
user/_find：     文件格式 elf64-littleriscv


Disassembly of section .text:

0000000000000000 <search>:

#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"
#include "kernel/fs.h"
void search(const char *path, const char *name){
   0:	d9010113          	addi	sp,sp,-624
   4:	26113423          	sd	ra,616(sp)
   8:	26813023          	sd	s0,608(sp)
   c:	24913c23          	sd	s1,600(sp)
  10:	25213823          	sd	s2,592(sp)
  14:	25313423          	sd	s3,584(sp)
  18:	25413023          	sd	s4,576(sp)
  1c:	23513c23          	sd	s5,568(sp)
  20:	23613823          	sd	s6,560(sp)
  24:	1c80                	addi	s0,sp,624
  26:	892a                	mv	s2,a0
  28:	89ae                	mv	s3,a1
	int fd;
	struct stat st;
	struct dirent de;
	char buf[512];
	char *p;
	if((fd = open(path, 0))<0){
  2a:	4581                	li	a1,0
  2c:	00000097          	auipc	ra,0x0
  30:	44a080e7          	jalr	1098(ra) # 476 <open>
  34:	0e054363          	bltz	a0,11a <search+0x11a>
  38:	84aa                	mv	s1,a0
		fprintf(2, "find: cannot open %s\n", path);
		return;
	}
	strcpy(buf, path);
  3a:	85ca                	mv	a1,s2
  3c:	d9840513          	addi	a0,s0,-616
  40:	00000097          	auipc	ra,0x0
  44:	18a080e7          	jalr	394(ra) # 1ca <strcpy>
	p = buf+strlen(buf);
  48:	d9840513          	addi	a0,s0,-616
  4c:	00000097          	auipc	ra,0x0
  50:	1c6080e7          	jalr	454(ra) # 212 <strlen>
  54:	1502                	slli	a0,a0,0x20
  56:	9101                	srli	a0,a0,0x20
  58:	d9840793          	addi	a5,s0,-616
  5c:	00a78933          	add	s2,a5,a0
	*p='/';
  60:	02f00793          	li	a5,47
  64:	00f90023          	sb	a5,0(s2)
	p++;
  68:	00190b13          	addi	s6,s2,1
	while(read(fd, &de, sizeof(de)) == sizeof(de)){
		//empty dirent
		if(de.inum == 0)
			continue;
		//dirents  "." and ".."
		if((strcmp(".",de.name)==0)||(strcmp(de.name,"..")==0)){
  6c:	00001a17          	auipc	s4,0x1
  70:	8fca0a13          	addi	s4,s4,-1796 # 968 <malloc+0x100>
  74:	00001a97          	auipc	s5,0x1
  78:	8fca8a93          	addi	s5,s5,-1796 # 970 <malloc+0x108>
	while(read(fd, &de, sizeof(de)) == sizeof(de)){
  7c:	4641                	li	a2,16
  7e:	f9840593          	addi	a1,s0,-104
  82:	8526                	mv	a0,s1
  84:	00000097          	auipc	ra,0x0
  88:	3ca080e7          	jalr	970(ra) # 44e <read>
  8c:	47c1                	li	a5,16
  8e:	0cf51563          	bne	a0,a5,158 <search+0x158>
		if(de.inum == 0)
  92:	f9845783          	lhu	a5,-104(s0)
  96:	d3fd                	beqz	a5,7c <search+0x7c>
		if((strcmp(".",de.name)==0)||(strcmp(de.name,"..")==0)){
  98:	f9a40593          	addi	a1,s0,-102
  9c:	8552                	mv	a0,s4
  9e:	00000097          	auipc	ra,0x0
  a2:	148080e7          	jalr	328(ra) # 1e6 <strcmp>
  a6:	d979                	beqz	a0,7c <search+0x7c>
  a8:	85d6                	mv	a1,s5
  aa:	f9a40513          	addi	a0,s0,-102
  ae:	00000097          	auipc	ra,0x0
  b2:	138080e7          	jalr	312(ra) # 1e6 <strcmp>
  b6:	d179                	beqz	a0,7c <search+0x7c>
			continue;
		} 
		memmove(p, de.name,DIRSIZ);
  b8:	4639                	li	a2,14
  ba:	f9a40593          	addi	a1,s0,-102
  be:	855a                	mv	a0,s6
  c0:	00000097          	auipc	ra,0x0
  c4:	2c4080e7          	jalr	708(ra) # 384 <memmove>
		p[DIRSIZ] = 0;
  c8:	000907a3          	sb	zero,15(s2)
		if(stat(buf, &st) < 0){
  cc:	fa840593          	addi	a1,s0,-88
  d0:	d9840513          	addi	a0,s0,-616
  d4:	00000097          	auipc	ra,0x0
  d8:	222080e7          	jalr	546(ra) # 2f6 <stat>
  dc:	04054a63          	bltz	a0,130 <search+0x130>
        	fprintf(2, "find: cannot stat %s\n", buf);
			continue;
		}
		switch(st.type){
  e0:	fb041783          	lh	a5,-80(s0)
  e4:	0007869b          	sext.w	a3,a5
  e8:	4705                	li	a4,1
  ea:	04e68f63          	beq	a3,a4,148 <search+0x148>
  ee:	4709                	li	a4,2
  f0:	f8e696e3          	bne	a3,a4,7c <search+0x7c>
			case T_FILE: if(!strcmp(de.name,name))
  f4:	85ce                	mv	a1,s3
  f6:	f9a40513          	addi	a0,s0,-102
  fa:	00000097          	auipc	ra,0x0
  fe:	0ec080e7          	jalr	236(ra) # 1e6 <strcmp>
 102:	fd2d                	bnez	a0,7c <search+0x7c>
							 printf("%s\n", buf);
 104:	d9840593          	addi	a1,s0,-616
 108:	00001517          	auipc	a0,0x1
 10c:	88850513          	addi	a0,a0,-1912 # 990 <malloc+0x128>
 110:	00000097          	auipc	ra,0x0
 114:	6a0080e7          	jalr	1696(ra) # 7b0 <printf>
 118:	b795                	j	7c <search+0x7c>
		fprintf(2, "find: cannot open %s\n", path);
 11a:	864a                	mv	a2,s2
 11c:	00001597          	auipc	a1,0x1
 120:	83458593          	addi	a1,a1,-1996 # 950 <malloc+0xe8>
 124:	4509                	li	a0,2
 126:	00000097          	auipc	ra,0x0
 12a:	65c080e7          	jalr	1628(ra) # 782 <fprintf>
		return;
 12e:	a815                	j	162 <search+0x162>
        	fprintf(2, "find: cannot stat %s\n", buf);
 130:	d9840613          	addi	a2,s0,-616
 134:	00001597          	auipc	a1,0x1
 138:	84458593          	addi	a1,a1,-1980 # 978 <malloc+0x110>
 13c:	4509                	li	a0,2
 13e:	00000097          	auipc	ra,0x0
 142:	644080e7          	jalr	1604(ra) # 782 <fprintf>
			continue;
 146:	bf1d                	j	7c <search+0x7c>
						 break;
			case T_DIR:  search(buf, name);
 148:	85ce                	mv	a1,s3
 14a:	d9840513          	addi	a0,s0,-616
 14e:	00000097          	auipc	ra,0x0
 152:	eb2080e7          	jalr	-334(ra) # 0 <search>
						 break;
 156:	b71d                	j	7c <search+0x7c>
		}
	}
	close (fd);
 158:	8526                	mv	a0,s1
 15a:	00000097          	auipc	ra,0x0
 15e:	304080e7          	jalr	772(ra) # 45e <close>
	return;
}
 162:	26813083          	ld	ra,616(sp)
 166:	26013403          	ld	s0,608(sp)
 16a:	25813483          	ld	s1,600(sp)
 16e:	25013903          	ld	s2,592(sp)
 172:	24813983          	ld	s3,584(sp)
 176:	24013a03          	ld	s4,576(sp)
 17a:	23813a83          	ld	s5,568(sp)
 17e:	23013b03          	ld	s6,560(sp)
 182:	27010113          	addi	sp,sp,624
 186:	8082                	ret

0000000000000188 <main>:
int main(int argc, char *argv[]){
 188:	1141                	addi	sp,sp,-16
 18a:	e406                	sd	ra,8(sp)
 18c:	e022                	sd	s0,0(sp)
 18e:	0800                	addi	s0,sp,16
	if(argc != 3){
 190:	470d                	li	a4,3
 192:	02e50063          	beq	a0,a4,1b2 <main+0x2a>
		fprintf(2, "arguments number error\n");
 196:	00001597          	auipc	a1,0x1
 19a:	80258593          	addi	a1,a1,-2046 # 998 <malloc+0x130>
 19e:	4509                	li	a0,2
 1a0:	00000097          	auipc	ra,0x0
 1a4:	5e2080e7          	jalr	1506(ra) # 782 <fprintf>
		exit(1);
 1a8:	4505                	li	a0,1
 1aa:	00000097          	auipc	ra,0x0
 1ae:	28c080e7          	jalr	652(ra) # 436 <exit>
 1b2:	87ae                	mv	a5,a1
	}
	search(argv[1], argv[2]);
 1b4:	698c                	ld	a1,16(a1)
 1b6:	6788                	ld	a0,8(a5)
 1b8:	00000097          	auipc	ra,0x0
 1bc:	e48080e7          	jalr	-440(ra) # 0 <search>
	exit(0);
 1c0:	4501                	li	a0,0
 1c2:	00000097          	auipc	ra,0x0
 1c6:	274080e7          	jalr	628(ra) # 436 <exit>

00000000000001ca <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
 1ca:	1141                	addi	sp,sp,-16
 1cc:	e422                	sd	s0,8(sp)
 1ce:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 1d0:	87aa                	mv	a5,a0
 1d2:	0585                	addi	a1,a1,1
 1d4:	0785                	addi	a5,a5,1
 1d6:	fff5c703          	lbu	a4,-1(a1)
 1da:	fee78fa3          	sb	a4,-1(a5)
 1de:	fb75                	bnez	a4,1d2 <strcpy+0x8>
    ;
  return os;
}
 1e0:	6422                	ld	s0,8(sp)
 1e2:	0141                	addi	sp,sp,16
 1e4:	8082                	ret

00000000000001e6 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 1e6:	1141                	addi	sp,sp,-16
 1e8:	e422                	sd	s0,8(sp)
 1ea:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 1ec:	00054783          	lbu	a5,0(a0)
 1f0:	cb91                	beqz	a5,204 <strcmp+0x1e>
 1f2:	0005c703          	lbu	a4,0(a1)
 1f6:	00f71763          	bne	a4,a5,204 <strcmp+0x1e>
    p++, q++;
 1fa:	0505                	addi	a0,a0,1
 1fc:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 1fe:	00054783          	lbu	a5,0(a0)
 202:	fbe5                	bnez	a5,1f2 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 204:	0005c503          	lbu	a0,0(a1)
}
 208:	40a7853b          	subw	a0,a5,a0
 20c:	6422                	ld	s0,8(sp)
 20e:	0141                	addi	sp,sp,16
 210:	8082                	ret

0000000000000212 <strlen>:

uint
strlen(const char *s)
{
 212:	1141                	addi	sp,sp,-16
 214:	e422                	sd	s0,8(sp)
 216:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 218:	00054783          	lbu	a5,0(a0)
 21c:	cf91                	beqz	a5,238 <strlen+0x26>
 21e:	0505                	addi	a0,a0,1
 220:	87aa                	mv	a5,a0
 222:	4685                	li	a3,1
 224:	9e89                	subw	a3,a3,a0
 226:	00f6853b          	addw	a0,a3,a5
 22a:	0785                	addi	a5,a5,1
 22c:	fff7c703          	lbu	a4,-1(a5)
 230:	fb7d                	bnez	a4,226 <strlen+0x14>
    ;
  return n;
}
 232:	6422                	ld	s0,8(sp)
 234:	0141                	addi	sp,sp,16
 236:	8082                	ret
  for(n = 0; s[n]; n++)
 238:	4501                	li	a0,0
 23a:	bfe5                	j	232 <strlen+0x20>

000000000000023c <memset>:

void*
memset(void *dst, int c, uint n)
{
 23c:	1141                	addi	sp,sp,-16
 23e:	e422                	sd	s0,8(sp)
 240:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 242:	ca19                	beqz	a2,258 <memset+0x1c>
 244:	87aa                	mv	a5,a0
 246:	1602                	slli	a2,a2,0x20
 248:	9201                	srli	a2,a2,0x20
 24a:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 24e:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 252:	0785                	addi	a5,a5,1
 254:	fee79de3          	bne	a5,a4,24e <memset+0x12>
  }
  return dst;
}
 258:	6422                	ld	s0,8(sp)
 25a:	0141                	addi	sp,sp,16
 25c:	8082                	ret

