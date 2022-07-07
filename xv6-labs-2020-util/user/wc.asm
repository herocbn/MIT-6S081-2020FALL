
user/_wc：     文件格式 elf64-littleriscv


Disassembly of section .text:

0000000000000000 <wc>:

char buf[512];

void
wc(int fd, char *name)
{
   0:	7119                	addi	sp,sp,-128
   2:	fc86                	sd	ra,120(sp)
   4:	f8a2                	sd	s0,112(sp)
   6:	f4a6                	sd	s1,104(sp)
   8:	f0ca                	sd	s2,96(sp)
   a:	ecce                	sd	s3,88(sp)
   c:	e8d2                	sd	s4,80(sp)
   e:	e4d6                	sd	s5,72(sp)
  10:	e0da                	sd	s6,64(sp)
  12:	fc5e                	sd	s7,56(sp)
  14:	f862                	sd	s8,48(sp)
  16:	f466                	sd	s9,40(sp)
  18:	f06a                	sd	s10,32(sp)
  1a:	ec6e                	sd	s11,24(sp)
  1c:	0100                	addi	s0,sp,128
  1e:	f8a43423          	sd	a0,-120(s0)
  22:	f8b43023          	sd	a1,-128(s0)
  int i, n;
  int l, w, c, inword;

  l = w = c = 0;
  inword = 0;
  26:	4981                	li	s3,0
  l = w = c = 0;
  28:	4c81                	li	s9,0
  2a:	4c01                	li	s8,0
  2c:	4b81                	li	s7,0
  2e:	00001d97          	auipc	s11,0x1
  32:	9bbd8d93          	addi	s11,s11,-1605 # 9e9 <buf+0x1>
  while((n = read(fd, buf, sizeof(buf))) > 0){
    for(i=0; i<n; i++){
      c++;
      if(buf[i] == '\n')
  36:	4aa9                	li	s5,10
        l++;
      if(strchr(" \r\t\n\v", buf[i]))
  38:	00001a17          	auipc	s4,0x1
  3c:	8e8a0a13          	addi	s4,s4,-1816 # 920 <malloc+0xec>
        inword = 0;
  40:	4b01                	li	s6,0
  while((n = read(fd, buf, sizeof(buf))) > 0){
  42:	a805                	j	72 <wc+0x72>
      if(strchr(" \r\t\n\v", buf[i]))
  44:	8552                	mv	a0,s4
  46:	00000097          	auipc	ra,0x0
  4a:	1e4080e7          	jalr	484(ra) # 22a <strchr>
  4e:	c919                	beqz	a0,64 <wc+0x64>
        inword = 0;
  50:	89da                	mv	s3,s6
    for(i=0; i<n; i++){
  52:	0485                	addi	s1,s1,1
  54:	01248d63          	beq	s1,s2,6e <wc+0x6e>
      if(buf[i] == '\n')
  58:	0004c583          	lbu	a1,0(s1)
  5c:	ff5594e3          	bne	a1,s5,44 <wc+0x44>
        l++;
  60:	2b85                	addiw	s7,s7,1
  62:	b7cd                	j	44 <wc+0x44>
      else if(!inword){
  64:	fe0997e3          	bnez	s3,52 <wc+0x52>
        w++;
  68:	2c05                	addiw	s8,s8,1
        inword = 1;
  6a:	4985                	li	s3,1
  6c:	b7dd                	j	52 <wc+0x52>
      c++;
  6e:	01ac8cbb          	addw	s9,s9,s10
  while((n = read(fd, buf, sizeof(buf))) > 0){
  72:	20000613          	li	a2,512
  76:	00001597          	auipc	a1,0x1
  7a:	97258593          	addi	a1,a1,-1678 # 9e8 <buf>
  7e:	f8843503          	ld	a0,-120(s0)
  82:	00000097          	auipc	ra,0x0
  86:	398080e7          	jalr	920(ra) # 41a <read>
  8a:	00a05f63          	blez	a0,a8 <wc+0xa8>
    for(i=0; i<n; i++){
  8e:	00001497          	auipc	s1,0x1
  92:	95a48493          	addi	s1,s1,-1702 # 9e8 <buf>
  96:	00050d1b          	sext.w	s10,a0
  9a:	fff5091b          	addiw	s2,a0,-1
  9e:	1902                	slli	s2,s2,0x20
  a0:	02095913          	srli	s2,s2,0x20
  a4:	996e                	add	s2,s2,s11
  a6:	bf4d                	j	58 <wc+0x58>
      }
    }
  }
  if(n < 0){
  a8:	02054e63          	bltz	a0,e4 <wc+0xe4>
    printf("wc: read error\n");
    exit(1);
  }
  printf("%d %d %d %s\n", l, w, c, name);
  ac:	f8043703          	ld	a4,-128(s0)
  b0:	86e6                	mv	a3,s9
  b2:	8662                	mv	a2,s8
  b4:	85de                	mv	a1,s7
  b6:	00001517          	auipc	a0,0x1
  ba:	88250513          	addi	a0,a0,-1918 # 938 <malloc+0x104>
  be:	00000097          	auipc	ra,0x0
  c2:	6be080e7          	jalr	1726(ra) # 77c <printf>
}
  c6:	70e6                	ld	ra,120(sp)
  c8:	7446                	ld	s0,112(sp)
  ca:	74a6                	ld	s1,104(sp)
  cc:	7906                	ld	s2,96(sp)
  ce:	69e6                	ld	s3,88(sp)
  d0:	6a46                	ld	s4,80(sp)
  d2:	6aa6                	ld	s5,72(sp)
  d4:	6b06                	ld	s6,64(sp)
  d6:	7be2                	ld	s7,56(sp)
  d8:	7c42                	ld	s8,48(sp)
  da:	7ca2                	ld	s9,40(sp)
  dc:	7d02                	ld	s10,32(sp)
  de:	6de2                	ld	s11,24(sp)
  e0:	6109                	addi	sp,sp,128
  e2:	8082                	ret
    printf("wc: read error\n");
  e4:	00001517          	auipc	a0,0x1
  e8:	84450513          	addi	a0,a0,-1980 # 928 <malloc+0xf4>
  ec:	00000097          	auipc	ra,0x0
  f0:	690080e7          	jalr	1680(ra) # 77c <printf>
    exit(1);
  f4:	4505                	li	a0,1
  f6:	00000097          	auipc	ra,0x0
  fa:	30c080e7          	jalr	780(ra) # 402 <exit>

00000000000000fe <main>:

int
main(int argc, char *argv[])
{
  fe:	7179                	addi	sp,sp,-48
 100:	f406                	sd	ra,40(sp)
 102:	f022                	sd	s0,32(sp)
 104:	ec26                	sd	s1,24(sp)
 106:	e84a                	sd	s2,16(sp)
 108:	e44e                	sd	s3,8(sp)
 10a:	e052                	sd	s4,0(sp)
 10c:	1800                	addi	s0,sp,48
  int fd, i;

  if(argc <= 1){
 10e:	4785                	li	a5,1
 110:	04a7d763          	bge	a5,a0,15e <main+0x60>
 114:	00858493          	addi	s1,a1,8
 118:	ffe5099b          	addiw	s3,a0,-2
 11c:	02099793          	slli	a5,s3,0x20
 120:	01d7d993          	srli	s3,a5,0x1d
 124:	05c1                	addi	a1,a1,16
 126:	99ae                	add	s3,s3,a1
    wc(0, "");
    exit(0);
  }

  for(i = 1; i < argc; i++){
    if((fd = open(argv[i], 0)) < 0){
 128:	4581                	li	a1,0
 12a:	6088                	ld	a0,0(s1)
 12c:	00000097          	auipc	ra,0x0
 130:	316080e7          	jalr	790(ra) # 442 <open>
 134:	892a                	mv	s2,a0
 136:	04054263          	bltz	a0,17a <main+0x7c>
      printf("wc: cannot open %s\n", argv[i]);
      exit(1);
    }
    wc(fd, argv[i]);
 13a:	608c                	ld	a1,0(s1)
 13c:	00000097          	auipc	ra,0x0
 140:	ec4080e7          	jalr	-316(ra) # 0 <wc>
    close(fd);
 144:	854a                	mv	a0,s2
 146:	00000097          	auipc	ra,0x0
 14a:	2e4080e7          	jalr	740(ra) # 42a <close>
  for(i = 1; i < argc; i++){
 14e:	04a1                	addi	s1,s1,8
 150:	fd349ce3          	bne	s1,s3,128 <main+0x2a>
  }
  exit(0);
 154:	4501                	li	a0,0
 156:	00000097          	auipc	ra,0x0
 15a:	2ac080e7          	jalr	684(ra) # 402 <exit>
    wc(0, "");
 15e:	00000597          	auipc	a1,0x0
 162:	7ea58593          	addi	a1,a1,2026 # 948 <malloc+0x114>
 166:	4501                	li	a0,0
 168:	00000097          	auipc	ra,0x0
 16c:	e98080e7          	jalr	-360(ra) # 0 <wc>
    exit(0);
 170:	4501                	li	a0,0
 172:	00000097          	auipc	ra,0x0
 176:	290080e7          	jalr	656(ra) # 402 <exit>
      printf("wc: cannot open %s\n", argv[i]);
 17a:	608c                	ld	a1,0(s1)
 17c:	00000517          	auipc	a0,0x0
 180:	7d450513          	addi	a0,a0,2004 # 950 <malloc+0x11c>
 184:	00000097          	auipc	ra,0x0
 188:	5f8080e7          	jalr	1528(ra) # 77c <printf>
      exit(1);
 18c:	4505                	li	a0,1
 18e:	00000097          	auipc	ra,0x0
 192:	274080e7          	jalr	628(ra) # 402 <exit>

0000000000000196 <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
 196:	1141                	addi	sp,sp,-16
 198:	e422                	sd	s0,8(sp)
 19a:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 19c:	87aa                	mv	a5,a0
 19e:	0585                	addi	a1,a1,1
 1a0:	0785                	addi	a5,a5,1
 1a2:	fff5c703          	lbu	a4,-1(a1)
 1a6:	fee78fa3          	sb	a4,-1(a5)
 1aa:	fb75                	bnez	a4,19e <strcpy+0x8>
    ;
  return os;
}
 1ac:	6422                	ld	s0,8(sp)
 1ae:	0141                	addi	sp,sp,16
 1b0:	8082                	ret

00000000000001b2 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 1b2:	1141                	addi	sp,sp,-16
 1b4:	e422                	sd	s0,8(sp)
 1b6:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 1b8:	00054783          	lbu	a5,0(a0)
 1bc:	cb91                	beqz	a5,1d0 <strcmp+0x1e>
 1be:	0005c703          	lbu	a4,0(a1)
 1c2:	00f71763          	bne	a4,a5,1d0 <strcmp+0x1e>
    p++, q++;
 1c6:	0505                	addi	a0,a0,1
 1c8:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 1ca:	00054783          	lbu	a5,0(a0)
 1ce:	fbe5                	bnez	a5,1be <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 1d0:	0005c503          	lbu	a0,0(a1)
}
 1d4:	40a7853b          	subw	a0,a5,a0
 1d8:	6422                	ld	s0,8(sp)
 1da:	0141                	addi	sp,sp,16
 1dc:	8082                	ret

00000000000001de <strlen>:

uint
strlen(const char *s)
{
 1de:	1141                	addi	sp,sp,-16
 1e0:	e422                	sd	s0,8(sp)
 1e2:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 1e4:	00054783          	lbu	a5,0(a0)
 1e8:	cf91                	beqz	a5,204 <strlen+0x26>
 1ea:	0505                	addi	a0,a0,1
 1ec:	87aa                	mv	a5,a0
 1ee:	4685                	li	a3,1
 1f0:	9e89                	subw	a3,a3,a0
 1f2:	00f6853b          	addw	a0,a3,a5
 1f6:	0785                	addi	a5,a5,1
 1f8:	fff7c703          	lbu	a4,-1(a5)
 1fc:	fb7d                	bnez	a4,1f2 <strlen+0x14>
    ;
  return n;
}
 1fe:	6422                	ld	s0,8(sp)
 200:	0141                	addi	sp,sp,16
 202:	8082                	ret
  for(n = 0; s[n]; n++)
 204:	4501                	li	a0,0
 206:	bfe5                	j	1fe <strlen+0x20>

0000000000000208 <memset>:

void*
memset(void *dst, int c, uint n)
{
 208:	1141                	addi	sp,sp,-16
 20a:	e422                	sd	s0,8(sp)
 20c:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 20e:	ca19                	beqz	a2,224 <memset+0x1c>
 210:	87aa                	mv	a5,a0
 212:	1602                	slli	a2,a2,0x20
 214:	9201                	srli	a2,a2,0x20
 216:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 21a:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 21e:	0785                	addi	a5,a5,1
 220:	fee79de3          	bne	a5,a4,21a <memset+0x12>
  }
  return dst;
}
 224:	6422                	ld	s0,8(sp)
 226:	0141                	addi	sp,sp,16
 228:	8082                	ret

000000000000022a <strchr>:

char*
strchr(const char *s, char c)
{
 22a:	1141                	addi	sp,sp,-16
 22c:	e422                	sd	s0,8(sp)
 22e:	0800                	addi	s0,sp,16
  for(; *s; s++)
 230:	00054783          	lbu	a5,0(a0)
 234:	cb99                	beqz	a5,24a <strchr+0x20>
    if(*s == c)
 236:	00f58763          	beq	a1,a5,244 <strchr+0x1a>
  for(; *s; s++)
 23a:	0505                	addi	a0,a0,1
 23c:	00054783          	lbu	a5,0(a0)
 240:	fbfd                	bnez	a5,236 <strchr+0xc>
      return (char*)s;
  return 0;
 242:	4501                	li	a0,0
}
 244:	6422                	ld	s0,8(sp)
 246:	0141                	addi	sp,sp,16
 248:	8082                	ret
  return 0;
 24a:	4501                	li	a0,0
 24c:	bfe5                	j	244 <strchr+0x1a>

000000000000024e <gets>:

char*
gets(char *buf, int max)
{
 24e:	711d                	addi	sp,sp,-96
 250:	ec86                	sd	ra,88(sp)
 252:	e8a2                	sd	s0,80(sp)
 254:	e4a6                	sd	s1,72(sp)
 256:	e0ca                	sd	s2,64(sp)
 258:	fc4e                	sd	s3,56(sp)
 25a:	f852                	sd	s4,48(sp)
 25c:	f456                	sd	s5,40(sp)
 25e:	f05a                	sd	s6,32(sp)
 260:	ec5e                	sd	s7,24(sp)
 262:	1080                	addi	s0,sp,96
 264:	8baa                	mv	s7,a0
 266:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 268:	892a                	mv	s2,a0
 26a:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 26c:	4aa9                	li	s5,10
 26e:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 270:	89a6                	mv	s3,s1
 272:	2485                	addiw	s1,s1,1
 274:	0344d863          	bge	s1,s4,2a4 <gets+0x56>
    cc = read(0, &c, 1);
 278:	4605                	li	a2,1
 27a:	faf40593          	addi	a1,s0,-81
 27e:	4501                	li	a0,0
 280:	00000097          	auipc	ra,0x0
 284:	19a080e7          	jalr	410(ra) # 41a <read>
    if(cc < 1)
 288:	00a05e63          	blez	a0,2a4 <gets+0x56>
    buf[i++] = c;
 28c:	faf44783          	lbu	a5,-81(s0)
 290:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 294:	01578763          	beq	a5,s5,2a2 <gets+0x54>
 298:	0905                	addi	s2,s2,1
 29a:	fd679be3          	bne	a5,s6,270 <gets+0x22>
  for(i=0; i+1 < max; ){
 29e:	89a6                	mv	s3,s1
 2a0:	a011                	j	2a4 <gets+0x56>
 2a2:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 2a4:	99de                	add	s3,s3,s7
 2a6:	00098023          	sb	zero,0(s3)
  return buf;
}
 2aa:	855e                	mv	a0,s7
 2ac:	60e6                	ld	ra,88(sp)
 2ae:	6446                	ld	s0,80(sp)
 2b0:	64a6                	ld	s1,72(sp)
 2b2:	6906                	ld	s2,64(sp)
 2b4:	79e2                	ld	s3,56(sp)
 2b6:	7a42                	ld	s4,48(sp)
 2b8:	7aa2                	ld	s5,40(sp)
 2ba:	7b02                	ld	s6,32(sp)
 2bc:	6be2                	ld	s7,24(sp)
 2be:	6125                	addi	sp,sp,96
 2c0:	8082                	ret

00000000000002c2 <stat>:

int
stat(const char *n, struct stat *st)
{
 2c2:	1101                	addi	sp,sp,-32
 2c4:	ec06                	sd	ra,24(sp)
 2c6:	e822                	sd	s0,16(sp)
 2c8:	e426                	sd	s1,8(sp)
 2ca:	e04a                	sd	s2,0(sp)
 2cc:	1000                	addi	s0,sp,32
 2ce:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 2d0:	4581                	li	a1,0
 2d2:	00000097          	auipc	ra,0x0
 2d6:	170080e7          	jalr	368(ra) # 442 <open>
  if(fd < 0)
 2da:	02054563          	bltz	a0,304 <stat+0x42>
 2de:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 2e0:	85ca                	mv	a1,s2
 2e2:	00000097          	auipc	ra,0x0
 2e6:	178080e7          	jalr	376(ra) # 45a <fstat>
 2ea:	892a                	mv	s2,a0
  close(fd);
 2ec:	8526                	mv	a0,s1
 2ee:	00000097          	auipc	ra,0x0
 2f2:	13c080e7          	jalr	316(ra) # 42a <close>
  return r;
}
 2f6:	854a                	mv	a0,s2
 2f8:	60e2                	ld	ra,24(sp)
 2fa:	6442                	ld	s0,16(sp)
 2fc:	64a2                	ld	s1,8(sp)
 2fe:	6902                	ld	s2,0(sp)
 300:	6105                	addi	sp,sp,32
 302:	8082                	ret
    return -1;
 304:	597d                	li	s2,-1
 306:	bfc5                	j	2f6 <stat+0x34>

0000000000000308 <atoi>:

int
atoi(const char *s)
{
 308:	1141                	addi	sp,sp,-16
 30a:	e422                	sd	s0,8(sp)
 30c:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 30e:	00054683          	lbu	a3,0(a0)
 312:	fd06879b          	addiw	a5,a3,-48
 316:	0ff7f793          	zext.b	a5,a5
 31a:	4625                	li	a2,9
 31c:	02f66863          	bltu	a2,a5,34c <atoi+0x44>
 320:	872a                	mv	a4,a0
  n = 0;
 322:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 324:	0705                	addi	a4,a4,1
 326:	0025179b          	slliw	a5,a0,0x2
 32a:	9fa9                	addw	a5,a5,a0
 32c:	0017979b          	slliw	a5,a5,0x1
 330:	9fb5                	addw	a5,a5,a3
 332:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 336:	00074683          	lbu	a3,0(a4)
 33a:	fd06879b          	addiw	a5,a3,-48
 33e:	0ff7f793          	zext.b	a5,a5
 342:	fef671e3          	bgeu	a2,a5,324 <atoi+0x1c>
  return n;
}
 346:	6422                	ld	s0,8(sp)
 348:	0141                	addi	sp,sp,16
 34a:	8082                	ret
  n = 0;
 34c:	4501                	li	a0,0
 34e:	bfe5                	j	346 <atoi+0x3e>

0000000000000350 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 350:	1141                	addi	sp,sp,-16
 352:	e422                	sd	s0,8(sp)
 354:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 356:	02b57463          	bgeu	a0,a1,37e <memmove+0x2e>
    while(n-- > 0)
 35a:	00c05f63          	blez	a2,378 <memmove+0x28>
 35e:	1602                	slli	a2,a2,0x20
 360:	9201                	srli	a2,a2,0x20
 362:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 366:	872a                	mv	a4,a0
      *dst++ = *src++;
 368:	0585                	addi	a1,a1,1
 36a:	0705                	addi	a4,a4,1
 36c:	fff5c683          	lbu	a3,-1(a1)
 370:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 374:	fee79ae3          	bne	a5,a4,368 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 378:	6422                	ld	s0,8(sp)
 37a:	0141                	addi	sp,sp,16
 37c:	8082                	ret
    dst += n;
 37e:	00c50733          	add	a4,a0,a2
    src += n;
 382:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 384:	fec05ae3          	blez	a2,378 <memmove+0x28>
 388:	fff6079b          	addiw	a5,a2,-1
 38c:	1782                	slli	a5,a5,0x20
 38e:	9381                	srli	a5,a5,0x20
 390:	fff7c793          	not	a5,a5
 394:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 396:	15fd                	addi	a1,a1,-1
 398:	177d                	addi	a4,a4,-1
 39a:	0005c683          	lbu	a3,0(a1)
 39e:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 3a2:	fee79ae3          	bne	a5,a4,396 <memmove+0x46>
 3a6:	bfc9                	j	378 <memmove+0x28>

00000000000003a8 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 3a8:	1141                	addi	sp,sp,-16
 3aa:	e422                	sd	s0,8(sp)
 3ac:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 3ae:	ca05                	beqz	a2,3de <memcmp+0x36>
 3b0:	fff6069b          	addiw	a3,a2,-1
 3b4:	1682                	slli	a3,a3,0x20
 3b6:	9281                	srli	a3,a3,0x20
 3b8:	0685                	addi	a3,a3,1
 3ba:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 3bc:	00054783          	lbu	a5,0(a0)
 3c0:	0005c703          	lbu	a4,0(a1)
 3c4:	00e79863          	bne	a5,a4,3d4 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 3c8:	0505                	addi	a0,a0,1
    p2++;
 3ca:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 3cc:	fed518e3          	bne	a0,a3,3bc <memcmp+0x14>
  }
  return 0;
 3d0:	4501                	li	a0,0
 3d2:	a019                	j	3d8 <memcmp+0x30>
      return *p1 - *p2;
 3d4:	40e7853b          	subw	a0,a5,a4
}
 3d8:	6422                	ld	s0,8(sp)
 3da:	0141                	addi	sp,sp,16
 3dc:	8082                	ret
  return 0;
 3de:	4501                	li	a0,0
 3e0:	bfe5                	j	3d8 <memcmp+0x30>

00000000000003e2 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 3e2:	1141                	addi	sp,sp,-16
 3e4:	e406                	sd	ra,8(sp)
 3e6:	e022                	sd	s0,0(sp)
 3e8:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 3ea:	00000097          	auipc	ra,0x0
 3ee:	f66080e7          	jalr	-154(ra) # 350 <memmove>
}
 3f2:	60a2                	ld	ra,8(sp)
 3f4:	6402                	ld	s0,0(sp)
 3f6:	0141                	addi	sp,sp,16
 3f8:	8082                	ret

00000000000003fa <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 3fa:	4885                	li	a7,1
 ecall
 3fc:	00000073          	ecall
 ret
 400:	8082                	ret

0000000000000402 <exit>:
.global exit
exit:
 li a7, SYS_exit
 402:	4889                	li	a7,2
 ecall
 404:	00000073          	ecall
 ret
 408:	8082                	ret

000000000000040a <wait>:
.global wait
wait:
 li a7, SYS_wait
 40a:	488d                	li	a7,3
 ecall
 40c:	00000073          	ecall
 ret
 410:	8082                	ret

0000000000000412 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 412:	4891                	li	a7,4
 ecall
 414:	00000073          	ecall
 ret
 418:	8082                	ret

000000000000041a <read>:
.global read
read:
 li a7, SYS_read
 41a:	4895                	li	a7,5
 ecall
 41c:	00000073          	ecall
 ret
 420:	8082                	ret

0000000000000422 <write>:
.global write
write:
 li a7, SYS_write
 422:	48c1                	li	a7,16
 ecall
 424:	00000073          	ecall
 ret
 428:	8082                	ret

000000000000042a <close>:
.global close
close:
 li a7, SYS_close
 42a:	48d5                	li	a7,21
 ecall
 42c:	00000073          	ecall
 ret
 430:	8082                	ret

0000000000000432 <kill>:
.global kill
kill:
 li a7, SYS_kill
 432:	4899                	li	a7,6
 ecall
 434:	00000073          	ecall
 ret
 438:	8082                	ret

000000000000043a <exec>:
.global exec
exec:
 li a7, SYS_exec
 43a:	489d                	li	a7,7
 ecall
 43c:	00000073          	ecall
 ret
 440:	8082                	ret

0000000000000442 <open>:
.global open
open:
 li a7, SYS_open
 442:	48bd                	li	a7,15
 ecall
 444:	00000073          	ecall
 ret
 448:	8082                	ret

000000000000044a <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 44a:	48c5                	li	a7,17
 ecall
 44c:	00000073          	ecall
 ret
 450:	8082                	ret

0000000000000452 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 452:	48c9                	li	a7,18
 ecall
 454:	00000073          	ecall
 ret
 458:	8082                	ret

000000000000045a <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 45a:	48a1                	li	a7,8
 ecall
 45c:	00000073          	ecall
 ret
 460:	8082                	ret

0000000000000462 <link>:
.global link
link:
 li a7, SYS_link
 462:	48cd                	li	a7,19
 ecall
 464:	00000073          	ecall
 ret
 468:	8082                	ret

000000000000046a <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 46a:	48d1                	li	a7,20
 ecall
 46c:	00000073          	ecall
 ret
 470:	8082                	ret

0000000000000472 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 472:	48a5                	li	a7,9
 ecall
 474:	00000073          	ecall
 ret
 478:	8082                	ret

000000000000047a <dup>:
.global dup
dup:
 li a7, SYS_dup
 47a:	48a9                	li	a7,10
 ecall
 47c:	00000073          	ecall
 ret
 480:	8082                	ret

0000000000000482 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 482:	48ad                	li	a7,11
 ecall
 484:	00000073          	ecall
 ret
 488:	8082                	ret

000000000000048a <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 48a:	48b1                	li	a7,12
 ecall
 48c:	00000073          	ecall
 ret
 490:	8082                	ret

0000000000000492 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 492:	48b5                	li	a7,13
 ecall
 494:	00000073          	ecall
 ret
 498:	8082                	ret

000000000000049a <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 49a:	48b9                	li	a7,14
 ecall
 49c:	00000073          	ecall
 ret
 4a0:	8082                	ret

00000000000004a2 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 4a2:	1101                	addi	sp,sp,-32
 4a4:	ec06                	sd	ra,24(sp)
 4a6:	e822                	sd	s0,16(sp)
 4a8:	1000                	addi	s0,sp,32
 4aa:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 4ae:	4605                	li	a2,1
 4b0:	fef40593          	addi	a1,s0,-17
 4b4:	00000097          	auipc	ra,0x0
 4b8:	f6e080e7          	jalr	-146(ra) # 422 <write>
}
 4bc:	60e2                	ld	ra,24(sp)
 4be:	6442                	ld	s0,16(sp)
 4c0:	6105                	addi	sp,sp,32
 4c2:	8082                	ret

