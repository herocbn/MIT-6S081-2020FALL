## Lab 10：mmap

##### 实验准备与概述

这次的作业主要考察虚拟内存和文件系统的相关知识，以及两者的综合使用，需要我们在前面实验的基础上进行更进一步的操作，这里面综合了前面诸如lazy lab，cow lab 等实验的操作方法，可以来说是一个综合性题目，当然这里的实现方法有多种，而且各个实现层次的难度亦有不同，下面是比较简单的一种。

这道题主要是要求我们实现两个系统调用：mmap与munmap，我们之前或许了解过这两个函数，主要是进行内存映射，将一个内存区域映射到当前用户进程的区域，而后者则是取消映射。

做了这么多实验，我也发现了做题的思路，要针对实验的测试案例来进行改进，每次实现一个测试案例，然后根据错误提示进行修改即可，直到通过所有的测试案例，屡试不爽哈哈哈哈。

过程可能很漫长，但调试过程也是涉及许多思考的过程，帮助我们成长，对操作系统有更加深入地了解。（我发现我特喜欢打印输出语句，这真的很有帮助哈哈哈）

##### 实验思路

1.  首先实现两者的系统调用，返回错误信号（参考syscall的手法，但这里的实现，我放在了sysfile。）

2.  深入理解mmap为每个进程映射了哪些东西，也就是VMAs，声明vma，并将VMA数组加入到每个进程中（由于一个进程可能会有多个映射，需要存储这里将最大的存储量设置为NOVMA），也就是说，每个进程会有NOVMA个VMAs，而每个VMA由需要映射的条件（不同数据类型）组成，所以这里将VMA声明为结构体类型，进行数据存储。

    ```c
    #define MINADDR (MAXVA-18*PGSIZE)
    #define NOVMA       16 
    
    
    struct vma{
        uint64 va; 
        uint64 len;
        int    prot;
        int    flags;
        struct file* f;
        int   offset;
    };
    
    
    struct proc {
      struct spinlock lock;
    
      // p->lock must be held when using these:
      enum procstate state;        // Process state
      struct proc *parent;         // Parent process
      void *chan;                  // If non-zero, sleeping on chan
      int killed;                  // If non-zero, have been killed
      int xstate;                  // Exit status to be returned to parent's wait
      int pid;                     // Process ID
    
      // these are private to the process, so p->lock need not be held.
      uint64 kstack;               // Virtual address of kernel stack
      uint64 sz;                   // Size of process memory (bytes)
      pagetable_t pagetable;       // User page table
      struct trapframe *trapframe; // data page for trampoline.S
      struct context context;      // swtch() here to run process
      struct file *ofile[NOFILE];  // Open files
      struct inode *cwd;           // Current directory
      char name[16];               // Process name (debugging)
      struct vma vmas[NOVMA];
    };               
    ```

    

3.  实现mmap：这里是第一关，首先将获取外部的输入，然后判断外部输入是否合理，接着在当前进程中找到一个空槽VMA，然后将外部输入放入该空槽中，最后返回该空槽存储文件指针的地址，也就是VMA->va（补充说明：这里面涉及如何查找空槽以及如何分配存储文件内容的地址，具体实现如下）

    ```c
    uint64
    sys_mmap(void){
        struct file *f;
        uint64 addr;                                                                     
        uint64 len;
        int prot;
        int flags;
        int offset;
        struct vma *v = 0;
        if(argaddr(0,&addr)<0||argaddr(1,&len)<0||argint(2,&prot)<0||argint(3,&flags)<0||argfd(4,0,&f)<0||argint(5,&offset)<0){
            return -1;
        }
        if(len<0||offset<0||f==0){
            return -1;
        }
        if(flags == MAP_SHARED){
            if(!f->readable){
                return -1;
            }
            if(!f->writable){
                if(prot&PROT_WRITE){
                    return -1;
                }
            }
        }
         //find a slot vma in proc
        struct proc *p;
        p = myproc();
        int i;
        uint64 sz = 0;
        for(i = 0;i<NOVMA;i++){
            if(p->vmas[i].len == 0){
                //判断该地址是否存在文件内容
                v = &(p->vmas[i]);
                break;
            }
            sz+=p->vmas[i].len;
        }
        if(v==0)     
            return 0xffffffffffffffff;
        sz = PGROUNDUP(sz);
        //将文件内容映射到高地址（这里取16+2）
        addr = MINADDR+sz;
        if(addr+len>(MAXVA-2*PGSIZE)){
            panic("vma:no free areas!\n");
        }
        v->f = filedup(f);
        v->va = addr;
        v->len = len;
        v->prot = prot;
        v->flags = flags;
        v->offset = offset;
        return addr;
    }
    ```

