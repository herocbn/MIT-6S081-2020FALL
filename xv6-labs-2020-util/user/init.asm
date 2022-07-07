
user/_init：     文件格式 elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:

char *argv[] = { "sh", 0 };

int
main(void)
{
   0:	1101                	addi	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	e426                	sd	s1,8(sp)
   8:	e04a                	sd	s2,0(sp)
   a:	1000                	addi	s0,sp,32
  int pid, wpid;

  if(open("console", O_RDWR) < 0){
   c:	4589                	li	a1,2
   e:	00001517          	auipc	a0,0x1
  12:	87250513          	addi	a0,a0,-1934 # 880 <malloc+0xea>
  16:	00000097          	auipc	ra,0x0
  1a:	38e080e7          	jalr	910(ra) # 3a4 <open>
  1e:	06054363          	bltz	a0,84 <main+0x84>
    mknod("console", CONSOLE, 0);
    open("console", O_RDWR);
  }
  dup(0);  // stdout
  22:	4501                	li	a0,0
  24:	00000097          	auipc	ra,0x0
  28:	3b8080e7          	jalr	952(ra) # 3dc <dup>
  dup(0);  // stderr
  2c:	4501                	li	a0,0
  2e:	00000097          	auipc	ra,0x0
  32:	3ae080e7          	jalr	942(ra) # 3dc <dup>

  for(;;){
    printf("init: starting sh\n");
  36:	00001917          	auipc	s2,0x1
  3a:	85290913          	addi	s2,s2,-1966 # 888 <malloc+0xf2>
  3e:	854a                	mv	a0,s2
  40:	00000097          	auipc	ra,0x0
  44:	69e080e7          	jalr	1694(ra) # 6de <printf>
    pid = fork();
  48:	00000097          	auipc	ra,0x0
  4c:	314080e7          	jalr	788(ra) # 35c <fork>
  50:	84aa                	mv	s1,a0
    if(pid < 0){
  52:	04054d63          	bltz	a0,ac <main+0xac>
      printf("init: fork failed\n");
      exit(1);
    }
    if(pid == 0){
  56:	c925                	beqz	a0,c6 <main+0xc6>
    }

    for(;;){
      // this call to wait() returns if the shell exits,
      // or if a parentless process exits.
      wpid = wait((int *) 0);
  58:	4501                	li	a0,0
  5a:	00000097          	auipc	ra,0x0
  5e:	312080e7          	jalr	786(ra) # 36c <wait>
      if(wpid == pid){
  62:	fca48ee3          	beq	s1,a0,3e <main+0x3e>
        // the shell exited; restart it.
        break;
      } else if(wpid < 0){
  66:	fe0559e3          	bgez	a0,58 <main+0x58>
        printf("init: wait returned an error\n");
  6a:	00001517          	auipc	a0,0x1
  6e:	86e50513          	addi	a0,a0,-1938 # 8d8 <malloc+0x142>
  72:	00000097          	auipc	ra,0x0
  76:	66c080e7          	jalr	1644(ra) # 6de <printf>
        exit(1);
  7a:	4505                	li	a0,1
  7c:	00000097          	auipc	ra,0x0
  80:	2e8080e7          	jalr	744(ra) # 364 <exit>
    mknod("console", CONSOLE, 0);
  84:	4601                	li	a2,0
  86:	4585                	li	a1,1
  88:	00000517          	auipc	a0,0x0
  8c:	7f850513          	addi	a0,a0,2040 # 880 <malloc+0xea>
  90:	00000097          	auipc	ra,0x0
  94:	31c080e7          	jalr	796(ra) # 3ac <mknod>
    open("console", O_RDWR);
  98:	4589                	li	a1,2
  9a:	00000517          	auipc	a0,0x0
  9e:	7e650513          	addi	a0,a0,2022 # 880 <malloc+0xea>
  a2:	00000097          	auipc	ra,0x0
  a6:	302080e7          	jalr	770(ra) # 3a4 <open>
  aa:	bfa5                	j	22 <main+0x22>
      printf("init: fork failed\n");
  ac:	00000517          	auipc	a0,0x0
  b0:	7f450513          	addi	a0,a0,2036 # 8a0 <malloc+0x10a>
  b4:	00000097          	auipc	ra,0x0
  b8:	62a080e7          	jalr	1578(ra) # 6de <printf>
      exit(1);
  bc:	4505                	li	a0,1
  be:	00000097          	auipc	ra,0x0
  c2:	2a6080e7          	jalr	678(ra) # 364 <exit>
      exec("sh", argv);
  c6:	00001597          	auipc	a1,0x1
  ca:	8aa58593          	addi	a1,a1,-1878 # 970 <argv>
  ce:	00000517          	auipc	a0,0x0
  d2:	7ea50513          	addi	a0,a0,2026 # 8b8 <malloc+0x122>
  d6:	00000097          	auipc	ra,0x0
  da:	2c6080e7          	jalr	710(ra) # 39c <exec>
      printf("init: exec sh failed\n");
  de:	00000517          	auipc	a0,0x0
  e2:	7e250513          	addi	a0,a0,2018 # 8c0 <malloc+0x12a>
  e6:	00000097          	auipc	ra,0x0
  ea:	5f8080e7          	jalr	1528(ra) # 6de <printf>
      exit(1);
  ee:	4505                	li	a0,1
  f0:	00000097          	auipc	ra,0x0
  f4:	274080e7          	jalr	628(ra) # 364 <exit>

00000000000000f8 <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
  f8:	1141                	addi	sp,sp,-16
  fa:	e422                	sd	s0,8(sp)
  fc:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  fe:	87aa                	mv	a5,a0
 100:	0585                	addi	a1,a1,1
 102:	0785                	addi	a5,a5,1
 104:	fff5c703          	lbu	a4,-1(a1)
 108:	fee78fa3          	sb	a4,-1(a5)
 10c:	fb75                	bnez	a4,100 <strcpy+0x8>
    ;
  return os;
}
 10e:	6422                	ld	s0,8(sp)
 110:	0141                	addi	sp,sp,16
 112:	8082                	ret

0000000000000114 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 114:	1141                	addi	sp,sp,-16
 116:	e422                	sd	s0,8(sp)
 118:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 11a:	00054783          	lbu	a5,0(a0)
 11e:	cb91                	beqz	a5,132 <strcmp+0x1e>
 120:	0005c703          	lbu	a4,0(a1)
 124:	00f71763          	bne	a4,a5,132 <strcmp+0x1e>
    p++, q++;
 128:	0505                	addi	a0,a0,1
 12a:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 12c:	00054783          	lbu	a5,0(a0)
 130:	fbe5                	bnez	a5,120 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 132:	0005c503          	lbu	a0,0(a1)
}
 136:	40a7853b          	subw	a0,a5,a0
 13a:	6422                	ld	s0,8(sp)
 13c:	0141                	addi	sp,sp,16
 13e:	8082                	ret

0000000000000140 <strlen>:

uint
strlen(const char *s)
{
 140:	1141                	addi	sp,sp,-16
 142:	e422                	sd	s0,8(sp)
 144:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 146:	00054783          	lbu	a5,0(a0)
 14a:	cf91                	beqz	a5,166 <strlen+0x26>
 14c:	0505                	addi	a0,a0,1
 14e:	87aa                	mv	a5,a0
 150:	4685                	li	a3,1
 152:	9e89                	subw	a3,a3,a0
 154:	00f6853b          	addw	a0,a3,a5
 158:	0785                	addi	a5,a5,1
 15a:	fff7c703          	lbu	a4,-1(a5)
 15e:	fb7d                	bnez	a4,154 <strlen+0x14>
    ;
  return n;
}
 160:	6422                	ld	s0,8(sp)
 162:	0141                	addi	sp,sp,16
 164:	8082                	ret
  for(n = 0; s[n]; n++)
 166:	4501                	li	a0,0
 168:	bfe5                	j	160 <strlen+0x20>

000000000000016a <memset>:

void*
memset(void *dst, int c, uint n)
{
 16a:	1141                	addi	sp,sp,-16
 16c:	e422                	sd	s0,8(sp)
 16e:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 170:	ca19                	beqz	a2,186 <memset+0x1c>
 172:	87aa                	mv	a5,a0
 174:	1602                	slli	a2,a2,0x20
 176:	9201                	srli	a2,a2,0x20
 178:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 17c:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 180:	0785                	addi	a5,a5,1
 182:	fee79de3          	bne	a5,a4,17c <memset+0x12>
  }
  return dst;
}
 186:	6422                	ld	s0,8(sp)
 188:	0141                	addi	sp,sp,16
 18a:	8082                	ret

000000000000018c <strchr>:

char*
strchr(const char *s, char c)
{
 18c:	1141                	addi	sp,sp,-16
 18e:	e422                	sd	s0,8(sp)
 190:	0800                	addi	s0,sp,16
  for(; *s; s++)
 192:	00054783          	lbu	a5,0(a0)
 196:	cb99                	beqz	a5,1ac <strchr+0x20>
    if(*s == c)
 198:	00f58763          	beq	a1,a5,1a6 <strchr+0x1a>
  for(; *s; s++)
 19c:	0505                	addi	a0,a0,1
 19e:	00054783          	lbu	a5,0(a0)
 1a2:	fbfd                	bnez	a5,198 <strchr+0xc>
      return (char*)s;
  return 0;
 1a4:	4501                	li	a0,0
}
 1a6:	6422                	ld	s0,8(sp)
 1a8:	0141                	addi	sp,sp,16
 1aa:	8082                	ret
  return 0;
 1ac:	4501                	li	a0,0
 1ae:	bfe5                	j	1a6 <strchr+0x1a>

00000000000001b0 <gets>:

char*
gets(char *buf, int max)
{
 1b0:	711d                	addi	sp,sp,-96
 1b2:	ec86                	sd	ra,88(sp)
 1b4:	e8a2                	sd	s0,80(sp)
 1b6:	e4a6                	sd	s1,72(sp)
 1b8:	e0ca                	sd	s2,64(sp)
 1ba:	fc4e                	sd	s3,56(sp)
 1bc:	f852                	sd	s4,48(sp)
 1be:	f456                	sd	s5,40(sp)
 1c0:	f05a                	sd	s6,32(sp)
 1c2:	ec5e                	sd	s7,24(sp)
 1c4:	1080                	addi	s0,sp,96
 1c6:	8baa                	mv	s7,a0
 1c8:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1ca:	892a                	mv	s2,a0
 1cc:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 1ce:	4aa9                	li	s5,10
 1d0:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 1d2:	89a6                	mv	s3,s1
 1d4:	2485                	addiw	s1,s1,1
 1d6:	0344d863          	bge	s1,s4,206 <gets+0x56>
    cc = read(0, &c, 1);
 1da:	4605                	li	a2,1
 1dc:	faf40593          	addi	a1,s0,-81
 1e0:	4501                	li	a0,0
 1e2:	00000097          	auipc	ra,0x0
 1e6:	19a080e7          	jalr	410(ra) # 37c <read>
    if(cc < 1)
 1ea:	00a05e63          	blez	a0,206 <gets+0x56>
    buf[i++] = c;
 1ee:	faf44783          	lbu	a5,-81(s0)
 1f2:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 1f6:	01578763          	beq	a5,s5,204 <gets+0x54>
 1fa:	0905                	addi	s2,s2,1
 1fc:	fd679be3          	bne	a5,s6,1d2 <gets+0x22>
  for(i=0; i+1 < max; ){
 200:	89a6                	mv	s3,s1
 202:	a011                	j	206 <gets+0x56>
 204:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 206:	99de                	add	s3,s3,s7
 208:	00098023          	sb	zero,0(s3)
  return buf;
}
 20c:	855e                	mv	a0,s7
 20e:	60e6                	ld	ra,88(sp)
 210:	6446                	ld	s0,80(sp)
 212:	64a6                	ld	s1,72(sp)
 214:	6906                	ld	s2,64(sp)
 216:	79e2                	ld	s3,56(sp)
 218:	7a42                	ld	s4,48(sp)
 21a:	7aa2                	ld	s5,40(sp)
 21c:	7b02                	ld	s6,32(sp)
 21e:	6be2                	ld	s7,24(sp)
 220:	6125                	addi	sp,sp,96
 222:	8082                	ret

0000000000000224 <stat>:

int
stat(const char *n, struct stat *st)
{
 224:	1101                	addi	sp,sp,-32
 226:	ec06                	sd	ra,24(sp)
 228:	e822                	sd	s0,16(sp)
 22a:	e426                	sd	s1,8(sp)
 22c:	e04a                	sd	s2,0(sp)
 22e:	1000                	addi	s0,sp,32
 230:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 232:	4581                	li	a1,0
 234:	00000097          	auipc	ra,0x0
 238:	170080e7          	jalr	368(ra) # 3a4 <open>
  if(fd < 0)
 23c:	02054563          	bltz	a0,266 <stat+0x42>
 240:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 242:	85ca                	mv	a1,s2
 244:	00000097          	auipc	ra,0x0
 248:	178080e7          	jalr	376(ra) # 3bc <fstat>
 24c:	892a                	mv	s2,a0
  close(fd);
 24e:	8526                	mv	a0,s1
 250:	00000097          	auipc	ra,0x0
 254:	13c080e7          	jalr	316(ra) # 38c <close>
  return r;
}
 258:	854a                	mv	a0,s2
 25a:	60e2                	ld	ra,24(sp)
 25c:	6442                	ld	s0,16(sp)
 25e:	64a2                	ld	s1,8(sp)
 260:	6902                	ld	s2,0(sp)
 262:	6105                	addi	sp,sp,32
 264:	8082                	ret
    return -1;
 266:	597d                	li	s2,-1
 268:	bfc5                	j	258 <stat+0x34>

000000000000026a <atoi>:

int
atoi(const char *s)
{
 26a:	1141                	addi	sp,sp,-16
 26c:	e422                	sd	s0,8(sp)
 26e:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 270:	00054683          	lbu	a3,0(a0)
 274:	fd06879b          	addiw	a5,a3,-48
 278:	0ff7f793          	zext.b	a5,a5
 27c:	4625                	li	a2,9
 27e:	02f66863          	bltu	a2,a5,2ae <atoi+0x44>
 282:	872a                	mv	a4,a0
  n = 0;
 284:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 286:	0705                	addi	a4,a4,1
 288:	0025179b          	slliw	a5,a0,0x2
 28c:	9fa9                	addw	a5,a5,a0
 28e:	0017979b          	slliw	a5,a5,0x1
 292:	9fb5                	addw	a5,a5,a3
 294:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 298:	00074683          	lbu	a3,0(a4)
 29c:	fd06879b          	addiw	a5,a3,-48
 2a0:	0ff7f793          	zext.b	a5,a5
 2a4:	fef671e3          	bgeu	a2,a5,286 <atoi+0x1c>
  return n;
}
 2a8:	6422                	ld	s0,8(sp)
 2aa:	0141                	addi	sp,sp,16
 2ac:	8082                	ret
  n = 0;
 2ae:	4501                	li	a0,0
 2b0:	bfe5                	j	2a8 <atoi+0x3e>

00000000000002b2 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 2b2:	1141                	addi	sp,sp,-16
 2b4:	e422                	sd	s0,8(sp)
 2b6:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 2b8:	02b57463          	bgeu	a0,a1,2e0 <memmove+0x2e>
    while(n-- > 0)
 2bc:	00c05f63          	blez	a2,2da <memmove+0x28>
 2c0:	1602                	slli	a2,a2,0x20
 2c2:	9201                	srli	a2,a2,0x20
 2c4:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 2c8:	872a                	mv	a4,a0
      *dst++ = *src++;
 2ca:	0585                	addi	a1,a1,1
 2cc:	0705                	addi	a4,a4,1
 2ce:	fff5c683          	lbu	a3,-1(a1)
 2d2:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 2d6:	fee79ae3          	bne	a5,a4,2ca <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 2da:	6422                	ld	s0,8(sp)
 2dc:	0141                	addi	sp,sp,16
 2de:	8082                	ret
    dst += n;
 2e0:	00c50733          	add	a4,a0,a2
    src += n;
 2e4:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 2e6:	fec05ae3          	blez	a2,2da <memmove+0x28>
 2ea:	fff6079b          	addiw	a5,a2,-1
 2ee:	1782                	slli	a5,a5,0x20
 2f0:	9381                	srli	a5,a5,0x20
 2f2:	fff7c793          	not	a5,a5
 2f6:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 2f8:	15fd                	addi	a1,a1,-1
 2fa:	177d                	addi	a4,a4,-1
 2fc:	0005c683          	lbu	a3,0(a1)
 300:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 304:	fee79ae3          	bne	a5,a4,2f8 <memmove+0x46>
 308:	bfc9                	j	2da <memmove+0x28>

000000000000030a <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 30a:	1141                	addi	sp,sp,-16
 30c:	e422                	sd	s0,8(sp)
 30e:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 310:	ca05                	beqz	a2,340 <memcmp+0x36>
 312:	fff6069b          	addiw	a3,a2,-1
 316:	1682                	slli	a3,a3,0x20
 318:	9281                	srli	a3,a3,0x20
 31a:	0685                	addi	a3,a3,1
 31c:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 31e:	00054783          	lbu	a5,0(a0)
 322:	0005c703          	lbu	a4,0(a1)
 326:	00e79863          	bne	a5,a4,336 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 32a:	0505                	addi	a0,a0,1
    p2++;
 32c:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 32e:	fed518e3          	bne	a0,a3,31e <memcmp+0x14>
  }
  return 0;
 332:	4501                	li	a0,0
 334:	a019                	j	33a <memcmp+0x30>
      return *p1 - *p2;
 336:	40e7853b          	subw	a0,a5,a4
}
 33a:	6422                	ld	s0,8(sp)
 33c:	0141                	addi	sp,sp,16
 33e:	8082                	ret
  return 0;
 340:	4501                	li	a0,0
 342:	bfe5                	j	33a <memcmp+0x30>

