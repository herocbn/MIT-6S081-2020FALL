/*************************************************************************
    > File Name: cow.c
    > Author: cbn
    > Mail: cbn@hust.edu.cn 
    > Created Time: 2022年05月10日 星期二 23时30分09秒
 ************************************************************************/

#include "param.h"                                                                                                                              
#include "types.h"
#include "memlayout.h"
#include "riscv.h"
#include "defs.h"
#include "spinlock.h"

struct{    
    struct spinlock lock;
    uint64 count;
} cow_counts[PHYSTOP>>12]; 


void
inc_counts(uint64 pa){
    pa = PGROUNDDOWN(pa);
    if(pa>=PHYSTOP){
        panic("inc_counts");
    }
    uint64 index = pa/PGSIZE;
    acquire(&cow_counts[index].lock);
    cow_counts[index].count++;
    release(&cow_counts[index].lock);
}
uint64
dec_counts(uint64 pa){
    pa = PGROUNDDOWN(pa);
    if(pa>=PHYSTOP){
        panic("dec_counts");
    }
    uint64 index = pa/PGSIZE;
    acquire(&cow_counts[index].lock);
    cow_counts[index].count--;
    uint64 count = cow_counts[index].count;
    release(&cow_counts[index].lock);
    return count;                                                                                                                                       
}


