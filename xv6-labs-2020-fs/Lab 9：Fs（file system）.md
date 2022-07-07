## lab 9：Fs（file system）

#### 实验准备

通读第八章以及观看教学视频，理解目录与文件的组织方式，思考与阅读源码的实现方式。总的来说，本次作业难度不大，主要是对文件系统抽象的理解。

### Large files 

##### 题目大意

为xv6实现一个二级间接数据块，使得文件大小为65803（原来为256+12），为此需要修改bmap和itrunc。

##### 题目解答

这里由于有一个一级间接数据块可以参考，这里需要注意的是，bread对应一个brelse。同时，读完一个数据块需要释放，不能嵌套读取数据块。具体实现比较简单，注意一下细节即可。

```c
static uint
bmap(struct inode *ip, uint bn)
{
  uint addr, *a;
  struct buf *bp;
// begin of DIRECT BLOCKS
  if(bn < NDIRECT){
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  // end of DIRECT BLOCKS
  bn -= NDIRECT;

  if(bn < NINDIRECT){
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
    return addr;
  }
  //panic("cannot reach!");
  bn-=NINDIRECT;
  uint b = bn/NINDIRECT;
  bn = bn-b*NINDIRECT;
  if(b < NINDIRECT){
	if((addr = ip->addrs[NDIRECT+1]) == 0){
		ip->addrs[NDIRECT+1] = addr = balloc(ip->dev);
	}
	bp = bread(ip->dev, addr);
	a = (uint*)bp->data;
	if((addr = a[b]) == 0){
		a[b] = addr = balloc(ip->dev);
		log_write(bp);
	}
	brelse(bp);	
	
	bp = bread(ip->dev,addr);
	a = (uint*)bp->data;
	if((addr = a[bn]) == 0){
		a[bn] = addr = balloc(ip->dev);
		log_write(bp);
	}
	brelse(bp);

	return addr;
  }

  panic("bmap: out of range");
}
```

```c
void
itrunc(struct inode *ip)
{
  int i, j;
  struct buf *bp, *pt;
  uint *a,*b;

  for(i = 0; i < NDIRECT; i++){
    if(ip->addrs[i]){
      bfree(ip->dev, ip->addrs[i]);
      ip->addrs[i] = 0;
    }
  }

  if(ip->addrs[NDIRECT]){
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    a = (uint*)bp->data;
    for(j = 0; j < NINDIRECT; j++){
      if(a[j])
        bfree(ip->dev, a[j]);
    }
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }
  if(ip->addrs[NDIRECT+1]){
	  bp = bread(ip->dev, ip->addrs[NDIRECT+1]);
	  a = (uint*)bp->data;
	  for(j=0;j<NINDIRECT;j++){
		  pt = bread(ip->dev,a[j]);
		  b = (uint*)pt->data;
		  for(i=0;i<NINDIRECT;i++){
			  if(b[i])
				bfree(ip->dev,b[i]);
		  }
		  brelse(pt);
		  bfree(ip->dev,a[j]);
		  a[j] = 0;
	  }
	  brelse(bp);
	  bfree(ip->dev, ip->addrs[NDIRECT+1]);
	  ip->addrs[NDIRECT+1] = 0;
  }

  ip->size = 0;
  iupdate(ip);
}
```

### Symbolic links

##### 题目大意

在xv6中实现软链接，需要留意软链接的含义，首先软链接是一种文件类似于普通文件和目录文件，为此需要涉及创建这类文件和打开此类文件的实现。

##### 题目答案

类比硬链接文件，如link，首先进行参数获取，然后是文件创建，文件写入，最后保存退出。重点是如何打开此类文件，这里需要在open函数里面稍作修改，使得能够处理这类文件，这里对于这类文件，实现了一种follow_do的处理函数，用于跟随软链接的目标路径，具体实现如下：

```c++
uint64
sys_symlink(void){
    char  target[MAXPATH], path[MAXPATH];
    struct inode *ip;
    int n =  argstr(0, target, MAXPATH);
    if(n<0||argstr(1, path, MAXPATH) < 0)
        return -1;
    begin_op();
    if((ip = create(path, T_SYMLINK, 0, 0)) ==0 ){
        end_op();
        return -1;
    }
    if(writei(ip, 0, (uint64)target, 0, n)!=n){
        iunlockput(ip);
        end_op();
        return -1;
    }
    iunlockput(ip);
    end_op();
    return 0;
}        
```

这里需要注意follow_do如果正确返回的是加锁的ip，不正确的话，返回的是解锁的ip，为此这里不需要继续解锁否则出现解锁panic

```c++
    if((omode & O_NOFOLLOW) == 0&&(ip->type == T_SYMLINK)){
        if((ip = follow_do(ip))==0){                       
            //printf("cannot reach here!\n");
            //iunlockput(ip);
            end_op();
            return -1; 
        }   

```

```c++
struct inode*
follow_do(struct inode* ip)
{	
	static int depth =0;
	//To see the depth
	if(depth>10){
		depth = 0;
        iunlockput(ip);
		return 0;
	}
	char ps[MAXPATH];
	//Deal with symbolic files to get target path
	if(ip->type == T_SYMLINK){
		if(readi(ip, 0, (uint64)ps,0,  sizeof(ps))<=0){
			iunlockput(ip);
			return 0;
		}
		iunlockput(ip);
		if((ip = namei(ps))==0){
			//printf("follow_do: namei error!\n");
			return 0;
		}
		ilock(ip);
		depth++;
		return follow_do(ip);
	}
	else{
		depth = 0;
		return ip;
	}
}
```

### 测试结果

在主目录下面编写time.txt，然后make grade，进行评分测试

```c++
== Test running bigfile == 
$ make qemu-gdb
running bigfile: OK (98.3s) 
== Test running symlinktest == 
$ make qemu-gdb
(0.5s) 
== Test   symlinktest: symlinks == 
  symlinktest: symlinks: OK 
== Test   symlinktest: concurrent symlinks == 
  symlinktest: concurrent symlinks: OK 
== Test usertests == 
$ make qemu-gdb
usertests: OK (160.8s) 
== Test time == 
time: OK 
Score: 100/100
```

