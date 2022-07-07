### lab 3：PGTBL

[TOC]



------

#### 1.打印页表

##### 题目翻译

>   在你开始编码之前，请阅读xv6书中的第3章，以及相关文件。
>
>   kern/memlayout.h，它捕捉了内存的布局。
>   kern/vm.c，它包含大多数虚拟内存（VM）代码。
>   kernel/kalloc.c，包含分配和释放物理内存的代码。****

如果你通过了pte printout测试的make grade，你将获得这项作业的全部学分。

现在当你启动xv6时，它应该打印出这样的输出，描述第一个进程在刚刚完成exec()ing init时的页面表。

```c
page table 0x0000000087f6e000
..0: pte 0x0000000021fda801 pa 0x0000000087f6a000
.. ..0: pte 0x0000000021fda401 pa 0x0000000087f69000
.. .. ..0: pte 0x0000000021fdac1f pa 0x0000000087f6b000
.. .. ..1: pte 0x0000000021fda00f pa 0x0000000087f68000
.. .. ..2: pte 0x0000000021fd9c1f pa 0x0000000087f67000
..255: pte 0x0000000021fdb401 pa 0x0000000087f6d000
.. ..511: pte 0x0000000021fdb001 pa 0x0000000087f6c000
.. .. ..510: pte 0x0000000021fdd807 pa 0x0000000087f76000
.. .. ..511: pte 0x0000000020001c0b pa 0x0000000080007000
```

第一行显示vmprint的参数。之后，每个PTE都有一行，包括指向树中更深的页表页的PTE。每一行PTE都有一个缩进的数字"..."，表示它在树中的深度。每个PTE行显示PTE在其页表页中的索引，PTE位，以及从PTE中提取的物理地址。**不要打印那些无效的PTEs**。在上面的例子中，顶级页表页有条目0和255的映射。下一级的条目0只有索引0的映射，而下一级的索引0有条目0、1和2的映射。

你的代码可能发出的物理地址与上面显示的不同。条目数和虚拟地址应该是一样的。

一些提示：

>   -   [x] 将vmprint()放在kernel/vm.c中。
>
>   -   [x] 使用文件kernel/riscv.h末尾的宏。
>
>   -   [x] 函数freewalk可能是鼓舞人心的。
>
>   -   [x] 在kernel/defs.h中定义vmprint的原型，以便你可以从exec.c中调用它。
>
>       这里要注意在exec中的第一个进程需要打印，具体代码段为：
>
>       ```c
>       140   if(p->pid==1){
>       141       vmprint(p->pagetable);
>       142   }
>       ```
>
>       
>
>   -   [x] 在你的printf调用中使用%p来打印出完整的64位十六进制PTE和地址，如例子中所示。
>

Q&A：用文中的图3-4来解释vmprint的输出。第0页包含什么？第2页中有什么？当以用户模式运行时，该进程能否读/写第1页所映射的内存？

##### 题目解答

主要是对vmprint（）递归函数的编写，基于freewalk（）的原型。我这里利用局部静态变量的特性进行树结构的表达，具体代码如下：

```c
291 void vmprint(pagetable_t pagetable){
292     static int count=0;
293     if(count==0){
294         printf("page table %p\n",(uint64) pagetable);
295     }
296     char str[3][10] ={"..", ".. ..", ".. .. .."};
297     count++;
298     
299     for(int i=0; i<512;i++){
300         pte_t pte = pagetable[i];
301         if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
302             uint64 child = PTE2PA(pte);
303             printf("%s%d: pte %p pa %p\n", str[count-1], i, (uint64)pte, child);
304             vmprint((pagetable_t)child);
305         }else if(pte & PTE_V){
306             uint64 child = PTE2PA(pte);
307             printf("%s%d: pte %p pa %p\n", str[count-1], i, (uint64)pte, child);
308         }
309 
310     }
311     count = 1;//当一棵树（页表）递归完成后，count置1，进入下一棵树（页表）
312 }

```



