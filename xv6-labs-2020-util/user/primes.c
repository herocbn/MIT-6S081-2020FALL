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
