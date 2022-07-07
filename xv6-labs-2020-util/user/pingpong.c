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
