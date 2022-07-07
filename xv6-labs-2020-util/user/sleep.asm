
user/_sleep：     文件格式 elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
    > Created Time: 2022年03月24日 星期四 19时56分24秒
 ************************************************************************/

#include "kernel/types.h"
#include "user/user.h"
int main(int argc, char *argv[]){
   0:	1141                	addi	sp,sp,-16
   2:	e406                	sd	ra,8(sp)
   4:	e022                	sd	s0,0(sp)
   6:	0800                	addi	s0,sp,16
	if(argc != 2){
   8:	4789                	li	a5,2
   a:	02f50063          	beq	a0,a5,2a <main+0x2a>
		printf("%s: need one argument!",argv[0]);
   e:	618c                	ld	a1,0(a1)
  10:	00000517          	auipc	a0,0x0
  14:	7c050513          	addi	a0,a0,1984 # 7d0 <malloc+0xec>
  18:	00000097          	auipc	ra,0x0
  1c:	614080e7          	jalr	1556(ra) # 62c <printf>
		exit(1);
  20:	4505                	li	a0,1
  22:	00000097          	auipc	ra,0x0
  26:	290080e7          	jalr	656(ra) # 2b2 <exit>
	}
	int time = atoi(argv[1]);
  2a:	6588                	ld	a0,8(a1)
  2c:	00000097          	auipc	ra,0x0
  30:	18c080e7          	jalr	396(ra) # 1b8 <atoi>
	sleep(time);
  34:	00000097          	auipc	ra,0x0
  38:	30e080e7          	jalr	782(ra) # 342 <sleep>
	exit(0);
  3c:	4501                	li	a0,0
  3e:	00000097          	auipc	ra,0x0
  42:	274080e7          	jalr	628(ra) # 2b2 <exit>

0000000000000046 <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
  46:	1141                	addi	sp,sp,-16
  48:	e422                	sd	s0,8(sp)
  4a:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  4c:	87aa                	mv	a5,a0
  4e:	0585                	addi	a1,a1,1
  50:	0785                	addi	a5,a5,1
  52:	fff5c703          	lbu	a4,-1(a1)
  56:	fee78fa3          	sb	a4,-1(a5)
  5a:	fb75                	bnez	a4,4e <strcpy+0x8>
    ;
  return os;
}
  5c:	6422                	ld	s0,8(sp)
  5e:	0141                	addi	sp,sp,16
  60:	8082                	ret

0000000000000062 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  62:	1141                	addi	sp,sp,-16
  64:	e422                	sd	s0,8(sp)
  66:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  68:	00054783          	lbu	a5,0(a0)
  6c:	cb91                	beqz	a5,80 <strcmp+0x1e>
  6e:	0005c703          	lbu	a4,0(a1)
  72:	00f71763          	bne	a4,a5,80 <strcmp+0x1e>
    p++, q++;
  76:	0505                	addi	a0,a0,1
  78:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  7a:	00054783          	lbu	a5,0(a0)
  7e:	fbe5                	bnez	a5,6e <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
  80:	0005c503          	lbu	a0,0(a1)
}
  84:	40a7853b          	subw	a0,a5,a0
  88:	6422                	ld	s0,8(sp)
  8a:	0141                	addi	sp,sp,16
  8c:	8082                	ret

000000000000008e <strlen>:

uint
strlen(const char *s)
{
  8e:	1141                	addi	sp,sp,-16
  90:	e422                	sd	s0,8(sp)
  92:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  94:	00054783          	lbu	a5,0(a0)
  98:	cf91                	beqz	a5,b4 <strlen+0x26>
  9a:	0505                	addi	a0,a0,1
  9c:	87aa                	mv	a5,a0
  9e:	4685                	li	a3,1
  a0:	9e89                	subw	a3,a3,a0
  a2:	00f6853b          	addw	a0,a3,a5
  a6:	0785                	addi	a5,a5,1
  a8:	fff7c703          	lbu	a4,-1(a5)
  ac:	fb7d                	bnez	a4,a2 <strlen+0x14>
    ;
  return n;
}
  ae:	6422                	ld	s0,8(sp)
  b0:	0141                	addi	sp,sp,16
  b2:	8082                	ret
  for(n = 0; s[n]; n++)
  b4:	4501                	li	a0,0
  b6:	bfe5                	j	ae <strlen+0x20>

00000000000000b8 <memset>:

void*
memset(void *dst, int c, uint n)
{
  b8:	1141                	addi	sp,sp,-16
  ba:	e422                	sd	s0,8(sp)
  bc:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
  be:	ca19                	beqz	a2,d4 <memset+0x1c>
  c0:	87aa                	mv	a5,a0
  c2:	1602                	slli	a2,a2,0x20
  c4:	9201                	srli	a2,a2,0x20
  c6:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
  ca:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
  ce:	0785                	addi	a5,a5,1
  d0:	fee79de3          	bne	a5,a4,ca <memset+0x12>
  }
  return dst;
}
  d4:	6422                	ld	s0,8(sp)
  d6:	0141                	addi	sp,sp,16
  d8:	8082                	ret

00000000000000da <strchr>:

