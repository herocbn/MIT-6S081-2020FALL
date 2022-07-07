# Lab 6：COW Fork

[TOC]

虚拟内存提供了一种间接性：内核可以通过标记PTEs无效或只读来拦截内存引用，从而导致页面故障，并且可以通过修改PTEs来改变地址的含义。在计算机系统中，有一种说法，任何系统问题都可以通过一定程度的间接性来解决。懒惰分配实验室提供了一个例子。这个实验室探讨了另一个例子：写时复制 fork。

### 背景知识

xv6中的fork()系统调用将父进程的所有用户空间内存复制到子进程中。如果父进程很大，复制可能需要很长的时间。更糟的是，这项工作往往是浪费的；例如，在子进程中，fork()之后的exec()将导致子进程丢弃复制的内存，可能根本没有使用其中的大部分。另一方面，如果父代和子代都使用一个页面，并且其中一个或两个都写了它，那么就真的需要复制了。

写时复制（COW）fork()的目标是推迟为子代分配和复制物理内存页，直到实际需要时再进行复制。
COW fork()只为子程序创建一个pagetable，其中用户内存的PTE指向父程序的物理页。COW fork()将父代和子代中所有的用户PTE标记为不可写。当任何一个进程试图写入这些COW页面时，CPU将强制发生页面故障。内核页故障处理程序检测到这种情况，为发生故障的进程分配一个物理内存页，将原来的页复制到新的页中，并修改发生故障的进程中的相关PTE以**引用新的页**，这次的PTE被标记为可写。当页面故障处理程序返回时，用户进程将能够写入它的页面副本。

COW fork()使得释放实现用户内存的物理页变得有些棘手。一个给定的物理页可能被多个进程的页表所引用，只有当最后一个引用消失时才应该被释放。

### Implement copy-on write([hard](https://pdos.csail.mit.edu/6.828/2020/labs/guidance.html))

##### 题目翻译

你的任务是在xv6内核中实现写时复制分叉。如果你修改后的内核能成功执行 cowtest 和 usertests 程序，你就完成了。

为了帮助你测试你的实现，我们提供了一个名为cowtest的xv6程序（源代码在user/cowtest.c中）。cowtest运行各种测试，但即使是第一个测试在未修改的xv6上也会失败。因此，最初，你会看到

```
$ cowtest
simple: fork() failed
$ 
```

"简单 "测试分配了超过一半的可用物理内存，然后fork()s。分叉失败是因为没有足够的空闲物理内存来给子代分配父代内存的完整拷贝。
当你完成后，你的内核应该通过 cowtest 和 usertests 的所有测试。就是说：

```
$ cowtest
simple: ok
simple: ok
three: zombie!
ok
three: zombie!
ok
three: zombie!
ok
file: ok
ALL COW TESTS PASSED
$ usertests
...
ALL TESTS PASSED
$
```

这里有一个合理的攻击计划：

1.  **修改uvmcopy()，将父代的物理页映射到子代，而不是分配新页。在子代和父代的PTE中清除PTE_W。**
2.  修改usertrap()以识别页面故障。当一个COW页发生页面故障时，用kalloc()分配一个新的页面，将旧的页面复制到新的页面，并将新的页面安装到PTE中，并设置PTE_W。
3.  确保每一个物理页在最后一个PTE引用消失时被释放 -- 但不是之前。做到这一点的一个好方法是，为每个物理页保留一个 "引用计数"，即引用该页的用户页表的数量。当**kalloc()分配一个页面时**，将该物理页面的引用计数设为1。当fork导致一个子进程共享该页时，增加该页的引用计数，当任何进程将该页从其页表中删除时，减少该页的计数。把这些计数放在一个固定大小的整数数组中是可以的。你必须为如何为数组建立索引以及如何选择其大小制定一个方案。例如，你可以用页面的物理地址除以4096来给数组做索引，并给数组的元素数等于kalloc.c中kinit()放置在free list上的任何页面的最高物理地址。
4.  修改copyout()，当它遇到一个COW页时，使用与页面故障相同的方案。

一些提示：

