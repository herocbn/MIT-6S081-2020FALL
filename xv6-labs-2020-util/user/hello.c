/*************************************************************************
    > File Name: hello.c
    > Author: cbn
    > Mail: cbn@hust.edu.cn 
    > Created Time: 2022年04月04日 星期一 00时00分49秒
 ************************************************************************/

#include"kernel/types.h"
#include"kernel/stat.h"
#include"kernel/param.h"
#include"user/user.h"

int main(){
	printf("Hello XV6!\n");
	hello();
	exit(0);
}

