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
}