00000000000004c4 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 4c4:	7139                	addi	sp,sp,-64
 4c6:	fc06                	sd	ra,56(sp)
 4c8:	f822                	sd	s0,48(sp)
 4ca:	f426                	sd	s1,40(sp)
 4cc:	f04a                	sd	s2,32(sp)
 4ce:	ec4e                	sd	s3,24(sp)
 4d0:	0080                	addi	s0,sp,64
 4d2:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 4d4:	c299                	beqz	a3,4da <printint+0x16>
 4d6:	0805c963          	bltz	a1,568 <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 4da:	2581                	sext.w	a1,a1
  neg = 0;
 4dc:	4881                	li	a7,0
 4de:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 4e2:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 4e4:	2601                	sext.w	a2,a2
 4e6:	00000517          	auipc	a0,0x0
 4ea:	4e250513          	addi	a0,a0,1250 # 9c8 <digits>
 4ee:	883a                	mv	a6,a4
 4f0:	2705                	addiw	a4,a4,1
 4f2:	02c5f7bb          	remuw	a5,a1,a2
 4f6:	1782                	slli	a5,a5,0x20
 4f8:	9381                	srli	a5,a5,0x20
 4fa:	97aa                	add	a5,a5,a0
 4fc:	0007c783          	lbu	a5,0(a5)
 500:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 504:	0005879b          	sext.w	a5,a1
 508:	02c5d5bb          	divuw	a1,a1,a2
 50c:	0685                	addi	a3,a3,1
 50e:	fec7f0e3          	bgeu	a5,a2,4ee <printint+0x2a>
  if(neg)
 512:	00088c63          	beqz	a7,52a <printint+0x66>
    buf[i++] = '-';
 516:	fd070793          	addi	a5,a4,-48
 51a:	00878733          	add	a4,a5,s0
 51e:	02d00793          	li	a5,45
 522:	fef70823          	sb	a5,-16(a4)
 526:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 52a:	02e05863          	blez	a4,55a <printint+0x96>
 52e:	fc040793          	addi	a5,s0,-64
 532:	00e78933          	add	s2,a5,a4
 536:	fff78993          	addi	s3,a5,-1
 53a:	99ba                	add	s3,s3,a4
 53c:	377d                	addiw	a4,a4,-1
 53e:	1702                	slli	a4,a4,0x20
 540:	9301                	srli	a4,a4,0x20
 542:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 546:	fff94583          	lbu	a1,-1(s2)
 54a:	8526                	mv	a0,s1
 54c:	00000097          	auipc	ra,0x0
 550:	f56080e7          	jalr	-170(ra) # 4a2 <putc>
  while(--i >= 0)
 554:	197d                	addi	s2,s2,-1
 556:	ff3918e3          	bne	s2,s3,546 <printint+0x82>
}
 55a:	70e2                	ld	ra,56(sp)
 55c:	7442                	ld	s0,48(sp)
 55e:	74a2                	ld	s1,40(sp)
 560:	7902                	ld	s2,32(sp)
 562:	69e2                	ld	s3,24(sp)
 564:	6121                	addi	sp,sp,64
 566:	8082                	ret
    x = -xx;
 568:	40b005bb          	negw	a1,a1
    neg = 1;
 56c:	4885                	li	a7,1
    x = -xx;
 56e:	bf85                	j	4de <printint+0x1a>