0000000000000344 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 344:	1141                	addi	sp,sp,-16
 346:	e406                	sd	ra,8(sp)
 348:	e022                	sd	s0,0(sp)
 34a:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 34c:	00000097          	auipc	ra,0x0
 350:	f66080e7          	jalr	-154(ra) # 2b2 <memmove>
}
 354:	60a2                	ld	ra,8(sp)
 356:	6402                	ld	s0,0(sp)
 358:	0141                	addi	sp,sp,16
 35a:	8082                	ret

000000000000035c <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 35c:	4885                	li	a7,1
 ecall
 35e:	00000073          	ecall
 ret
 362:	8082                	ret

0000000000000364 <exit>:
.global exit
exit:
 li a7, SYS_exit
 364:	4889                	li	a7,2
 ecall
 366:	00000073          	ecall
 ret
 36a:	8082                	ret

000000000000036c <wait>:
.global wait
wait:
 li a7, SYS_wait
 36c:	488d                	li	a7,3
 ecall
 36e:	00000073          	ecall
 ret
 372:	8082                	ret

0000000000000374 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 374:	4891                	li	a7,4
 ecall
 376:	00000073          	ecall
 ret
 37a:	8082                	ret

000000000000037c <read>:
.global read
read:
 li a7, SYS_read
 37c:	4895                	li	a7,5
 ecall
 37e:	00000073          	ecall
 ret
 382:	8082                	ret