000000000000025e <strchr>:

char*
strchr(const char *s, char c)
{
 25e:	1141                	addi	sp,sp,-16
 260:	e422                	sd	s0,8(sp)
 262:	0800                	addi	s0,sp,16
  for(; *s; s++)
 264:	00054783          	lbu	a5,0(a0)
 268:	cb99                	beqz	a5,27e <strchr+0x20>
    if(*s == c)
 26a:	00f58763          	beq	a1,a5,278 <strchr+0x1a>
  for(; *s; s++)
 26e:	0505                	addi	a0,a0,1
 270:	00054783          	lbu	a5,0(a0)
 274:	fbfd                	bnez	a5,26a <strchr+0xc>
      return (char*)s;
  return 0;
 276:	4501                	li	a0,0
}
 278:	6422                	ld	s0,8(sp)
 27a:	0141                	addi	sp,sp,16
 27c:	8082                	ret
  return 0;
 27e:	4501                	li	a0,0
 280:	bfe5                	j	278 <strchr+0x1a>

0000000000000282 <gets>:

char*
gets(char *buf, int max)
{
 282:	711d                	addi	sp,sp,-96
 284:	ec86                	sd	ra,88(sp)
 286:	e8a2                	sd	s0,80(sp)
 288:	e4a6                	sd	s1,72(sp)
 28a:	e0ca                	sd	s2,64(sp)
 28c:	fc4e                	sd	s3,56(sp)
 28e:	f852                	sd	s4,48(sp)
 290:	f456                	sd	s5,40(sp)
 292:	f05a                	sd	s6,32(sp)
 294:	ec5e                	sd	s7,24(sp)
 296:	1080                	addi	s0,sp,96
 298:	8baa                	mv	s7,a0
 29a:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 29c:	892a                	mv	s2,a0
 29e:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 2a0:	4aa9                	li	s5,10
 2a2:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 2a4:	89a6                	mv	s3,s1
 2a6:	2485                	addiw	s1,s1,1
 2a8:	0344d863          	bge	s1,s4,2d8 <gets+0x56>
    cc = read(0, &c, 1);
 2ac:	4605                	li	a2,1
 2ae:	faf40593          	addi	a1,s0,-81
 2b2:	4501                	li	a0,0
 2b4:	00000097          	auipc	ra,0x0
 2b8:	19a080e7          	jalr	410(ra) # 44e <read>
    if(cc < 1)
 2bc:	00a05e63          	blez	a0,2d8 <gets+0x56>
    buf[i++] = c;
 2c0:	faf44783          	lbu	a5,-81(s0)
 2c4:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 2c8:	01578763          	beq	a5,s5,2d6 <gets+0x54>
 2cc:	0905                	addi	s2,s2,1
 2ce:	fd679be3          	bne	a5,s6,2a4 <gets+0x22>
  for(i=0; i+1 < max; ){
 2d2:	89a6                	mv	s3,s1
 2d4:	a011                	j	2d8 <gets+0x56>
 2d6:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 2d8:	99de                	add	s3,s3,s7
 2da:	00098023          	sb	zero,0(s3)
  return buf;
}
 2de:	855e                	mv	a0,s7
 2e0:	60e6                	ld	ra,88(sp)
 2e2:	6446                	ld	s0,80(sp)
 2e4:	64a6                	ld	s1,72(sp)
 2e6:	6906                	ld	s2,64(sp)
 2e8:	79e2                	ld	s3,56(sp)
 2ea:	7a42                	ld	s4,48(sp)
 2ec:	7aa2                	ld	s5,40(sp)
 2ee:	7b02                	ld	s6,32(sp)
 2f0:	6be2                	ld	s7,24(sp)
 2f2:	6125                	addi	sp,sp,96
 2f4:	8082                	ret

00000000000002f6 <stat>:

int
stat(const char *n, struct stat *st)
{
 2f6:	1101                	addi	sp,sp,-32
 2f8:	ec06                	sd	ra,24(sp)
 2fa:	e822                	sd	s0,16(sp)
 2fc:	e426                	sd	s1,8(sp)
 2fe:	e04a                	sd	s2,0(sp)
 300:	1000                	addi	s0,sp,32
 302:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 304:	4581                	li	a1,0
 306:	00000097          	auipc	ra,0x0
 30a:	170080e7          	jalr	368(ra) # 476 <open>
  if(fd < 0)
 30e:	02054563          	bltz	a0,338 <stat+0x42>
 312:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 314:	85ca                	mv	a1,s2
 316:	00000097          	auipc	ra,0x0
 31a:	178080e7          	jalr	376(ra) # 48e <fstat>
 31e:	892a                	mv	s2,a0
  close(fd);
 320:	8526                	mv	a0,s1
 322:	00000097          	auipc	ra,0x0
 326:	13c080e7          	jalr	316(ra) # 45e <close>
  return r;
}
 32a:	854a                	mv	a0,s2
 32c:	60e2                	ld	ra,24(sp)
 32e:	6442                	ld	s0,16(sp)
 330:	64a2                	ld	s1,8(sp)
 332:	6902                	ld	s2,0(sp)
 334:	6105                	addi	sp,sp,32
 336:	8082                	ret
    return -1;
 338:	597d                	li	s2,-1
 33a:	bfc5                	j	32a <stat+0x34>

000000000000033c <atoi>:

int
atoi(const char *s)
{
 33c:	1141                	addi	sp,sp,-16
 33e:	e422                	sd	s0,8(sp)
 340:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 342:	00054683          	lbu	a3,0(a0)
 346:	fd06879b          	addiw	a5,a3,-48
 34a:	0ff7f793          	zext.b	a5,a5
 34e:	4625                	li	a2,9
 350:	02f66863          	bltu	a2,a5,380 <atoi+0x44>
 354:	872a                	mv	a4,a0
  n = 0;
 356:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 358:	0705                	addi	a4,a4,1
 35a:	0025179b          	slliw	a5,a0,0x2
 35e:	9fa9                	addw	a5,a5,a0
 360:	0017979b          	slliw	a5,a5,0x1
 364:	9fb5                	addw	a5,a5,a3
 366:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 36a:	00074683          	lbu	a3,0(a4)
 36e:	fd06879b          	addiw	a5,a3,-48
 372:	0ff7f793          	zext.b	a5,a5
 376:	fef671e3          	bgeu	a2,a5,358 <atoi+0x1c>
  return n;
}
 37a:	6422                	ld	s0,8(sp)
 37c:	0141                	addi	sp,sp,16
 37e:	8082                	ret
  n = 0;
 380:	4501                	li	a0,0
 382:	bfe5                	j	37a <atoi+0x3e>

0000000000000384 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 384:	1141                	addi	sp,sp,-16
 386:	e422                	sd	s0,8(sp)
 388:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 38a:	02b57463          	bgeu	a0,a1,3b2 <memmove+0x2e>
    while(n-- > 0)
 38e:	00c05f63          	blez	a2,3ac <memmove+0x28>
 392:	1602                	slli	a2,a2,0x20
 394:	9201                	srli	a2,a2,0x20
 396:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 39a:	872a                	mv	a4,a0
      *dst++ = *src++;
 39c:	0585                	addi	a1,a1,1
 39e:	0705                	addi	a4,a4,1
 3a0:	fff5c683          	lbu	a3,-1(a1)
 3a4:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 3a8:	fee79ae3          	bne	a5,a4,39c <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 3ac:	6422                	ld	s0,8(sp)
 3ae:	0141                	addi	sp,sp,16
 3b0:	8082                	ret
    dst += n;
 3b2:	00c50733          	add	a4,a0,a2
    src += n;
 3b6:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 3b8:	fec05ae3          	blez	a2,3ac <memmove+0x28>
 3bc:	fff6079b          	addiw	a5,a2,-1
 3c0:	1782                	slli	a5,a5,0x20
 3c2:	9381                	srli	a5,a5,0x20
 3c4:	fff7c793          	not	a5,a5
 3c8:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 3ca:	15fd                	addi	a1,a1,-1
 3cc:	177d                	addi	a4,a4,-1
 3ce:	0005c683          	lbu	a3,0(a1)
 3d2:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 3d6:	fee79ae3          	bne	a5,a4,3ca <memmove+0x46>
 3da:	bfc9                	j	3ac <memmove+0x28>

00000000000003dc <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 3dc:	1141                	addi	sp,sp,-16
 3de:	e422                	sd	s0,8(sp)
 3e0:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 3e2:	ca05                	beqz	a2,412 <memcmp+0x36>
 3e4:	fff6069b          	addiw	a3,a2,-1
 3e8:	1682                	slli	a3,a3,0x20
 3ea:	9281                	srli	a3,a3,0x20
 3ec:	0685                	addi	a3,a3,1
 3ee:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 3f0:	00054783          	lbu	a5,0(a0)
 3f4:	0005c703          	lbu	a4,0(a1)
 3f8:	00e79863          	bne	a5,a4,408 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 3fc:	0505                	addi	a0,a0,1
    p2++;
 3fe:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 400:	fed518e3          	bne	a0,a3,3f0 <memcmp+0x14>
  }
  return 0;
 404:	4501                	li	a0,0
 406:	a019                	j	40c <memcmp+0x30>
      return *p1 - *p2;
 408:	40e7853b          	subw	a0,a5,a4
}
 40c:	6422                	ld	s0,8(sp)
 40e:	0141                	addi	sp,sp,16
 410:	8082                	ret
  return 0;
 412:	4501                	li	a0,0
 414:	bfe5                	j	40c <memcmp+0x30>