char*
strchr(const char *s, char c)
{
  da:	1141                	addi	sp,sp,-16
  dc:	e422                	sd	s0,8(sp)
  de:	0800                	addi	s0,sp,16
  for(; *s; s++)
  e0:	00054783          	lbu	a5,0(a0)
  e4:	cb99                	beqz	a5,fa <strchr+0x20>
    if(*s == c)
  e6:	00f58763          	beq	a1,a5,f4 <strchr+0x1a>
  for(; *s; s++)
  ea:	0505                	addi	a0,a0,1
  ec:	00054783          	lbu	a5,0(a0)
  f0:	fbfd                	bnez	a5,e6 <strchr+0xc>
      return (char*)s;
  return 0;
  f2:	4501                	li	a0,0
}
  f4:	6422                	ld	s0,8(sp)
  f6:	0141                	addi	sp,sp,16
  f8:	8082                	ret
  return 0;
  fa:	4501                	li	a0,0
  fc:	bfe5                	j	f4 <strchr+0x1a>

00000000000000fe <gets>:

char*
gets(char *buf, int max)
{
  fe:	711d                	addi	sp,sp,-96
 100:	ec86                	sd	ra,88(sp)
 102:	e8a2                	sd	s0,80(sp)
 104:	e4a6                	sd	s1,72(sp)
 106:	e0ca                	sd	s2,64(sp)
 108:	fc4e                	sd	s3,56(sp)
 10a:	f852                	sd	s4,48(sp)
 10c:	f456                	sd	s5,40(sp)
 10e:	f05a                	sd	s6,32(sp)
 110:	ec5e                	sd	s7,24(sp)
 112:	1080                	addi	s0,sp,96
 114:	8baa                	mv	s7,a0
 116:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 118:	892a                	mv	s2,a0
 11a:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 11c:	4aa9                	li	s5,10
 11e:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 120:	89a6                	mv	s3,s1
 122:	2485                	addiw	s1,s1,1
 124:	0344d863          	bge	s1,s4,154 <gets+0x56>
    cc = read(0, &c, 1);
 128:	4605                	li	a2,1
 12a:	faf40593          	addi	a1,s0,-81
 12e:	4501                	li	a0,0
 130:	00000097          	auipc	ra,0x0
 134:	19a080e7          	jalr	410(ra) # 2ca <read>
    if(cc < 1)
 138:	00a05e63          	blez	a0,154 <gets+0x56>
    buf[i++] = c;
 13c:	faf44783          	lbu	a5,-81(s0)
 140:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 144:	01578763          	beq	a5,s5,152 <gets+0x54>
 148:	0905                	addi	s2,s2,1
 14a:	fd679be3          	bne	a5,s6,120 <gets+0x22>
  for(i=0; i+1 < max; ){
 14e:	89a6                	mv	s3,s1
 150:	a011                	j	154 <gets+0x56>
 152:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 154:	99de                	add	s3,s3,s7
 156:	00098023          	sb	zero,0(s3)
  return buf;
}
 15a:	855e                	mv	a0,s7
 15c:	60e6                	ld	ra,88(sp)
 15e:	6446                	ld	s0,80(sp)
 160:	64a6                	ld	s1,72(sp)
 162:	6906                	ld	s2,64(sp)
 164:	79e2                	ld	s3,56(sp)
 166:	7a42                	ld	s4,48(sp)
 168:	7aa2                	ld	s5,40(sp)
 16a:	7b02                	ld	s6,32(sp)
 16c:	6be2                	ld	s7,24(sp)
 16e:	6125                	addi	sp,sp,96
 170:	8082                	ret

0000000000000172 <stat>:

int
stat(const char *n, struct stat *st)
{
 172:	1101                	addi	sp,sp,-32
 174:	ec06                	sd	ra,24(sp)
 176:	e822                	sd	s0,16(sp)
 178:	e426                	sd	s1,8(sp)
 17a:	e04a                	sd	s2,0(sp)
 17c:	1000                	addi	s0,sp,32
 17e:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 180:	4581                	li	a1,0
 182:	00000097          	auipc	ra,0x0
 186:	170080e7          	jalr	368(ra) # 2f2 <open>
  if(fd < 0)
 18a:	02054563          	bltz	a0,1b4 <stat+0x42>
 18e:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 190:	85ca                	mv	a1,s2
 192:	00000097          	auipc	ra,0x0
 196:	178080e7          	jalr	376(ra) # 30a <fstat>
 19a:	892a                	mv	s2,a0
  close(fd);
 19c:	8526                	mv	a0,s1
 19e:	00000097          	auipc	ra,0x0
 1a2:	13c080e7          	jalr	316(ra) # 2da <close>
  return r;
}
 1a6:	854a                	mv	a0,s2
 1a8:	60e2                	ld	ra,24(sp)
 1aa:	6442                	ld	s0,16(sp)
 1ac:	64a2                	ld	s1,8(sp)
 1ae:	6902                	ld	s2,0(sp)
 1b0:	6105                	addi	sp,sp,32
 1b2:	8082                	ret
    return -1;
 1b4:	597d                	li	s2,-1
 1b6:	bfc5                	j	1a6 <stat+0x34>

00000000000001b8 <atoi>:

int
atoi(const char *s)
{
 1b8:	1141                	addi	sp,sp,-16
 1ba:	e422                	sd	s0,8(sp)
 1bc:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 1be:	00054683          	lbu	a3,0(a0)
 1c2:	fd06879b          	addiw	a5,a3,-48
 1c6:	0ff7f793          	zext.b	a5,a5
 1ca:	4625                	li	a2,9
 1cc:	02f66863          	bltu	a2,a5,1fc <atoi+0x44>
 1d0:	872a                	mv	a4,a0
  n = 0;
 1d2:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 1d4:	0705                	addi	a4,a4,1
 1d6:	0025179b          	slliw	a5,a0,0x2
 1da:	9fa9                	addw	a5,a5,a0
 1dc:	0017979b          	slliw	a5,a5,0x1
 1e0:	9fb5                	addw	a5,a5,a3
 1e2:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 1e6:	00074683          	lbu	a3,0(a4)
 1ea:	fd06879b          	addiw	a5,a3,-48
 1ee:	0ff7f793          	zext.b	a5,a5
 1f2:	fef671e3          	bgeu	a2,a5,1d4 <atoi+0x1c>
  return n;
}
 1f6:	6422                	ld	s0,8(sp)
 1f8:	0141                	addi	sp,sp,16
 1fa:	8082                	ret
  n = 0;
 1fc:	4501                	li	a0,0
 1fe:	bfe5                	j	1f6 <atoi+0x3e>

0000000000000200 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 200:	1141                	addi	sp,sp,-16
 202:	e422                	sd	s0,8(sp)
 204:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 206:	02b57463          	bgeu	a0,a1,22e <memmove+0x2e>
    while(n-- > 0)
 20a:	00c05f63          	blez	a2,228 <memmove+0x28>
 20e:	1602                	slli	a2,a2,0x20
 210:	9201                	srli	a2,a2,0x20
 212:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 216:	872a                	mv	a4,a0
      *dst++ = *src++;
 218:	0585                	addi	a1,a1,1
 21a:	0705                	addi	a4,a4,1
 21c:	fff5c683          	lbu	a3,-1(a1)
 220:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 224:	fee79ae3          	bne	a5,a4,218 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 228:	6422                	ld	s0,8(sp)
 22a:	0141                	addi	sp,sp,16
 22c:	8082                	ret
    dst += n;
 22e:	00c50733          	add	a4,a0,a2
    src += n;
 232:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 234:	fec05ae3          	blez	a2,228 <memmove+0x28>
 238:	fff6079b          	addiw	a5,a2,-1
 23c:	1782                	slli	a5,a5,0x20
 23e:	9381                	srli	a5,a5,0x20
 240:	fff7c793          	not	a5,a5
 244:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 246:	15fd                	addi	a1,a1,-1
 248:	177d                	addi	a4,a4,-1
 24a:	0005c683          	lbu	a3,0(a1)
 24e:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 252:	fee79ae3          	bne	a5,a4,246 <memmove+0x46>
 256:	bfc9                	j	228 <memmove+0x28>

0000000000000258 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 258:	1141                	addi	sp,sp,-16
 25a:	e422                	sd	s0,8(sp)
 25c:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 25e:	ca05                	beqz	a2,28e <memcmp+0x36>
 260:	fff6069b          	addiw	a3,a2,-1
 264:	1682                	slli	a3,a3,0x20
 266:	9281                	srli	a3,a3,0x20
 268:	0685                	addi	a3,a3,1
 26a:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 26c:	00054783          	lbu	a5,0(a0)
 270:	0005c703          	lbu	a4,0(a1)
 274:	00e79863          	bne	a5,a4,284 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 278:	0505                	addi	a0,a0,1
    p2++;
 27a:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 27c:	fed518e3          	bne	a0,a3,26c <memcmp+0x14>
  }
  return 0;
 280:	4501                	li	a0,0
 282:	a019                	j	288 <memcmp+0x30>
      return *p1 - *p2;
 284:	40e7853b          	subw	a0,a5,a4
}
 288:	6422                	ld	s0,8(sp)
 28a:	0141                	addi	sp,sp,16
 28c:	8082                	ret
  return 0;
 28e:	4501                	li	a0,0
 290:	bfe5                	j	288 <memcmp+0x30>