0000000000000384 <write>:
.global write
write:
 li a7, SYS_write
 384:	48c1                	li	a7,16
 ecall
 386:	00000073          	ecall
 ret
 38a:	8082                	ret

000000000000038c <close>:
.global close
close:
 li a7, SYS_close
 38c:	48d5                	li	a7,21
 ecall
 38e:	00000073          	ecall
 ret
 392:	8082                	ret

0000000000000394 <kill>:
.global kill
kill:
 li a7, SYS_kill
 394:	4899                	li	a7,6
 ecall
 396:	00000073          	ecall
 ret
 39a:	8082                	ret

000000000000039c <exec>:
.global exec
exec:
 li a7, SYS_exec
 39c:	489d                	li	a7,7
 ecall
 39e:	00000073          	ecall
 ret
 3a2:	8082                	ret

00000000000003a4 <open>:
.global open
open:
 li a7, SYS_open
 3a4:	48bd                	li	a7,15
 ecall
 3a6:	00000073          	ecall
 ret
 3aa:	8082                	ret

00000000000003ac <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 3ac:	48c5                	li	a7,17
 ecall
 3ae:	00000073          	ecall
 ret
 3b2:	8082                	ret

00000000000003b4 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 3b4:	48c9                	li	a7,18
 ecall
 3b6:	00000073          	ecall
 ret
 3ba:	8082                	ret