#### 2.每个进程的内核页表

##### 题目翻译

Xv6的内核页表只有一个内核页表，该表在内核中执行时就使用。 内核页表直接映射到物理地址，因此内核虚拟地址x映射到物理地址x。 Xv6还为每个进程的用户地址空间提供了一个单独的页表，仅包含该进程的用户内存的映射，从虚拟地址零开始。 由于内核页表不包含这些映射，因此用户地址在内核中无效。 因此，当内核需要使用在系统调用中传递的用户指针（例如，传递给write（）的缓冲区指针）时，内核必须首先将指针转换为物理地址。 本节和下一节的目标是允许内核直接取消引用用户指针。

您的第一项工作是修改内核，以使每个进程在内核中执行时都使用其自己的内核页表副本。 修改struct proc以维护每个进程的内核页表，并修改调度程序以在切换进程时切换内核页表。 对于此步骤，每个进程的内核页表应与现有的全局内核页表相同。 如果usertests正确运行，则可以通过实验室的这一部分。

阅读本作业开始时提到的书籍章节和代码； 了解虚拟内存代码的工作方式会更容易正确地修改它。 页面表设置中的错误可能由于缺少映射而导致陷阱，可能导致加载和存储影响物理内存的意外页面，并可能导致从错误的内存页面执行指令。

一些提示：

-   在进程的内核页表的struct proc中添加一个字段。
-   为新进程生成内核页表的合理方法是实现kvminit的修改版本，该版本将创建新的页表，而不是修改kernel_pagetable。 您将要从allocproc调用此函数。
-   确保每个进程的内核页表都具有该进程的内核堆栈的映射。 在未修改的xv6中，所有内核堆栈都在procinit中设置。 您将需要将部分或全部此功能移至allocproc。
-   修改scheduler（）以将进程的内核页表加载到内核的satp寄存器中（有关灵感，请参阅kvminithart）。 不要忘记在调用w_satp（）之后调用sfence_vma（）。
-   当没有进程在运行时，scheduler（）应该使用kernel_pagetable。
-   在freeproc中释放进程的内核页表。
-   您将需要一种释放页面表而不释放叶子物理内存页面的方法。
-   vmprint可以很方便地调试页表。
-   可以修改xv6功能或添加新功能。 您可能至少需要在kernel / vm.c和kernel / proc.c中执行此操作。 （但是，请勿修改kernel / vmcopyin.c，kernel / stats.c，user / usertests.c和user / stats.c。）缺少页表映射可能会导致内核遇到页错误。 它将显示包含sepc = 0x00000000XXXXXXXX的错误。 您可以通过在kernel / kernel.asm中搜索XXXXXXXX来找出故障发生的位置。
-   注意: 在切换进程时，现更新satp为p->kpagetable 这样当前进程的根页表地址就是p->kpagetable 在进程执行结束之后，将satp切换为全局kernel_pagetable

##### 题目解答

任务清单：

-   [x] 修改内核页表的proc 部分，为其添加一个字段内核页表指针kpagetable

    ```c
     // kernel/proc.h
     ...
     85 // Per-process state
     86 struct proc {
     87   struct spinlock lock;
     ...
    102   pagetable_t kpagetable;      // Kernel page table
     ...
    108 };                                                                                        
    ```

    

