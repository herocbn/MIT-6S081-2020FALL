##  Lab ：Networking

#### 实验准备

在本次实验中要求编写网卡E1000 的传输和接受驱动程序，使其可以完成基本的操作。需要具备的知识基础主要是视频课程（80%）+作业提示（10%）+E1000技术手册（10%），必须理解网卡这类网络驱动程序是如何工作的，为此视频里讲解的很清楚，这里就不再描述了，其次是作业提示也能够很好地帮助我们完成题目的大部分情况，最后才是技术手册，由于这里技术手册特别晦涩难懂，我的建议是不如直接先看xv6的网络驱动程序源码，在不懂的话，尝试阅读技术手册。

接下来主要是对xv6里面的网卡驱动程序的剖析，其中最重要的是**e1000_init.**

首先是全局变量与宏声明

```c
// xv6/kernel/e1000.c
#define TX_RING_SIZE 16
static struct tx_desc tx_ring[TX_RING_SIZE] __attribute__((aligned(16)));
static struct mbuf *tx_mbufs[TX_RING_SIZE];
/* 上文定义一个传输环，环的组成元素是tx_desc类型，传输缓存层的元素类型是mbuf*
struct tx_desc   
{
  uint64 addr;//存放数据包的地址
  uint16 length;//数据包的长度
  //后面是校验位和控制位，可参考技术手册进行操作
  uint8 cso;
  uint8 cmd;
  uint8 status;
  uint8 css;
  uint16 special; 
};
控制符里面重要的是cmd和status，其中status表示上一个数据包是否传输成功，若成功则E1000_TXD_STAT_DD（0x01），否则为0x0.其次是cmd，它控制了该描述符的行为，当 E1000_TXD_CMD_EOP 被设置时，表示当前描述符为用于存储一块数据包的最后一个描述符（当数据包较大时可由多个描述符共同存储），当 E1000_TXD_CMD_RS 被设置时，硬件在提取当前描述符的内容时，会自动将该描述符的status 置为 E1000_TXD_STAT_DD 。
--------------------------------------------------------------------------------------
struct mbuf {                                                        
  struct mbuf  *next; // the next mbuf in the chain
  char         *head; // the current start position of the buffer
  unsigned int len;   // the length of the buffer
  char         buf[MBUF_SIZE]; // the backing store
};
*/
//接受环的编写与传输环大致相同
#define RX_RING_SIZE 16
static struct rx_desc rx_ring[RX_RING_SIZE] __attribute__((aligned(16)));
static struct mbuf *rx_mbufs[RX_RING_SIZE];

// remember where the e1000's registers live.
static volatile uint32 *regs;//用于获取当前的（传输或者接收）环索引位置

struct spinlock e1000_lock;//这里为什么定义一个锁，而不是为传输和接收都定义一个锁很关键，主要是主机对网卡与网卡对主机的关系分别是多对一与一对多的关系，为此只需要在传输上面加锁即可使得多个用户进行调用网卡驱动程序。

```

接下来是传输的初始化过程

```c
 // [E1000 14.5] Transmit initialization
  memset(tx_ring, 0, sizeof(tx_ring));
  for (i = 0; i < TX_RING_SIZE; i++) {
    tx_ring[i].status = E1000_TXD_STAT_DD;
    tx_mbufs[i] = 0;
  }
  regs[E1000_TDBAL] = (uint64) tx_ring;
  if(sizeof(tx_ring) % 128 != 0)
    panic("e1000");
  regs[E1000_TDLEN] = sizeof(tx_ring);
  regs[E1000_TDH] = regs[E1000_TDT] = 0;
/*
这一部分是对传输环的初始化，首先将所有值置零，接着将每个环的描述符状态设置为可用状态（E1000_TXD_STAT_DD），然后是传输缓存层指针设置为空指针，将当前的环索引置零，表示从头开始使用传输环，这里要和接收环做区别。
*/

```

接着是接收环的初始化过程

```c
 // [E1000 14.4] Receive initialization
  memset(rx_ring, 0, sizeof(rx_ring));
  for (i = 0; i < RX_RING_SIZE; i++) {
    rx_mbufs[i] = mbufalloc(0);
    if (!rx_mbufs[i])
      panic("e1000");
    rx_ring[i].addr = (uint64) rx_mbufs[i]->head;
  }
  regs[E1000_RDBAL] = (uint64) rx_ring;
  if(sizeof(rx_ring) % 128 != 0)
    panic("e1000");
  regs[E1000_RDH] = 0;
  regs[E1000_RDT] = RX_RING_SIZE - 1;
  regs[E1000_RDLEN] = sizeof(rx_ring);
/* 
这一部分是对接收环的初始化，首先环置零，接着是为每个接收缓存申请一个可用的缓存地址，用于存放随时可能到达的数据包，接着将每个缓存地址放入环中。然后是对头部和尾部的初始化，主要的是E1000_RDT的定义要注意，这里他将其设置为最后一个元素的索引为此，后面使用前需要先将其加1在对其总长度取模。
```