0000000000000292 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 292:	1141                	addi	sp,sp,-16
 294:	e406                	sd	ra,8(sp)
 296:	e022                	sd	s0,0(sp)
 298:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 29a:	00000097          	auipc	ra,0x0
 29e:	f66080e7          	jalr	-154(ra) # 200 <memmove>
}
 2a2:	60a2                	ld	ra,8(sp)
 2a4:	6402                	ld	s0,0(sp)
 2a6:	0141                	addi	sp,sp,16
 2a8:	8082                	ret

00000000000002aa <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 2aa:	4885                	li	a7,1
 ecall
 2ac:	00000073          	ecall
 ret
 2b0:	8082                	ret

00000000000002b2 <exit>:
.global exit
exit:
 li a7, SYS_exit
 2b2:	4889                	li	a7,2
 ecall
 2b4:	00000073          	ecall
 ret
 2b8:	8082                	ret

00000000000002ba <wait>:
.global wait
wait:
 li a7, SYS_wait
 2ba:	488d                	li	a7,3
 ecall
 2bc:	00000073          	ecall
 ret
 2c0:	8082                	ret

00000000000002c2 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 2c2:	4891                	li	a7,4
 ecall
 2c4:	00000073          	ecall
 ret
 2c8:	8082                	ret

00000000000002ca <read>:
.global read
read:
 li a7, SYS_read
 2ca:	4895                	li	a7,5
 ecall
 2cc:	00000073          	ecall
 ret
 2d0:	8082                	ret