-   [x] 修改kvminit ->实现proc_kpgtl（）：为创建一个新进程就创建一个内核页表

    仿照全局内核页表的初始化，得到进程内核页表，这里注释掉的CLINT后面解释

    ```c
     // kernel/vm.c
     ...
     23 pagetable_t proc_kpgtl(){
     24   pagetable_t pgtl = (pagetable_t) kalloc();
     25   memset(pgtl, 0, PGSIZE);
     26   uvmmap(pgtl,UART0, UART0, PGSIZE, PTE_R | PTE_W);
     27   uvmmap(pgtl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
     28 //  uvmmap(pgtl, CLINT, CLINT, 0x10000, PTE_R | PTE_W);
     29   uvmmap(pgtl, PLIC, PLIC, 0x400000, PTE_R | PTE_W);
     30   uvmmap(pgtl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
     31   uvmmap(pgtl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
     32   uvmmap(pgtl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
     33   return pgtl;
     34 } 
    
    
    
    ```

    最近看完教学视频之后，看到了老师的另外一种解法，他利用共享的方法，将全局的内核页表的level0条目拷贝到每个进程的内核页表的level0中，因为这些是为了保证和全局页表一致，并且这些物理内存是固定的。为此需要考虑的level0的条目只有一个也就是内核堆栈页Kstack，这里需要对其进行声明和释放即可。

-   [x] 进程内核页表的映射，在allocproc中具体实现

    ```c
    //kernel/proc.c
    static struct proc*
    allocproc(void)
    {
        ...
    111   // An empty user page table.
    112   p->pagetable = proc_pagetable(p);
    113   if(p->pagetable == 0){
    114     freeproc(p);
    115     release(&p->lock);
    116     return 0;
    117   }
    118     p->kpagetable = proc_kpgtl();
    119     //add kernel stack mappings to kpagetable
    120     char *pa = kalloc();
    121     if(pa == 0)
    122         panic("kalloc");
    123     uint64 va = KSTACK((int) (p-proc));//映射到进程的任意位置
    124     uvmmap(p->kpagetable, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    125     p->kstack = va;//记录进程内核栈的虚拟地址位置
    126 
    127   // Set up new context to start executing at forkret,
    128   // which returns to user space.
    129   memset(&p->context, 0, sizeof(p->context));
    130   p->context.ra = (uint64)forkret;
    131   p->context.sp = p->kstack + PGSIZE;
    132 
    133   return p;
    134 }
    
    ```

    

-   [x] 修改调度程序scheduler

    ```c
    // kernel/proc.c
    // void scheduler(void)
    ...
    513     for(p = proc; p < &proc[NPROC]; p++) {
    514       acquire(&p->lock);
    515       if(p->state == RUNNABLE) {
    516         // Switch to chosen process.  It is the process's job
    517         // to release its lock and then reacquire it
    518         // before jumping back to us.
    519         p->state = RUNNING;
    520         c->proc = p;
    521         w_satp(MAKE_SATP(p->kpagetable));
    522         sfence_vma();
    523         swtch(&c->context, &p->context); 
    524 //没有用户进程的时候，使用全局内核页表
    525         kvminithart();
    526         // Process is done running for now.
    527         // It should have changed its p->state before coming back.
    528         c->proc = 0;
    529 
    530         found = 1;
    531       }     
    532       release(&p->lock);
    533     }         
    ...
    ```

    

-   [x] 在freeproc中释放进程的内核页表  

    在kill一个进程时，需要对其用户页表和内核页表进行释放处理，这里有几点需要注意

    首先是顺序问题，要先释放进程的内核栈，在释放对应的进程内核页表，这里要注意参数的设置，看清楚函数原型，到底需要**字节数还是页面数**

    进程内核栈的释放，这里需要删除对应的物理内存，故最后一个参数设置为1

    进程内核页表的释放，这里只需要取消映射关系即可达到效果，这里需要注意改进freewalk（）为kfreewalk（），主要是避免遇到“freewalk： leaf”，其实这里可以直接对三级页表调用kfreewalk（），这里不再展示