-   懒惰的页面分配实验可能已经让你熟悉了许多与写时复制有关的xv6内核代码。然而，你不应该把这个实验建立在你的懒惰分配方案上；相反，请按照上面的指示从xv6的一个新副本开始。
-   **对于每个PTE来说，有一种方法来记录它是否是一个COW映射可能是有用的。你可以使用RISC-V PTE中的RSW（为软件保留）位来做这件事**。
-   usertests探索了cowtest没有测试的场景，所以别忘了检查所有的测试是否都通过了。
-   一些有用的宏和页表标志的定义在kernel/riscv.h的最后。
-   如果发生了COW页故障，并且没有空闲的内存，这个进程应该被杀死。

##### 题目答案

在做这个实验之前，强烈建议完成上一个实验，因为他们相似度很大，有较好的锻炼效果，在这里，我记录一下自己犯错较多的地方。

在上文中，其实已经把步骤告诉我们了，我们要做的是实现他们，当然这才是难点，也是学会学习的方面。话不多说，开写。

<img src="C:\Users\17386\AppData\Roaming\Typora\typora-user-images\image-20220511205819550.png" alt="image-20220511205819550" style="zoom:80%;" />

首先，对于fork函数，由父进程得到子进程，这里的子进程为了实现cow，就需要修改uvmcopy（），使得子进程的页表映射到与父进程同一个物理地址下面，同时设置两个进程页表的标志符包括PTE_W和PTE_RSW，这里只需要RSW的一个位即可进行分辨选取第八位即可。这里需要增加对该物理页引用的次数，为此需要添加这个函数inc_counts(uint64 pa).在后面会进行该函数的具体设计。

```c
350 int
351 uvmcopy(pagetable_t old, pagetable_t new, uint64 sz)
352 {
353   pte_t *pte;
354   uint64 pa, i;
355   uint flags;                                                                         357   for(i = 0; i < sz; i += PGSIZE){
358     if((pte = walk(old, i, 0)) == 0)
359       panic("uvmcopy: pte should exist");
360     if((*pte & PTE_V) == 0)
361       panic("uvmcopy: page not present");
362     pa = PTE2PA(*pte);// physical addr page
363     *pte = ((*pte)&(~PTE_W))|PTE_RSW;
364     flags = PTE_FLAGS(*pte);//这里一定要注意PTE_FLAGS的使用，后面避免出错
365 
366     if(mappages(new, i, PGSIZE, (uint64)pa, flags) != 0){
367       goto err;
368     }
369 
370     inc_counts(pa);
371   }
372   return 0;
373 
374  err:
375   uvmunmap(new, 0, i / PGSIZE, 1);
376   return -1;
```



其次是，添加页面故障处理函数cowfork（），当遇到写入的页面故障时，就需要进行相应的处理，这里将具体的处理细节封装在一个函数里面，主要是考虑到后面还需要复用，copyout函数再对一个虚拟地址进行对应的物理地址查找调用了walkaddr，如果这里不对walkaddr进行修改，在进行cowtest的第三个测试的时候，就会导致写入父进程的物理地址产生异常error，为此这里需要修改，使得需要进行申请物理页时，合理申请，参考walkaddr和uvmcopy部分代码即可写出。

```
94 uint64
 95 cowfork(pagetable_t pagetable, uint64 va){
 96     pte_t *pte;
 97     uint64 pa;
 98     char *mem;
 99     if(va >= MAXVA)
100         return 0;
101     pte = walk(pagetable, va, 0);
102     if(pte == 0)
103         return 0;
104     if((*pte&PTE_V) == 0)
105         return 0;
106     if((*pte&PTE_U) == 0)
107         return 0;
108     if((*pte&PTE_W) == 0){
109         if((*pte&PTE_RSW) == 0)
110             return 0;
111         else{
112             if((mem = kalloc()) == 0)
113                 exit(-1);
114             pa = PTE2PA(*pte);
115             //set the limits bits
116             uint flags = (PTE_FLAGS(*pte)|(PTE_W))&(~PTE_RSW);
117             //here needs to store pa in mem;
118             memmove(mem, (char*)pa, PGSIZE);
119             va = PGROUNDDOWN(va);
120             uvmunmap(pagetable, va, 1, 1);//在kfree中实现清除物理页，这里只是记录一下
121             if(mappages(pagetable, va, PGSIZE, (uint64)mem, flags) != 0){
122                 kfree(mem);
123                 return 0;
124             }
125             return (uint64)mem;
126         }
127     }
128     else{
129         pa = PTE2PA(*pte);
130         return pa;
131     }
132 }

```

