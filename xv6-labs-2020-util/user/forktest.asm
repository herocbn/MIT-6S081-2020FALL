
user/_forktest：     文件格式 elf64-littleriscv


Disassembly of section .text:

0000000000000000 <print>:

#define N  1000

void
print(const char *s)
{
   0:	1101                	addi	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	e426                	sd	s1,8(sp)
   8:	1000                	addi	s0,sp,32
   a:	84aa                	mv	s1,a0
  write(1, s, strlen(s));
   c:	00000097          	auipc	ra,0x0
  10:	15a080e7          	jalr	346(ra) # 166 <strlen>
  14:	0005061b          	sext.w	a2,a0
  18:	85a6                	mv	a1,s1
  1a:	4505                	li	a0,1
  1c:	00000097          	auipc	ra,0x0
  20:	38e080e7          	jalr	910(ra) # 3aa <write>
}
  24:	60e2                	ld	ra,24(sp)
  26:	6442                	ld	s0,16(sp)
  28:	64a2                	ld	s1,8(sp)
  2a:	6105                	addi	sp,sp,32
  2c:	8082                	ret

000000000000002e <forktest>:

void
forktest(void)
{
  2e:	1101                	addi	sp,sp,-32
  30:	ec06                	sd	ra,24(sp)
  32:	e822                	sd	s0,16(sp)
  34:	e426                	sd	s1,8(sp)
  36:	e04a                	sd	s2,0(sp)
  38:	1000                	addi	s0,sp,32
  int n, pid;

  print("fork test\n");
  3a:	00000517          	auipc	a0,0x0
  3e:	3f650513          	addi	a0,a0,1014 # 430 <uptime+0xe>
  42:	00000097          	auipc	ra,0x0
  46:	fbe080e7          	jalr	-66(ra) # 0 <print>

  for(n=0; n<N; n++){
  4a:	4481                	li	s1,0
  4c:	3e800913          	li	s2,1000
    pid = fork();
  50:	00000097          	auipc	ra,0x0
  54:	332080e7          	jalr	818(ra) # 382 <fork>
    if(pid < 0)
  58:	02054763          	bltz	a0,86 <forktest+0x58>
      break;
    if(pid == 0)
  5c:	c10d                	beqz	a0,7e <forktest+0x50>
  for(n=0; n<N; n++){
  5e:	2485                	addiw	s1,s1,1
  60:	ff2498e3          	bne	s1,s2,50 <forktest+0x22>
      exit(0);
  }

  if(n == N){
    print("fork claimed to work N times!\n");
  64:	00000517          	auipc	a0,0x0
  68:	3dc50513          	addi	a0,a0,988 # 440 <uptime+0x1e>
  6c:	00000097          	auipc	ra,0x0
  70:	f94080e7          	jalr	-108(ra) # 0 <print>
    exit(1);
  74:	4505                	li	a0,1
  76:	00000097          	auipc	ra,0x0
  7a:	314080e7          	jalr	788(ra) # 38a <exit>
      exit(0);
  7e:	00000097          	auipc	ra,0x0
  82:	30c080e7          	jalr	780(ra) # 38a <exit>
  if(n == N){
  86:	3e800793          	li	a5,1000
  8a:	fcf48de3          	beq	s1,a5,64 <forktest+0x36>
  }

  for(; n > 0; n--){
  8e:	00905b63          	blez	s1,a4 <forktest+0x76>
    if(wait(0) < 0){
  92:	4501                	li	a0,0
  94:	00000097          	auipc	ra,0x0
  98:	2fe080e7          	jalr	766(ra) # 392 <wait>
  9c:	02054a63          	bltz	a0,d0 <forktest+0xa2>
  for(; n > 0; n--){
  a0:	34fd                	addiw	s1,s1,-1
  a2:	f8e5                	bnez	s1,92 <forktest+0x64>
      print("wait stopped early\n");
      exit(1);
    }
  }

  if(wait(0) != -1){
  a4:	4501                	li	a0,0
  a6:	00000097          	auipc	ra,0x0
  aa:	2ec080e7          	jalr	748(ra) # 392 <wait>
  ae:	57fd                	li	a5,-1
  b0:	02f51d63          	bne	a0,a5,ea <forktest+0xbc>
    print("wait got too many\n");
    exit(1);
  }

  print("fork test OK\n");
  b4:	00000517          	auipc	a0,0x0
  b8:	3dc50513          	addi	a0,a0,988 # 490 <uptime+0x6e>
  bc:	00000097          	auipc	ra,0x0
  c0:	f44080e7          	jalr	-188(ra) # 0 <print>
}
  c4:	60e2                	ld	ra,24(sp)
  c6:	6442                	ld	s0,16(sp)
  c8:	64a2                	ld	s1,8(sp)
  ca:	6902                	ld	s2,0(sp)
  cc:	6105                	addi	sp,sp,32
  ce:	8082                	ret
      print("wait stopped early\n");
  d0:	00000517          	auipc	a0,0x0
  d4:	39050513          	addi	a0,a0,912 # 460 <uptime+0x3e>
  d8:	00000097          	auipc	ra,0x0
  dc:	f28080e7          	jalr	-216(ra) # 0 <print>
      exit(1);
  e0:	4505                	li	a0,1
  e2:	00000097          	auipc	ra,0x0
  e6:	2a8080e7          	jalr	680(ra) # 38a <exit>
    print("wait got too many\n");
  ea:	00000517          	auipc	a0,0x0
  ee:	38e50513          	addi	a0,a0,910 # 478 <uptime+0x56>
  f2:	00000097          	auipc	ra,0x0
  f6:	f0e080e7          	jalr	-242(ra) # 0 <print>
    exit(1);
  fa:	4505                	li	a0,1
  fc:	00000097          	auipc	ra,0x0
 100:	28e080e7          	jalr	654(ra) # 38a <exit>

0000000000000104 <main>:

int
main(void)
{
 104:	1141                	addi	sp,sp,-16
 106:	e406                	sd	ra,8(sp)
 108:	e022                	sd	s0,0(sp)
 10a:	0800                	addi	s0,sp,16
  forktest();
 10c:	00000097          	auipc	ra,0x0
 110:	f22080e7          	jalr	-222(ra) # 2e <forktest>
  exit(0);
 114:	4501                	li	a0,0
 116:	00000097          	auipc	ra,0x0
 11a:	274080e7          	jalr	628(ra) # 38a <exit>

000000000000011e <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
 11e:	1141                	addi	sp,sp,-16
 120:	e422                	sd	s0,8(sp)
 122:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 124:	87aa                	mv	a5,a0
 126:	0585                	addi	a1,a1,1
 128:	0785                	addi	a5,a5,1
 12a:	fff5c703          	lbu	a4,-1(a1)
 12e:	fee78fa3          	sb	a4,-1(a5)
 132:	fb75                	bnez	a4,126 <strcpy+0x8>
    ;
  return os;
}
 134:	6422                	ld	s0,8(sp)
 136:	0141                	addi	sp,sp,16
 138:	8082                	ret

000000000000013a <strcmp>:

int
strcmp(const char *p, const char *q)
{
 13a:	1141                	addi	sp,sp,-16
 13c:	e422                	sd	s0,8(sp)
 13e:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 140:	00054783          	lbu	a5,0(a0)
 144:	cb91                	beqz	a5,158 <strcmp+0x1e>
 146:	0005c703          	lbu	a4,0(a1)
 14a:	00f71763          	bne	a4,a5,158 <strcmp+0x1e>
    p++, q++;
 14e:	0505                	addi	a0,a0,1
 150:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 152:	00054783          	lbu	a5,0(a0)
 156:	fbe5                	bnez	a5,146 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 158:	0005c503          	lbu	a0,0(a1)
}
 15c:	40a7853b          	subw	a0,a5,a0
 160:	6422                	ld	s0,8(sp)
 162:	0141                	addi	sp,sp,16
 164:	8082                	ret

0000000000000166 <strlen>:

uint
strlen(const char *s)
{
 166:	1141                	addi	sp,sp,-16
 168:	e422                	sd	s0,8(sp)
 16a:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 16c:	00054783          	lbu	a5,0(a0)
 170:	cf91                	beqz	a5,18c <strlen+0x26>
 172:	0505                	addi	a0,a0,1
 174:	87aa                	mv	a5,a0
 176:	4685                	li	a3,1
 178:	9e89                	subw	a3,a3,a0
 17a:	00f6853b          	addw	a0,a3,a5
 17e:	0785                	addi	a5,a5,1
 180:	fff7c703          	lbu	a4,-1(a5)
 184:	fb7d                	bnez	a4,17a <strlen+0x14>
    ;
  return n;
}
 186:	6422                	ld	s0,8(sp)
 188:	0141                	addi	sp,sp,16
 18a:	8082                	ret
  for(n = 0; s[n]; n++)
 18c:	4501                	li	a0,0
 18e:	bfe5                	j	186 <strlen+0x20>

0000000000000190 <memset>:

void*
memset(void *dst, int c, uint n)
{
 190:	1141                	addi	sp,sp,-16
 192:	e422                	sd	s0,8(sp)
 194:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 196:	ca19                	beqz	a2,1ac <memset+0x1c>
 198:	87aa                	mv	a5,a0
 19a:	1602                	slli	a2,a2,0x20
 19c:	9201                	srli	a2,a2,0x20
 19e:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 1a2:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 1a6:	0785                	addi	a5,a5,1
 1a8:	fee79de3          	bne	a5,a4,1a2 <memset+0x12>
  }
  return dst;
}
 1ac:	6422                	ld	s0,8(sp)
 1ae:	0141                	addi	sp,sp,16
 1b0:	8082                	ret

00000000000001b2 <strchr>:

char*
strchr(const char *s, char c)
{
 1b2:	1141                	addi	sp,sp,-16
 1b4:	e422                	sd	s0,8(sp)
 1b6:	0800                	addi	s0,sp,16
  for(; *s; s++)
 1b8:	00054783          	lbu	a5,0(a0)
 1bc:	cb99                	beqz	a5,1d2 <strchr+0x20>
    if(*s == c)
 1be:	00f58763          	beq	a1,a5,1cc <strchr+0x1a>
  for(; *s; s++)
 1c2:	0505                	addi	a0,a0,1
 1c4:	00054783          	lbu	a5,0(a0)
 1c8:	fbfd                	bnez	a5,1be <strchr+0xc>
      return (char*)s;
  return 0;
 1ca:	4501                	li	a0,0
}
 1cc:	6422                	ld	s0,8(sp)
 1ce:	0141                	addi	sp,sp,16
 1d0:	8082                	ret
  return 0;
 1d2:	4501                	li	a0,0
 1d4:	bfe5                	j	1cc <strchr+0x1a>

00000000000001d6 <gets>:

char*
gets(char *buf, int max)
{
 1d6:	711d                	addi	sp,sp,-96
 1d8:	ec86                	sd	ra,88(sp)
 1da:	e8a2                	sd	s0,80(sp)
 1dc:	e4a6                	sd	s1,72(sp)
 1de:	e0ca                	sd	s2,64(sp)
 1e0:	fc4e                	sd	s3,56(sp)
 1e2:	f852                	sd	s4,48(sp)
 1e4:	f456                	sd	s5,40(sp)
 1e6:	f05a                	sd	s6,32(sp)
 1e8:	ec5e                	sd	s7,24(sp)
 1ea:	1080                	addi	s0,sp,96
 1ec:	8baa                	mv	s7,a0
 1ee:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1f0:	892a                	mv	s2,a0
 1f2:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 1f4:	4aa9                	li	s5,10
 1f6:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 1f8:	89a6                	mv	s3,s1
 1fa:	2485                	addiw	s1,s1,1
 1fc:	0344d863          	bge	s1,s4,22c <gets+0x56>
    cc = read(0, &c, 1);
 200:	4605                	li	a2,1
 202:	faf40593          	addi	a1,s0,-81
 206:	4501                	li	a0,0
 208:	00000097          	auipc	ra,0x0
 20c:	19a080e7          	jalr	410(ra) # 3a2 <read>
    if(cc < 1)
 210:	00a05e63          	blez	a0,22c <gets+0x56>
    buf[i++] = c;
 214:	faf44783          	lbu	a5,-81(s0)
 218:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 21c:	01578763          	beq	a5,s5,22a <gets+0x54>
 220:	0905                	addi	s2,s2,1
 222:	fd679be3          	bne	a5,s6,1f8 <gets+0x22>
  for(i=0; i+1 < max; ){
 226:	89a6                	mv	s3,s1
 228:	a011                	j	22c <gets+0x56>
 22a:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 22c:	99de                	add	s3,s3,s7
 22e:	00098023          	sb	zero,0(s3)
  return buf;
}
 232:	855e                	mv	a0,s7
 234:	60e6                	ld	ra,88(sp)
 236:	6446                	ld	s0,80(sp)
 238:	64a6                	ld	s1,72(sp)
 23a:	6906                	ld	s2,64(sp)
 23c:	79e2                	ld	s3,56(sp)
 23e:	7a42                	ld	s4,48(sp)
 240:	7aa2                	ld	s5,40(sp)
 242:	7b02                	ld	s6,32(sp)
 244:	6be2                	ld	s7,24(sp)
 246:	6125                	addi	sp,sp,96
 248:	8082                	ret

000000000000024a <stat>:

int
stat(const char *n, struct stat *st)
{
 24a:	1101                	addi	sp,sp,-32
 24c:	ec06                	sd	ra,24(sp)
 24e:	e822                	sd	s0,16(sp)
 250:	e426                	sd	s1,8(sp)
 252:	e04a                	sd	s2,0(sp)
 254:	1000                	addi	s0,sp,32
 256:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 258:	4581                	li	a1,0
 25a:	00000097          	auipc	ra,0x0
 25e:	170080e7          	jalr	368(ra) # 3ca <open>
  if(fd < 0)
 262:	02054563          	bltz	a0,28c <stat+0x42>
 266:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 268:	85ca                	mv	a1,s2
 26a:	00000097          	auipc	ra,0x0
 26e:	178080e7          	jalr	376(ra) # 3e2 <fstat>
 272:	892a                	mv	s2,a0
  close(fd);
 274:	8526                	mv	a0,s1
 276:	00000097          	auipc	ra,0x0
 27a:	13c080e7          	jalr	316(ra) # 3b2 <close>
  return r;
}
 27e:	854a                	mv	a0,s2
 280:	60e2                	ld	ra,24(sp)
 282:	6442                	ld	s0,16(sp)
 284:	64a2                	ld	s1,8(sp)
 286:	6902                	ld	s2,0(sp)
 288:	6105                	addi	sp,sp,32
 28a:	8082                	ret
    return -1;
 28c:	597d                	li	s2,-1
 28e:	bfc5                	j	27e <stat+0x34>

0000000000000290 <atoi>:

int
atoi(const char *s)
{
 290:	1141                	addi	sp,sp,-16
 292:	e422                	sd	s0,8(sp)
 294:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 296:	00054683          	lbu	a3,0(a0)
 29a:	fd06879b          	addiw	a5,a3,-48
 29e:	0ff7f793          	zext.b	a5,a5
 2a2:	4625                	li	a2,9
 2a4:	02f66863          	bltu	a2,a5,2d4 <atoi+0x44>
 2a8:	872a                	mv	a4,a0
  n = 0;
 2aa:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 2ac:	0705                	addi	a4,a4,1
 2ae:	0025179b          	slliw	a5,a0,0x2
 2b2:	9fa9                	addw	a5,a5,a0
 2b4:	0017979b          	slliw	a5,a5,0x1
 2b8:	9fb5                	addw	a5,a5,a3
 2ba:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 2be:	00074683          	lbu	a3,0(a4)
 2c2:	fd06879b          	addiw	a5,a3,-48
 2c6:	0ff7f793          	zext.b	a5,a5
 2ca:	fef671e3          	bgeu	a2,a5,2ac <atoi+0x1c>
  return n;
}
 2ce:	6422                	ld	s0,8(sp)
 2d0:	0141                	addi	sp,sp,16
 2d2:	8082                	ret
  n = 0;
 2d4:	4501                	li	a0,0
 2d6:	bfe5                	j	2ce <atoi+0x3e>

00000000000002d8 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 2d8:	1141                	addi	sp,sp,-16
 2da:	e422                	sd	s0,8(sp)
 2dc:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 2de:	02b57463          	bgeu	a0,a1,306 <memmove+0x2e>
    while(n-- > 0)
 2e2:	00c05f63          	blez	a2,300 <memmove+0x28>
 2e6:	1602                	slli	a2,a2,0x20
 2e8:	9201                	srli	a2,a2,0x20
 2ea:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 2ee:	872a                	mv	a4,a0
      *dst++ = *src++;
 2f0:	0585                	addi	a1,a1,1
 2f2:	0705                	addi	a4,a4,1
 2f4:	fff5c683          	lbu	a3,-1(a1)
 2f8:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 2fc:	fee79ae3          	bne	a5,a4,2f0 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 300:	6422                	ld	s0,8(sp)
 302:	0141                	addi	sp,sp,16
 304:	8082                	ret
    dst += n;
 306:	00c50733          	add	a4,a0,a2
    src += n;
 30a:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 30c:	fec05ae3          	blez	a2,300 <memmove+0x28>
 310:	fff6079b          	addiw	a5,a2,-1
 314:	1782                	slli	a5,a5,0x20
 316:	9381                	srli	a5,a5,0x20
 318:	fff7c793          	not	a5,a5
 31c:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 31e:	15fd                	addi	a1,a1,-1
 320:	177d                	addi	a4,a4,-1
 322:	0005c683          	lbu	a3,0(a1)
 326:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 32a:	fee79ae3          	bne	a5,a4,31e <memmove+0x46>
 32e:	bfc9                	j	300 <memmove+0x28>

0000000000000330 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 330:	1141                	addi	sp,sp,-16
 332:	e422                	sd	s0,8(sp)
 334:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 336:	ca05                	beqz	a2,366 <memcmp+0x36>
 338:	fff6069b          	addiw	a3,a2,-1
 33c:	1682                	slli	a3,a3,0x20
 33e:	9281                	srli	a3,a3,0x20
 340:	0685                	addi	a3,a3,1
 342:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 344:	00054783          	lbu	a5,0(a0)
 348:	0005c703          	lbu	a4,0(a1)
 34c:	00e79863          	bne	a5,a4,35c <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 350:	0505                	addi	a0,a0,1
    p2++;
 352:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 354:	fed518e3          	bne	a0,a3,344 <memcmp+0x14>
  }
  return 0;
 358:	4501                	li	a0,0
 35a:	a019                	j	360 <memcmp+0x30>
      return *p1 - *p2;
 35c:	40e7853b          	subw	a0,a5,a4
}
 360:	6422                	ld	s0,8(sp)
 362:	0141                	addi	sp,sp,16
 364:	8082                	ret
  return 0;
 366:	4501                	li	a0,0
 368:	bfe5                	j	360 <memcmp+0x30>

000000000000036a <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 36a:	1141                	addi	sp,sp,-16
 36c:	e406                	sd	ra,8(sp)
 36e:	e022                	sd	s0,0(sp)
 370:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 372:	00000097          	auipc	ra,0x0
 376:	f66080e7          	jalr	-154(ra) # 2d8 <memmove>
}
 37a:	60a2                	ld	ra,8(sp)
 37c:	6402                	ld	s0,0(sp)
 37e:	0141                	addi	sp,sp,16
 380:	8082                	ret

