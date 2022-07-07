# Lab 8: locks

### 实验准备

在这个实验室中，你将获得重新设计代码以提高并行性的经验。在多核机器上并行性差的一个常见症状是高锁争用。提高并行性通常需要**改变数据结构和锁策略**，以减少争用。你将为xv6内存分配器和块缓存做这件事。

>   在编写代码之前，请确保阅读xv6书中的以下部分。
>
>   -   第6章："锁定 "和相应的代码。
>   -   第3.5节："代码。物理内存分配器"
>   -   第8.1节到8.3节："概述"、"缓冲区缓存层 "和 "代码。缓冲区高速缓存"

### 内存分配器（[中等](https://pdos.csail.mit.edu/6.828/2020/labs/guidance.html))

##### 题目翻译

user/kalloctest程序强调xv6的内存分配器：三个进程增加和减少他们的地址空间，导致对kalloc和kfree的多次调用。 kalloctest打印（作为 "#fetch-and-add"）由于试图获取另一个核已经持有的锁而在aquire中循环迭代的数量，对于kmem锁和其他一些锁。获取中的循环迭代次数是对锁竞争的一个粗略衡量。在你完成实验之前，kalloctest的输出看起来与此相似。

```c
$ kalloctest
start test1
test1 results:
--- lock kmem/bcache stats
lock: kmem: #fetch-and-add 83375 #acquire() 433015
lock: bcache: #fetch-and-add 0 #acquire() 1260
--- top 5 contended locks:
lock: kmem: #fetch-and-add 83375 #acquire() 433015
lock: proc: #fetch-and-add 23737 #acquire() 130718
lock: virtio_disk: #fetch-and-add 11159 #acquire() 114
lock: proc: #fetch-and-add 5937 #acquire() 130786
lock: proc: #fetch-and-add 4080 #acquire() 130786
tot= 83375
test1 FAIL
```

kalloctest调用一个系统调用，使内核打印出kmem和bcache锁（这是本实验的重点）以及5个争夺最激烈的锁的计数。如果存在锁的争夺，那么获取循环的迭代次数将会很大。系统调用返回kmem锁和bcache锁的循环迭代次数之和。

在这个实验中，你必须使用一台有多个内核的专门的无负载机器。如果你使用一台正在做其他事情的机器，那么kalloctest所打印的计数将是无稽之谈。你可以使用专用的Athena工作站，或者你自己的笔记本电脑，但不要使用拨号机。

kalloctest中锁争用的根本原因是kalloc()有一个单一的自由列表，由一个锁保护。为了消除锁的争夺，你必须重新设计内存分配器，以避免单一的锁和列表。基本的想法是为每个CPU维护一个空闲列表，每个列表有自己的锁。不同CPU上的分配和释放可以并行运行，因为每个CPU将对不同的列表进行操作。主要的挑战是如何处理这样的情况：一个CPU的空闲列表是空的，但另一个CPU的列表有空闲内存；在这种情况下，一个CPU必须 "偷 "走另一个CPU的空闲列表的一部分。偷窃可能会带来锁的争夺，但希望这种情况不常发生。

>   你的工作是实现每个CPU的自由列表，并在一个CPU的自由列表为空时进行窃取。你必须给你所有的锁起一个以 "kmem "开头的名字。也就是说，你应该为你的每个锁调用initlock，并传递一个以 "kmem "开头的名字。运行kalloctest，看看你的实现是否减少了锁的争夺。为了检查它是否仍然可以分配所有的内存，运行usertests sbrkmuch。你的输出将类似于下图所示，在kmem锁上的争夺大大减少，尽管具体数字会有所不同。确保usertests中的所有测试都通过了。 make grade应该说kalloctests通过了。

：