0000000000000416 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 416:	1141                	addi	sp,sp,-16
 418:	e406                	sd	ra,8(sp)
 41a:	e022                	sd	s0,0(sp)
 41c:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 41e:	00000097          	auipc	ra,0x0
 422:	f66080e7          	jalr	-154(ra) # 384 <memmove>
}
 426:	60a2                	ld	ra,8(sp)
 428:	6402                	ld	s0,0(sp)
 42a:	0141                	addi	sp,sp,16
 42c:	8082                	ret

000000000000042e <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 42e:	4885                	li	a7,1
 ecall
 430:	00000073          	ecall
 ret
 434:	8082                	ret

0000000000000436 <exit>:
.global exit
exit:
 li a7, SYS_exit
 436:	4889                	li	a7,2
 ecall
 438:	00000073          	ecall
 ret
 43c:	8082                	ret

000000000000043e <wait>:
.global wait
wait:
 li a7, SYS_wait
 43e:	488d                	li	a7,3
 ecall
 440:	00000073          	ecall
 ret
 444:	8082                	ret

0000000000000446 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 446:	4891                	li	a7,4
 ecall
 448:	00000073          	ecall
 ret
 44c:	8082                	ret

000000000000044e <read>:
.global read
read:
 li a7, SYS_read
 44e:	4895                	li	a7,5
 ecall
 450:	00000073          	ecall
 ret
 454:	8082                	ret