0000000000000382 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 382:	4885                	li	a7,1
 ecall
 384:	00000073          	ecall
 ret
 388:	8082                	ret

000000000000038a <exit>:
.global exit
exit:
 li a7, SYS_exit
 38a:	4889                	li	a7,2
 ecall
 38c:	00000073          	ecall
 ret
 390:	8082                	ret

0000000000000392 <wait>:
.global wait
wait:
 li a7, SYS_wait
 392:	488d                	li	a7,3
 ecall
 394:	00000073          	ecall
 ret
 398:	8082                	ret

000000000000039a <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 39a:	4891                	li	a7,4
 ecall
 39c:	00000073          	ecall
 ret
 3a0:	8082                	ret

00000000000003a2 <read>:
.global read
read:
 li a7, SYS_read
 3a2:	4895                	li	a7,5
 ecall
 3a4:	00000073          	ecall
 ret
 3a8:	8082                	ret

00000000000003aa <write>:
.global write
write:
 li a7, SYS_write
 3aa:	48c1                	li	a7,16
 ecall
 3ac:	00000073          	ecall
 ret
 3b0:	8082                	ret

00000000000003b2 <close>:
.global close
close:
 li a7, SYS_close
 3b2:	48d5                	li	a7,21
 ecall
 3b4:	00000073          	ecall
 ret
 3b8:	8082                	ret

