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

	char *args[MAXARG];
	int i;
	char buf[512];
	// Get the main argv of exec 
	for(i=1;i<argc;i++){
		args[i-1] = argv[i];
	}
	//Get the rest argv of exec and excute
	int n;
	char *p;
	while(1){
		p = buf;
		while((n = read(0, p, 1))&&(*p!='\n')){
			p++;
		}
		*p = '\0';
		if(p!=buf){
			if(fork()==0){
				args[argc-1] = buf;
				exec(argv[1], args);
				exit(1);
			}
		}
		wait(0);
		if(n<=0){
			exit(1);
		}
	}
	exit(0);
}

