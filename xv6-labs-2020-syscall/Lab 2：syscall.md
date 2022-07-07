## Lab 2：system calls （系统调用）



[TOC]




> 前言：在本练习中，您将向 xv6 添加一些新的系统调用，这将帮助您了解它们的工作原理，并向您介绍 xv6 内核的一些内部结构。你将在以后的实验室中添加更多系统调用。
> 
> 准备：在开始编码之前，请阅读 xv6 本书的第 2 章、第 4 章的第 4.3 和 4.4 节以及相关的源文件。

若要启动实验室，请切换到 syscall 分支：

```c
  $ git fetch
  $ git checkout syscall
  $ make clean
```
这里建议重新下载实验，进行操作：

```c
	$ git clone git://g.csail.mit.edu/xv6-labs-2020
	Cloning into 'xv6-labs-2020'...
	...
	$ cd xv6-labs-2020
	$ git checkout syscall
```


### 1. System call tracing（系统调用跟踪）
#### Question :
在此实验中，你将添加一个系统调用跟踪功能，该功能可能会在调试以后的实验室时帮助你。您将创建一个将控制跟踪的新跟踪系统调用。它应该采用一个参数，一个整数"掩码"，其位指定要跟踪的系统调用。例如，为了跟踪 fork 系统调用，程序调用 `trace（1 << SYS_fork）`，其中 `SYS_fork` 是来自 `kernel/syscall.h` 的系统调用号。您必须修改 xv6 内核，以便在每个系统调用即将返回时打印出一行，前提是在掩码中设置了系统调用的号码。该行应包含进程 ID、系统调用的名称和返回值; 您不需要打印系统调用参数。跟踪系统调用应启用对调用它的进程及其随后分叉的任何子进程的跟踪，但不应影响其他进程。


#### Example:
在实验中提供了一个跟踪用户级程序，该程序运行另一个启用了跟踪的程序（请参阅 user/trace.c）。完成后，您应该看到如下输出：

```c
$ trace 32 grep hello README
3: syscall read -> 1023
3: syscall read -> 966
3: syscall read -> 70
3: syscall read -> 0
$
$ trace 2147483647 grep hello README
4: syscall trace -> 0
4: syscall exec -> 3
4: syscall open -> 3
4: syscall read -> 1023
4: syscall read -> 966
4: syscall read -> 70
4: syscall read -> 0
4: syscall close -> 0
$
$ grep hello README
$
$ trace 2 usertests forkforkfork
usertests starting
test forkforkfork: 407: syscall fork -> 408
408: syscall fork -> 409
409: syscall fork -> 410
410: syscall fork -> 411
409: syscall fork -> 412
410: syscall fork -> 413
409: syscall fork -> 414
411: syscall fork -> 415
...
$   
```

