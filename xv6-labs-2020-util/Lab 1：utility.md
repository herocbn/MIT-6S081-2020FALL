# 6S081 OS-LAB



Before carry out these labs , you must read materials on the official websites carefully, otherwise, you will be in great trouble.

Materials are the fallowings:

[1]: https://pdos.csail.mit.edu/6.828/2020/xv6/book-riscv-rev1.pdf
[2]: https://pdos.csail.mit.edu/6.828/2020/labs/util.html
[3]: https://swtch.com/~rsc/thread/

##  Lab 1: Xv6 and Unix utilities

------

#### sleep(easy)

------

Implement the UNIX program `sleep` for xv6

##### Example:

Run the program from the xv6 shell:

```c
      $ make qemu
      ...
      init: starting sh
      $ sleep 10
      (nothing happens for a little while)
      $
```

##### Preperation:

Here , the number behind the function sleep is  a user-specified number of ticks, which is not the really time like seconds, minutes, hours. Just attention this.

##### Reference Items:

```c
/*************************************************************************
    > File Name: sleep.c
    > Author: cbn
    > Mail: cbn@hust.edu.cn 
    > Created Time: 2022年03月24日 星期四 19时56分24秒
 ************************************************************************/

#include "kernel/types.h"
#include "user/user.h"
int main(int argc, char *argv[]){
	if(argc != 2){
		printf("%s: need one argument!",argv[0]);
		exit(1);
	}
	int time = atoi(argv[1]);
	sleep(time);
	exit(0);
}
```

------

#### pingpong(easy)

------

*Write a program that uses UNIX system calls to ''ping-pong'' a byte between two processes over a pair of pipes, one for each direction.*

##### Example:

Run the program from the xv6 shell and it should produce the following output:

```c
 	$ make qemu
    ...
    init: starting sh
    $ pingpong
    4: received ping
    3: received pong
    $
```

##### preperation:

Create a pair of double-direction pipes. 

You should know how to use basic syscalls.

##### Reference Items:

```c
/*************************************************************************
    > File Name: pingpong.c
    > Author: cbn
    > Mail: cbn@hust.edu.cn 
    > Created Time: 2022年03月24日 星期四 23时35分48秒
 ************************************************************************/

#include "kernel/types.h"
#include "user/user.h"
int main(int argc, char *argv[]){
	int p1[2], p2[2];
	pipe(p1);
	pipe(p2);
	if(fork() == 0){
		close(p1[1]);
		close(p2[0]);
		char buf;
		if(read(p1[0], &buf, 1)){
			printf("%d: received ping\n", getpid());
		}
		write(p2[1], &buf, 1);
		exit(0);

	}
	else{
		close(p1[0]);
		char buf ='1';
		write(p1[1], &buf,1);
		char ger;
		if(read(p2[0],&ger,1)){
			printf("%d: received pong\n", getpid());
		}
		exit(0);
	}
	
}
```

------

#### primes(hard)

------

*Write a concurrent version of **prime sieve** using pipes. This idea is due to Doug McIlroy, inventor of Unix pipes.*