0000000000000456 <write>:
.global write
write:
 li a7, SYS_write
 456:	48c1                	li	a7,16
 ecall
 458:	00000073          	ecall
 ret
 45c:	8082                	ret

000000000000045e <close>:
.global close
close:
 li a7, SYS_close
 45e:	48d5                	li	a7,21
 ecall
 460:	00000073          	ecall
 ret
 464:	8082                	ret

0000000000000466 <kill>:
.global kill
kill:
 li a7, SYS_kill
 466:	4899                	li	a7,6
 ecall
 468:	00000073          	ecall
 ret
 46c:	8082                	ret

000000000000046e <exec>:
.global exec
exec:
 li a7, SYS_exec
 46e:	489d                	li	a7,7
 ecall
 470:	00000073          	ecall
 ret
 474:	8082                	ret

0000000000000476 <open>:
.global open
open:
 li a7, SYS_open
 476:	48bd                	li	a7,15
 ecall
 478:	00000073          	ecall
 ret
 47c:	8082                	ret

000000000000047e <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 47e:	48c5                	li	a7,17
 ecall
 480:	00000073          	ecall
 ret
 484:	8082                	ret

0000000000000486 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 486:	48c9                	li	a7,18
 ecall
 488:	00000073          	ecall
 ret
 48c:	8082                	ret

