# Lab: Multithreading

[TOC]



## 背景知识

本练习将让您熟悉多线程。您将在用户级线程包中实现线程之间的切换，使用多个线程来加速程序，并实现barrier函数。

>   在编写代码之前，您应该确保已经阅读了[xv6书中](https://pdos.csail.mit.edu/6.828/2020/xv6/book-riscv-rev1.pdf)的“第7章：调度”，并研究和阅读了相应的代码
>
>   如果之前学过多线程以及线程处理函数就更好了！

## Uthread：在线程之间切换（[中等](https://pdos.csail.mit.edu/6.828/2020/labs/guidance.html))

##### 题目翻译

在本练习中，您将为用户级线程系统设计上下文切换机制，然后实现它。为了帮助您入门，xv6 有两个文件 user/uthread.c 和 user/uthread_switch.S，以及 Makefile 中的一条规则，用于构建一个 uthread 程序。uthread.c包含大部分用户级线程包，以及三个简单测试线程的代码。线程包缺少一些用于创建线程和在线程之间切换的代码。

>    您的工作是制定一个计划来创建线程并保存/恢复寄存器以在线程之间切换，并实施该计划。完成后，`make grade` 应该说明您的解决方案通过了 `uthread` 测试。

完成后，在 xv6 上运行 `uthread` 时，您应该会看到以下输出（三个线程可能以不同的顺序开始）：

```c
$ make qemu
...
$ uthread
thread_a started
thread_b started
thread_c started
thread_c 0
thread_a 0
thread_b 0
thread_c 1
thread_a 1
thread_b 1
...
thread_c 99
thread_a 99
thread_b 99
thread_c: exit after 100
thread_a: exit after 100
thread_b: exit after 100
thread_schedule: no runnable threads
$
```

这个输出来自三个测试线程，每个线程都有一个循环，打印一行，然后将CPU让给其他线程。

**然而，在这一点上，由于没有上下文切换代码，你会看到没有输出。**

你需要给user/uthread.c中的**thread_create()**和**thread_schedule()**以及**user/uthread_switch.S**中 thread_switch添加代码。一个目标是确保当thread_schedule()第一次运行一个给定的线程时，该线程在自己的堆栈中执行传递给thread_create()的函数。另一个目标是确保thread_switch保存被切换走的线程的寄存器，恢复被切换到的线程的寄存器，并返回到后一个线程的指令中它最后离开的地方。你必须决定在哪里保存/恢复寄存器；修改struct thread以保存寄存器是一个好计划。你需要在thread_schedule中添加对thread_switch的调用；你可以向thread_switch传递任何你需要的参数，但其意图是将线程t切换到下一个线程。

一些提示：

-   thread_switch只需要保存/恢复callee-save寄存器。为什么呢？

-   你可以在user/uthread.asm中看到uthread的汇编代码，这对于调试来说可能很方便。
-   为了测试你的代码，使用riscv64-linux-gnu-gdb单步浏览你的thread_switch可能会有帮助。你可以用这种方式开始:

```
(gdb) file user/_uthread
Reading symbols from user/_uthread...
(gdb) b uthread.c:60
```

这在uthread.c的第60行设置了一个断点。这个断点可能（也可能不）在你运行uthread之前就被触发了。这怎么可能发生呢？

一旦你的xv6 shell运行，输入 "uthread"，gdb就会在第60行中断。现在你可以键入类似下面的命令来检查uthread的状态。

```
   (gdb) p/x *next_thread
```

用 "x"，你可以检查一个内存位置的内容。

```
   (gdb) x/x next_thread->stack
```

你可以这样跳到thread_switch的开头。

```
   (gdb) b thread_switch
   (gdb) c
```

 你可以使用单步汇编指令

```
   (gdb) si
```

gdb的在线文档[在这里](https://sourceware.org/gdb/current/onlinedocs/gdb/)。

##### 题目答案

要实现在用户级线程之间进行切换，需要保存和恢复线程的寄存器，这里可以参考swtch的用法，注意这里需要在user/uthread_switch.S进行修改，之前一直没看清题目，于是在user/uthread_switch.asm 中就行添加代码。

```c
  1     .text              
  2 
  3     /*
  4          * save the old thread's registers,
  5          * restore the new thread's registers.
  6          */
  7 
  8     .globl thread_switch
  9 thread_switch:
 10     /* YOUR CODE HERE */
 11 
 12         sd ra, 0(a0)
 13         sd sp, 8(a0)
 14         sd s0, 16(a0)
 15         sd s1, 24(a0)
 16         sd s2, 32(a0)
 17         sd s3, 40(a0)
 18         sd s4, 48(a0)
 19         sd s5, 56(a0)
 20         sd s6, 64(a0)
 21         sd s7, 72(a0)
 22         sd s8, 80(a0)
 23         sd s9, 88(a0)
 24         sd s10, 96(a0)
 25         sd s11, 104(a0)
 26 
 27         ld ra, 0(a1)
 28         ld sp, 8(a1)
 29         ld s0, 16(a1)
 30         ld s1, 24(a1)
 31         ld s2, 32(a1)
 32         ld s3, 40(a1)
 33         ld s4, 48(a1)
 34         ld s5, 56(a1)
 35         ld s6, 64(a1)
 36         ld s7, 72(a1)
 37         ld s8, 80(a1)
 38         ld s9, 88(a1)
 39         ld s10, 96(a1)
 40         ld s11, 104(a1)
 41 
 42     ret    /* return to ra */

```

其次是user/uthread.c中的**thread_create()**，这两部分需要仔细思考一下，首先是thread_create()，这个函数主要的功能是确保当thread_schedule()第一次运行一个给定的线程时，该线程在自己的堆栈中执行传递给thread_create()的函数，这里可以参考xv6的第一个用户进程的写法。

```c
83 void 
 84 thread_create(void (*func)())
 85 {
 86   struct thread *t;
 87 
 88   for (t = all_thread; t < all_thread + MAX_THREAD; t++) {
 89     if (t->state == FREE) break;
 90   }
 91   t->state = RUNNABLE;
 92   // YOUR CODE HERE
 93   memset(&t->context, 0, sizeof(t->context));
 94   t->context.ra = (uint64)(func);
 95   t->context.sp =(uint64)t->stack+STACK_SIZE;
 96   return;                                                           
 97 }

```

最后是**thread_schedule()**的修改，由于需要在不同线程之间进行切换，为此只需要在每个线程之间切换时，调用thread_switch((uint64)&t->context, (uint64)&current_thread->context)

```c
75   if (current_thread != next_thread) {      
 76     next_thread->state = RUNNING;
 77     t = current_thread;
 78     current_thread = next_thread;
 79     thread_switch((uint64)&t->context, (uint64)&current_thread->context);
 80   }
```



## 使用线程（[中等](https://pdos.csail.mit.edu/6.828/2020/labs/guidance.html))

##### 题目翻译

在本作业中，您将使用哈希表探索使用线程和锁进行并行编程。您应该在具有多个内核的真实 Linux 或 MacOS 计算机（不是 xv6，不是 qemu）上执行此分配。最近的笔记本电脑都有多核处理器。

这个作业使用UNIX的pthread线程库。你可以从手册页中找到有关它的信息，用man pthreads，你也可以在网上查找，例如这里、这里和这里。

文件notxv6/ph.c包含一个简单的哈希表，如果从单线程使用该表是正确的，但从多线程使用则不正确。在你的xv6主目录下（也许是~/xv6-labs-2020），输入以下内容。

```
$ make ph
$ ./ph 1
```

注意，为了构建ph，Makefile使用了你操作系统的gcc，而不是6.S081的工具。ph的参数指定了在哈希表上执行put和get操作的线程数量。运行一段时间后，ph 1会产生类似这样的输出：

```
100000 puts, 3.991 seconds, 25056 puts/second
0: 0 keys missing
100000 gets, 3.981 seconds, 25118 gets/second
```

 你看到的数字可能与这个样本输出相差2倍或更多，这取决于你的电脑有多快，是否有多个核心，以及是否在忙着做其他事情。

ph运行了两项基准测试。首先，它通过调用put()向哈希表添加大量的键，并打印出每秒钟所达到的put率。然后它用get()从哈希表中获取键。它打印出本应在哈希表中的键的数量，作为放的结果，但缺少（在本例中为零），并打印出它实现的每秒获取的数量。

你可以通过给它一个大于1的参数来告诉ph在同一时间从多个线程使用它的哈希表。试试ph 2。

```
$ ./ph 2
100000 puts, 1.885 seconds, 53044 puts/second
1: 16579 keys missing
0: 16579 keys missing
200000 gets, 4.322 seconds, 46274 gets/second
```

这个ph 2输出的第一行表明，当两个线程同时向哈希表添加条目时，它们达到了每秒53,044次插入的总速率。这大约是运行ph1的单线程速度的两倍。这是一个很好的 "并行加速"，大约是2倍，是人们所希望的（也就是说，两倍的核心在单位时间内产生两倍的工作）。
然而，这两行说 `16579 keys missing` ，表明大量本应在哈希表中的键不在那里。也就是说，放应该把这些键添加到哈希表中，但是出了问题。请看notxv6/ph.c，特别是put()和insert()。

为什么有2个线程的Keys会丢失，而有1个线程的则不会？找出一个有2个线程的事件序列，它可以导致一把钥匙keys丢失。在答案-线程.txt中提交你的序列和简短的解释。
为了避免这一系列的事件，在notxv6/ph.c的put和get中插入lock和unlock语句，这样在两个线程中丢失的钥匙数量总是0。相关的pthread调用是。

**pthread_mutex_t lock; // 声明一个锁**
**pthread_mutex_init(&lock, NULL); //初始化锁**
**pthread_mutex_lock(&lock); // 获取锁**
**pthread_mutex_unlock(&lock); // 释放锁**

>   当make grade说你的代码通过了ph_safe测试时，你就完成了，ph_safe测试要求在两个线程中零缺失键。在这一点上，不通过ph_fast测试也是可以的。

在有些情况下，并发的put()s在哈希表中读取或写入的内存没有重叠，因此不需要锁来保护彼此。你能改变ph.c以利用这种情况来获得一些put()s的并行加速吗？提示：每个哈希桶有一个锁怎么样？

修改你的代码，使一些put操作在保持正确性的前提下并行运行。当make grade说你的代码通过了ph_safe和ph_fast测试，你就完成了。ph_fast测试要求两个线程的put/second数量至少是一个线程的1.25倍。

##### 题目答案

这道题目主要就是考察调用pthread函数，需要注意的是首先声明一个锁，然后在主函数调用初始化锁函数，最后在需要的地方进行加锁与开锁操作。

```c
 ...
 11 pthread_mutex_t lock;            // declare a lock
 12 
 13 struct entry {
 14   int key;
 15   int value;
 16   struct entry *next;
 17 };

```

```c
103 int
104 main(int argc, char *argv[])
105 {
 ...
110   if(pthread_mutex_init(&lock,NULL)!=0) // initialize the lock
111     {
112         printf("Init lock error!");
113         exit(-1);
114     }

```

```c
40 static 
 41 void put(int key, int value)
 42 {
 43   int i = key % NBUCKET;
 44 
 45   // is the key already present?
 46   struct entry *e = 0;
 47   for (e = table[i]; e != 0; e = e->next) {
 48     if (e->key == key)
 49       break;
 50   }
 51   if(e){
 52     // update the existing key.
 53     e->value = value;
 54   } else {
 55     // the new is new.
 56     pthread_mutex_lock(&lock);       // acquire lock
 57     insert(key, value, &table[i], table[i]);
 58     pthread_mutex_unlock(&lock);       // acquire lock
 59   }
 60 }

```



## 屏障（[中等](https://pdos.csail.mit.edu/6.828/2020/labs/guidance.html))

##### 题目翻译

在这个作业中，你将实现一个障碍：在一个应用程序中的一个点，所有参与的线程必须等待，直到所有其他参与的线程也到达这个点。你将使用pthread条件变量，这是一种类似于xv6的睡眠和唤醒的序列协调技术。

你应该在一台真实的计算机上做这个作业（不是xv6，也不是qemu）。

文件notxv6/barrier.c中包含了一个破碎的屏障：

>   $ make barrier
>   $ ./barrier 2
>   barrier: notxv6/barrier.c:42: thread: 断言 `i == t' 失败。
>   数字“2”指定了在屏障上同步的线程数量（barrier.c中的nthread）。每个线程执行一个循环。在每个循环迭代中，一个线程调用barrier()，然后睡眠一个随机的微秒数。断言被触发，因为一个线程在另一个线程到达屏障之前就离开了屏障。所期望的行为是，每个线程都在barrier()中阻塞，直到所有的n个线程都调用barrier()。
>
>   你的目标是实现理想的屏障行为。除了你在ph这项作业中看到的锁外，你还需要以下新的pthread函数 ：pthread_cond_wait(&cond, &mutex); // 在cond时进入睡眠状态，释放锁的mutex，在唤醒时获取。
>   pthread_cond_broadcast(&cond); // 唤醒所有在条件下睡觉的线程。
>   确保你的方案通过make grade的barrier测试。

pthread_cond_wait在被调用时释放了mutex，并在返回前重新获取了mutex。
我们已经给了你 barrier_init() 。你的工作是实现 barrier() ，使恐慌不会发生。我们已经为你定义了 struct barrier ；它的字段供你使用。 

有两个问题使你的任务复杂化：

-   你必须处理一连串的barrier调用，每一次我们都称之为一轮。每次当所有线程都到达障碍物时，你都应该递增bstate.round。
-   你必须处理这样的情况：一个线程在其他线程退出屏障之前就在循环中竞赛。特别是，你正在重复使用bstate.nthread这个变量，从一个回合到下一个回合。确保一个离开障碍物并在循环中竞赛的线程不会在前一轮仍在使用它时增加bstate.nthread。

用一个、两个、以及两个以上的线程测试你的代码。

##### 题目答案

这里需要实现一个barrier（）函数，使得能够等待所有线程到达barrier函数，然后再进行下一轮的迭代，这里需要注意，一个线程需要另外一个线程进行唤醒（最后一个线程需要唤醒前面所有线程），然后使用最后一个线程的round。

```c
25 static void 
 26 barrier()
 27 {
 28     pthread_mutex_lock(&bstate.barrier_mutex);
 29     bstate.nthread++;
 30     int m = bstate.nthread;
 31     if(m<nthread){
 32         pthread_cond_wait(&bstate.barrier_cond, &bstate.barrier_mutex);
 33     }else{
 34         bstate.round++;
 35         bstate.nthread = 0;
 36         pthread_cond_broadcast(&bstate.barrier_cond);
 37     }                                                                                                                                               
 38     pthread_mutex_unlock(&bstate.barrier_mutex);
 39 }

```

这里涉及许多线程的函数，有空可以多学习一下~

这里记下我对几个函数的理解吧：

首先是pthread_cond_wait(*cond, *mutex)；该函数以cond作为条件变量进行睡眠，等待被pthread_cond_broadcast或者pthread_cond_signal唤醒，同时再函数内部持有mutex锁，当在睡眠后就释放该锁，唤醒后重新想要获取该锁，但不一定能获取到。

其次是pthread_cond_broadcast(*mutex)；该函数唤醒在cond上面等待的睡眠函数

最后是pthread_create（）

```c
#include <pthread.h>
int pthread_create(
                 pthread_t *restrict tidp,   //新创建的线程ID指向的内存单元。
                 const pthread_attr_t *restrict attr,  //线程属性，默认为NULL
                 void *(*start_rtn)(void *), //新创建的线程从start_rtn函数的地址开始运行
                 void *restrict arg //默认为NULL。若上述函数需要参数，将参数放入结构中并将地址作为arg传入。
                  );
```

**问题：**
**避免直接**在传递的参数中**传递发生改变的量**，否则会导致结果不可测。
即使是只再创造一个单线程，也可能在线程未获取传递参数时，线程获取的变量值已经被主线程进行了修改。

**通常解决方案：**
重新申请一块内存，存入需要传递的参数，再将这个地址作为arg传入。

配套使用**pthread_join**

```c
int pthread_join(
               pthread_t tid, //需要等待的线程,指定的线程必须位于当前的进程中，而且不得是分离线程
               void **status  //线程tid所执行的函数返回值（返回值地址需要保证有效），其中status可以为NULL
                 );
```

pthread_join()函数会一直阻塞调用线程，直到指定的线程终止。当pthread_join()返回之后，应用程序可回收与已终止线程关联的任何数据存储空间。
但是，同时需要注意，一定要和上面创建的某一线程配套使用，这样还可以起到互斥的作用。否则多线程可能抢占CPU资源，导致运行结果不确定。

## 测试结果

编写answers-thread.txt和time.txt文件，然后测试结果：

```c
== Test uthread == 
$ make qemu-gdb
uthread: OK (2.4s) 
== Test answers-thread.txt == answers-thread.txt: OK 
== Test ph_safe == make[1]: 进入目录“/home/cbn/6s081/xv6-labs-2020”
make[1]: “ph”已是最新。
make[1]: 离开目录“/home/cbn/6s081/xv6-labs-2020”
ph_safe: OK (7.7s) 
== Test ph_fast == make[1]: 进入目录“/home/cbn/6s081/xv6-labs-2020”
make[1]: “ph”已是最新。
make[1]: 离开目录“/home/cbn/6s081/xv6-labs-2020”
ph_fast: OK (19.0s) 
== Test barrier == make[1]: 进入目录“/home/cbn/6s081/xv6-labs-2020”
gcc -o barrier -g -O2 notxv6/barrier.c -pthread
make[1]: 离开目录“/home/cbn/6s081/xv6-labs-2020”
barrier: OK (12.0s) 
== Test time == 
time: OK 
Score: 60/60
```