```c
$ kalloctest
start test1
test1 results:
--- lock kmem/bcache stats
lock: kmem: #fetch-and-add 0 #acquire() 42843
lock: kmem: #fetch-and-add 0 #acquire() 198674
lock: kmem: #fetch-and-add 0 #acquire() 191534
lock: bcache: #fetch-and-add 0 #acquire() 1242
--- top 5 contended locks:
lock: proc: #fetch-and-add 43861 #acquire() 117281
lock: virtio_disk: #fetch-and-add 5347 #acquire() 114
lock: proc: #fetch-and-add 4856 #acquire() 117312
lock: proc: #fetch-and-add 4168 #acquire() 117316
lock: proc: #fetch-and-add 2797 #acquire() 117266
tot= 0
test1 OK
start test2
total free number of pages: 32499 (out of 32768)
.....
test2 OK
$ usertests sbrkmuch
usertests starting
test sbrkmuch: OK
ALL TESTS PASSED
$ usertests
...
ALL TESTS PASSED
$
```

>   一些提示:
>
>   -   你可以使用kernel/param.h中的常数NCPU
>   -   让freerange把所有的空闲内存给运行freerange的CPU。
>   -   函数cpuid返回当前的核心号，但只有在关闭中断时调用它并使用其结果才是安全的。你应该使用 push_off() 和 pop_off() 来关闭和开启中断。
>   -   看一下kernel/sprintf.c中的snprintf函数，了解一下字符串格式化的想法。不过，把所有的锁命名为 "kmem "也是可以的。

##### 题目答案

该题的主要目的是想让我们将减少kmem锁的竞争，但由于在进行分配内存时，需要对freelist进行修改，为此需要保护该全局变量，但在原来的设计中，只有一个锁对此进行保护，这就造成许多进程对该锁的竞争。为此需要为每一个CPU分配一个自己的freelist，这样就不会出现竞争，这里的难点是理解题意，第一个是**让freerange把所有的空闲内存给运行freerange的CPU**，我们知道只有kinit函数才会调用该函数，所以只有第一个CPU会调用这个函数，这使得第一个CPU会获得所有的空闲链表，第二个**一个CPU必须 "偷 "走另一个CPU的空闲列表的一部分**，这就涉及到第二个CPU必须从第一个CPU中取走一部分freelist，这里为了方便只取一半，而当CPU发现自己没有内存就向其他CPU取走，这里需要跳过自己，然后返回获得的free list指针。代码如下：

首先是针对每一个CPU生成一个freelist，对应一个自旋锁：

```c
struct {
  struct spinlock lock;
  struct run *freelist;
} kmem[NCPU];
```

然后初始化所有锁：

```c
void
kinit()
{
  for(int i=0;i<NCPU;i++){
	char str[10];
	snprintf(str,9,"kmem %d",i);
	initlock(&kmem[i].lock, str);
  }
  freerange(end, (void*)PHYSTOP);
}
```

接着是对kfree中每个CPU的链表进行free：

```c
  acquire(&kmem[id].lock);
  r->next = kmem[id].freelist;
  kmem[id].freelist = r;
  release(&kmem[id].lock);
```

难点是在kalloc函数里面，如何从别的CPU中取得空闲链表指针：

```c
void *
kalloc(void)
{
  struct run *r;
  push_off();
  int id = cpuid();
  pop_off(); 
  acquire(&kmem[id].lock);
  r = kmem[id].freelist;
  if(!r){
	  r = steal(id);
  }
  if(r)
    kmem[id].freelist = r->next;
  release(&kmem[id].lock);
  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk
  return (void*)r;
}
```

这里的steal函数采用双指针的方法快速得到其余CPU上freelist的中间指针，返回即可，这里需要注意偷取的时候需要对被偷对象加锁，否则会出现bug，最后要注意解锁，放在死锁。

```c
struct run *steal(int id){
	struct run *r,*slow, *fast;
	for(int i=0;i<NCPU;i++){
		if(i == id)
			continue;
		acquire(&kmem[i].lock);
		if(kmem[i].freelist){
     		slow = kmem[i].freelist;fast = kmem[i].freelist->next;
     		r = slow;
     		if(fast == 0||fast->next == 0){
     			release(&kmem[i].lock);
     			continue;
     		}
     		while(fast != slow){
     			if(fast == 0||fast->next == 0)
     				break;
     			slow = slow->next;
     			fast = fast->next->next;
     		}
			r = slow->next;
     		slow->next = 0;
     		release(&kmem[i].lock);
     		return r;

		}
		release(&kmem[i].lock);
	}
	return 0;
}
```