00000000000003ba <kill>:
.global kill
kill:
 li a7, SYS_kill
 3ba:	4899                	li	a7,6
 ecall
 3bc:	00000073          	ecall
 ret
 3c0:	8082                	ret

00000000000003c2 <exec>:
.global exec
exec:
 li a7, SYS_exec
 3c2:	489d                	li	a7,7
 ecall
 3c4:	00000073          	ecall
 ret
 3c8:	8082                	ret

00000000000003ca <open>:
.global open
open:
 li a7, SYS_open
 3ca:	48bd                	li	a7,15
 ecall
 3cc:	00000073          	ecall
 ret
 3d0:	8082                	ret

00000000000003d2 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 3d2:	48c5                	li	a7,17
 ecall
 3d4:	00000073          	ecall
 ret
 3d8:	8082                	ret

00000000000003da <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 3da:	48c9                	li	a7,18
 ecall
 3dc:	00000073          	ecall
 ret
 3e0:	8082                	ret

00000000000003e2 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 3e2:	48a1                	li	a7,8
 ecall
 3e4:	00000073          	ecall
 ret
 3e8:	8082                	ret

00000000000003ea <link>:
.global link
link:
 li a7, SYS_link
 3ea:	48cd                	li	a7,19
 ecall
 3ec:	00000073          	ecall
 ret
 3f0:	8082                	ret

00000000000003f2 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 3f2:	48d1                	li	a7,20
 ecall
 3f4:	00000073          	ecall
 ret
 3f8:	8082                	ret

00000000000003fa <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 3fa:	48a5                	li	a7,9
 ecall
 3fc:	00000073          	ecall
 ret
 400:	8082                	ret

0000000000000402 <dup>:
.global dup
dup:
 li a7, SYS_dup
 402:	48a9                	li	a7,10
 ecall
 404:	00000073          	ecall
 ret
 408:	8082                	ret

000000000000040a <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 40a:	48ad                	li	a7,11
 ecall
 40c:	00000073          	ecall
 ret
 410:	8082                	ret

0000000000000412 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 412:	48b1                	li	a7,12
 ecall
 414:	00000073          	ecall
 ret
 418:	8082                	ret

000000000000041a <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 41a:	48b5                	li	a7,13
 ecall
 41c:	00000073          	ecall
 ret
 420:	8082                	ret

0000000000000422 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 422:	48b9                	li	a7,14
 ecall
 424:	00000073          	ecall
 ret
 428:	8082                	ret