```c
139 static void
140 freeproc(struct proc *p)
141 {
142   if(p->trapframe)
143     kfree((void*)p->trapframe);
144   p->trapframe = 0;
145   if(p->kstack){
146      // pte_t *pte = walk(p->kpagetable, p->kstack, 0);
147      // kfree((void*)PTE2PA(*pte));第二种方法需要显示释放内存
148      uvmunmap(p->kpagetable, p->kstack, 1, 1);
149   }
150   if(p->pagetable)
151     proc_freepagetable(p->pagetable, p->sz);                                                   
152   if(p->kpagetable){
153       proc_freekpagetable(p->kpagetable);
154   }
155 
156   p->kstack = 0;
157   p->pagetable = 0;
158   p->kpagetable = 0;
159   p->sz = 0;
160   p->pid = 0;
161   p->parent = 0;
162   p->name[0] = 0;
163   p->chan = 0;
164   p->killed = 0;
165   p->xstate = 0;
166   p->state = UNUSED;
167 }

```

```c
313 void kfreewalk(pagetable_t pagetable){
314   // there are 2^9 = 512 PTEs in a page table.
315   for(int i = 0; i < 512; i++){
316     pte_t pte = pagetable[i];
317     if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
318       // this PTE points to a lower-level page table.
319       uint64 child = PTE2PA(pte);
320       kfreewalk((pagetable_t)child);
321       pagetable[i] = 0;
322     } else if(pte & PTE_V){
323       pagetable[i] = 0;
324     }
325   }
326   kfree((void*)pagetable);
327 
328 }

```

```c
211 void
212 proc_freekpagetable(pagetable_t pgtl)
213 {
214 //  kfreewalk(pagetable);第二种方法
215   uvmunmap(pgtl, UART0, 1, 0);
216   uvmunmap(pgtl, VIRTIO0, 1, 0);
217 //  uvmunmap(pgtl, CLINT, 0x10000/PGSIZE, 0);
218   uvmunmap(pgtl, PLIC, 0x400000/PGSIZE, 0);
219   uvmunmap(pgtl, KERNBASE, (PHYSTOP-KERNBASE)/PGSIZE, 0);//合并代码块与数据块
220   uvmunmap(pgtl, TRAMPOLINE, 1, 0);
221   uvmfree(pgtl, 0);
222 }

```

```c
351 void
352 uvmfree(pagetable_t pagetable, uint64 sz)                                          
353 { 
354   if(sz > 0)
355     uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
356   kfreewalk(pagetable);
357 } 
```

在调试过程中，总是会遇到一个panic：kvmpa，这一点很奇怪，于是查看kvmpa，确实会有这个panic，触发条件为：（页表中）该虚拟地址不存在。为此，查找调用kvmpa的函数，得到virtio_disk文件中使用了这个函数。

kvmpa() 函数用于将内核虚拟地址转换为物理地址, 其中调用 walk() 函数时使用了全局的内核页表. 此时需要换位当前进程的内核页表. 修改方法有两种, 一种是直接修改 kvmpa() 内部, 将 walk() 的第一个参数改为 myproc()->kpagetable; 第二种则是将 kvmpa() 的参数增加一个 pagetable_t, 在 kernel/virtio_disk.c 的 virtio_disk_rw() 调用时传入 myproc()->kpagetable. 两种方法效果是一样的, 此处选择了第二种, 主要考虑到未来扩展时可能会使用全局内核页表的情况, 则第一种不能适用.

```c
//
205   // buf0 is on a kernel stack, which is not direct mapped,
206   // thus the call to kvmpa().
207   disk.desc[idx[0]].addr = (uint64) kvmpa(myproc()->kpagetable, (uint64) &buf0);

```

 


#### 3.简化copyin/copyinstr

##### 题目翻译

内核的copyin函数读取由用户指针指向的内存。它通过将它们转换为物理地址来完成这一工作，内核可以直接对其进行解引用。它通过在软件中walk进程页表来完成这种转换。在这部分实验中，你的工作是向每个进程的内核页表（在上一节中创建）**添加用户映射**，使copyin（以及相关的字符串函数copyinstr）能够直接解引用用户指针。