### 缓冲区缓存（[困难](https://pdos.csail.mit.edu/6.828/2020/labs/guidance.html))

##### 题目翻译

这一半的作业与前一半的作业是独立的；无论你是否完成了前一半的作业，你都可以进行这一半的工作（并通过测试）。

如果多个进程密集地使用文件系统，它们很可能会争夺bcache.lock，它保护kernel/bio.c中的磁盘块缓存。bcachetest创建了几个重复读取不同文件的进程，以产生对bcache.lock的争夺；其输出看起来像这样（在你完成本实验之前）。

```c
$ bcachetest
start test0
test0 results:
--- lock kmem/bcache stats
lock: kmem: #fetch-and-add 0 #acquire() 33035
lock: bcache: #fetch-and-add 16142 #acquire() 65978
--- top 5 contended locks:
lock: virtio_disk: #fetch-and-add 162870 #acquire() 1188
lock: proc: #fetch-and-add 51936 #acquire() 73732
lock: bcache: #fetch-and-add 16142 #acquire() 65978
lock: uart: #fetch-and-add 7505 #acquire() 117
lock: proc: #fetch-and-add 6937 #acquire() 73420
tot= 16142
test0: FAIL
start test1
test1 OK
```

你可能会看到不同的输出，但bcache锁的获取循环迭代次数会很高。如果你看一下kernel/bio.c中的代码，你会发现bcache.lock保护了缓存块缓冲区的列表，每个块缓冲区的引用计数（b->refcnt），以及缓存块的身份（b->dev和b->blockno）。

>   修改块缓存，使运行bcachetest时，bcache中所有锁的获取循环迭代次数接近于零。理想情况下，区块缓存中涉及的所有锁的计数之和应该为零，但如果总和小于500也没关系。**修改bget和brelse**，使bcache中不同区块的并发查找和释放不太可能在锁上发生冲突（例如，不必都等待bcache.lock）。你必须保持一个不变的原则，即每个区块最多只有一个副本被缓存。当你完成后，你的输出应该类似于下图所示（虽然不完全相同）。确保usertests仍然通过。当你完成后，make grade应该通过所有的测试。

```c
$ bcachetest
start test0
test0 results:
--- lock kmem/bcache stats
lock: kmem: #fetch-and-add 0 #acquire() 32954
lock: kmem: #fetch-and-add 0 #acquire() 75
lock: kmem: #fetch-and-add 0 #acquire() 73
lock: bcache: #fetch-and-add 0 #acquire() 85
lock: bcache.bucket: #fetch-and-add 0 #acquire() 4159
lock: bcache.bucket: #fetch-and-add 0 #acquire() 2118
lock: bcache.bucket: #fetch-and-add 0 #acquire() 4274
lock: bcache.bucket: #fetch-and-add 0 #acquire() 4326
lock: bcache.bucket: #fetch-and-add 0 #acquire() 6334
lock: bcache.bucket: #fetch-and-add 0 #acquire() 6321
lock: bcache.bucket: #fetch-and-add 0 #acquire() 6704
lock: bcache.bucket: #fetch-and-add 0 #acquire() 6696
lock: bcache.bucket: #fetch-and-add 0 #acquire() 7757
lock: bcache.bucket: #fetch-and-add 0 #acquire() 6199
lock: bcache.bucket: #fetch-and-add 0 #acquire() 4136
lock: bcache.bucket: #fetch-and-add 0 #acquire() 4136
lock: bcache.bucket: #fetch-and-add 0 #acquire() 2123
--- top 5 contended locks:
lock: virtio_disk: #fetch-and-add 158235 #acquire() 1193
lock: proc: #fetch-and-add 117563 #acquire() 3708493
lock: proc: #fetch-and-add 65921 #acquire() 3710254
lock: proc: #fetch-and-add 44090 #acquire() 3708607
lock: proc: #fetch-and-add 43252 #acquire() 3708521
tot= 128
test0: OK
start test1
test1 OK
$ usertests
  ...
ALL TESTS PASSED
$
```

