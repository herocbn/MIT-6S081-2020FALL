## lab 4：Traps

------

[TOC]

### 前期准备

本实验探讨了如何使用陷阱实现系统调用。你将首先做一个堆栈的热身练习，然后你将实现一个用户级陷阱处理的例子。

在你开始编码之前，请阅读xv6书的第4章，以及相关的源文件。

-    kernel/trampoline.S：从用户空间到内核空间再到用户空间的转换过程中所涉及的汇编。
-    kernel/trap. c: 处理所有中断的代码

系统调用
再次回忆 lab2 的系统调用过程，在这里根据课程内容做一下补充：

首先，当用户调用系统调用的函数时，在进入函数前，会执行 user/usys.S 中相应的汇编指令，指令首先将系统调用的函数码放到a7寄存器内，然后执行 ecall 指令进入内核态。

ecall 指令是 cpu 指令，该指令只做三件事情。

-   **首先将cpu的状态由用户态（user mode）切换为内核态（supervisor mode）；**
-   **然后将程序计数器的值保存在了SEPC寄存器；**
-   **最后跳转到STVEC寄存器指向的指令。**

ecall 指令并没有将 page table 切换为内核页表，也没有切换栈指针，需要进一步执行一些指令才能成功转为内核态。

这里需要对 trampoline 进行一下说明，STVEC寄存器中存储的是 trampoline page 的起始位置。进入内核前，首先需要在该位置处执行一些初始化的操作。例如，切换页表、切换栈指针等操作。需要注意的是，由于用户页表和内核页表都有 trampoline 的索引，且索引的位置是一样的，因此，即使在此刻切换了页表，cpu 也可以正常地找到这个地址，继续在这个位置执行指令。

接下来，cpu 从 trampoline page 处开始进行取指执行。接下来需要保存所有寄存器的值，以便在系统调用后恢复调用前的状态。为此，xv6将进程的所有寄存器的值放到了进程的 trapframe 结构中。

在 kernel/trap.c 中，需要 检查触发trap的原因，以确定相应的处理方式。产生中断的原因有很多，比如系统调用、运算时除以0、使用了一个未被映射的虚拟地址、或者是设备中断等等。这里是因为系统调用，所以以系统调用的方式进行处理。

接下来开始在内核态执行系统调用函数，在 kernel/syscall.c 中取出 a7 寄存器中的函数码，根据该函数码，调用 kernel/sysproc.c 中对应的系统调用函数。

最后，在系统调用函数执行完成后，将保存在 trapframe 中的 SEPC 寄存器的值取出来，从该地址存储的指令处开始执行（保存的值为ecall指令处的PC值加上4，即为 ecall 指令的下一条指令）。随后执行 ret 恢复进入内核态之前的状态，转为用户态。

以系统调用write为例子，

