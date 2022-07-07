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