4.  这样之后，运行mmaptest，会触发页面故障，因为只是把文件地址返回，但并没有内容和读写权限，所以会触发trap，这里需要处理来自vma 的页面故障，注意不一定是读故障就是VMA故障，所以这里在进行判断的时候需要附加条件，也就是页面地址必须位于最低文件地址之上（MINADDR），在 TRAOPFRAME之下，才会对其进行页面处理。接着是找到发生页面故障的vma，申请一页内存块将文件读入（这里需要注意文件读入时需要指定偏移量），然后将该内存块映射到该页面故障地址，添加适当的权限。

    ```c
     if(r_scause() == 13){
          uint64 va = r_stval();
          va = PGROUNDDOWN(va);
          if(va>=MINADDR&&va<TRAPFRAME){
              if (p->killed){
                  exit(-1);
              }
              intr_off();
              struct vma *v=0;
              for(int i=0;i<NOVMA;i++){
                  if(p->vmas[i].va<=va&&va<p->vmas[i].len+p->vmas[i].va){
                      v = &(p->vmas[i]);
                      break;
                  }
              }
              if(p==0){
                  panic("no such a trap-page in vmas!\n");
              }
              char *mem;
              mem = kalloc();
              if(mem == 0){
                  p->killed = 1;
                  exit(-1);
              }
              memset(mem,0,PGSIZE);
              
              struct file* fs = (v->f);
              uint off = (va-v->va+v->offset);
              ilock(fs->ip);
              readi(fs->ip, 0,(uint64)mem,(off),PGSIZE);
              iunlock(fs->ip);
    
              int pte_flag;
              if(v->flags == 0x2){
                  pte_flag = PTE_R|PTE_W;
              }
              else{
                  pte_flag = (v->prot>1)? (PTE_R|PTE_W):PTE_R;
              }
              pte_flag|=PTE_U;
              if(mappages(p->pagetable, va, PGSIZE, (uint64)mem, pte_flag)!=0){
                  kfree(mem);
                 // printf("Mapping Error!");
                  exit(-1);
              }
              usertrapret();
          }
      }
    
    ```

5.  再次之后运行mmaptest，会到达第一个munmap，当然也会终止下来，接下来实现munmap，这里的做法和mmap类似

    ```c
    uint64
    sys_munmap(void){
        uint64 addr, len;
        int i;
        uint64 sz;
        struct proc *p = myproc();
        if(argaddr(0, &addr)<0||argaddr(1, &len)<0){
            return -1;
        }
        addr = PGROUNDDOWN(addr);
        for(i=0;i<NOVMA;i++){
            if(p->vmas[i].va == addr){
                break;
            }
        }
        int j;
        //找到addr所在的vma，下面进行对长度为len的区间取消文件映射
        for(j=i;j<NOVMA;j++){
            sz = min(len, p->vmas[j].len);
            len-=sz;
    // need to write back?
            if(p->vmas[j].flags==1){
                filewrite(p->vmas[j].f,addr,sz);    
            }
            uvmunmap(p->pagetable, addr, sz/PGSIZE, 1);
            addr+=sz;
            p->vmas[j].len-=sz;
            p->vmas[j].offset+=sz;
            if(p->vmas[j].len == 0){
                fileclose(p->vmas[j].f);
            }
            if(len == 0){
                break;
            }
        }
        return 0;
    
    }              
    ```

6.  修改uvmunmap，避免对无效页面进行取消映射，这里直接跳过即可，和cow lab一样。

7.  修改exit使得进程结束后，将还在使用的vma进行释放

    ```c
    void
    exit(int status)
    {
      struct proc *p = myproc();
      uint64 len;
      if(p == initproc)
        panic("init exiting");
      for(int i=0;i<NOVMA;i++){
          if((len = p->vmas[i].len)!=0){
              if(p->vmas[i].flags == 1){ 
                  filewrite(p->vmas[i].f,p->vmas[i].va,len);
              }   
              uvmunmap(p->pagetable,p->vmas[i].va,len/PGSIZE,1);                  
              p->vmas[i].flags=0;
              p->vmas[i].len=0;
              p->vmas[i].prot = 0;
          }
      }
      // Close all open files.
      for(int fd = 0; fd < NOFILE; fd++){
        if(p->ofile[fd]){
          struct file *f = p->ofile[fd];
          fileclose(f);
          p->ofile[fd] = 0;
        }   
      }
    ```

8.  修改fork函数，使得fork_test能够运行，这里根据提示需要将父进程的vmas复制到vmas即可，然后增加文件引用次数，当然如果这里实现cow将会更酷，这里采用直接复制，以后来填坑。

    ```c
      for(int i=0;i<NOVMA;i++){
          if(p->vmas[i].len!=0){
          //如果该区域存在文件的话就进行复制
              np->vmas[i] = p->vmas[i];
              filedup(np->vmas[i].f);
          }
      }
      release(&np->lock);
      return pid;
    }
    
    ```

##### 测试结果

```
== Test running mmaptest == 
$ make qemu-gdb
(3.8s) 
== Test   mmaptest: mmap f == 
  mmaptest: mmap f: OK 
== Test   mmaptest: mmap private == 
  mmaptest: mmap private: OK 
== Test   mmaptest: mmap read-only == 
  mmaptest: mmap read-only: OK 
== Test   mmaptest: mmap read/write == 
  mmaptest: mmap read/write: OK 
== Test   mmaptest: mmap dirty == 
  mmaptest: mmap dirty: OK 
== Test   mmaptest: not-mapped unmap == 
  mmaptest: not-mapped unmap: OK 
== Test   mmaptest: two files == 
  mmaptest: two files: OK 
== Test   mmaptest: fork_test == 
  mmaptest: fork_test: OK 
== Test usertests == 
$ make qemu-gdb
usertests: OK (98.0s) 
== Test time == 
time: OK 
Score: 140/140
```