>   将kernel/vm.c中copyin的主体替换为对copyin_new的调用（定义在kernel/vmcopyin.c中）；对copyinstr和copyinstr_new做同样的处理。在每个进程的内核页表中添加用户地址的映射，以便copyin_new和copyinstr_new能够工作。如果usertests正确运行，并且make grade都通过，你就通过了这项作业。

这个方案依赖于用户的虚拟地址范围不与内核用于其自身指令和数据的虚拟地址范围重叠。Xv6对用户地址空间使用从零开始的虚拟地址，幸运的是内核的内存从更高的地址开始。然而，这种方案确实限制了用户进程的最大尺寸，使其小于内核的最低虚拟地址。内核启动后，这个地址是xv6中的0xC000000，即PLIC寄存器的地址；参见kernel/vm.c中的kvminit()，kernel/memlayout.h，以及文中的图3-4。你需要修改xv6以防止用户进程的规模超过PLIC地址。

一些提示：

-   [x] 首先用copyin_new的调用代替copyin()，并使其工作，然后再转到copyinstr。
-   [x] 在内核改变进程的用户映射的每个点上，以同样的方式改变进程的内核页表。这些点包括fork(), exec(), 和sbrk().
-   [x] 不要忘记在userinit中把第一个进程的用户页表包括在它的内核页表中。
-   [x] 在一个进程的内核页表中，用户地址的PTE需要什么权限？(一个设置了PTE_U的页不能在内核模式下被访问)。
-   [x] 不要忘记上面提到的PLIC限制。

Linux使用了一种类似于你所实现的技术。直到几年前，许多内核在用户和内核空间都使用相同的每进程页表，并对用户和内核地址进行映射，以避免在用户和内核空间之间切换时必须切换页表。然而，这种设置允许诸如Meltdown和Spectre这样的侧通道攻击。

>   思考：解释为什么第三个测试srcva + len < srcva在copyin_new()中是必要的：给出srcva和len的值，前两个测试失败（即不会导致返回-1），但第三个测试为真（导致返回1）。

题目大意：内核的copyin函数读取用户指针指向的内存。它先将它们翻译为物理地址（内核可以直接用）。通过代码walk进程页表实现翻译。 在此实验中，你的工作是给每个进程的内核页表添加用户映射，使得copyin可以直接使用用户指针。

##### 题目解答

首先要知道题目意思，刚开始我就自己写了一个copyin_new，原来已经给你写好了，你要做的就是将它替换为copyin，copyinstr也是类似处理

```c
 // kernel/vmcopyin.c:已经实现了对应的函数版本，直接使用即可
...
 26 // Copy from user to kernel.
 27 // Copy len bytes to dst from virtual address srcva in a given page table.
 28 // Return 0 on success, -1 on error.
 29 int
 30 copyin_new(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
 31 {
 32   struct proc *p = myproc();
 33 
 34   if (srcva >= p->sz || srcva+len >= p->sz || srcva+len < srcva)
 35     return -1;
 36   memmove((void *) dst, (void *)srcva, len);
 37   stats.ncopyin++;   // XXX lock
 38   return 0;
 39 }
...

```

```c
//kernel/vm.c
...
463 int
464 copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
465 {
466     if(copyin_new(pagetable, dst, srcva, len) == 0)
467         return 0;
468     return -1;
469 }
470 
471 // Copy a null-terminated string from user to kernel.
472 // Copy bytes to dst from virtual address srcva in a given page table,
473 // until a '\0', or max.
474 // Return 0 on success, -1 on error.
475 int
476 copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
477 {
478     if(copyinstr_new(pagetable, dst, srcva, max) == 0)
479         return 0;
480     return -1; 
481 }            
```

其次，到了最难的部分，当遇到以下几个函数：fork，exec，sbrk，应该如何修改进程的内核页表，这里不能照搬用户页表的方式。先看看在fork里，是怎么处理的。