![write() 函数系统调用过程](https://img-blog.csdnimg.cn/fa8870f7027c4d9183ba0b64936cf710.png#pic_center)

首先是 ecall 指令进入内核态；然后在 trampoline 处执行 uservec，完成初始化操作；随后执行 usertrap，判断中断类型，这里是系统调用中断；转到 syscall 中，根据 a7 寄存器中的值，调用对应的系统调用函数，即 sys_write 函数；最后使用 ret 指令进行返回，同时恢复寄存器的值，恢复到用户进行系统调用前的状态。


### RISC-V assembly

##### 题目翻译

了解一点RISC-V的汇编是很重要的，你在6.004中接触过它。在你的xv6 repo中，有一个文件user/call.c。make fs.img编译了它，也产生了user/call.asm中程序的可读汇编版本。

阅读call.asm中函数g、f和main的代码。RISC-V的指导手册在参考页上。这里有一些你应该回答的问题（将答案存储在文件answer-traps.txt中）。

1.  哪些寄存器包含函数的参数？例如，在main对printf的调用中，哪个寄存器包含13？->通过查阅汇编代码即可

2.  在main的汇编代码中，对函数f的调用在哪里？对g的调用在哪里？(提示：编译器可以内联函数。)没有调用函数f和g，使用了内联函数

3.  函数printf的地址是什么？通过查看代码和汇编即可

4.  在主程序中调用printf的jalr之后，寄存器ra中的值是多少？

    这里需要注意jalr的指令含义：

    jalr  1544（ra） ->  t = pc+4 , pc = sext(1544)+x(ra),pc =  pc&~1 ,x(ra) = t

    和普通的jalr不同点在于这里没有目标寄存器rd

    jalr  rd  offset(rs) -> t = pc+4 =, pc = sext(offset)+x(rs),pc = pc&~1 ,x(rd) = t

    这里ra里保存的是下一次指令的地址pc+4

5.  运行以下代码。

    ```c
    unsigned int i = 0x00646c72。
    printf("H%x Wo%s", 57616, &i)。
    ```

    输出的结果是什么？

    通过输入上述代码，可得输出：HE110 World

    [这是一个ASCII表]: http://web.cs.mun.ca/~michael/c/ascii-table.html

    ，将字节映射到字符。这个输出取决于RISC-V是小编码的这一事实。如果RISC-V是大面值的，你会把i设置为什么，以产生相同的输出？你是否需要把57616改成一个不同的值？

    i= 0x726c6400，不需要改变57616，因为二进制数据和字符串读入的格式不同。

    [这里有一个关于小位和大位的描述]: http://www.webopedia.com/TERM/b/big_endian.html

    ，

    [还有一个更异想天开的描述]: http://www.networksorcery.com/enp/ien/ien137.txt

    。
    
    在下面的代码中，'y='后面要打印什么？(注意：答案不是一个具体的值。)为什么会出现这种情况？
    
    ```c
    printf("x=%d y=%d", 3)。
    ```



这里需要主要的几点：

SRLI是逻辑右移（零被移到上方位）；SRAI是算术右移（原来的符号位被复制到空出的上方位）。

##### 题目答案

```c
  1  r(a2) = 13;r(a1) = 12; a0 stores the RA           2  inline optimization
  3  0x628
  4  ra = pc+4 = 0x38
  5  HE110 World  change i -> 0x726c6400 only
  6  a1 store  first arg; a2 store second arg
  7 
```





### BackTrace（回溯）

##### 题目翻译

对于调试来说，有一个回溯通常是很有用的：在错误发生的点之上的堆栈中的函数调用的列表。

在kernel/printf.c中实现一个backtrace()函数，在sys_sleep中插入一个对该函数的调用，然后运行 ，调用sys_sleep。你的输出应该是这样的：bttest

```c
backtrace:
0x0000000080002cda
0x0000000080002bb6
0x0000000080002898
```

在bttest之后退出qemu。在你的终端：地址可能略有不同，但如果你运行`addr2line -e kernel/kernel`（或`riscv64-unknown-elf-addr2line -e kernel/kernel`）并剪切和粘贴上述地址如下。你应该看到像这样的东西。

```
 $ addr2line -e kernel/kernel
    0x0000000080002de2
    0x0000000080002f4a
    0x0000000080002bfc
    Ctrl-D
  
    kernel/sysproc.c:74
    kernel/syscall.c:224
    kernel/trap.c:85
```

编译器在每个堆栈帧中放入一个帧指针，该指针持有调用者的帧指针地址。你的回溯应该使用这些帧指针在堆栈上行走，并在每个堆栈帧中打印出保存的返回地址。

一些小提示：

-   在kernel/defs.h中添加backtrace的原型，这样你就可以在sys_sleep中调用backtrace。
-   GCC编译器将当前执行的函数的帧指针存储在寄存器s0中。在kernel/riscv.h中加入以下函数：并在backtrace中调用这个函数来读取当前的帧指针。这个函数使用in-line assembly来读取s0。

```c
static inline uint64
r_fp()
{
  uint64 x;
  asm volatile("mv %0, s0" : "=r" (x) );
  return x;
}
```

-   这些讲义上有一张堆栈框架布局的图片。请注意，返回地址住在堆栈帧指针的固定偏移量（-8），保存的帧指针住在帧指针的固定偏移量（-16）。
-   Xv6为xv6内核中的每个堆栈分配一个页面，地址是PAGE对齐的。你可以通过使用PGROUNDDOWN(fp)和PGROUNDUP(fp)来计算堆栈页的顶部和底部地址（见kernel/riscv.h.这些数字有助于backtrace终止其循环。

一旦你的反向追踪成功，从kernel/printf.c的panic中调用它，这样你就能在内核恐慌时看到它的反向追踪。

##### 题目答案

这里是实现一个简单的回溯，从sys_sleep出发，进行打印上个函数的地址，终止条件是一个页的大小。

这里主要展示在kernel/printf.c中实现的backtrace代码：

```c++
130 void backtrace(void){
131     uint64 fp;
132     printf("backtrace:\n");
133     fp = r_fp();
134     while((PGROUNDUP(fp)-PGROUNDDOWN(fp)) == PGSIZE){
135         printf("%p\n", *(uint64*)(fp-8));
136         fp = * (uint64*)(fp-16);
137     }
138 }
```

这里要留意的是，指针的使用，首先需要明确指针的类型，在进行对其进行解引用。

### Alarm（警报）

##### 题目翻译

在这个练习中，你将为xv6添加一个功能，在**进程使用CPU时间时定期发出警告**。这对于想要限制它们占用多少CPU时间的计算型进程，或者对于想要计算但又想采取一些定期行动的进程，可能是很有用的。更广泛地说，你将实现一个原始形式的用户级中断/故障处理程序；例如，你可以使用类似的东西来处理应用程序中的页面故障。如果你的解决方案通过了**alarmtest和usertests**，那么它就是正确的。

你应该添加一个新的`sigalarm(interval, handler)`系统调用。如果一个应用程序调用`sigalarm(n, fn)`，那么在程序每消耗n个 "ticks "的CPU时间后，内核应该使应用程序函数fn被调用。当fn返回时，应用程序应该恢复到它停止的地方。在xv6中，tick是一个相当随意的时间单位，由硬件定时器产生中断的频率决定。如果一个应用程序调用`sigalarm(0, 0)`，内核应该停止产生周期性的报警调用。

你会在你的xv6资源库中发现一个文件user/alarmtest.c。把它添加到Makefile中。在你加入sigalarm和sigreturn系统调用之前，它不会正确编译（见下文）。

alarmtest在test0中调用`sigalarm(2, periodic)`，要求内核每2个ticks强制调用`periodic()`，然后旋转一段时间。你可以在user/alarmtest.asm中看到alarmtest的汇编代码，这对于调试来说可能很方便。当alarmtest产生这样的输出时，你的解决方案是正确的，而且usertests也能正常运行。

```
$ alarmtest
test0 start
........alarm!
test0 passed
test1 start
...alarm!
..alarm!
...alarm!
..alarm!
...alarm!
..alarm!
...alarm!
..alarm!
...alarm!
..alarm!
test1 passed
test2 start
................alarm!
test2 passed
$ usertests
...
ALL TESTS PASSED
$
```



当你完成后，你的解决方案将只有几行代码，但要做好它可能很棘手。我们将用原始仓库中的 alarmtest.c 版本测试你的代码。你可以修改 alarmtest.c 来帮助你调试，但要确保原始 alarmtest 表示所有测试都通过。

##### test0: invoke handler

通过修改内核跳转到用户空间的报警处理程序来开始，这将导致test0打印 "alarm!"。先不要担心 "alarm!"输出后会发生什么；如果你的程序在打印 "alarm!"后崩溃了，现在也没有问题。

这里有一些提示：

-   你需要修改Makefile，使alarmtest.c被编译为xv6用户程序。
-   要放在user/user.h中的正确声明是。

​    int sigalarm(int ticks, void (*handler)())。

​    int sigreturn(void)。

-   更新user/usys.pl（它生成user/usys.S）、kernel/syscall.h和kernel/syscall.c，以允许alarmtest调用sigalarm和sigreturn系统调用。
-   现在，你的sys_sigreturn应该只返回0。
-   你的sys_sigalarm()应该在proc结构（在kernel/proc.h中）的新字段中存储警报间隔和指向处理函数的指针。
-   你需要跟踪从最后一次调用（或直到下一次调用）进程的警报处理程序以来，已经过了多少个时间点；你也需要在proc结构中的一个新字段。你可以在proc.c的allocproc()中初始化proc字段。
-   每一次嘀嗒声，硬件时钟都会强制中断，这在kernel/trap.c的usertrap()中处理。
-   你只想在有定时器中断的情况下操纵进程的报警滴答，你想这样做

​    if(which_dev == 2) ...

-   只有当进程有一个定时器未完成时才调用报警函数。**注意，用户的报警函数的地址可能是0**（例如，在user/alarmtest.asm中， periodic在地址0）。
-   你需要修改usertrap()，以便当一个进程的报警间隔期过后，用户进程执行处理函数。当RISC-V上的一个陷阱返回到用户空间时，什么决定了用户空间代码恢复执行的指令地址？
-   如果你告诉qemu只使用一个CPU，那么用gdb查看陷阱会更容易，你可以通过运行

​    make CPUS=1 qemu-gdb

-   如果alarmtest打印出 "alarm!"，你就成功了。

##### test1/test2(): resume interrupted code

有可能是alarmtest在打印出 "alarm!"后在test0或test1中崩溃，或者alarmtest（最终）打印出 "test1 failed"，或者alarmtest退出时没有打印 "test1 passed"。为了解决这个问题，你必须确保当报警处理程序完成后，控制权返回到用户程序最初被定时器中断的指令中。你必须确保寄存器的内容恢复到中断时的值，这样用户程序在报警后可以不受干扰地继续运行。最后，你应该在每次中断后 "重新设置 "报警计数器，使处理程序被定期调用。

作为一个起点，我们已经为你做了一个设计决定：用户报警处理程序完成后需要调用sigreturn系统调用。看一下alarmtest.c中的periodic，以了解一个例子。这意味着你可以向usertrap和sys_sigreturn添加代码，使用户进程在处理完报警后正常恢复。

一些提示：

-   你的解决方案将要求你**保存和恢复寄存器**你需要保存和恢复哪些寄存器来正确恢复被中断的代码？(提示：会有很多)。
-   当定时器关闭时，让usertrap在struct proc中**保存足够的状态**，以便sigreturn能够正确地返回到被中断的用户代码。
-   防止对处理程序的重复调用，如果一个处理程序还没有返回，内核不应该再调用它。test2测试这一点。
-   一旦你通过了test0、test1和test2，运行usertests以确保你没有破坏内核的任何其他部分。

##### 关于一些RISC-V指令和调用的说明

AUIPC->用于建立与pc有关的地址，使用U型格式。AUIPC从U型格式形成一个32位的偏移量，在最低的12位上填入0，将这个偏移量加到AUIPC指令的地址PC上，然后将结果放入寄存器rd。

ADDI->将符号扩展后的12位立即添加到寄存器rs1。算术溢出被忽略，结果是简单的低XLEN位的结果。ADDI  rd, rs1, 0是用来实现MV rd, rs1汇编器伪指令的。

![image-20220504160530872](C:\Users\17386\Desktop\image-20220504160530872.png)

在这里需要注意的是保存与恢复寄存器。

##### 题目答案

对于test0，比较简单，主要是书写sysalarm，以及修改trap.c。但是要注意的一点是这里的定时器中断采用的是输出写信号，以此产生定时器中断“2”，所以才导致上述的定时功能。

当然，需要向proc添加新元素，以此来设置警报程序，这里要注意的是初始化元素与清除元素。

主要代码如下：

添加新字段

```c
87 struct proc {
...
 98   int ticks;
 99   int past_ticks;
100   uint64 handler;
...

```

初始化新字段

```c
 kernel/proc.c
 allocproc func->
 ...
133   p->ticks = 0;
134   p->handler = 0;
135   p->past_ticks=0;                               136   return p;
```

清除新字段

```c
kernel/proc.c
freeproc func ->
...
162   p->handler = 0;
163   p->ticks = 0;
164   p->past_ticks = 0;
...

```

从用户函数到内核函数的过程，

```c
106 sys_sigalarm(void){
107     int ticks;
108     uint64 handler;
109     if(argint(0, &ticks)<0||argaddr(1, &handler)<0|| ticks<0)
110     return -1;
111     struct proc*p; 
112     p = myproc();
113     p->ticks = ticks;
114     p->past_ticks = 0;
115     p->handler = handler;
116     return 0;
117 }

```

警报返回函数，test0这里简单返回0即可。不再赘述。

主要是处理陷阱函数，当遇到定时器中断时，应该进行计数。当达到目标时，启动用户级中断处理函数。

```
 80   if(which_dev == 2)                                                
 81       if(p->ticks){
 82           if(p->ticks==p->past_ticks){
 85               p->past_ticks = 0;
 86               p->trapframe->epc = p->handler;
 87           }
 88           p->past_ticks++;
 89       }

```

在这样之后，test0已经测试成功。

针对test1和test2 主要是两个问题，保存和恢复寄存器以及只能处理一个用户级中断处理函数，直到它结束并返回。

首先对于第一个问题，要保存进入 handler之前的寄存器，以便返回后，能够恢复原来的状态，为此要在进入handler之前，需要对进入的寄存器进行保存，这里有很多方法保存寄存器，由于寄存器被保存在trapframe里面，问题转换为如何保存一个trapframe，这里在进程的结构体里面声明了一个新的字段initframe，为了保存上一个trapframe。由于initframe也需要具体的物理空间，故需要在初始化的时候，需要为其分配空间，用于存放trapframe。接着是，从initframe恢复trapframe，这里和保存相反，不再赘述。

其次是，如何只保证在程序运行时，仅有一个中断处理函数在运行，为此这里要注意一个点就是，直到其结束并返回后才能进行调用下一个中断处理函数，由于past_ticks表示经过了多少ticks，在一个中断处理函数执行当中，由于past_ticks = ticks， 这里只要保证在中断处理函数执行时，past_ticks没有被置0即可，因为past_ticks一直在做累加， 为此不会再有机会等于ticks，故只需要在本次中断处理函数返回的时候，执行past_ticks=0即可，达到效果。

需要改变的代码如下：

```c
 kernel/proc.h
 ...
106   struct trapframe *trapframe; // data page for trampoline.S        
 ...
111   struct trapframe *initframe;
 ... 

```



```
kernel/proc.c
...
110   // Allocate a trapframe page.
111   if((p->trapframe = (struct trapframe *)kalloc()) == 0){
112     release(&p->lock);
113     return 0;
114   }
115   if((p->initframe = (struct trapframe *)kalloc()) == 0){
116     release(&p->lock);
117     return 0;
118   }

```



```c
80   if(which_dev == 2)
 81       if(p->ticks){
 82           if(p->ticks==p->past_ticks){
 83               // save the register               
 85               *p->initframe = *p->trapframe;
 86               p->trapframe->epc = p->handler;
 87           }
 88           p->past_ticks++;
 89       }

```

```c
98 uint64
 99 sys_sigreturn(void){
100     struct proc*p = myproc();
101     *p->trapframe = *p->initframe;
102     p->past_ticks = 0;
103     return 0;
104 }
```

### 测试结果

在主目录下面编写answes-traps.txt 和 time.txt 两个文件，分别记录第一个问题的答案和完成实验所需要的时间（单位：小时）。

在主目录下执行 make grade

![image-20220505155647001](C:\Users\17386\Desktop\1)