#### Preparation: 
这里将要注意的点列举一下：
（手册里面说的不是很全面，这里建议手动查找：当进行系统调用时，到底哪里进行修改了？）
我这里参考[https://tnallen.people.clemson.edu/2019/03/04/intro-to-xv6.html](https://tnallen.people.clemson.edu/2019/03/04/intro-to-xv6.html)
这篇文章的内核和本文的有区别，但方法一样，利用正则匹配，找到一个系统调用所需要经历的所有过程。当然包括用户级和内核级两大部分，大多数都是依葫芦画瓢，按照标准来进行操作就行。
![在这里插入图片描述](https://img-blog.csdnimg.cn/ed5743cc0e2d4256aec3283361f38d66.png?x-oss-process=image/watermark,type_d3F5LXplbmhlaQ,shadow_50,text_Q1NETiBAY3ViZV9fNA==,size_20,color_FFFFFF,t_70,g_se,x_16)
（其中的tags，.asm，.sym文件不用管，tags是我用来进行vim堆栈调用的，剩余两个是生成的汇编文件，不需要自己组装）

首先是用户级：

 1. 将系统调用的原型添加到user/user.h（注意在添加原型时，也要添加所需的结构类型，如下面第二个实验）
 2. 将存根添加到user/usys.pl
 3. 这里可以将user/usys.S也进行修改，当然也可以不用，建议修改。

其次是内核级：
 1. 将系统调用的编号添加到 kernel/syscall.h
 2. 修改 kernel/sysproc.c，添加一个系统调用的函数，这一步可以参照图片上面的例子修改。

#### Reference:

```c
//-----kernel/sysproc.c---------
uint64
sys_trace(void){
	int n;
	if(argint(0, &n)<0){
		return -1;
	}
	myproc()->tracemask = n;//tracemask是输入的整数掩码，对应父进程及其子进程，需要在进程开始的框架中声明
	return 0;
}

//-----kernel/proc.h------
// Per-process state
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
  int tracemask;//整数掩码
};
//修改fork，使得掩码复制到子进程，由于这里是在内核，故需要将之前声明的数据传给子代
//---------kernel/proc.c--------
int
fork(void)
{
  int i, pid;
  struct proc *np;
  struct proc *p = myproc();
...
  // copy saved user registers.
  *(np->trapframe) = *(p->trapframe);

  // Cause fork to return 0 in the child.
  np->trapframe->a0 = 0; 
  np->tracemask = p->tracemask;
//修改syscall()函数，以打印输出，这里选择使用printf
//注意这里打印输出时，要求打印系统调用函数，建议使用字符数组
//---------kernel/syscall.c--------
static char* syscall_name[] = {
[SYS_fork]    "fork",
[SYS_exit]    "exit",
[SYS_wait]    "wait",
[SYS_pipe]    "pipe",
[SYS_read]    "read",
[SYS_kill]    "kill",
[SYS_exec]    "exec",
[SYS_fstat]   "fstat",
[SYS_chdir]   "chdir",
[SYS_dup]     "dup",
[SYS_getpid]  "getpid",
[SYS_sbrk]    "sbrk",
[SYS_sleep]   "sleep",
[SYS_uptime]  "uptime",
[SYS_open]    "open",
[SYS_write]   "write",
[SYS_mknod]   "mknod",
[SYS_unlink]  "unlink",
[SYS_link]    "link",
[SYS_mkdir]   "mkdir",
[SYS_close]   "close",
[SYS_trace]   "trace",
[SYS_sysinfo] "sysinfo"
};
void
syscall(void)
{
  int num;
  struct proc *p = myproc();
  num = p->trapframe->a7;

  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    p->trapframe->a0 = syscalls[num]();
	if((p->tracemask)&(1<<num)){
		printf("%d: syscall %s -> %d\n", p->pid, syscall_name[num], p->trapframe->a0);
	}
  } else {
    printf("%d %s: unknown sys call %d\n",
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
  }
```

### 2. Sysinfo（系统信息）
#### Question :
在此实验中，您将添加一个系统调用 sysinfo，用于收集有关正在运行的系统的信息。系统调用采用一个参数：指向结构 sysinfo 的指针（参见 kernel/sysinfo.h）。内核应填写此结构的字段：freemem 字段应设置为可用内存的字节数，nproc 字段应设置为状态not UNUSED的进程数。

#### Example:
调用我们提供系统信息测试sysinfotest测试程序;如果它打印"sysinfotest：OK"，则通过此分配。
![在这里插入图片描述](https://img-blog.csdnimg.cn/8282bfb6f7ea4a6b833405f35cbd16de.png)

#### Preparation: 
这里一定要注意许多细节！包括nproc的含义，这里是 not UNUSED ！
其他就参照原来的就行。
#### Reference:
这里主要展示实现sys_sysinfo（nproc与freemem）的部分：

```c
//--------kernel/sysproc.c------
uint64
sys_sysinfo(void){
	uint64 ptr;//get the usr_addr  
	if(argaddr(0, &ptr)<0){
		return -1;
	}
	//copyout() implemention
	struct proc *p = myproc();
	struct sysinfo st;
	st.nproc =  collect_process();
	st.freemem = kcollect();
	if(copyout(p->pagetable, ptr, (char *)&st, sizeof(st))<0){
		return -1;
	}
	return 0;
}
//kernel/proc.c : collect_process
//collect thr free process num
uint64 collect_process(void){
	uint64 n = 0;
	struct proc *p;
	for(p = proc;p<&proc[NPROC];p++){
		if(p->state != UNUSED){
			n=n+1;
		}	
	}
	return n;
}
//kenerl/kalloc: kcollect
//collect the free memory
uint64
kcollect(void){
	struct run *r;
	uint64 mem=0;
 
	r = kmem.freelist;
	while(r){
		mem+=PGSIZE;
		r = r->next;
	}
 
	return mem;
}

```