```c
296 // Create a new process, copying the parent.
297 // Sets up child kernel stack to return as if from fork() system call.
298 int
299 fork(void)                                                                            
300 {
301   int i, pid;
302   struct proc *np;
303   struct proc *p = myproc();
304 
305   // Allocate process.
306   if((np = allocproc()) == 0){
307     return -1;
308   }
309 
310   // Copy user memory from parent to child.
311   if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
312     freeproc(np);
313     release(&np->lock);
314     return -1;
315   }
    //这里不能直接拷贝父进程的内核页表，因为父子进程都是读时共享，写时复制，共享内核页表的物理端，只有需要修改时，才独立分配一片内存，进行独立的写，不影响另一端的数据
    //这里还需要注意的是，父子进程的用户态页表的也不一样，需要使用本进程的用户页表来进行映射，在进行添加用户态映射时，只需要将用户页表端的物理地址映射到内核页表即可。
316   if(kvmcopy(np->pagetable, np->kpagetable, 0, p->sz)<0){
317       freeproc(np);
318       release(&np->lock);
319       return -1;
320   }

```

这里当时写的时候有一个误区，为什么不能用父进程的页表进行拷贝的原因是，如果父进程被杀死，那么对应的页表就会失效，为此应该使用本身的页表进行映射。

```c
365 int
366 kvmcopy(pagetable_t old, pagetable_t new, uint64 begin, uint64 end)
367 {
368   pte_t *pte;
369   uint64 pa, i;
370   uint flags;
371   begin = PGROUNDUP(begin);
    //这里begin的含义是原来的用户页表字节大小（kb）或者理解为起始点复制位置（每一次复制，按照一页来复制），end是进行更改后的用户页表字节大小（kb）或者理解为复制的结束位置。
372   for(i = begin; i < end; i += PGSIZE){
373     if((pte = walk(old, i, 0)) == 0)
374       panic("uvmcopy: pte should exist");
375     if((*pte & PTE_V) == 0)
376       panic("uvmcopy: page not present");
377     pa = PTE2PA(*pte);
378     flags = PTE_FLAGS(*pte);
379     flags = flags & (~PTE_U);
380 // 要注意用户标志的消除，题目中有提到
381     if(mappages(new, i, PGSIZE, (uint64)pa, flags) != 0){
382       goto err;
383     }
384   }
385   return 0;
386 
387  err:
388   uvmunmap(new, 0, i / PGSIZE, 1);
389   return -1;
390 }              
```

接下来是对exec中进程内核页表的修改，需要注意的几点是，在何处插入内核页表修改代码

，如何修改内核页表。要想解决这两个问题，首先要明确的是exec函数的意义：用一个新的进程取代当前的进程，这就涉及到用户页表的替换（代码段以及数据段）。

在这里面的顺序问题很重要，在手册里提醒道“ 在准备新的内存映像的过程中，如果 `exec` 检测到一个错误，比如一个无效的程序段， 它就会跳转到标签 `bad`，释放新的映像，并返回-1。`exec` 必须延迟释放旧映像，直到它确定`exec`系统调用会成功：如果旧映像消失了，系统调用就不能返回-1。`exec`中唯一的错误情况发生在创建映像的过程中。一旦镜像完成，`exec`就可以提交到新的页表（`kernel/exec.c:113`）并释放旧的页表 ”。

为此，需要在原来的用户页表被释放后，再进行当前的内核页表的释放，然后再将新的用户页表映射到当前的内核页表（被释放后的）。

```c
// kernel/exec.c
...
125   // Commit to the user image.
126   oldpagetable = p->pagetable;
127   p->pagetable = pagetable;
128   p->sz = sz;
129 
130 
131   p->trapframe->epc = elf.entry;  // initial program counter = main
132   p->trapframe->sp = sp; // initial stack pointer
133   proc_freepagetable(oldpagetable, oldsz);
134 
135   uvmunmap(p->kpagetable, 0, PGROUNDUP(oldsz)/PGSIZE, 0);
136   if(kvmcopy(p->pagetable, p->kpagetable, 0, p->sz) == -1)
137       goto bad;
138
...
```