00000000000002d2 <write>:
.global write
write:
 li a7, SYS_write
 2d2:	48c1                	li	a7,16
 ecall
 2d4:	00000073          	ecall
 ret
 2d8:	8082                	ret

00000000000002da <close>:
.global close
close:
 li a7, SYS_close
 2da:	48d5                	li	a7,21
 ecall
 2dc:	00000073          	ecall
 ret
 2e0:	8082                	ret

00000000000002e2 <kill>:
.global kill
kill:
 li a7, SYS_kill
 2e2:	4899                	li	a7,6
 ecall
 2e4:	00000073          	ecall
 ret
 2e8:	8082                	ret

00000000000002ea <exec>:
.global exec
exec:
 li a7, SYS_exec
 2ea:	489d                	li	a7,7
 ecall
 2ec:	00000073          	ecall
 ret
 2f0:	8082                	ret

00000000000002f2 <open>:
.global open
open:
 li a7, SYS_open
 2f2:	48bd                	li	a7,15
 ecall
 2f4:	00000073          	ecall
 ret
 2f8:	8082                	ret

00000000000002fa <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 2fa:	48c5                	li	a7,17
 ecall
 2fc:	00000073          	ecall
 ret
 300:	8082                	ret

0000000000000302 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 302:	48c9                	li	a7,18
 ecall
 304:	00000073          	ecall
 ret
 308:	8082                	ret

000000000000030a <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 30a:	48a1                	li	a7,8
 ecall
 30c:	00000073          	ecall
 ret
 310:	8082                	ret

0000000000000312 <link>:
.global link
link:
 li a7, SYS_link
 312:	48cd                	li	a7,19
 ecall
 314:	00000073          	ecall
 ret
 318:	8082                	ret

000000000000031a <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 31a:	48d1                	li	a7,20
 ecall
 31c:	00000073          	ecall
 ret
 320:	8082                	ret

0000000000000322 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 322:	48a5                	li	a7,9
 ecall
 324:	00000073          	ecall
 ret
 328:	8082                	ret

000000000000032a <dup>:
.global dup
dup:
 li a7, SYS_dup
 32a:	48a9                	li	a7,10
 ecall
 32c:	00000073          	ecall
 ret
 330:	8082                	ret

0000000000000332 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 332:	48ad                	li	a7,11
 ecall
 334:	00000073          	ecall
 ret
 338:	8082                	ret

000000000000033a <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 33a:	48b1                	li	a7,12
 ecall
 33c:	00000073          	ecall
 ret
 340:	8082                	ret

0000000000000342 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 342:	48b5                	li	a7,13
 ecall
 344:	00000073          	ecall
 ret
 348:	8082                	ret

000000000000034a <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 34a:	48b9                	li	a7,14
 ecall
 34c:	00000073          	ecall
 ret
 350:	8082                	ret

0000000000000352 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 352:	1101                	addi	sp,sp,-32
 354:	ec06                	sd	ra,24(sp)
 356:	e822                	sd	s0,16(sp)
 358:	1000                	addi	s0,sp,32
 35a:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 35e:	4605                	li	a2,1
 360:	fef40593          	addi	a1,s0,-17
 364:	00000097          	auipc	ra,0x0
 368:	f6e080e7          	jalr	-146(ra) # 2d2 <write>
}
 36c:	60e2                	ld	ra,24(sp)
 36e:	6442                	ld	s0,16(sp)
 370:	6105                	addi	sp,sp,32
 372:	8082                	ret

