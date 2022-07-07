
user/_cat：     文件格式 elf64-littleriscv


Disassembly of section .text:

0000000000000000 <cat>:

char buf[512];

void
cat(int fd)
{
   0:	7179                	addi	sp,sp,-48
   2:	f406                	sd	ra,40(sp)
   4:	f022                	sd	s0,32(sp)
   6:	ec26                	sd	s1,24(sp)
   8:	e84a                	sd	s2,16(sp)
   a:	e44e                	sd	s3,8(sp)
   c:	1800                	addi	s0,sp,48
   e:	89aa                	mv	s3,a0
  int n;

  while((n = read(fd, buf, sizeof(buf))) > 0) {
  10:	00001917          	auipc	s2,0x1
  14:	96090913          	addi	s2,s2,-1696 # 970 <buf>
  18:	20000613          	li	a2,512
  1c:	85ca                	mv	a1,s2
  1e:	854e                	mv	a0,s3
  20:	00000097          	auipc	ra,0x0
  24:	382080e7          	jalr	898(ra) # 3a2 <read>
  28:	84aa                	mv	s1,a0
  2a:	02a05963          	blez	a0,5c <cat+0x5c>
    if (write(1, buf, n) != n) {
  2e:	8626                	mv	a2,s1
  30:	85ca                	mv	a1,s2
  32:	4505                	li	a0,1
  34:	00000097          	auipc	ra,0x0
  38:	376080e7          	jalr	886(ra) # 3aa <write>
  3c:	fc950ee3          	beq	a0,s1,18 <cat+0x18>
      fprintf(2, "cat: write error\n");
  40:	00001597          	auipc	a1,0x1
  44:	86858593          	addi	a1,a1,-1944 # 8a8 <malloc+0xec>
  48:	4509                	li	a0,2
  4a:	00000097          	auipc	ra,0x0
  4e:	68c080e7          	jalr	1676(ra) # 6d6 <fprintf>
      exit(1);
  52:	4505                	li	a0,1
  54:	00000097          	auipc	ra,0x0
  58:	336080e7          	jalr	822(ra) # 38a <exit>
    }
  }
  if(n < 0){
  5c:	00054963          	bltz	a0,6e <cat+0x6e>
    fprintf(2, "cat: read error\n");
    exit(1);
  }
}
  60:	70a2                	ld	ra,40(sp)
  62:	7402                	ld	s0,32(sp)
  64:	64e2                	ld	s1,24(sp)
  66:	6942                	ld	s2,16(sp)
  68:	69a2                	ld	s3,8(sp)
  6a:	6145                	addi	sp,sp,48
  6c:	8082                	ret
    fprintf(2, "cat: read error\n");
  6e:	00001597          	auipc	a1,0x1
  72:	85258593          	addi	a1,a1,-1966 # 8c0 <malloc+0x104>
  76:	4509                	li	a0,2
  78:	00000097          	auipc	ra,0x0
  7c:	65e080e7          	jalr	1630(ra) # 6d6 <fprintf>
    exit(1);
  80:	4505                	li	a0,1
  82:	00000097          	auipc	ra,0x0
  86:	308080e7          	jalr	776(ra) # 38a <exit>

000000000000008a <main>:

int
main(int argc, char *argv[])
{
  8a:	7179                	addi	sp,sp,-48
  8c:	f406                	sd	ra,40(sp)
  8e:	f022                	sd	s0,32(sp)
  90:	ec26                	sd	s1,24(sp)
  92:	e84a                	sd	s2,16(sp)
  94:	e44e                	sd	s3,8(sp)
  96:	e052                	sd	s4,0(sp)
  98:	1800                	addi	s0,sp,48
  int fd, i;

  if(argc <= 1){
  9a:	4785                	li	a5,1
  9c:	04a7d763          	bge	a5,a0,ea <main+0x60>
  a0:	00858913          	addi	s2,a1,8
  a4:	ffe5099b          	addiw	s3,a0,-2
  a8:	02099793          	slli	a5,s3,0x20
  ac:	01d7d993          	srli	s3,a5,0x1d
  b0:	05c1                	addi	a1,a1,16
  b2:	99ae                	add	s3,s3,a1
    cat(0);
    exit(0);
  }

  for(i = 1; i < argc; i++){
    if((fd = open(argv[i], 0)) < 0){
  b4:	4581                	li	a1,0
  b6:	00093503          	ld	a0,0(s2)
  ba:	00000097          	auipc	ra,0x0
  be:	310080e7          	jalr	784(ra) # 3ca <open>
  c2:	84aa                	mv	s1,a0
  c4:	02054d63          	bltz	a0,fe <main+0x74>
      fprintf(2, "cat: cannot open %s\n", argv[i]);
      exit(1);
    }
    cat(fd);
  c8:	00000097          	auipc	ra,0x0
  cc:	f38080e7          	jalr	-200(ra) # 0 <cat>
    close(fd);
  d0:	8526                	mv	a0,s1
  d2:	00000097          	auipc	ra,0x0
  d6:	2e0080e7          	jalr	736(ra) # 3b2 <close>
  for(i = 1; i < argc; i++){
  da:	0921                	addi	s2,s2,8
  dc:	fd391ce3          	bne	s2,s3,b4 <main+0x2a>
  }
  exit(0);
  e0:	4501                	li	a0,0
  e2:	00000097          	auipc	ra,0x0
  e6:	2a8080e7          	jalr	680(ra) # 38a <exit>
    cat(0);
  ea:	4501                	li	a0,0
  ec:	00000097          	auipc	ra,0x0
  f0:	f14080e7          	jalr	-236(ra) # 0 <cat>
    exit(0);
  f4:	4501                	li	a0,0
  f6:	00000097          	auipc	ra,0x0
  fa:	294080e7          	jalr	660(ra) # 38a <exit>
      fprintf(2, "cat: cannot open %s\n", argv[i]);
  fe:	00093603          	ld	a2,0(s2)
 102:	00000597          	auipc	a1,0x0
 106:	7d658593          	addi	a1,a1,2006 # 8d8 <malloc+0x11c>
 10a:	4509                	li	a0,2
 10c:	00000097          	auipc	ra,0x0
 110:	5ca080e7          	jalr	1482(ra) # 6d6 <fprintf>
      exit(1);
 114:	4505                	li	a0,1
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

000000000000042a <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 42a:	1101                	addi	sp,sp,-32
 42c:	ec06                	sd	ra,24(sp)
 42e:	e822                	sd	s0,16(sp)
 430:	1000                	addi	s0,sp,32
 432:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 436:	4605                	li	a2,1
 438:	fef40593          	addi	a1,s0,-17
 43c:	00000097          	auipc	ra,0x0
 440:	f6e080e7          	jalr	-146(ra) # 3aa <write>
}
 444:	60e2                	ld	ra,24(sp)
 446:	6442                	ld	s0,16(sp)
 448:	6105                	addi	sp,sp,32
 44a:	8082                	ret

000000000000044c <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 44c:	7139                	addi	sp,sp,-64
 44e:	fc06                	sd	ra,56(sp)
 450:	f822                	sd	s0,48(sp)
 452:	f426                	sd	s1,40(sp)
 454:	f04a                	sd	s2,32(sp)
 456:	ec4e                	sd	s3,24(sp)
 458:	0080                	addi	s0,sp,64
 45a:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 45c:	c299                	beqz	a3,462 <printint+0x16>
 45e:	0805c963          	bltz	a1,4f0 <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 462:	2581                	sext.w	a1,a1
  neg = 0;
 464:	4881                	li	a7,0
 466:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 46a:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 46c:	2601                	sext.w	a2,a2
 46e:	00000517          	auipc	a0,0x0
 472:	4e250513          	addi	a0,a0,1250 # 950 <digits>
 476:	883a                	mv	a6,a4
 478:	2705                	addiw	a4,a4,1
 47a:	02c5f7bb          	remuw	a5,a1,a2
 47e:	1782                	slli	a5,a5,0x20
 480:	9381                	srli	a5,a5,0x20
 482:	97aa                	add	a5,a5,a0
 484:	0007c783          	lbu	a5,0(a5)
 488:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 48c:	0005879b          	sext.w	a5,a1
 490:	02c5d5bb          	divuw	a1,a1,a2
 494:	0685                	addi	a3,a3,1
 496:	fec7f0e3          	bgeu	a5,a2,476 <printint+0x2a>
  if(neg)
 49a:	00088c63          	beqz	a7,4b2 <printint+0x66>
    buf[i++] = '-';
 49e:	fd070793          	addi	a5,a4,-48
 4a2:	00878733          	add	a4,a5,s0
 4a6:	02d00793          	li	a5,45
 4aa:	fef70823          	sb	a5,-16(a4)
 4ae:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 4b2:	02e05863          	blez	a4,4e2 <printint+0x96>
 4b6:	fc040793          	addi	a5,s0,-64
 4ba:	00e78933          	add	s2,a5,a4
 4be:	fff78993          	addi	s3,a5,-1
 4c2:	99ba                	add	s3,s3,a4
 4c4:	377d                	addiw	a4,a4,-1
 4c6:	1702                	slli	a4,a4,0x20
 4c8:	9301                	srli	a4,a4,0x20
 4ca:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 4ce:	fff94583          	lbu	a1,-1(s2)
 4d2:	8526                	mv	a0,s1
 4d4:	00000097          	auipc	ra,0x0
 4d8:	f56080e7          	jalr	-170(ra) # 42a <putc>
  while(--i >= 0)
 4dc:	197d                	addi	s2,s2,-1
 4de:	ff3918e3          	bne	s2,s3,4ce <printint+0x82>
}
 4e2:	70e2                	ld	ra,56(sp)
 4e4:	7442                	ld	s0,48(sp)
 4e6:	74a2                	ld	s1,40(sp)
 4e8:	7902                	ld	s2,32(sp)
 4ea:	69e2                	ld	s3,24(sp)
 4ec:	6121                	addi	sp,sp,64
 4ee:	8082                	ret
    x = -xx;
 4f0:	40b005bb          	negw	a1,a1
    neg = 1;
 4f4:	4885                	li	a7,1
    x = -xx;
 4f6:	bf85                	j	466 <printint+0x1a>