将该函数添加到def.h中即可，接下来是对uvmcopy中物理页引用计数函数的实现，根据提示，需要对调用kalloc（）后使得引用计数为1，为此需要在kalloc()里面进行类似于初始化的操作，每次申请的一片物理页需要进行初始化1，但要注意，这里的计数过程中需要加锁，可以借鉴空闲物理页链表的自旋锁的实现方法。其次在kfree中需要判断是否需要对物理页进行清除，这里需要判断引用计数是否为零，最后在刚开始的时候，调用kinit（）的时候里面获得所有的空闲物理页的过程中，调用了kfree（）为此，需要在之前调用一次引用计数加法的过程，否则会出现-1（无符号数对应无穷大）。

```c
35 void
 36 freerange(void *pa_start, void *pa_end)
 37 {
 38   char *p;
 39   p = (char*)PGROUNDUP((uint64)pa_start);
 40   for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE){
 41       inc_counts((uint64)p);
 42       kfree(p);
 43   }
 44 }

```

```c
 50 void
 51 kfree(void *pa)
 52 {
 53   struct run *r;
 54 
 55   if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
 56     panic("kfree");
 57 
 58   // Fill with junk to catch dangling refs.
 59   if(dec_counts((uint64)pa)==0){
 60     memset(pa, 1, PGSIZE);
 61     r = (struct run*)pa;
 62 
 63     acquire(&kmem.lock);
 64     r->next = kmem.freelist;
 65     kmem.freelist = r;
 66     release(&kmem.lock);
 67   }
 68 }

```

```c
 73 void *                                                                                                                                              
 74 kalloc(void)
 75 {
 76   struct run *r;
 77 
 78   acquire(&kmem.lock);
 79   r = kmem.freelist;
 80   if(r)
 81     kmem.freelist = r->next;
 82   release(&kmem.lock);
 83 
 84   inc_counts((uint64)r);// when apply for a page increase the count
 85   if(r)
 86     memset((char*)r, 5, PGSIZE); // fill with junk
 87   return (void*)r;
 88 }

```

这里把具体的细节封装在一个内核函数cow.c里面，方便进行调用，但需要同时在Makefile里面进行链接cow.o，在ojbs里面添加类似的语句`$K/cow.o \`。

```c
 15 struct{    
 16     struct spinlock lock;
 17     uint64 count;
 18 } cow_counts[PHYSTOP>>12];//这里count（全局变量）自动初始化为0，其次是数组的数目对应的是最大物理地址/PGSIZE
```

```c
 void
 22 inc_counts(uint64 pa){
 23     pa = PGROUNDDOWN(pa);
 24     if(pa>=PHYSTOP){
 25         panic("inc_counts");
 26     }
 27     uint64 index = pa/PGSIZE;
 28     acquire(&cow_counts[index].lock);
 29     cow_counts[index].count++;
 30     release(&cow_counts[index].lock);
 31 }

```

```c
 32 uint64
 33 dec_counts(uint64 pa){
 34     pa = PGROUNDDOWN(pa);
 35     if(pa>=PHYSTOP){
 36         panic("dec_counts");
 37     }
 38     uint64 index = pa/PGSIZE;
 39     acquire(&cow_counts[index].lock);
 40     cow_counts[index].count--;
 41     uint64 count = cow_counts[index].count;
 42     release(&cow_counts[index].lock);
 43     return count;                                                                                                                                  
 44 }

```

### 测试结果

在主目录文件下创建time.txt文件，输入完成实验的时间（小时），

然后进行测试在主目录的终端下 $ make grade

 