0000000000000570 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 570:	7119                	addi	sp,sp,-128
 572:	fc86                	sd	ra,120(sp)
 574:	f8a2                	sd	s0,112(sp)
 576:	f4a6                	sd	s1,104(sp)
 578:	f0ca                	sd	s2,96(sp)
 57a:	ecce                	sd	s3,88(sp)
 57c:	e8d2                	sd	s4,80(sp)
 57e:	e4d6                	sd	s5,72(sp)
 580:	e0da                	sd	s6,64(sp)
 582:	fc5e                	sd	s7,56(sp)
 584:	f862                	sd	s8,48(sp)
 586:	f466                	sd	s9,40(sp)
 588:	f06a                	sd	s10,32(sp)
 58a:	ec6e                	sd	s11,24(sp)
 58c:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 58e:	0005c903          	lbu	s2,0(a1)
 592:	18090f63          	beqz	s2,730 <vprintf+0x1c0>
 596:	8aaa                	mv	s5,a0
 598:	8b32                	mv	s6,a2
 59a:	00158493          	addi	s1,a1,1
  state = 0;
 59e:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 5a0:	02500a13          	li	s4,37
 5a4:	4c55                	li	s8,21
 5a6:	00000c97          	auipc	s9,0x0
 5aa:	3cac8c93          	addi	s9,s9,970 # 970 <malloc+0x13c>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
        s = va_arg(ap, char*);
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 5ae:	02800d93          	li	s11,40
  putc(fd, 'x');
 5b2:	4d41                	li	s10,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 5b4:	00000b97          	auipc	s7,0x0
 5b8:	414b8b93          	addi	s7,s7,1044 # 9c8 <digits>
 5bc:	a839                	j	5da <vprintf+0x6a>
        putc(fd, c);
 5be:	85ca                	mv	a1,s2
 5c0:	8556                	mv	a0,s5
 5c2:	00000097          	auipc	ra,0x0
 5c6:	ee0080e7          	jalr	-288(ra) # 4a2 <putc>
 5ca:	a019                	j	5d0 <vprintf+0x60>
    } else if(state == '%'){
 5cc:	01498d63          	beq	s3,s4,5e6 <vprintf+0x76>
  for(i = 0; fmt[i]; i++){
 5d0:	0485                	addi	s1,s1,1
 5d2:	fff4c903          	lbu	s2,-1(s1)
 5d6:	14090d63          	beqz	s2,730 <vprintf+0x1c0>
    if(state == 0){
 5da:	fe0999e3          	bnez	s3,5cc <vprintf+0x5c>
      if(c == '%'){
 5de:	ff4910e3          	bne	s2,s4,5be <vprintf+0x4e>
        state = '%';
 5e2:	89d2                	mv	s3,s4
 5e4:	b7f5                	j	5d0 <vprintf+0x60>
      if(c == 'd'){
 5e6:	11490c63          	beq	s2,s4,6fe <vprintf+0x18e>
 5ea:	f9d9079b          	addiw	a5,s2,-99
 5ee:	0ff7f793          	zext.b	a5,a5
 5f2:	10fc6e63          	bltu	s8,a5,70e <vprintf+0x19e>
 5f6:	f9d9079b          	addiw	a5,s2,-99
 5fa:	0ff7f713          	zext.b	a4,a5
 5fe:	10ec6863          	bltu	s8,a4,70e <vprintf+0x19e>
 602:	00271793          	slli	a5,a4,0x2
 606:	97e6                	add	a5,a5,s9
 608:	439c                	lw	a5,0(a5)
 60a:	97e6                	add	a5,a5,s9
 60c:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 60e:	008b0913          	addi	s2,s6,8
 612:	4685                	li	a3,1
 614:	4629                	li	a2,10
 616:	000b2583          	lw	a1,0(s6)
 61a:	8556                	mv	a0,s5
 61c:	00000097          	auipc	ra,0x0
 620:	ea8080e7          	jalr	-344(ra) # 4c4 <printint>
 624:	8b4a                	mv	s6,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 626:	4981                	li	s3,0
 628:	b765                	j	5d0 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 62a:	008b0913          	addi	s2,s6,8
 62e:	4681                	li	a3,0
 630:	4629                	li	a2,10
 632:	000b2583          	lw	a1,0(s6)
 636:	8556                	mv	a0,s5
 638:	00000097          	auipc	ra,0x0
 63c:	e8c080e7          	jalr	-372(ra) # 4c4 <printint>
 640:	8b4a                	mv	s6,s2
      state = 0;
 642:	4981                	li	s3,0
 644:	b771                	j	5d0 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 646:	008b0913          	addi	s2,s6,8
 64a:	4681                	li	a3,0
 64c:	866a                	mv	a2,s10
 64e:	000b2583          	lw	a1,0(s6)
 652:	8556                	mv	a0,s5
 654:	00000097          	auipc	ra,0x0
 658:	e70080e7          	jalr	-400(ra) # 4c4 <printint>
 65c:	8b4a                	mv	s6,s2
      state = 0;
 65e:	4981                	li	s3,0
 660:	bf85                	j	5d0 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 662:	008b0793          	addi	a5,s6,8
 666:	f8f43423          	sd	a5,-120(s0)
 66a:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 66e:	03000593          	li	a1,48
 672:	8556                	mv	a0,s5
 674:	00000097          	auipc	ra,0x0
 678:	e2e080e7          	jalr	-466(ra) # 4a2 <putc>
  putc(fd, 'x');
 67c:	07800593          	li	a1,120
 680:	8556                	mv	a0,s5
 682:	00000097          	auipc	ra,0x0
 686:	e20080e7          	jalr	-480(ra) # 4a2 <putc>
 68a:	896a                	mv	s2,s10
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 68c:	03c9d793          	srli	a5,s3,0x3c
 690:	97de                	add	a5,a5,s7
 692:	0007c583          	lbu	a1,0(a5)
 696:	8556                	mv	a0,s5
 698:	00000097          	auipc	ra,0x0
 69c:	e0a080e7          	jalr	-502(ra) # 4a2 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 6a0:	0992                	slli	s3,s3,0x4
 6a2:	397d                	addiw	s2,s2,-1
 6a4:	fe0914e3          	bnez	s2,68c <vprintf+0x11c>
        printptr(fd, va_arg(ap, uint64));
 6a8:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 6ac:	4981                	li	s3,0
 6ae:	b70d                	j	5d0 <vprintf+0x60>
        s = va_arg(ap, char*);
 6b0:	008b0913          	addi	s2,s6,8
 6b4:	000b3983          	ld	s3,0(s6)
        if(s == 0)
 6b8:	02098163          	beqz	s3,6da <vprintf+0x16a>
        while(*s != 0){
 6bc:	0009c583          	lbu	a1,0(s3)
 6c0:	c5ad                	beqz	a1,72a <vprintf+0x1ba>
          putc(fd, *s);
 6c2:	8556                	mv	a0,s5
 6c4:	00000097          	auipc	ra,0x0
 6c8:	dde080e7          	jalr	-546(ra) # 4a2 <putc>
          s++;
 6cc:	0985                	addi	s3,s3,1
        while(*s != 0){
 6ce:	0009c583          	lbu	a1,0(s3)
 6d2:	f9e5                	bnez	a1,6c2 <vprintf+0x152>
        s = va_arg(ap, char*);
 6d4:	8b4a                	mv	s6,s2
      state = 0;
 6d6:	4981                	li	s3,0
 6d8:	bde5                	j	5d0 <vprintf+0x60>
          s = "(null)";
 6da:	00000997          	auipc	s3,0x0
 6de:	28e98993          	addi	s3,s3,654 # 968 <malloc+0x134>
        while(*s != 0){
 6e2:	85ee                	mv	a1,s11
 6e4:	bff9                	j	6c2 <vprintf+0x152>
        putc(fd, va_arg(ap, uint));
 6e6:	008b0913          	addi	s2,s6,8
 6ea:	000b4583          	lbu	a1,0(s6)
 6ee:	8556                	mv	a0,s5
 6f0:	00000097          	auipc	ra,0x0
 6f4:	db2080e7          	jalr	-590(ra) # 4a2 <putc>
 6f8:	8b4a                	mv	s6,s2
      state = 0;
 6fa:	4981                	li	s3,0
 6fc:	bdd1                	j	5d0 <vprintf+0x60>
        putc(fd, c);
 6fe:	85d2                	mv	a1,s4
 700:	8556                	mv	a0,s5
 702:	00000097          	auipc	ra,0x0
 706:	da0080e7          	jalr	-608(ra) # 4a2 <putc>
      state = 0;
 70a:	4981                	li	s3,0
 70c:	b5d1                	j	5d0 <vprintf+0x60>
        putc(fd, '%');
 70e:	85d2                	mv	a1,s4
 710:	8556                	mv	a0,s5
 712:	00000097          	auipc	ra,0x0
 716:	d90080e7          	jalr	-624(ra) # 4a2 <putc>
        putc(fd, c);
 71a:	85ca                	mv	a1,s2
 71c:	8556                	mv	a0,s5
 71e:	00000097          	auipc	ra,0x0
 722:	d84080e7          	jalr	-636(ra) # 4a2 <putc>
      state = 0;
 726:	4981                	li	s3,0
 728:	b565                	j	5d0 <vprintf+0x60>
        s = va_arg(ap, char*);
 72a:	8b4a                	mv	s6,s2
      state = 0;
 72c:	4981                	li	s3,0
 72e:	b54d                	j	5d0 <vprintf+0x60>
    }
  }
}
 730:	70e6                	ld	ra,120(sp)
 732:	7446                	ld	s0,112(sp)
 734:	74a6                	ld	s1,104(sp)
 736:	7906                	ld	s2,96(sp)
 738:	69e6                	ld	s3,88(sp)
 73a:	6a46                	ld	s4,80(sp)
 73c:	6aa6                	ld	s5,72(sp)
 73e:	6b06                	ld	s6,64(sp)
 740:	7be2                	ld	s7,56(sp)
 742:	7c42                	ld	s8,48(sp)
 744:	7ca2                	ld	s9,40(sp)
 746:	7d02                	ld	s10,32(sp)
 748:	6de2                	ld	s11,24(sp)
 74a:	6109                	addi	sp,sp,128
 74c:	8082                	ret

000000000000074e <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 74e:	715d                	addi	sp,sp,-80
 750:	ec06                	sd	ra,24(sp)
 752:	e822                	sd	s0,16(sp)
 754:	1000                	addi	s0,sp,32
 756:	e010                	sd	a2,0(s0)
 758:	e414                	sd	a3,8(s0)
 75a:	e818                	sd	a4,16(s0)
 75c:	ec1c                	sd	a5,24(s0)
 75e:	03043023          	sd	a6,32(s0)
 762:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 766:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 76a:	8622                	mv	a2,s0
 76c:	00000097          	auipc	ra,0x0
 770:	e04080e7          	jalr	-508(ra) # 570 <vprintf>
}
 774:	60e2                	ld	ra,24(sp)
 776:	6442                	ld	s0,16(sp)
 778:	6161                	addi	sp,sp,80
 77a:	8082                	ret

000000000000077c <printf>:

void
printf(const char *fmt, ...)
{
 77c:	711d                	addi	sp,sp,-96
 77e:	ec06                	sd	ra,24(sp)
 780:	e822                	sd	s0,16(sp)
 782:	1000                	addi	s0,sp,32
 784:	e40c                	sd	a1,8(s0)
 786:	e810                	sd	a2,16(s0)
 788:	ec14                	sd	a3,24(s0)
 78a:	f018                	sd	a4,32(s0)
 78c:	f41c                	sd	a5,40(s0)
 78e:	03043823          	sd	a6,48(s0)
 792:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 796:	00840613          	addi	a2,s0,8
 79a:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 79e:	85aa                	mv	a1,a0
 7a0:	4505                	li	a0,1
 7a2:	00000097          	auipc	ra,0x0
 7a6:	dce080e7          	jalr	-562(ra) # 570 <vprintf>
}
 7aa:	60e2                	ld	ra,24(sp)
 7ac:	6442                	ld	s0,16(sp)
 7ae:	6125                	addi	sp,sp,96
 7b0:	8082                	ret

00000000000007b2 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 7b2:	1141                	addi	sp,sp,-16
 7b4:	e422                	sd	s0,8(sp)
 7b6:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 7b8:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7bc:	00000797          	auipc	a5,0x0
 7c0:	2247b783          	ld	a5,548(a5) # 9e0 <freep>
 7c4:	a02d                	j	7ee <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 7c6:	4618                	lw	a4,8(a2)
 7c8:	9f2d                	addw	a4,a4,a1
 7ca:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 7ce:	6398                	ld	a4,0(a5)
 7d0:	6310                	ld	a2,0(a4)
 7d2:	a83d                	j	810 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 7d4:	ff852703          	lw	a4,-8(a0)
 7d8:	9f31                	addw	a4,a4,a2
 7da:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 7dc:	ff053683          	ld	a3,-16(a0)
 7e0:	a091                	j	824 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7e2:	6398                	ld	a4,0(a5)
 7e4:	00e7e463          	bltu	a5,a4,7ec <free+0x3a>
 7e8:	00e6ea63          	bltu	a3,a4,7fc <free+0x4a>
{
 7ec:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7ee:	fed7fae3          	bgeu	a5,a3,7e2 <free+0x30>
 7f2:	6398                	ld	a4,0(a5)
 7f4:	00e6e463          	bltu	a3,a4,7fc <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7f8:	fee7eae3          	bltu	a5,a4,7ec <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 7fc:	ff852583          	lw	a1,-8(a0)
 800:	6390                	ld	a2,0(a5)
 802:	02059813          	slli	a6,a1,0x20
 806:	01c85713          	srli	a4,a6,0x1c
 80a:	9736                	add	a4,a4,a3
 80c:	fae60de3          	beq	a2,a4,7c6 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 810:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 814:	4790                	lw	a2,8(a5)
 816:	02061593          	slli	a1,a2,0x20
 81a:	01c5d713          	srli	a4,a1,0x1c
 81e:	973e                	add	a4,a4,a5
 820:	fae68ae3          	beq	a3,a4,7d4 <free+0x22>
    p->s.ptr = bp->s.ptr;
 824:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 826:	00000717          	auipc	a4,0x0
 82a:	1af73d23          	sd	a5,442(a4) # 9e0 <freep>
}
 82e:	6422                	ld	s0,8(sp)
 830:	0141                	addi	sp,sp,16
 832:	8082                	ret

0000000000000834 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 834:	7139                	addi	sp,sp,-64
 836:	fc06                	sd	ra,56(sp)
 838:	f822                	sd	s0,48(sp)
 83a:	f426                	sd	s1,40(sp)
 83c:	f04a                	sd	s2,32(sp)
 83e:	ec4e                	sd	s3,24(sp)
 840:	e852                	sd	s4,16(sp)
 842:	e456                	sd	s5,8(sp)
 844:	e05a                	sd	s6,0(sp)
 846:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 848:	02051493          	slli	s1,a0,0x20
 84c:	9081                	srli	s1,s1,0x20
 84e:	04bd                	addi	s1,s1,15
 850:	8091                	srli	s1,s1,0x4
 852:	0014899b          	addiw	s3,s1,1
 856:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 858:	00000517          	auipc	a0,0x0
 85c:	18853503          	ld	a0,392(a0) # 9e0 <freep>
 860:	c515                	beqz	a0,88c <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 862:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 864:	4798                	lw	a4,8(a5)
 866:	02977f63          	bgeu	a4,s1,8a4 <malloc+0x70>
 86a:	8a4e                	mv	s4,s3
 86c:	0009871b          	sext.w	a4,s3
 870:	6685                	lui	a3,0x1
 872:	00d77363          	bgeu	a4,a3,878 <malloc+0x44>
 876:	6a05                	lui	s4,0x1
 878:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 87c:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 880:	00000917          	auipc	s2,0x0
 884:	16090913          	addi	s2,s2,352 # 9e0 <freep>
  if(p == (char*)-1)
 888:	5afd                	li	s5,-1
 88a:	a895                	j	8fe <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
 88c:	00000797          	auipc	a5,0x0
 890:	35c78793          	addi	a5,a5,860 # be8 <base>
 894:	00000717          	auipc	a4,0x0
 898:	14f73623          	sd	a5,332(a4) # 9e0 <freep>
 89c:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 89e:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 8a2:	b7e1                	j	86a <malloc+0x36>
      if(p->s.size == nunits)
 8a4:	02e48c63          	beq	s1,a4,8dc <malloc+0xa8>
        p->s.size -= nunits;
 8a8:	4137073b          	subw	a4,a4,s3
 8ac:	c798                	sw	a4,8(a5)
        p += p->s.size;
 8ae:	02071693          	slli	a3,a4,0x20
 8b2:	01c6d713          	srli	a4,a3,0x1c
 8b6:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 8b8:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 8bc:	00000717          	auipc	a4,0x0
 8c0:	12a73223          	sd	a0,292(a4) # 9e0 <freep>
      return (void*)(p + 1);
 8c4:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 8c8:	70e2                	ld	ra,56(sp)
 8ca:	7442                	ld	s0,48(sp)
 8cc:	74a2                	ld	s1,40(sp)
 8ce:	7902                	ld	s2,32(sp)
 8d0:	69e2                	ld	s3,24(sp)
 8d2:	6a42                	ld	s4,16(sp)
 8d4:	6aa2                	ld	s5,8(sp)
 8d6:	6b02                	ld	s6,0(sp)
 8d8:	6121                	addi	sp,sp,64
 8da:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 8dc:	6398                	ld	a4,0(a5)
 8de:	e118                	sd	a4,0(a0)
 8e0:	bff1                	j	8bc <malloc+0x88>
  hp->s.size = nu;
 8e2:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 8e6:	0541                	addi	a0,a0,16
 8e8:	00000097          	auipc	ra,0x0
 8ec:	eca080e7          	jalr	-310(ra) # 7b2 <free>
  return freep;
 8f0:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 8f4:	d971                	beqz	a0,8c8 <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8f6:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 8f8:	4798                	lw	a4,8(a5)
 8fa:	fa9775e3          	bgeu	a4,s1,8a4 <malloc+0x70>
    if(p == freep)
 8fe:	00093703          	ld	a4,0(s2)
 902:	853e                	mv	a0,a5
 904:	fef719e3          	bne	a4,a5,8f6 <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
 908:	8552                	mv	a0,s4
 90a:	00000097          	auipc	ra,0x0
 90e:	b80080e7          	jalr	-1152(ra) # 48a <sbrk>
  if(p == (char*)-1)
 912:	fd5518e3          	bne	a0,s5,8e2 <malloc+0xae>
        return 0;
 916:	4501                	li	a0,0
 918:	bf45                	j	8c8 <malloc+0x94>