![img](https://swtch.com/~rsc/thread/sieve.gif)

##### Example:

Your solution is correct if it implements a pipe-based sieve and produces the following output:

```c
    $ make qemu
    ...
    init: starting sh
    $ primes
    prime 2
    prime 3
    prime 5
    prime 7
    prime 11
    prime 13
    prime 17
    prime 19
    prime 23
    prime 29
    prime 31
    $
```

##### preperation:

1. You should read the materials carefully. 
2. To finish this lab, you have to be accquainted yourself with the usage of pipe() and fork(). 
3. At last, just try it until you see the ans!

##### Reference Items:

```c
/*************************************************************************
    > File Name: primes.c
    > Author: cbn
    > Mail: cbn@hust.edu.cn 
    > Created Time: 2022年03月26日 星期六 01时57分30秒
 ************************************************************************/
#include"kernel/types.h"
#include"kernel/stat.h"
#include"user/user.h"
void prime(int p_left[]){
	//judge exit conditions
	int p, n;
	if(read(p_left[0], &p, 1)==0){
		close(p_left[0]);
		exit(0);
	}
	int p_right[2];
	pipe(p_right);
	//son recursion
	if(fork() == 0){
		close(p_left[0]);
		close(p_right[1]);
		prime(p_right);
	}
	//parent send rest to p_right 
	else{
		printf("prime %d\n", p);
		close(p_right[0]);
		while(read(p_left[0], &n, 1)){
			if(n%p){
				write(p_right[1], &n, 1);
			}
		}
		close(p_left[0]);
		close(p_right[1]);
	}
	exit(0);

}


int main(){
	int p_left[2], i;
	pipe(p_left);
	
	if(fork()==0){
		close(p_left[1]);
		prime(p_left);
	}
	else{
		close(p_left[0]);
		for(i=2;i<36;i++){
			write(p_left[1], &i, 1);
		}
		close(p_left[1]);
		wait(0);
	}
	exit(0);
}
```

------

#### find(moderate)

------

**Write a simple version of the UNIX find program: find all the files in a directory tree with a specific name.*  

##### *Expected Output:* 

```c
    $ make qemu
    ...
    init: starting sh
    $ echo > b
    $ mkdir a
    $ echo > a/b
    $ find . b
    ./b
    ./a/b
```

##### *Preparation:* 

1. You should master the ls(in ls.c) func, which is the core of this work. 
2.  After this,  you should know dirent file, *sizeof()* (which contains basic variables and arrays)....When use the function *sizeof()* to a struct , just split the struct into basic variables!! 

##### *Reference Items:*

```c
 /*************************************************************************
    > File Name: find.c
    > Author: cbn
    > Mail: cbn@hust.edu.cn 
    > Created Time: 2022年03月25日 星期五 19时45分10秒
 ************************************************************************/

#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"
#include "kernel/fs.h"
void search(const char *path, const char *name){
	int fd;
	struct stat st;
	struct dirent de;
	char buf[512];
	char *p;
	if((fd = open(path, 0))<0){
		fprintf(2, "find: cannot open %s\n", path);
		return;
	}
	strcpy(buf, path);
	p = buf+strlen(buf);
	*p='/';
	p++;
    // Attention here :*p++ the same as (*p and then p++),better to split them
    
	while(read(fd, &de, sizeof(de)) == sizeof(de)){
		//empty dirent
		if(de.inum == 0)
			continue;
		//dirents  "." and ".."
		if((strcmp(".",de.name)==0)||(strcmp(de.name,"..")==0)){
			continue;
		} 
		memmove(p, de.name,DIRSIZ);
		p[DIRSIZ] = 0;
		if(stat(buf, &st) < 0){
        	fprintf(2, "find: cannot stat %s\n", buf);
			continue;
		}
        //Here I make a mistake before.
        //Use switch case and trust me!!
        //Because st.type with three values, and I missed one before
		switch(st.type){
			case T_FILE: if(!strcmp(de.name,name))
							 printf("%s\n", buf);
						 break;
			case T_DIR:  search(buf, name);
						 break;
		}
	}
	close (fd);
	return;
}
int main(int argc, char *argv[]){
	if(argc != 3){
		fprintf(2, "arguments number error\n");
		exit(1);
	}
	search(argv[1], argv[2]);
	exit(0);
    // Here is a XV6 feature
    // main()function must end with exit()
}
```

------

#### xargs(moderate)

------

*Write a simple version of the UNIX xargs program: *read lines from the standard input and run a command for each line, supplying the line as arguments to the command. Your solution should be in the file user/xargs.c.*

##### *Example:*

The following example illustrates xargs behavior:     

```c
 $ echo hello too | xargs echo bye
    bye hello too
 $
```

Test your program with 

```c
sh < xargstest.sh
```

 in the qemu (if you are correct ,then get the output below)

```
 $ make qemu
 	 ...
 	 init: starting sh
 	 $ sh < xargstest.sh
  	 $ $ $ $ $ $ hello
  	 hello
  	 hello
 	 $ $  

```

##### *Prepation:* 

1. Firstly,  you should be clearly aware of the question, or you may be in truble in programming as I faced.
2. Just ignore those unimportant sentences like : Please note that xargs on UNIX makes an optimization....
3. I am really confused about these sentences above...

##### *Reference Items:*

```c
/*************************************************************************
    > File Name: xargs.c
    > Author: cbn
    > Mail: cbn@hust.edu.cn 
    > Created Time: 2022年03月27日 星期日 20时24分01秒
 ************************************************************************/

#include"kernel/types.h"
#include"kernel/stat.h"
#include"kernel/param.h"
#include"user/user.h"

int main(int argc, char *argv[]){

​	char *args[MAXARG];
​	int i;
​	char buf[512];
​	// Get the main argv of exec 
​	for(i=1;i<argc;i++){
​		args[i-1] = argv[i];
​	}
​	//Get the rest argv of exec and excute
​	int n;
​	while(1){
​        // Read until meet '\n' 
​		char *p = buf;
​        //Read until meet '\n' 
​		while((n = read(0, p, 1))&&(*p!='\n')){
​			p++;
​            //Break conditions:n<=0 or *p='\n'
​		}
​		*p = '\0';
​        // Avoid EOF and exec the args
​		if(p!=buf){
​			if(fork()==0){
​				args[argc-1] = buf;
​				args[argc] = 0;
​				exec(argv[1], args);
​				printf("I can not be printed\n");
​			}
​			wait(0);
​		}
​        //EOF ans
​		if(n<=0){
​			break;
​		}
​	}
​	exit(0);
}
```

### Checkout

------

Use tool package in xv6 lab to test your ans!

```c
$ make grade
```

![image-20220329205311320](C:\Users\17386\AppData\Roaming\Typora\typora-user-images\image-20220329205311320.png)

Test time file is designed for MIT undergraduates. Here we can just ignore it !

That's all for Lab 1.

> Please contact with me if existing errors above. 