<img src="Lab ：Networking.assets/figure1.png" style="zoom:67%;" />

实验指导部分 

关于实现e1000_transmit的提示：

-   首先，通过读取E1000_TDT控制寄存器，向E1000询问它期待下一个数据包的TX环索引。regs[E1000_TDT]
-   然后检查环是否溢出。如果E1000_TXD_STAT_DD在E1000_TDT索引的描述符中没有设置，说明E1000还没有完成相应的前一个传输请求，所以返回错误。
-   否则，使用 mbuffree() 释放从该描述符传输的最后一个 mbuf（如果有的话）。
-   然后填入描述符。m->head指向内存中的数据包内容，m->len是数据包长度。设置必要的cmd标志（请看E1000手册的第3.3节），并把指向mbuf的指针藏起来，以便以后释放。
-   最后，通过在E1000_TDT上加一来更新环形位置，并对TX_RING_SIZE进行调制。
-   如果 e1000_transmit() 成功地将 mbuf 添加到环上，返回 0。在失败时（例如，没有可用的描述符来传输 mbuf），返回 -1 以便调用者知道释放 mbuf。

实现e1000_recv的一些提示。

-   首先，通过获取E1000_RDT控制寄存器并在RX_RING_SIZE上加一个模数，向E1000询问下一个等待接收的数据包（如果有的话）所在的环形索引。
-   然后通过检查描述符的状态部分的E1000_RXD_STAT_DD位来检查是否有新数据包。如果没有，停止。
-   否则，将mbuf的m->len更新为描述符中报告的长度。使用 net_rx() 将 mbuf 传递给网络堆栈。
-   然后使用 mbufalloc() 分配一个新的 mbuf 来替换刚刚给 net_rx() 的那个。将其数据指针 (m->head) 编入描述符。将描述符的状态位清除为零。
-   最后，更新E1000_RDT寄存器，使其成为最后处理的环形描述符的索引。
-   e1000_init()用mbufs初始化RX环，你会想看看它是怎么做的，也许会借用代码。
-   在某些时候，曾经到达的数据包总数将超过环的大小（16）；确保你的代码能够处理这个问题。

你需要锁来应对xv6可能从多个进程中使用E1000，或者在中断到来时在内核线程中使用E1000的情况。

#### 实验答案

```c
int
e1000_transmit(struct mbuf *m)
{
  //
  // Your code here.
  //
  // the mbuf contains an ethernet frame; program it into
  // the TX descriptor ring so that the e1000 sends it. Stash
  // a pointer so that it can be freed after sending.
  //
  acquire(&e1000_lock);
  uint32 next_index = regs[E1000_TDT];
  if((tx_ring[next_index].status & E1000_TXD_STAT_DD) == 0){
      release(&e1000_lock);
      return -1;
  }
  if(tx_mbufs[next_index])
      mbuffree(tx_mbufs[next_index]);
  tx_ring[next_index].addr = (uint64)m->head;
  tx_ring[next_index].length = (uint16)m->len;
  tx_ring[next_index].cmd = E1000_TXD_CMD_EOP | E1000_TXD_CMD_RS;
  tx_mbufs[next_index] = m;
  regs[E1000_TDT] = (next_index+1)%TX_RING_SIZE;
  release(&e1000_lock);
  return 0;
}

```

```c
static void
e1000_recv(void)
{
  //
  // Your code here.
  //
  // Check for packets that have arrived from the e1000
  // Create and deliver an mbuf for each packet (using net_rx()).
  //
  uint32 next_index = (regs[E1000_RDT]+1)%RX_RING_SIZE;
  while(rx_ring[next_index].status & E1000_RXD_STAT_DD){
    if(rx_ring[next_index].length>MBUF_SIZE){
        panic("MBUF_SIZE OVERFLOW!");
    }
    rx_mbufs[next_index]->len = rx_ring[next_index].length;
    net_rx(rx_mbufs[next_index]);
    rx_mbufs[next_index] =  mbufalloc(0);
    rx_ring[next_index].addr = (uint64)rx_mbufs[next_index]->head;
    rx_ring[next_index].status = 0;
    next_index = (next_index+1)%RX_RING_SIZE;
  }
  regs[E1000_RDT] = (next_index-1)%RX_RING_SIZE;
}

```

#### 测试结果

```
== Test running nettests == 
$ make qemu-gdb
(3.4s) 
== Test   nettest: ping == 
  nettest: ping: OK 
== Test   nettest: single process == 
  nettest: single process: OK 
== Test   nettest: multi-process == 
  nettest: multi-process: OK 
== Test   nettest: DNS == 
  nettest: DNS: OK 
== Test time == 
time: OK 
Score: 100/100

```