00000000000003bc <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 3bc:	48a1                	li	a7,8
 ecall
 3be:	00000073          	ecall
 ret
 3c2:	8082                	ret

00000000000003c4 <link>:
.global link
link:
 li a7, SYS_link
 3c4:	48cd                	li	a7,19
 ecall
 3c6:	00000073          	ecall
 ret
 3ca:	8082                	ret

00000000000003cc <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 3cc:	48d1                	li	a7,20
 ecall
 3ce:	00000073          	ecall
 ret
 3d2:	8082                	ret

00000000000003d4 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 3d4:	48a5                	li	a7,9
 ecall
 3d6:	00000073          	ecall
 ret
 3da:	8082                	ret

00000000000003dc <dup>:
.global dup
dup:
 li a7, SYS_dup
 3dc:	48a9                	li	a7,10
 ecall
 3de:	00000073          	ecall
 ret
 3e2:	8082                	ret

00000000000003e4 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 3e4:	48ad                	li	a7,11
 ecall
 3e6:	00000073          	ecall
 ret
 3ea:	8082                	ret

00000000000003ec <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 3ec:	48b1                	li	a7,12
 ecall
 3ee:	00000073          	ecall
 ret
 3f2:	8082                	ret

00000000000003f4 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 3f4:	48b5                	li	a7,13
 ecall
 3f6:	00000073          	ecall
 ret
 3fa:	8082                	ret

00000000000003fc <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 3fc:	48b9                	li	a7,14
 ecall
 3fe:	00000073          	ecall
 ret
 402:	8082                	ret