000000000000048e <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 48e:	48a1                	li	a7,8
 ecall
 490:	00000073          	ecall
 ret
 494:	8082                	ret

0000000000000496 <link>:
.global link
link:
 li a7, SYS_link
 496:	48cd                	li	a7,19
 ecall
 498:	00000073          	ecall
 ret
 49c:	8082                	ret

000000000000049e <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 49e:	48d1                	li	a7,20
 ecall
 4a0:	00000073          	ecall
 ret
 4a4:	8082                	ret

00000000000004a6 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 4a6:	48a5                	li	a7,9
 ecall
 4a8:	00000073          	ecall
 ret
 4ac:	8082                	ret

00000000000004ae <dup>:
.global dup
dup:
 li a7, SYS_dup
 4ae:	48a9                	li	a7,10
 ecall
 4b0:	00000073          	ecall
 ret
 4b4:	8082                	ret

00000000000004b6 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 4b6:	48ad                	li	a7,11
 ecall
 4b8:	00000073          	ecall
 ret
 4bc:	8082                	ret

00000000000004be <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 4be:	48b1                	li	a7,12
 ecall
 4c0:	00000073          	ecall
 ret
 4c4:	8082                	ret

00000000000004c6 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 4c6:	48b5                	li	a7,13
 ecall
 4c8:	00000073          	ecall
 ret
 4cc:	8082                	ret

00000000000004ce <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 4ce:	48b9                	li	a7,14
 ecall
 4d0:	00000073          	ecall
 ret
 4d4:	8082                	ret

00000000000004d6 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 4d6:	1101                	addi	sp,sp,-32
 4d8:	ec06                	sd	ra,24(sp)
 4da:	e822                	sd	s0,16(sp)
 4dc:	1000                	addi	s0,sp,32
 4de:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 4e2:	4605                	li	a2,1
 4e4:	fef40593          	addi	a1,s0,-17
 4e8:	00000097          	auipc	ra,0x0
 4ec:	f6e080e7          	jalr	-146(ra) # 456 <write>
}
 4f0:	60e2                	ld	ra,24(sp)
 4f2:	6442                	ld	s0,16(sp)
 4f4:	6105                	addi	sp,sp,32
 4f6:	8082                	ret

00000000000004f8 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 4f8:	7139                	addi	sp,sp,-64
 4fa:	fc06                	sd	ra,56(sp)
 4fc:	f822                	sd	s0,48(sp)
 4fe:	f426                	sd	s1,40(sp)
 500:	f04a                	sd	s2,32(sp)
 502:	ec4e                	sd	s3,24(sp)
 504:	0080                	addi	s0,sp,64
 506:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 508:	c299                	beqz	a3,50e <printint+0x16>
 50a:	0805c963          	bltz	a1,59c <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 50e:	2581                	sext.w	a1,a1
  neg = 0;
 510:	4881                	li	a7,0
 512:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 516:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 518:	2601                	sext.w	a2,a2
 51a:	00000517          	auipc	a0,0x0
 51e:	4f650513          	addi	a0,a0,1270 # a10 <digits>
 522:	883a                	mv	a6,a4
 524:	2705                	addiw	a4,a4,1
 526:	02c5f7bb          	remuw	a5,a1,a2
 52a:	1782                	slli	a5,a5,0x20
 52c:	9381                	srli	a5,a5,0x20
 52e:	97aa                	add	a5,a5,a0
 530:	0007c783          	lbu	a5,0(a5)
 534:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 538:	0005879b          	sext.w	a5,a1
 53c:	02c5d5bb          	divuw	a1,a1,a2
 540:	0685                	addi	a3,a3,1
 542:	fec7f0e3          	bgeu	a5,a2,522 <printint+0x2a>
  if(neg)
 546:	00088c63          	beqz	a7,55e <printint+0x66>
    buf[i++] = '-';
 54a:	fd070793          	addi	a5,a4,-48
 54e:	00878733          	add	a4,a5,s0
 552:	02d00793          	li	a5,45
 556:	fef70823          	sb	a5,-16(a4)
 55a:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 55e:	02e05863          	blez	a4,58e <printint+0x96>
 562:	fc040793          	addi	a5,s0,-64
 566:	00e78933          	add	s2,a5,a4
 56a:	fff78993          	addi	s3,a5,-1
 56e:	99ba                	add	s3,s3,a4
 570:	377d                	addiw	a4,a4,-1
 572:	1702                	slli	a4,a4,0x20
 574:	9301                	srli	a4,a4,0x20
 576:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 57a:	fff94583          	lbu	a1,-1(s2)
 57e:	8526                	mv	a0,s1
 580:	00000097          	auipc	ra,0x0
 584:	f56080e7          	jalr	-170(ra) # 4d6 <putc>
  while(--i >= 0)
 588:	197d                	addi	s2,s2,-1
 58a:	ff3918e3          	bne	s2,s3,57a <printint+0x82>
}
 58e:	70e2                	ld	ra,56(sp)
 590:	7442                	ld	s0,48(sp)
 592:	74a2                	ld	s1,40(sp)
 594:	7902                	ld	s2,32(sp)
 596:	69e2                	ld	s3,24(sp)
 598:	6121                	addi	sp,sp,64
 59a:	8082                	ret
    x = -xx;
 59c:	40b005bb          	negw	a1,a1
    neg = 1;
 5a0:	4885                	li	a7,1
    x = -xx;
 5a2:	bf85                	j	512 <printint+0x1a>