00000000000004f8 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 4f8:	7119                	addi	sp,sp,-128
 4fa:	fc86                	sd	ra,120(sp)
 4fc:	f8a2                	sd	s0,112(sp)
 4fe:	f4a6                	sd	s1,104(sp)
 500:	f0ca                	sd	s2,96(sp)
 502:	ecce                	sd	s3,88(sp)
 504:	e8d2                	sd	s4,80(sp)
 506:	e4d6                	sd	s5,72(sp)
 508:	e0da                	sd	s6,64(sp)
 50a:	fc5e                	sd	s7,56(sp)
 50c:	f862                	sd	s8,48(sp)
 50e:	f466                	sd	s9,40(sp)
 510:	f06a                	sd	s10,32(sp)
 512:	ec6e                	sd	s11,24(sp)
 514:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 516:	0005c903          	lbu	s2,0(a1)
 51a:	18090f63          	beqz	s2,6b8 <vprintf+0x1c0>
 51e:	8aaa                	mv	s5,a0
 520:	8b32                	mv	s6,a2
 522:	00158493          	addi	s1,a1,1
  state = 0;
 526:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 528:	02500a13          	li	s4,37
 52c:	4c55                	li	s8,21
 52e:	00000c97          	auipc	s9,0x0
 532:	3cac8c93          	addi	s9,s9,970 # 8f8 <malloc+0x13c>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
        s = va_arg(ap, char*);
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 536:	02800d93          	li	s11,40
  putc(fd, 'x');
 53a:	4d41                	li	s10,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 53c:	00000b97          	auipc	s7,0x0
 540:	414b8b93          	addi	s7,s7,1044 # 950 <digits>
 544:	a839                	j	562 <vprintf+0x6a>
        putc(fd, c);
 546:	85ca                	mv	a1,s2
 548:	8556                	mv	a0,s5
 54a:	00000097          	auipc	ra,0x0
 54e:	ee0080e7          	jalr	-288(ra) # 42a <putc>
 552:	a019                	j	558 <vprintf+0x60>
    } else if(state == '%'){
 554:	01498d63          	beq	s3,s4,56e <vprintf+0x76>
  for(i = 0; fmt[i]; i++){
 558:	0485                	addi	s1,s1,1
 55a:	fff4c903          	lbu	s2,-1(s1)
 55e:	14090d63          	beqz	s2,6b8 <vprintf+0x1c0>
    if(state == 0){
 562:	fe0999e3          	bnez	s3,554 <vprintf+0x5c>
      if(c == '%'){
 566:	ff4910e3          	bne	s2,s4,546 <vprintf+0x4e>
        state = '%';
 56a:	89d2                	mv	s3,s4
 56c:	b7f5                	j	558 <vprintf+0x60>
      if(c == 'd'){
 56e:	11490c63          	beq	s2,s4,686 <vprintf+0x18e>
 572:	f9d9079b          	addiw	a5,s2,-99
 576:	0ff7f793          	zext.b	a5,a5
 57a:	10fc6e63          	bltu	s8,a5,696 <vprintf+0x19e>
 57e:	f9d9079b          	addiw	a5,s2,-99
 582:	0ff7f713          	zext.b	a4,a5
 586:	10ec6863          	bltu	s8,a4,696 <vprintf+0x19e>
 58a:	00271793          	slli	a5,a4,0x2
 58e:	97e6                	add	a5,a5,s9
 590:	439c                	lw	a5,0(a5)
 592:	97e6                	add	a5,a5,s9
 594:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 596:	008b0913          	addi	s2,s6,8
 59a:	4685                	li	a3,1
 59c:	4629                	li	a2,10
 59e:	000b2583          	lw	a1,0(s6)
 5a2:	8556                	mv	a0,s5
 5a4:	00000097          	auipc	ra,0x0
 5a8:	ea8080e7          	jalr	-344(ra) # 44c <printint>
 5ac:	8b4a                	mv	s6,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 5ae:	4981                	li	s3,0
 5b0:	b765                	j	558 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 5b2:	008b0913          	addi	s2,s6,8
 5b6:	4681                	li	a3,0
 5b8:	4629                	li	a2,10
 5ba:	000b2583          	lw	a1,0(s6)
 5be:	8556                	mv	a0,s5
 5c0:	00000097          	auipc	ra,0x0
 5c4:	e8c080e7          	jalr	-372(ra) # 44c <printint>
 5c8:	8b4a                	mv	s6,s2
      state = 0;
 5ca:	4981                	li	s3,0
 5cc:	b771                	j	558 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 5ce:	008b0913          	addi	s2,s6,8
 5d2:	4681                	li	a3,0
 5d4:	866a                	mv	a2,s10
 5d6:	000b2583          	lw	a1,0(s6)
 5da:	8556                	mv	a0,s5
 5dc:	00000097          	auipc	ra,0x0
 5e0:	e70080e7          	jalr	-400(ra) # 44c <printint>
 5e4:	8b4a                	mv	s6,s2
      state = 0;
 5e6:	4981                	li	s3,0
 5e8:	bf85                	j	558 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 5ea:	008b0793          	addi	a5,s6,8
 5ee:	f8f43423          	sd	a5,-120(s0)
 5f2:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 5f6:	03000593          	li	a1,48
 5fa:	8556                	mv	a0,s5
 5fc:	00000097          	auipc	ra,0x0
 600:	e2e080e7          	jalr	-466(ra) # 42a <putc>
  putc(fd, 'x');
 604:	07800593          	li	a1,120
 608:	8556                	mv	a0,s5
 60a:	00000097          	auipc	ra,0x0
 60e:	e20080e7          	jalr	-480(ra) # 42a <putc>
 612:	896a                	mv	s2,s10
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 614:	03c9d793          	srli	a5,s3,0x3c
 618:	97de                	add	a5,a5,s7
 61a:	0007c583          	lbu	a1,0(a5)
 61e:	8556                	mv	a0,s5
 620:	00000097          	auipc	ra,0x0
 624:	e0a080e7          	jalr	-502(ra) # 42a <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 628:	0992                	slli	s3,s3,0x4
 62a:	397d                	addiw	s2,s2,-1
 62c:	fe0914e3          	bnez	s2,614 <vprintf+0x11c>
        printptr(fd, va_arg(ap, uint64));
 630:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 634:	4981                	li	s3,0
 636:	b70d                	j	558 <vprintf+0x60>
        s = va_arg(ap, char*);
 638:	008b0913          	addi	s2,s6,8
 63c:	000b3983          	ld	s3,0(s6)
        if(s == 0)
 640:	02098163          	beqz	s3,662 <vprintf+0x16a>
        while(*s != 0){
 644:	0009c583          	lbu	a1,0(s3)
 648:	c5ad                	beqz	a1,6b2 <vprintf+0x1ba>
          putc(fd, *s);
 64a:	8556                	mv	a0,s5
 64c:	00000097          	auipc	ra,0x0
 650:	dde080e7          	jalr	-546(ra) # 42a <putc>
          s++;
 654:	0985                	addi	s3,s3,1
        while(*s != 0){
 656:	0009c583          	lbu	a1,0(s3)
 65a:	f9e5                	bnez	a1,64a <vprintf+0x152>
        s = va_arg(ap, char*);
 65c:	8b4a                	mv	s6,s2
      state = 0;
 65e:	4981                	li	s3,0
 660:	bde5                	j	558 <vprintf+0x60>
          s = "(null)";
 662:	00000997          	auipc	s3,0x0
 666:	28e98993          	addi	s3,s3,654 # 8f0 <malloc+0x134>
        while(*s != 0){
 66a:	85ee                	mv	a1,s11
 66c:	bff9                	j	64a <vprintf+0x152>
        putc(fd, va_arg(ap, uint));
 66e:	008b0913          	addi	s2,s6,8
 672:	000b4583          	lbu	a1,0(s6)
 676:	8556                	mv	a0,s5
 678:	00000097          	auipc	ra,0x0
 67c:	db2080e7          	jalr	-590(ra) # 42a <putc>
 680:	8b4a                	mv	s6,s2
      state = 0;
 682:	4981                	li	s3,0
 684:	bdd1                	j	558 <vprintf+0x60>
        putc(fd, c);
 686:	85d2                	mv	a1,s4
 688:	8556                	mv	a0,s5
 68a:	00000097          	auipc	ra,0x0
 68e:	da0080e7          	jalr	-608(ra) # 42a <putc>
      state = 0;
 692:	4981                	li	s3,0
 694:	b5d1                	j	558 <vprintf+0x60>
        putc(fd, '%');
 696:	85d2                	mv	a1,s4
 698:	8556                	mv	a0,s5
 69a:	00000097          	auipc	ra,0x0
 69e:	d90080e7          	jalr	-624(ra) # 42a <putc>
        putc(fd, c);
 6a2:	85ca                	mv	a1,s2
 6a4:	8556                	mv	a0,s5
 6a6:	00000097          	auipc	ra,0x0
 6aa:	d84080e7          	jalr	-636(ra) # 42a <putc>
      state = 0;
 6ae:	4981                	li	s3,0
 6b0:	b565                	j	558 <vprintf+0x60>
        s = va_arg(ap, char*);
 6b2:	8b4a                	mv	s6,s2
      state = 0;
 6b4:	4981                	li	s3,0
 6b6:	b54d                	j	558 <vprintf+0x60>
    }
  }
}
 6b8:	70e6                	ld	ra,120(sp)
 6ba:	7446                	ld	s0,112(sp)
 6bc:	74a6                	ld	s1,104(sp)
 6be:	7906                	ld	s2,96(sp)
 6c0:	69e6                	ld	s3,88(sp)
 6c2:	6a46                	ld	s4,80(sp)
 6c4:	6aa6                	ld	s5,72(sp)
 6c6:	6b06                	ld	s6,64(sp)
 6c8:	7be2                	ld	s7,56(sp)
 6ca:	7c42                	ld	s8,48(sp)
 6cc:	7ca2                	ld	s9,40(sp)
 6ce:	7d02                	ld	s10,32(sp)
 6d0:	6de2                	ld	s11,24(sp)
 6d2:	6109                	addi	sp,sp,128
 6d4:	8082                	ret

00000000000006d6 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 6d6:	715d                	addi	sp,sp,-80
 6d8:	ec06                	sd	ra,24(sp)
 6da:	e822                	sd	s0,16(sp)
 6dc:	1000                	addi	s0,sp,32
 6de:	e010                	sd	a2,0(s0)
 6e0:	e414                	sd	a3,8(s0)
 6e2:	e818                	sd	a4,16(s0)
 6e4:	ec1c                	sd	a5,24(s0)
 6e6:	03043023          	sd	a6,32(s0)
 6ea:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 6ee:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 6f2:	8622                	mv	a2,s0
 6f4:	00000097          	auipc	ra,0x0
 6f8:	e04080e7          	jalr	-508(ra) # 4f8 <vprintf>
}
 6fc:	60e2                	ld	ra,24(sp)
 6fe:	6442                	ld	s0,16(sp)
 700:	6161                	addi	sp,sp,80
 702:	8082                	ret

0000000000000704 <printf>:

void
printf(const char *fmt, ...)
{
 704:	711d                	addi	sp,sp,-96
 706:	ec06                	sd	ra,24(sp)
 708:	e822                	sd	s0,16(sp)
 70a:	1000                	addi	s0,sp,32
 70c:	e40c                	sd	a1,8(s0)
 70e:	e810                	sd	a2,16(s0)
 710:	ec14                	sd	a3,24(s0)
 712:	f018                	sd	a4,32(s0)
 714:	f41c                	sd	a5,40(s0)
 716:	03043823          	sd	a6,48(s0)
 71a:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 71e:	00840613          	addi	a2,s0,8
 722:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 726:	85aa                	mv	a1,a0
 728:	4505                	li	a0,1
 72a:	00000097          	auipc	ra,0x0
 72e:	dce080e7          	jalr	-562(ra) # 4f8 <vprintf>
}
 732:	60e2                	ld	ra,24(sp)
 734:	6442                	ld	s0,16(sp)
 736:	6125                	addi	sp,sp,96
 738:	8082                	ret

000000000000073a <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 73a:	1141                	addi	sp,sp,-16
 73c:	e422                	sd	s0,8(sp)
 73e:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 740:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 744:	00000797          	auipc	a5,0x0
 748:	2247b783          	ld	a5,548(a5) # 968 <freep>
 74c:	a02d                	j	776 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 74e:	4618                	lw	a4,8(a2)
 750:	9f2d                	addw	a4,a4,a1
 752:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 756:	6398                	ld	a4,0(a5)
 758:	6310                	ld	a2,0(a4)
 75a:	a83d                	j	798 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 75c:	ff852703          	lw	a4,-8(a0)
 760:	9f31                	addw	a4,a4,a2
 762:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 764:	ff053683          	ld	a3,-16(a0)
 768:	a091                	j	7ac <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 76a:	6398                	ld	a4,0(a5)
 76c:	00e7e463          	bltu	a5,a4,774 <free+0x3a>
 770:	00e6ea63          	bltu	a3,a4,784 <free+0x4a>
{
 774:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 776:	fed7fae3          	bgeu	a5,a3,76a <free+0x30>
 77a:	6398                	ld	a4,0(a5)
 77c:	00e6e463          	bltu	a3,a4,784 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 780:	fee7eae3          	bltu	a5,a4,774 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 784:	ff852583          	lw	a1,-8(a0)
 788:	6390                	ld	a2,0(a5)
 78a:	02059813          	slli	a6,a1,0x20
 78e:	01c85713          	srli	a4,a6,0x1c
 792:	9736                	add	a4,a4,a3
 794:	fae60de3          	beq	a2,a4,74e <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 798:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 79c:	4790                	lw	a2,8(a5)
 79e:	02061593          	slli	a1,a2,0x20
 7a2:	01c5d713          	srli	a4,a1,0x1c
 7a6:	973e                	add	a4,a4,a5
 7a8:	fae68ae3          	beq	a3,a4,75c <free+0x22>
    p->s.ptr = bp->s.ptr;
 7ac:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 7ae:	00000717          	auipc	a4,0x0
 7b2:	1af73d23          	sd	a5,442(a4) # 968 <freep>
}
 7b6:	6422                	ld	s0,8(sp)
 7b8:	0141                	addi	sp,sp,16
 7ba:	8082                	ret

00000000000007bc <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 7bc:	7139                	addi	sp,sp,-64
 7be:	fc06                	sd	ra,56(sp)
 7c0:	f822                	sd	s0,48(sp)
 7c2:	f426                	sd	s1,40(sp)
 7c4:	f04a                	sd	s2,32(sp)
 7c6:	ec4e                	sd	s3,24(sp)
 7c8:	e852                	sd	s4,16(sp)
 7ca:	e456                	sd	s5,8(sp)
 7cc:	e05a                	sd	s6,0(sp)
 7ce:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7d0:	02051493          	slli	s1,a0,0x20
 7d4:	9081                	srli	s1,s1,0x20
 7d6:	04bd                	addi	s1,s1,15
 7d8:	8091                	srli	s1,s1,0x4
 7da:	0014899b          	addiw	s3,s1,1
 7de:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 7e0:	00000517          	auipc	a0,0x0
 7e4:	18853503          	ld	a0,392(a0) # 968 <freep>
 7e8:	c515                	beqz	a0,814 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7ea:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 7ec:	4798                	lw	a4,8(a5)
 7ee:	02977f63          	bgeu	a4,s1,82c <malloc+0x70>
 7f2:	8a4e                	mv	s4,s3
 7f4:	0009871b          	sext.w	a4,s3
 7f8:	6685                	lui	a3,0x1
 7fa:	00d77363          	bgeu	a4,a3,800 <malloc+0x44>
 7fe:	6a05                	lui	s4,0x1
 800:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 804:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 808:	00000917          	auipc	s2,0x0
 80c:	16090913          	addi	s2,s2,352 # 968 <freep>
  if(p == (char*)-1)
 810:	5afd                	li	s5,-1
 812:	a895                	j	886 <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
 814:	00000797          	auipc	a5,0x0
 818:	35c78793          	addi	a5,a5,860 # b70 <base>
 81c:	00000717          	auipc	a4,0x0
 820:	14f73623          	sd	a5,332(a4) # 968 <freep>
 824:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 826:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 82a:	b7e1                	j	7f2 <malloc+0x36>
      if(p->s.size == nunits)
 82c:	02e48c63          	beq	s1,a4,864 <malloc+0xa8>
        p->s.size -= nunits;
 830:	4137073b          	subw	a4,a4,s3
 834:	c798                	sw	a4,8(a5)
        p += p->s.size;
 836:	02071693          	slli	a3,a4,0x20
 83a:	01c6d713          	srli	a4,a3,0x1c
 83e:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 840:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 844:	00000717          	auipc	a4,0x0
 848:	12a73223          	sd	a0,292(a4) # 968 <freep>
      return (void*)(p + 1);
 84c:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 850:	70e2                	ld	ra,56(sp)
 852:	7442                	ld	s0,48(sp)
 854:	74a2                	ld	s1,40(sp)
 856:	7902                	ld	s2,32(sp)
 858:	69e2                	ld	s3,24(sp)
 85a:	6a42                	ld	s4,16(sp)
 85c:	6aa2                	ld	s5,8(sp)
 85e:	6b02                	ld	s6,0(sp)
 860:	6121                	addi	sp,sp,64
 862:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 864:	6398                	ld	a4,0(a5)
 866:	e118                	sd	a4,0(a0)
 868:	bff1                	j	844 <malloc+0x88>
  hp->s.size = nu;
 86a:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 86e:	0541                	addi	a0,a0,16
 870:	00000097          	auipc	ra,0x0
 874:	eca080e7          	jalr	-310(ra) # 73a <free>
  return freep;
 878:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 87c:	d971                	beqz	a0,850 <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 87e:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 880:	4798                	lw	a4,8(a5)
 882:	fa9775e3          	bgeu	a4,s1,82c <malloc+0x70>
    if(p == freep)
 886:	00093703          	ld	a4,0(s2)
 88a:	853e                	mv	a0,a5
 88c:	fef719e3          	bne	a4,a5,87e <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
 890:	8552                	mv	a0,s4
 892:	00000097          	auipc	ra,0x0
 896:	b80080e7          	jalr	-1152(ra) # 412 <sbrk>
  if(p == (char*)-1)
 89a:	fd5518e3          	bne	a0,s5,86a <malloc+0xae>
        return 0;
 89e:	4501                	li	a0,0
 8a0:	bf45                	j	850 <malloc+0x94>