0000000000000404 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 404:	1101                	addi	sp,sp,-32
 406:	ec06                	sd	ra,24(sp)
 408:	e822                	sd	s0,16(sp)
 40a:	1000                	addi	s0,sp,32
 40c:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 410:	4605                	li	a2,1
 412:	fef40593          	addi	a1,s0,-17
 416:	00000097          	auipc	ra,0x0
 41a:	f6e080e7          	jalr	-146(ra) # 384 <write>
}
 41e:	60e2                	ld	ra,24(sp)
 420:	6442                	ld	s0,16(sp)
 422:	6105                	addi	sp,sp,32
 424:	8082                	ret

0000000000000426 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 426:	7139                	addi	sp,sp,-64
 428:	fc06                	sd	ra,56(sp)
 42a:	f822                	sd	s0,48(sp)
 42c:	f426                	sd	s1,40(sp)
 42e:	f04a                	sd	s2,32(sp)
 430:	ec4e                	sd	s3,24(sp)
 432:	0080                	addi	s0,sp,64
 434:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 436:	c299                	beqz	a3,43c <printint+0x16>
 438:	0805c963          	bltz	a1,4ca <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 43c:	2581                	sext.w	a1,a1
  neg = 0;
 43e:	4881                	li	a7,0
 440:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 444:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 446:	2601                	sext.w	a2,a2
 448:	00000517          	auipc	a0,0x0
 44c:	51050513          	addi	a0,a0,1296 # 958 <digits>
 450:	883a                	mv	a6,a4
 452:	2705                	addiw	a4,a4,1
 454:	02c5f7bb          	remuw	a5,a1,a2
 458:	1782                	slli	a5,a5,0x20
 45a:	9381                	srli	a5,a5,0x20
 45c:	97aa                	add	a5,a5,a0
 45e:	0007c783          	lbu	a5,0(a5)
 462:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 466:	0005879b          	sext.w	a5,a1
 46a:	02c5d5bb          	divuw	a1,a1,a2
 46e:	0685                	addi	a3,a3,1
 470:	fec7f0e3          	bgeu	a5,a2,450 <printint+0x2a>
  if(neg)
 474:	00088c63          	beqz	a7,48c <printint+0x66>
    buf[i++] = '-';
 478:	fd070793          	addi	a5,a4,-48
 47c:	00878733          	add	a4,a5,s0
 480:	02d00793          	li	a5,45
 484:	fef70823          	sb	a5,-16(a4)
 488:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 48c:	02e05863          	blez	a4,4bc <printint+0x96>
 490:	fc040793          	addi	a5,s0,-64
 494:	00e78933          	add	s2,a5,a4
 498:	fff78993          	addi	s3,a5,-1
 49c:	99ba                	add	s3,s3,a4
 49e:	377d                	addiw	a4,a4,-1
 4a0:	1702                	slli	a4,a4,0x20
 4a2:	9301                	srli	a4,a4,0x20
 4a4:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 4a8:	fff94583          	lbu	a1,-1(s2)
 4ac:	8526                	mv	a0,s1
 4ae:	00000097          	auipc	ra,0x0
 4b2:	f56080e7          	jalr	-170(ra) # 404 <putc>
  while(--i >= 0)
 4b6:	197d                	addi	s2,s2,-1
 4b8:	ff3918e3          	bne	s2,s3,4a8 <printint+0x82>
}
 4bc:	70e2                	ld	ra,56(sp)
 4be:	7442                	ld	s0,48(sp)
 4c0:	74a2                	ld	s1,40(sp)
 4c2:	7902                	ld	s2,32(sp)
 4c4:	69e2                	ld	s3,24(sp)
 4c6:	6121                	addi	sp,sp,64
 4c8:	8082                	ret
    x = -xx;
 4ca:	40b005bb          	negw	a1,a1
    neg = 1;
 4ce:	4885                	li	a7,1
    x = -xx;
 4d0:	bf85                	j	440 <printint+0x1a>