接着是sbrk中对页表内容的修改，通过查找，发现这个是一个用户级函数，需要进行系统调用，最后调用的内核函数是growproc，这里需要对growproc进行修改，观察函数内部的功能，发现该函数主要是对用户空间的内存进行扩大或者缩小，这里需要注意的是，是否可以任意扩大用户空间的内存大小，显然是不能的，由于内核页表要引用用户页表的虚拟地址内容，那么用户页表的地址范围不能超过内核页表地址的最小值，为防止重叠，在文中只需要小于PLIC即可，凡是大于该地址的修改项都是错误的，为此修改如下：

```c
//kernel/proc.c
...
270 int
271 growproc(int n)
272 {
273   uint sz;
274   struct proc *p = myproc();
275 
276   sz = p->sz;
277   if(n > 0){
278     if(sz + n > PLIC)
279         return -1;
280     if((sz = uvmalloc(p->pagetable, sz, sz + n)) == 0) {
281       return -1;
282     }
    //这里需要特别注意参数的设置后两位参数，这里主要是起始复制点，和末尾点
283     if(kvmcopy(p->pagetable, p->kpagetable, p->sz, sz) == -1)
284         return -1;
285     
286   } else if(n < 0){
287     sz = uvmdealloc(p->pagetable, sz, sz + n);
288     if(PGROUNDUP(sz)<PGROUNDUP(p->sz)){
289         uvmunmap(p->kpagetable,PGROUNDUP(sz), (PGROUNDUP(p->sz)-PGROUNDUP(sz))/PGSIZE,     0);
290     }
291   }
292   p->sz = sz;                                                                         
293   return 0;
294 }
...

```

最后一个要求是对userinit中第一个进程的用户页表进行映射

```c
239 void
240 userinit(void)
241 {
242   struct proc *p;
243 
244   p = allocproc();
245   initproc = p;
246   
247   // allocate one user page and copy init's instructions
248   // and data into it.
249   uvminit(p->pagetable, initcode, sizeof(initcode));
250   p->sz = PGSIZE;
251   //add user-PGTL into per-proc-kPGTL
252   kvmcopy(p->pagetable, p->kpagetable,0,p->sz);

```

从上面，几个修改看出，只要不是扩展内存，都是从0开始进行映射，即直接映射，要注意的就是扩展内存里面的大小限制。

还有就是内核页表与用户页表的差别很重要

#### 4.实验测试与评分

##### make grade

```
/*
可能时间比较漫长，耐心等待即可，如果遇到TimeOUT的Error，需要到评分标准gradelib中修改时长限制，这是因为电脑太垃圾了，没有别的原因哈（我这里的虚拟机的配置较差）
这里需要主要在主目录（实验目录上）编写两个文件：
time.txt->内容为完成实验的小时数目（整数）
answers-pgtbl.txt->你对实验的看法与分析，注意要大于10个字符，才会符合评分条件。
*/
== Test pte printout == pte printout: OK (2s) 
== Test answers-pgtbl.txt == answers-pgtbl.txt: OK 
== Test count copyin == count copyin: OK (1.8s) 
== Test usertests == (184.1s) 
== Test   usertests: copyin == 
  usertests: copyin: OK 
== Test   usertests: copyinstr1 == 
  usertests: copyinstr1: OK 
== Test   usertests: copyinstr2 == 
  usertests: copyinstr2: OK 
== Test   usertests: copyinstr3 == 
  usertests: copyinstr3: OK 
== Test   usertests: sbrkmuch == 
  usertests: sbrkmuch: OK 
== Test   usertests: all tests == 
  usertests: all tests: OK 
== Test time == 
time: OK 
Score: 66/66
```