请给你所有的锁取一个以 "bcache "开头的名字。也就是说，你应该为你的每一个锁调用initlock，并传递一个以 "bcache "开头的名字。

减少bcache中的争用比kalloc更棘手，因为bcache缓冲区确实是由进程（也就是CPU）共享的。对于kalloc来说，我们可以通过给每个CPU提供自己的分配器来消除大部分的争用，但这对bcache来说是行不通的。我们建议你**用一个带锁的哈希表来查询缓存中的区块号码**，每个哈希桶有一个锁。

在某些情况下，如果你的解决方案有锁冲突，那是可以的。

-   当两个进程同时使用相同的块号时，bcachetest test0不会这样做。
-   当两个进程同时错过了缓存，并且需要找到一个未使用的块来替换时，bcachetest test0不会这样做。
-   当两个进程同时使用的区块在你用来划分区块和锁的方案中发生冲突时；例如，如果两个进程使用的区块，其区块号在哈希表中哈希到同一个槽中，bcachetest test0可能会这样做，这取决于你的设计，但你应该尝试调整方案的细节以避免冲突（例如，改变哈希表的大小）。

**bcachetest的test1使用了比缓冲区更多的独立块，并使用了大量的文件系统代码路径。**

这里有一些提示:

-   阅读xv6书中关于块缓存的描述（8.1-8.3节）。
-   使用固定数量的桶，不动态地调整哈希表的大小是可以的。使用一个质数的桶（例如，13）来减少散列冲突的可能性。
-   **在哈希表中搜索一个缓冲区，并在没有找到缓冲区时为其分配一个条目，必须是原子性的。**
-   删除所有缓冲区的列表（bcache.head等），取而代之的是使用最后一次使用缓冲区的时间戳（即使用kernel/trap.c中的ticks）。有了这个变化，brelse就不需要获取bcache锁了，**bget可以根据时间戳选择最近使用最少的块。**
-   **在bget中序列化驱逐是可以的（即bget中选择缓冲区的部分，当在缓存中查找失误时可以重新使用）。**
-   **你的解决方案在某些情况下可能需要持有两个锁；例如，在驱逐过程中，你可能需要持有bcache锁和每个桶的锁。请确保你能避免死锁。**
-   当替换一个区块时，你可能会把一个结构缓冲区从一个桶移到另一个桶，因为新的区块哈希到一个不同的桶。你可能会遇到一个棘手的情况：新的块可能哈希到与旧的块相同的桶。请确保你在这种情况下避免死锁。
-   一些调试技巧：实现bucket锁，但在bget的开始/结束时留下全局的bcache.lock acquire/release，以使代码序列化。一旦你确定它是正确的，没有竞赛条件，就删除全局锁并处理并发问题。你也可以运行make CPUS=1 qemu来用一个核心进行测试。

##### 题目答案

这道题的难度远大于第一题，当然自己也真正学会了锁的使用方法，以及锁的重要性。首先是要理解题目含义，他要求我们要减少对bcache锁的竞争，该锁是负责保护缓存块的，当多个进程进行

测试结果：

```c
== Test running kalloctest == 
$ make qemu-gdb
(68.8s) 
== Test   kalloctest: test1 == 
  kalloctest: test1: OK 
== Test   kalloctest: test2 == 
  kalloctest: test2: OK 
== Test kalloctest: sbrkmuch == 
$ make qemu-gdb
kalloctest: sbrkmuch: OK (9.1s) 
== Test running bcachetest == 
$ make qemu-gdb
(6.4s) 
== Test   bcachetest: test0 == 
  bcachetest: test0: OK 
== Test   bcachetest: test1 == 
  bcachetest: test1: OK 
== Test usertests == 
$ make qemu-gdb
usertests: OK (97.9s) 
== Test time == 
time: OK 
Score: 70/70
```

