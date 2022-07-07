// Buffer cache.
//
// The buffer cache is a linked list of buf structures holding
// cached copies of disk block contents.  Caching disk blocks
// in memory reduces the number of disk reads and also provides
// a synchronization point for disk blocks used by multiple processes.
//
// Interface:
// * To get a buffer for a particular disk block, call bread.
// * After changing buffer data, call bwrite to write it to disk.
// * When done with the buffer, call brelse.
// * Do not use the buffer after calling brelse.
// * Only one process at a time can use a buffer,
//     so do not keep them longer than necessary.


#include "types.h"
#include "param.h"
#include "spinlock.h"
#include "sleeplock.h"
#include "riscv.h"
#include "defs.h"
#include "fs.h"
#include "buf.h"
#define BUCKETNUM 13
#define HASH(blockno) ((blockno)%(BUCKETNUM))

struct {
  struct spinlock lock;
  struct spinlock locks[BUCKETNUM];
  struct spinlock hashlock;
  struct buf buf[NBUF];
  struct buf buckets[BUCKETNUM];
  uint size;
  // Linked list of all buffers, through prev/next.
  // Sorted by how recently the buffer was used.
  // head.next is most recent, head.prev is least.
 // struct buf head;
} bcache;

void
binit(void)
{
  struct buf *b;

  initlock(&bcache.lock, "bcache");
  initlock(&bcache.hashlock, "hashlock");
  for(int i=0;i<BUCKETNUM;i++){
	  initlock(&bcache.locks[i], "bcache.bucket");
  }
  // Create linked list of buffers
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    initsleeplock(&b->lock, "buffer");
  }
}

// Look through buffer cache for block on device dev.
// If not found, allocate a buffer.
// In either case, return locked buffer.
static struct buf*
bget(uint dev, uint blockno)
{
  struct buf *b,*p;
  p=0;
  uint time = -1;
  int index = HASH(blockno);
  acquire(&bcache.locks[index]);
  for(b = bcache.buckets[index].next;b != 0;b = b->next){
	  if((b->blockno == blockno)&&(b->dev == dev)){
		  b->refcnt++;
		  release(&bcache.locks[index]);
		  acquiresleep(&b->lock);
		  return b;
	  }
  }
	//not cached ,but still have free blocks
	acquire(&bcache.lock);
	if(bcache.size<NBUF){
		b = &bcache.buf[bcache.size++];
		b->blockno = blockno;
		b->dev = dev;
		b->valid = 0;
		b->refcnt = 1;
		b->next = bcache.buckets[index].next;
		bcache.buckets[index].next = b;
		release(&bcache.lock);
		release(&bcache.locks[index]);
		acquiresleep(&b->lock);
		return b;
	}
	release(&bcache.lock);
	release(&bcache.locks[index]);
	//not cached but don't have free blocks then must evict
	//find in the index list
	acquire(&bcache.hashlock);
	int j=0;
	for(int i=0;i<BUCKETNUM;i++){
		acquire(&bcache.locks[i]);
		for(b=bcache.buckets[i].next;b!=0;b = b->next){
			if(b->refcnt==0 && b->time_stamp<time){
				p = b;
				j = i;
				time = b->time_stamp;
			}
		}
		release(&bcache.locks[i]);
	}
		
	acquire(&bcache.locks[j]);
    for(b=&bcache.buckets[j];b->next!=0;b = b->next){
        if(b->next == p){
            break;
        }
    }
	if(j != index){
		acquire(&bcache.locks[index]);
	}
    if(p){

        p->blockno = blockno;
        p->dev = dev;
        p->refcnt = 1;
        p->valid = 0;
        b->next = p->next;
        p->next = bcache.buckets[index].next;
        bcache.buckets[index].next = p;
		if(j!=index)
	        release(&bcache.locks[index]);
        release(&bcache.locks[j]);
		release(&bcache.hashlock);
        acquiresleep(&p->lock);
        return p;

    }
	panic("no free blocks");

}
/*
//high racing version
  acquire(&bcache.lock);
  // Is the block already cached?
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    if(b->dev == dev && b->blockno == blockno){
      b->refcnt++;
      release(&bcache.lock);
      acquiresleep(&b->lock);
      return b;
    }
  }

  // Not cached.
  // Recycle the least recently used (LRU) unused buffer.
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    if(b->refcnt == 0) {
      b->dev = dev;
      b->blockno = blockno;
      b->valid = 0;
      b->refcnt = 1;
      release(&bcache.lock);
      acquiresleep(&b->lock);
      return b;
    }
  }
  panic("bget: no buffers");
}
*/

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
  if(!holdingsleep(&b->lock))
    panic("bwrite");
  virtio_disk_rw(b, 1);
}

// Release a locked buffer.
// Move to the head of the most-recently-used list.
extern uint ticks;
void
brelse(struct buf *b)
{
  int index;
  if(!holdingsleep(&b->lock))
    panic("brelse");
  releasesleep(&b->lock);
  index = HASH(b->blockno);
  acquire(&bcache.locks[index]);

  b->refcnt--;
  if (b->refcnt == 0) {
    // no one is waiting for it.
	b->time_stamp = ticks;
  }
  
  release(&bcache.locks[index]);
}

void
bpin(struct buf *b) {
  int index = HASH(b->blockno);
  acquire(&bcache.locks[index]);
  b->refcnt++;
  release(&bcache.locks[index]);
}

void
bunpin(struct buf *b) {
  int index = HASH(b->blockno);
  acquire(&bcache.locks[index]);
  b->refcnt--;
  release(&bcache.locks[index]);
}