00000000000004d2 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 4d2:	7119                	addi	sp,sp,-128
 4d4:	fc86                	sd	ra,120(sp)
 4d6:	f8a2                	sd	s0,112(sp)
 4d8:	f4a6                	sd	s1,104(sp)
 4da:	f0ca                	sd	s2,96(sp)
 4dc:	ecce                	sd	s3,88(sp)
 4de:	e8d2                	sd	s4,80(sp)
 4e0:	e4d6                	sd	s5,72(sp)
 4e2:	e0da                	sd	s6,64(sp)
 4e4:	fc5e                	sd	s7,56(sp)
 4e6:	f862                	sd	s8,48(sp)
 4e8:	f466                	sd	s9,40(sp)
 4ea:	f06a                	sd	s10,32(sp)
 4ec:	ec6e                	sd	s11,24(sp)
 4ee:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 4f0:	0005c903          	lbu	s2,0(a1)
 4f4:	18090f63          	beqz	s2,692 <vprintf+0x1c0>
 4f8:	8aaa                	mv	s5,a0
 4fa:	8b32                	mv	s6,a2
 4fc:	00158493          	addi	s1,a1,1
  state = 0;
 500:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 502:	02500a13          	li	s4,37
 506:	4c55                	li	s8,21
 508:	00000c97          	auipc	s9,0x0
 50c:	3f8c8c93          	addi	s9,s9,1016 # 900 <malloc+0x16a>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
        s = va_arg(ap, char*);
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 510:	02800d93          	li	s11,40
  putc(fd, 'x');
 514:	4d41                	li	s10,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 516:	00000b97          	auipc	s7,0x0
 51a:	442b8b93          	addi	s7,s7,1090 # 958 <digits>
 51e:	a839                	j	53c <vprintf+0x6a>
        putc(fd, c);
 520:	85ca                	mv	a1,s2
 522:	8556                	mv	a0,s5
 524:	00000097          	auipc	ra,0x0
 528:	ee0080e7          	jalr	-288(ra) # 404 <putc>
 52c:	a019                	j	532 <vprintf+0x60>
    } else if(state == '%'){
 52e:	01498d63          	beq	s3,s4,548 <vprintf+0x76>
  for(i = 0; fmt[i]; i++){
 532:	0485                	addi	s1,s1,1
 534:	fff4c903          	lbu	s2,-1(s1)
 538:	14090d63          	beqz	s2,692 <vprintf+0x1c0>
    if(state == 0){
 53c:	fe0999e3          	bnez	s3,52e <vprintf+0x5c>
      if(c == '%'){
 540:	ff4910e3          	bne	s2,s4,520 <vprintf+0x4e>
        state = '%';
 544:	89d2                	mv	s3,s4
 546:	b7f5                	j	532 <vprintf+0x60>
      if(c == 'd'){
 548:	11490c63          	beq	s2,s4,660 <vprintf+0x18e>
 54c:	f9d9079b          	addiw	a5,s2,-99
 550:	0ff7f793          	zext.b	a5,a5
 554:	10fc6e63          	bltu	s8,a5,670 <vprintf+0x19e>
 558:	f9d9079b          	addiw	a5,s2,-99
 55c:	0ff7f713          	zext.b	a4,a5
 560:	10ec6863          	bltu	s8,a4,670 <vprintf+0x19e>
 564:	00271793          	slli	a5,a4,0x2
 568:	97e6                	add	a5,a5,s9
 56a:	439c                	lw	a5,0(a5)
 56c:	97e6                	add	a5,a5,s9
 56e:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 570:	008b0913          	addi	s2,s6,8
 574:	4685                	li	a3,1
 576:	4629                	li	a2,10
 578:	000b2583          	lw	a1,0(s6)
 57c:	8556                	mv	a0,s5
 57e:	00000097          	auipc	ra,0x0
 582:	ea8080e7          	jalr	-344(ra) # 426 <printint>
 586:	8b4a                	mv	s6,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 588:	4981                	li	s3,0
 58a:	b765                	j	532 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 58c:	008b0913          	addi	s2,s6,8
 590:	4681                	li	a3,0
 592:	4629                	li	a2,10
 594:	000b2583          	lw	a1,0(s6)
 598:	8556                	mv	a0,s5
 59a:	00000097          	auipc	ra,0x0
 59e:	e8c080e7          	jalr	-372(ra) # 426 <printint>
 5a2:	8b4a                	mv	s6,s2
      state = 0;
 5a4:	4981                	li	s3,0
 5a6:	b771                	j	532 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 5a8:	008b0913          	addi	s2,s6,8
 5ac:	4681                	li	a3,0
 5ae:	866a                	mv	a2,s10
 5b0:	000b2583          	lw	a1,0(s6)
 5b4:	8556                	mv	a0,s5
 5b6:	00000097          	auipc	ra,0x0
 5ba:	e70080e7          	jalr	-400(ra) # 426 <printint>
 5be:	8b4a                	mv	s6,s2
      state = 0;
 5c0:	4981                	li	s3,0
 5c2:	bf85                	j	532 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 5c4:	008b0793          	addi	a5,s6,8
 5c8:	f8f43423          	sd	a5,-120(s0)
 5cc:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 5d0:	03000593          	li	a1,48
 5d4:	8556                	mv	a0,s5
 5d6:	00000097          	auipc	ra,0x0
 5da:	e2e080e7          	jalr	-466(ra) # 404 <putc>
  putc(fd, 'x');
 5de:	07800593          	li	a1,120
 5e2:	8556                	mv	a0,s5
 5e4:	00000097          	auipc	ra,0x0
 5e8:	e20080e7          	jalr	-480(ra) # 404 <putc>
 5ec:	896a                	mv	s2,s10
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 5ee:	03c9d793          	srli	a5,s3,0x3c
 5f2:	97de                	add	a5,a5,s7
 5f4:	0007c583          	lbu	a1,0(a5)
 5f8:	8556                	mv	a0,s5
 5fa:	00000097          	auipc	ra,0x0
 5fe:	e0a080e7          	jalr	-502(ra) # 404 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 602:	0992                	slli	s3,s3,0x4
 604:	397d                	addiw	s2,s2,-1
 606:	fe0914e3          	bnez	s2,5ee <vprintf+0x11c>
        printptr(fd, va_arg(ap, uint64));
 60a:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 60e:	4981                	li	s3,0
 610:	b70d                	j	532 <vprintf+0x60>
        s = va_arg(ap, char*);
 612:	008b0913          	addi	s2,s6,8
 616:	000b3983          	ld	s3,0(s6)
        if(s == 0)
 61a:	02098163          	beqz	s3,63c <vprintf+0x16a>
        while(*s != 0){
 61e:	0009c583          	lbu	a1,0(s3)
 622:	c5ad                	beqz	a1,68c <vprintf+0x1ba>
          putc(fd, *s);
 624:	8556                	mv	a0,s5
 626:	00000097          	auipc	ra,0x0
 62a:	dde080e7          	jalr	-546(ra) # 404 <putc>
          s++;
 62e:	0985                	addi	s3,s3,1
        while(*s != 0){
 630:	0009c583          	lbu	a1,0(s3)
 634:	f9e5                	bnez	a1,624 <vprintf+0x152>
        s = va_arg(ap, char*);
 636:	8b4a                	mv	s6,s2
      state = 0;
 638:	4981                	li	s3,0
 63a:	bde5                	j	532 <vprintf+0x60>
          s = "(null)";
 63c:	00000997          	auipc	s3,0x0
 640:	2bc98993          	addi	s3,s3,700 # 8f8 <malloc+0x162>
        while(*s != 0){
 644:	85ee                	mv	a1,s11
 646:	bff9                	j	624 <vprintf+0x152>
        putc(fd, va_arg(ap, uint));
 648:	008b0913          	addi	s2,s6,8
 64c:	000b4583          	lbu	a1,0(s6)
 650:	8556                	mv	a0,s5
 652:	00000097          	auipc	ra,0x0
 656:	db2080e7          	jalr	-590(ra) # 404 <putc>
 65a:	8b4a                	mv	s6,s2
      state = 0;
 65c:	4981                	li	s3,0
 65e:	bdd1                	j	532 <vprintf+0x60>
        putc(fd, c);
 660:	85d2                	mv	a1,s4
 662:	8556                	mv	a0,s5
 664:	00000097          	auipc	ra,0x0
 668:	da0080e7          	jalr	-608(ra) # 404 <putc>
      state = 0;
 66c:	4981                	li	s3,0
 66e:	b5d1                	j	532 <vprintf+0x60>
        putc(fd, '%');
 670:	85d2                	mv	a1,s4
 672:	8556                	mv	a0,s5
 674:	00000097          	auipc	ra,0x0
 678:	d90080e7          	jalr	-624(ra) # 404 <putc>
        putc(fd, c);
 67c:	85ca                	mv	a1,s2
 67e:	8556                	mv	a0,s5
 680:	00000097          	auipc	ra,0x0
 684:	d84080e7          	jalr	-636(ra) # 404 <putc>
      state = 0;
 688:	4981                	li	s3,0
 68a:	b565                	j	532 <vprintf+0x60>
        s = va_arg(ap, char*);
 68c:	8b4a                	mv	s6,s2
      state = 0;
 68e:	4981                	li	s3,0
 690:	b54d                	j	532 <vprintf+0x60>
    }
  }
}
 692:	70e6                	ld	ra,120(sp)
 694:	7446                	ld	s0,112(sp)
 696:	74a6                	ld	s1,104(sp)
 698:	7906                	ld	s2,96(sp)
 69a:	69e6                	ld	s3,88(sp)
 69c:	6a46                	ld	s4,80(sp)
 69e:	6aa6                	ld	s5,72(sp)
 6a0:	6b06                	ld	s6,64(sp)
 6a2:	7be2                	ld	s7,56(sp)
 6a4:	7c42                	ld	s8,48(sp)
 6a6:	7ca2                	ld	s9,40(sp)
 6a8:	7d02                	ld	s10,32(sp)
 6aa:	6de2                	ld	s11,24(sp)
 6ac:	6109                	addi	sp,sp,128
 6ae:	8082                	ret

00000000000006b0 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 6b0:	715d                	addi	sp,sp,-80
 6b2:	ec06                	sd	ra,24(sp)
 6b4:	e822                	sd	s0,16(sp)
 6b6:	1000                	addi	s0,sp,32
 6b8:	e010                	sd	a2,0(s0)
 6ba:	e414                	sd	a3,8(s0)
 6bc:	e818                	sd	a4,16(s0)
 6be:	ec1c                	sd	a5,24(s0)
 6c0:	03043023          	sd	a6,32(s0)
 6c4:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 6c8:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 6cc:	8622                	mv	a2,s0
 6ce:	00000097          	auipc	ra,0x0
 6d2:	e04080e7          	jalr	-508(ra) # 4d2 <vprintf>
}
 6d6:	60e2                	ld	ra,24(sp)
 6d8:	6442                	ld	s0,16(sp)
 6da:	6161                	addi	sp,sp,80
 6dc:	8082                	ret

00000000000006de <printf>:

void
printf(const char *fmt, ...)
{
 6de:	711d                	addi	sp,sp,-96
 6e0:	ec06                	sd	ra,24(sp)
 6e2:	e822                	sd	s0,16(sp)
 6e4:	1000                	addi	s0,sp,32
 6e6:	e40c                	sd	a1,8(s0)
 6e8:	e810                	sd	a2,16(s0)
 6ea:	ec14                	sd	a3,24(s0)
 6ec:	f018                	sd	a4,32(s0)
 6ee:	f41c                	sd	a5,40(s0)
 6f0:	03043823          	sd	a6,48(s0)
 6f4:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 6f8:	00840613          	addi	a2,s0,8
 6fc:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 700:	85aa                	mv	a1,a0
 702:	4505                	li	a0,1
 704:	00000097          	auipc	ra,0x0
 708:	dce080e7          	jalr	-562(ra) # 4d2 <vprintf>
}
 70c:	60e2                	ld	ra,24(sp)
 70e:	6442                	ld	s0,16(sp)
 710:	6125                	addi	sp,sp,96
 712:	8082                	ret

0000000000000714 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 714:	1141                	addi	sp,sp,-16
 716:	e422                	sd	s0,8(sp)
 718:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 71a:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 71e:	00000797          	auipc	a5,0x0
 722:	2627b783          	ld	a5,610(a5) # 980 <freep>
 726:	a02d                	j	750 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 728:	4618                	lw	a4,8(a2)
 72a:	9f2d                	addw	a4,a4,a1
 72c:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 730:	6398                	ld	a4,0(a5)
 732:	6310                	ld	a2,0(a4)
 734:	a83d                	j	772 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 736:	ff852703          	lw	a4,-8(a0)
 73a:	9f31                	addw	a4,a4,a2
 73c:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 73e:	ff053683          	ld	a3,-16(a0)
 742:	a091                	j	786 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 744:	6398                	ld	a4,0(a5)
 746:	00e7e463          	bltu	a5,a4,74e <free+0x3a>
 74a:	00e6ea63          	bltu	a3,a4,75e <free+0x4a>
{
 74e:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 750:	fed7fae3          	bgeu	a5,a3,744 <free+0x30>
 754:	6398                	ld	a4,0(a5)
 756:	00e6e463          	bltu	a3,a4,75e <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 75a:	fee7eae3          	bltu	a5,a4,74e <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 75e:	ff852583          	lw	a1,-8(a0)
 762:	6390                	ld	a2,0(a5)
 764:	02059813          	slli	a6,a1,0x20
 768:	01c85713          	srli	a4,a6,0x1c
 76c:	9736                	add	a4,a4,a3
 76e:	fae60de3          	beq	a2,a4,728 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 772:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 776:	4790                	lw	a2,8(a5)
 778:	02061593          	slli	a1,a2,0x20
 77c:	01c5d713          	srli	a4,a1,0x1c
 780:	973e                	add	a4,a4,a5
 782:	fae68ae3          	beq	a3,a4,736 <free+0x22>
    p->s.ptr = bp->s.ptr;
 786:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 788:	00000717          	auipc	a4,0x0
 78c:	1ef73c23          	sd	a5,504(a4) # 980 <freep>
}
 790:	6422                	ld	s0,8(sp)
 792:	0141                	addi	sp,sp,16
 794:	8082                	ret

0000000000000796 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 796:	7139                	addi	sp,sp,-64
 798:	fc06                	sd	ra,56(sp)
 79a:	f822                	sd	s0,48(sp)
 79c:	f426                	sd	s1,40(sp)
 79e:	f04a                	sd	s2,32(sp)
 7a0:	ec4e                	sd	s3,24(sp)
 7a2:	e852                	sd	s4,16(sp)
 7a4:	e456                	sd	s5,8(sp)
 7a6:	e05a                	sd	s6,0(sp)
 7a8:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7aa:	02051493          	slli	s1,a0,0x20
 7ae:	9081                	srli	s1,s1,0x20
 7b0:	04bd                	addi	s1,s1,15
 7b2:	8091                	srli	s1,s1,0x4
 7b4:	0014899b          	addiw	s3,s1,1
 7b8:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 7ba:	00000517          	auipc	a0,0x0
 7be:	1c653503          	ld	a0,454(a0) # 980 <freep>
 7c2:	c515                	beqz	a0,7ee <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7c4:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 7c6:	4798                	lw	a4,8(a5)
 7c8:	02977f63          	bgeu	a4,s1,806 <malloc+0x70>
 7cc:	8a4e                	mv	s4,s3
 7ce:	0009871b          	sext.w	a4,s3
 7d2:	6685                	lui	a3,0x1
 7d4:	00d77363          	bgeu	a4,a3,7da <malloc+0x44>
 7d8:	6a05                	lui	s4,0x1
 7da:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 7de:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 7e2:	00000917          	auipc	s2,0x0
 7e6:	19e90913          	addi	s2,s2,414 # 980 <freep>
  if(p == (char*)-1)
 7ea:	5afd                	li	s5,-1
 7ec:	a895                	j	860 <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
 7ee:	00000797          	auipc	a5,0x0
 7f2:	19a78793          	addi	a5,a5,410 # 988 <base>
 7f6:	00000717          	auipc	a4,0x0
 7fa:	18f73523          	sd	a5,394(a4) # 980 <freep>
 7fe:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 800:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 804:	b7e1                	j	7cc <malloc+0x36>
      if(p->s.size == nunits)
 806:	02e48c63          	beq	s1,a4,83e <malloc+0xa8>
        p->s.size -= nunits;
 80a:	4137073b          	subw	a4,a4,s3
 80e:	c798                	sw	a4,8(a5)
        p += p->s.size;
 810:	02071693          	slli	a3,a4,0x20
 814:	01c6d713          	srli	a4,a3,0x1c
 818:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 81a:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 81e:	00000717          	auipc	a4,0x0
 822:	16a73123          	sd	a0,354(a4) # 980 <freep>
      return (void*)(p + 1);
 826:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 82a:	70e2                	ld	ra,56(sp)
 82c:	7442                	ld	s0,48(sp)
 82e:	74a2                	ld	s1,40(sp)
 830:	7902                	ld	s2,32(sp)
 832:	69e2                	ld	s3,24(sp)
 834:	6a42                	ld	s4,16(sp)
 836:	6aa2                	ld	s5,8(sp)
 838:	6b02                	ld	s6,0(sp)
 83a:	6121                	addi	sp,sp,64
 83c:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 83e:	6398                	ld	a4,0(a5)
 840:	e118                	sd	a4,0(a0)
 842:	bff1                	j	81e <malloc+0x88>
  hp->s.size = nu;
 844:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 848:	0541                	addi	a0,a0,16
 84a:	00000097          	auipc	ra,0x0
 84e:	eca080e7          	jalr	-310(ra) # 714 <free>
  return freep;
 852:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 856:	d971                	beqz	a0,82a <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 858:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 85a:	4798                	lw	a4,8(a5)
 85c:	fa9775e3          	bgeu	a4,s1,806 <malloc+0x70>
    if(p == freep)
 860:	00093703          	ld	a4,0(s2)
 864:	853e                	mv	a0,a5
 866:	fef719e3          	bne	a4,a5,858 <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
 86a:	8552                	mv	a0,s4
 86c:	00000097          	auipc	ra,0x0
 870:	b80080e7          	jalr	-1152(ra) # 3ec <sbrk>
  if(p == (char*)-1)
 874:	fd5518e3          	bne	a0,s5,844 <malloc+0xae>
        return 0;
 878:	4501                	li	a0,0
 87a:	bf45                	j	82a <malloc+0x94>
