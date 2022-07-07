
user/_xargs：     文件格式 elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include"kernel/types.h"
#include"kernel/stat.h"
#include"kernel/param.h"
#include"user/user.h"

int main(int argc, char *argv[]){
   0:	cc010113          	addi	sp,sp,-832
   4:	32113c23          	sd	ra,824(sp)
   8:	32813823          	sd	s0,816(sp)
   c:	32913423          	sd	s1,808(sp)
  10:	33213023          	sd	s2,800(sp)
  14:	31313c23          	sd	s3,792(sp)
  18:	31413823          	sd	s4,784(sp)
  1c:	31513423          	sd	s5,776(sp)
  20:	31613023          	sd	s6,768(sp)
  24:	0680                	addi	s0,sp,832
  26:	8a2a                	mv	s4,a0
  28:	8aae                	mv	s5,a1

	char *args[MAXARG];
	int i;
	char buf[512];
	// Get the main argv of exec 
	for(i=1;i<argc;i++){
  2a:	4785                	li	a5,1
  2c:	02a7d563          	bge	a5,a0,56 <main+0x56>
  30:	00858713          	addi	a4,a1,8
  34:	ec040793          	addi	a5,s0,-320
  38:	ffe5061b          	addiw	a2,a0,-2
  3c:	02061693          	slli	a3,a2,0x20
  40:	01d6d613          	srli	a2,a3,0x1d
  44:	ec840693          	addi	a3,s0,-312
  48:	9636                	add	a2,a2,a3
		args[i-1] = argv[i];
  4a:	6314                	ld	a3,0(a4)
  4c:	e394                	sd	a3,0(a5)
	for(i=1;i<argc;i++){
  4e:	0721                	addi	a4,a4,8
  50:	07a1                	addi	a5,a5,8
  52:	fec79ce3          	bne	a5,a2,4a <main+0x4a>
	//Get the rest argv of exec and excute
	int n;
	char *p;
	while(1){
		p = buf;
		while((n = read(0, p, 1))&&(*p!='\n')){
  56:	49a9                	li	s3,10
			p++;
		}
		*p = '\0';
		if(p!=buf){
  58:	cc040b13          	addi	s6,s0,-832
  5c:	a815                	j	90 <main+0x90>
			p++;
  5e:	0905                	addi	s2,s2,1
		while((n = read(0, p, 1))&&(*p!='\n')){
  60:	4605                	li	a2,1
  62:	85ca                	mv	a1,s2
  64:	4501                	li	a0,0
  66:	00000097          	auipc	ra,0x0
  6a:	324080e7          	jalr	804(ra) # 38a <read>
  6e:	84aa                	mv	s1,a0
  70:	c139                	beqz	a0,b6 <main+0xb6>
  72:	00094783          	lbu	a5,0(s2)
  76:	ff3794e3          	bne	a5,s3,5e <main+0x5e>
		*p = '\0';
  7a:	00090023          	sb	zero,0(s2)
		if(p!=buf){
  7e:	01691c63          	bne	s2,s6,96 <main+0x96>
				args[argc-1] = buf;
				exec(argv[1], args);
				exit(1);
			}
		}
		wait(0);
  82:	4501                	li	a0,0
  84:	00000097          	auipc	ra,0x0
  88:	2f6080e7          	jalr	758(ra) # 37a <wait>
		if(n<=0){
  8c:	02905063          	blez	s1,ac <main+0xac>
		p = buf;
  90:	cc040913          	addi	s2,s0,-832
		while((n = read(0, p, 1))&&(*p!='\n')){
  94:	b7f1                	j	60 <main+0x60>
			if(fork()==0){
  96:	00000097          	auipc	ra,0x0
  9a:	2d4080e7          	jalr	724(ra) # 36a <fork>
  9e:	f175                	bnez	a0,82 <main+0x82>
  a0:	a035                	j	cc <main+0xcc>
		wait(0);
  a2:	4501                	li	a0,0
  a4:	00000097          	auipc	ra,0x0
  a8:	2d6080e7          	jalr	726(ra) # 37a <wait>
			exit(1);
  ac:	4505                	li	a0,1
  ae:	00000097          	auipc	ra,0x0
  b2:	2c4080e7          	jalr	708(ra) # 372 <exit>
		*p = '\0';
  b6:	00090023          	sb	zero,0(s2)
		if(p!=buf){
  ba:	cc040793          	addi	a5,s0,-832
  be:	fef902e3          	beq	s2,a5,a2 <main+0xa2>
			if(fork()==0){
  c2:	00000097          	auipc	ra,0x0
  c6:	2a8080e7          	jalr	680(ra) # 36a <fork>
  ca:	e905                	bnez	a0,fa <main+0xfa>
				args[argc-1] = buf;
  cc:	fffa079b          	addiw	a5,s4,-1
  d0:	078e                	slli	a5,a5,0x3
  d2:	fc078793          	addi	a5,a5,-64
  d6:	97a2                	add	a5,a5,s0
  d8:	cc040713          	addi	a4,s0,-832
  dc:	f0e7b023          	sd	a4,-256(a5)
				exec(argv[1], args);
  e0:	ec040593          	addi	a1,s0,-320
  e4:	008ab503          	ld	a0,8(s5)
  e8:	00000097          	auipc	ra,0x0
  ec:	2c2080e7          	jalr	706(ra) # 3aa <exec>
				exit(1);
  f0:	4505                	li	a0,1
  f2:	00000097          	auipc	ra,0x0
  f6:	280080e7          	jalr	640(ra) # 372 <exit>
		wait(0);
  fa:	4501                	li	a0,0
  fc:	00000097          	auipc	ra,0x0
 100:	27e080e7          	jalr	638(ra) # 37a <wait>
		if(n<=0){
 104:	b765                	j	ac <main+0xac>

0000000000000106 <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
 106:	1141                	addi	sp,sp,-16
 108:	e422                	sd	s0,8(sp)
 10a:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 10c:	87aa                	mv	a5,a0
 10e:	0585                	addi	a1,a1,1
 110:	0785                	addi	a5,a5,1
 112:	fff5c703          	lbu	a4,-1(a1)
 116:	fee78fa3          	sb	a4,-1(a5)
 11a:	fb75                	bnez	a4,10e <strcpy+0x8>
    ;
  return os;
}
 11c:	6422                	ld	s0,8(sp)
 11e:	0141                	addi	sp,sp,16
 120:	8082                	ret

0000000000000122 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 122:	1141                	addi	sp,sp,-16
 124:	e422                	sd	s0,8(sp)
 126:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 128:	00054783          	lbu	a5,0(a0)
 12c:	cb91                	beqz	a5,140 <strcmp+0x1e>
 12e:	0005c703          	lbu	a4,0(a1)
 132:	00f71763          	bne	a4,a5,140 <strcmp+0x1e>
    p++, q++;
 136:	0505                	addi	a0,a0,1
 138:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 13a:	00054783          	lbu	a5,0(a0)
 13e:	fbe5                	bnez	a5,12e <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 140:	0005c503          	lbu	a0,0(a1)
}
 144:	40a7853b          	subw	a0,a5,a0
 148:	6422                	ld	s0,8(sp)
 14a:	0141                	addi	sp,sp,16
 14c:	8082                	ret

000000000000014e <strlen>:

uint
strlen(const char *s)
{
 14e:	1141                	addi	sp,sp,-16
 150:	e422                	sd	s0,8(sp)
 152:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 154:	00054783          	lbu	a5,0(a0)
 158:	cf91                	beqz	a5,174 <strlen+0x26>
 15a:	0505                	addi	a0,a0,1
 15c:	87aa                	mv	a5,a0
 15e:	4685                	li	a3,1
 160:	9e89                	subw	a3,a3,a0
 162:	00f6853b          	addw	a0,a3,a5
 166:	0785                	addi	a5,a5,1
 168:	fff7c703          	lbu	a4,-1(a5)
 16c:	fb7d                	bnez	a4,162 <strlen+0x14>
    ;
  return n;
}
 16e:	6422                	ld	s0,8(sp)
 170:	0141                	addi	sp,sp,16
 172:	8082                	ret
  for(n = 0; s[n]; n++)
 174:	4501                	li	a0,0
 176:	bfe5                	j	16e <strlen+0x20>

0000000000000178 <memset>:

void*
memset(void *dst, int c, uint n)
{
 178:	1141                	addi	sp,sp,-16
 17a:	e422                	sd	s0,8(sp)
 17c:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 17e:	ca19                	beqz	a2,194 <memset+0x1c>
 180:	87aa                	mv	a5,a0
 182:	1602                	slli	a2,a2,0x20
 184:	9201                	srli	a2,a2,0x20
 186:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 18a:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 18e:	0785                	addi	a5,a5,1
 190:	fee79de3          	bne	a5,a4,18a <memset+0x12>
  }
  return dst;
}
 194:	6422                	ld	s0,8(sp)
 196:	0141                	addi	sp,sp,16
 198:	8082                	ret

000000000000019a <strchr>:

char*
strchr(const char *s, char c)
{
 19a:	1141                	addi	sp,sp,-16
 19c:	e422                	sd	s0,8(sp)
 19e:	0800                	addi	s0,sp,16
  for(; *s; s++)
 1a0:	00054783          	lbu	a5,0(a0)
 1a4:	cb99                	beqz	a5,1ba <strchr+0x20>
    if(*s == c)
 1a6:	00f58763          	beq	a1,a5,1b4 <strchr+0x1a>
  for(; *s; s++)
 1aa:	0505                	addi	a0,a0,1
 1ac:	00054783          	lbu	a5,0(a0)
 1b0:	fbfd                	bnez	a5,1a6 <strchr+0xc>
      return (char*)s;
  return 0;
 1b2:	4501                	li	a0,0
}
 1b4:	6422                	ld	s0,8(sp)
 1b6:	0141                	addi	sp,sp,16
 1b8:	8082                	ret
  return 0;
 1ba:	4501                	li	a0,0
 1bc:	bfe5                	j	1b4 <strchr+0x1a>

00000000000001be <gets>:

char*
gets(char *buf, int max)
{
 1be:	711d                	addi	sp,sp,-96
 1c0:	ec86                	sd	ra,88(sp)
 1c2:	e8a2                	sd	s0,80(sp)
 1c4:	e4a6                	sd	s1,72(sp)
 1c6:	e0ca                	sd	s2,64(sp)
 1c8:	fc4e                	sd	s3,56(sp)
 1ca:	f852                	sd	s4,48(sp)
 1cc:	f456                	sd	s5,40(sp)
 1ce:	f05a                	sd	s6,32(sp)
 1d0:	ec5e                	sd	s7,24(sp)
 1d2:	1080                	addi	s0,sp,96
 1d4:	8baa                	mv	s7,a0
 1d6:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1d8:	892a                	mv	s2,a0
 1da:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 1dc:	4aa9                	li	s5,10
 1de:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 1e0:	89a6                	mv	s3,s1
 1e2:	2485                	addiw	s1,s1,1
 1e4:	0344d863          	bge	s1,s4,214 <gets+0x56>
    cc = read(0, &c, 1);
 1e8:	4605                	li	a2,1
 1ea:	faf40593          	addi	a1,s0,-81
 1ee:	4501                	li	a0,0
 1f0:	00000097          	auipc	ra,0x0
 1f4:	19a080e7          	jalr	410(ra) # 38a <read>
    if(cc < 1)
 1f8:	00a05e63          	blez	a0,214 <gets+0x56>
    buf[i++] = c;
 1fc:	faf44783          	lbu	a5,-81(s0)
 200:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 204:	01578763          	beq	a5,s5,212 <gets+0x54>
 208:	0905                	addi	s2,s2,1
 20a:	fd679be3          	bne	a5,s6,1e0 <gets+0x22>
  for(i=0; i+1 < max; ){
 20e:	89a6                	mv	s3,s1
 210:	a011                	j	214 <gets+0x56>
 212:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 214:	99de                	add	s3,s3,s7
 216:	00098023          	sb	zero,0(s3)
  return buf;
}
 21a:	855e                	mv	a0,s7
 21c:	60e6                	ld	ra,88(sp)
 21e:	6446                	ld	s0,80(sp)
 220:	64a6                	ld	s1,72(sp)
 222:	6906                	ld	s2,64(sp)
 224:	79e2                	ld	s3,56(sp)
 226:	7a42                	ld	s4,48(sp)
 228:	7aa2                	ld	s5,40(sp)
 22a:	7b02                	ld	s6,32(sp)
 22c:	6be2                	ld	s7,24(sp)
 22e:	6125                	addi	sp,sp,96
 230:	8082                	ret

0000000000000232 <stat>:

int
stat(const char *n, struct stat *st)
{
 232:	1101                	addi	sp,sp,-32
 234:	ec06                	sd	ra,24(sp)
 236:	e822                	sd	s0,16(sp)
 238:	e426                	sd	s1,8(sp)
 23a:	e04a                	sd	s2,0(sp)
 23c:	1000                	addi	s0,sp,32
 23e:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 240:	4581                	li	a1,0
 242:	00000097          	auipc	ra,0x0
 246:	170080e7          	jalr	368(ra) # 3b2 <open>
  if(fd < 0)
 24a:	02054563          	bltz	a0,274 <stat+0x42>
 24e:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 250:	85ca                	mv	a1,s2
 252:	00000097          	auipc	ra,0x0
 256:	178080e7          	jalr	376(ra) # 3ca <fstat>
 25a:	892a                	mv	s2,a0
  close(fd);
 25c:	8526                	mv	a0,s1
 25e:	00000097          	auipc	ra,0x0
 262:	13c080e7          	jalr	316(ra) # 39a <close>
  return r;
}
 266:	854a                	mv	a0,s2
 268:	60e2                	ld	ra,24(sp)
 26a:	6442                	ld	s0,16(sp)
 26c:	64a2                	ld	s1,8(sp)
 26e:	6902                	ld	s2,0(sp)
 270:	6105                	addi	sp,sp,32
 272:	8082                	ret
    return -1;
 274:	597d                	li	s2,-1
 276:	bfc5                	j	266 <stat+0x34>

0000000000000278 <atoi>:

int
atoi(const char *s)
{
 278:	1141                	addi	sp,sp,-16
 27a:	e422                	sd	s0,8(sp)
 27c:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 27e:	00054683          	lbu	a3,0(a0)
 282:	fd06879b          	addiw	a5,a3,-48
 286:	0ff7f793          	zext.b	a5,a5
 28a:	4625                	li	a2,9
 28c:	02f66863          	bltu	a2,a5,2bc <atoi+0x44>
 290:	872a                	mv	a4,a0
  n = 0;
 292:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 294:	0705                	addi	a4,a4,1
 296:	0025179b          	slliw	a5,a0,0x2
 29a:	9fa9                	addw	a5,a5,a0
 29c:	0017979b          	slliw	a5,a5,0x1
 2a0:	9fb5                	addw	a5,a5,a3
 2a2:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 2a6:	00074683          	lbu	a3,0(a4)
 2aa:	fd06879b          	addiw	a5,a3,-48
 2ae:	0ff7f793          	zext.b	a5,a5
 2b2:	fef671e3          	bgeu	a2,a5,294 <atoi+0x1c>
  return n;
}
 2b6:	6422                	ld	s0,8(sp)
 2b8:	0141                	addi	sp,sp,16
 2ba:	8082                	ret
  n = 0;
 2bc:	4501                	li	a0,0
 2be:	bfe5                	j	2b6 <atoi+0x3e>

00000000000002c0 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 2c0:	1141                	addi	sp,sp,-16
 2c2:	e422                	sd	s0,8(sp)
 2c4:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 2c6:	02b57463          	bgeu	a0,a1,2ee <memmove+0x2e>
    while(n-- > 0)
 2ca:	00c05f63          	blez	a2,2e8 <memmove+0x28>
 2ce:	1602                	slli	a2,a2,0x20
 2d0:	9201                	srli	a2,a2,0x20
 2d2:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 2d6:	872a                	mv	a4,a0
      *dst++ = *src++;
 2d8:	0585                	addi	a1,a1,1
 2da:	0705                	addi	a4,a4,1
 2dc:	fff5c683          	lbu	a3,-1(a1)
 2e0:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 2e4:	fee79ae3          	bne	a5,a4,2d8 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 2e8:	6422                	ld	s0,8(sp)
 2ea:	0141                	addi	sp,sp,16
 2ec:	8082                	ret
    dst += n;
 2ee:	00c50733          	add	a4,a0,a2
    src += n;
 2f2:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 2f4:	fec05ae3          	blez	a2,2e8 <memmove+0x28>
 2f8:	fff6079b          	addiw	a5,a2,-1
 2fc:	1782                	slli	a5,a5,0x20
 2fe:	9381                	srli	a5,a5,0x20
 300:	fff7c793          	not	a5,a5
 304:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 306:	15fd                	addi	a1,a1,-1
 308:	177d                	addi	a4,a4,-1
 30a:	0005c683          	lbu	a3,0(a1)
 30e:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 312:	fee79ae3          	bne	a5,a4,306 <memmove+0x46>
 316:	bfc9                	j	2e8 <memmove+0x28>

0000000000000318 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 318:	1141                	addi	sp,sp,-16
 31a:	e422                	sd	s0,8(sp)
 31c:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 31e:	ca05                	beqz	a2,34e <memcmp+0x36>
 320:	fff6069b          	addiw	a3,a2,-1
 324:	1682                	slli	a3,a3,0x20
 326:	9281                	srli	a3,a3,0x20
 328:	0685                	addi	a3,a3,1
 32a:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 32c:	00054783          	lbu	a5,0(a0)
 330:	0005c703          	lbu	a4,0(a1)
 334:	00e79863          	bne	a5,a4,344 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 338:	0505                	addi	a0,a0,1
    p2++;
 33a:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 33c:	fed518e3          	bne	a0,a3,32c <memcmp+0x14>
  }
  return 0;
 340:	4501                	li	a0,0
 342:	a019                	j	348 <memcmp+0x30>
      return *p1 - *p2;
 344:	40e7853b          	subw	a0,a5,a4
}
 348:	6422                	ld	s0,8(sp)
 34a:	0141                	addi	sp,sp,16
 34c:	8082                	ret
  return 0;
 34e:	4501                	li	a0,0
 350:	bfe5                	j	348 <memcmp+0x30>

0000000000000352 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 352:	1141                	addi	sp,sp,-16
 354:	e406                	sd	ra,8(sp)
 356:	e022                	sd	s0,0(sp)
 358:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 35a:	00000097          	auipc	ra,0x0
 35e:	f66080e7          	jalr	-154(ra) # 2c0 <memmove>
}
 362:	60a2                	ld	ra,8(sp)
 364:	6402                	ld	s0,0(sp)
 366:	0141                	addi	sp,sp,16
 368:	8082                	ret

000000000000036a <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 36a:	4885                	li	a7,1
 ecall
 36c:	00000073          	ecall
 ret
 370:	8082                	ret

0000000000000372 <exit>:
.global exit
exit:
 li a7, SYS_exit
 372:	4889                	li	a7,2
 ecall
 374:	00000073          	ecall
 ret
 378:	8082                	ret

000000000000037a <wait>:
.global wait
wait:
 li a7, SYS_wait
 37a:	488d                	li	a7,3
 ecall
 37c:	00000073          	ecall
 ret
 380:	8082                	ret

0000000000000382 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 382:	4891                	li	a7,4
 ecall
 384:	00000073          	ecall
 ret
 388:	8082                	ret

000000000000038a <read>:
.global read
read:
 li a7, SYS_read
 38a:	4895                	li	a7,5
 ecall
 38c:	00000073          	ecall
 ret
 390:	8082                	ret

0000000000000392 <write>:
.global write
write:
 li a7, SYS_write
 392:	48c1                	li	a7,16
 ecall
 394:	00000073          	ecall
 ret
 398:	8082                	ret

000000000000039a <close>:
.global close
close:
 li a7, SYS_close
 39a:	48d5                	li	a7,21
 ecall
 39c:	00000073          	ecall
 ret
 3a0:	8082                	ret

00000000000003a2 <kill>:
.global kill
kill:
 li a7, SYS_kill
 3a2:	4899                	li	a7,6
 ecall
 3a4:	00000073          	ecall
 ret
 3a8:	8082                	ret

00000000000003aa <exec>:
.global exec
exec:
 li a7, SYS_exec
 3aa:	489d                	li	a7,7
 ecall
 3ac:	00000073          	ecall
 ret
 3b0:	8082                	ret

00000000000003b2 <open>:
.global open
open:
 li a7, SYS_open
 3b2:	48bd                	li	a7,15
 ecall
 3b4:	00000073          	ecall
 ret
 3b8:	8082                	ret

00000000000003ba <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 3ba:	48c5                	li	a7,17
 ecall
 3bc:	00000073          	ecall
 ret
 3c0:	8082                	ret

00000000000003c2 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 3c2:	48c9                	li	a7,18
 ecall
 3c4:	00000073          	ecall
 ret
 3c8:	8082                	ret

00000000000003ca <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 3ca:	48a1                	li	a7,8
 ecall
 3cc:	00000073          	ecall
 ret
 3d0:	8082                	ret

00000000000003d2 <link>:
.global link
link:
 li a7, SYS_link
 3d2:	48cd                	li	a7,19
 ecall
 3d4:	00000073          	ecall
 ret
 3d8:	8082                	ret

00000000000003da <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 3da:	48d1                	li	a7,20
 ecall
 3dc:	00000073          	ecall
 ret
 3e0:	8082                	ret

00000000000003e2 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 3e2:	48a5                	li	a7,9
 ecall
 3e4:	00000073          	ecall
 ret
 3e8:	8082                	ret

00000000000003ea <dup>:
.global dup
dup:
 li a7, SYS_dup
 3ea:	48a9                	li	a7,10
 ecall
 3ec:	00000073          	ecall
 ret
 3f0:	8082                	ret

00000000000003f2 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 3f2:	48ad                	li	a7,11
 ecall
 3f4:	00000073          	ecall
 ret
 3f8:	8082                	ret

00000000000003fa <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 3fa:	48b1                	li	a7,12
 ecall
 3fc:	00000073          	ecall
 ret
 400:	8082                	ret

0000000000000402 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 402:	48b5                	li	a7,13
 ecall
 404:	00000073          	ecall
 ret
 408:	8082                	ret

000000000000040a <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 40a:	48b9                	li	a7,14
 ecall
 40c:	00000073          	ecall
 ret
 410:	8082                	ret

0000000000000412 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 412:	1101                	addi	sp,sp,-32
 414:	ec06                	sd	ra,24(sp)
 416:	e822                	sd	s0,16(sp)
 418:	1000                	addi	s0,sp,32
 41a:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 41e:	4605                	li	a2,1
 420:	fef40593          	addi	a1,s0,-17
 424:	00000097          	auipc	ra,0x0
 428:	f6e080e7          	jalr	-146(ra) # 392 <write>
}
 42c:	60e2                	ld	ra,24(sp)
 42e:	6442                	ld	s0,16(sp)
 430:	6105                	addi	sp,sp,32
 432:	8082                	ret

0000000000000434 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 434:	7139                	addi	sp,sp,-64
 436:	fc06                	sd	ra,56(sp)
 438:	f822                	sd	s0,48(sp)
 43a:	f426                	sd	s1,40(sp)
 43c:	f04a                	sd	s2,32(sp)
 43e:	ec4e                	sd	s3,24(sp)
 440:	0080                	addi	s0,sp,64
 442:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 444:	c299                	beqz	a3,44a <printint+0x16>
 446:	0805c963          	bltz	a1,4d8 <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 44a:	2581                	sext.w	a1,a1
  neg = 0;
 44c:	4881                	li	a7,0
 44e:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 452:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 454:	2601                	sext.w	a2,a2
 456:	00000517          	auipc	a0,0x0
 45a:	49a50513          	addi	a0,a0,1178 # 8f0 <digits>
 45e:	883a                	mv	a6,a4
 460:	2705                	addiw	a4,a4,1
 462:	02c5f7bb          	remuw	a5,a1,a2
 466:	1782                	slli	a5,a5,0x20
 468:	9381                	srli	a5,a5,0x20
 46a:	97aa                	add	a5,a5,a0
 46c:	0007c783          	lbu	a5,0(a5)
 470:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 474:	0005879b          	sext.w	a5,a1
 478:	02c5d5bb          	divuw	a1,a1,a2
 47c:	0685                	addi	a3,a3,1
 47e:	fec7f0e3          	bgeu	a5,a2,45e <printint+0x2a>
  if(neg)
 482:	00088c63          	beqz	a7,49a <printint+0x66>
    buf[i++] = '-';
 486:	fd070793          	addi	a5,a4,-48
 48a:	00878733          	add	a4,a5,s0
 48e:	02d00793          	li	a5,45
 492:	fef70823          	sb	a5,-16(a4)
 496:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 49a:	02e05863          	blez	a4,4ca <printint+0x96>
 49e:	fc040793          	addi	a5,s0,-64
 4a2:	00e78933          	add	s2,a5,a4
 4a6:	fff78993          	addi	s3,a5,-1
 4aa:	99ba                	add	s3,s3,a4
 4ac:	377d                	addiw	a4,a4,-1
 4ae:	1702                	slli	a4,a4,0x20
 4b0:	9301                	srli	a4,a4,0x20
 4b2:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 4b6:	fff94583          	lbu	a1,-1(s2)
 4ba:	8526                	mv	a0,s1
 4bc:	00000097          	auipc	ra,0x0
 4c0:	f56080e7          	jalr	-170(ra) # 412 <putc>
  while(--i >= 0)
 4c4:	197d                	addi	s2,s2,-1
 4c6:	ff3918e3          	bne	s2,s3,4b6 <printint+0x82>
}
 4ca:	70e2                	ld	ra,56(sp)
 4cc:	7442                	ld	s0,48(sp)
 4ce:	74a2                	ld	s1,40(sp)
 4d0:	7902                	ld	s2,32(sp)
 4d2:	69e2                	ld	s3,24(sp)
 4d4:	6121                	addi	sp,sp,64
 4d6:	8082                	ret
    x = -xx;
 4d8:	40b005bb          	negw	a1,a1
    neg = 1;
 4dc:	4885                	li	a7,1
    x = -xx;
 4de:	bf85                	j	44e <printint+0x1a>

00000000000004e0 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 4e0:	7119                	addi	sp,sp,-128
 4e2:	fc86                	sd	ra,120(sp)
 4e4:	f8a2                	sd	s0,112(sp)
 4e6:	f4a6                	sd	s1,104(sp)
 4e8:	f0ca                	sd	s2,96(sp)
 4ea:	ecce                	sd	s3,88(sp)
 4ec:	e8d2                	sd	s4,80(sp)
 4ee:	e4d6                	sd	s5,72(sp)
 4f0:	e0da                	sd	s6,64(sp)
 4f2:	fc5e                	sd	s7,56(sp)
 4f4:	f862                	sd	s8,48(sp)
 4f6:	f466                	sd	s9,40(sp)
 4f8:	f06a                	sd	s10,32(sp)
 4fa:	ec6e                	sd	s11,24(sp)
 4fc:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 4fe:	0005c903          	lbu	s2,0(a1)
 502:	18090f63          	beqz	s2,6a0 <vprintf+0x1c0>
 506:	8aaa                	mv	s5,a0
 508:	8b32                	mv	s6,a2
 50a:	00158493          	addi	s1,a1,1
  state = 0;
 50e:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 510:	02500a13          	li	s4,37
 514:	4c55                	li	s8,21
 516:	00000c97          	auipc	s9,0x0
 51a:	382c8c93          	addi	s9,s9,898 # 898 <malloc+0xf4>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
        s = va_arg(ap, char*);
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 51e:	02800d93          	li	s11,40
  putc(fd, 'x');
 522:	4d41                	li	s10,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 524:	00000b97          	auipc	s7,0x0
 528:	3ccb8b93          	addi	s7,s7,972 # 8f0 <digits>
 52c:	a839                	j	54a <vprintf+0x6a>
        putc(fd, c);
 52e:	85ca                	mv	a1,s2
 530:	8556                	mv	a0,s5
 532:	00000097          	auipc	ra,0x0
 536:	ee0080e7          	jalr	-288(ra) # 412 <putc>
 53a:	a019                	j	540 <vprintf+0x60>
    } else if(state == '%'){
 53c:	01498d63          	beq	s3,s4,556 <vprintf+0x76>
  for(i = 0; fmt[i]; i++){
 540:	0485                	addi	s1,s1,1
 542:	fff4c903          	lbu	s2,-1(s1)
 546:	14090d63          	beqz	s2,6a0 <vprintf+0x1c0>
    if(state == 0){
 54a:	fe0999e3          	bnez	s3,53c <vprintf+0x5c>
      if(c == '%'){
 54e:	ff4910e3          	bne	s2,s4,52e <vprintf+0x4e>
        state = '%';
 552:	89d2                	mv	s3,s4
 554:	b7f5                	j	540 <vprintf+0x60>
      if(c == 'd'){
 556:	11490c63          	beq	s2,s4,66e <vprintf+0x18e>
 55a:	f9d9079b          	addiw	a5,s2,-99
 55e:	0ff7f793          	zext.b	a5,a5
 562:	10fc6e63          	bltu	s8,a5,67e <vprintf+0x19e>
 566:	f9d9079b          	addiw	a5,s2,-99
 56a:	0ff7f713          	zext.b	a4,a5
 56e:	10ec6863          	bltu	s8,a4,67e <vprintf+0x19e>
 572:	00271793          	slli	a5,a4,0x2
 576:	97e6                	add	a5,a5,s9
 578:	439c                	lw	a5,0(a5)
 57a:	97e6                	add	a5,a5,s9
 57c:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 57e:	008b0913          	addi	s2,s6,8
 582:	4685                	li	a3,1
 584:	4629                	li	a2,10
 586:	000b2583          	lw	a1,0(s6)
 58a:	8556                	mv	a0,s5
 58c:	00000097          	auipc	ra,0x0
 590:	ea8080e7          	jalr	-344(ra) # 434 <printint>
 594:	8b4a                	mv	s6,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 596:	4981                	li	s3,0
 598:	b765                	j	540 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 59a:	008b0913          	addi	s2,s6,8
 59e:	4681                	li	a3,0
 5a0:	4629                	li	a2,10
 5a2:	000b2583          	lw	a1,0(s6)
 5a6:	8556                	mv	a0,s5
 5a8:	00000097          	auipc	ra,0x0
 5ac:	e8c080e7          	jalr	-372(ra) # 434 <printint>
 5b0:	8b4a                	mv	s6,s2
      state = 0;
 5b2:	4981                	li	s3,0
 5b4:	b771                	j	540 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 5b6:	008b0913          	addi	s2,s6,8
 5ba:	4681                	li	a3,0
 5bc:	866a                	mv	a2,s10
 5be:	000b2583          	lw	a1,0(s6)
 5c2:	8556                	mv	a0,s5
 5c4:	00000097          	auipc	ra,0x0
 5c8:	e70080e7          	jalr	-400(ra) # 434 <printint>
 5cc:	8b4a                	mv	s6,s2
      state = 0;
 5ce:	4981                	li	s3,0
 5d0:	bf85                	j	540 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 5d2:	008b0793          	addi	a5,s6,8
 5d6:	f8f43423          	sd	a5,-120(s0)
 5da:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 5de:	03000593          	li	a1,48
 5e2:	8556                	mv	a0,s5
 5e4:	00000097          	auipc	ra,0x0
 5e8:	e2e080e7          	jalr	-466(ra) # 412 <putc>
  putc(fd, 'x');
 5ec:	07800593          	li	a1,120
 5f0:	8556                	mv	a0,s5
 5f2:	00000097          	auipc	ra,0x0
 5f6:	e20080e7          	jalr	-480(ra) # 412 <putc>
 5fa:	896a                	mv	s2,s10
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 5fc:	03c9d793          	srli	a5,s3,0x3c
 600:	97de                	add	a5,a5,s7
 602:	0007c583          	lbu	a1,0(a5)
 606:	8556                	mv	a0,s5
 608:	00000097          	auipc	ra,0x0
 60c:	e0a080e7          	jalr	-502(ra) # 412 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 610:	0992                	slli	s3,s3,0x4
 612:	397d                	addiw	s2,s2,-1
 614:	fe0914e3          	bnez	s2,5fc <vprintf+0x11c>
        printptr(fd, va_arg(ap, uint64));
 618:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 61c:	4981                	li	s3,0
 61e:	b70d                	j	540 <vprintf+0x60>
        s = va_arg(ap, char*);
 620:	008b0913          	addi	s2,s6,8
 624:	000b3983          	ld	s3,0(s6)
        if(s == 0)
 628:	02098163          	beqz	s3,64a <vprintf+0x16a>
        while(*s != 0){
 62c:	0009c583          	lbu	a1,0(s3)
 630:	c5ad                	beqz	a1,69a <vprintf+0x1ba>
          putc(fd, *s);
 632:	8556                	mv	a0,s5
 634:	00000097          	auipc	ra,0x0
 638:	dde080e7          	jalr	-546(ra) # 412 <putc>
          s++;
 63c:	0985                	addi	s3,s3,1
        while(*s != 0){
 63e:	0009c583          	lbu	a1,0(s3)
 642:	f9e5                	bnez	a1,632 <vprintf+0x152>
        s = va_arg(ap, char*);
 644:	8b4a                	mv	s6,s2
      state = 0;
 646:	4981                	li	s3,0
 648:	bde5                	j	540 <vprintf+0x60>
          s = "(null)";
 64a:	00000997          	auipc	s3,0x0
 64e:	24698993          	addi	s3,s3,582 # 890 <malloc+0xec>
        while(*s != 0){
 652:	85ee                	mv	a1,s11
 654:	bff9                	j	632 <vprintf+0x152>
        putc(fd, va_arg(ap, uint));
 656:	008b0913          	addi	s2,s6,8
 65a:	000b4583          	lbu	a1,0(s6)
 65e:	8556                	mv	a0,s5
 660:	00000097          	auipc	ra,0x0
 664:	db2080e7          	jalr	-590(ra) # 412 <putc>
 668:	8b4a                	mv	s6,s2
      state = 0;
 66a:	4981                	li	s3,0
 66c:	bdd1                	j	540 <vprintf+0x60>
        putc(fd, c);
 66e:	85d2                	mv	a1,s4
 670:	8556                	mv	a0,s5
 672:	00000097          	auipc	ra,0x0
 676:	da0080e7          	jalr	-608(ra) # 412 <putc>
      state = 0;
 67a:	4981                	li	s3,0
 67c:	b5d1                	j	540 <vprintf+0x60>
        putc(fd, '%');
 67e:	85d2                	mv	a1,s4
 680:	8556                	mv	a0,s5
 682:	00000097          	auipc	ra,0x0
 686:	d90080e7          	jalr	-624(ra) # 412 <putc>
        putc(fd, c);
 68a:	85ca                	mv	a1,s2
 68c:	8556                	mv	a0,s5
 68e:	00000097          	auipc	ra,0x0
 692:	d84080e7          	jalr	-636(ra) # 412 <putc>
      state = 0;
 696:	4981                	li	s3,0
 698:	b565                	j	540 <vprintf+0x60>
        s = va_arg(ap, char*);
 69a:	8b4a                	mv	s6,s2
      state = 0;
 69c:	4981                	li	s3,0
 69e:	b54d                	j	540 <vprintf+0x60>
    }
  }
}
 6a0:	70e6                	ld	ra,120(sp)
 6a2:	7446                	ld	s0,112(sp)
 6a4:	74a6                	ld	s1,104(sp)
 6a6:	7906                	ld	s2,96(sp)
 6a8:	69e6                	ld	s3,88(sp)
 6aa:	6a46                	ld	s4,80(sp)
 6ac:	6aa6                	ld	s5,72(sp)
 6ae:	6b06                	ld	s6,64(sp)
 6b0:	7be2                	ld	s7,56(sp)
 6b2:	7c42                	ld	s8,48(sp)
 6b4:	7ca2                	ld	s9,40(sp)
 6b6:	7d02                	ld	s10,32(sp)
 6b8:	6de2                	ld	s11,24(sp)
 6ba:	6109                	addi	sp,sp,128
 6bc:	8082                	ret

00000000000006be <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 6be:	715d                	addi	sp,sp,-80
 6c0:	ec06                	sd	ra,24(sp)
 6c2:	e822                	sd	s0,16(sp)
 6c4:	1000                	addi	s0,sp,32
 6c6:	e010                	sd	a2,0(s0)
 6c8:	e414                	sd	a3,8(s0)
 6ca:	e818                	sd	a4,16(s0)
 6cc:	ec1c                	sd	a5,24(s0)
 6ce:	03043023          	sd	a6,32(s0)
 6d2:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 6d6:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 6da:	8622                	mv	a2,s0
 6dc:	00000097          	auipc	ra,0x0
 6e0:	e04080e7          	jalr	-508(ra) # 4e0 <vprintf>
}
 6e4:	60e2                	ld	ra,24(sp)
 6e6:	6442                	ld	s0,16(sp)
 6e8:	6161                	addi	sp,sp,80
 6ea:	8082                	ret

00000000000006ec <printf>:

void
printf(const char *fmt, ...)
{
 6ec:	711d                	addi	sp,sp,-96
 6ee:	ec06                	sd	ra,24(sp)
 6f0:	e822                	sd	s0,16(sp)
 6f2:	1000                	addi	s0,sp,32
 6f4:	e40c                	sd	a1,8(s0)
 6f6:	e810                	sd	a2,16(s0)
 6f8:	ec14                	sd	a3,24(s0)
 6fa:	f018                	sd	a4,32(s0)
 6fc:	f41c                	sd	a5,40(s0)
 6fe:	03043823          	sd	a6,48(s0)
 702:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 706:	00840613          	addi	a2,s0,8
 70a:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 70e:	85aa                	mv	a1,a0
 710:	4505                	li	a0,1
 712:	00000097          	auipc	ra,0x0
 716:	dce080e7          	jalr	-562(ra) # 4e0 <vprintf>
}
 71a:	60e2                	ld	ra,24(sp)
 71c:	6442                	ld	s0,16(sp)
 71e:	6125                	addi	sp,sp,96
 720:	8082                	ret

0000000000000722 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 722:	1141                	addi	sp,sp,-16
 724:	e422                	sd	s0,8(sp)
 726:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 728:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 72c:	00000797          	auipc	a5,0x0
 730:	1dc7b783          	ld	a5,476(a5) # 908 <freep>
 734:	a02d                	j	75e <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 736:	4618                	lw	a4,8(a2)
 738:	9f2d                	addw	a4,a4,a1
 73a:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 73e:	6398                	ld	a4,0(a5)
 740:	6310                	ld	a2,0(a4)
 742:	a83d                	j	780 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 744:	ff852703          	lw	a4,-8(a0)
 748:	9f31                	addw	a4,a4,a2
 74a:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 74c:	ff053683          	ld	a3,-16(a0)
 750:	a091                	j	794 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 752:	6398                	ld	a4,0(a5)
 754:	00e7e463          	bltu	a5,a4,75c <free+0x3a>
 758:	00e6ea63          	bltu	a3,a4,76c <free+0x4a>
{
 75c:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 75e:	fed7fae3          	bgeu	a5,a3,752 <free+0x30>
 762:	6398                	ld	a4,0(a5)
 764:	00e6e463          	bltu	a3,a4,76c <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 768:	fee7eae3          	bltu	a5,a4,75c <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 76c:	ff852583          	lw	a1,-8(a0)
 770:	6390                	ld	a2,0(a5)
 772:	02059813          	slli	a6,a1,0x20
 776:	01c85713          	srli	a4,a6,0x1c
 77a:	9736                	add	a4,a4,a3
 77c:	fae60de3          	beq	a2,a4,736 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 780:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 784:	4790                	lw	a2,8(a5)
 786:	02061593          	slli	a1,a2,0x20
 78a:	01c5d713          	srli	a4,a1,0x1c
 78e:	973e                	add	a4,a4,a5
 790:	fae68ae3          	beq	a3,a4,744 <free+0x22>
    p->s.ptr = bp->s.ptr;
 794:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 796:	00000717          	auipc	a4,0x0
 79a:	16f73923          	sd	a5,370(a4) # 908 <freep>
}
 79e:	6422                	ld	s0,8(sp)
 7a0:	0141                	addi	sp,sp,16
 7a2:	8082                	ret

00000000000007a4 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 7a4:	7139                	addi	sp,sp,-64
 7a6:	fc06                	sd	ra,56(sp)
 7a8:	f822                	sd	s0,48(sp)
 7aa:	f426                	sd	s1,40(sp)
 7ac:	f04a                	sd	s2,32(sp)
 7ae:	ec4e                	sd	s3,24(sp)
 7b0:	e852                	sd	s4,16(sp)
 7b2:	e456                	sd	s5,8(sp)
 7b4:	e05a                	sd	s6,0(sp)
 7b6:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7b8:	02051493          	slli	s1,a0,0x20
 7bc:	9081                	srli	s1,s1,0x20
 7be:	04bd                	addi	s1,s1,15
 7c0:	8091                	srli	s1,s1,0x4
 7c2:	0014899b          	addiw	s3,s1,1
 7c6:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 7c8:	00000517          	auipc	a0,0x0
 7cc:	14053503          	ld	a0,320(a0) # 908 <freep>
 7d0:	c515                	beqz	a0,7fc <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7d2:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 7d4:	4798                	lw	a4,8(a5)
 7d6:	02977f63          	bgeu	a4,s1,814 <malloc+0x70>
 7da:	8a4e                	mv	s4,s3
 7dc:	0009871b          	sext.w	a4,s3
 7e0:	6685                	lui	a3,0x1
 7e2:	00d77363          	bgeu	a4,a3,7e8 <malloc+0x44>
 7e6:	6a05                	lui	s4,0x1
 7e8:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 7ec:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 7f0:	00000917          	auipc	s2,0x0
 7f4:	11890913          	addi	s2,s2,280 # 908 <freep>
  if(p == (char*)-1)
 7f8:	5afd                	li	s5,-1
 7fa:	a895                	j	86e <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
 7fc:	00000797          	auipc	a5,0x0
 800:	11478793          	addi	a5,a5,276 # 910 <base>
 804:	00000717          	auipc	a4,0x0
 808:	10f73223          	sd	a5,260(a4) # 908 <freep>
 80c:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 80e:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 812:	b7e1                	j	7da <malloc+0x36>
      if(p->s.size == nunits)
 814:	02e48c63          	beq	s1,a4,84c <malloc+0xa8>
        p->s.size -= nunits;
 818:	4137073b          	subw	a4,a4,s3
 81c:	c798                	sw	a4,8(a5)
        p += p->s.size;
 81e:	02071693          	slli	a3,a4,0x20
 822:	01c6d713          	srli	a4,a3,0x1c
 826:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 828:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 82c:	00000717          	auipc	a4,0x0
 830:	0ca73e23          	sd	a0,220(a4) # 908 <freep>
      return (void*)(p + 1);
 834:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 838:	70e2                	ld	ra,56(sp)
 83a:	7442                	ld	s0,48(sp)
 83c:	74a2                	ld	s1,40(sp)
 83e:	7902                	ld	s2,32(sp)
 840:	69e2                	ld	s3,24(sp)
 842:	6a42                	ld	s4,16(sp)
 844:	6aa2                	ld	s5,8(sp)
 846:	6b02                	ld	s6,0(sp)
 848:	6121                	addi	sp,sp,64
 84a:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 84c:	6398                	ld	a4,0(a5)
 84e:	e118                	sd	a4,0(a0)
 850:	bff1                	j	82c <malloc+0x88>
  hp->s.size = nu;
 852:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 856:	0541                	addi	a0,a0,16
 858:	00000097          	auipc	ra,0x0
 85c:	eca080e7          	jalr	-310(ra) # 722 <free>
  return freep;
 860:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 864:	d971                	beqz	a0,838 <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 866:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 868:	4798                	lw	a4,8(a5)
 86a:	fa9775e3          	bgeu	a4,s1,814 <malloc+0x70>
    if(p == freep)
 86e:	00093703          	ld	a4,0(s2)
 872:	853e                	mv	a0,a5
 874:	fef719e3          	bne	a4,a5,866 <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
 878:	8552                	mv	a0,s4
 87a:	00000097          	auipc	ra,0x0
 87e:	b80080e7          	jalr	-1152(ra) # 3fa <sbrk>
  if(p == (char*)-1)
 882:	fd5518e3          	bne	a0,s5,852 <malloc+0xae>
        return 0;
 886:	4501                	li	a0,0
 888:	bf45                	j	838 <malloc+0x94>