0000000000000374 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 374:	7139                	addi	sp,sp,-64
 376:	fc06                	sd	ra,56(sp)
 378:	f822                	sd	s0,48(sp)
 37a:	f426                	sd	s1,40(sp)
 37c:	f04a                	sd	s2,32(sp)
 37e:	ec4e                	sd	s3,24(sp)
 380:	0080                	addi	s0,sp,64
 382:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 384:	c299                	beqz	a3,38a <printint+0x16>
 386:	0805c963          	bltz	a1,418 <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 38a:	2581                	sext.w	a1,a1
  neg = 0;
 38c:	4881                	li	a7,0
 38e:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 392:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 394:	2601                	sext.w	a2,a2
 396:	00000517          	auipc	a0,0x0
 39a:	4b250513          	addi	a0,a0,1202 # 848 <digits>
 39e:	883a                	mv	a6,a4
 3a0:	2705                	addiw	a4,a4,1
 3a2:	02c5f7bb          	remuw	a5,a1,a2
 3a6:	1782                	slli	a5,a5,0x20
 3a8:	9381                	srli	a5,a5,0x20
 3aa:	97aa                	add	a5,a5,a0
 3ac:	0007c783          	lbu	a5,0(a5)
 3b0:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 3b4:	0005879b          	sext.w	a5,a1
 3b8:	02c5d5bb          	divuw	a1,a1,a2
 3bc:	0685                	addi	a3,a3,1
 3be:	fec7f0e3          	bgeu	a5,a2,39e <printint+0x2a>
  if(neg)
 3c2:	00088c63          	beqz	a7,3da <printint+0x66>
    buf[i++] = '-';
 3c6:	fd070793          	addi	a5,a4,-48
 3ca:	00878733          	add	a4,a5,s0
 3ce:	02d00793          	li	a5,45
 3d2:	fef70823          	sb	a5,-16(a4)
 3d6:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 3da:	02e05863          	blez	a4,40a <printint+0x96>
 3de:	fc040793          	addi	a5,s0,-64
 3e2:	00e78933          	add	s2,a5,a4
 3e6:	fff78993          	addi	s3,a5,-1
 3ea:	99ba                	add	s3,s3,a4
 3ec:	377d                	addiw	a4,a4,-1
 3ee:	1702                	slli	a4,a4,0x20
 3f0:	9301                	srli	a4,a4,0x20
 3f2:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 3f6:	fff94583          	lbu	a1,-1(s2)
 3fa:	8526                	mv	a0,s1
 3fc:	00000097          	auipc	ra,0x0
 400:	f56080e7          	jalr	-170(ra) # 352 <putc>
  while(--i >= 0)
 404:	197d                	addi	s2,s2,-1
 406:	ff3918e3          	bne	s2,s3,3f6 <printint+0x82>
}
 40a:	70e2                	ld	ra,56(sp)
 40c:	7442                	ld	s0,48(sp)
 40e:	74a2                	ld	s1,40(sp)
 410:	7902                	ld	s2,32(sp)
 412:	69e2                	ld	s3,24(sp)
 414:	6121                	addi	sp,sp,64
 416:	8082                	ret
    x = -xx;
 418:	40b005bb          	negw	a1,a1
    neg = 1;
 41c:	4885                	li	a7,1
    x = -xx;
 41e:	bf85                	j	38e <printint+0x1a>