00000000000005a4 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 5a4:	7119                	addi	sp,sp,-128
 5a6:	fc86                	sd	ra,120(sp)
 5a8:	f8a2                	sd	s0,112(sp)
 5aa:	f4a6                	sd	s1,104(sp)
 5ac:	f0ca                	sd	s2,96(sp)
 5ae:	ecce                	sd	s3,88(sp)
 5b0:	e8d2                	sd	s4,80(sp)
 5b2:	e4d6                	sd	s5,72(sp)
 5b4:	e0da                	sd	s6,64(sp)
 5b6:	fc5e                	sd	s7,56(sp)
 5b8:	f862                	sd	s8,48(sp)
 5ba:	f466                	sd	s9,40(sp)
 5bc:	f06a                	sd	s10,32(sp)
 5be:	ec6e                	sd	s11,24(sp)
 5c0:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 5c2:	0005c903          	lbu	s2,0(a1)
 5c6:	18090f63          	beqz	s2,764 <vprintf+0x1c0>
 5ca:	8aaa                	mv	s5,a0
 5cc:	8b32                	mv	s6,a2
 5ce:	00158493          	addi	s1,a1,1
  state = 0;
 5d2:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 5d4:	02500a13          	li	s4,37
 5d8:	4c55                	li	s8,21
 5da:	00000c97          	auipc	s9,0x0
 5de:	3dec8c93          	addi	s9,s9,990 # 9b8 <malloc+0x150>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
        s = va_arg(ap, char*);
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 5e2:	02800d93          	li	s11,40
  putc(fd, 'x');
 5e6:	4d41                	li	s10,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 5e8:	00000b97          	auipc	s7,0x0
 5ec:	428b8b93          	addi	s7,s7,1064 # a10 <digits>
 5f0:	a839                	j	60e <vprintf+0x6a>
        putc(fd, c);
 5f2:	85ca                	mv	a1,s2
 5f4:	8556                	mv	a0,s5
 5f6:	00000097          	auipc	ra,0x0
 5fa:	ee0080e7          	jalr	-288(ra) # 4d6 <putc>
 5fe:	a019                	j	604 <vprintf+0x60>
    } else if(state == '%'){
 600:	01498d63          	beq	s3,s4,61a <vprintf+0x76>
  for(i = 0; fmt[i]; i++){
 604:	0485                	addi	s1,s1,1
 606:	fff4c903          	lbu	s2,-1(s1)
 60a:	14090d63          	beqz	s2,764 <vprintf+0x1c0>
    if(state == 0){
 60e:	fe0999e3          	bnez	s3,600 <vprintf+0x5c>
      if(c == '%'){
 612:	ff4910e3          	bne	s2,s4,5f2 <vprintf+0x4e>
        state = '%';
 616:	89d2                	mv	s3,s4
 618:	b7f5                	j	604 <vprintf+0x60>
      if(c == 'd'){
 61a:	11490c63          	beq	s2,s4,732 <vprintf+0x18e>
 61e:	f9d9079b          	addiw	a5,s2,-99
 622:	0ff7f793          	zext.b	a5,a5
 626:	10fc6e63          	bltu	s8,a5,742 <vprintf+0x19e>
 62a:	f9d9079b          	addiw	a5,s2,-99
 62e:	0ff7f713          	zext.b	a4,a5
 632:	10ec6863          	bltu	s8,a4,742 <vprintf+0x19e>
 636:	00271793          	slli	a5,a4,0x2
 63a:	97e6                	add	a5,a5,s9
 63c:	439c                	lw	a5,0(a5)
 63e:	97e6                	add	a5,a5,s9
 640:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 642:	008b0913          	addi	s2,s6,8
 646:	4685                	li	a3,1
 648:	4629                	li	a2,10
 64a:	000b2583          	lw	a1,0(s6)
 64e:	8556                	mv	a0,s5
 650:	00000097          	auipc	ra,0x0
 654:	ea8080e7          	jalr	-344(ra) # 4f8 <printint>
 658:	8b4a                	mv	s6,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 65a:	4981                	li	s3,0
 65c:	b765                	j	604 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 65e:	008b0913          	addi	s2,s6,8
 662:	4681                	li	a3,0
 664:	4629                	li	a2,10
 666:	000b2583          	lw	a1,0(s6)
 66a:	8556                	mv	a0,s5
 66c:	00000097          	auipc	ra,0x0
 670:	e8c080e7          	jalr	-372(ra) # 4f8 <printint>
 674:	8b4a                	mv	s6,s2
      state = 0;
 676:	4981                	li	s3,0
 678:	b771                	j	604 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 67a:	008b0913          	addi	s2,s6,8
 67e:	4681                	li	a3,0
 680:	866a                	mv	a2,s10
 682:	000b2583          	lw	a1,0(s6)
 686:	8556                	mv	a0,s5
 688:	00000097          	auipc	ra,0x0
 68c:	e70080e7          	jalr	-400(ra) # 4f8 <printint>
 690:	8b4a                	mv	s6,s2
      state = 0;
 692:	4981                	li	s3,0
 694:	bf85                	j	604 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 696:	008b0793          	addi	a5,s6,8
 69a:	f8f43423          	sd	a5,-120(s0)
 69e:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 6a2:	03000593          	li	a1,48
 6a6:	8556                	mv	a0,s5
 6a8:	00000097          	auipc	ra,0x0
 6ac:	e2e080e7          	jalr	-466(ra) # 4d6 <putc>
  putc(fd, 'x');
 6b0:	07800593          	li	a1,120
 6b4:	8556                	mv	a0,s5
 6b6:	00000097          	auipc	ra,0x0
 6ba:	e20080e7          	jalr	-480(ra) # 4d6 <putc>
 6be:	896a                	mv	s2,s10
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 6c0:	03c9d793          	srli	a5,s3,0x3c
 6c4:	97de                	add	a5,a5,s7
 6c6:	0007c583          	lbu	a1,0(a5)
 6ca:	8556                	mv	a0,s5
 6cc:	00000097          	auipc	ra,0x0
 6d0:	e0a080e7          	jalr	-502(ra) # 4d6 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 6d4:	0992                	slli	s3,s3,0x4
 6d6:	397d                	addiw	s2,s2,-1
 6d8:	fe0914e3          	bnez	s2,6c0 <vprintf+0x11c>
        printptr(fd, va_arg(ap, uint64));
 6dc:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 6e0:	4981                	li	s3,0
 6e2:	b70d                	j	604 <vprintf+0x60>
        s = va_arg(ap, char*);
 6e4:	008b0913          	addi	s2,s6,8
 6e8:	000b3983          	ld	s3,0(s6)
        if(s == 0)
 6ec:	02098163          	beqz	s3,70e <vprintf+0x16a>
        while(*s != 0){
 6f0:	0009c583          	lbu	a1,0(s3)
 6f4:	c5ad                	beqz	a1,75e <vprintf+0x1ba>
          putc(fd, *s);
 6f6:	8556                	mv	a0,s5
 6f8:	00000097          	auipc	ra,0x0
 6fc:	dde080e7          	jalr	-546(ra) # 4d6 <putc>
          s++;
 700:	0985                	addi	s3,s3,1
        while(*s != 0){
 702:	0009c583          	lbu	a1,0(s3)
 706:	f9e5                	bnez	a1,6f6 <vprintf+0x152>
        s = va_arg(ap, char*);
 708:	8b4a                	mv	s6,s2
      state = 0;
 70a:	4981                	li	s3,0
 70c:	bde5                	j	604 <vprintf+0x60>
          s = "(null)";
 70e:	00000997          	auipc	s3,0x0
 712:	2a298993          	addi	s3,s3,674 # 9b0 <malloc+0x148>
        while(*s != 0){
 716:	85ee                	mv	a1,s11
 718:	bff9                	j	6f6 <vprintf+0x152>
        putc(fd, va_arg(ap, uint));
 71a:	008b0913          	addi	s2,s6,8
 71e:	000b4583          	lbu	a1,0(s6)
 722:	8556                	mv	a0,s5
 724:	00000097          	auipc	ra,0x0
 728:	db2080e7          	jalr	-590(ra) # 4d6 <putc>
 72c:	8b4a                	mv	s6,s2
      state = 0;
 72e:	4981                	li	s3,0
 730:	bdd1                	j	604 <vprintf+0x60>
        putc(fd, c);
 732:	85d2                	mv	a1,s4
 734:	8556                	mv	a0,s5
 736:	00000097          	auipc	ra,0x0
 73a:	da0080e7          	jalr	-608(ra) # 4d6 <putc>
      state = 0;
 73e:	4981                	li	s3,0
 740:	b5d1                	j	604 <vprintf+0x60>
        putc(fd, '%');
 742:	85d2                	mv	a1,s4
 744:	8556                	mv	a0,s5
 746:	00000097          	auipc	ra,0x0
 74a:	d90080e7          	jalr	-624(ra) # 4d6 <putc>
        putc(fd, c);
 74e:	85ca                	mv	a1,s2
 750:	8556                	mv	a0,s5
 752:	00000097          	auipc	ra,0x0
 756:	d84080e7          	jalr	-636(ra) # 4d6 <putc>
      state = 0;
 75a:	4981                	li	s3,0
 75c:	b565                	j	604 <vprintf+0x60>
        s = va_arg(ap, char*);
 75e:	8b4a                	mv	s6,s2
      state = 0;
 760:	4981                	li	s3,0
 762:	b54d                	j	604 <vprintf+0x60>
    }
  }
}
 764:	70e6                	ld	ra,120(sp)
 766:	7446                	ld	s0,112(sp)
 768:	74a6                	ld	s1,104(sp)
 76a:	7906                	ld	s2,96(sp)
 76c:	69e6                	ld	s3,88(sp)
 76e:	6a46                	ld	s4,80(sp)
 770:	6aa6                	ld	s5,72(sp)
 772:	6b06                	ld	s6,64(sp)
 774:	7be2                	ld	s7,56(sp)
 776:	7c42                	ld	s8,48(sp)
 778:	7ca2                	ld	s9,40(sp)
 77a:	7d02                	ld	s10,32(sp)
 77c:	6de2                	ld	s11,24(sp)
 77e:	6109                	addi	sp,sp,128
 780:	8082                	ret

0000000000000782 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 782:	715d                	addi	sp,sp,-80
 784:	ec06                	sd	ra,24(sp)
 786:	e822                	sd	s0,16(sp)
 788:	1000                	addi	s0,sp,32
 78a:	e010                	sd	a2,0(s0)
 78c:	e414                	sd	a3,8(s0)
 78e:	e818                	sd	a4,16(s0)
 790:	ec1c                	sd	a5,24(s0)
 792:	03043023          	sd	a6,32(s0)
 796:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 79a:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 79e:	8622                	mv	a2,s0
 7a0:	00000097          	auipc	ra,0x0
 7a4:	e04080e7          	jalr	-508(ra) # 5a4 <vprintf>
}
 7a8:	60e2                	ld	ra,24(sp)
 7aa:	6442                	ld	s0,16(sp)
 7ac:	6161                	addi	sp,sp,80
 7ae:	8082                	ret

00000000000007b0 <printf>:

void
printf(const char *fmt, ...)
{
 7b0:	711d                	addi	sp,sp,-96
 7b2:	ec06                	sd	ra,24(sp)
 7b4:	e822                	sd	s0,16(sp)
 7b6:	1000                	addi	s0,sp,32
 7b8:	e40c                	sd	a1,8(s0)
 7ba:	e810                	sd	a2,16(s0)
 7bc:	ec14                	sd	a3,24(s0)
 7be:	f018                	sd	a4,32(s0)
 7c0:	f41c                	sd	a5,40(s0)
 7c2:	03043823          	sd	a6,48(s0)
 7c6:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 7ca:	00840613          	addi	a2,s0,8
 7ce:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 7d2:	85aa                	mv	a1,a0
 7d4:	4505                	li	a0,1
 7d6:	00000097          	auipc	ra,0x0
 7da:	dce080e7          	jalr	-562(ra) # 5a4 <vprintf>
}
 7de:	60e2                	ld	ra,24(sp)
 7e0:	6442                	ld	s0,16(sp)
 7e2:	6125                	addi	sp,sp,96
 7e4:	8082                	ret

00000000000007e6 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 7e6:	1141                	addi	sp,sp,-16
 7e8:	e422                	sd	s0,8(sp)
 7ea:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 7ec:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7f0:	00000797          	auipc	a5,0x0
 7f4:	2387b783          	ld	a5,568(a5) # a28 <freep>
 7f8:	a02d                	j	822 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 7fa:	4618                	lw	a4,8(a2)
 7fc:	9f2d                	addw	a4,a4,a1
 7fe:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 802:	6398                	ld	a4,0(a5)
 804:	6310                	ld	a2,0(a4)
 806:	a83d                	j	844 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 808:	ff852703          	lw	a4,-8(a0)
 80c:	9f31                	addw	a4,a4,a2
 80e:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 810:	ff053683          	ld	a3,-16(a0)
 814:	a091                	j	858 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 816:	6398                	ld	a4,0(a5)
 818:	00e7e463          	bltu	a5,a4,820 <free+0x3a>
 81c:	00e6ea63          	bltu	a3,a4,830 <free+0x4a>
{
 820:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 822:	fed7fae3          	bgeu	a5,a3,816 <free+0x30>
 826:	6398                	ld	a4,0(a5)
 828:	00e6e463          	bltu	a3,a4,830 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 82c:	fee7eae3          	bltu	a5,a4,820 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 830:	ff852583          	lw	a1,-8(a0)
 834:	6390                	ld	a2,0(a5)
 836:	02059813          	slli	a6,a1,0x20
 83a:	01c85713          	srli	a4,a6,0x1c
 83e:	9736                	add	a4,a4,a3
 840:	fae60de3          	beq	a2,a4,7fa <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 844:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 848:	4790                	lw	a2,8(a5)
 84a:	02061593          	slli	a1,a2,0x20
 84e:	01c5d713          	srli	a4,a1,0x1c
 852:	973e                	add	a4,a4,a5
 854:	fae68ae3          	beq	a3,a4,808 <free+0x22>
    p->s.ptr = bp->s.ptr;
 858:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 85a:	00000717          	auipc	a4,0x0
 85e:	1cf73723          	sd	a5,462(a4) # a28 <freep>
}
 862:	6422                	ld	s0,8(sp)
 864:	0141                	addi	sp,sp,16
 866:	8082                	ret

0000000000000868 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 868:	7139                	addi	sp,sp,-64
 86a:	fc06                	sd	ra,56(sp)
 86c:	f822                	sd	s0,48(sp)
 86e:	f426                	sd	s1,40(sp)
 870:	f04a                	sd	s2,32(sp)
 872:	ec4e                	sd	s3,24(sp)
 874:	e852                	sd	s4,16(sp)
 876:	e456                	sd	s5,8(sp)
 878:	e05a                	sd	s6,0(sp)
 87a:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 87c:	02051493          	slli	s1,a0,0x20
 880:	9081                	srli	s1,s1,0x20
 882:	04bd                	addi	s1,s1,15
 884:	8091                	srli	s1,s1,0x4
 886:	0014899b          	addiw	s3,s1,1
 88a:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 88c:	00000517          	auipc	a0,0x0
 890:	19c53503          	ld	a0,412(a0) # a28 <freep>
 894:	c515                	beqz	a0,8c0 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 896:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 898:	4798                	lw	a4,8(a5)
 89a:	02977f63          	bgeu	a4,s1,8d8 <malloc+0x70>
 89e:	8a4e                	mv	s4,s3
 8a0:	0009871b          	sext.w	a4,s3
 8a4:	6685                	lui	a3,0x1
 8a6:	00d77363          	bgeu	a4,a3,8ac <malloc+0x44>
 8aa:	6a05                	lui	s4,0x1
 8ac:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 8b0:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 8b4:	00000917          	auipc	s2,0x0
 8b8:	17490913          	addi	s2,s2,372 # a28 <freep>
  if(p == (char*)-1)
 8bc:	5afd                	li	s5,-1
 8be:	a895                	j	932 <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
 8c0:	00000797          	auipc	a5,0x0
 8c4:	17078793          	addi	a5,a5,368 # a30 <base>
 8c8:	00000717          	auipc	a4,0x0
 8cc:	16f73023          	sd	a5,352(a4) # a28 <freep>
 8d0:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 8d2:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 8d6:	b7e1                	j	89e <malloc+0x36>
      if(p->s.size == nunits)
 8d8:	02e48c63          	beq	s1,a4,910 <malloc+0xa8>
        p->s.size -= nunits;
 8dc:	4137073b          	subw	a4,a4,s3
 8e0:	c798                	sw	a4,8(a5)
        p += p->s.size;
 8e2:	02071693          	slli	a3,a4,0x20
 8e6:	01c6d713          	srli	a4,a3,0x1c
 8ea:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 8ec:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 8f0:	00000717          	auipc	a4,0x0
 8f4:	12a73c23          	sd	a0,312(a4) # a28 <freep>
      return (void*)(p + 1);
 8f8:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 8fc:	70e2                	ld	ra,56(sp)
 8fe:	7442                	ld	s0,48(sp)
 900:	74a2                	ld	s1,40(sp)
 902:	7902                	ld	s2,32(sp)
 904:	69e2                	ld	s3,24(sp)
 906:	6a42                	ld	s4,16(sp)
 908:	6aa2                	ld	s5,8(sp)
 90a:	6b02                	ld	s6,0(sp)
 90c:	6121                	addi	sp,sp,64
 90e:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 910:	6398                	ld	a4,0(a5)
 912:	e118                	sd	a4,0(a0)
 914:	bff1                	j	8f0 <malloc+0x88>
  hp->s.size = nu;
 916:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 91a:	0541                	addi	a0,a0,16
 91c:	00000097          	auipc	ra,0x0
 920:	eca080e7          	jalr	-310(ra) # 7e6 <free>
  return freep;
 924:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 928:	d971                	beqz	a0,8fc <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 92a:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 92c:	4798                	lw	a4,8(a5)
 92e:	fa9775e3          	bgeu	a4,s1,8d8 <malloc+0x70>
    if(p == freep)
 932:	00093703          	ld	a4,0(s2)
 936:	853e                	mv	a0,a5
 938:	fef719e3          	bne	a4,a5,92a <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
 93c:	8552                	mv	a0,s4
 93e:	00000097          	auipc	ra,0x0
 942:	b80080e7          	jalr	-1152(ra) # 4be <sbrk>
  if(p == (char*)-1)
 946:	fd5518e3          	bne	a0,s5,916 <malloc+0xae>
        return 0;
 94a:	4501                	li	a0,0
 94c:	bf45                	j	8fc <malloc+0x94>
