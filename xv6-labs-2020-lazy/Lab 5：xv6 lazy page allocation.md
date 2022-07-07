## Lab 5：Lazy 

[TOC]



### 前期准备

O/S可以利用页表硬件玩的很多花样之一是懒惰地分配用户空间的堆内存。Xv6应用程序使用sbrk()系统调用向内核索取堆内存。在我们给你的内核中，sbrk()分配物理内存并将其映射到进程的虚拟地址空间。内核为一个大的请求分配和映射内存可能需要很长的时间。例如，考虑到一千兆字节由262,144个4096字节的页面组成；这是一个巨大的分配数量，即使每个分配都很便宜。此外，一些程序分配的内存比它们实际使用的要多（例如，为了实现稀疏数组），或者在使用之前提前分配内存。为了让sbrk()在这些情况下更快地完成，复杂的内核会懒散地分配用户内存。也就是说，sbrk()并不分配物理内存，而只是记住哪些用户地址被分配，并在用户页表中把这些地址标记为无效。当进程第一次尝试使用任何指定的懒惰分配的内存页时，CPU会产生一个页面故障，内核通过分配物理内存、清零和映射来处理。你将在本实验中为xv6添加这个懒惰分配功能。

>   Before you start coding, read Chapter 4 (in particular 4.6) of the [xv6 book](https://pdos.csail.mit.edu/6.828/2020/xv6/book-riscv-rev1.pdf), and related files you are likely to modify:
>
>   -   `kernel/trap.c`
>   -   `kernel/vm.c`
>   -   `kernel/sysproc.c`

### Eliminate allocation from sbrk() ([easy](https://pdos.csail.mit.edu/6.828/2020/labs/guidance.html))

##### 题目翻译

你的第一个任务是从sbrk(n)系统调用实现中删除页面分配，也就是sysproc.c中的函数sys_sbrk()。sbrk(n)系统调用将进程的内存大小增加n字节，然后返回新分配区域的开始（即旧大小）。你的新sbrk(n)应该只是将进程的大小（myproc()->sz）增加n，并返回旧的大小。它不应该分配内存 -- 所以你应该删除对growproc()的调用（但你仍然需要增加进程的大小！）。

试着猜测一下这个修改的结果是什么：什么会被破坏？

进行这个修改，启动xv6，在shell中输入echo hi。你应该看到像这样的东西。

```
init: starting sh
$ echo hi
usertrap(): unexpected scause 0x000000000000000f pid=3
            sepc=0x0000000000001258 stval=0x0000000000004008
va=0x0000000000004000 pte=0x0000000000000000
panic: uvmunmap: not mapped
```

"usertrap(): ... "消息来自于Trap.c中的用户陷阱处理程序；它捕获了一个它不知道如何处理的异常。请确保你理解为什么会发生这种页面故障。stval=0x0...04008 "表明导致页面故障的虚拟地址是0x4008。

##### 题目答案

这一题比较简单，只需要删除kernel/sysproc.c中sys_sbrk()里面的growproc()函数即可，然后其他稍作改变。

```c
uint64
sys_sbrk(void){
	int addr;
	int n;
	struct proc *p = myproc();
    if(argint(0, &n) < 0)
    return -1;
    addr = p->sz;
    p->sz+=n;
    return addr;
}
```

### Lazy allocation ([moderate](https://pdos.csail.mit.edu/6.828/2020/labs/guidance.html))

##### 题目翻译

修改 trap.c 中的代码，以响应来自用户空间的页面故障，在故障地址处映射一个新分配的物理内存页面，然后返回用户空间，让进程继续执行。你应该在产生信息"usertrap()：..."的printf调用之前添加你的代码。修改你需要的其他xv6内核代码，以使echo hi工作。

一些提示：

-   你可以通过查看usertrap()中的r_scause()是否为13或15来检查一个故障是否是页故障。
-   r_stval()返回RISC-V的stval寄存器，它包含了引起页面故障的虚拟地址。
-   从vm.c中的uvmalloc()偷取代码，这就是sbrk()调用的代码（通过growproc()）。你需要调用 kalloc() 和 mappages()。
-   使用PGROUNDDOWN(va)将出错的虚拟地址四舍五入到一个页面边界。
-   uvmunmap()会发生恐慌；修改它，使其在某些页面没有被映射时不发生恐慌。
-   如果内核崩溃了，在kernel/kernel.asm中查找sepc
-   使用你在pgtbl实验室的vmprint**函数来打印页表的内容**。
-   如果你看到错误 "不完整的proc类型"，包括 "spinlock.h "然后 "proc.h"。

如果一切顺利，你的懒惰分配代码应该导致echo hi工作。你应该至少得到一个页面故障（从而得到懒惰分配），也许是两个。

##### 题目答案

这里和第三问放在一起进行解答，见第三问解答

### Lazytests and Usertests ([moderate](https://pdos.csail.mit.edu/6.828/2020/labs/guidance.html))

##### 题目翻译

我们为你提供了lazytests，一个xv6的用户程序，测试一些可能给你的懒惰内存分配器带来压力的特殊情况。修改你的内核代码，使所有的lazytests和usertests都能通过。

一些提示：

-   处理负的sbrk()参数。
-   如果一个进程在一个比sbrk()分配的虚拟内存地址更高的地方发生页面故障，则杀死它。
-   正确处理fork()中父子间的内存拷贝。
-   处理这样的情况：进程从 sbrk() 传递一个有效的地址给系统调用，如 read 或 write，但该地址的内存还没有被分配。
-   正确处理内存不足的情况：如果kalloc()在页面故障处理程序中失败，则杀死当前进程。
-   处理用户堆栈下面的无效页面的故障。

如果你的内核通过了lazytests和usertests，你的解决方案是可以接受的。

```c
$  lazytests
lazytests starting
running test lazy alloc
test lazy alloc: OK
running test lazy unmap...
usertrap(): ...
test lazy unmap: OK
running test out of memory
usertrap(): ...
test out of memory: OK
ALL TESTS PASSED
$ usertests
...
ALL TESTS PASSED
$
```

##### 题目答案

首先对于输入的增加或者缩减的内存数目进行处理，在sysproc.c中进行处理，这里有几个需要注意的，对于n正负的处理，这里正数的话，直接进行懒分配即可，对于负数，可以观察growproc（）对于负数的处理，这里模仿一下

```c
 42 sys_sbrk(void)
 43 {                                                           
 44   int addr;
 45   int n;
 46   struct proc *p = myproc();
 47   if(argint(0, &n) < 0)
 48     return -1;
 49   addr = p->sz;
 50   if(n>=0){
 51       p->sz+=n;
 52   }
 53   else if(n<0){
 54       p->sz = uvmdealloc(p->pagetable, addr,addr+n);
 55   }
 56   else{
 57       return -1;
 58   }
 59   return addr;
 60 }

```

接着，是对页面故障进行处理，在kernel/trap.c中，对usertrap函数进行修改，这里有很多细节地方需要注意，一个一个来看。首先是对于检测页面故障的错误号码，这个可以参考调用系统调用的手法，模仿着写，但是要注意许多地方要去掉，第一个要关闭设备中断，防止陷入另一个中断而返回不过来，其次是要注意在trapframe里面保存的程序指针epc，这里要和系统调用区别开来，因为对于缺页这类异常，需要再次执行一次，为此这里的程序计数器不变；接着是处理访问无效页和大于分配页面的地址，只需要简单的杀死进程即可。最后，对于普通情况，实现分配一页内存的函数allocpg，这里参考growproc里面的uvmalloc的函数。

```
 ...
 // 处理页面故障的section
 53   if(r_scause() == 13||r_scause() ==15){
 54       if(p->killed)
 55           exit(-1);
 56      intr_off();
 57     //  p->trapframe->epc += 4;
 58 // deal with page exception
 59       uint64 va = r_stval();
 60       va = PGROUNDDOWN(va); 
 61       if(va>PGROUNDDOWN(p->sz)){
 62           p->killed = 1;
 63           exit(-1);
 64       }
 65       if(va<p->trapframe->sp){
 66           p->killed = 1;
 67           exit(-1);
 68       }
 69       allocpg(va);
 70       usertrapret();
	  }

```

```
//需要在kernel/def.h 中声明该函数 ，此处是定义。
//声明不再赘述
108 void allocpg(uint64 va){
109         char *mem;
110         struct proc *p = myproc();
111         mem = kalloc();
112         if(mem == 0){
113             p->killed = 1;
114             //printf("No memmory!");
115             exit(-1);
116         }
117         memset(mem, 0, PGSIZE);
118         if(mappages(p->pagetable, va, PGSIZE, (uint64)mem, PTE_W|PTE_X|PTE_R|PTE_U)!=0){
119           kfree(mem);
120          // printf("Mapping Error!");
121           exit(-1);
122         }
123 }  
```

然后是对于fork函数生成的一对父子进程，这里要注意拷贝过程中，对于无效页面，直接跳过即可，但是这里要注意不要漏掉对于pte=0（不存在）的情况，后面解释为啥会出现这种情况。

```c
317 int
318 uvmcopy(pagetable_t old, pagetable_t new, uint64 sz)
319 {
320   pte_t *pte;                                                       
321   uint64 pa, i;
322   uint flags;
323   char *mem;
324 
325   for(i = 0; i < sz; i += PGSIZE){
326     if((pte = walk(old, i, 0)) == 0)
327       //panic("uvmcopy: pte should exist");
328       continue;
329     if((*pte & PTE_V) == 0){
330       //panic("uvmcopy: page not present");
331       continue;
332     }
333     pa = PTE2PA(*pte);
334     flags = PTE_FLAGS(*pte);
335     if((mem = kalloc()) == 0)
336       goto err;
337     memmove(mem, (char*)pa, PGSIZE);
338     if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
339       kfree(mem);
340       goto err;
341     }
342   }

```



接着是对于uvmunmap函数的处理，也有上述两种情况，进行修改即可。

```c
179 void
180 uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_fre    e)
181 {
182   uint64 a;
183   pte_t *pte;
184 
185   if((va % PGSIZE) != 0)
186     panic("uvmunmap: not aligned");
187 
188   for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
189     if((pte = walk(pagetable, a, 0)) == 0)
190       //panic("uvmunmap: walk");
191       continue;
192     if((*pte & PTE_V) == 0){
193      // printf("uvmunmap: not mapped\n");
194       continue; 
195     }
196     if(PTE_FLAGS(*pte) == PTE_V)
197       panic("uvmunmap: not a leaf");
198     if(do_free){
199       uint64 pa = PTE2PA(*pte);
200       kfree((void*)pa);                                             
201     }
202     *pte = 0;
203   }

```



最后是对于read和write系统调用的处理，这两个系统调用函数比较复杂，看的我有点蒙，但还是有眉目，必然是文件到文件之间的通信，为此必然会进行用户端读取与写入，为此会调用copyin和copyout，这两个函数都会调用walkaddr对输入的虚拟地址进行对应的物理地址查找，返回va对应的物理地址，但这里要注意，要使得两个函数正常工作，就需要有存在的物理地址进行读取和存入，pte是通过walk函数得到的最后一级虚拟地址，可能无效，不存在，或者用户端不可读取，这里对于用户端不可读不用进行修改，这是隔离的前提，只需要针对pte无效与不存在进行修改，解释一下为什么会出现不存在的情况，由于可能在进行分配页面的时候只分配了第一级或者第二级页面，为此最后的页面地址就是0（不存在），为此需要分配相应的物理地址进行映射，保证函数的正常工作，这里调用allocpg函数进行分配一页物理空间，当然这里还需要注意需要映射的虚拟地址的合理性，因为必须在堆栈之上同时在目前用户的最大地址之下，才是合法的，否则返回0.

这里可能会有这样的疑问为啥，这里可以直接进行页面故障的处理呢，我的看法是系统通过write已经进入内核，如果在这里不进行修改，内核会陷入中断，这里为了简化，直接就可以在内核里面进行处理。

```c
 96 uint64
 97 walkaddr(pagetable_t pagetable, uint64 va)
 98 {
 99   pte_t *pte;
100   uint64 pa;
101   struct proc *p = myproc();
102   if(va >= MAXVA)
103     return 0;
104 
105   pte = walk(pagetable, va, 0);
106   if(pte == 0||(*pte &PTE_V) == 0){
107     if(va>=p->trapframe->sp && va<p->sz){
108         allocpg(va);
109     }
110     else{
111         return 0;
112     }
113   }
114   if((*pte & PTE_U) == 0)
115     return 0;                                                       
116   pa = PTE2PA(*pte);
117   return pa;
118 }

```



### 测试结果

在主目录下面测试结果，打开终端输入make grade，即可测试自己的成绩

```
$ make qemu-gdb
(3.5s) 
== Test   lazy: map == 
  lazy: map: OK 
== Test   lazy: unmap == 
  lazy: unmap: OK 
== Test usertests == 
$ make qemu-gdb
(69.8s) 
== Test   usertests: pgbug == 
  usertests: pgbug: OK 
== Test   usertests: sbrkbugs == 
  usertests: sbrkbugs: OK 
== Test   usertests: argptest == 
  usertests: argptest: OK 
== Test   usertests: sbrkmuch == 
  usertests: sbrkmuch: OK 
== Test   usertests: sbrkfail == 
  usertests: sbrkfail: OK 
== Test   usertests: sbrkarg == 
  usertests: sbrkarg: OK 
== Test   usertests: stacktest == 
  usertests: stacktest: OK 
== Test   usertests: execout == 
  usertests: execout: OK 
== Test   usertests: copyin == 
  usertests: copyin: OK 
== Test   usertests: copyout == 
  usertests: copyout: OK 
== Test   usertests: copyinstr1 == 
  usertests: copyinstr1: OK 
== Test   usertests: copyinstr2 == 
  usertests: copyinstr2: OK 
== Test   usertests: copyinstr3 == 
  usertests: copyinstr3: OK 
== Test   usertests: rwsbrk == 
  usertests: rwsbrk: OK 
== Test   usertests: truncate1 == 
  usertests: truncate1: OK 
== Test   usertests: truncate2 == 
  usertests: truncate2: OK 
== Test   usertests: truncate3 == 
  usertests: truncate3: OK 
== Test   usertests: reparent2 == 
  usertests: reparent2: OK 
== Test   usertests: badarg == 
  usertests: badarg: OK 
== Test   usertests: reparent == 
  usertests: reparent: OK 
== Test   usertests: twochildren == 
  usertests: twochildren: OK 
== Test   usertests: forkfork == 
  usertests: forkfork: OK 
== Test   usertests: forkforkfork == 
  usertests: forkforkfork: OK 
== Test   usertests: createdelete == 
  usertests: createdelete: OK 
== Test   usertests: linkunlink == 
  usertests: linkunlink: OK 
== Test   usertests: linktest == 
  usertests: linktest: OK 
== Test   usertests: unlinkread == 
  usertests: unlinkread: OK 
== Test   usertests: concreate == 
  usertests: concreate: OK 
== Test   usertests: subdir == 
  usertests: subdir: OK 
== Test   usertests: fourfiles == 
  usertests: fourfiles: OK 
== Test   usertests: sharedfd == 
  usertests: sharedfd: OK 
== Test   usertests: exectest == 
  usertests: exectest: OK 
== Test   usertests: bigargtest == 
  usertests: bigargtest: OK 
== Test   usertests: bigwrite == 
  usertests: bigwrite: OK 
== Test   usertests: bsstest == 
  usertests: bsstest: OK 
== Test   usertests: sbrkbasic == 
  usertests: sbrkbasic: OK 
== Test   usertests: kernmem == 
  usertests: kernmem: OK 
== Test   usertests: validatetest == 
  usertests: validatetest: OK 
== Test   usertests: opentest == 
  usertests: opentest: OK 
== Test   usertests: writetest == 
  usertests: writetest: OK 
== Test   usertests: writebig == 
  usertests: writebig: OK 
== Test   usertests: createtest == 
  usertests: createtest: OK 
== Test   usertests: openiput == 
  usertests: openiput: OK 
== Test   usertests: exitiput == 
  usertests: exitiput: OK 
== Test   usertests: iput == 
  usertests: iput: OK 
== Test   usertests: mem == 
  usertests: mem: OK 
== Test   usertests: pipe1 == 
  usertests: pipe1: OK 
== Test   usertests: preempt == 
  usertests: preempt: OK 
== Test   usertests: exitwait == 
  usertests: exitwait: OK 
== Test   usertests: rmdot == 
  usertests: rmdot: OK 
== Test   usertests: fourteen == 
  usertests: fourteen: OK 
== Test   usertests: bigfile == 
  usertests: bigfile: OK 
== Test   usertests: dirfile == 
  usertests: dirfile: OK 
== Test   usertests: iref == 
  usertests: iref: OK 
== Test   usertests: forktest == 
  usertests: forktest: OK 
== Test time == 
time: OK 
Score: 119/119

```