0000000000000420 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 420:	7119                	addi	sp,sp,-128
 422:	fc86                	sd	ra,120(sp)
 424:	f8a2                	sd	s0,112(sp)
 426:	f4a6                	sd	s1,104(sp)
 428:	f0ca                	sd	s2,96(sp)
 42a:	ecce                	sd	s3,88(sp)
 42c:	e8d2                	sd	s4,80(sp)
 42e:	e4d6                	sd	s5,72(sp)
 430:	e0da                	sd	s6,64(sp)
 432:	fc5e                	sd	s7,56(sp)
 434:	f862                	sd	s8,48(sp)
 436:	f466                	sd	s9,40(sp)
 438:	f06a                	sd	s10,32(sp)
 43a:	ec6e                	sd	s11,24(sp)
 43c:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 43e:	0005c903          	lbu	s2,0(a1)
 442:	18090f63          	beqz	s2,5e0 <vprintf+0x1c0>
 446:	8aaa                	mv	s5,a0
 448:	8b32                	mv	s6,a2
 44a:	00158493          	addi	s1,a1,1
  state = 0;
 44e:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 450:	02500a13          	li	s4,37
 454:	4c55                	li	s8,21
 456:	00000c97          	auipc	s9,0x0
 45a:	39ac8c93          	addi	s9,s9,922 # 7f0 <malloc+0x10c>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
        s = va_arg(ap, char*);
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 45e:	02800d93          	li	s11,40
  putc(fd, 'x');
 462:	4d41                	li	s10,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 464:	00000b97          	auipc	s7,0x0
 468:	3e4b8b93          	addi	s7,s7,996 # 848 <digits>
 46c:	a839                	j	48a <vprintf+0x6a>
        putc(fd, c);
 46e:	85ca                	mv	a1,s2
 470:	8556                	mv	a0,s5
 472:	00000097          	auipc	ra,0x0
 476:	ee0080e7          	jalr	-288(ra) # 352 <putc>
 47a:	a019                	j	480 <vprintf+0x60>
    } else if(state == '%'){
 47c:	01498d63          	beq	s3,s4,496 <vprintf+0x76>
  for(i = 0; fmt[i]; i++){
 480:	0485                	addi	s1,s1,1
 482:	fff4c903          	lbu	s2,-1(s1)
 486:	14090d63          	beqz	s2,5e0 <vprintf+0x1c0>
    if(state == 0){
 48a:	fe0999e3          	bnez	s3,47c <vprintf+0x5c>
      if(c == '%'){
 48e:	ff4910e3          	bne	s2,s4,46e <vprintf+0x4e>
        state = '%';
 492:	89d2                	mv	s3,s4
 494:	b7f5                	j	480 <vprintf+0x60>
      if(c == 'd'){
 496:	11490c63          	beq	s2,s4,5ae <vprintf+0x18e>
 49a:	f9d9079b          	addiw	a5,s2,-99
 49e:	0ff7f793          	zext.b	a5,a5
 4a2:	10fc6e63          	bltu	s8,a5,5be <vprintf+0x19e>
 4a6:	f9d9079b          	addiw	a5,s2,-99
 4aa:	0ff7f713          	zext.b	a4,a5
 4ae:	10ec6863          	bltu	s8,a4,5be <vprintf+0x19e>
 4b2:	00271793          	slli	a5,a4,0x2
 4b6:	97e6                	add	a5,a5,s9
 4b8:	439c                	lw	a5,0(a5)
 4ba:	97e6                	add	a5,a5,s9
 4bc:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 4be:	008b0913          	addi	s2,s6,8
 4c2:	4685                	li	a3,1
 4c4:	4629                	li	a2,10
 4c6:	000b2583          	lw	a1,0(s6)
 4ca:	8556                	mv	a0,s5
 4cc:	00000097          	auipc	ra,0x0
 4d0:	ea8080e7          	jalr	-344(ra) # 374 <printint>
 4d4:	8b4a                	mv	s6,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 4d6:	4981                	li	s3,0
 4d8:	b765                	j	480 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 4da:	008b0913          	addi	s2,s6,8
 4de:	4681                	li	a3,0
 4e0:	4629                	li	a2,10
 4e2:	000b2583          	lw	a1,0(s6)
 4e6:	8556                	mv	a0,s5
 4e8:	00000097          	auipc	ra,0x0
 4ec:	e8c080e7          	jalr	-372(ra) # 374 <printint>
 4f0:	8b4a                	mv	s6,s2
      state = 0;
 4f2:	4981                	li	s3,0
 4f4:	b771                	j	480 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 4f6:	008b0913          	addi	s2,s6,8
 4fa:	4681                	li	a3,0
 4fc:	866a                	mv	a2,s10
 4fe:	000b2583          	lw	a1,0(s6)
 502:	8556                	mv	a0,s5
 504:	00000097          	auipc	ra,0x0
 508:	e70080e7          	jalr	-400(ra) # 374 <printint>
 50c:	8b4a                	mv	s6,s2
      state = 0;
 50e:	4981                	li	s3,0
 510:	bf85                	j	480 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 512:	008b0793          	addi	a5,s6,8
 516:	f8f43423          	sd	a5,-120(s0)
 51a:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 51e:	03000593          	li	a1,48
 522:	8556                	mv	a0,s5
 524:	00000097          	auipc	ra,0x0
 528:	e2e080e7          	jalr	-466(ra) # 352 <putc>
  putc(fd, 'x');
 52c:	07800593          	li	a1,120
 530:	8556                	mv	a0,s5
 532:	00000097          	auipc	ra,0x0
 536:	e20080e7          	jalr	-480(ra) # 352 <putc>
 53a:	896a                	mv	s2,s10
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 53c:	03c9d793          	srli	a5,s3,0x3c
 540:	97de                	add	a5,a5,s7
 542:	0007c583          	lbu	a1,0(a5)
 546:	8556                	mv	a0,s5
 548:	00000097          	auipc	ra,0x0
 54c:	e0a080e7          	jalr	-502(ra) # 352 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 550:	0992                	slli	s3,s3,0x4
 552:	397d                	addiw	s2,s2,-1
 554:	fe0914e3          	bnez	s2,53c <vprintf+0x11c>
        printptr(fd, va_arg(ap, uint64));
 558:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 55c:	4981                	li	s3,0
 55e:	b70d                	j	480 <vprintf+0x60>
        s = va_arg(ap, char*);
 560:	008b0913          	addi	s2,s6,8
 564:	000b3983          	ld	s3,0(s6)
        if(s == 0)
 568:	02098163          	beqz	s3,58a <vprintf+0x16a>
        while(*s != 0){
 56c:	0009c583          	lbu	a1,0(s3)
 570:	c5ad                	beqz	a1,5da <vprintf+0x1ba>
          putc(fd, *s);
 572:	8556                	mv	a0,s5
 574:	00000097          	auipc	ra,0x0
 578:	dde080e7          	jalr	-546(ra) # 352 <putc>
          s++;
 57c:	0985                	addi	s3,s3,1
        while(*s != 0){
 57e:	0009c583          	lbu	a1,0(s3)
 582:	f9e5                	bnez	a1,572 <vprintf+0x152>
        s = va_arg(ap, char*);
 584:	8b4a                	mv	s6,s2
      state = 0;
 586:	4981                	li	s3,0
 588:	bde5                	j	480 <vprintf+0x60>
          s = "(null)";
 58a:	00000997          	auipc	s3,0x0
 58e:	25e98993          	addi	s3,s3,606 # 7e8 <malloc+0x104>
        while(*s != 0){
 592:	85ee                	mv	a1,s11
 594:	bff9                	j	572 <vprintf+0x152>
        putc(fd, va_arg(ap, uint));
 596:	008b0913          	addi	s2,s6,8
 59a:	000b4583          	lbu	a1,0(s6)
 59e:	8556                	mv	a0,s5
 5a0:	00000097          	auipc	ra,0x0
 5a4:	db2080e7          	jalr	-590(ra) # 352 <putc>
 5a8:	8b4a                	mv	s6,s2
      state = 0;
 5aa:	4981                	li	s3,0
 5ac:	bdd1                	j	480 <vprintf+0x60>
        putc(fd, c);
 5ae:	85d2                	mv	a1,s4
 5b0:	8556                	mv	a0,s5
 5b2:	00000097          	auipc	ra,0x0
 5b6:	da0080e7          	jalr	-608(ra) # 352 <putc>
      state = 0;
 5ba:	4981                	li	s3,0
 5bc:	b5d1                	j	480 <vprintf+0x60>
        putc(fd, '%');
 5be:	85d2                	mv	a1,s4
 5c0:	8556                	mv	a0,s5
 5c2:	00000097          	auipc	ra,0x0
 5c6:	d90080e7          	jalr	-624(ra) # 352 <putc>
        putc(fd, c);
 5ca:	85ca                	mv	a1,s2
 5cc:	8556                	mv	a0,s5
 5ce:	00000097          	auipc	ra,0x0
 5d2:	d84080e7          	jalr	-636(ra) # 352 <putc>
      state = 0;
 5d6:	4981                	li	s3,0
 5d8:	b565                	j	480 <vprintf+0x60>
        s = va_arg(ap, char*);
 5da:	8b4a                	mv	s6,s2
      state = 0;
 5dc:	4981                	li	s3,0
 5de:	b54d                	j	480 <vprintf+0x60>
    }
  }
}
 5e0:	70e6                	ld	ra,120(sp)
 5e2:	7446                	ld	s0,112(sp)
 5e4:	74a6                	ld	s1,104(sp)
 5e6:	7906                	ld	s2,96(sp)
 5e8:	69e6                	ld	s3,88(sp)
 5ea:	6a46                	ld	s4,80(sp)
 5ec:	6aa6                	ld	s5,72(sp)
 5ee:	6b06                	ld	s6,64(sp)
 5f0:	7be2                	ld	s7,56(sp)
 5f2:	7c42                	ld	s8,48(sp)
 5f4:	7ca2                	ld	s9,40(sp)
 5f6:	7d02                	ld	s10,32(sp)
 5f8:	6de2                	ld	s11,24(sp)
 5fa:	6109                	addi	sp,sp,128
 5fc:	8082                	ret

00000000000005fe <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 5fe:	715d                	addi	sp,sp,-80
 600:	ec06                	sd	ra,24(sp)
 602:	e822                	sd	s0,16(sp)
 604:	1000                	addi	s0,sp,32
 606:	e010                	sd	a2,0(s0)
 608:	e414                	sd	a3,8(s0)
 60a:	e818                	sd	a4,16(s0)
 60c:	ec1c                	sd	a5,24(s0)
 60e:	03043023          	sd	a6,32(s0)
 612:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 616:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 61a:	8622                	mv	a2,s0
 61c:	00000097          	auipc	ra,0x0
 620:	e04080e7          	jalr	-508(ra) # 420 <vprintf>
}
 624:	60e2                	ld	ra,24(sp)
 626:	6442                	ld	s0,16(sp)
 628:	6161                	addi	sp,sp,80
 62a:	8082                	ret

000000000000062c <printf>:

void
printf(const char *fmt, ...)
{
 62c:	711d                	addi	sp,sp,-96
 62e:	ec06                	sd	ra,24(sp)
 630:	e822                	sd	s0,16(sp)
 632:	1000                	addi	s0,sp,32
 634:	e40c                	sd	a1,8(s0)
 636:	e810                	sd	a2,16(s0)
 638:	ec14                	sd	a3,24(s0)
 63a:	f018                	sd	a4,32(s0)
 63c:	f41c                	sd	a5,40(s0)
 63e:	03043823          	sd	a6,48(s0)
 642:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 646:	00840613          	addi	a2,s0,8
 64a:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 64e:	85aa                	mv	a1,a0
 650:	4505                	li	a0,1
 652:	00000097          	auipc	ra,0x0
 656:	dce080e7          	jalr	-562(ra) # 420 <vprintf>
}
 65a:	60e2                	ld	ra,24(sp)
 65c:	6442                	ld	s0,16(sp)
 65e:	6125                	addi	sp,sp,96
 660:	8082                	ret

0000000000000662 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 662:	1141                	addi	sp,sp,-16
 664:	e422                	sd	s0,8(sp)
 666:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 668:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 66c:	00000797          	auipc	a5,0x0
 670:	1f47b783          	ld	a5,500(a5) # 860 <freep>
 674:	a02d                	j	69e <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 676:	4618                	lw	a4,8(a2)
 678:	9f2d                	addw	a4,a4,a1
 67a:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 67e:	6398                	ld	a4,0(a5)
 680:	6310                	ld	a2,0(a4)
 682:	a83d                	j	6c0 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 684:	ff852703          	lw	a4,-8(a0)
 688:	9f31                	addw	a4,a4,a2
 68a:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 68c:	ff053683          	ld	a3,-16(a0)
 690:	a091                	j	6d4 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 692:	6398                	ld	a4,0(a5)
 694:	00e7e463          	bltu	a5,a4,69c <free+0x3a>
 698:	00e6ea63          	bltu	a3,a4,6ac <free+0x4a>
{
 69c:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 69e:	fed7fae3          	bgeu	a5,a3,692 <free+0x30>
 6a2:	6398                	ld	a4,0(a5)
 6a4:	00e6e463          	bltu	a3,a4,6ac <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6a8:	fee7eae3          	bltu	a5,a4,69c <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 6ac:	ff852583          	lw	a1,-8(a0)
 6b0:	6390                	ld	a2,0(a5)
 6b2:	02059813          	slli	a6,a1,0x20
 6b6:	01c85713          	srli	a4,a6,0x1c
 6ba:	9736                	add	a4,a4,a3
 6bc:	fae60de3          	beq	a2,a4,676 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 6c0:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 6c4:	4790                	lw	a2,8(a5)
 6c6:	02061593          	slli	a1,a2,0x20
 6ca:	01c5d713          	srli	a4,a1,0x1c
 6ce:	973e                	add	a4,a4,a5
 6d0:	fae68ae3          	beq	a3,a4,684 <free+0x22>
    p->s.ptr = bp->s.ptr;
 6d4:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 6d6:	00000717          	auipc	a4,0x0
 6da:	18f73523          	sd	a5,394(a4) # 860 <freep>
}
 6de:	6422                	ld	s0,8(sp)
 6e0:	0141                	addi	sp,sp,16
 6e2:	8082                	ret

00000000000006e4 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 6e4:	7139                	addi	sp,sp,-64
 6e6:	fc06                	sd	ra,56(sp)
 6e8:	f822                	sd	s0,48(sp)
 6ea:	f426                	sd	s1,40(sp)
 6ec:	f04a                	sd	s2,32(sp)
 6ee:	ec4e                	sd	s3,24(sp)
 6f0:	e852                	sd	s4,16(sp)
 6f2:	e456                	sd	s5,8(sp)
 6f4:	e05a                	sd	s6,0(sp)
 6f6:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 6f8:	02051493          	slli	s1,a0,0x20
 6fc:	9081                	srli	s1,s1,0x20
 6fe:	04bd                	addi	s1,s1,15
 700:	8091                	srli	s1,s1,0x4
 702:	0014899b          	addiw	s3,s1,1
 706:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 708:	00000517          	auipc	a0,0x0
 70c:	15853503          	ld	a0,344(a0) # 860 <freep>
 710:	c515                	beqz	a0,73c <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 712:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 714:	4798                	lw	a4,8(a5)
 716:	02977f63          	bgeu	a4,s1,754 <malloc+0x70>
 71a:	8a4e                	mv	s4,s3
 71c:	0009871b          	sext.w	a4,s3
 720:	6685                	lui	a3,0x1
 722:	00d77363          	bgeu	a4,a3,728 <malloc+0x44>
 726:	6a05                	lui	s4,0x1
 728:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 72c:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 730:	00000917          	auipc	s2,0x0
 734:	13090913          	addi	s2,s2,304 # 860 <freep>
  if(p == (char*)-1)
 738:	5afd                	li	s5,-1
 73a:	a895                	j	7ae <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
 73c:	00000797          	auipc	a5,0x0
 740:	12c78793          	addi	a5,a5,300 # 868 <base>
 744:	00000717          	auipc	a4,0x0
 748:	10f73e23          	sd	a5,284(a4) # 860 <freep>
 74c:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 74e:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 752:	b7e1                	j	71a <malloc+0x36>
      if(p->s.size == nunits)
 754:	02e48c63          	beq	s1,a4,78c <malloc+0xa8>
        p->s.size -= nunits;
 758:	4137073b          	subw	a4,a4,s3
 75c:	c798                	sw	a4,8(a5)
        p += p->s.size;
 75e:	02071693          	slli	a3,a4,0x20
 762:	01c6d713          	srli	a4,a3,0x1c
 766:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 768:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 76c:	00000717          	auipc	a4,0x0
 770:	0ea73a23          	sd	a0,244(a4) # 860 <freep>
      return (void*)(p + 1);
 774:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 778:	70e2                	ld	ra,56(sp)
 77a:	7442                	ld	s0,48(sp)
 77c:	74a2                	ld	s1,40(sp)
 77e:	7902                	ld	s2,32(sp)
 780:	69e2                	ld	s3,24(sp)
 782:	6a42                	ld	s4,16(sp)
 784:	6aa2                	ld	s5,8(sp)
 786:	6b02                	ld	s6,0(sp)
 788:	6121                	addi	sp,sp,64
 78a:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 78c:	6398                	ld	a4,0(a5)
 78e:	e118                	sd	a4,0(a0)
 790:	bff1                	j	76c <malloc+0x88>
  hp->s.size = nu;
 792:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 796:	0541                	addi	a0,a0,16
 798:	00000097          	auipc	ra,0x0
 79c:	eca080e7          	jalr	-310(ra) # 662 <free>
  return freep;
 7a0:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 7a4:	d971                	beqz	a0,778 <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7a6:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 7a8:	4798                	lw	a4,8(a5)
 7aa:	fa9775e3          	bgeu	a4,s1,754 <malloc+0x70>
    if(p == freep)
 7ae:	00093703          	ld	a4,0(s2)
 7b2:	853e                	mv	a0,a5
 7b4:	fef719e3          	bne	a4,a5,7a6 <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
 7b8:	8552                	mv	a0,s4
 7ba:	00000097          	auipc	ra,0x0
 7be:	b80080e7          	jalr	-1152(ra) # 33a <sbrk>
  if(p == (char*)-1)
 7c2:	fd5518e3          	bne	a0,s5,792 <malloc+0xae>
        return 0;
 7c6:	4501                	li	a0,0
 7c8:	bf45                	j	778 <malloc+0x94>
