
user/_usertests：     文件格式 elf64-littleriscv


Disassembly of section .text:

0000000000000000 <copyinstr1>:
}

// what if you pass ridiculous string pointers to system calls?
void
copyinstr1(char *s)
{
       0:	1141                	addi	sp,sp,-16
       2:	e406                	sd	ra,8(sp)
       4:	e022                	sd	s0,0(sp)
       6:	0800                	addi	s0,sp,16
  uint64 addrs[] = { 0x80000000LL, 0xffffffffffffffff };

  for(int ai = 0; ai < 2; ai++){
    uint64 addr = addrs[ai];

    int fd = open((char *)addr, O_CREATE|O_WRONLY);
       8:	20100593          	li	a1,513
       c:	4505                	li	a0,1
       e:	057e                	slli	a0,a0,0x1f
      10:	00005097          	auipc	ra,0x5
      14:	39a080e7          	jalr	922(ra) # 53aa <open>
    if(fd >= 0){
      18:	02055063          	bgez	a0,38 <copyinstr1+0x38>
    int fd = open((char *)addr, O_CREATE|O_WRONLY);
      1c:	20100593          	li	a1,513
      20:	557d                	li	a0,-1
      22:	00005097          	auipc	ra,0x5
      26:	388080e7          	jalr	904(ra) # 53aa <open>
    uint64 addr = addrs[ai];
      2a:	55fd                	li	a1,-1
    if(fd >= 0){
      2c:	00055863          	bgez	a0,3c <copyinstr1+0x3c>
      printf("open(%p) returned %d, not -1\n", addr, fd);
      exit(1);
    }
  }
}
      30:	60a2                	ld	ra,8(sp)
      32:	6402                	ld	s0,0(sp)
      34:	0141                	addi	sp,sp,16
      36:	8082                	ret
    uint64 addr = addrs[ai];
      38:	4585                	li	a1,1
      3a:	05fe                	slli	a1,a1,0x1f
      printf("open(%p) returned %d, not -1\n", addr, fd);
      3c:	862a                	mv	a2,a0
      3e:	00006517          	auipc	a0,0x6
      42:	84a50513          	addi	a0,a0,-1974 # 5888 <malloc+0xec>
      46:	00005097          	auipc	ra,0x5
      4a:	69e080e7          	jalr	1694(ra) # 56e4 <printf>
      exit(1);
      4e:	4505                	li	a0,1
      50:	00005097          	auipc	ra,0x5
      54:	31a080e7          	jalr	794(ra) # 536a <exit>

0000000000000058 <bsstest>:
void
bsstest(char *s)
{
  int i;

  for(i = 0; i < sizeof(uninit); i++){
      58:	00009797          	auipc	a5,0x9
      5c:	01878793          	addi	a5,a5,24 # 9070 <uninit>
      60:	0000b697          	auipc	a3,0xb
      64:	72068693          	addi	a3,a3,1824 # b780 <buf>
    if(uninit[i] != '\0'){
      68:	0007c703          	lbu	a4,0(a5)
      6c:	e709                	bnez	a4,76 <bsstest+0x1e>
  for(i = 0; i < sizeof(uninit); i++){
      6e:	0785                	addi	a5,a5,1
      70:	fed79ce3          	bne	a5,a3,68 <bsstest+0x10>
      74:	8082                	ret
{
      76:	1141                	addi	sp,sp,-16
      78:	e406                	sd	ra,8(sp)
      7a:	e022                	sd	s0,0(sp)
      7c:	0800                	addi	s0,sp,16
      printf("%s: bss test failed\n", s);
      7e:	85aa                	mv	a1,a0
      80:	00006517          	auipc	a0,0x6
      84:	82850513          	addi	a0,a0,-2008 # 58a8 <malloc+0x10c>
      88:	00005097          	auipc	ra,0x5
      8c:	65c080e7          	jalr	1628(ra) # 56e4 <printf>
      exit(1);
      90:	4505                	li	a0,1
      92:	00005097          	auipc	ra,0x5
      96:	2d8080e7          	jalr	728(ra) # 536a <exit>

000000000000009a <opentest>:
{
      9a:	1101                	addi	sp,sp,-32
      9c:	ec06                	sd	ra,24(sp)
      9e:	e822                	sd	s0,16(sp)
      a0:	e426                	sd	s1,8(sp)
      a2:	1000                	addi	s0,sp,32
      a4:	84aa                	mv	s1,a0
  fd = open("echo", 0);
      a6:	4581                	li	a1,0
      a8:	00006517          	auipc	a0,0x6
      ac:	81850513          	addi	a0,a0,-2024 # 58c0 <malloc+0x124>
      b0:	00005097          	auipc	ra,0x5
      b4:	2fa080e7          	jalr	762(ra) # 53aa <open>
  if(fd < 0){
      b8:	02054663          	bltz	a0,e4 <opentest+0x4a>
  close(fd);
      bc:	00005097          	auipc	ra,0x5
      c0:	2d6080e7          	jalr	726(ra) # 5392 <close>
  fd = open("doesnotexist", 0);
      c4:	4581                	li	a1,0
      c6:	00006517          	auipc	a0,0x6
      ca:	81a50513          	addi	a0,a0,-2022 # 58e0 <malloc+0x144>
      ce:	00005097          	auipc	ra,0x5
      d2:	2dc080e7          	jalr	732(ra) # 53aa <open>
  if(fd >= 0){
      d6:	02055563          	bgez	a0,100 <opentest+0x66>
}
      da:	60e2                	ld	ra,24(sp)
      dc:	6442                	ld	s0,16(sp)
      de:	64a2                	ld	s1,8(sp)
      e0:	6105                	addi	sp,sp,32
      e2:	8082                	ret
    printf("%s: open echo failed!\n", s);
      e4:	85a6                	mv	a1,s1
      e6:	00005517          	auipc	a0,0x5
      ea:	7e250513          	addi	a0,a0,2018 # 58c8 <malloc+0x12c>
      ee:	00005097          	auipc	ra,0x5
      f2:	5f6080e7          	jalr	1526(ra) # 56e4 <printf>
    exit(1);
      f6:	4505                	li	a0,1
      f8:	00005097          	auipc	ra,0x5
      fc:	272080e7          	jalr	626(ra) # 536a <exit>
    printf("%s: open doesnotexist succeeded!\n", s);
     100:	85a6                	mv	a1,s1
     102:	00005517          	auipc	a0,0x5
     106:	7ee50513          	addi	a0,a0,2030 # 58f0 <malloc+0x154>
     10a:	00005097          	auipc	ra,0x5
     10e:	5da080e7          	jalr	1498(ra) # 56e4 <printf>
    exit(1);
     112:	4505                	li	a0,1
     114:	00005097          	auipc	ra,0x5
     118:	256080e7          	jalr	598(ra) # 536a <exit>

000000000000011c <truncate2>:
{
     11c:	7179                	addi	sp,sp,-48
     11e:	f406                	sd	ra,40(sp)
     120:	f022                	sd	s0,32(sp)
     122:	ec26                	sd	s1,24(sp)
     124:	e84a                	sd	s2,16(sp)
     126:	e44e                	sd	s3,8(sp)
     128:	1800                	addi	s0,sp,48
     12a:	89aa                	mv	s3,a0
  unlink("truncfile");
     12c:	00005517          	auipc	a0,0x5
     130:	7ec50513          	addi	a0,a0,2028 # 5918 <malloc+0x17c>
     134:	00005097          	auipc	ra,0x5
     138:	286080e7          	jalr	646(ra) # 53ba <unlink>
  int fd1 = open("truncfile", O_CREATE|O_TRUNC|O_WRONLY);
     13c:	60100593          	li	a1,1537
     140:	00005517          	auipc	a0,0x5
     144:	7d850513          	addi	a0,a0,2008 # 5918 <malloc+0x17c>
     148:	00005097          	auipc	ra,0x5
     14c:	262080e7          	jalr	610(ra) # 53aa <open>
     150:	84aa                	mv	s1,a0
  write(fd1, "abcd", 4);
     152:	4611                	li	a2,4
     154:	00005597          	auipc	a1,0x5
     158:	7d458593          	addi	a1,a1,2004 # 5928 <malloc+0x18c>
     15c:	00005097          	auipc	ra,0x5
     160:	22e080e7          	jalr	558(ra) # 538a <write>
  int fd2 = open("truncfile", O_TRUNC|O_WRONLY);
     164:	40100593          	li	a1,1025
     168:	00005517          	auipc	a0,0x5
     16c:	7b050513          	addi	a0,a0,1968 # 5918 <malloc+0x17c>
     170:	00005097          	auipc	ra,0x5
     174:	23a080e7          	jalr	570(ra) # 53aa <open>
     178:	892a                	mv	s2,a0
  int n = write(fd1, "x", 1);
     17a:	4605                	li	a2,1
     17c:	00005597          	auipc	a1,0x5
     180:	7b458593          	addi	a1,a1,1972 # 5930 <malloc+0x194>
     184:	8526                	mv	a0,s1
     186:	00005097          	auipc	ra,0x5
     18a:	204080e7          	jalr	516(ra) # 538a <write>
  if(n != -1){
     18e:	57fd                	li	a5,-1
     190:	02f51b63          	bne	a0,a5,1c6 <truncate2+0xaa>
  unlink("truncfile");
     194:	00005517          	auipc	a0,0x5
     198:	78450513          	addi	a0,a0,1924 # 5918 <malloc+0x17c>
     19c:	00005097          	auipc	ra,0x5
     1a0:	21e080e7          	jalr	542(ra) # 53ba <unlink>
  close(fd1);
     1a4:	8526                	mv	a0,s1
     1a6:	00005097          	auipc	ra,0x5
     1aa:	1ec080e7          	jalr	492(ra) # 5392 <close>
  close(fd2);
     1ae:	854a                	mv	a0,s2
     1b0:	00005097          	auipc	ra,0x5
     1b4:	1e2080e7          	jalr	482(ra) # 5392 <close>
}
     1b8:	70a2                	ld	ra,40(sp)
     1ba:	7402                	ld	s0,32(sp)
     1bc:	64e2                	ld	s1,24(sp)
     1be:	6942                	ld	s2,16(sp)
     1c0:	69a2                	ld	s3,8(sp)
     1c2:	6145                	addi	sp,sp,48
     1c4:	8082                	ret
    printf("%s: write returned %d, expected -1\n", s, n);
     1c6:	862a                	mv	a2,a0
     1c8:	85ce                	mv	a1,s3
     1ca:	00005517          	auipc	a0,0x5
     1ce:	76e50513          	addi	a0,a0,1902 # 5938 <malloc+0x19c>
     1d2:	00005097          	auipc	ra,0x5
     1d6:	512080e7          	jalr	1298(ra) # 56e4 <printf>
    exit(1);
     1da:	4505                	li	a0,1
     1dc:	00005097          	auipc	ra,0x5
     1e0:	18e080e7          	jalr	398(ra) # 536a <exit>

00000000000001e4 <createtest>:
{
     1e4:	7179                	addi	sp,sp,-48
     1e6:	f406                	sd	ra,40(sp)
     1e8:	f022                	sd	s0,32(sp)
     1ea:	ec26                	sd	s1,24(sp)
     1ec:	e84a                	sd	s2,16(sp)
     1ee:	e44e                	sd	s3,8(sp)
     1f0:	1800                	addi	s0,sp,48
  name[0] = 'a';
     1f2:	00008797          	auipc	a5,0x8
     1f6:	d6678793          	addi	a5,a5,-666 # 7f58 <name>
     1fa:	06100713          	li	a4,97
     1fe:	00e78023          	sb	a4,0(a5)
  name[2] = '\0';
     202:	00078123          	sb	zero,2(a5)
     206:	03000493          	li	s1,48
    name[1] = '0' + i;
     20a:	893e                	mv	s2,a5
  for(i = 0; i < N; i++){
     20c:	06400993          	li	s3,100
    name[1] = '0' + i;
     210:	009900a3          	sb	s1,1(s2)
    fd = open(name, O_CREATE|O_RDWR);
     214:	20200593          	li	a1,514
     218:	854a                	mv	a0,s2
     21a:	00005097          	auipc	ra,0x5
     21e:	190080e7          	jalr	400(ra) # 53aa <open>
    close(fd);
     222:	00005097          	auipc	ra,0x5
     226:	170080e7          	jalr	368(ra) # 5392 <close>
  for(i = 0; i < N; i++){
     22a:	2485                	addiw	s1,s1,1
     22c:	0ff4f493          	zext.b	s1,s1
     230:	ff3490e3          	bne	s1,s3,210 <createtest+0x2c>
  name[0] = 'a';
     234:	00008797          	auipc	a5,0x8
     238:	d2478793          	addi	a5,a5,-732 # 7f58 <name>
     23c:	06100713          	li	a4,97
     240:	00e78023          	sb	a4,0(a5)
  name[2] = '\0';
     244:	00078123          	sb	zero,2(a5)
     248:	03000493          	li	s1,48
    name[1] = '0' + i;
     24c:	893e                	mv	s2,a5
  for(i = 0; i < N; i++){
     24e:	06400993          	li	s3,100
    name[1] = '0' + i;
     252:	009900a3          	sb	s1,1(s2)
    unlink(name);
     256:	854a                	mv	a0,s2
     258:	00005097          	auipc	ra,0x5
     25c:	162080e7          	jalr	354(ra) # 53ba <unlink>
  for(i = 0; i < N; i++){
     260:	2485                	addiw	s1,s1,1
     262:	0ff4f493          	zext.b	s1,s1
     266:	ff3496e3          	bne	s1,s3,252 <createtest+0x6e>
}
     26a:	70a2                	ld	ra,40(sp)
     26c:	7402                	ld	s0,32(sp)
     26e:	64e2                	ld	s1,24(sp)
     270:	6942                	ld	s2,16(sp)
     272:	69a2                	ld	s3,8(sp)
     274:	6145                	addi	sp,sp,48
     276:	8082                	ret

0000000000000278 <bigwrite>:
{
     278:	715d                	addi	sp,sp,-80
     27a:	e486                	sd	ra,72(sp)
     27c:	e0a2                	sd	s0,64(sp)
     27e:	fc26                	sd	s1,56(sp)
     280:	f84a                	sd	s2,48(sp)
     282:	f44e                	sd	s3,40(sp)
     284:	f052                	sd	s4,32(sp)
     286:	ec56                	sd	s5,24(sp)
     288:	e85a                	sd	s6,16(sp)
     28a:	e45e                	sd	s7,8(sp)
     28c:	0880                	addi	s0,sp,80
     28e:	8baa                	mv	s7,a0
  unlink("bigwrite");
     290:	00005517          	auipc	a0,0x5
     294:	6d050513          	addi	a0,a0,1744 # 5960 <malloc+0x1c4>
     298:	00005097          	auipc	ra,0x5
     29c:	122080e7          	jalr	290(ra) # 53ba <unlink>
  for(sz = 499; sz < (MAXOPBLOCKS+2)*BSIZE; sz += 471){
     2a0:	1f300493          	li	s1,499
    fd = open("bigwrite", O_CREATE | O_RDWR);
     2a4:	00005a97          	auipc	s5,0x5
     2a8:	6bca8a93          	addi	s5,s5,1724 # 5960 <malloc+0x1c4>
      int cc = write(fd, buf, sz);
     2ac:	0000ba17          	auipc	s4,0xb
     2b0:	4d4a0a13          	addi	s4,s4,1236 # b780 <buf>
  for(sz = 499; sz < (MAXOPBLOCKS+2)*BSIZE; sz += 471){
     2b4:	6b0d                	lui	s6,0x3
     2b6:	1c9b0b13          	addi	s6,s6,457 # 31c9 <subdir+0x4f3>
    fd = open("bigwrite", O_CREATE | O_RDWR);
     2ba:	20200593          	li	a1,514
     2be:	8556                	mv	a0,s5
     2c0:	00005097          	auipc	ra,0x5
     2c4:	0ea080e7          	jalr	234(ra) # 53aa <open>
     2c8:	892a                	mv	s2,a0
    if(fd < 0){
     2ca:	04054d63          	bltz	a0,324 <bigwrite+0xac>
      int cc = write(fd, buf, sz);
     2ce:	8626                	mv	a2,s1
     2d0:	85d2                	mv	a1,s4
     2d2:	00005097          	auipc	ra,0x5
     2d6:	0b8080e7          	jalr	184(ra) # 538a <write>
     2da:	89aa                	mv	s3,a0
      if(cc != sz){
     2dc:	06a49263          	bne	s1,a0,340 <bigwrite+0xc8>
      int cc = write(fd, buf, sz);
     2e0:	8626                	mv	a2,s1
     2e2:	85d2                	mv	a1,s4
     2e4:	854a                	mv	a0,s2
     2e6:	00005097          	auipc	ra,0x5
     2ea:	0a4080e7          	jalr	164(ra) # 538a <write>
      if(cc != sz){
     2ee:	04951a63          	bne	a0,s1,342 <bigwrite+0xca>
    close(fd);
     2f2:	854a                	mv	a0,s2
     2f4:	00005097          	auipc	ra,0x5
     2f8:	09e080e7          	jalr	158(ra) # 5392 <close>
    unlink("bigwrite");
     2fc:	8556                	mv	a0,s5
     2fe:	00005097          	auipc	ra,0x5
     302:	0bc080e7          	jalr	188(ra) # 53ba <unlink>
  for(sz = 499; sz < (MAXOPBLOCKS+2)*BSIZE; sz += 471){
     306:	1d74849b          	addiw	s1,s1,471
     30a:	fb6498e3          	bne	s1,s6,2ba <bigwrite+0x42>
}
     30e:	60a6                	ld	ra,72(sp)
     310:	6406                	ld	s0,64(sp)
     312:	74e2                	ld	s1,56(sp)
     314:	7942                	ld	s2,48(sp)
     316:	79a2                	ld	s3,40(sp)
     318:	7a02                	ld	s4,32(sp)
     31a:	6ae2                	ld	s5,24(sp)
     31c:	6b42                	ld	s6,16(sp)
     31e:	6ba2                	ld	s7,8(sp)
     320:	6161                	addi	sp,sp,80
     322:	8082                	ret
      printf("%s: cannot create bigwrite\n", s);
     324:	85de                	mv	a1,s7
     326:	00005517          	auipc	a0,0x5
     32a:	64a50513          	addi	a0,a0,1610 # 5970 <malloc+0x1d4>
     32e:	00005097          	auipc	ra,0x5
     332:	3b6080e7          	jalr	950(ra) # 56e4 <printf>
      exit(1);
     336:	4505                	li	a0,1
     338:	00005097          	auipc	ra,0x5
     33c:	032080e7          	jalr	50(ra) # 536a <exit>
      if(cc != sz){
     340:	89a6                	mv	s3,s1
        printf("%s: write(%d) ret %d\n", s, sz, cc);
     342:	86aa                	mv	a3,a0
     344:	864e                	mv	a2,s3
     346:	85de                	mv	a1,s7
     348:	00005517          	auipc	a0,0x5
     34c:	64850513          	addi	a0,a0,1608 # 5990 <malloc+0x1f4>
     350:	00005097          	auipc	ra,0x5
     354:	394080e7          	jalr	916(ra) # 56e4 <printf>
        exit(1);
     358:	4505                	li	a0,1
     35a:	00005097          	auipc	ra,0x5
     35e:	010080e7          	jalr	16(ra) # 536a <exit>

0000000000000362 <copyin>:
{
     362:	715d                	addi	sp,sp,-80
     364:	e486                	sd	ra,72(sp)
     366:	e0a2                	sd	s0,64(sp)
     368:	fc26                	sd	s1,56(sp)
     36a:	f84a                	sd	s2,48(sp)
     36c:	f44e                	sd	s3,40(sp)
     36e:	f052                	sd	s4,32(sp)
     370:	0880                	addi	s0,sp,80
  uint64 addrs[] = { 0x80000000LL, 0xffffffffffffffff };
     372:	4785                	li	a5,1
     374:	07fe                	slli	a5,a5,0x1f
     376:	fcf43023          	sd	a5,-64(s0)
     37a:	57fd                	li	a5,-1
     37c:	fcf43423          	sd	a5,-56(s0)
  for(int ai = 0; ai < 2; ai++){
     380:	fc040913          	addi	s2,s0,-64
    int fd = open("copyin1", O_CREATE|O_WRONLY);
     384:	00005a17          	auipc	s4,0x5
     388:	624a0a13          	addi	s4,s4,1572 # 59a8 <malloc+0x20c>
    uint64 addr = addrs[ai];
     38c:	00093983          	ld	s3,0(s2)
    int fd = open("copyin1", O_CREATE|O_WRONLY);
     390:	20100593          	li	a1,513
     394:	8552                	mv	a0,s4
     396:	00005097          	auipc	ra,0x5
     39a:	014080e7          	jalr	20(ra) # 53aa <open>
     39e:	84aa                	mv	s1,a0
    if(fd < 0){
     3a0:	08054863          	bltz	a0,430 <copyin+0xce>
    int n = write(fd, (void*)addr, 8192);
     3a4:	6609                	lui	a2,0x2
     3a6:	85ce                	mv	a1,s3
     3a8:	00005097          	auipc	ra,0x5
     3ac:	fe2080e7          	jalr	-30(ra) # 538a <write>
    if(n >= 0){
     3b0:	08055d63          	bgez	a0,44a <copyin+0xe8>
    close(fd);
     3b4:	8526                	mv	a0,s1
     3b6:	00005097          	auipc	ra,0x5
     3ba:	fdc080e7          	jalr	-36(ra) # 5392 <close>
    unlink("copyin1");
     3be:	8552                	mv	a0,s4
     3c0:	00005097          	auipc	ra,0x5
     3c4:	ffa080e7          	jalr	-6(ra) # 53ba <unlink>
    n = write(1, (char*)addr, 8192);
     3c8:	6609                	lui	a2,0x2
     3ca:	85ce                	mv	a1,s3
     3cc:	4505                	li	a0,1
     3ce:	00005097          	auipc	ra,0x5
     3d2:	fbc080e7          	jalr	-68(ra) # 538a <write>
    if(n > 0){
     3d6:	08a04963          	bgtz	a0,468 <copyin+0x106>
    if(pipe(fds) < 0){
     3da:	fb840513          	addi	a0,s0,-72
     3de:	00005097          	auipc	ra,0x5
     3e2:	f9c080e7          	jalr	-100(ra) # 537a <pipe>
     3e6:	0a054063          	bltz	a0,486 <copyin+0x124>
    n = write(fds[1], (char*)addr, 8192);
     3ea:	6609                	lui	a2,0x2
     3ec:	85ce                	mv	a1,s3
     3ee:	fbc42503          	lw	a0,-68(s0)
     3f2:	00005097          	auipc	ra,0x5
     3f6:	f98080e7          	jalr	-104(ra) # 538a <write>
    if(n > 0){
     3fa:	0aa04363          	bgtz	a0,4a0 <copyin+0x13e>
    close(fds[0]);
     3fe:	fb842503          	lw	a0,-72(s0)
     402:	00005097          	auipc	ra,0x5
     406:	f90080e7          	jalr	-112(ra) # 5392 <close>
    close(fds[1]);
     40a:	fbc42503          	lw	a0,-68(s0)
     40e:	00005097          	auipc	ra,0x5
     412:	f84080e7          	jalr	-124(ra) # 5392 <close>
  for(int ai = 0; ai < 2; ai++){
     416:	0921                	addi	s2,s2,8
     418:	fd040793          	addi	a5,s0,-48
     41c:	f6f918e3          	bne	s2,a5,38c <copyin+0x2a>
}
     420:	60a6                	ld	ra,72(sp)
     422:	6406                	ld	s0,64(sp)
     424:	74e2                	ld	s1,56(sp)
     426:	7942                	ld	s2,48(sp)
     428:	79a2                	ld	s3,40(sp)
     42a:	7a02                	ld	s4,32(sp)
     42c:	6161                	addi	sp,sp,80
     42e:	8082                	ret
      printf("open(copyin1) failed\n");
     430:	00005517          	auipc	a0,0x5
     434:	58050513          	addi	a0,a0,1408 # 59b0 <malloc+0x214>
     438:	00005097          	auipc	ra,0x5
     43c:	2ac080e7          	jalr	684(ra) # 56e4 <printf>
      exit(1);
     440:	4505                	li	a0,1
     442:	00005097          	auipc	ra,0x5
     446:	f28080e7          	jalr	-216(ra) # 536a <exit>
      printf("write(fd, %p, 8192) returned %d, not -1\n", addr, n);
     44a:	862a                	mv	a2,a0
     44c:	85ce                	mv	a1,s3
     44e:	00005517          	auipc	a0,0x5
     452:	57a50513          	addi	a0,a0,1402 # 59c8 <malloc+0x22c>
     456:	00005097          	auipc	ra,0x5
     45a:	28e080e7          	jalr	654(ra) # 56e4 <printf>
      exit(1);
     45e:	4505                	li	a0,1
     460:	00005097          	auipc	ra,0x5
     464:	f0a080e7          	jalr	-246(ra) # 536a <exit>
      printf("write(1, %p, 8192) returned %d, not -1 or 0\n", addr, n);
     468:	862a                	mv	a2,a0
     46a:	85ce                	mv	a1,s3
     46c:	00005517          	auipc	a0,0x5
     470:	58c50513          	addi	a0,a0,1420 # 59f8 <malloc+0x25c>
     474:	00005097          	auipc	ra,0x5
     478:	270080e7          	jalr	624(ra) # 56e4 <printf>
      exit(1);
     47c:	4505                	li	a0,1
     47e:	00005097          	auipc	ra,0x5
     482:	eec080e7          	jalr	-276(ra) # 536a <exit>
      printf("pipe() failed\n");
     486:	00005517          	auipc	a0,0x5
     48a:	5a250513          	addi	a0,a0,1442 # 5a28 <malloc+0x28c>
     48e:	00005097          	auipc	ra,0x5
     492:	256080e7          	jalr	598(ra) # 56e4 <printf>
      exit(1);
     496:	4505                	li	a0,1
     498:	00005097          	auipc	ra,0x5
     49c:	ed2080e7          	jalr	-302(ra) # 536a <exit>
      printf("write(pipe, %p, 8192) returned %d, not -1 or 0\n", addr, n);
     4a0:	862a                	mv	a2,a0
     4a2:	85ce                	mv	a1,s3
     4a4:	00005517          	auipc	a0,0x5
     4a8:	59450513          	addi	a0,a0,1428 # 5a38 <malloc+0x29c>
     4ac:	00005097          	auipc	ra,0x5
     4b0:	238080e7          	jalr	568(ra) # 56e4 <printf>
      exit(1);
     4b4:	4505                	li	a0,1
     4b6:	00005097          	auipc	ra,0x5
     4ba:	eb4080e7          	jalr	-332(ra) # 536a <exit>

00000000000004be <copyout>:
{
     4be:	711d                	addi	sp,sp,-96
     4c0:	ec86                	sd	ra,88(sp)
     4c2:	e8a2                	sd	s0,80(sp)
     4c4:	e4a6                	sd	s1,72(sp)
     4c6:	e0ca                	sd	s2,64(sp)
     4c8:	fc4e                	sd	s3,56(sp)
     4ca:	f852                	sd	s4,48(sp)
     4cc:	f456                	sd	s5,40(sp)
     4ce:	1080                	addi	s0,sp,96
  uint64 addrs[] = { 0x80000000LL, 0xffffffffffffffff };
     4d0:	4785                	li	a5,1
     4d2:	07fe                	slli	a5,a5,0x1f
     4d4:	faf43823          	sd	a5,-80(s0)
     4d8:	57fd                	li	a5,-1
     4da:	faf43c23          	sd	a5,-72(s0)
  for(int ai = 0; ai < 2; ai++){
     4de:	fb040913          	addi	s2,s0,-80
    int fd = open("README", 0);
     4e2:	00005a17          	auipc	s4,0x5
     4e6:	586a0a13          	addi	s4,s4,1414 # 5a68 <malloc+0x2cc>
    n = write(fds[1], "x", 1);
     4ea:	00005a97          	auipc	s5,0x5
     4ee:	446a8a93          	addi	s5,s5,1094 # 5930 <malloc+0x194>
    uint64 addr = addrs[ai];
     4f2:	00093983          	ld	s3,0(s2)
    int fd = open("README", 0);
     4f6:	4581                	li	a1,0
     4f8:	8552                	mv	a0,s4
     4fa:	00005097          	auipc	ra,0x5
     4fe:	eb0080e7          	jalr	-336(ra) # 53aa <open>
     502:	84aa                	mv	s1,a0
    if(fd < 0){
     504:	08054663          	bltz	a0,590 <copyout+0xd2>
    int n = read(fd, (void*)addr, 8192);
     508:	6609                	lui	a2,0x2
     50a:	85ce                	mv	a1,s3
     50c:	00005097          	auipc	ra,0x5
     510:	e76080e7          	jalr	-394(ra) # 5382 <read>
    if(n > 0){
     514:	08a04b63          	bgtz	a0,5aa <copyout+0xec>
    close(fd);
     518:	8526                	mv	a0,s1
     51a:	00005097          	auipc	ra,0x5
     51e:	e78080e7          	jalr	-392(ra) # 5392 <close>
    if(pipe(fds) < 0){
     522:	fa840513          	addi	a0,s0,-88
     526:	00005097          	auipc	ra,0x5
     52a:	e54080e7          	jalr	-428(ra) # 537a <pipe>
     52e:	08054d63          	bltz	a0,5c8 <copyout+0x10a>
    n = write(fds[1], "x", 1);
     532:	4605                	li	a2,1
     534:	85d6                	mv	a1,s5
     536:	fac42503          	lw	a0,-84(s0)
     53a:	00005097          	auipc	ra,0x5
     53e:	e50080e7          	jalr	-432(ra) # 538a <write>
    if(n != 1){
     542:	4785                	li	a5,1
     544:	08f51f63          	bne	a0,a5,5e2 <copyout+0x124>
    n = read(fds[0], (void*)addr, 8192);
     548:	6609                	lui	a2,0x2
     54a:	85ce                	mv	a1,s3
     54c:	fa842503          	lw	a0,-88(s0)
     550:	00005097          	auipc	ra,0x5
     554:	e32080e7          	jalr	-462(ra) # 5382 <read>
    if(n > 0){
     558:	0aa04263          	bgtz	a0,5fc <copyout+0x13e>
    close(fds[0]);
     55c:	fa842503          	lw	a0,-88(s0)
     560:	00005097          	auipc	ra,0x5
     564:	e32080e7          	jalr	-462(ra) # 5392 <close>
    close(fds[1]);
     568:	fac42503          	lw	a0,-84(s0)
     56c:	00005097          	auipc	ra,0x5
     570:	e26080e7          	jalr	-474(ra) # 5392 <close>
  for(int ai = 0; ai < 2; ai++){
     574:	0921                	addi	s2,s2,8
     576:	fc040793          	addi	a5,s0,-64
     57a:	f6f91ce3          	bne	s2,a5,4f2 <copyout+0x34>
}
     57e:	60e6                	ld	ra,88(sp)
     580:	6446                	ld	s0,80(sp)
     582:	64a6                	ld	s1,72(sp)
     584:	6906                	ld	s2,64(sp)
     586:	79e2                	ld	s3,56(sp)
     588:	7a42                	ld	s4,48(sp)
     58a:	7aa2                	ld	s5,40(sp)
     58c:	6125                	addi	sp,sp,96
     58e:	8082                	ret
      printf("open(README) failed\n");
     590:	00005517          	auipc	a0,0x5
     594:	4e050513          	addi	a0,a0,1248 # 5a70 <malloc+0x2d4>
     598:	00005097          	auipc	ra,0x5
     59c:	14c080e7          	jalr	332(ra) # 56e4 <printf>
      exit(1);
     5a0:	4505                	li	a0,1
     5a2:	00005097          	auipc	ra,0x5
     5a6:	dc8080e7          	jalr	-568(ra) # 536a <exit>
      printf("read(fd, %p, 8192) returned %d, not -1 or 0\n", addr, n);
     5aa:	862a                	mv	a2,a0
     5ac:	85ce                	mv	a1,s3
     5ae:	00005517          	auipc	a0,0x5
     5b2:	4da50513          	addi	a0,a0,1242 # 5a88 <malloc+0x2ec>
     5b6:	00005097          	auipc	ra,0x5
     5ba:	12e080e7          	jalr	302(ra) # 56e4 <printf>
      exit(1);
     5be:	4505                	li	a0,1
     5c0:	00005097          	auipc	ra,0x5
     5c4:	daa080e7          	jalr	-598(ra) # 536a <exit>
      printf("pipe() failed\n");
     5c8:	00005517          	auipc	a0,0x5
     5cc:	46050513          	addi	a0,a0,1120 # 5a28 <malloc+0x28c>
     5d0:	00005097          	auipc	ra,0x5
     5d4:	114080e7          	jalr	276(ra) # 56e4 <printf>
      exit(1);
     5d8:	4505                	li	a0,1
     5da:	00005097          	auipc	ra,0x5
     5de:	d90080e7          	jalr	-624(ra) # 536a <exit>
      printf("pipe write failed\n");
     5e2:	00005517          	auipc	a0,0x5
     5e6:	4d650513          	addi	a0,a0,1238 # 5ab8 <malloc+0x31c>
     5ea:	00005097          	auipc	ra,0x5
     5ee:	0fa080e7          	jalr	250(ra) # 56e4 <printf>
      exit(1);
     5f2:	4505                	li	a0,1
     5f4:	00005097          	auipc	ra,0x5
     5f8:	d76080e7          	jalr	-650(ra) # 536a <exit>
      printf("read(pipe, %p, 8192) returned %d, not -1 or 0\n", addr, n);
     5fc:	862a                	mv	a2,a0
     5fe:	85ce                	mv	a1,s3
     600:	00005517          	auipc	a0,0x5
     604:	4d050513          	addi	a0,a0,1232 # 5ad0 <malloc+0x334>
     608:	00005097          	auipc	ra,0x5
     60c:	0dc080e7          	jalr	220(ra) # 56e4 <printf>
      exit(1);
     610:	4505                	li	a0,1
     612:	00005097          	auipc	ra,0x5
     616:	d58080e7          	jalr	-680(ra) # 536a <exit>

000000000000061a <truncate1>:
{
     61a:	711d                	addi	sp,sp,-96
     61c:	ec86                	sd	ra,88(sp)
     61e:	e8a2                	sd	s0,80(sp)
     620:	e4a6                	sd	s1,72(sp)
     622:	e0ca                	sd	s2,64(sp)
     624:	fc4e                	sd	s3,56(sp)
     626:	f852                	sd	s4,48(sp)
     628:	f456                	sd	s5,40(sp)
     62a:	1080                	addi	s0,sp,96
     62c:	8aaa                	mv	s5,a0
  unlink("truncfile");
     62e:	00005517          	auipc	a0,0x5
     632:	2ea50513          	addi	a0,a0,746 # 5918 <malloc+0x17c>
     636:	00005097          	auipc	ra,0x5
     63a:	d84080e7          	jalr	-636(ra) # 53ba <unlink>
  int fd1 = open("truncfile", O_CREATE|O_WRONLY|O_TRUNC);
     63e:	60100593          	li	a1,1537
     642:	00005517          	auipc	a0,0x5
     646:	2d650513          	addi	a0,a0,726 # 5918 <malloc+0x17c>
     64a:	00005097          	auipc	ra,0x5
     64e:	d60080e7          	jalr	-672(ra) # 53aa <open>
     652:	84aa                	mv	s1,a0
  write(fd1, "abcd", 4);
     654:	4611                	li	a2,4
     656:	00005597          	auipc	a1,0x5
     65a:	2d258593          	addi	a1,a1,722 # 5928 <malloc+0x18c>
     65e:	00005097          	auipc	ra,0x5
     662:	d2c080e7          	jalr	-724(ra) # 538a <write>
  close(fd1);
     666:	8526                	mv	a0,s1
     668:	00005097          	auipc	ra,0x5
     66c:	d2a080e7          	jalr	-726(ra) # 5392 <close>
  int fd2 = open("truncfile", O_RDONLY);
     670:	4581                	li	a1,0
     672:	00005517          	auipc	a0,0x5
     676:	2a650513          	addi	a0,a0,678 # 5918 <malloc+0x17c>
     67a:	00005097          	auipc	ra,0x5
     67e:	d30080e7          	jalr	-720(ra) # 53aa <open>
     682:	84aa                	mv	s1,a0
  int n = read(fd2, buf, sizeof(buf));
     684:	02000613          	li	a2,32
     688:	fa040593          	addi	a1,s0,-96
     68c:	00005097          	auipc	ra,0x5
     690:	cf6080e7          	jalr	-778(ra) # 5382 <read>
  if(n != 4){
     694:	4791                	li	a5,4
     696:	0cf51e63          	bne	a0,a5,772 <truncate1+0x158>
  fd1 = open("truncfile", O_WRONLY|O_TRUNC);
     69a:	40100593          	li	a1,1025
     69e:	00005517          	auipc	a0,0x5
     6a2:	27a50513          	addi	a0,a0,634 # 5918 <malloc+0x17c>
     6a6:	00005097          	auipc	ra,0x5
     6aa:	d04080e7          	jalr	-764(ra) # 53aa <open>
     6ae:	89aa                	mv	s3,a0
  int fd3 = open("truncfile", O_RDONLY);
     6b0:	4581                	li	a1,0
     6b2:	00005517          	auipc	a0,0x5
     6b6:	26650513          	addi	a0,a0,614 # 5918 <malloc+0x17c>
     6ba:	00005097          	auipc	ra,0x5
     6be:	cf0080e7          	jalr	-784(ra) # 53aa <open>
     6c2:	892a                	mv	s2,a0
  n = read(fd3, buf, sizeof(buf));
     6c4:	02000613          	li	a2,32
     6c8:	fa040593          	addi	a1,s0,-96
     6cc:	00005097          	auipc	ra,0x5
     6d0:	cb6080e7          	jalr	-842(ra) # 5382 <read>
     6d4:	8a2a                	mv	s4,a0
  if(n != 0){
     6d6:	ed4d                	bnez	a0,790 <truncate1+0x176>
  n = read(fd2, buf, sizeof(buf));
     6d8:	02000613          	li	a2,32
     6dc:	fa040593          	addi	a1,s0,-96
     6e0:	8526                	mv	a0,s1
     6e2:	00005097          	auipc	ra,0x5
     6e6:	ca0080e7          	jalr	-864(ra) # 5382 <read>
     6ea:	8a2a                	mv	s4,a0
  if(n != 0){
     6ec:	e971                	bnez	a0,7c0 <truncate1+0x1a6>
  write(fd1, "abcdef", 6);
     6ee:	4619                	li	a2,6
     6f0:	00005597          	auipc	a1,0x5
     6f4:	47058593          	addi	a1,a1,1136 # 5b60 <malloc+0x3c4>
     6f8:	854e                	mv	a0,s3
     6fa:	00005097          	auipc	ra,0x5
     6fe:	c90080e7          	jalr	-880(ra) # 538a <write>
  n = read(fd3, buf, sizeof(buf));
     702:	02000613          	li	a2,32
     706:	fa040593          	addi	a1,s0,-96
     70a:	854a                	mv	a0,s2
     70c:	00005097          	auipc	ra,0x5
     710:	c76080e7          	jalr	-906(ra) # 5382 <read>
  if(n != 6){
     714:	4799                	li	a5,6
     716:	0cf51d63          	bne	a0,a5,7f0 <truncate1+0x1d6>
  n = read(fd2, buf, sizeof(buf));
     71a:	02000613          	li	a2,32
     71e:	fa040593          	addi	a1,s0,-96
     722:	8526                	mv	a0,s1
     724:	00005097          	auipc	ra,0x5
     728:	c5e080e7          	jalr	-930(ra) # 5382 <read>
  if(n != 2){
     72c:	4789                	li	a5,2
     72e:	0ef51063          	bne	a0,a5,80e <truncate1+0x1f4>
  unlink("truncfile");
     732:	00005517          	auipc	a0,0x5
     736:	1e650513          	addi	a0,a0,486 # 5918 <malloc+0x17c>
     73a:	00005097          	auipc	ra,0x5
     73e:	c80080e7          	jalr	-896(ra) # 53ba <unlink>
  close(fd1);
     742:	854e                	mv	a0,s3
     744:	00005097          	auipc	ra,0x5
     748:	c4e080e7          	jalr	-946(ra) # 5392 <close>
  close(fd2);
     74c:	8526                	mv	a0,s1
     74e:	00005097          	auipc	ra,0x5
     752:	c44080e7          	jalr	-956(ra) # 5392 <close>
  close(fd3);
     756:	854a                	mv	a0,s2
     758:	00005097          	auipc	ra,0x5
     75c:	c3a080e7          	jalr	-966(ra) # 5392 <close>
}
     760:	60e6                	ld	ra,88(sp)
     762:	6446                	ld	s0,80(sp)
     764:	64a6                	ld	s1,72(sp)
     766:	6906                	ld	s2,64(sp)
     768:	79e2                	ld	s3,56(sp)
     76a:	7a42                	ld	s4,48(sp)
     76c:	7aa2                	ld	s5,40(sp)
     76e:	6125                	addi	sp,sp,96
     770:	8082                	ret
    printf("%s: read %d bytes, wanted 4\n", s, n);
     772:	862a                	mv	a2,a0
     774:	85d6                	mv	a1,s5
     776:	00005517          	auipc	a0,0x5
     77a:	38a50513          	addi	a0,a0,906 # 5b00 <malloc+0x364>
     77e:	00005097          	auipc	ra,0x5
     782:	f66080e7          	jalr	-154(ra) # 56e4 <printf>
    exit(1);
     786:	4505                	li	a0,1
     788:	00005097          	auipc	ra,0x5
     78c:	be2080e7          	jalr	-1054(ra) # 536a <exit>
    printf("aaa fd3=%d\n", fd3);
     790:	85ca                	mv	a1,s2
     792:	00005517          	auipc	a0,0x5
     796:	38e50513          	addi	a0,a0,910 # 5b20 <malloc+0x384>
     79a:	00005097          	auipc	ra,0x5
     79e:	f4a080e7          	jalr	-182(ra) # 56e4 <printf>
    printf("%s: read %d bytes, wanted 0\n", s, n);
     7a2:	8652                	mv	a2,s4
     7a4:	85d6                	mv	a1,s5
     7a6:	00005517          	auipc	a0,0x5
     7aa:	38a50513          	addi	a0,a0,906 # 5b30 <malloc+0x394>
     7ae:	00005097          	auipc	ra,0x5
     7b2:	f36080e7          	jalr	-202(ra) # 56e4 <printf>
    exit(1);
     7b6:	4505                	li	a0,1
     7b8:	00005097          	auipc	ra,0x5
     7bc:	bb2080e7          	jalr	-1102(ra) # 536a <exit>
    printf("bbb fd2=%d\n", fd2);
     7c0:	85a6                	mv	a1,s1
     7c2:	00005517          	auipc	a0,0x5
     7c6:	38e50513          	addi	a0,a0,910 # 5b50 <malloc+0x3b4>
     7ca:	00005097          	auipc	ra,0x5
     7ce:	f1a080e7          	jalr	-230(ra) # 56e4 <printf>
    printf("%s: read %d bytes, wanted 0\n", s, n);
     7d2:	8652                	mv	a2,s4
     7d4:	85d6                	mv	a1,s5
     7d6:	00005517          	auipc	a0,0x5
     7da:	35a50513          	addi	a0,a0,858 # 5b30 <malloc+0x394>
     7de:	00005097          	auipc	ra,0x5
     7e2:	f06080e7          	jalr	-250(ra) # 56e4 <printf>
    exit(1);
     7e6:	4505                	li	a0,1
     7e8:	00005097          	auipc	ra,0x5
     7ec:	b82080e7          	jalr	-1150(ra) # 536a <exit>
    printf("%s: read %d bytes, wanted 6\n", s, n);
     7f0:	862a                	mv	a2,a0
     7f2:	85d6                	mv	a1,s5
     7f4:	00005517          	auipc	a0,0x5
     7f8:	37450513          	addi	a0,a0,884 # 5b68 <malloc+0x3cc>
     7fc:	00005097          	auipc	ra,0x5
     800:	ee8080e7          	jalr	-280(ra) # 56e4 <printf>
    exit(1);
     804:	4505                	li	a0,1
     806:	00005097          	auipc	ra,0x5
     80a:	b64080e7          	jalr	-1180(ra) # 536a <exit>
    printf("%s: read %d bytes, wanted 2\n", s, n);
     80e:	862a                	mv	a2,a0
     810:	85d6                	mv	a1,s5
     812:	00005517          	auipc	a0,0x5
     816:	37650513          	addi	a0,a0,886 # 5b88 <malloc+0x3ec>
     81a:	00005097          	auipc	ra,0x5
     81e:	eca080e7          	jalr	-310(ra) # 56e4 <printf>
    exit(1);
     822:	4505                	li	a0,1
     824:	00005097          	auipc	ra,0x5
     828:	b46080e7          	jalr	-1210(ra) # 536a <exit>

000000000000082c <writetest>:
{
     82c:	7139                	addi	sp,sp,-64
     82e:	fc06                	sd	ra,56(sp)
     830:	f822                	sd	s0,48(sp)
     832:	f426                	sd	s1,40(sp)
     834:	f04a                	sd	s2,32(sp)
     836:	ec4e                	sd	s3,24(sp)
     838:	e852                	sd	s4,16(sp)
     83a:	e456                	sd	s5,8(sp)
     83c:	e05a                	sd	s6,0(sp)
     83e:	0080                	addi	s0,sp,64
     840:	8b2a                	mv	s6,a0
  fd = open("small", O_CREATE|O_RDWR);
     842:	20200593          	li	a1,514
     846:	00005517          	auipc	a0,0x5
     84a:	36250513          	addi	a0,a0,866 # 5ba8 <malloc+0x40c>
     84e:	00005097          	auipc	ra,0x5
     852:	b5c080e7          	jalr	-1188(ra) # 53aa <open>
  if(fd < 0){
     856:	0a054d63          	bltz	a0,910 <writetest+0xe4>
     85a:	892a                	mv	s2,a0
     85c:	4481                	li	s1,0
    if(write(fd, "aaaaaaaaaa", SZ) != SZ){
     85e:	00005997          	auipc	s3,0x5
     862:	37298993          	addi	s3,s3,882 # 5bd0 <malloc+0x434>
    if(write(fd, "bbbbbbbbbb", SZ) != SZ){
     866:	00005a97          	auipc	s5,0x5
     86a:	3a2a8a93          	addi	s5,s5,930 # 5c08 <malloc+0x46c>
  for(i = 0; i < N; i++){
     86e:	06400a13          	li	s4,100
    if(write(fd, "aaaaaaaaaa", SZ) != SZ){
     872:	4629                	li	a2,10
     874:	85ce                	mv	a1,s3
     876:	854a                	mv	a0,s2
     878:	00005097          	auipc	ra,0x5
     87c:	b12080e7          	jalr	-1262(ra) # 538a <write>
     880:	47a9                	li	a5,10
     882:	0af51563          	bne	a0,a5,92c <writetest+0x100>
    if(write(fd, "bbbbbbbbbb", SZ) != SZ){
     886:	4629                	li	a2,10
     888:	85d6                	mv	a1,s5
     88a:	854a                	mv	a0,s2
     88c:	00005097          	auipc	ra,0x5
     890:	afe080e7          	jalr	-1282(ra) # 538a <write>
     894:	47a9                	li	a5,10
     896:	0af51963          	bne	a0,a5,948 <writetest+0x11c>
  for(i = 0; i < N; i++){
     89a:	2485                	addiw	s1,s1,1
     89c:	fd449be3          	bne	s1,s4,872 <writetest+0x46>
  close(fd);
     8a0:	854a                	mv	a0,s2
     8a2:	00005097          	auipc	ra,0x5
     8a6:	af0080e7          	jalr	-1296(ra) # 5392 <close>
  fd = open("small", O_RDONLY);
     8aa:	4581                	li	a1,0
     8ac:	00005517          	auipc	a0,0x5
     8b0:	2fc50513          	addi	a0,a0,764 # 5ba8 <malloc+0x40c>
     8b4:	00005097          	auipc	ra,0x5
     8b8:	af6080e7          	jalr	-1290(ra) # 53aa <open>
     8bc:	84aa                	mv	s1,a0
  if(fd < 0){
     8be:	0a054363          	bltz	a0,964 <writetest+0x138>
  i = read(fd, buf, N*SZ*2);
     8c2:	7d000613          	li	a2,2000
     8c6:	0000b597          	auipc	a1,0xb
     8ca:	eba58593          	addi	a1,a1,-326 # b780 <buf>
     8ce:	00005097          	auipc	ra,0x5
     8d2:	ab4080e7          	jalr	-1356(ra) # 5382 <read>
  if(i != N*SZ*2){
     8d6:	7d000793          	li	a5,2000
     8da:	0af51363          	bne	a0,a5,980 <writetest+0x154>
  close(fd);
     8de:	8526                	mv	a0,s1
     8e0:	00005097          	auipc	ra,0x5
     8e4:	ab2080e7          	jalr	-1358(ra) # 5392 <close>
  if(unlink("small") < 0){
     8e8:	00005517          	auipc	a0,0x5
     8ec:	2c050513          	addi	a0,a0,704 # 5ba8 <malloc+0x40c>
     8f0:	00005097          	auipc	ra,0x5
     8f4:	aca080e7          	jalr	-1334(ra) # 53ba <unlink>
     8f8:	0a054263          	bltz	a0,99c <writetest+0x170>
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
    printf("%s: error: creat small failed!\n", s);
     910:	85da                	mv	a1,s6
     912:	00005517          	auipc	a0,0x5
     916:	29e50513          	addi	a0,a0,670 # 5bb0 <malloc+0x414>
     91a:	00005097          	auipc	ra,0x5
     91e:	dca080e7          	jalr	-566(ra) # 56e4 <printf>
    exit(1);
     922:	4505                	li	a0,1
     924:	00005097          	auipc	ra,0x5
     928:	a46080e7          	jalr	-1466(ra) # 536a <exit>
      printf("%s: error: write aa %d new file failed\n", i);
     92c:	85a6                	mv	a1,s1
     92e:	00005517          	auipc	a0,0x5
     932:	2b250513          	addi	a0,a0,690 # 5be0 <malloc+0x444>
     936:	00005097          	auipc	ra,0x5
     93a:	dae080e7          	jalr	-594(ra) # 56e4 <printf>
      exit(1);
     93e:	4505                	li	a0,1
     940:	00005097          	auipc	ra,0x5
     944:	a2a080e7          	jalr	-1494(ra) # 536a <exit>
      printf("%s: error: write bb %d new file failed\n", i);
     948:	85a6                	mv	a1,s1
     94a:	00005517          	auipc	a0,0x5
     94e:	2ce50513          	addi	a0,a0,718 # 5c18 <malloc+0x47c>
     952:	00005097          	auipc	ra,0x5
     956:	d92080e7          	jalr	-622(ra) # 56e4 <printf>
      exit(1);
     95a:	4505                	li	a0,1
     95c:	00005097          	auipc	ra,0x5
     960:	a0e080e7          	jalr	-1522(ra) # 536a <exit>
    printf("%s: error: open small failed!\n", s);
     964:	85da                	mv	a1,s6
     966:	00005517          	auipc	a0,0x5
     96a:	2da50513          	addi	a0,a0,730 # 5c40 <malloc+0x4a4>
     96e:	00005097          	auipc	ra,0x5
     972:	d76080e7          	jalr	-650(ra) # 56e4 <printf>
    exit(1);
     976:	4505                	li	a0,1
     978:	00005097          	auipc	ra,0x5
     97c:	9f2080e7          	jalr	-1550(ra) # 536a <exit>
    printf("%s: read failed\n", s);
     980:	85da                	mv	a1,s6
     982:	00005517          	auipc	a0,0x5
     986:	2de50513          	addi	a0,a0,734 # 5c60 <malloc+0x4c4>
     98a:	00005097          	auipc	ra,0x5
     98e:	d5a080e7          	jalr	-678(ra) # 56e4 <printf>
    exit(1);
     992:	4505                	li	a0,1
     994:	00005097          	auipc	ra,0x5
     998:	9d6080e7          	jalr	-1578(ra) # 536a <exit>
    printf("%s: unlink small failed\n", s);
     99c:	85da                	mv	a1,s6
     99e:	00005517          	auipc	a0,0x5
     9a2:	2da50513          	addi	a0,a0,730 # 5c78 <malloc+0x4dc>
     9a6:	00005097          	auipc	ra,0x5
     9aa:	d3e080e7          	jalr	-706(ra) # 56e4 <printf>
    exit(1);
     9ae:	4505                	li	a0,1
     9b0:	00005097          	auipc	ra,0x5
     9b4:	9ba080e7          	jalr	-1606(ra) # 536a <exit>

00000000000009b8 <writebig>:
{
     9b8:	7139                	addi	sp,sp,-64
     9ba:	fc06                	sd	ra,56(sp)
     9bc:	f822                	sd	s0,48(sp)
     9be:	f426                	sd	s1,40(sp)
     9c0:	f04a                	sd	s2,32(sp)
     9c2:	ec4e                	sd	s3,24(sp)
     9c4:	e852                	sd	s4,16(sp)
     9c6:	e456                	sd	s5,8(sp)
     9c8:	0080                	addi	s0,sp,64
     9ca:	8aaa                	mv	s5,a0
  fd = open("big", O_CREATE|O_RDWR);
     9cc:	20200593          	li	a1,514
     9d0:	00005517          	auipc	a0,0x5
     9d4:	2c850513          	addi	a0,a0,712 # 5c98 <malloc+0x4fc>
     9d8:	00005097          	auipc	ra,0x5
     9dc:	9d2080e7          	jalr	-1582(ra) # 53aa <open>
     9e0:	89aa                	mv	s3,a0
  for(i = 0; i < MAXFILE; i++){
     9e2:	4481                	li	s1,0
    ((int*)buf)[0] = i;
     9e4:	0000b917          	auipc	s2,0xb
     9e8:	d9c90913          	addi	s2,s2,-612 # b780 <buf>
  for(i = 0; i < MAXFILE; i++){
     9ec:	10c00a13          	li	s4,268
  if(fd < 0){
     9f0:	06054c63          	bltz	a0,a68 <writebig+0xb0>
    ((int*)buf)[0] = i;
     9f4:	00992023          	sw	s1,0(s2)
    if(write(fd, buf, BSIZE) != BSIZE){
     9f8:	40000613          	li	a2,1024
     9fc:	85ca                	mv	a1,s2
     9fe:	854e                	mv	a0,s3
     a00:	00005097          	auipc	ra,0x5
     a04:	98a080e7          	jalr	-1654(ra) # 538a <write>
     a08:	40000793          	li	a5,1024
     a0c:	06f51c63          	bne	a0,a5,a84 <writebig+0xcc>
  for(i = 0; i < MAXFILE; i++){
     a10:	2485                	addiw	s1,s1,1
     a12:	ff4491e3          	bne	s1,s4,9f4 <writebig+0x3c>
  close(fd);
     a16:	854e                	mv	a0,s3
     a18:	00005097          	auipc	ra,0x5
     a1c:	97a080e7          	jalr	-1670(ra) # 5392 <close>
  fd = open("big", O_RDONLY);
     a20:	4581                	li	a1,0
     a22:	00005517          	auipc	a0,0x5
     a26:	27650513          	addi	a0,a0,630 # 5c98 <malloc+0x4fc>
     a2a:	00005097          	auipc	ra,0x5
     a2e:	980080e7          	jalr	-1664(ra) # 53aa <open>
     a32:	89aa                	mv	s3,a0
  n = 0;
     a34:	4481                	li	s1,0
    i = read(fd, buf, BSIZE);
     a36:	0000b917          	auipc	s2,0xb
     a3a:	d4a90913          	addi	s2,s2,-694 # b780 <buf>
  if(fd < 0){
     a3e:	06054163          	bltz	a0,aa0 <writebig+0xe8>
    i = read(fd, buf, BSIZE);
     a42:	40000613          	li	a2,1024
     a46:	85ca                	mv	a1,s2
     a48:	854e                	mv	a0,s3
     a4a:	00005097          	auipc	ra,0x5
     a4e:	938080e7          	jalr	-1736(ra) # 5382 <read>
    if(i == 0){
     a52:	c52d                	beqz	a0,abc <writebig+0x104>
    } else if(i != BSIZE){
     a54:	40000793          	li	a5,1024
     a58:	0af51d63          	bne	a0,a5,b12 <writebig+0x15a>
    if(((int*)buf)[0] != n){
     a5c:	00092603          	lw	a2,0(s2)
     a60:	0c961763          	bne	a2,s1,b2e <writebig+0x176>
    n++;
     a64:	2485                	addiw	s1,s1,1
    i = read(fd, buf, BSIZE);
     a66:	bff1                	j	a42 <writebig+0x8a>
    printf("%s: error: creat big failed!\n", s);
     a68:	85d6                	mv	a1,s5
     a6a:	00005517          	auipc	a0,0x5
     a6e:	23650513          	addi	a0,a0,566 # 5ca0 <malloc+0x504>
     a72:	00005097          	auipc	ra,0x5
     a76:	c72080e7          	jalr	-910(ra) # 56e4 <printf>
    exit(1);
     a7a:	4505                	li	a0,1
     a7c:	00005097          	auipc	ra,0x5
     a80:	8ee080e7          	jalr	-1810(ra) # 536a <exit>
      printf("%s: error: write big file failed\n", i);
     a84:	85a6                	mv	a1,s1
     a86:	00005517          	auipc	a0,0x5
     a8a:	23a50513          	addi	a0,a0,570 # 5cc0 <malloc+0x524>
     a8e:	00005097          	auipc	ra,0x5
     a92:	c56080e7          	jalr	-938(ra) # 56e4 <printf>
      exit(1);
     a96:	4505                	li	a0,1
     a98:	00005097          	auipc	ra,0x5
     a9c:	8d2080e7          	jalr	-1838(ra) # 536a <exit>
    printf("%s: error: open big failed!\n", s);
     aa0:	85d6                	mv	a1,s5
     aa2:	00005517          	auipc	a0,0x5
     aa6:	24650513          	addi	a0,a0,582 # 5ce8 <malloc+0x54c>
     aaa:	00005097          	auipc	ra,0x5
     aae:	c3a080e7          	jalr	-966(ra) # 56e4 <printf>
    exit(1);
     ab2:	4505                	li	a0,1
     ab4:	00005097          	auipc	ra,0x5
     ab8:	8b6080e7          	jalr	-1866(ra) # 536a <exit>
      if(n == MAXFILE - 1){
     abc:	10b00793          	li	a5,267
     ac0:	02f48a63          	beq	s1,a5,af4 <writebig+0x13c>
  close(fd);
     ac4:	854e                	mv	a0,s3
     ac6:	00005097          	auipc	ra,0x5
     aca:	8cc080e7          	jalr	-1844(ra) # 5392 <close>
  if(unlink("big") < 0){
     ace:	00005517          	auipc	a0,0x5
     ad2:	1ca50513          	addi	a0,a0,458 # 5c98 <malloc+0x4fc>
     ad6:	00005097          	auipc	ra,0x5
     ada:	8e4080e7          	jalr	-1820(ra) # 53ba <unlink>
     ade:	06054663          	bltz	a0,b4a <writebig+0x192>
}
     ae2:	70e2                	ld	ra,56(sp)
     ae4:	7442                	ld	s0,48(sp)
     ae6:	74a2                	ld	s1,40(sp)
     ae8:	7902                	ld	s2,32(sp)
     aea:	69e2                	ld	s3,24(sp)
     aec:	6a42                	ld	s4,16(sp)
     aee:	6aa2                	ld	s5,8(sp)
     af0:	6121                	addi	sp,sp,64
     af2:	8082                	ret
        printf("%s: read only %d blocks from big", n);
     af4:	10b00593          	li	a1,267
     af8:	00005517          	auipc	a0,0x5
     afc:	21050513          	addi	a0,a0,528 # 5d08 <malloc+0x56c>
     b00:	00005097          	auipc	ra,0x5
     b04:	be4080e7          	jalr	-1052(ra) # 56e4 <printf>
        exit(1);
     b08:	4505                	li	a0,1
     b0a:	00005097          	auipc	ra,0x5
     b0e:	860080e7          	jalr	-1952(ra) # 536a <exit>
      printf("%s: read failed %d\n", i);
     b12:	85aa                	mv	a1,a0
     b14:	00005517          	auipc	a0,0x5
     b18:	21c50513          	addi	a0,a0,540 # 5d30 <malloc+0x594>
     b1c:	00005097          	auipc	ra,0x5
     b20:	bc8080e7          	jalr	-1080(ra) # 56e4 <printf>
      exit(1);
     b24:	4505                	li	a0,1
     b26:	00005097          	auipc	ra,0x5
     b2a:	844080e7          	jalr	-1980(ra) # 536a <exit>
      printf("%s: read content of block %d is %d\n",
     b2e:	85a6                	mv	a1,s1
     b30:	00005517          	auipc	a0,0x5
     b34:	21850513          	addi	a0,a0,536 # 5d48 <malloc+0x5ac>
     b38:	00005097          	auipc	ra,0x5
     b3c:	bac080e7          	jalr	-1108(ra) # 56e4 <printf>
      exit(1);
     b40:	4505                	li	a0,1
     b42:	00005097          	auipc	ra,0x5
     b46:	828080e7          	jalr	-2008(ra) # 536a <exit>
    printf("%s: unlink big failed\n", s);
     b4a:	85d6                	mv	a1,s5
     b4c:	00005517          	auipc	a0,0x5
     b50:	22450513          	addi	a0,a0,548 # 5d70 <malloc+0x5d4>
     b54:	00005097          	auipc	ra,0x5
     b58:	b90080e7          	jalr	-1136(ra) # 56e4 <printf>
    exit(1);
     b5c:	4505                	li	a0,1
     b5e:	00005097          	auipc	ra,0x5
     b62:	80c080e7          	jalr	-2036(ra) # 536a <exit>

0000000000000b66 <unlinkread>:
{
     b66:	7179                	addi	sp,sp,-48
     b68:	f406                	sd	ra,40(sp)
     b6a:	f022                	sd	s0,32(sp)
     b6c:	ec26                	sd	s1,24(sp)
     b6e:	e84a                	sd	s2,16(sp)
     b70:	e44e                	sd	s3,8(sp)
     b72:	1800                	addi	s0,sp,48
     b74:	89aa                	mv	s3,a0
  fd = open("unlinkread", O_CREATE | O_RDWR);
     b76:	20200593          	li	a1,514
     b7a:	00005517          	auipc	a0,0x5
     b7e:	20e50513          	addi	a0,a0,526 # 5d88 <malloc+0x5ec>
     b82:	00005097          	auipc	ra,0x5
     b86:	828080e7          	jalr	-2008(ra) # 53aa <open>
  if(fd < 0){
     b8a:	0e054563          	bltz	a0,c74 <unlinkread+0x10e>
     b8e:	84aa                	mv	s1,a0
  write(fd, "hello", SZ);
     b90:	4615                	li	a2,5
     b92:	00005597          	auipc	a1,0x5
     b96:	22658593          	addi	a1,a1,550 # 5db8 <malloc+0x61c>
     b9a:	00004097          	auipc	ra,0x4
     b9e:	7f0080e7          	jalr	2032(ra) # 538a <write>
  close(fd);
     ba2:	8526                	mv	a0,s1
     ba4:	00004097          	auipc	ra,0x4
     ba8:	7ee080e7          	jalr	2030(ra) # 5392 <close>
  fd = open("unlinkread", O_RDWR);
     bac:	4589                	li	a1,2
     bae:	00005517          	auipc	a0,0x5
     bb2:	1da50513          	addi	a0,a0,474 # 5d88 <malloc+0x5ec>
     bb6:	00004097          	auipc	ra,0x4
     bba:	7f4080e7          	jalr	2036(ra) # 53aa <open>
     bbe:	84aa                	mv	s1,a0
  if(fd < 0){
     bc0:	0c054863          	bltz	a0,c90 <unlinkread+0x12a>
  if(unlink("unlinkread") != 0){
     bc4:	00005517          	auipc	a0,0x5
     bc8:	1c450513          	addi	a0,a0,452 # 5d88 <malloc+0x5ec>
     bcc:	00004097          	auipc	ra,0x4
     bd0:	7ee080e7          	jalr	2030(ra) # 53ba <unlink>
     bd4:	ed61                	bnez	a0,cac <unlinkread+0x146>
  fd1 = open("unlinkread", O_CREATE | O_RDWR);
     bd6:	20200593          	li	a1,514
     bda:	00005517          	auipc	a0,0x5
     bde:	1ae50513          	addi	a0,a0,430 # 5d88 <malloc+0x5ec>
     be2:	00004097          	auipc	ra,0x4
     be6:	7c8080e7          	jalr	1992(ra) # 53aa <open>
     bea:	892a                	mv	s2,a0
  write(fd1, "yyy", 3);
     bec:	460d                	li	a2,3
     bee:	00005597          	auipc	a1,0x5
     bf2:	21258593          	addi	a1,a1,530 # 5e00 <malloc+0x664>
     bf6:	00004097          	auipc	ra,0x4
     bfa:	794080e7          	jalr	1940(ra) # 538a <write>
  close(fd1);
     bfe:	854a                	mv	a0,s2
     c00:	00004097          	auipc	ra,0x4
     c04:	792080e7          	jalr	1938(ra) # 5392 <close>
  if(read(fd, buf, sizeof(buf)) != SZ){
     c08:	660d                	lui	a2,0x3
     c0a:	0000b597          	auipc	a1,0xb
     c0e:	b7658593          	addi	a1,a1,-1162 # b780 <buf>
     c12:	8526                	mv	a0,s1
     c14:	00004097          	auipc	ra,0x4
     c18:	76e080e7          	jalr	1902(ra) # 5382 <read>
     c1c:	4795                	li	a5,5
     c1e:	0af51563          	bne	a0,a5,cc8 <unlinkread+0x162>
  if(buf[0] != 'h'){
     c22:	0000b717          	auipc	a4,0xb
     c26:	b5e74703          	lbu	a4,-1186(a4) # b780 <buf>
     c2a:	06800793          	li	a5,104
     c2e:	0af71b63          	bne	a4,a5,ce4 <unlinkread+0x17e>
  if(write(fd, buf, 10) != 10){
     c32:	4629                	li	a2,10
     c34:	0000b597          	auipc	a1,0xb
     c38:	b4c58593          	addi	a1,a1,-1204 # b780 <buf>
     c3c:	8526                	mv	a0,s1
     c3e:	00004097          	auipc	ra,0x4
     c42:	74c080e7          	jalr	1868(ra) # 538a <write>
     c46:	47a9                	li	a5,10
     c48:	0af51c63          	bne	a0,a5,d00 <unlinkread+0x19a>
  close(fd);
     c4c:	8526                	mv	a0,s1
     c4e:	00004097          	auipc	ra,0x4
     c52:	744080e7          	jalr	1860(ra) # 5392 <close>
  unlink("unlinkread");
     c56:	00005517          	auipc	a0,0x5
     c5a:	13250513          	addi	a0,a0,306 # 5d88 <malloc+0x5ec>
     c5e:	00004097          	auipc	ra,0x4
     c62:	75c080e7          	jalr	1884(ra) # 53ba <unlink>
}
     c66:	70a2                	ld	ra,40(sp)
     c68:	7402                	ld	s0,32(sp)
     c6a:	64e2                	ld	s1,24(sp)
     c6c:	6942                	ld	s2,16(sp)
     c6e:	69a2                	ld	s3,8(sp)
     c70:	6145                	addi	sp,sp,48
     c72:	8082                	ret
    printf("%s: create unlinkread failed\n", s);
     c74:	85ce                	mv	a1,s3
     c76:	00005517          	auipc	a0,0x5
     c7a:	12250513          	addi	a0,a0,290 # 5d98 <malloc+0x5fc>
     c7e:	00005097          	auipc	ra,0x5
     c82:	a66080e7          	jalr	-1434(ra) # 56e4 <printf>
    exit(1);
     c86:	4505                	li	a0,1
     c88:	00004097          	auipc	ra,0x4
     c8c:	6e2080e7          	jalr	1762(ra) # 536a <exit>
    printf("%s: open unlinkread failed\n", s);
     c90:	85ce                	mv	a1,s3
     c92:	00005517          	auipc	a0,0x5
     c96:	12e50513          	addi	a0,a0,302 # 5dc0 <malloc+0x624>
     c9a:	00005097          	auipc	ra,0x5
     c9e:	a4a080e7          	jalr	-1462(ra) # 56e4 <printf>
    exit(1);
     ca2:	4505                	li	a0,1
     ca4:	00004097          	auipc	ra,0x4
     ca8:	6c6080e7          	jalr	1734(ra) # 536a <exit>
    printf("%s: unlink unlinkread failed\n", s);
     cac:	85ce                	mv	a1,s3
     cae:	00005517          	auipc	a0,0x5
     cb2:	13250513          	addi	a0,a0,306 # 5de0 <malloc+0x644>
     cb6:	00005097          	auipc	ra,0x5
     cba:	a2e080e7          	jalr	-1490(ra) # 56e4 <printf>
    exit(1);
     cbe:	4505                	li	a0,1
     cc0:	00004097          	auipc	ra,0x4
     cc4:	6aa080e7          	jalr	1706(ra) # 536a <exit>
    printf("%s: unlinkread read failed", s);
     cc8:	85ce                	mv	a1,s3
     cca:	00005517          	auipc	a0,0x5
     cce:	13e50513          	addi	a0,a0,318 # 5e08 <malloc+0x66c>
     cd2:	00005097          	auipc	ra,0x5
     cd6:	a12080e7          	jalr	-1518(ra) # 56e4 <printf>
    exit(1);
     cda:	4505                	li	a0,1
     cdc:	00004097          	auipc	ra,0x4
     ce0:	68e080e7          	jalr	1678(ra) # 536a <exit>
    printf("%s: unlinkread wrong data\n", s);
     ce4:	85ce                	mv	a1,s3
     ce6:	00005517          	auipc	a0,0x5
     cea:	14250513          	addi	a0,a0,322 # 5e28 <malloc+0x68c>
     cee:	00005097          	auipc	ra,0x5
     cf2:	9f6080e7          	jalr	-1546(ra) # 56e4 <printf>
    exit(1);
     cf6:	4505                	li	a0,1
     cf8:	00004097          	auipc	ra,0x4
     cfc:	672080e7          	jalr	1650(ra) # 536a <exit>
    printf("%s: unlinkread write failed\n", s);
     d00:	85ce                	mv	a1,s3
     d02:	00005517          	auipc	a0,0x5
     d06:	14650513          	addi	a0,a0,326 # 5e48 <malloc+0x6ac>
     d0a:	00005097          	auipc	ra,0x5
     d0e:	9da080e7          	jalr	-1574(ra) # 56e4 <printf>
    exit(1);
     d12:	4505                	li	a0,1
     d14:	00004097          	auipc	ra,0x4
     d18:	656080e7          	jalr	1622(ra) # 536a <exit>

0000000000000d1c <linktest>:
{
     d1c:	1101                	addi	sp,sp,-32
     d1e:	ec06                	sd	ra,24(sp)
     d20:	e822                	sd	s0,16(sp)
     d22:	e426                	sd	s1,8(sp)
     d24:	e04a                	sd	s2,0(sp)
     d26:	1000                	addi	s0,sp,32
     d28:	892a                	mv	s2,a0
  unlink("lf1");
     d2a:	00005517          	auipc	a0,0x5
     d2e:	13e50513          	addi	a0,a0,318 # 5e68 <malloc+0x6cc>
     d32:	00004097          	auipc	ra,0x4
     d36:	688080e7          	jalr	1672(ra) # 53ba <unlink>
  unlink("lf2");
     d3a:	00005517          	auipc	a0,0x5
     d3e:	13650513          	addi	a0,a0,310 # 5e70 <malloc+0x6d4>
     d42:	00004097          	auipc	ra,0x4
     d46:	678080e7          	jalr	1656(ra) # 53ba <unlink>
  fd = open("lf1", O_CREATE|O_RDWR);
     d4a:	20200593          	li	a1,514
     d4e:	00005517          	auipc	a0,0x5
     d52:	11a50513          	addi	a0,a0,282 # 5e68 <malloc+0x6cc>
     d56:	00004097          	auipc	ra,0x4
     d5a:	654080e7          	jalr	1620(ra) # 53aa <open>
  if(fd < 0){
     d5e:	10054763          	bltz	a0,e6c <linktest+0x150>
     d62:	84aa                	mv	s1,a0
  if(write(fd, "hello", SZ) != SZ){
     d64:	4615                	li	a2,5
     d66:	00005597          	auipc	a1,0x5
     d6a:	05258593          	addi	a1,a1,82 # 5db8 <malloc+0x61c>
     d6e:	00004097          	auipc	ra,0x4
     d72:	61c080e7          	jalr	1564(ra) # 538a <write>
     d76:	4795                	li	a5,5
     d78:	10f51863          	bne	a0,a5,e88 <linktest+0x16c>
  close(fd);
     d7c:	8526                	mv	a0,s1
     d7e:	00004097          	auipc	ra,0x4
     d82:	614080e7          	jalr	1556(ra) # 5392 <close>
  if(link("lf1", "lf2") < 0){
     d86:	00005597          	auipc	a1,0x5
     d8a:	0ea58593          	addi	a1,a1,234 # 5e70 <malloc+0x6d4>
     d8e:	00005517          	auipc	a0,0x5
     d92:	0da50513          	addi	a0,a0,218 # 5e68 <malloc+0x6cc>
     d96:	00004097          	auipc	ra,0x4
     d9a:	634080e7          	jalr	1588(ra) # 53ca <link>
     d9e:	10054363          	bltz	a0,ea4 <linktest+0x188>
  unlink("lf1");
     da2:	00005517          	auipc	a0,0x5
     da6:	0c650513          	addi	a0,a0,198 # 5e68 <malloc+0x6cc>
     daa:	00004097          	auipc	ra,0x4
     dae:	610080e7          	jalr	1552(ra) # 53ba <unlink>
  if(open("lf1", 0) >= 0){
     db2:	4581                	li	a1,0
     db4:	00005517          	auipc	a0,0x5
     db8:	0b450513          	addi	a0,a0,180 # 5e68 <malloc+0x6cc>
     dbc:	00004097          	auipc	ra,0x4
     dc0:	5ee080e7          	jalr	1518(ra) # 53aa <open>
     dc4:	0e055e63          	bgez	a0,ec0 <linktest+0x1a4>
  fd = open("lf2", 0);
     dc8:	4581                	li	a1,0
     dca:	00005517          	auipc	a0,0x5
     dce:	0a650513          	addi	a0,a0,166 # 5e70 <malloc+0x6d4>
     dd2:	00004097          	auipc	ra,0x4
     dd6:	5d8080e7          	jalr	1496(ra) # 53aa <open>
     dda:	84aa                	mv	s1,a0
  if(fd < 0){
     ddc:	10054063          	bltz	a0,edc <linktest+0x1c0>
  if(read(fd, buf, sizeof(buf)) != SZ){
     de0:	660d                	lui	a2,0x3
     de2:	0000b597          	auipc	a1,0xb
     de6:	99e58593          	addi	a1,a1,-1634 # b780 <buf>
     dea:	00004097          	auipc	ra,0x4
     dee:	598080e7          	jalr	1432(ra) # 5382 <read>
     df2:	4795                	li	a5,5
     df4:	10f51263          	bne	a0,a5,ef8 <linktest+0x1dc>
  close(fd);
     df8:	8526                	mv	a0,s1
     dfa:	00004097          	auipc	ra,0x4
     dfe:	598080e7          	jalr	1432(ra) # 5392 <close>
  if(link("lf2", "lf2") >= 0){
     e02:	00005597          	auipc	a1,0x5
     e06:	06e58593          	addi	a1,a1,110 # 5e70 <malloc+0x6d4>
     e0a:	852e                	mv	a0,a1
     e0c:	00004097          	auipc	ra,0x4
     e10:	5be080e7          	jalr	1470(ra) # 53ca <link>
     e14:	10055063          	bgez	a0,f14 <linktest+0x1f8>
  unlink("lf2");
     e18:	00005517          	auipc	a0,0x5
     e1c:	05850513          	addi	a0,a0,88 # 5e70 <malloc+0x6d4>
     e20:	00004097          	auipc	ra,0x4
     e24:	59a080e7          	jalr	1434(ra) # 53ba <unlink>
  if(link("lf2", "lf1") >= 0){
     e28:	00005597          	auipc	a1,0x5
     e2c:	04058593          	addi	a1,a1,64 # 5e68 <malloc+0x6cc>
     e30:	00005517          	auipc	a0,0x5
     e34:	04050513          	addi	a0,a0,64 # 5e70 <malloc+0x6d4>
     e38:	00004097          	auipc	ra,0x4
     e3c:	592080e7          	jalr	1426(ra) # 53ca <link>
     e40:	0e055863          	bgez	a0,f30 <linktest+0x214>
  if(link(".", "lf1") >= 0){
     e44:	00005597          	auipc	a1,0x5
     e48:	02458593          	addi	a1,a1,36 # 5e68 <malloc+0x6cc>
     e4c:	00005517          	auipc	a0,0x5
     e50:	12c50513          	addi	a0,a0,300 # 5f78 <malloc+0x7dc>
     e54:	00004097          	auipc	ra,0x4
     e58:	576080e7          	jalr	1398(ra) # 53ca <link>
     e5c:	0e055863          	bgez	a0,f4c <linktest+0x230>
}
     e60:	60e2                	ld	ra,24(sp)
     e62:	6442                	ld	s0,16(sp)
     e64:	64a2                	ld	s1,8(sp)
     e66:	6902                	ld	s2,0(sp)
     e68:	6105                	addi	sp,sp,32
     e6a:	8082                	ret
    printf("%s: create lf1 failed\n", s);
     e6c:	85ca                	mv	a1,s2
     e6e:	00005517          	auipc	a0,0x5
     e72:	00a50513          	addi	a0,a0,10 # 5e78 <malloc+0x6dc>
     e76:	00005097          	auipc	ra,0x5
     e7a:	86e080e7          	jalr	-1938(ra) # 56e4 <printf>
    exit(1);
     e7e:	4505                	li	a0,1
     e80:	00004097          	auipc	ra,0x4
     e84:	4ea080e7          	jalr	1258(ra) # 536a <exit>
    printf("%s: write lf1 failed\n", s);
     e88:	85ca                	mv	a1,s2
     e8a:	00005517          	auipc	a0,0x5
     e8e:	00650513          	addi	a0,a0,6 # 5e90 <malloc+0x6f4>
     e92:	00005097          	auipc	ra,0x5
     e96:	852080e7          	jalr	-1966(ra) # 56e4 <printf>
    exit(1);
     e9a:	4505                	li	a0,1
     e9c:	00004097          	auipc	ra,0x4
     ea0:	4ce080e7          	jalr	1230(ra) # 536a <exit>
    printf("%s: link lf1 lf2 failed\n", s);
     ea4:	85ca                	mv	a1,s2
     ea6:	00005517          	auipc	a0,0x5
     eaa:	00250513          	addi	a0,a0,2 # 5ea8 <malloc+0x70c>
     eae:	00005097          	auipc	ra,0x5
     eb2:	836080e7          	jalr	-1994(ra) # 56e4 <printf>
    exit(1);
     eb6:	4505                	li	a0,1
     eb8:	00004097          	auipc	ra,0x4
     ebc:	4b2080e7          	jalr	1202(ra) # 536a <exit>
    printf("%s: unlinked lf1 but it is still there!\n", s);
     ec0:	85ca                	mv	a1,s2
     ec2:	00005517          	auipc	a0,0x5
     ec6:	00650513          	addi	a0,a0,6 # 5ec8 <malloc+0x72c>
     eca:	00005097          	auipc	ra,0x5
     ece:	81a080e7          	jalr	-2022(ra) # 56e4 <printf>
    exit(1);
     ed2:	4505                	li	a0,1
     ed4:	00004097          	auipc	ra,0x4
     ed8:	496080e7          	jalr	1174(ra) # 536a <exit>
    printf("%s: open lf2 failed\n", s);
     edc:	85ca                	mv	a1,s2
     ede:	00005517          	auipc	a0,0x5
     ee2:	01a50513          	addi	a0,a0,26 # 5ef8 <malloc+0x75c>
     ee6:	00004097          	auipc	ra,0x4
     eea:	7fe080e7          	jalr	2046(ra) # 56e4 <printf>
    exit(1);
     eee:	4505                	li	a0,1
     ef0:	00004097          	auipc	ra,0x4
     ef4:	47a080e7          	jalr	1146(ra) # 536a <exit>
    printf("%s: read lf2 failed\n", s);
     ef8:	85ca                	mv	a1,s2
     efa:	00005517          	auipc	a0,0x5
     efe:	01650513          	addi	a0,a0,22 # 5f10 <malloc+0x774>
     f02:	00004097          	auipc	ra,0x4
     f06:	7e2080e7          	jalr	2018(ra) # 56e4 <printf>
    exit(1);
     f0a:	4505                	li	a0,1
     f0c:	00004097          	auipc	ra,0x4
     f10:	45e080e7          	jalr	1118(ra) # 536a <exit>
    printf("%s: link lf2 lf2 succeeded! oops\n", s);
     f14:	85ca                	mv	a1,s2
     f16:	00005517          	auipc	a0,0x5
     f1a:	01250513          	addi	a0,a0,18 # 5f28 <malloc+0x78c>
     f1e:	00004097          	auipc	ra,0x4
     f22:	7c6080e7          	jalr	1990(ra) # 56e4 <printf>
    exit(1);
     f26:	4505                	li	a0,1
     f28:	00004097          	auipc	ra,0x4
     f2c:	442080e7          	jalr	1090(ra) # 536a <exit>
    printf("%s: link non-existant succeeded! oops\n", s);
     f30:	85ca                	mv	a1,s2
     f32:	00005517          	auipc	a0,0x5
     f36:	01e50513          	addi	a0,a0,30 # 5f50 <malloc+0x7b4>
     f3a:	00004097          	auipc	ra,0x4
     f3e:	7aa080e7          	jalr	1962(ra) # 56e4 <printf>
    exit(1);
     f42:	4505                	li	a0,1
     f44:	00004097          	auipc	ra,0x4
     f48:	426080e7          	jalr	1062(ra) # 536a <exit>
    printf("%s: link . lf1 succeeded! oops\n", s);
     f4c:	85ca                	mv	a1,s2
     f4e:	00005517          	auipc	a0,0x5
     f52:	03250513          	addi	a0,a0,50 # 5f80 <malloc+0x7e4>
     f56:	00004097          	auipc	ra,0x4
     f5a:	78e080e7          	jalr	1934(ra) # 56e4 <printf>
    exit(1);
     f5e:	4505                	li	a0,1
     f60:	00004097          	auipc	ra,0x4
     f64:	40a080e7          	jalr	1034(ra) # 536a <exit>

0000000000000f68 <bigdir>:
{
     f68:	715d                	addi	sp,sp,-80
     f6a:	e486                	sd	ra,72(sp)
     f6c:	e0a2                	sd	s0,64(sp)
     f6e:	fc26                	sd	s1,56(sp)
     f70:	f84a                	sd	s2,48(sp)
     f72:	f44e                	sd	s3,40(sp)
     f74:	f052                	sd	s4,32(sp)
     f76:	ec56                	sd	s5,24(sp)
     f78:	e85a                	sd	s6,16(sp)
     f7a:	0880                	addi	s0,sp,80
     f7c:	89aa                	mv	s3,a0
  unlink("bd");
     f7e:	00005517          	auipc	a0,0x5
     f82:	02250513          	addi	a0,a0,34 # 5fa0 <malloc+0x804>
     f86:	00004097          	auipc	ra,0x4
     f8a:	434080e7          	jalr	1076(ra) # 53ba <unlink>
  fd = open("bd", O_CREATE);
     f8e:	20000593          	li	a1,512
     f92:	00005517          	auipc	a0,0x5
     f96:	00e50513          	addi	a0,a0,14 # 5fa0 <malloc+0x804>
     f9a:	00004097          	auipc	ra,0x4
     f9e:	410080e7          	jalr	1040(ra) # 53aa <open>
  if(fd < 0){
     fa2:	0c054963          	bltz	a0,1074 <bigdir+0x10c>
  close(fd);
     fa6:	00004097          	auipc	ra,0x4
     faa:	3ec080e7          	jalr	1004(ra) # 5392 <close>
  for(i = 0; i < N; i++){
     fae:	4901                	li	s2,0
    name[0] = 'x';
     fb0:	07800a93          	li	s5,120
    if(link("bd", name) != 0){
     fb4:	00005a17          	auipc	s4,0x5
     fb8:	feca0a13          	addi	s4,s4,-20 # 5fa0 <malloc+0x804>
  for(i = 0; i < N; i++){
     fbc:	1f400b13          	li	s6,500
    name[0] = 'x';
     fc0:	fb540823          	sb	s5,-80(s0)
    name[1] = '0' + (i / 64);
     fc4:	41f9571b          	sraiw	a4,s2,0x1f
     fc8:	01a7571b          	srliw	a4,a4,0x1a
     fcc:	012707bb          	addw	a5,a4,s2
     fd0:	4067d69b          	sraiw	a3,a5,0x6
     fd4:	0306869b          	addiw	a3,a3,48
     fd8:	fad408a3          	sb	a3,-79(s0)
    name[2] = '0' + (i % 64);
     fdc:	03f7f793          	andi	a5,a5,63
     fe0:	9f99                	subw	a5,a5,a4
     fe2:	0307879b          	addiw	a5,a5,48
     fe6:	faf40923          	sb	a5,-78(s0)
    name[3] = '\0';
     fea:	fa0409a3          	sb	zero,-77(s0)
    if(link("bd", name) != 0){
     fee:	fb040593          	addi	a1,s0,-80
     ff2:	8552                	mv	a0,s4
     ff4:	00004097          	auipc	ra,0x4
     ff8:	3d6080e7          	jalr	982(ra) # 53ca <link>
     ffc:	84aa                	mv	s1,a0
     ffe:	e949                	bnez	a0,1090 <bigdir+0x128>
  for(i = 0; i < N; i++){
    1000:	2905                	addiw	s2,s2,1
    1002:	fb691fe3          	bne	s2,s6,fc0 <bigdir+0x58>
  unlink("bd");
    1006:	00005517          	auipc	a0,0x5
    100a:	f9a50513          	addi	a0,a0,-102 # 5fa0 <malloc+0x804>
    100e:	00004097          	auipc	ra,0x4
    1012:	3ac080e7          	jalr	940(ra) # 53ba <unlink>
    name[0] = 'x';
    1016:	07800913          	li	s2,120
  for(i = 0; i < N; i++){
    101a:	1f400a13          	li	s4,500
    name[0] = 'x';
    101e:	fb240823          	sb	s2,-80(s0)
    name[1] = '0' + (i / 64);
    1022:	41f4d71b          	sraiw	a4,s1,0x1f
    1026:	01a7571b          	srliw	a4,a4,0x1a
    102a:	009707bb          	addw	a5,a4,s1
    102e:	4067d69b          	sraiw	a3,a5,0x6
    1032:	0306869b          	addiw	a3,a3,48
    1036:	fad408a3          	sb	a3,-79(s0)
    name[2] = '0' + (i % 64);
    103a:	03f7f793          	andi	a5,a5,63
    103e:	9f99                	subw	a5,a5,a4
    1040:	0307879b          	addiw	a5,a5,48
    1044:	faf40923          	sb	a5,-78(s0)
    name[3] = '\0';
    1048:	fa0409a3          	sb	zero,-77(s0)
    if(unlink(name) != 0){
    104c:	fb040513          	addi	a0,s0,-80
    1050:	00004097          	auipc	ra,0x4
    1054:	36a080e7          	jalr	874(ra) # 53ba <unlink>
    1058:	ed21                	bnez	a0,10b0 <bigdir+0x148>
  for(i = 0; i < N; i++){
    105a:	2485                	addiw	s1,s1,1
    105c:	fd4491e3          	bne	s1,s4,101e <bigdir+0xb6>
}
    1060:	60a6                	ld	ra,72(sp)
    1062:	6406                	ld	s0,64(sp)
    1064:	74e2                	ld	s1,56(sp)
    1066:	7942                	ld	s2,48(sp)
    1068:	79a2                	ld	s3,40(sp)
    106a:	7a02                	ld	s4,32(sp)
    106c:	6ae2                	ld	s5,24(sp)
    106e:	6b42                	ld	s6,16(sp)
    1070:	6161                	addi	sp,sp,80
    1072:	8082                	ret
    printf("%s: bigdir create failed\n", s);
    1074:	85ce                	mv	a1,s3
    1076:	00005517          	auipc	a0,0x5
    107a:	f3250513          	addi	a0,a0,-206 # 5fa8 <malloc+0x80c>
    107e:	00004097          	auipc	ra,0x4
    1082:	666080e7          	jalr	1638(ra) # 56e4 <printf>
    exit(1);
    1086:	4505                	li	a0,1
    1088:	00004097          	auipc	ra,0x4
    108c:	2e2080e7          	jalr	738(ra) # 536a <exit>
      printf("%s: bigdir link(bd, %s) failed\n", s, name);
    1090:	fb040613          	addi	a2,s0,-80
    1094:	85ce                	mv	a1,s3
    1096:	00005517          	auipc	a0,0x5
    109a:	f3250513          	addi	a0,a0,-206 # 5fc8 <malloc+0x82c>
    109e:	00004097          	auipc	ra,0x4
    10a2:	646080e7          	jalr	1606(ra) # 56e4 <printf>
      exit(1);
    10a6:	4505                	li	a0,1
    10a8:	00004097          	auipc	ra,0x4
    10ac:	2c2080e7          	jalr	706(ra) # 536a <exit>
      printf("%s: bigdir unlink failed", s);
    10b0:	85ce                	mv	a1,s3
    10b2:	00005517          	auipc	a0,0x5
    10b6:	f3650513          	addi	a0,a0,-202 # 5fe8 <malloc+0x84c>
    10ba:	00004097          	auipc	ra,0x4
    10be:	62a080e7          	jalr	1578(ra) # 56e4 <printf>
      exit(1);
    10c2:	4505                	li	a0,1
    10c4:	00004097          	auipc	ra,0x4
    10c8:	2a6080e7          	jalr	678(ra) # 536a <exit>

00000000000010cc <validatetest>:
{
    10cc:	7139                	addi	sp,sp,-64
    10ce:	fc06                	sd	ra,56(sp)
    10d0:	f822                	sd	s0,48(sp)
    10d2:	f426                	sd	s1,40(sp)
    10d4:	f04a                	sd	s2,32(sp)
    10d6:	ec4e                	sd	s3,24(sp)
    10d8:	e852                	sd	s4,16(sp)
    10da:	e456                	sd	s5,8(sp)
    10dc:	e05a                	sd	s6,0(sp)
    10de:	0080                	addi	s0,sp,64
    10e0:	8b2a                	mv	s6,a0
  for(p = 0; p <= (uint)hi; p += PGSIZE){
    10e2:	4481                	li	s1,0
    if(link("nosuchfile", (char*)p) != -1){
    10e4:	00005997          	auipc	s3,0x5
    10e8:	f2498993          	addi	s3,s3,-220 # 6008 <malloc+0x86c>
    10ec:	597d                	li	s2,-1
  for(p = 0; p <= (uint)hi; p += PGSIZE){
    10ee:	6a85                	lui	s5,0x1
    10f0:	00114a37          	lui	s4,0x114
    if(link("nosuchfile", (char*)p) != -1){
    10f4:	85a6                	mv	a1,s1
    10f6:	854e                	mv	a0,s3
    10f8:	00004097          	auipc	ra,0x4
    10fc:	2d2080e7          	jalr	722(ra) # 53ca <link>
    1100:	01251f63          	bne	a0,s2,111e <validatetest+0x52>
  for(p = 0; p <= (uint)hi; p += PGSIZE){
    1104:	94d6                	add	s1,s1,s5
    1106:	ff4497e3          	bne	s1,s4,10f4 <validatetest+0x28>
}
    110a:	70e2                	ld	ra,56(sp)
    110c:	7442                	ld	s0,48(sp)
    110e:	74a2                	ld	s1,40(sp)
    1110:	7902                	ld	s2,32(sp)
    1112:	69e2                	ld	s3,24(sp)
    1114:	6a42                	ld	s4,16(sp)
    1116:	6aa2                	ld	s5,8(sp)
    1118:	6b02                	ld	s6,0(sp)
    111a:	6121                	addi	sp,sp,64
    111c:	8082                	ret
      printf("%s: link should not succeed\n", s);
    111e:	85da                	mv	a1,s6
    1120:	00005517          	auipc	a0,0x5
    1124:	ef850513          	addi	a0,a0,-264 # 6018 <malloc+0x87c>
    1128:	00004097          	auipc	ra,0x4
    112c:	5bc080e7          	jalr	1468(ra) # 56e4 <printf>
      exit(1);
    1130:	4505                	li	a0,1
    1132:	00004097          	auipc	ra,0x4
    1136:	238080e7          	jalr	568(ra) # 536a <exit>

000000000000113a <pgbug>:
// regression test. copyin(), copyout(), and copyinstr() used to cast
// the virtual page address to uint, which (with certain wild system
// call arguments) resulted in a kernel page faults.
void
pgbug(char *s)
{
    113a:	7179                	addi	sp,sp,-48
    113c:	f406                	sd	ra,40(sp)
    113e:	f022                	sd	s0,32(sp)
    1140:	ec26                	sd	s1,24(sp)
    1142:	1800                	addi	s0,sp,48
  char *argv[1];
  argv[0] = 0;
    1144:	fc043c23          	sd	zero,-40(s0)
  exec((char*)0xeaeb0b5b00002f5e, argv);
    1148:	00007497          	auipc	s1,0x7
    114c:	e004b483          	ld	s1,-512(s1) # 7f48 <__SDATA_BEGIN__>
    1150:	fd840593          	addi	a1,s0,-40
    1154:	8526                	mv	a0,s1
    1156:	00004097          	auipc	ra,0x4
    115a:	24c080e7          	jalr	588(ra) # 53a2 <exec>

  pipe((int*)0xeaeb0b5b00002f5e);
    115e:	8526                	mv	a0,s1
    1160:	00004097          	auipc	ra,0x4
    1164:	21a080e7          	jalr	538(ra) # 537a <pipe>

  exit(0);
    1168:	4501                	li	a0,0
    116a:	00004097          	auipc	ra,0x4
    116e:	200080e7          	jalr	512(ra) # 536a <exit>

0000000000001172 <badarg>:

// regression test. test whether exec() leaks memory if one of the
// arguments is invalid. the test passes if the kernel doesn't panic.
void
badarg(char *s)
{
    1172:	7139                	addi	sp,sp,-64
    1174:	fc06                	sd	ra,56(sp)
    1176:	f822                	sd	s0,48(sp)
    1178:	f426                	sd	s1,40(sp)
    117a:	f04a                	sd	s2,32(sp)
    117c:	ec4e                	sd	s3,24(sp)
    117e:	0080                	addi	s0,sp,64
    1180:	64b1                	lui	s1,0xc
    1182:	35048493          	addi	s1,s1,848 # c350 <buf+0xbd0>
  for(int i = 0; i < 50000; i++){
    char *argv[2];
    argv[0] = (char*)0xffffffff;
    1186:	597d                	li	s2,-1
    1188:	02095913          	srli	s2,s2,0x20
    argv[1] = 0;
    exec("echo", argv);
    118c:	00004997          	auipc	s3,0x4
    1190:	73498993          	addi	s3,s3,1844 # 58c0 <malloc+0x124>
    argv[0] = (char*)0xffffffff;
    1194:	fd243023          	sd	s2,-64(s0)
    argv[1] = 0;
    1198:	fc043423          	sd	zero,-56(s0)
    exec("echo", argv);
    119c:	fc040593          	addi	a1,s0,-64
    11a0:	854e                	mv	a0,s3
    11a2:	00004097          	auipc	ra,0x4
    11a6:	200080e7          	jalr	512(ra) # 53a2 <exec>
  for(int i = 0; i < 50000; i++){
    11aa:	34fd                	addiw	s1,s1,-1
    11ac:	f4e5                	bnez	s1,1194 <badarg+0x22>
  }
  
  exit(0);
    11ae:	4501                	li	a0,0
    11b0:	00004097          	auipc	ra,0x4
    11b4:	1ba080e7          	jalr	442(ra) # 536a <exit>

00000000000011b8 <copyinstr2>:
{
    11b8:	7155                	addi	sp,sp,-208
    11ba:	e586                	sd	ra,200(sp)
    11bc:	e1a2                	sd	s0,192(sp)
    11be:	0980                	addi	s0,sp,208
  for(int i = 0; i < MAXPATH; i++)
    11c0:	f6840793          	addi	a5,s0,-152
    11c4:	fe840693          	addi	a3,s0,-24
    b[i] = 'x';
    11c8:	07800713          	li	a4,120
    11cc:	00e78023          	sb	a4,0(a5)
  for(int i = 0; i < MAXPATH; i++)
    11d0:	0785                	addi	a5,a5,1
    11d2:	fed79de3          	bne	a5,a3,11cc <copyinstr2+0x14>
  b[MAXPATH] = '\0';
    11d6:	fe040423          	sb	zero,-24(s0)
  int ret = unlink(b);
    11da:	f6840513          	addi	a0,s0,-152
    11de:	00004097          	auipc	ra,0x4
    11e2:	1dc080e7          	jalr	476(ra) # 53ba <unlink>
  if(ret != -1){
    11e6:	57fd                	li	a5,-1
    11e8:	0ef51063          	bne	a0,a5,12c8 <copyinstr2+0x110>
  int fd = open(b, O_CREATE | O_WRONLY);
    11ec:	20100593          	li	a1,513
    11f0:	f6840513          	addi	a0,s0,-152
    11f4:	00004097          	auipc	ra,0x4
    11f8:	1b6080e7          	jalr	438(ra) # 53aa <open>
  if(fd != -1){
    11fc:	57fd                	li	a5,-1
    11fe:	0ef51563          	bne	a0,a5,12e8 <copyinstr2+0x130>
  ret = link(b, b);
    1202:	f6840593          	addi	a1,s0,-152
    1206:	852e                	mv	a0,a1
    1208:	00004097          	auipc	ra,0x4
    120c:	1c2080e7          	jalr	450(ra) # 53ca <link>
  if(ret != -1){
    1210:	57fd                	li	a5,-1
    1212:	0ef51b63          	bne	a0,a5,1308 <copyinstr2+0x150>
  char *args[] = { "xx", 0 };
    1216:	00006797          	auipc	a5,0x6
    121a:	eca78793          	addi	a5,a5,-310 # 70e0 <malloc+0x1944>
    121e:	f4f43c23          	sd	a5,-168(s0)
    1222:	f6043023          	sd	zero,-160(s0)
  ret = exec(b, args);
    1226:	f5840593          	addi	a1,s0,-168
    122a:	f6840513          	addi	a0,s0,-152
    122e:	00004097          	auipc	ra,0x4
    1232:	174080e7          	jalr	372(ra) # 53a2 <exec>
  if(ret != -1){
    1236:	57fd                	li	a5,-1
    1238:	0ef51963          	bne	a0,a5,132a <copyinstr2+0x172>
  int pid = fork();
    123c:	00004097          	auipc	ra,0x4
    1240:	126080e7          	jalr	294(ra) # 5362 <fork>
  if(pid < 0){
    1244:	10054363          	bltz	a0,134a <copyinstr2+0x192>
  if(pid == 0){
    1248:	12051463          	bnez	a0,1370 <copyinstr2+0x1b8>
    124c:	00007797          	auipc	a5,0x7
    1250:	e1c78793          	addi	a5,a5,-484 # 8068 <big.0>
    1254:	00008697          	auipc	a3,0x8
    1258:	e1468693          	addi	a3,a3,-492 # 9068 <__global_pointer$+0x920>
      big[i] = 'x';
    125c:	07800713          	li	a4,120
    1260:	00e78023          	sb	a4,0(a5)
    for(int i = 0; i < PGSIZE; i++)
    1264:	0785                	addi	a5,a5,1
    1266:	fed79de3          	bne	a5,a3,1260 <copyinstr2+0xa8>
    big[PGSIZE] = '\0';
    126a:	00008797          	auipc	a5,0x8
    126e:	de078f23          	sb	zero,-514(a5) # 9068 <__global_pointer$+0x920>
    char *args2[] = { big, big, big, 0 };
    1272:	00007797          	auipc	a5,0x7
    1276:	8be78793          	addi	a5,a5,-1858 # 7b30 <malloc+0x2394>
    127a:	6390                	ld	a2,0(a5)
    127c:	6794                	ld	a3,8(a5)
    127e:	6b98                	ld	a4,16(a5)
    1280:	6f9c                	ld	a5,24(a5)
    1282:	f2c43823          	sd	a2,-208(s0)
    1286:	f2d43c23          	sd	a3,-200(s0)
    128a:	f4e43023          	sd	a4,-192(s0)
    128e:	f4f43423          	sd	a5,-184(s0)
    ret = exec("echo", args2);
    1292:	f3040593          	addi	a1,s0,-208
    1296:	00004517          	auipc	a0,0x4
    129a:	62a50513          	addi	a0,a0,1578 # 58c0 <malloc+0x124>
    129e:	00004097          	auipc	ra,0x4
    12a2:	104080e7          	jalr	260(ra) # 53a2 <exec>
    if(ret != -1){
    12a6:	57fd                	li	a5,-1
    12a8:	0af50e63          	beq	a0,a5,1364 <copyinstr2+0x1ac>
      printf("exec(echo, BIG) returned %d, not -1\n", fd);
    12ac:	55fd                	li	a1,-1
    12ae:	00005517          	auipc	a0,0x5
    12b2:	e1250513          	addi	a0,a0,-494 # 60c0 <malloc+0x924>
    12b6:	00004097          	auipc	ra,0x4
    12ba:	42e080e7          	jalr	1070(ra) # 56e4 <printf>
      exit(1);
    12be:	4505                	li	a0,1
    12c0:	00004097          	auipc	ra,0x4
    12c4:	0aa080e7          	jalr	170(ra) # 536a <exit>
    printf("unlink(%s) returned %d, not -1\n", b, ret);
    12c8:	862a                	mv	a2,a0
    12ca:	f6840593          	addi	a1,s0,-152
    12ce:	00005517          	auipc	a0,0x5
    12d2:	d6a50513          	addi	a0,a0,-662 # 6038 <malloc+0x89c>
    12d6:	00004097          	auipc	ra,0x4
    12da:	40e080e7          	jalr	1038(ra) # 56e4 <printf>
    exit(1);
    12de:	4505                	li	a0,1
    12e0:	00004097          	auipc	ra,0x4
    12e4:	08a080e7          	jalr	138(ra) # 536a <exit>
    printf("open(%s) returned %d, not -1\n", b, fd);
    12e8:	862a                	mv	a2,a0
    12ea:	f6840593          	addi	a1,s0,-152
    12ee:	00005517          	auipc	a0,0x5
    12f2:	d6a50513          	addi	a0,a0,-662 # 6058 <malloc+0x8bc>
    12f6:	00004097          	auipc	ra,0x4
    12fa:	3ee080e7          	jalr	1006(ra) # 56e4 <printf>
    exit(1);
    12fe:	4505                	li	a0,1
    1300:	00004097          	auipc	ra,0x4
    1304:	06a080e7          	jalr	106(ra) # 536a <exit>
    printf("link(%s, %s) returned %d, not -1\n", b, b, ret);
    1308:	86aa                	mv	a3,a0
    130a:	f6840613          	addi	a2,s0,-152
    130e:	85b2                	mv	a1,a2
    1310:	00005517          	auipc	a0,0x5
    1314:	d6850513          	addi	a0,a0,-664 # 6078 <malloc+0x8dc>
    1318:	00004097          	auipc	ra,0x4
    131c:	3cc080e7          	jalr	972(ra) # 56e4 <printf>
    exit(1);
    1320:	4505                	li	a0,1
    1322:	00004097          	auipc	ra,0x4
    1326:	048080e7          	jalr	72(ra) # 536a <exit>
    printf("exec(%s) returned %d, not -1\n", b, fd);
    132a:	567d                	li	a2,-1
    132c:	f6840593          	addi	a1,s0,-152
    1330:	00005517          	auipc	a0,0x5
    1334:	d7050513          	addi	a0,a0,-656 # 60a0 <malloc+0x904>
    1338:	00004097          	auipc	ra,0x4
    133c:	3ac080e7          	jalr	940(ra) # 56e4 <printf>
    exit(1);
    1340:	4505                	li	a0,1
    1342:	00004097          	auipc	ra,0x4
    1346:	028080e7          	jalr	40(ra) # 536a <exit>
    printf("fork failed\n");
    134a:	00005517          	auipc	a0,0x5
    134e:	1be50513          	addi	a0,a0,446 # 6508 <malloc+0xd6c>
    1352:	00004097          	auipc	ra,0x4
    1356:	392080e7          	jalr	914(ra) # 56e4 <printf>
    exit(1);
    135a:	4505                	li	a0,1
    135c:	00004097          	auipc	ra,0x4
    1360:	00e080e7          	jalr	14(ra) # 536a <exit>
    exit(747); // OK
    1364:	2eb00513          	li	a0,747
    1368:	00004097          	auipc	ra,0x4
    136c:	002080e7          	jalr	2(ra) # 536a <exit>
  int st = 0;
    1370:	f4042a23          	sw	zero,-172(s0)
  wait(&st);
    1374:	f5440513          	addi	a0,s0,-172
    1378:	00004097          	auipc	ra,0x4
    137c:	ffa080e7          	jalr	-6(ra) # 5372 <wait>
  if(st != 747){
    1380:	f5442703          	lw	a4,-172(s0)
    1384:	2eb00793          	li	a5,747
    1388:	00f71663          	bne	a4,a5,1394 <copyinstr2+0x1dc>
}
    138c:	60ae                	ld	ra,200(sp)
    138e:	640e                	ld	s0,192(sp)
    1390:	6169                	addi	sp,sp,208
    1392:	8082                	ret
    printf("exec(echo, BIG) succeeded, should have failed\n");
    1394:	00005517          	auipc	a0,0x5
    1398:	d5450513          	addi	a0,a0,-684 # 60e8 <malloc+0x94c>
    139c:	00004097          	auipc	ra,0x4
    13a0:	348080e7          	jalr	840(ra) # 56e4 <printf>
    exit(1);
    13a4:	4505                	li	a0,1
    13a6:	00004097          	auipc	ra,0x4
    13aa:	fc4080e7          	jalr	-60(ra) # 536a <exit>

00000000000013ae <truncate3>:
{
    13ae:	7159                	addi	sp,sp,-112
    13b0:	f486                	sd	ra,104(sp)
    13b2:	f0a2                	sd	s0,96(sp)
    13b4:	eca6                	sd	s1,88(sp)
    13b6:	e8ca                	sd	s2,80(sp)
    13b8:	e4ce                	sd	s3,72(sp)
    13ba:	e0d2                	sd	s4,64(sp)
    13bc:	fc56                	sd	s5,56(sp)
    13be:	1880                	addi	s0,sp,112
    13c0:	892a                	mv	s2,a0
  close(open("truncfile", O_CREATE|O_TRUNC|O_WRONLY));
    13c2:	60100593          	li	a1,1537
    13c6:	00004517          	auipc	a0,0x4
    13ca:	55250513          	addi	a0,a0,1362 # 5918 <malloc+0x17c>
    13ce:	00004097          	auipc	ra,0x4
    13d2:	fdc080e7          	jalr	-36(ra) # 53aa <open>
    13d6:	00004097          	auipc	ra,0x4
    13da:	fbc080e7          	jalr	-68(ra) # 5392 <close>
  pid = fork();
    13de:	00004097          	auipc	ra,0x4
    13e2:	f84080e7          	jalr	-124(ra) # 5362 <fork>
  if(pid < 0){
    13e6:	08054063          	bltz	a0,1466 <truncate3+0xb8>
  if(pid == 0){
    13ea:	e969                	bnez	a0,14bc <truncate3+0x10e>
    13ec:	06400993          	li	s3,100
      int fd = open("truncfile", O_WRONLY);
    13f0:	00004a17          	auipc	s4,0x4
    13f4:	528a0a13          	addi	s4,s4,1320 # 5918 <malloc+0x17c>
      int n = write(fd, "1234567890", 10);
    13f8:	00005a97          	auipc	s5,0x5
    13fc:	d50a8a93          	addi	s5,s5,-688 # 6148 <malloc+0x9ac>
      int fd = open("truncfile", O_WRONLY);
    1400:	4585                	li	a1,1
    1402:	8552                	mv	a0,s4
    1404:	00004097          	auipc	ra,0x4
    1408:	fa6080e7          	jalr	-90(ra) # 53aa <open>
    140c:	84aa                	mv	s1,a0
      if(fd < 0){
    140e:	06054a63          	bltz	a0,1482 <truncate3+0xd4>
      int n = write(fd, "1234567890", 10);
    1412:	4629                	li	a2,10
    1414:	85d6                	mv	a1,s5
    1416:	00004097          	auipc	ra,0x4
    141a:	f74080e7          	jalr	-140(ra) # 538a <write>
      if(n != 10){
    141e:	47a9                	li	a5,10
    1420:	06f51f63          	bne	a0,a5,149e <truncate3+0xf0>
      close(fd);
    1424:	8526                	mv	a0,s1
    1426:	00004097          	auipc	ra,0x4
    142a:	f6c080e7          	jalr	-148(ra) # 5392 <close>
      fd = open("truncfile", O_RDONLY);
    142e:	4581                	li	a1,0
    1430:	8552                	mv	a0,s4
    1432:	00004097          	auipc	ra,0x4
    1436:	f78080e7          	jalr	-136(ra) # 53aa <open>
    143a:	84aa                	mv	s1,a0
      read(fd, buf, sizeof(buf));
    143c:	02000613          	li	a2,32
    1440:	f9840593          	addi	a1,s0,-104
    1444:	00004097          	auipc	ra,0x4
    1448:	f3e080e7          	jalr	-194(ra) # 5382 <read>
      close(fd);
    144c:	8526                	mv	a0,s1
    144e:	00004097          	auipc	ra,0x4
    1452:	f44080e7          	jalr	-188(ra) # 5392 <close>
    for(int i = 0; i < 100; i++){
    1456:	39fd                	addiw	s3,s3,-1
    1458:	fa0994e3          	bnez	s3,1400 <truncate3+0x52>
    exit(0);
    145c:	4501                	li	a0,0
    145e:	00004097          	auipc	ra,0x4
    1462:	f0c080e7          	jalr	-244(ra) # 536a <exit>
    printf("%s: fork failed\n", s);
    1466:	85ca                	mv	a1,s2
    1468:	00005517          	auipc	a0,0x5
    146c:	cb050513          	addi	a0,a0,-848 # 6118 <malloc+0x97c>
    1470:	00004097          	auipc	ra,0x4
    1474:	274080e7          	jalr	628(ra) # 56e4 <printf>
    exit(1);
    1478:	4505                	li	a0,1
    147a:	00004097          	auipc	ra,0x4
    147e:	ef0080e7          	jalr	-272(ra) # 536a <exit>
        printf("%s: open failed\n", s);
    1482:	85ca                	mv	a1,s2
    1484:	00005517          	auipc	a0,0x5
    1488:	cac50513          	addi	a0,a0,-852 # 6130 <malloc+0x994>
    148c:	00004097          	auipc	ra,0x4
    1490:	258080e7          	jalr	600(ra) # 56e4 <printf>
        exit(1);
    1494:	4505                	li	a0,1
    1496:	00004097          	auipc	ra,0x4
    149a:	ed4080e7          	jalr	-300(ra) # 536a <exit>
        printf("%s: write got %d, expected 10\n", s, n);
    149e:	862a                	mv	a2,a0
    14a0:	85ca                	mv	a1,s2
    14a2:	00005517          	auipc	a0,0x5
    14a6:	cb650513          	addi	a0,a0,-842 # 6158 <malloc+0x9bc>
    14aa:	00004097          	auipc	ra,0x4
    14ae:	23a080e7          	jalr	570(ra) # 56e4 <printf>
        exit(1);
    14b2:	4505                	li	a0,1
    14b4:	00004097          	auipc	ra,0x4
    14b8:	eb6080e7          	jalr	-330(ra) # 536a <exit>
    14bc:	09600993          	li	s3,150
    int fd = open("truncfile", O_CREATE|O_WRONLY|O_TRUNC);
    14c0:	00004a17          	auipc	s4,0x4
    14c4:	458a0a13          	addi	s4,s4,1112 # 5918 <malloc+0x17c>
    int n = write(fd, "xxx", 3);
    14c8:	00005a97          	auipc	s5,0x5
    14cc:	cb0a8a93          	addi	s5,s5,-848 # 6178 <malloc+0x9dc>
    int fd = open("truncfile", O_CREATE|O_WRONLY|O_TRUNC);
    14d0:	60100593          	li	a1,1537
    14d4:	8552                	mv	a0,s4
    14d6:	00004097          	auipc	ra,0x4
    14da:	ed4080e7          	jalr	-300(ra) # 53aa <open>
    14de:	84aa                	mv	s1,a0
    if(fd < 0){
    14e0:	04054763          	bltz	a0,152e <truncate3+0x180>
    int n = write(fd, "xxx", 3);
    14e4:	460d                	li	a2,3
    14e6:	85d6                	mv	a1,s5
    14e8:	00004097          	auipc	ra,0x4
    14ec:	ea2080e7          	jalr	-350(ra) # 538a <write>
    if(n != 3){
    14f0:	478d                	li	a5,3
    14f2:	04f51c63          	bne	a0,a5,154a <truncate3+0x19c>
    close(fd);
    14f6:	8526                	mv	a0,s1
    14f8:	00004097          	auipc	ra,0x4
    14fc:	e9a080e7          	jalr	-358(ra) # 5392 <close>
  for(int i = 0; i < 150; i++){
    1500:	39fd                	addiw	s3,s3,-1
    1502:	fc0997e3          	bnez	s3,14d0 <truncate3+0x122>
  wait(&xstatus);
    1506:	fbc40513          	addi	a0,s0,-68
    150a:	00004097          	auipc	ra,0x4
    150e:	e68080e7          	jalr	-408(ra) # 5372 <wait>
  unlink("truncfile");
    1512:	00004517          	auipc	a0,0x4
    1516:	40650513          	addi	a0,a0,1030 # 5918 <malloc+0x17c>
    151a:	00004097          	auipc	ra,0x4
    151e:	ea0080e7          	jalr	-352(ra) # 53ba <unlink>
  exit(xstatus);
    1522:	fbc42503          	lw	a0,-68(s0)
    1526:	00004097          	auipc	ra,0x4
    152a:	e44080e7          	jalr	-444(ra) # 536a <exit>
      printf("%s: open failed\n", s);
    152e:	85ca                	mv	a1,s2
    1530:	00005517          	auipc	a0,0x5
    1534:	c0050513          	addi	a0,a0,-1024 # 6130 <malloc+0x994>
    1538:	00004097          	auipc	ra,0x4
    153c:	1ac080e7          	jalr	428(ra) # 56e4 <printf>
      exit(1);
    1540:	4505                	li	a0,1
    1542:	00004097          	auipc	ra,0x4
    1546:	e28080e7          	jalr	-472(ra) # 536a <exit>
      printf("%s: write got %d, expected 3\n", s, n);
    154a:	862a                	mv	a2,a0
    154c:	85ca                	mv	a1,s2
    154e:	00005517          	auipc	a0,0x5
    1552:	c3250513          	addi	a0,a0,-974 # 6180 <malloc+0x9e4>
    1556:	00004097          	auipc	ra,0x4
    155a:	18e080e7          	jalr	398(ra) # 56e4 <printf>
      exit(1);
    155e:	4505                	li	a0,1
    1560:	00004097          	auipc	ra,0x4
    1564:	e0a080e7          	jalr	-502(ra) # 536a <exit>

0000000000001568 <exectest>:
{
    1568:	715d                	addi	sp,sp,-80
    156a:	e486                	sd	ra,72(sp)
    156c:	e0a2                	sd	s0,64(sp)
    156e:	fc26                	sd	s1,56(sp)
    1570:	f84a                	sd	s2,48(sp)
    1572:	0880                	addi	s0,sp,80
    1574:	892a                	mv	s2,a0
  char *echoargv[] = { "echo", "OK", 0 };
    1576:	00004797          	auipc	a5,0x4
    157a:	34a78793          	addi	a5,a5,842 # 58c0 <malloc+0x124>
    157e:	fcf43023          	sd	a5,-64(s0)
    1582:	00005797          	auipc	a5,0x5
    1586:	c1e78793          	addi	a5,a5,-994 # 61a0 <malloc+0xa04>
    158a:	fcf43423          	sd	a5,-56(s0)
    158e:	fc043823          	sd	zero,-48(s0)
  unlink("echo-ok");
    1592:	00005517          	auipc	a0,0x5
    1596:	c1650513          	addi	a0,a0,-1002 # 61a8 <malloc+0xa0c>
    159a:	00004097          	auipc	ra,0x4
    159e:	e20080e7          	jalr	-480(ra) # 53ba <unlink>
  pid = fork();
    15a2:	00004097          	auipc	ra,0x4
    15a6:	dc0080e7          	jalr	-576(ra) # 5362 <fork>
  if(pid < 0) {
    15aa:	04054663          	bltz	a0,15f6 <exectest+0x8e>
    15ae:	84aa                	mv	s1,a0
  if(pid == 0) {
    15b0:	e959                	bnez	a0,1646 <exectest+0xde>
    close(1);
    15b2:	4505                	li	a0,1
    15b4:	00004097          	auipc	ra,0x4
    15b8:	dde080e7          	jalr	-546(ra) # 5392 <close>
    fd = open("echo-ok", O_CREATE|O_WRONLY);
    15bc:	20100593          	li	a1,513
    15c0:	00005517          	auipc	a0,0x5
    15c4:	be850513          	addi	a0,a0,-1048 # 61a8 <malloc+0xa0c>
    15c8:	00004097          	auipc	ra,0x4
    15cc:	de2080e7          	jalr	-542(ra) # 53aa <open>
    if(fd < 0) {
    15d0:	04054163          	bltz	a0,1612 <exectest+0xaa>
    if(fd != 1) {
    15d4:	4785                	li	a5,1
    15d6:	04f50c63          	beq	a0,a5,162e <exectest+0xc6>
      printf("%s: wrong fd\n", s);
    15da:	85ca                	mv	a1,s2
    15dc:	00005517          	auipc	a0,0x5
    15e0:	bec50513          	addi	a0,a0,-1044 # 61c8 <malloc+0xa2c>
    15e4:	00004097          	auipc	ra,0x4
    15e8:	100080e7          	jalr	256(ra) # 56e4 <printf>
      exit(1);
    15ec:	4505                	li	a0,1
    15ee:	00004097          	auipc	ra,0x4
    15f2:	d7c080e7          	jalr	-644(ra) # 536a <exit>
     printf("%s: fork failed\n", s);
    15f6:	85ca                	mv	a1,s2
    15f8:	00005517          	auipc	a0,0x5
    15fc:	b2050513          	addi	a0,a0,-1248 # 6118 <malloc+0x97c>
    1600:	00004097          	auipc	ra,0x4
    1604:	0e4080e7          	jalr	228(ra) # 56e4 <printf>
     exit(1);
    1608:	4505                	li	a0,1
    160a:	00004097          	auipc	ra,0x4
    160e:	d60080e7          	jalr	-672(ra) # 536a <exit>
      printf("%s: create failed\n", s);
    1612:	85ca                	mv	a1,s2
    1614:	00005517          	auipc	a0,0x5
    1618:	b9c50513          	addi	a0,a0,-1124 # 61b0 <malloc+0xa14>
    161c:	00004097          	auipc	ra,0x4
    1620:	0c8080e7          	jalr	200(ra) # 56e4 <printf>
      exit(1);
    1624:	4505                	li	a0,1
    1626:	00004097          	auipc	ra,0x4
    162a:	d44080e7          	jalr	-700(ra) # 536a <exit>
    if(exec("echo", echoargv) < 0){
    162e:	fc040593          	addi	a1,s0,-64
    1632:	00004517          	auipc	a0,0x4
    1636:	28e50513          	addi	a0,a0,654 # 58c0 <malloc+0x124>
    163a:	00004097          	auipc	ra,0x4
    163e:	d68080e7          	jalr	-664(ra) # 53a2 <exec>
    1642:	02054163          	bltz	a0,1664 <exectest+0xfc>
  if (wait(&xstatus) != pid) {
    1646:	fdc40513          	addi	a0,s0,-36
    164a:	00004097          	auipc	ra,0x4
    164e:	d28080e7          	jalr	-728(ra) # 5372 <wait>
    1652:	02951763          	bne	a0,s1,1680 <exectest+0x118>
  if(xstatus != 0)
    1656:	fdc42503          	lw	a0,-36(s0)
    165a:	cd0d                	beqz	a0,1694 <exectest+0x12c>
    exit(xstatus);
    165c:	00004097          	auipc	ra,0x4
    1660:	d0e080e7          	jalr	-754(ra) # 536a <exit>
      printf("%s: exec echo failed\n", s);
    1664:	85ca                	mv	a1,s2
    1666:	00005517          	auipc	a0,0x5
    166a:	b7250513          	addi	a0,a0,-1166 # 61d8 <malloc+0xa3c>
    166e:	00004097          	auipc	ra,0x4
    1672:	076080e7          	jalr	118(ra) # 56e4 <printf>
      exit(1);
    1676:	4505                	li	a0,1
    1678:	00004097          	auipc	ra,0x4
    167c:	cf2080e7          	jalr	-782(ra) # 536a <exit>
    printf("%s: wait failed!\n", s);
    1680:	85ca                	mv	a1,s2
    1682:	00005517          	auipc	a0,0x5
    1686:	b6e50513          	addi	a0,a0,-1170 # 61f0 <malloc+0xa54>
    168a:	00004097          	auipc	ra,0x4
    168e:	05a080e7          	jalr	90(ra) # 56e4 <printf>
    1692:	b7d1                	j	1656 <exectest+0xee>
  fd = open("echo-ok", O_RDONLY);
    1694:	4581                	li	a1,0
    1696:	00005517          	auipc	a0,0x5
    169a:	b1250513          	addi	a0,a0,-1262 # 61a8 <malloc+0xa0c>
    169e:	00004097          	auipc	ra,0x4
    16a2:	d0c080e7          	jalr	-756(ra) # 53aa <open>
  if(fd < 0) {
    16a6:	02054a63          	bltz	a0,16da <exectest+0x172>
  if (read(fd, buf, 2) != 2) {
    16aa:	4609                	li	a2,2
    16ac:	fb840593          	addi	a1,s0,-72
    16b0:	00004097          	auipc	ra,0x4
    16b4:	cd2080e7          	jalr	-814(ra) # 5382 <read>
    16b8:	4789                	li	a5,2
    16ba:	02f50e63          	beq	a0,a5,16f6 <exectest+0x18e>
    printf("%s: read failed\n", s);
    16be:	85ca                	mv	a1,s2
    16c0:	00004517          	auipc	a0,0x4
    16c4:	5a050513          	addi	a0,a0,1440 # 5c60 <malloc+0x4c4>
    16c8:	00004097          	auipc	ra,0x4
    16cc:	01c080e7          	jalr	28(ra) # 56e4 <printf>
    exit(1);
    16d0:	4505                	li	a0,1
    16d2:	00004097          	auipc	ra,0x4
    16d6:	c98080e7          	jalr	-872(ra) # 536a <exit>
    printf("%s: open failed\n", s);
    16da:	85ca                	mv	a1,s2
    16dc:	00005517          	auipc	a0,0x5
    16e0:	a5450513          	addi	a0,a0,-1452 # 6130 <malloc+0x994>
    16e4:	00004097          	auipc	ra,0x4
    16e8:	000080e7          	jalr	ra # 56e4 <printf>
    exit(1);
    16ec:	4505                	li	a0,1
    16ee:	00004097          	auipc	ra,0x4
    16f2:	c7c080e7          	jalr	-900(ra) # 536a <exit>
  unlink("echo-ok");
    16f6:	00005517          	auipc	a0,0x5
    16fa:	ab250513          	addi	a0,a0,-1358 # 61a8 <malloc+0xa0c>
    16fe:	00004097          	auipc	ra,0x4
    1702:	cbc080e7          	jalr	-836(ra) # 53ba <unlink>
  if(buf[0] == 'O' && buf[1] == 'K')
    1706:	fb844703          	lbu	a4,-72(s0)
    170a:	04f00793          	li	a5,79
    170e:	00f71863          	bne	a4,a5,171e <exectest+0x1b6>
    1712:	fb944703          	lbu	a4,-71(s0)
    1716:	04b00793          	li	a5,75
    171a:	02f70063          	beq	a4,a5,173a <exectest+0x1d2>
    printf("%s: wrong output\n", s);
    171e:	85ca                	mv	a1,s2
    1720:	00005517          	auipc	a0,0x5
    1724:	ae850513          	addi	a0,a0,-1304 # 6208 <malloc+0xa6c>
    1728:	00004097          	auipc	ra,0x4
    172c:	fbc080e7          	jalr	-68(ra) # 56e4 <printf>
    exit(1);
    1730:	4505                	li	a0,1
    1732:	00004097          	auipc	ra,0x4
    1736:	c38080e7          	jalr	-968(ra) # 536a <exit>
    exit(0);
    173a:	4501                	li	a0,0
    173c:	00004097          	auipc	ra,0x4
    1740:	c2e080e7          	jalr	-978(ra) # 536a <exit>

0000000000001744 <pipe1>:
{
    1744:	711d                	addi	sp,sp,-96
    1746:	ec86                	sd	ra,88(sp)
    1748:	e8a2                	sd	s0,80(sp)
    174a:	e4a6                	sd	s1,72(sp)
    174c:	e0ca                	sd	s2,64(sp)
    174e:	fc4e                	sd	s3,56(sp)
    1750:	f852                	sd	s4,48(sp)
    1752:	f456                	sd	s5,40(sp)
    1754:	f05a                	sd	s6,32(sp)
    1756:	ec5e                	sd	s7,24(sp)
    1758:	1080                	addi	s0,sp,96
    175a:	892a                	mv	s2,a0
  if(pipe(fds) != 0){
    175c:	fa840513          	addi	a0,s0,-88
    1760:	00004097          	auipc	ra,0x4
    1764:	c1a080e7          	jalr	-998(ra) # 537a <pipe>
    1768:	e93d                	bnez	a0,17de <pipe1+0x9a>
    176a:	84aa                	mv	s1,a0
  pid = fork();
    176c:	00004097          	auipc	ra,0x4
    1770:	bf6080e7          	jalr	-1034(ra) # 5362 <fork>
    1774:	8a2a                	mv	s4,a0
  if(pid == 0){
    1776:	c151                	beqz	a0,17fa <pipe1+0xb6>
  } else if(pid > 0){
    1778:	16a05d63          	blez	a0,18f2 <pipe1+0x1ae>
    close(fds[1]);
    177c:	fac42503          	lw	a0,-84(s0)
    1780:	00004097          	auipc	ra,0x4
    1784:	c12080e7          	jalr	-1006(ra) # 5392 <close>
    total = 0;
    1788:	8a26                	mv	s4,s1
    cc = 1;
    178a:	4985                	li	s3,1
    while((n = read(fds[0], buf, cc)) > 0){
    178c:	0000aa97          	auipc	s5,0xa
    1790:	ff4a8a93          	addi	s5,s5,-12 # b780 <buf>
      if(cc > sizeof(buf))
    1794:	6b0d                	lui	s6,0x3
    while((n = read(fds[0], buf, cc)) > 0){
    1796:	864e                	mv	a2,s3
    1798:	85d6                	mv	a1,s5
    179a:	fa842503          	lw	a0,-88(s0)
    179e:	00004097          	auipc	ra,0x4
    17a2:	be4080e7          	jalr	-1052(ra) # 5382 <read>
    17a6:	10a05163          	blez	a0,18a8 <pipe1+0x164>
      for(i = 0; i < n; i++){
    17aa:	0000a717          	auipc	a4,0xa
    17ae:	fd670713          	addi	a4,a4,-42 # b780 <buf>
    17b2:	00a4863b          	addw	a2,s1,a0
        if((buf[i] & 0xff) != (seq++ & 0xff)){
    17b6:	00074683          	lbu	a3,0(a4)
    17ba:	0ff4f793          	zext.b	a5,s1
    17be:	2485                	addiw	s1,s1,1
    17c0:	0cf69063          	bne	a3,a5,1880 <pipe1+0x13c>
      for(i = 0; i < n; i++){
    17c4:	0705                	addi	a4,a4,1
    17c6:	fec498e3          	bne	s1,a2,17b6 <pipe1+0x72>
      total += n;
    17ca:	00aa0a3b          	addw	s4,s4,a0
      cc = cc * 2;
    17ce:	0019979b          	slliw	a5,s3,0x1
    17d2:	0007899b          	sext.w	s3,a5
      if(cc > sizeof(buf))
    17d6:	fd3b70e3          	bgeu	s6,s3,1796 <pipe1+0x52>
        cc = sizeof(buf);
    17da:	89da                	mv	s3,s6
    17dc:	bf6d                	j	1796 <pipe1+0x52>
    printf("%s: pipe() failed\n", s);
    17de:	85ca                	mv	a1,s2
    17e0:	00005517          	auipc	a0,0x5
    17e4:	a4050513          	addi	a0,a0,-1472 # 6220 <malloc+0xa84>
    17e8:	00004097          	auipc	ra,0x4
    17ec:	efc080e7          	jalr	-260(ra) # 56e4 <printf>
    exit(1);
    17f0:	4505                	li	a0,1
    17f2:	00004097          	auipc	ra,0x4
    17f6:	b78080e7          	jalr	-1160(ra) # 536a <exit>
    close(fds[0]);
    17fa:	fa842503          	lw	a0,-88(s0)
    17fe:	00004097          	auipc	ra,0x4
    1802:	b94080e7          	jalr	-1132(ra) # 5392 <close>
    for(n = 0; n < N; n++){
    1806:	0000ab17          	auipc	s6,0xa
    180a:	f7ab0b13          	addi	s6,s6,-134 # b780 <buf>
    180e:	416004bb          	negw	s1,s6
    1812:	0ff4f493          	zext.b	s1,s1
    1816:	409b0993          	addi	s3,s6,1033
      if(write(fds[1], buf, SZ) != SZ){
    181a:	8bda                	mv	s7,s6
    for(n = 0; n < N; n++){
    181c:	6a85                	lui	s5,0x1
    181e:	42da8a93          	addi	s5,s5,1069 # 142d <truncate3+0x7f>
{
    1822:	87da                	mv	a5,s6
        buf[i] = seq++;
    1824:	0097873b          	addw	a4,a5,s1
    1828:	00e78023          	sb	a4,0(a5)
      for(i = 0; i < SZ; i++)
    182c:	0785                	addi	a5,a5,1
    182e:	fef99be3          	bne	s3,a5,1824 <pipe1+0xe0>
        buf[i] = seq++;
    1832:	409a0a1b          	addiw	s4,s4,1033
      if(write(fds[1], buf, SZ) != SZ){
    1836:	40900613          	li	a2,1033
    183a:	85de                	mv	a1,s7
    183c:	fac42503          	lw	a0,-84(s0)
    1840:	00004097          	auipc	ra,0x4
    1844:	b4a080e7          	jalr	-1206(ra) # 538a <write>
    1848:	40900793          	li	a5,1033
    184c:	00f51c63          	bne	a0,a5,1864 <pipe1+0x120>
    for(n = 0; n < N; n++){
    1850:	24a5                	addiw	s1,s1,9
    1852:	0ff4f493          	zext.b	s1,s1
    1856:	fd5a16e3          	bne	s4,s5,1822 <pipe1+0xde>
    exit(0);
    185a:	4501                	li	a0,0
    185c:	00004097          	auipc	ra,0x4
    1860:	b0e080e7          	jalr	-1266(ra) # 536a <exit>
        printf("%s: pipe1 oops 1\n", s);
    1864:	85ca                	mv	a1,s2
    1866:	00005517          	auipc	a0,0x5
    186a:	9d250513          	addi	a0,a0,-1582 # 6238 <malloc+0xa9c>
    186e:	00004097          	auipc	ra,0x4
    1872:	e76080e7          	jalr	-394(ra) # 56e4 <printf>
        exit(1);
    1876:	4505                	li	a0,1
    1878:	00004097          	auipc	ra,0x4
    187c:	af2080e7          	jalr	-1294(ra) # 536a <exit>
          printf("%s: pipe1 oops 2\n", s);
    1880:	85ca                	mv	a1,s2
    1882:	00005517          	auipc	a0,0x5
    1886:	9ce50513          	addi	a0,a0,-1586 # 6250 <malloc+0xab4>
    188a:	00004097          	auipc	ra,0x4
    188e:	e5a080e7          	jalr	-422(ra) # 56e4 <printf>
}
    1892:	60e6                	ld	ra,88(sp)
    1894:	6446                	ld	s0,80(sp)
    1896:	64a6                	ld	s1,72(sp)
    1898:	6906                	ld	s2,64(sp)
    189a:	79e2                	ld	s3,56(sp)
    189c:	7a42                	ld	s4,48(sp)
    189e:	7aa2                	ld	s5,40(sp)
    18a0:	7b02                	ld	s6,32(sp)
    18a2:	6be2                	ld	s7,24(sp)
    18a4:	6125                	addi	sp,sp,96
    18a6:	8082                	ret
    if(total != N * SZ){
    18a8:	6785                	lui	a5,0x1
    18aa:	42d78793          	addi	a5,a5,1069 # 142d <truncate3+0x7f>
    18ae:	02fa0063          	beq	s4,a5,18ce <pipe1+0x18a>
      printf("%s: pipe1 oops 3 total %d\n", total);
    18b2:	85d2                	mv	a1,s4
    18b4:	00005517          	auipc	a0,0x5
    18b8:	9b450513          	addi	a0,a0,-1612 # 6268 <malloc+0xacc>
    18bc:	00004097          	auipc	ra,0x4
    18c0:	e28080e7          	jalr	-472(ra) # 56e4 <printf>
      exit(1);
    18c4:	4505                	li	a0,1
    18c6:	00004097          	auipc	ra,0x4
    18ca:	aa4080e7          	jalr	-1372(ra) # 536a <exit>
    close(fds[0]);
    18ce:	fa842503          	lw	a0,-88(s0)
    18d2:	00004097          	auipc	ra,0x4
    18d6:	ac0080e7          	jalr	-1344(ra) # 5392 <close>
    wait(&xstatus);
    18da:	fa440513          	addi	a0,s0,-92
    18de:	00004097          	auipc	ra,0x4
    18e2:	a94080e7          	jalr	-1388(ra) # 5372 <wait>
    exit(xstatus);
    18e6:	fa442503          	lw	a0,-92(s0)
    18ea:	00004097          	auipc	ra,0x4
    18ee:	a80080e7          	jalr	-1408(ra) # 536a <exit>
    printf("%s: fork() failed\n", s);
    18f2:	85ca                	mv	a1,s2
    18f4:	00005517          	auipc	a0,0x5
    18f8:	99450513          	addi	a0,a0,-1644 # 6288 <malloc+0xaec>
    18fc:	00004097          	auipc	ra,0x4
    1900:	de8080e7          	jalr	-536(ra) # 56e4 <printf>
    exit(1);
    1904:	4505                	li	a0,1
    1906:	00004097          	auipc	ra,0x4
    190a:	a64080e7          	jalr	-1436(ra) # 536a <exit>

000000000000190e <exitwait>:
{
    190e:	7139                	addi	sp,sp,-64
    1910:	fc06                	sd	ra,56(sp)
    1912:	f822                	sd	s0,48(sp)
    1914:	f426                	sd	s1,40(sp)
    1916:	f04a                	sd	s2,32(sp)
    1918:	ec4e                	sd	s3,24(sp)
    191a:	e852                	sd	s4,16(sp)
    191c:	0080                	addi	s0,sp,64
    191e:	8a2a                	mv	s4,a0
  for(i = 0; i < 100; i++){
    1920:	4901                	li	s2,0
    1922:	06400993          	li	s3,100
    pid = fork();
    1926:	00004097          	auipc	ra,0x4
    192a:	a3c080e7          	jalr	-1476(ra) # 5362 <fork>
    192e:	84aa                	mv	s1,a0
    if(pid < 0){
    1930:	02054a63          	bltz	a0,1964 <exitwait+0x56>
    if(pid){
    1934:	c151                	beqz	a0,19b8 <exitwait+0xaa>
      if(wait(&xstate) != pid){
    1936:	fcc40513          	addi	a0,s0,-52
    193a:	00004097          	auipc	ra,0x4
    193e:	a38080e7          	jalr	-1480(ra) # 5372 <wait>
    1942:	02951f63          	bne	a0,s1,1980 <exitwait+0x72>
      if(i != xstate) {
    1946:	fcc42783          	lw	a5,-52(s0)
    194a:	05279963          	bne	a5,s2,199c <exitwait+0x8e>
  for(i = 0; i < 100; i++){
    194e:	2905                	addiw	s2,s2,1
    1950:	fd391be3          	bne	s2,s3,1926 <exitwait+0x18>
}
    1954:	70e2                	ld	ra,56(sp)
    1956:	7442                	ld	s0,48(sp)
    1958:	74a2                	ld	s1,40(sp)
    195a:	7902                	ld	s2,32(sp)
    195c:	69e2                	ld	s3,24(sp)
    195e:	6a42                	ld	s4,16(sp)
    1960:	6121                	addi	sp,sp,64
    1962:	8082                	ret
      printf("%s: fork failed\n", s);
    1964:	85d2                	mv	a1,s4
    1966:	00004517          	auipc	a0,0x4
    196a:	7b250513          	addi	a0,a0,1970 # 6118 <malloc+0x97c>
    196e:	00004097          	auipc	ra,0x4
    1972:	d76080e7          	jalr	-650(ra) # 56e4 <printf>
      exit(1);
    1976:	4505                	li	a0,1
    1978:	00004097          	auipc	ra,0x4
    197c:	9f2080e7          	jalr	-1550(ra) # 536a <exit>
        printf("%s: wait wrong pid\n", s);
    1980:	85d2                	mv	a1,s4
    1982:	00005517          	auipc	a0,0x5
    1986:	91e50513          	addi	a0,a0,-1762 # 62a0 <malloc+0xb04>
    198a:	00004097          	auipc	ra,0x4
    198e:	d5a080e7          	jalr	-678(ra) # 56e4 <printf>
        exit(1);
    1992:	4505                	li	a0,1
    1994:	00004097          	auipc	ra,0x4
    1998:	9d6080e7          	jalr	-1578(ra) # 536a <exit>
        printf("%s: wait wrong exit status\n", s);
    199c:	85d2                	mv	a1,s4
    199e:	00005517          	auipc	a0,0x5
    19a2:	91a50513          	addi	a0,a0,-1766 # 62b8 <malloc+0xb1c>
    19a6:	00004097          	auipc	ra,0x4
    19aa:	d3e080e7          	jalr	-706(ra) # 56e4 <printf>
        exit(1);
    19ae:	4505                	li	a0,1
    19b0:	00004097          	auipc	ra,0x4
    19b4:	9ba080e7          	jalr	-1606(ra) # 536a <exit>
      exit(i);
    19b8:	854a                	mv	a0,s2
    19ba:	00004097          	auipc	ra,0x4
    19be:	9b0080e7          	jalr	-1616(ra) # 536a <exit>

00000000000019c2 <twochildren>:
{
    19c2:	1101                	addi	sp,sp,-32
    19c4:	ec06                	sd	ra,24(sp)
    19c6:	e822                	sd	s0,16(sp)
    19c8:	e426                	sd	s1,8(sp)
    19ca:	e04a                	sd	s2,0(sp)
    19cc:	1000                	addi	s0,sp,32
    19ce:	892a                	mv	s2,a0
    19d0:	3e800493          	li	s1,1000
    int pid1 = fork();
    19d4:	00004097          	auipc	ra,0x4
    19d8:	98e080e7          	jalr	-1650(ra) # 5362 <fork>
    if(pid1 < 0){
    19dc:	02054c63          	bltz	a0,1a14 <twochildren+0x52>
    if(pid1 == 0){
    19e0:	c921                	beqz	a0,1a30 <twochildren+0x6e>
      int pid2 = fork();
    19e2:	00004097          	auipc	ra,0x4
    19e6:	980080e7          	jalr	-1664(ra) # 5362 <fork>
      if(pid2 < 0){
    19ea:	04054763          	bltz	a0,1a38 <twochildren+0x76>
      if(pid2 == 0){
    19ee:	c13d                	beqz	a0,1a54 <twochildren+0x92>
        wait(0);
    19f0:	4501                	li	a0,0
    19f2:	00004097          	auipc	ra,0x4
    19f6:	980080e7          	jalr	-1664(ra) # 5372 <wait>
        wait(0);
    19fa:	4501                	li	a0,0
    19fc:	00004097          	auipc	ra,0x4
    1a00:	976080e7          	jalr	-1674(ra) # 5372 <wait>
  for(int i = 0; i < 1000; i++){
    1a04:	34fd                	addiw	s1,s1,-1
    1a06:	f4f9                	bnez	s1,19d4 <twochildren+0x12>
}
    1a08:	60e2                	ld	ra,24(sp)
    1a0a:	6442                	ld	s0,16(sp)
    1a0c:	64a2                	ld	s1,8(sp)
    1a0e:	6902                	ld	s2,0(sp)
    1a10:	6105                	addi	sp,sp,32
    1a12:	8082                	ret
      printf("%s: fork failed\n", s);
    1a14:	85ca                	mv	a1,s2
    1a16:	00004517          	auipc	a0,0x4
    1a1a:	70250513          	addi	a0,a0,1794 # 6118 <malloc+0x97c>
    1a1e:	00004097          	auipc	ra,0x4
    1a22:	cc6080e7          	jalr	-826(ra) # 56e4 <printf>
      exit(1);
    1a26:	4505                	li	a0,1
    1a28:	00004097          	auipc	ra,0x4
    1a2c:	942080e7          	jalr	-1726(ra) # 536a <exit>
      exit(0);
    1a30:	00004097          	auipc	ra,0x4
    1a34:	93a080e7          	jalr	-1734(ra) # 536a <exit>
        printf("%s: fork failed\n", s);
    1a38:	85ca                	mv	a1,s2
    1a3a:	00004517          	auipc	a0,0x4
    1a3e:	6de50513          	addi	a0,a0,1758 # 6118 <malloc+0x97c>
    1a42:	00004097          	auipc	ra,0x4
    1a46:	ca2080e7          	jalr	-862(ra) # 56e4 <printf>
        exit(1);
    1a4a:	4505                	li	a0,1
    1a4c:	00004097          	auipc	ra,0x4
    1a50:	91e080e7          	jalr	-1762(ra) # 536a <exit>
        exit(0);
    1a54:	00004097          	auipc	ra,0x4
    1a58:	916080e7          	jalr	-1770(ra) # 536a <exit>

0000000000001a5c <forkfork>:
{
    1a5c:	7179                	addi	sp,sp,-48
    1a5e:	f406                	sd	ra,40(sp)
    1a60:	f022                	sd	s0,32(sp)
    1a62:	ec26                	sd	s1,24(sp)
    1a64:	1800                	addi	s0,sp,48
    1a66:	84aa                	mv	s1,a0
    int pid = fork();
    1a68:	00004097          	auipc	ra,0x4
    1a6c:	8fa080e7          	jalr	-1798(ra) # 5362 <fork>
    if(pid < 0){
    1a70:	04054163          	bltz	a0,1ab2 <forkfork+0x56>
    if(pid == 0){
    1a74:	cd29                	beqz	a0,1ace <forkfork+0x72>
    int pid = fork();
    1a76:	00004097          	auipc	ra,0x4
    1a7a:	8ec080e7          	jalr	-1812(ra) # 5362 <fork>
    if(pid < 0){
    1a7e:	02054a63          	bltz	a0,1ab2 <forkfork+0x56>
    if(pid == 0){
    1a82:	c531                	beqz	a0,1ace <forkfork+0x72>
    wait(&xstatus);
    1a84:	fdc40513          	addi	a0,s0,-36
    1a88:	00004097          	auipc	ra,0x4
    1a8c:	8ea080e7          	jalr	-1814(ra) # 5372 <wait>
    if(xstatus != 0) {
    1a90:	fdc42783          	lw	a5,-36(s0)
    1a94:	ebbd                	bnez	a5,1b0a <forkfork+0xae>
    wait(&xstatus);
    1a96:	fdc40513          	addi	a0,s0,-36
    1a9a:	00004097          	auipc	ra,0x4
    1a9e:	8d8080e7          	jalr	-1832(ra) # 5372 <wait>
    if(xstatus != 0) {
    1aa2:	fdc42783          	lw	a5,-36(s0)
    1aa6:	e3b5                	bnez	a5,1b0a <forkfork+0xae>
}
    1aa8:	70a2                	ld	ra,40(sp)
    1aaa:	7402                	ld	s0,32(sp)
    1aac:	64e2                	ld	s1,24(sp)
    1aae:	6145                	addi	sp,sp,48
    1ab0:	8082                	ret
      printf("%s: fork failed", s);
    1ab2:	85a6                	mv	a1,s1
    1ab4:	00005517          	auipc	a0,0x5
    1ab8:	82450513          	addi	a0,a0,-2012 # 62d8 <malloc+0xb3c>
    1abc:	00004097          	auipc	ra,0x4
    1ac0:	c28080e7          	jalr	-984(ra) # 56e4 <printf>
      exit(1);
    1ac4:	4505                	li	a0,1
    1ac6:	00004097          	auipc	ra,0x4
    1aca:	8a4080e7          	jalr	-1884(ra) # 536a <exit>
{
    1ace:	0c800493          	li	s1,200
        int pid1 = fork();
    1ad2:	00004097          	auipc	ra,0x4
    1ad6:	890080e7          	jalr	-1904(ra) # 5362 <fork>
        if(pid1 < 0){
    1ada:	00054f63          	bltz	a0,1af8 <forkfork+0x9c>
        if(pid1 == 0){
    1ade:	c115                	beqz	a0,1b02 <forkfork+0xa6>
        wait(0);
    1ae0:	4501                	li	a0,0
    1ae2:	00004097          	auipc	ra,0x4
    1ae6:	890080e7          	jalr	-1904(ra) # 5372 <wait>
      for(int j = 0; j < 200; j++){
    1aea:	34fd                	addiw	s1,s1,-1
    1aec:	f0fd                	bnez	s1,1ad2 <forkfork+0x76>
      exit(0);
    1aee:	4501                	li	a0,0
    1af0:	00004097          	auipc	ra,0x4
    1af4:	87a080e7          	jalr	-1926(ra) # 536a <exit>
          exit(1);
    1af8:	4505                	li	a0,1
    1afa:	00004097          	auipc	ra,0x4
    1afe:	870080e7          	jalr	-1936(ra) # 536a <exit>
          exit(0);
    1b02:	00004097          	auipc	ra,0x4
    1b06:	868080e7          	jalr	-1944(ra) # 536a <exit>
      printf("%s: fork in child failed", s);
    1b0a:	85a6                	mv	a1,s1
    1b0c:	00004517          	auipc	a0,0x4
    1b10:	7dc50513          	addi	a0,a0,2012 # 62e8 <malloc+0xb4c>
    1b14:	00004097          	auipc	ra,0x4
    1b18:	bd0080e7          	jalr	-1072(ra) # 56e4 <printf>
      exit(1);
    1b1c:	4505                	li	a0,1
    1b1e:	00004097          	auipc	ra,0x4
    1b22:	84c080e7          	jalr	-1972(ra) # 536a <exit>

0000000000001b26 <reparent2>:
{
    1b26:	1101                	addi	sp,sp,-32
    1b28:	ec06                	sd	ra,24(sp)
    1b2a:	e822                	sd	s0,16(sp)
    1b2c:	e426                	sd	s1,8(sp)
    1b2e:	1000                	addi	s0,sp,32
    1b30:	32000493          	li	s1,800
    int pid1 = fork();
    1b34:	00004097          	auipc	ra,0x4
    1b38:	82e080e7          	jalr	-2002(ra) # 5362 <fork>
    if(pid1 < 0){
    1b3c:	00054f63          	bltz	a0,1b5a <reparent2+0x34>
    if(pid1 == 0){
    1b40:	c915                	beqz	a0,1b74 <reparent2+0x4e>
    wait(0);
    1b42:	4501                	li	a0,0
    1b44:	00004097          	auipc	ra,0x4
    1b48:	82e080e7          	jalr	-2002(ra) # 5372 <wait>
  for(int i = 0; i < 800; i++){
    1b4c:	34fd                	addiw	s1,s1,-1
    1b4e:	f0fd                	bnez	s1,1b34 <reparent2+0xe>
  exit(0);
    1b50:	4501                	li	a0,0
    1b52:	00004097          	auipc	ra,0x4
    1b56:	818080e7          	jalr	-2024(ra) # 536a <exit>
      printf("fork failed\n");
    1b5a:	00005517          	auipc	a0,0x5
    1b5e:	9ae50513          	addi	a0,a0,-1618 # 6508 <malloc+0xd6c>
    1b62:	00004097          	auipc	ra,0x4
    1b66:	b82080e7          	jalr	-1150(ra) # 56e4 <printf>
      exit(1);
    1b6a:	4505                	li	a0,1
    1b6c:	00003097          	auipc	ra,0x3
    1b70:	7fe080e7          	jalr	2046(ra) # 536a <exit>
      fork();
    1b74:	00003097          	auipc	ra,0x3
    1b78:	7ee080e7          	jalr	2030(ra) # 5362 <fork>
      fork();
    1b7c:	00003097          	auipc	ra,0x3
    1b80:	7e6080e7          	jalr	2022(ra) # 5362 <fork>
      exit(0);
    1b84:	4501                	li	a0,0
    1b86:	00003097          	auipc	ra,0x3
    1b8a:	7e4080e7          	jalr	2020(ra) # 536a <exit>

0000000000001b8e <createdelete>:
{
    1b8e:	7175                	addi	sp,sp,-144
    1b90:	e506                	sd	ra,136(sp)
    1b92:	e122                	sd	s0,128(sp)
    1b94:	fca6                	sd	s1,120(sp)
    1b96:	f8ca                	sd	s2,112(sp)
    1b98:	f4ce                	sd	s3,104(sp)
    1b9a:	f0d2                	sd	s4,96(sp)
    1b9c:	ecd6                	sd	s5,88(sp)
    1b9e:	e8da                	sd	s6,80(sp)
    1ba0:	e4de                	sd	s7,72(sp)
    1ba2:	e0e2                	sd	s8,64(sp)
    1ba4:	fc66                	sd	s9,56(sp)
    1ba6:	0900                	addi	s0,sp,144
    1ba8:	8caa                	mv	s9,a0
  for(pi = 0; pi < NCHILD; pi++){
    1baa:	4901                	li	s2,0
    1bac:	4991                	li	s3,4
    pid = fork();
    1bae:	00003097          	auipc	ra,0x3
    1bb2:	7b4080e7          	jalr	1972(ra) # 5362 <fork>
    1bb6:	84aa                	mv	s1,a0
    if(pid < 0){
    1bb8:	02054f63          	bltz	a0,1bf6 <createdelete+0x68>
    if(pid == 0){
    1bbc:	c939                	beqz	a0,1c12 <createdelete+0x84>
  for(pi = 0; pi < NCHILD; pi++){
    1bbe:	2905                	addiw	s2,s2,1
    1bc0:	ff3917e3          	bne	s2,s3,1bae <createdelete+0x20>
    1bc4:	4491                	li	s1,4
    wait(&xstatus);
    1bc6:	f7c40513          	addi	a0,s0,-132
    1bca:	00003097          	auipc	ra,0x3
    1bce:	7a8080e7          	jalr	1960(ra) # 5372 <wait>
    if(xstatus != 0)
    1bd2:	f7c42903          	lw	s2,-132(s0)
    1bd6:	0e091263          	bnez	s2,1cba <createdelete+0x12c>
  for(pi = 0; pi < NCHILD; pi++){
    1bda:	34fd                	addiw	s1,s1,-1
    1bdc:	f4ed                	bnez	s1,1bc6 <createdelete+0x38>
  name[0] = name[1] = name[2] = 0;
    1bde:	f8040123          	sb	zero,-126(s0)
    1be2:	03000993          	li	s3,48
    1be6:	5a7d                	li	s4,-1
    1be8:	07000c13          	li	s8,112
      } else if((i >= 1 && i < N/2) && fd >= 0){
    1bec:	4b21                	li	s6,8
      if((i == 0 || i >= N/2) && fd < 0){
    1bee:	4ba5                	li	s7,9
    for(pi = 0; pi < NCHILD; pi++){
    1bf0:	07400a93          	li	s5,116
    1bf4:	a29d                	j	1d5a <createdelete+0x1cc>
      printf("fork failed\n", s);
    1bf6:	85e6                	mv	a1,s9
    1bf8:	00005517          	auipc	a0,0x5
    1bfc:	91050513          	addi	a0,a0,-1776 # 6508 <malloc+0xd6c>
    1c00:	00004097          	auipc	ra,0x4
    1c04:	ae4080e7          	jalr	-1308(ra) # 56e4 <printf>
      exit(1);
    1c08:	4505                	li	a0,1
    1c0a:	00003097          	auipc	ra,0x3
    1c0e:	760080e7          	jalr	1888(ra) # 536a <exit>
      name[0] = 'p' + pi;
    1c12:	0709091b          	addiw	s2,s2,112
    1c16:	f9240023          	sb	s2,-128(s0)
      name[2] = '\0';
    1c1a:	f8040123          	sb	zero,-126(s0)
      for(i = 0; i < N; i++){
    1c1e:	4951                	li	s2,20
    1c20:	a015                	j	1c44 <createdelete+0xb6>
          printf("%s: create failed\n", s);
    1c22:	85e6                	mv	a1,s9
    1c24:	00004517          	auipc	a0,0x4
    1c28:	58c50513          	addi	a0,a0,1420 # 61b0 <malloc+0xa14>
    1c2c:	00004097          	auipc	ra,0x4
    1c30:	ab8080e7          	jalr	-1352(ra) # 56e4 <printf>
          exit(1);
    1c34:	4505                	li	a0,1
    1c36:	00003097          	auipc	ra,0x3
    1c3a:	734080e7          	jalr	1844(ra) # 536a <exit>
      for(i = 0; i < N; i++){
    1c3e:	2485                	addiw	s1,s1,1
    1c40:	07248863          	beq	s1,s2,1cb0 <createdelete+0x122>
        name[1] = '0' + i;
    1c44:	0304879b          	addiw	a5,s1,48
    1c48:	f8f400a3          	sb	a5,-127(s0)
        fd = open(name, O_CREATE | O_RDWR);
    1c4c:	20200593          	li	a1,514
    1c50:	f8040513          	addi	a0,s0,-128
    1c54:	00003097          	auipc	ra,0x3
    1c58:	756080e7          	jalr	1878(ra) # 53aa <open>
        if(fd < 0){
    1c5c:	fc0543e3          	bltz	a0,1c22 <createdelete+0x94>
        close(fd);
    1c60:	00003097          	auipc	ra,0x3
    1c64:	732080e7          	jalr	1842(ra) # 5392 <close>
        if(i > 0 && (i % 2 ) == 0){
    1c68:	fc905be3          	blez	s1,1c3e <createdelete+0xb0>
    1c6c:	0014f793          	andi	a5,s1,1
    1c70:	f7f9                	bnez	a5,1c3e <createdelete+0xb0>
          name[1] = '0' + (i / 2);
    1c72:	01f4d79b          	srliw	a5,s1,0x1f
    1c76:	9fa5                	addw	a5,a5,s1
    1c78:	4017d79b          	sraiw	a5,a5,0x1
    1c7c:	0307879b          	addiw	a5,a5,48
    1c80:	f8f400a3          	sb	a5,-127(s0)
          if(unlink(name) < 0){
    1c84:	f8040513          	addi	a0,s0,-128
    1c88:	00003097          	auipc	ra,0x3
    1c8c:	732080e7          	jalr	1842(ra) # 53ba <unlink>
    1c90:	fa0557e3          	bgez	a0,1c3e <createdelete+0xb0>
            printf("%s: unlink failed\n", s);
    1c94:	85e6                	mv	a1,s9
    1c96:	00004517          	auipc	a0,0x4
    1c9a:	67250513          	addi	a0,a0,1650 # 6308 <malloc+0xb6c>
    1c9e:	00004097          	auipc	ra,0x4
    1ca2:	a46080e7          	jalr	-1466(ra) # 56e4 <printf>
            exit(1);
    1ca6:	4505                	li	a0,1
    1ca8:	00003097          	auipc	ra,0x3
    1cac:	6c2080e7          	jalr	1730(ra) # 536a <exit>
      exit(0);
    1cb0:	4501                	li	a0,0
    1cb2:	00003097          	auipc	ra,0x3
    1cb6:	6b8080e7          	jalr	1720(ra) # 536a <exit>
      exit(1);
    1cba:	4505                	li	a0,1
    1cbc:	00003097          	auipc	ra,0x3
    1cc0:	6ae080e7          	jalr	1710(ra) # 536a <exit>
        printf("%s: oops createdelete %s didn't exist\n", s, name);
    1cc4:	f8040613          	addi	a2,s0,-128
    1cc8:	85e6                	mv	a1,s9
    1cca:	00004517          	auipc	a0,0x4
    1cce:	65650513          	addi	a0,a0,1622 # 6320 <malloc+0xb84>
    1cd2:	00004097          	auipc	ra,0x4
    1cd6:	a12080e7          	jalr	-1518(ra) # 56e4 <printf>
        exit(1);
    1cda:	4505                	li	a0,1
    1cdc:	00003097          	auipc	ra,0x3
    1ce0:	68e080e7          	jalr	1678(ra) # 536a <exit>
      } else if((i >= 1 && i < N/2) && fd >= 0){
    1ce4:	054b7163          	bgeu	s6,s4,1d26 <createdelete+0x198>
      if(fd >= 0)
    1ce8:	02055a63          	bgez	a0,1d1c <createdelete+0x18e>
    for(pi = 0; pi < NCHILD; pi++){
    1cec:	2485                	addiw	s1,s1,1
    1cee:	0ff4f493          	zext.b	s1,s1
    1cf2:	05548c63          	beq	s1,s5,1d4a <createdelete+0x1bc>
      name[0] = 'p' + pi;
    1cf6:	f8940023          	sb	s1,-128(s0)
      name[1] = '0' + i;
    1cfa:	f93400a3          	sb	s3,-127(s0)
      fd = open(name, 0);
    1cfe:	4581                	li	a1,0
    1d00:	f8040513          	addi	a0,s0,-128
    1d04:	00003097          	auipc	ra,0x3
    1d08:	6a6080e7          	jalr	1702(ra) # 53aa <open>
      if((i == 0 || i >= N/2) && fd < 0){
    1d0c:	00090463          	beqz	s2,1d14 <createdelete+0x186>
    1d10:	fd2bdae3          	bge	s7,s2,1ce4 <createdelete+0x156>
    1d14:	fa0548e3          	bltz	a0,1cc4 <createdelete+0x136>
      } else if((i >= 1 && i < N/2) && fd >= 0){
    1d18:	014b7963          	bgeu	s6,s4,1d2a <createdelete+0x19c>
        close(fd);
    1d1c:	00003097          	auipc	ra,0x3
    1d20:	676080e7          	jalr	1654(ra) # 5392 <close>
    1d24:	b7e1                	j	1cec <createdelete+0x15e>
      } else if((i >= 1 && i < N/2) && fd >= 0){
    1d26:	fc0543e3          	bltz	a0,1cec <createdelete+0x15e>
        printf("%s: oops createdelete %s did exist\n", s, name);
    1d2a:	f8040613          	addi	a2,s0,-128
    1d2e:	85e6                	mv	a1,s9
    1d30:	00004517          	auipc	a0,0x4
    1d34:	61850513          	addi	a0,a0,1560 # 6348 <malloc+0xbac>
    1d38:	00004097          	auipc	ra,0x4
    1d3c:	9ac080e7          	jalr	-1620(ra) # 56e4 <printf>
        exit(1);
    1d40:	4505                	li	a0,1
    1d42:	00003097          	auipc	ra,0x3
    1d46:	628080e7          	jalr	1576(ra) # 536a <exit>
  for(i = 0; i < N; i++){
    1d4a:	2905                	addiw	s2,s2,1
    1d4c:	2a05                	addiw	s4,s4,1
    1d4e:	2985                	addiw	s3,s3,1
    1d50:	0ff9f993          	zext.b	s3,s3
    1d54:	47d1                	li	a5,20
    1d56:	02f90a63          	beq	s2,a5,1d8a <createdelete+0x1fc>
    for(pi = 0; pi < NCHILD; pi++){
    1d5a:	84e2                	mv	s1,s8
    1d5c:	bf69                	j	1cf6 <createdelete+0x168>
  for(i = 0; i < N; i++){
    1d5e:	2905                	addiw	s2,s2,1
    1d60:	0ff97913          	zext.b	s2,s2
    1d64:	2985                	addiw	s3,s3,1
    1d66:	0ff9f993          	zext.b	s3,s3
    1d6a:	03490863          	beq	s2,s4,1d9a <createdelete+0x20c>
  name[0] = name[1] = name[2] = 0;
    1d6e:	84d6                	mv	s1,s5
      name[0] = 'p' + i;
    1d70:	f9240023          	sb	s2,-128(s0)
      name[1] = '0' + i;
    1d74:	f93400a3          	sb	s3,-127(s0)
      unlink(name);
    1d78:	f8040513          	addi	a0,s0,-128
    1d7c:	00003097          	auipc	ra,0x3
    1d80:	63e080e7          	jalr	1598(ra) # 53ba <unlink>
    for(pi = 0; pi < NCHILD; pi++){
    1d84:	34fd                	addiw	s1,s1,-1
    1d86:	f4ed                	bnez	s1,1d70 <createdelete+0x1e2>
    1d88:	bfd9                	j	1d5e <createdelete+0x1d0>
    1d8a:	03000993          	li	s3,48
    1d8e:	07000913          	li	s2,112
  name[0] = name[1] = name[2] = 0;
    1d92:	4a91                	li	s5,4
  for(i = 0; i < N; i++){
    1d94:	08400a13          	li	s4,132
    1d98:	bfd9                	j	1d6e <createdelete+0x1e0>
}
    1d9a:	60aa                	ld	ra,136(sp)
    1d9c:	640a                	ld	s0,128(sp)
    1d9e:	74e6                	ld	s1,120(sp)
    1da0:	7946                	ld	s2,112(sp)
    1da2:	79a6                	ld	s3,104(sp)
    1da4:	7a06                	ld	s4,96(sp)
    1da6:	6ae6                	ld	s5,88(sp)
    1da8:	6b46                	ld	s6,80(sp)
    1daa:	6ba6                	ld	s7,72(sp)
    1dac:	6c06                	ld	s8,64(sp)
    1dae:	7ce2                	ld	s9,56(sp)
    1db0:	6149                	addi	sp,sp,144
    1db2:	8082                	ret

0000000000001db4 <linkunlink>:
{
    1db4:	711d                	addi	sp,sp,-96
    1db6:	ec86                	sd	ra,88(sp)
    1db8:	e8a2                	sd	s0,80(sp)
    1dba:	e4a6                	sd	s1,72(sp)
    1dbc:	e0ca                	sd	s2,64(sp)
    1dbe:	fc4e                	sd	s3,56(sp)
    1dc0:	f852                	sd	s4,48(sp)
    1dc2:	f456                	sd	s5,40(sp)
    1dc4:	f05a                	sd	s6,32(sp)
    1dc6:	ec5e                	sd	s7,24(sp)
    1dc8:	e862                	sd	s8,16(sp)
    1dca:	e466                	sd	s9,8(sp)
    1dcc:	1080                	addi	s0,sp,96
    1dce:	84aa                	mv	s1,a0
  unlink("x");
    1dd0:	00004517          	auipc	a0,0x4
    1dd4:	b6050513          	addi	a0,a0,-1184 # 5930 <malloc+0x194>
    1dd8:	00003097          	auipc	ra,0x3
    1ddc:	5e2080e7          	jalr	1506(ra) # 53ba <unlink>
  pid = fork();
    1de0:	00003097          	auipc	ra,0x3
    1de4:	582080e7          	jalr	1410(ra) # 5362 <fork>
  if(pid < 0){
    1de8:	02054b63          	bltz	a0,1e1e <linkunlink+0x6a>
    1dec:	8c2a                	mv	s8,a0
  unsigned int x = (pid ? 1 : 97);
    1dee:	4c85                	li	s9,1
    1df0:	e119                	bnez	a0,1df6 <linkunlink+0x42>
    1df2:	06100c93          	li	s9,97
    1df6:	06400493          	li	s1,100
    x = x * 1103515245 + 12345;
    1dfa:	41c659b7          	lui	s3,0x41c65
    1dfe:	e6d9899b          	addiw	s3,s3,-403 # 41c64e6d <__BSS_END__+0x41c566dd>
    1e02:	690d                	lui	s2,0x3
    1e04:	0399091b          	addiw	s2,s2,57 # 3039 <subdir+0x363>
    if((x % 3) == 0){
    1e08:	4a0d                	li	s4,3
    } else if((x % 3) == 1){
    1e0a:	4b05                	li	s6,1
      unlink("x");
    1e0c:	00004a97          	auipc	s5,0x4
    1e10:	b24a8a93          	addi	s5,s5,-1244 # 5930 <malloc+0x194>
      link("cat", "x");
    1e14:	00004b97          	auipc	s7,0x4
    1e18:	55cb8b93          	addi	s7,s7,1372 # 6370 <malloc+0xbd4>
    1e1c:	a825                	j	1e54 <linkunlink+0xa0>
    printf("%s: fork failed\n", s);
    1e1e:	85a6                	mv	a1,s1
    1e20:	00004517          	auipc	a0,0x4
    1e24:	2f850513          	addi	a0,a0,760 # 6118 <malloc+0x97c>
    1e28:	00004097          	auipc	ra,0x4
    1e2c:	8bc080e7          	jalr	-1860(ra) # 56e4 <printf>
    exit(1);
    1e30:	4505                	li	a0,1
    1e32:	00003097          	auipc	ra,0x3
    1e36:	538080e7          	jalr	1336(ra) # 536a <exit>
      close(open("x", O_RDWR | O_CREATE));
    1e3a:	20200593          	li	a1,514
    1e3e:	8556                	mv	a0,s5
    1e40:	00003097          	auipc	ra,0x3
    1e44:	56a080e7          	jalr	1386(ra) # 53aa <open>
    1e48:	00003097          	auipc	ra,0x3
    1e4c:	54a080e7          	jalr	1354(ra) # 5392 <close>
  for(i = 0; i < 100; i++){
    1e50:	34fd                	addiw	s1,s1,-1
    1e52:	c88d                	beqz	s1,1e84 <linkunlink+0xd0>
    x = x * 1103515245 + 12345;
    1e54:	033c87bb          	mulw	a5,s9,s3
    1e58:	012787bb          	addw	a5,a5,s2
    1e5c:	00078c9b          	sext.w	s9,a5
    if((x % 3) == 0){
    1e60:	0347f7bb          	remuw	a5,a5,s4
    1e64:	dbf9                	beqz	a5,1e3a <linkunlink+0x86>
    } else if((x % 3) == 1){
    1e66:	01678863          	beq	a5,s6,1e76 <linkunlink+0xc2>
      unlink("x");
    1e6a:	8556                	mv	a0,s5
    1e6c:	00003097          	auipc	ra,0x3
    1e70:	54e080e7          	jalr	1358(ra) # 53ba <unlink>
    1e74:	bff1                	j	1e50 <linkunlink+0x9c>
      link("cat", "x");
    1e76:	85d6                	mv	a1,s5
    1e78:	855e                	mv	a0,s7
    1e7a:	00003097          	auipc	ra,0x3
    1e7e:	550080e7          	jalr	1360(ra) # 53ca <link>
    1e82:	b7f9                	j	1e50 <linkunlink+0x9c>
  if(pid)
    1e84:	020c0463          	beqz	s8,1eac <linkunlink+0xf8>
    wait(0);
    1e88:	4501                	li	a0,0
    1e8a:	00003097          	auipc	ra,0x3
    1e8e:	4e8080e7          	jalr	1256(ra) # 5372 <wait>
}
    1e92:	60e6                	ld	ra,88(sp)
    1e94:	6446                	ld	s0,80(sp)
    1e96:	64a6                	ld	s1,72(sp)
    1e98:	6906                	ld	s2,64(sp)
    1e9a:	79e2                	ld	s3,56(sp)
    1e9c:	7a42                	ld	s4,48(sp)
    1e9e:	7aa2                	ld	s5,40(sp)
    1ea0:	7b02                	ld	s6,32(sp)
    1ea2:	6be2                	ld	s7,24(sp)
    1ea4:	6c42                	ld	s8,16(sp)
    1ea6:	6ca2                	ld	s9,8(sp)
    1ea8:	6125                	addi	sp,sp,96
    1eaa:	8082                	ret
    exit(0);
    1eac:	4501                	li	a0,0
    1eae:	00003097          	auipc	ra,0x3
    1eb2:	4bc080e7          	jalr	1212(ra) # 536a <exit>

0000000000001eb6 <forktest>:
{
    1eb6:	7179                	addi	sp,sp,-48
    1eb8:	f406                	sd	ra,40(sp)
    1eba:	f022                	sd	s0,32(sp)
    1ebc:	ec26                	sd	s1,24(sp)
    1ebe:	e84a                	sd	s2,16(sp)
    1ec0:	e44e                	sd	s3,8(sp)
    1ec2:	1800                	addi	s0,sp,48
    1ec4:	89aa                	mv	s3,a0
  for(n=0; n<N; n++){
    1ec6:	4481                	li	s1,0
    1ec8:	3e800913          	li	s2,1000
    pid = fork();
    1ecc:	00003097          	auipc	ra,0x3
    1ed0:	496080e7          	jalr	1174(ra) # 5362 <fork>
    if(pid < 0)
    1ed4:	02054863          	bltz	a0,1f04 <forktest+0x4e>
    if(pid == 0)
    1ed8:	c115                	beqz	a0,1efc <forktest+0x46>
  for(n=0; n<N; n++){
    1eda:	2485                	addiw	s1,s1,1
    1edc:	ff2498e3          	bne	s1,s2,1ecc <forktest+0x16>
    printf("%s: fork claimed to work 1000 times!\n", s);
    1ee0:	85ce                	mv	a1,s3
    1ee2:	00004517          	auipc	a0,0x4
    1ee6:	4ae50513          	addi	a0,a0,1198 # 6390 <malloc+0xbf4>
    1eea:	00003097          	auipc	ra,0x3
    1eee:	7fa080e7          	jalr	2042(ra) # 56e4 <printf>
    exit(1);
    1ef2:	4505                	li	a0,1
    1ef4:	00003097          	auipc	ra,0x3
    1ef8:	476080e7          	jalr	1142(ra) # 536a <exit>
      exit(0);
    1efc:	00003097          	auipc	ra,0x3
    1f00:	46e080e7          	jalr	1134(ra) # 536a <exit>
  if (n == 0) {
    1f04:	cc9d                	beqz	s1,1f42 <forktest+0x8c>
  if(n == N){
    1f06:	3e800793          	li	a5,1000
    1f0a:	fcf48be3          	beq	s1,a5,1ee0 <forktest+0x2a>
  for(; n > 0; n--){
    1f0e:	00905b63          	blez	s1,1f24 <forktest+0x6e>
    if(wait(0) < 0){
    1f12:	4501                	li	a0,0
    1f14:	00003097          	auipc	ra,0x3
    1f18:	45e080e7          	jalr	1118(ra) # 5372 <wait>
    1f1c:	04054163          	bltz	a0,1f5e <forktest+0xa8>
  for(; n > 0; n--){
    1f20:	34fd                	addiw	s1,s1,-1
    1f22:	f8e5                	bnez	s1,1f12 <forktest+0x5c>
  if(wait(0) != -1){
    1f24:	4501                	li	a0,0
    1f26:	00003097          	auipc	ra,0x3
    1f2a:	44c080e7          	jalr	1100(ra) # 5372 <wait>
    1f2e:	57fd                	li	a5,-1
    1f30:	04f51563          	bne	a0,a5,1f7a <forktest+0xc4>
}
    1f34:	70a2                	ld	ra,40(sp)
    1f36:	7402                	ld	s0,32(sp)
    1f38:	64e2                	ld	s1,24(sp)
    1f3a:	6942                	ld	s2,16(sp)
    1f3c:	69a2                	ld	s3,8(sp)
    1f3e:	6145                	addi	sp,sp,48
    1f40:	8082                	ret
    printf("%s: no fork at all!\n", s);
    1f42:	85ce                	mv	a1,s3
    1f44:	00004517          	auipc	a0,0x4
    1f48:	43450513          	addi	a0,a0,1076 # 6378 <malloc+0xbdc>
    1f4c:	00003097          	auipc	ra,0x3
    1f50:	798080e7          	jalr	1944(ra) # 56e4 <printf>
    exit(1);
    1f54:	4505                	li	a0,1
    1f56:	00003097          	auipc	ra,0x3
    1f5a:	414080e7          	jalr	1044(ra) # 536a <exit>
      printf("%s: wait stopped early\n", s);
    1f5e:	85ce                	mv	a1,s3
    1f60:	00004517          	auipc	a0,0x4
    1f64:	45850513          	addi	a0,a0,1112 # 63b8 <malloc+0xc1c>
    1f68:	00003097          	auipc	ra,0x3
    1f6c:	77c080e7          	jalr	1916(ra) # 56e4 <printf>
      exit(1);
    1f70:	4505                	li	a0,1
    1f72:	00003097          	auipc	ra,0x3
    1f76:	3f8080e7          	jalr	1016(ra) # 536a <exit>
    printf("%s: wait got too many\n", s);
    1f7a:	85ce                	mv	a1,s3
    1f7c:	00004517          	auipc	a0,0x4
    1f80:	45450513          	addi	a0,a0,1108 # 63d0 <malloc+0xc34>
    1f84:	00003097          	auipc	ra,0x3
    1f88:	760080e7          	jalr	1888(ra) # 56e4 <printf>
    exit(1);
    1f8c:	4505                	li	a0,1
    1f8e:	00003097          	auipc	ra,0x3
    1f92:	3dc080e7          	jalr	988(ra) # 536a <exit>

0000000000001f96 <kernmem>:
{
    1f96:	715d                	addi	sp,sp,-80
    1f98:	e486                	sd	ra,72(sp)
    1f9a:	e0a2                	sd	s0,64(sp)
    1f9c:	fc26                	sd	s1,56(sp)
    1f9e:	f84a                	sd	s2,48(sp)
    1fa0:	f44e                	sd	s3,40(sp)
    1fa2:	f052                	sd	s4,32(sp)
    1fa4:	ec56                	sd	s5,24(sp)
    1fa6:	0880                	addi	s0,sp,80
    1fa8:	8a2a                	mv	s4,a0
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    1faa:	4485                	li	s1,1
    1fac:	04fe                	slli	s1,s1,0x1f
    if(xstatus != -1)  // did kernel kill child?
    1fae:	5afd                	li	s5,-1
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    1fb0:	69b1                	lui	s3,0xc
    1fb2:	35098993          	addi	s3,s3,848 # c350 <buf+0xbd0>
    1fb6:	1003d937          	lui	s2,0x1003d
    1fba:	090e                	slli	s2,s2,0x3
    1fbc:	48090913          	addi	s2,s2,1152 # 1003d480 <__BSS_END__+0x1002ecf0>
    pid = fork();
    1fc0:	00003097          	auipc	ra,0x3
    1fc4:	3a2080e7          	jalr	930(ra) # 5362 <fork>
    if(pid < 0){
    1fc8:	02054963          	bltz	a0,1ffa <kernmem+0x64>
    if(pid == 0){
    1fcc:	c529                	beqz	a0,2016 <kernmem+0x80>
    wait(&xstatus);
    1fce:	fbc40513          	addi	a0,s0,-68
    1fd2:	00003097          	auipc	ra,0x3
    1fd6:	3a0080e7          	jalr	928(ra) # 5372 <wait>
    if(xstatus != -1)  // did kernel kill child?
    1fda:	fbc42783          	lw	a5,-68(s0)
    1fde:	05579c63          	bne	a5,s5,2036 <kernmem+0xa0>
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    1fe2:	94ce                	add	s1,s1,s3
    1fe4:	fd249ee3          	bne	s1,s2,1fc0 <kernmem+0x2a>
}
    1fe8:	60a6                	ld	ra,72(sp)
    1fea:	6406                	ld	s0,64(sp)
    1fec:	74e2                	ld	s1,56(sp)
    1fee:	7942                	ld	s2,48(sp)
    1ff0:	79a2                	ld	s3,40(sp)
    1ff2:	7a02                	ld	s4,32(sp)
    1ff4:	6ae2                	ld	s5,24(sp)
    1ff6:	6161                	addi	sp,sp,80
    1ff8:	8082                	ret
      printf("%s: fork failed\n", s);
    1ffa:	85d2                	mv	a1,s4
    1ffc:	00004517          	auipc	a0,0x4
    2000:	11c50513          	addi	a0,a0,284 # 6118 <malloc+0x97c>
    2004:	00003097          	auipc	ra,0x3
    2008:	6e0080e7          	jalr	1760(ra) # 56e4 <printf>
      exit(1);
    200c:	4505                	li	a0,1
    200e:	00003097          	auipc	ra,0x3
    2012:	35c080e7          	jalr	860(ra) # 536a <exit>
      printf("%s: oops could read %x = %x\n", a, *a);
    2016:	0004c603          	lbu	a2,0(s1)
    201a:	85a6                	mv	a1,s1
    201c:	00004517          	auipc	a0,0x4
    2020:	3cc50513          	addi	a0,a0,972 # 63e8 <malloc+0xc4c>
    2024:	00003097          	auipc	ra,0x3
    2028:	6c0080e7          	jalr	1728(ra) # 56e4 <printf>
      exit(1);
    202c:	4505                	li	a0,1
    202e:	00003097          	auipc	ra,0x3
    2032:	33c080e7          	jalr	828(ra) # 536a <exit>
      exit(1);
    2036:	4505                	li	a0,1
    2038:	00003097          	auipc	ra,0x3
    203c:	332080e7          	jalr	818(ra) # 536a <exit>

0000000000002040 <bigargtest>:
{
    2040:	7179                	addi	sp,sp,-48
    2042:	f406                	sd	ra,40(sp)
    2044:	f022                	sd	s0,32(sp)
    2046:	ec26                	sd	s1,24(sp)
    2048:	1800                	addi	s0,sp,48
    204a:	84aa                	mv	s1,a0
  unlink("bigarg-ok");
    204c:	00004517          	auipc	a0,0x4
    2050:	3bc50513          	addi	a0,a0,956 # 6408 <malloc+0xc6c>
    2054:	00003097          	auipc	ra,0x3
    2058:	366080e7          	jalr	870(ra) # 53ba <unlink>
  pid = fork();
    205c:	00003097          	auipc	ra,0x3
    2060:	306080e7          	jalr	774(ra) # 5362 <fork>
  if(pid == 0){
    2064:	c121                	beqz	a0,20a4 <bigargtest+0x64>
  } else if(pid < 0){
    2066:	0a054063          	bltz	a0,2106 <bigargtest+0xc6>
  wait(&xstatus);
    206a:	fdc40513          	addi	a0,s0,-36
    206e:	00003097          	auipc	ra,0x3
    2072:	304080e7          	jalr	772(ra) # 5372 <wait>
  if(xstatus != 0)
    2076:	fdc42503          	lw	a0,-36(s0)
    207a:	e545                	bnez	a0,2122 <bigargtest+0xe2>
  fd = open("bigarg-ok", 0);
    207c:	4581                	li	a1,0
    207e:	00004517          	auipc	a0,0x4
    2082:	38a50513          	addi	a0,a0,906 # 6408 <malloc+0xc6c>
    2086:	00003097          	auipc	ra,0x3
    208a:	324080e7          	jalr	804(ra) # 53aa <open>
  if(fd < 0){
    208e:	08054e63          	bltz	a0,212a <bigargtest+0xea>
  close(fd);
    2092:	00003097          	auipc	ra,0x3
    2096:	300080e7          	jalr	768(ra) # 5392 <close>
}
    209a:	70a2                	ld	ra,40(sp)
    209c:	7402                	ld	s0,32(sp)
    209e:	64e2                	ld	s1,24(sp)
    20a0:	6145                	addi	sp,sp,48
    20a2:	8082                	ret
    20a4:	00006797          	auipc	a5,0x6
    20a8:	ec478793          	addi	a5,a5,-316 # 7f68 <args.1>
    20ac:	00006697          	auipc	a3,0x6
    20b0:	fb468693          	addi	a3,a3,-76 # 8060 <args.1+0xf8>
      args[i] = "bigargs test: failed\n                                                                                                                                                                                                       ";
    20b4:	00004717          	auipc	a4,0x4
    20b8:	36470713          	addi	a4,a4,868 # 6418 <malloc+0xc7c>
    20bc:	e398                	sd	a4,0(a5)
    for(i = 0; i < MAXARG-1; i++)
    20be:	07a1                	addi	a5,a5,8
    20c0:	fed79ee3          	bne	a5,a3,20bc <bigargtest+0x7c>
    args[MAXARG-1] = 0;
    20c4:	00006597          	auipc	a1,0x6
    20c8:	ea458593          	addi	a1,a1,-348 # 7f68 <args.1>
    20cc:	0e05bc23          	sd	zero,248(a1)
    exec("echo", args);
    20d0:	00003517          	auipc	a0,0x3
    20d4:	7f050513          	addi	a0,a0,2032 # 58c0 <malloc+0x124>
    20d8:	00003097          	auipc	ra,0x3
    20dc:	2ca080e7          	jalr	714(ra) # 53a2 <exec>
    fd = open("bigarg-ok", O_CREATE);
    20e0:	20000593          	li	a1,512
    20e4:	00004517          	auipc	a0,0x4
    20e8:	32450513          	addi	a0,a0,804 # 6408 <malloc+0xc6c>
    20ec:	00003097          	auipc	ra,0x3
    20f0:	2be080e7          	jalr	702(ra) # 53aa <open>
    close(fd);
    20f4:	00003097          	auipc	ra,0x3
    20f8:	29e080e7          	jalr	670(ra) # 5392 <close>
    exit(0);
    20fc:	4501                	li	a0,0
    20fe:	00003097          	auipc	ra,0x3
    2102:	26c080e7          	jalr	620(ra) # 536a <exit>
    printf("%s: bigargtest: fork failed\n", s);
    2106:	85a6                	mv	a1,s1
    2108:	00004517          	auipc	a0,0x4
    210c:	3f050513          	addi	a0,a0,1008 # 64f8 <malloc+0xd5c>
    2110:	00003097          	auipc	ra,0x3
    2114:	5d4080e7          	jalr	1492(ra) # 56e4 <printf>
    exit(1);
    2118:	4505                	li	a0,1
    211a:	00003097          	auipc	ra,0x3
    211e:	250080e7          	jalr	592(ra) # 536a <exit>
    exit(xstatus);
    2122:	00003097          	auipc	ra,0x3
    2126:	248080e7          	jalr	584(ra) # 536a <exit>
    printf("%s: bigarg test failed!\n", s);
    212a:	85a6                	mv	a1,s1
    212c:	00004517          	auipc	a0,0x4
    2130:	3ec50513          	addi	a0,a0,1004 # 6518 <malloc+0xd7c>
    2134:	00003097          	auipc	ra,0x3
    2138:	5b0080e7          	jalr	1456(ra) # 56e4 <printf>
    exit(1);
    213c:	4505                	li	a0,1
    213e:	00003097          	auipc	ra,0x3
    2142:	22c080e7          	jalr	556(ra) # 536a <exit>

0000000000002146 <stacktest>:
{
    2146:	7179                	addi	sp,sp,-48
    2148:	f406                	sd	ra,40(sp)
    214a:	f022                	sd	s0,32(sp)
    214c:	ec26                	sd	s1,24(sp)
    214e:	1800                	addi	s0,sp,48
    2150:	84aa                	mv	s1,a0
  pid = fork();
    2152:	00003097          	auipc	ra,0x3
    2156:	210080e7          	jalr	528(ra) # 5362 <fork>
  if(pid == 0) {
    215a:	c115                	beqz	a0,217e <stacktest+0x38>
  } else if(pid < 0){
    215c:	04054363          	bltz	a0,21a2 <stacktest+0x5c>
  wait(&xstatus);
    2160:	fdc40513          	addi	a0,s0,-36
    2164:	00003097          	auipc	ra,0x3
    2168:	20e080e7          	jalr	526(ra) # 5372 <wait>
  if(xstatus == -1)  // kernel killed child?
    216c:	fdc42503          	lw	a0,-36(s0)
    2170:	57fd                	li	a5,-1
    2172:	04f50663          	beq	a0,a5,21be <stacktest+0x78>
    exit(xstatus);
    2176:	00003097          	auipc	ra,0x3
    217a:	1f4080e7          	jalr	500(ra) # 536a <exit>

static inline uint64
r_sp()
{
  uint64 x;
  asm volatile("mv %0, sp" : "=r" (x) );
    217e:	870a                	mv	a4,sp
    printf("%s: stacktest: read below stack %p\n", *sp);
    2180:	77fd                	lui	a5,0xfffff
    2182:	97ba                	add	a5,a5,a4
    2184:	0007c583          	lbu	a1,0(a5) # fffffffffffff000 <__BSS_END__+0xffffffffffff0870>
    2188:	00004517          	auipc	a0,0x4
    218c:	3b050513          	addi	a0,a0,944 # 6538 <malloc+0xd9c>
    2190:	00003097          	auipc	ra,0x3
    2194:	554080e7          	jalr	1364(ra) # 56e4 <printf>
    exit(1);
    2198:	4505                	li	a0,1
    219a:	00003097          	auipc	ra,0x3
    219e:	1d0080e7          	jalr	464(ra) # 536a <exit>
    printf("%s: fork failed\n", s);
    21a2:	85a6                	mv	a1,s1
    21a4:	00004517          	auipc	a0,0x4
    21a8:	f7450513          	addi	a0,a0,-140 # 6118 <malloc+0x97c>
    21ac:	00003097          	auipc	ra,0x3
    21b0:	538080e7          	jalr	1336(ra) # 56e4 <printf>
    exit(1);
    21b4:	4505                	li	a0,1
    21b6:	00003097          	auipc	ra,0x3
    21ba:	1b4080e7          	jalr	436(ra) # 536a <exit>
    exit(0);
    21be:	4501                	li	a0,0
    21c0:	00003097          	auipc	ra,0x3
    21c4:	1aa080e7          	jalr	426(ra) # 536a <exit>

00000000000021c8 <copyinstr3>:
{
    21c8:	7179                	addi	sp,sp,-48
    21ca:	f406                	sd	ra,40(sp)
    21cc:	f022                	sd	s0,32(sp)
    21ce:	ec26                	sd	s1,24(sp)
    21d0:	1800                	addi	s0,sp,48
  sbrk(8192);
    21d2:	6509                	lui	a0,0x2
    21d4:	00003097          	auipc	ra,0x3
    21d8:	21e080e7          	jalr	542(ra) # 53f2 <sbrk>
  uint64 top = (uint64) sbrk(0);
    21dc:	4501                	li	a0,0
    21de:	00003097          	auipc	ra,0x3
    21e2:	214080e7          	jalr	532(ra) # 53f2 <sbrk>
  if((top % PGSIZE) != 0){
    21e6:	03451793          	slli	a5,a0,0x34
    21ea:	e3c9                	bnez	a5,226c <copyinstr3+0xa4>
  top = (uint64) sbrk(0);
    21ec:	4501                	li	a0,0
    21ee:	00003097          	auipc	ra,0x3
    21f2:	204080e7          	jalr	516(ra) # 53f2 <sbrk>
  if(top % PGSIZE){
    21f6:	03451793          	slli	a5,a0,0x34
    21fa:	e3d9                	bnez	a5,2280 <copyinstr3+0xb8>
  char *b = (char *) (top - 1);
    21fc:	fff50493          	addi	s1,a0,-1 # 1fff <kernmem+0x69>
  *b = 'x';
    2200:	07800793          	li	a5,120
    2204:	fef50fa3          	sb	a5,-1(a0)
  int ret = unlink(b);
    2208:	8526                	mv	a0,s1
    220a:	00003097          	auipc	ra,0x3
    220e:	1b0080e7          	jalr	432(ra) # 53ba <unlink>
  if(ret != -1){
    2212:	57fd                	li	a5,-1
    2214:	08f51363          	bne	a0,a5,229a <copyinstr3+0xd2>
  int fd = open(b, O_CREATE | O_WRONLY);
    2218:	20100593          	li	a1,513
    221c:	8526                	mv	a0,s1
    221e:	00003097          	auipc	ra,0x3
    2222:	18c080e7          	jalr	396(ra) # 53aa <open>
  if(fd != -1){
    2226:	57fd                	li	a5,-1
    2228:	08f51863          	bne	a0,a5,22b8 <copyinstr3+0xf0>
  ret = link(b, b);
    222c:	85a6                	mv	a1,s1
    222e:	8526                	mv	a0,s1
    2230:	00003097          	auipc	ra,0x3
    2234:	19a080e7          	jalr	410(ra) # 53ca <link>
  if(ret != -1){
    2238:	57fd                	li	a5,-1
    223a:	08f51e63          	bne	a0,a5,22d6 <copyinstr3+0x10e>
  char *args[] = { "xx", 0 };
    223e:	00005797          	auipc	a5,0x5
    2242:	ea278793          	addi	a5,a5,-350 # 70e0 <malloc+0x1944>
    2246:	fcf43823          	sd	a5,-48(s0)
    224a:	fc043c23          	sd	zero,-40(s0)
  ret = exec(b, args);
    224e:	fd040593          	addi	a1,s0,-48
    2252:	8526                	mv	a0,s1
    2254:	00003097          	auipc	ra,0x3
    2258:	14e080e7          	jalr	334(ra) # 53a2 <exec>
  if(ret != -1){
    225c:	57fd                	li	a5,-1
    225e:	08f51c63          	bne	a0,a5,22f6 <copyinstr3+0x12e>
}
    2262:	70a2                	ld	ra,40(sp)
    2264:	7402                	ld	s0,32(sp)
    2266:	64e2                	ld	s1,24(sp)
    2268:	6145                	addi	sp,sp,48
    226a:	8082                	ret
    sbrk(PGSIZE - (top % PGSIZE));
    226c:	0347d513          	srli	a0,a5,0x34
    2270:	6785                	lui	a5,0x1
    2272:	40a7853b          	subw	a0,a5,a0
    2276:	00003097          	auipc	ra,0x3
    227a:	17c080e7          	jalr	380(ra) # 53f2 <sbrk>
    227e:	b7bd                	j	21ec <copyinstr3+0x24>
    printf("oops\n");
    2280:	00004517          	auipc	a0,0x4
    2284:	2e050513          	addi	a0,a0,736 # 6560 <malloc+0xdc4>
    2288:	00003097          	auipc	ra,0x3
    228c:	45c080e7          	jalr	1116(ra) # 56e4 <printf>
    exit(1);
    2290:	4505                	li	a0,1
    2292:	00003097          	auipc	ra,0x3
    2296:	0d8080e7          	jalr	216(ra) # 536a <exit>
    printf("unlink(%s) returned %d, not -1\n", b, ret);
    229a:	862a                	mv	a2,a0
    229c:	85a6                	mv	a1,s1
    229e:	00004517          	auipc	a0,0x4
    22a2:	d9a50513          	addi	a0,a0,-614 # 6038 <malloc+0x89c>
    22a6:	00003097          	auipc	ra,0x3
    22aa:	43e080e7          	jalr	1086(ra) # 56e4 <printf>
    exit(1);
    22ae:	4505                	li	a0,1
    22b0:	00003097          	auipc	ra,0x3
    22b4:	0ba080e7          	jalr	186(ra) # 536a <exit>
    printf("open(%s) returned %d, not -1\n", b, fd);
    22b8:	862a                	mv	a2,a0
    22ba:	85a6                	mv	a1,s1
    22bc:	00004517          	auipc	a0,0x4
    22c0:	d9c50513          	addi	a0,a0,-612 # 6058 <malloc+0x8bc>
    22c4:	00003097          	auipc	ra,0x3
    22c8:	420080e7          	jalr	1056(ra) # 56e4 <printf>
    exit(1);
    22cc:	4505                	li	a0,1
    22ce:	00003097          	auipc	ra,0x3
    22d2:	09c080e7          	jalr	156(ra) # 536a <exit>
    printf("link(%s, %s) returned %d, not -1\n", b, b, ret);
    22d6:	86aa                	mv	a3,a0
    22d8:	8626                	mv	a2,s1
    22da:	85a6                	mv	a1,s1
    22dc:	00004517          	auipc	a0,0x4
    22e0:	d9c50513          	addi	a0,a0,-612 # 6078 <malloc+0x8dc>
    22e4:	00003097          	auipc	ra,0x3
    22e8:	400080e7          	jalr	1024(ra) # 56e4 <printf>
    exit(1);
    22ec:	4505                	li	a0,1
    22ee:	00003097          	auipc	ra,0x3
    22f2:	07c080e7          	jalr	124(ra) # 536a <exit>
    printf("exec(%s) returned %d, not -1\n", b, fd);
    22f6:	567d                	li	a2,-1
    22f8:	85a6                	mv	a1,s1
    22fa:	00004517          	auipc	a0,0x4
    22fe:	da650513          	addi	a0,a0,-602 # 60a0 <malloc+0x904>
    2302:	00003097          	auipc	ra,0x3
    2306:	3e2080e7          	jalr	994(ra) # 56e4 <printf>
    exit(1);
    230a:	4505                	li	a0,1
    230c:	00003097          	auipc	ra,0x3
    2310:	05e080e7          	jalr	94(ra) # 536a <exit>

0000000000002314 <sbrkbasic>:
{
    2314:	7139                	addi	sp,sp,-64
    2316:	fc06                	sd	ra,56(sp)
    2318:	f822                	sd	s0,48(sp)
    231a:	f426                	sd	s1,40(sp)
    231c:	f04a                	sd	s2,32(sp)
    231e:	ec4e                	sd	s3,24(sp)
    2320:	e852                	sd	s4,16(sp)
    2322:	0080                	addi	s0,sp,64
    2324:	8a2a                	mv	s4,a0
  pid = fork();
    2326:	00003097          	auipc	ra,0x3
    232a:	03c080e7          	jalr	60(ra) # 5362 <fork>
  if(pid < 0){
    232e:	02054c63          	bltz	a0,2366 <sbrkbasic+0x52>
  if(pid == 0){
    2332:	ed21                	bnez	a0,238a <sbrkbasic+0x76>
    a = sbrk(TOOMUCH);
    2334:	40000537          	lui	a0,0x40000
    2338:	00003097          	auipc	ra,0x3
    233c:	0ba080e7          	jalr	186(ra) # 53f2 <sbrk>
    if(a == (char*)0xffffffffffffffffL){
    2340:	57fd                	li	a5,-1
    2342:	02f50f63          	beq	a0,a5,2380 <sbrkbasic+0x6c>
    for(b = a; b < a+TOOMUCH; b += 4096){
    2346:	400007b7          	lui	a5,0x40000
    234a:	97aa                	add	a5,a5,a0
      *b = 99;
    234c:	06300693          	li	a3,99
    for(b = a; b < a+TOOMUCH; b += 4096){
    2350:	6705                	lui	a4,0x1
      *b = 99;
    2352:	00d50023          	sb	a3,0(a0) # 40000000 <__BSS_END__+0x3fff1870>
    for(b = a; b < a+TOOMUCH; b += 4096){
    2356:	953a                	add	a0,a0,a4
    2358:	fef51de3          	bne	a0,a5,2352 <sbrkbasic+0x3e>
    exit(1);
    235c:	4505                	li	a0,1
    235e:	00003097          	auipc	ra,0x3
    2362:	00c080e7          	jalr	12(ra) # 536a <exit>
    printf("fork failed in sbrkbasic\n");
    2366:	00004517          	auipc	a0,0x4
    236a:	20250513          	addi	a0,a0,514 # 6568 <malloc+0xdcc>
    236e:	00003097          	auipc	ra,0x3
    2372:	376080e7          	jalr	886(ra) # 56e4 <printf>
    exit(1);
    2376:	4505                	li	a0,1
    2378:	00003097          	auipc	ra,0x3
    237c:	ff2080e7          	jalr	-14(ra) # 536a <exit>
      exit(0);
    2380:	4501                	li	a0,0
    2382:	00003097          	auipc	ra,0x3
    2386:	fe8080e7          	jalr	-24(ra) # 536a <exit>
  wait(&xstatus);
    238a:	fcc40513          	addi	a0,s0,-52
    238e:	00003097          	auipc	ra,0x3
    2392:	fe4080e7          	jalr	-28(ra) # 5372 <wait>
  if(xstatus == 1){
    2396:	fcc42703          	lw	a4,-52(s0)
    239a:	4785                	li	a5,1
    239c:	00f70d63          	beq	a4,a5,23b6 <sbrkbasic+0xa2>
  a = sbrk(0);
    23a0:	4501                	li	a0,0
    23a2:	00003097          	auipc	ra,0x3
    23a6:	050080e7          	jalr	80(ra) # 53f2 <sbrk>
    23aa:	84aa                	mv	s1,a0
  for(i = 0; i < 5000; i++){
    23ac:	4901                	li	s2,0
    23ae:	6985                	lui	s3,0x1
    23b0:	38898993          	addi	s3,s3,904 # 1388 <copyinstr2+0x1d0>
    23b4:	a005                	j	23d4 <sbrkbasic+0xc0>
    printf("%s: too much memory allocated!\n", s);
    23b6:	85d2                	mv	a1,s4
    23b8:	00004517          	auipc	a0,0x4
    23bc:	1d050513          	addi	a0,a0,464 # 6588 <malloc+0xdec>
    23c0:	00003097          	auipc	ra,0x3
    23c4:	324080e7          	jalr	804(ra) # 56e4 <printf>
    exit(1);
    23c8:	4505                	li	a0,1
    23ca:	00003097          	auipc	ra,0x3
    23ce:	fa0080e7          	jalr	-96(ra) # 536a <exit>
    a = b + 1;
    23d2:	84be                	mv	s1,a5
    b = sbrk(1);
    23d4:	4505                	li	a0,1
    23d6:	00003097          	auipc	ra,0x3
    23da:	01c080e7          	jalr	28(ra) # 53f2 <sbrk>
    if(b != a){
    23de:	04951c63          	bne	a0,s1,2436 <sbrkbasic+0x122>
    *b = 1;
    23e2:	4785                	li	a5,1
    23e4:	00f48023          	sb	a5,0(s1)
    a = b + 1;
    23e8:	00148793          	addi	a5,s1,1
  for(i = 0; i < 5000; i++){
    23ec:	2905                	addiw	s2,s2,1
    23ee:	ff3912e3          	bne	s2,s3,23d2 <sbrkbasic+0xbe>
  pid = fork();
    23f2:	00003097          	auipc	ra,0x3
    23f6:	f70080e7          	jalr	-144(ra) # 5362 <fork>
    23fa:	892a                	mv	s2,a0
  if(pid < 0){
    23fc:	04054d63          	bltz	a0,2456 <sbrkbasic+0x142>
  c = sbrk(1);
    2400:	4505                	li	a0,1
    2402:	00003097          	auipc	ra,0x3
    2406:	ff0080e7          	jalr	-16(ra) # 53f2 <sbrk>
  c = sbrk(1);
    240a:	4505                	li	a0,1
    240c:	00003097          	auipc	ra,0x3
    2410:	fe6080e7          	jalr	-26(ra) # 53f2 <sbrk>
  if(c != a + 1){
    2414:	0489                	addi	s1,s1,2
    2416:	04a48e63          	beq	s1,a0,2472 <sbrkbasic+0x15e>
    printf("%s: sbrk test failed post-fork\n", s);
    241a:	85d2                	mv	a1,s4
    241c:	00004517          	auipc	a0,0x4
    2420:	1cc50513          	addi	a0,a0,460 # 65e8 <malloc+0xe4c>
    2424:	00003097          	auipc	ra,0x3
    2428:	2c0080e7          	jalr	704(ra) # 56e4 <printf>
    exit(1);
    242c:	4505                	li	a0,1
    242e:	00003097          	auipc	ra,0x3
    2432:	f3c080e7          	jalr	-196(ra) # 536a <exit>
      printf("%s: sbrk test failed %d %x %x\n", i, a, b);
    2436:	86aa                	mv	a3,a0
    2438:	8626                	mv	a2,s1
    243a:	85ca                	mv	a1,s2
    243c:	00004517          	auipc	a0,0x4
    2440:	16c50513          	addi	a0,a0,364 # 65a8 <malloc+0xe0c>
    2444:	00003097          	auipc	ra,0x3
    2448:	2a0080e7          	jalr	672(ra) # 56e4 <printf>
      exit(1);
    244c:	4505                	li	a0,1
    244e:	00003097          	auipc	ra,0x3
    2452:	f1c080e7          	jalr	-228(ra) # 536a <exit>
    printf("%s: sbrk test fork failed\n", s);
    2456:	85d2                	mv	a1,s4
    2458:	00004517          	auipc	a0,0x4
    245c:	17050513          	addi	a0,a0,368 # 65c8 <malloc+0xe2c>
    2460:	00003097          	auipc	ra,0x3
    2464:	284080e7          	jalr	644(ra) # 56e4 <printf>
    exit(1);
    2468:	4505                	li	a0,1
    246a:	00003097          	auipc	ra,0x3
    246e:	f00080e7          	jalr	-256(ra) # 536a <exit>
  if(pid == 0)
    2472:	00091763          	bnez	s2,2480 <sbrkbasic+0x16c>
    exit(0);
    2476:	4501                	li	a0,0
    2478:	00003097          	auipc	ra,0x3
    247c:	ef2080e7          	jalr	-270(ra) # 536a <exit>
  wait(&xstatus);
    2480:	fcc40513          	addi	a0,s0,-52
    2484:	00003097          	auipc	ra,0x3
    2488:	eee080e7          	jalr	-274(ra) # 5372 <wait>
  exit(xstatus);
    248c:	fcc42503          	lw	a0,-52(s0)
    2490:	00003097          	auipc	ra,0x3
    2494:	eda080e7          	jalr	-294(ra) # 536a <exit>

0000000000002498 <sbrkmuch>:
{
    2498:	7179                	addi	sp,sp,-48
    249a:	f406                	sd	ra,40(sp)
    249c:	f022                	sd	s0,32(sp)
    249e:	ec26                	sd	s1,24(sp)
    24a0:	e84a                	sd	s2,16(sp)
    24a2:	e44e                	sd	s3,8(sp)
    24a4:	e052                	sd	s4,0(sp)
    24a6:	1800                	addi	s0,sp,48
    24a8:	89aa                	mv	s3,a0
  oldbrk = sbrk(0);
    24aa:	4501                	li	a0,0
    24ac:	00003097          	auipc	ra,0x3
    24b0:	f46080e7          	jalr	-186(ra) # 53f2 <sbrk>
    24b4:	892a                	mv	s2,a0
  a = sbrk(0);
    24b6:	4501                	li	a0,0
    24b8:	00003097          	auipc	ra,0x3
    24bc:	f3a080e7          	jalr	-198(ra) # 53f2 <sbrk>
    24c0:	84aa                	mv	s1,a0
  p = sbrk(amt);
    24c2:	06400537          	lui	a0,0x6400
    24c6:	9d05                	subw	a0,a0,s1
    24c8:	00003097          	auipc	ra,0x3
    24cc:	f2a080e7          	jalr	-214(ra) # 53f2 <sbrk>
  if (p != a) {
    24d0:	0ca49863          	bne	s1,a0,25a0 <sbrkmuch+0x108>
  char *eee = sbrk(0);
    24d4:	4501                	li	a0,0
    24d6:	00003097          	auipc	ra,0x3
    24da:	f1c080e7          	jalr	-228(ra) # 53f2 <sbrk>
    24de:	87aa                	mv	a5,a0
  for(char *pp = a; pp < eee; pp += 4096)
    24e0:	00a4f963          	bgeu	s1,a0,24f2 <sbrkmuch+0x5a>
    *pp = 1;
    24e4:	4685                	li	a3,1
  for(char *pp = a; pp < eee; pp += 4096)
    24e6:	6705                	lui	a4,0x1
    *pp = 1;
    24e8:	00d48023          	sb	a3,0(s1)
  for(char *pp = a; pp < eee; pp += 4096)
    24ec:	94ba                	add	s1,s1,a4
    24ee:	fef4ede3          	bltu	s1,a5,24e8 <sbrkmuch+0x50>
  *lastaddr = 99;
    24f2:	064007b7          	lui	a5,0x6400
    24f6:	06300713          	li	a4,99
    24fa:	fee78fa3          	sb	a4,-1(a5) # 63fffff <__BSS_END__+0x63f186f>
  a = sbrk(0);
    24fe:	4501                	li	a0,0
    2500:	00003097          	auipc	ra,0x3
    2504:	ef2080e7          	jalr	-270(ra) # 53f2 <sbrk>
    2508:	84aa                	mv	s1,a0
  c = sbrk(-PGSIZE);
    250a:	757d                	lui	a0,0xfffff
    250c:	00003097          	auipc	ra,0x3
    2510:	ee6080e7          	jalr	-282(ra) # 53f2 <sbrk>
  if(c == (char*)0xffffffffffffffffL){
    2514:	57fd                	li	a5,-1
    2516:	0af50363          	beq	a0,a5,25bc <sbrkmuch+0x124>
  c = sbrk(0);
    251a:	4501                	li	a0,0
    251c:	00003097          	auipc	ra,0x3
    2520:	ed6080e7          	jalr	-298(ra) # 53f2 <sbrk>
  if(c != a - PGSIZE){
    2524:	77fd                	lui	a5,0xfffff
    2526:	97a6                	add	a5,a5,s1
    2528:	0af51863          	bne	a0,a5,25d8 <sbrkmuch+0x140>
  a = sbrk(0);
    252c:	4501                	li	a0,0
    252e:	00003097          	auipc	ra,0x3
    2532:	ec4080e7          	jalr	-316(ra) # 53f2 <sbrk>
    2536:	84aa                	mv	s1,a0
  c = sbrk(PGSIZE);
    2538:	6505                	lui	a0,0x1
    253a:	00003097          	auipc	ra,0x3
    253e:	eb8080e7          	jalr	-328(ra) # 53f2 <sbrk>
    2542:	8a2a                	mv	s4,a0
  if(c != a || sbrk(0) != a + PGSIZE){
    2544:	0aa49963          	bne	s1,a0,25f6 <sbrkmuch+0x15e>
    2548:	4501                	li	a0,0
    254a:	00003097          	auipc	ra,0x3
    254e:	ea8080e7          	jalr	-344(ra) # 53f2 <sbrk>
    2552:	6785                	lui	a5,0x1
    2554:	97a6                	add	a5,a5,s1
    2556:	0af51063          	bne	a0,a5,25f6 <sbrkmuch+0x15e>
  if(*lastaddr == 99){
    255a:	064007b7          	lui	a5,0x6400
    255e:	fff7c703          	lbu	a4,-1(a5) # 63fffff <__BSS_END__+0x63f186f>
    2562:	06300793          	li	a5,99
    2566:	0af70763          	beq	a4,a5,2614 <sbrkmuch+0x17c>
  a = sbrk(0);
    256a:	4501                	li	a0,0
    256c:	00003097          	auipc	ra,0x3
    2570:	e86080e7          	jalr	-378(ra) # 53f2 <sbrk>
    2574:	84aa                	mv	s1,a0
  c = sbrk(-(sbrk(0) - oldbrk));
    2576:	4501                	li	a0,0
    2578:	00003097          	auipc	ra,0x3
    257c:	e7a080e7          	jalr	-390(ra) # 53f2 <sbrk>
    2580:	40a9053b          	subw	a0,s2,a0
    2584:	00003097          	auipc	ra,0x3
    2588:	e6e080e7          	jalr	-402(ra) # 53f2 <sbrk>
  if(c != a){
    258c:	0aa49263          	bne	s1,a0,2630 <sbrkmuch+0x198>
}
    2590:	70a2                	ld	ra,40(sp)
    2592:	7402                	ld	s0,32(sp)
    2594:	64e2                	ld	s1,24(sp)
    2596:	6942                	ld	s2,16(sp)
    2598:	69a2                	ld	s3,8(sp)
    259a:	6a02                	ld	s4,0(sp)
    259c:	6145                	addi	sp,sp,48
    259e:	8082                	ret
    printf("%s: sbrk test failed to grow big address space; enough phys mem?\n", s);
    25a0:	85ce                	mv	a1,s3
    25a2:	00004517          	auipc	a0,0x4
    25a6:	06650513          	addi	a0,a0,102 # 6608 <malloc+0xe6c>
    25aa:	00003097          	auipc	ra,0x3
    25ae:	13a080e7          	jalr	314(ra) # 56e4 <printf>
    exit(1);
    25b2:	4505                	li	a0,1
    25b4:	00003097          	auipc	ra,0x3
    25b8:	db6080e7          	jalr	-586(ra) # 536a <exit>
    printf("%s: sbrk could not deallocate\n", s);
    25bc:	85ce                	mv	a1,s3
    25be:	00004517          	auipc	a0,0x4
    25c2:	09250513          	addi	a0,a0,146 # 6650 <malloc+0xeb4>
    25c6:	00003097          	auipc	ra,0x3
    25ca:	11e080e7          	jalr	286(ra) # 56e4 <printf>
    exit(1);
    25ce:	4505                	li	a0,1
    25d0:	00003097          	auipc	ra,0x3
    25d4:	d9a080e7          	jalr	-614(ra) # 536a <exit>
    printf("%s: sbrk deallocation produced wrong address, a %x c %x\n", a, c);
    25d8:	862a                	mv	a2,a0
    25da:	85a6                	mv	a1,s1
    25dc:	00004517          	auipc	a0,0x4
    25e0:	09450513          	addi	a0,a0,148 # 6670 <malloc+0xed4>
    25e4:	00003097          	auipc	ra,0x3
    25e8:	100080e7          	jalr	256(ra) # 56e4 <printf>
    exit(1);
    25ec:	4505                	li	a0,1
    25ee:	00003097          	auipc	ra,0x3
    25f2:	d7c080e7          	jalr	-644(ra) # 536a <exit>
    printf("%s: sbrk re-allocation failed, a %x c %x\n", a, c);
    25f6:	8652                	mv	a2,s4
    25f8:	85a6                	mv	a1,s1
    25fa:	00004517          	auipc	a0,0x4
    25fe:	0b650513          	addi	a0,a0,182 # 66b0 <malloc+0xf14>
    2602:	00003097          	auipc	ra,0x3
    2606:	0e2080e7          	jalr	226(ra) # 56e4 <printf>
    exit(1);
    260a:	4505                	li	a0,1
    260c:	00003097          	auipc	ra,0x3
    2610:	d5e080e7          	jalr	-674(ra) # 536a <exit>
    printf("%s: sbrk de-allocation didn't really deallocate\n", s);
    2614:	85ce                	mv	a1,s3
    2616:	00004517          	auipc	a0,0x4
    261a:	0ca50513          	addi	a0,a0,202 # 66e0 <malloc+0xf44>
    261e:	00003097          	auipc	ra,0x3
    2622:	0c6080e7          	jalr	198(ra) # 56e4 <printf>
    exit(1);
    2626:	4505                	li	a0,1
    2628:	00003097          	auipc	ra,0x3
    262c:	d42080e7          	jalr	-702(ra) # 536a <exit>
    printf("%s: sbrk downsize failed, a %x c %x\n", a, c);
    2630:	862a                	mv	a2,a0
    2632:	85a6                	mv	a1,s1
    2634:	00004517          	auipc	a0,0x4
    2638:	0e450513          	addi	a0,a0,228 # 6718 <malloc+0xf7c>
    263c:	00003097          	auipc	ra,0x3
    2640:	0a8080e7          	jalr	168(ra) # 56e4 <printf>
    exit(1);
    2644:	4505                	li	a0,1
    2646:	00003097          	auipc	ra,0x3
    264a:	d24080e7          	jalr	-732(ra) # 536a <exit>

000000000000264e <sbrkarg>:
{
    264e:	7179                	addi	sp,sp,-48
    2650:	f406                	sd	ra,40(sp)
    2652:	f022                	sd	s0,32(sp)
    2654:	ec26                	sd	s1,24(sp)
    2656:	e84a                	sd	s2,16(sp)
    2658:	e44e                	sd	s3,8(sp)
    265a:	1800                	addi	s0,sp,48
    265c:	89aa                	mv	s3,a0
  a = sbrk(PGSIZE);
    265e:	6505                	lui	a0,0x1
    2660:	00003097          	auipc	ra,0x3
    2664:	d92080e7          	jalr	-622(ra) # 53f2 <sbrk>
    2668:	892a                	mv	s2,a0
  fd = open("sbrk", O_CREATE|O_WRONLY);
    266a:	20100593          	li	a1,513
    266e:	00004517          	auipc	a0,0x4
    2672:	0d250513          	addi	a0,a0,210 # 6740 <malloc+0xfa4>
    2676:	00003097          	auipc	ra,0x3
    267a:	d34080e7          	jalr	-716(ra) # 53aa <open>
    267e:	84aa                	mv	s1,a0
  unlink("sbrk");
    2680:	00004517          	auipc	a0,0x4
    2684:	0c050513          	addi	a0,a0,192 # 6740 <malloc+0xfa4>
    2688:	00003097          	auipc	ra,0x3
    268c:	d32080e7          	jalr	-718(ra) # 53ba <unlink>
  if(fd < 0)  {
    2690:	0404c163          	bltz	s1,26d2 <sbrkarg+0x84>
  if ((n = write(fd, a, PGSIZE)) < 0) {
    2694:	6605                	lui	a2,0x1
    2696:	85ca                	mv	a1,s2
    2698:	8526                	mv	a0,s1
    269a:	00003097          	auipc	ra,0x3
    269e:	cf0080e7          	jalr	-784(ra) # 538a <write>
    26a2:	04054663          	bltz	a0,26ee <sbrkarg+0xa0>
  close(fd);
    26a6:	8526                	mv	a0,s1
    26a8:	00003097          	auipc	ra,0x3
    26ac:	cea080e7          	jalr	-790(ra) # 5392 <close>
  a = sbrk(PGSIZE);
    26b0:	6505                	lui	a0,0x1
    26b2:	00003097          	auipc	ra,0x3
    26b6:	d40080e7          	jalr	-704(ra) # 53f2 <sbrk>
  if(pipe((int *) a) != 0){
    26ba:	00003097          	auipc	ra,0x3
    26be:	cc0080e7          	jalr	-832(ra) # 537a <pipe>
    26c2:	e521                	bnez	a0,270a <sbrkarg+0xbc>
}
    26c4:	70a2                	ld	ra,40(sp)
    26c6:	7402                	ld	s0,32(sp)
    26c8:	64e2                	ld	s1,24(sp)
    26ca:	6942                	ld	s2,16(sp)
    26cc:	69a2                	ld	s3,8(sp)
    26ce:	6145                	addi	sp,sp,48
    26d0:	8082                	ret
    printf("%s: open sbrk failed\n", s);
    26d2:	85ce                	mv	a1,s3
    26d4:	00004517          	auipc	a0,0x4
    26d8:	07450513          	addi	a0,a0,116 # 6748 <malloc+0xfac>
    26dc:	00003097          	auipc	ra,0x3
    26e0:	008080e7          	jalr	8(ra) # 56e4 <printf>
    exit(1);
    26e4:	4505                	li	a0,1
    26e6:	00003097          	auipc	ra,0x3
    26ea:	c84080e7          	jalr	-892(ra) # 536a <exit>
    printf("%s: write sbrk failed\n", s);
    26ee:	85ce                	mv	a1,s3
    26f0:	00004517          	auipc	a0,0x4
    26f4:	07050513          	addi	a0,a0,112 # 6760 <malloc+0xfc4>
    26f8:	00003097          	auipc	ra,0x3
    26fc:	fec080e7          	jalr	-20(ra) # 56e4 <printf>
    exit(1);
    2700:	4505                	li	a0,1
    2702:	00003097          	auipc	ra,0x3
    2706:	c68080e7          	jalr	-920(ra) # 536a <exit>
    printf("%s: pipe() failed\n", s);
    270a:	85ce                	mv	a1,s3
    270c:	00004517          	auipc	a0,0x4
    2710:	b1450513          	addi	a0,a0,-1260 # 6220 <malloc+0xa84>
    2714:	00003097          	auipc	ra,0x3
    2718:	fd0080e7          	jalr	-48(ra) # 56e4 <printf>
    exit(1);
    271c:	4505                	li	a0,1
    271e:	00003097          	auipc	ra,0x3
    2722:	c4c080e7          	jalr	-948(ra) # 536a <exit>

0000000000002726 <argptest>:
{
    2726:	1101                	addi	sp,sp,-32
    2728:	ec06                	sd	ra,24(sp)
    272a:	e822                	sd	s0,16(sp)
    272c:	e426                	sd	s1,8(sp)
    272e:	e04a                	sd	s2,0(sp)
    2730:	1000                	addi	s0,sp,32
    2732:	892a                	mv	s2,a0
  fd = open("init", O_RDONLY);
    2734:	4581                	li	a1,0
    2736:	00004517          	auipc	a0,0x4
    273a:	04250513          	addi	a0,a0,66 # 6778 <malloc+0xfdc>
    273e:	00003097          	auipc	ra,0x3
    2742:	c6c080e7          	jalr	-916(ra) # 53aa <open>
  if (fd < 0) {
    2746:	02054b63          	bltz	a0,277c <argptest+0x56>
    274a:	84aa                	mv	s1,a0
  read(fd, sbrk(0) - 1, -1);
    274c:	4501                	li	a0,0
    274e:	00003097          	auipc	ra,0x3
    2752:	ca4080e7          	jalr	-860(ra) # 53f2 <sbrk>
    2756:	567d                	li	a2,-1
    2758:	fff50593          	addi	a1,a0,-1
    275c:	8526                	mv	a0,s1
    275e:	00003097          	auipc	ra,0x3
    2762:	c24080e7          	jalr	-988(ra) # 5382 <read>
  close(fd);
    2766:	8526                	mv	a0,s1
    2768:	00003097          	auipc	ra,0x3
    276c:	c2a080e7          	jalr	-982(ra) # 5392 <close>
}
    2770:	60e2                	ld	ra,24(sp)
    2772:	6442                	ld	s0,16(sp)
    2774:	64a2                	ld	s1,8(sp)
    2776:	6902                	ld	s2,0(sp)
    2778:	6105                	addi	sp,sp,32
    277a:	8082                	ret
    printf("%s: open failed\n", s);
    277c:	85ca                	mv	a1,s2
    277e:	00004517          	auipc	a0,0x4
    2782:	9b250513          	addi	a0,a0,-1614 # 6130 <malloc+0x994>
    2786:	00003097          	auipc	ra,0x3
    278a:	f5e080e7          	jalr	-162(ra) # 56e4 <printf>
    exit(1);
    278e:	4505                	li	a0,1
    2790:	00003097          	auipc	ra,0x3
    2794:	bda080e7          	jalr	-1062(ra) # 536a <exit>

0000000000002798 <sbrkbugs>:
{
    2798:	1141                	addi	sp,sp,-16
    279a:	e406                	sd	ra,8(sp)
    279c:	e022                	sd	s0,0(sp)
    279e:	0800                	addi	s0,sp,16
  int pid = fork();
    27a0:	00003097          	auipc	ra,0x3
    27a4:	bc2080e7          	jalr	-1086(ra) # 5362 <fork>
  if(pid < 0){
    27a8:	02054263          	bltz	a0,27cc <sbrkbugs+0x34>
  if(pid == 0){
    27ac:	ed0d                	bnez	a0,27e6 <sbrkbugs+0x4e>
    int sz = (uint64) sbrk(0);
    27ae:	00003097          	auipc	ra,0x3
    27b2:	c44080e7          	jalr	-956(ra) # 53f2 <sbrk>
    sbrk(-sz);
    27b6:	40a0053b          	negw	a0,a0
    27ba:	00003097          	auipc	ra,0x3
    27be:	c38080e7          	jalr	-968(ra) # 53f2 <sbrk>
    exit(0);
    27c2:	4501                	li	a0,0
    27c4:	00003097          	auipc	ra,0x3
    27c8:	ba6080e7          	jalr	-1114(ra) # 536a <exit>
    printf("fork failed\n");
    27cc:	00004517          	auipc	a0,0x4
    27d0:	d3c50513          	addi	a0,a0,-708 # 6508 <malloc+0xd6c>
    27d4:	00003097          	auipc	ra,0x3
    27d8:	f10080e7          	jalr	-240(ra) # 56e4 <printf>
    exit(1);
    27dc:	4505                	li	a0,1
    27de:	00003097          	auipc	ra,0x3
    27e2:	b8c080e7          	jalr	-1140(ra) # 536a <exit>
  wait(0);
    27e6:	4501                	li	a0,0
    27e8:	00003097          	auipc	ra,0x3
    27ec:	b8a080e7          	jalr	-1142(ra) # 5372 <wait>
  pid = fork();
    27f0:	00003097          	auipc	ra,0x3
    27f4:	b72080e7          	jalr	-1166(ra) # 5362 <fork>
  if(pid < 0){
    27f8:	02054563          	bltz	a0,2822 <sbrkbugs+0x8a>
  if(pid == 0){
    27fc:	e121                	bnez	a0,283c <sbrkbugs+0xa4>
    int sz = (uint64) sbrk(0);
    27fe:	00003097          	auipc	ra,0x3
    2802:	bf4080e7          	jalr	-1036(ra) # 53f2 <sbrk>
    sbrk(-(sz - 3500));
    2806:	6785                	lui	a5,0x1
    2808:	dac7879b          	addiw	a5,a5,-596 # dac <linktest+0x90>
    280c:	40a7853b          	subw	a0,a5,a0
    2810:	00003097          	auipc	ra,0x3
    2814:	be2080e7          	jalr	-1054(ra) # 53f2 <sbrk>
    exit(0);
    2818:	4501                	li	a0,0
    281a:	00003097          	auipc	ra,0x3
    281e:	b50080e7          	jalr	-1200(ra) # 536a <exit>
    printf("fork failed\n");
    2822:	00004517          	auipc	a0,0x4
    2826:	ce650513          	addi	a0,a0,-794 # 6508 <malloc+0xd6c>
    282a:	00003097          	auipc	ra,0x3
    282e:	eba080e7          	jalr	-326(ra) # 56e4 <printf>
    exit(1);
    2832:	4505                	li	a0,1
    2834:	00003097          	auipc	ra,0x3
    2838:	b36080e7          	jalr	-1226(ra) # 536a <exit>
  wait(0);
    283c:	4501                	li	a0,0
    283e:	00003097          	auipc	ra,0x3
    2842:	b34080e7          	jalr	-1228(ra) # 5372 <wait>
  pid = fork();
    2846:	00003097          	auipc	ra,0x3
    284a:	b1c080e7          	jalr	-1252(ra) # 5362 <fork>
  if(pid < 0){
    284e:	02054a63          	bltz	a0,2882 <sbrkbugs+0xea>
  if(pid == 0){
    2852:	e529                	bnez	a0,289c <sbrkbugs+0x104>
    sbrk((10*4096 + 2048) - (uint64)sbrk(0));
    2854:	00003097          	auipc	ra,0x3
    2858:	b9e080e7          	jalr	-1122(ra) # 53f2 <sbrk>
    285c:	67ad                	lui	a5,0xb
    285e:	8007879b          	addiw	a5,a5,-2048 # a800 <uninit+0x1790>
    2862:	40a7853b          	subw	a0,a5,a0
    2866:	00003097          	auipc	ra,0x3
    286a:	b8c080e7          	jalr	-1140(ra) # 53f2 <sbrk>
    sbrk(-10);
    286e:	5559                	li	a0,-10
    2870:	00003097          	auipc	ra,0x3
    2874:	b82080e7          	jalr	-1150(ra) # 53f2 <sbrk>
    exit(0);
    2878:	4501                	li	a0,0
    287a:	00003097          	auipc	ra,0x3
    287e:	af0080e7          	jalr	-1296(ra) # 536a <exit>
    printf("fork failed\n");
    2882:	00004517          	auipc	a0,0x4
    2886:	c8650513          	addi	a0,a0,-890 # 6508 <malloc+0xd6c>
    288a:	00003097          	auipc	ra,0x3
    288e:	e5a080e7          	jalr	-422(ra) # 56e4 <printf>
    exit(1);
    2892:	4505                	li	a0,1
    2894:	00003097          	auipc	ra,0x3
    2898:	ad6080e7          	jalr	-1322(ra) # 536a <exit>
  wait(0);
    289c:	4501                	li	a0,0
    289e:	00003097          	auipc	ra,0x3
    28a2:	ad4080e7          	jalr	-1324(ra) # 5372 <wait>
  exit(0);
    28a6:	4501                	li	a0,0
    28a8:	00003097          	auipc	ra,0x3
    28ac:	ac2080e7          	jalr	-1342(ra) # 536a <exit>

00000000000028b0 <execout>:
// test the exec() code that cleans up if it runs out
// of memory. it's really a test that such a condition
// doesn't cause a panic.
void
execout(char *s)
{
    28b0:	715d                	addi	sp,sp,-80
    28b2:	e486                	sd	ra,72(sp)
    28b4:	e0a2                	sd	s0,64(sp)
    28b6:	fc26                	sd	s1,56(sp)
    28b8:	f84a                	sd	s2,48(sp)
    28ba:	f44e                	sd	s3,40(sp)
    28bc:	f052                	sd	s4,32(sp)
    28be:	0880                	addi	s0,sp,80
  for(int avail = 0; avail < 15; avail++){
    28c0:	4901                	li	s2,0
    28c2:	49bd                	li	s3,15
    int pid = fork();
    28c4:	00003097          	auipc	ra,0x3
    28c8:	a9e080e7          	jalr	-1378(ra) # 5362 <fork>
    28cc:	84aa                	mv	s1,a0
    if(pid < 0){
    28ce:	02054063          	bltz	a0,28ee <execout+0x3e>
      printf("fork failed\n");
      exit(1);
    } else if(pid == 0){
    28d2:	c91d                	beqz	a0,2908 <execout+0x58>
      close(1);
      char *args[] = { "echo", "x", 0 };
      exec("echo", args);
      exit(0);
    } else {
      wait((int*)0);
    28d4:	4501                	li	a0,0
    28d6:	00003097          	auipc	ra,0x3
    28da:	a9c080e7          	jalr	-1380(ra) # 5372 <wait>
  for(int avail = 0; avail < 15; avail++){
    28de:	2905                	addiw	s2,s2,1
    28e0:	ff3912e3          	bne	s2,s3,28c4 <execout+0x14>
    }
  }

  exit(0);
    28e4:	4501                	li	a0,0
    28e6:	00003097          	auipc	ra,0x3
    28ea:	a84080e7          	jalr	-1404(ra) # 536a <exit>
      printf("fork failed\n");
    28ee:	00004517          	auipc	a0,0x4
    28f2:	c1a50513          	addi	a0,a0,-998 # 6508 <malloc+0xd6c>
    28f6:	00003097          	auipc	ra,0x3
    28fa:	dee080e7          	jalr	-530(ra) # 56e4 <printf>
      exit(1);
    28fe:	4505                	li	a0,1
    2900:	00003097          	auipc	ra,0x3
    2904:	a6a080e7          	jalr	-1430(ra) # 536a <exit>
        if(a == 0xffffffffffffffffLL)
    2908:	59fd                	li	s3,-1
        *(char*)(a + 4096 - 1) = 1;
    290a:	4a05                	li	s4,1
        uint64 a = (uint64) sbrk(4096);
    290c:	6505                	lui	a0,0x1
    290e:	00003097          	auipc	ra,0x3
    2912:	ae4080e7          	jalr	-1308(ra) # 53f2 <sbrk>
        if(a == 0xffffffffffffffffLL)
    2916:	01350763          	beq	a0,s3,2924 <execout+0x74>
        *(char*)(a + 4096 - 1) = 1;
    291a:	6785                	lui	a5,0x1
    291c:	97aa                	add	a5,a5,a0
    291e:	ff478fa3          	sb	s4,-1(a5) # fff <bigdir+0x97>
      while(1){
    2922:	b7ed                	j	290c <execout+0x5c>
      for(int i = 0; i < avail; i++)
    2924:	01205a63          	blez	s2,2938 <execout+0x88>
        sbrk(-4096);
    2928:	757d                	lui	a0,0xfffff
    292a:	00003097          	auipc	ra,0x3
    292e:	ac8080e7          	jalr	-1336(ra) # 53f2 <sbrk>
      for(int i = 0; i < avail; i++)
    2932:	2485                	addiw	s1,s1,1
    2934:	ff249ae3          	bne	s1,s2,2928 <execout+0x78>
      close(1);
    2938:	4505                	li	a0,1
    293a:	00003097          	auipc	ra,0x3
    293e:	a58080e7          	jalr	-1448(ra) # 5392 <close>
      char *args[] = { "echo", "x", 0 };
    2942:	00003517          	auipc	a0,0x3
    2946:	f7e50513          	addi	a0,a0,-130 # 58c0 <malloc+0x124>
    294a:	faa43c23          	sd	a0,-72(s0)
    294e:	00003797          	auipc	a5,0x3
    2952:	fe278793          	addi	a5,a5,-30 # 5930 <malloc+0x194>
    2956:	fcf43023          	sd	a5,-64(s0)
    295a:	fc043423          	sd	zero,-56(s0)
      exec("echo", args);
    295e:	fb840593          	addi	a1,s0,-72
    2962:	00003097          	auipc	ra,0x3
    2966:	a40080e7          	jalr	-1472(ra) # 53a2 <exec>
      exit(0);
    296a:	4501                	li	a0,0
    296c:	00003097          	auipc	ra,0x3
    2970:	9fe080e7          	jalr	-1538(ra) # 536a <exit>

0000000000002974 <fourteen>:
{
    2974:	1101                	addi	sp,sp,-32
    2976:	ec06                	sd	ra,24(sp)
    2978:	e822                	sd	s0,16(sp)
    297a:	e426                	sd	s1,8(sp)
    297c:	1000                	addi	s0,sp,32
    297e:	84aa                	mv	s1,a0
  if(mkdir("12345678901234") != 0){
    2980:	00004517          	auipc	a0,0x4
    2984:	fd050513          	addi	a0,a0,-48 # 6950 <malloc+0x11b4>
    2988:	00003097          	auipc	ra,0x3
    298c:	a4a080e7          	jalr	-1462(ra) # 53d2 <mkdir>
    2990:	e165                	bnez	a0,2a70 <fourteen+0xfc>
  if(mkdir("12345678901234/123456789012345") != 0){
    2992:	00004517          	auipc	a0,0x4
    2996:	e1650513          	addi	a0,a0,-490 # 67a8 <malloc+0x100c>
    299a:	00003097          	auipc	ra,0x3
    299e:	a38080e7          	jalr	-1480(ra) # 53d2 <mkdir>
    29a2:	e56d                	bnez	a0,2a8c <fourteen+0x118>
  fd = open("123456789012345/123456789012345/123456789012345", O_CREATE);
    29a4:	20000593          	li	a1,512
    29a8:	00004517          	auipc	a0,0x4
    29ac:	e5850513          	addi	a0,a0,-424 # 6800 <malloc+0x1064>
    29b0:	00003097          	auipc	ra,0x3
    29b4:	9fa080e7          	jalr	-1542(ra) # 53aa <open>
  if(fd < 0){
    29b8:	0e054863          	bltz	a0,2aa8 <fourteen+0x134>
  close(fd);
    29bc:	00003097          	auipc	ra,0x3
    29c0:	9d6080e7          	jalr	-1578(ra) # 5392 <close>
  fd = open("12345678901234/12345678901234/12345678901234", 0);
    29c4:	4581                	li	a1,0
    29c6:	00004517          	auipc	a0,0x4
    29ca:	eb250513          	addi	a0,a0,-334 # 6878 <malloc+0x10dc>
    29ce:	00003097          	auipc	ra,0x3
    29d2:	9dc080e7          	jalr	-1572(ra) # 53aa <open>
  if(fd < 0){
    29d6:	0e054763          	bltz	a0,2ac4 <fourteen+0x150>
  close(fd);
    29da:	00003097          	auipc	ra,0x3
    29de:	9b8080e7          	jalr	-1608(ra) # 5392 <close>
  if(mkdir("12345678901234/12345678901234") == 0){
    29e2:	00004517          	auipc	a0,0x4
    29e6:	f0650513          	addi	a0,a0,-250 # 68e8 <malloc+0x114c>
    29ea:	00003097          	auipc	ra,0x3
    29ee:	9e8080e7          	jalr	-1560(ra) # 53d2 <mkdir>
    29f2:	c57d                	beqz	a0,2ae0 <fourteen+0x16c>
  if(mkdir("123456789012345/12345678901234") == 0){
    29f4:	00004517          	auipc	a0,0x4
    29f8:	f4c50513          	addi	a0,a0,-180 # 6940 <malloc+0x11a4>
    29fc:	00003097          	auipc	ra,0x3
    2a00:	9d6080e7          	jalr	-1578(ra) # 53d2 <mkdir>
    2a04:	cd65                	beqz	a0,2afc <fourteen+0x188>
  unlink("123456789012345/12345678901234");
    2a06:	00004517          	auipc	a0,0x4
    2a0a:	f3a50513          	addi	a0,a0,-198 # 6940 <malloc+0x11a4>
    2a0e:	00003097          	auipc	ra,0x3
    2a12:	9ac080e7          	jalr	-1620(ra) # 53ba <unlink>
  unlink("12345678901234/12345678901234");
    2a16:	00004517          	auipc	a0,0x4
    2a1a:	ed250513          	addi	a0,a0,-302 # 68e8 <malloc+0x114c>
    2a1e:	00003097          	auipc	ra,0x3
    2a22:	99c080e7          	jalr	-1636(ra) # 53ba <unlink>
  unlink("12345678901234/12345678901234/12345678901234");
    2a26:	00004517          	auipc	a0,0x4
    2a2a:	e5250513          	addi	a0,a0,-430 # 6878 <malloc+0x10dc>
    2a2e:	00003097          	auipc	ra,0x3
    2a32:	98c080e7          	jalr	-1652(ra) # 53ba <unlink>
  unlink("123456789012345/123456789012345/123456789012345");
    2a36:	00004517          	auipc	a0,0x4
    2a3a:	dca50513          	addi	a0,a0,-566 # 6800 <malloc+0x1064>
    2a3e:	00003097          	auipc	ra,0x3
    2a42:	97c080e7          	jalr	-1668(ra) # 53ba <unlink>
  unlink("12345678901234/123456789012345");
    2a46:	00004517          	auipc	a0,0x4
    2a4a:	d6250513          	addi	a0,a0,-670 # 67a8 <malloc+0x100c>
    2a4e:	00003097          	auipc	ra,0x3
    2a52:	96c080e7          	jalr	-1684(ra) # 53ba <unlink>
  unlink("12345678901234");
    2a56:	00004517          	auipc	a0,0x4
    2a5a:	efa50513          	addi	a0,a0,-262 # 6950 <malloc+0x11b4>
    2a5e:	00003097          	auipc	ra,0x3
    2a62:	95c080e7          	jalr	-1700(ra) # 53ba <unlink>
}
    2a66:	60e2                	ld	ra,24(sp)
    2a68:	6442                	ld	s0,16(sp)
    2a6a:	64a2                	ld	s1,8(sp)
    2a6c:	6105                	addi	sp,sp,32
    2a6e:	8082                	ret
    printf("%s: mkdir 12345678901234 failed\n", s);
    2a70:	85a6                	mv	a1,s1
    2a72:	00004517          	auipc	a0,0x4
    2a76:	d0e50513          	addi	a0,a0,-754 # 6780 <malloc+0xfe4>
    2a7a:	00003097          	auipc	ra,0x3
    2a7e:	c6a080e7          	jalr	-918(ra) # 56e4 <printf>
    exit(1);
    2a82:	4505                	li	a0,1
    2a84:	00003097          	auipc	ra,0x3
    2a88:	8e6080e7          	jalr	-1818(ra) # 536a <exit>
    printf("%s: mkdir 12345678901234/123456789012345 failed\n", s);
    2a8c:	85a6                	mv	a1,s1
    2a8e:	00004517          	auipc	a0,0x4
    2a92:	d3a50513          	addi	a0,a0,-710 # 67c8 <malloc+0x102c>
    2a96:	00003097          	auipc	ra,0x3
    2a9a:	c4e080e7          	jalr	-946(ra) # 56e4 <printf>
    exit(1);
    2a9e:	4505                	li	a0,1
    2aa0:	00003097          	auipc	ra,0x3
    2aa4:	8ca080e7          	jalr	-1846(ra) # 536a <exit>
    printf("%s: create 123456789012345/123456789012345/123456789012345 failed\n", s);
    2aa8:	85a6                	mv	a1,s1
    2aaa:	00004517          	auipc	a0,0x4
    2aae:	d8650513          	addi	a0,a0,-634 # 6830 <malloc+0x1094>
    2ab2:	00003097          	auipc	ra,0x3
    2ab6:	c32080e7          	jalr	-974(ra) # 56e4 <printf>
    exit(1);
    2aba:	4505                	li	a0,1
    2abc:	00003097          	auipc	ra,0x3
    2ac0:	8ae080e7          	jalr	-1874(ra) # 536a <exit>
    printf("%s: open 12345678901234/12345678901234/12345678901234 failed\n", s);
    2ac4:	85a6                	mv	a1,s1
    2ac6:	00004517          	auipc	a0,0x4
    2aca:	de250513          	addi	a0,a0,-542 # 68a8 <malloc+0x110c>
    2ace:	00003097          	auipc	ra,0x3
    2ad2:	c16080e7          	jalr	-1002(ra) # 56e4 <printf>
    exit(1);
    2ad6:	4505                	li	a0,1
    2ad8:	00003097          	auipc	ra,0x3
    2adc:	892080e7          	jalr	-1902(ra) # 536a <exit>
    printf("%s: mkdir 12345678901234/12345678901234 succeeded!\n", s);
    2ae0:	85a6                	mv	a1,s1
    2ae2:	00004517          	auipc	a0,0x4
    2ae6:	e2650513          	addi	a0,a0,-474 # 6908 <malloc+0x116c>
    2aea:	00003097          	auipc	ra,0x3
    2aee:	bfa080e7          	jalr	-1030(ra) # 56e4 <printf>
    exit(1);
    2af2:	4505                	li	a0,1
    2af4:	00003097          	auipc	ra,0x3
    2af8:	876080e7          	jalr	-1930(ra) # 536a <exit>
    printf("%s: mkdir 12345678901234/123456789012345 succeeded!\n", s);
    2afc:	85a6                	mv	a1,s1
    2afe:	00004517          	auipc	a0,0x4
    2b02:	e6250513          	addi	a0,a0,-414 # 6960 <malloc+0x11c4>
    2b06:	00003097          	auipc	ra,0x3
    2b0a:	bde080e7          	jalr	-1058(ra) # 56e4 <printf>
    exit(1);
    2b0e:	4505                	li	a0,1
    2b10:	00003097          	auipc	ra,0x3
    2b14:	85a080e7          	jalr	-1958(ra) # 536a <exit>

0000000000002b18 <iputtest>:
{
    2b18:	1101                	addi	sp,sp,-32
    2b1a:	ec06                	sd	ra,24(sp)
    2b1c:	e822                	sd	s0,16(sp)
    2b1e:	e426                	sd	s1,8(sp)
    2b20:	1000                	addi	s0,sp,32
    2b22:	84aa                	mv	s1,a0
  if(mkdir("iputdir") < 0){
    2b24:	00004517          	auipc	a0,0x4
    2b28:	e7450513          	addi	a0,a0,-396 # 6998 <malloc+0x11fc>
    2b2c:	00003097          	auipc	ra,0x3
    2b30:	8a6080e7          	jalr	-1882(ra) # 53d2 <mkdir>
    2b34:	04054563          	bltz	a0,2b7e <iputtest+0x66>
  if(chdir("iputdir") < 0){
    2b38:	00004517          	auipc	a0,0x4
    2b3c:	e6050513          	addi	a0,a0,-416 # 6998 <malloc+0x11fc>
    2b40:	00003097          	auipc	ra,0x3
    2b44:	89a080e7          	jalr	-1894(ra) # 53da <chdir>
    2b48:	04054963          	bltz	a0,2b9a <iputtest+0x82>
  if(unlink("../iputdir") < 0){
    2b4c:	00004517          	auipc	a0,0x4
    2b50:	e8c50513          	addi	a0,a0,-372 # 69d8 <malloc+0x123c>
    2b54:	00003097          	auipc	ra,0x3
    2b58:	866080e7          	jalr	-1946(ra) # 53ba <unlink>
    2b5c:	04054d63          	bltz	a0,2bb6 <iputtest+0x9e>
  if(chdir("/") < 0){
    2b60:	00004517          	auipc	a0,0x4
    2b64:	ea850513          	addi	a0,a0,-344 # 6a08 <malloc+0x126c>
    2b68:	00003097          	auipc	ra,0x3
    2b6c:	872080e7          	jalr	-1934(ra) # 53da <chdir>
    2b70:	06054163          	bltz	a0,2bd2 <iputtest+0xba>
}
    2b74:	60e2                	ld	ra,24(sp)
    2b76:	6442                	ld	s0,16(sp)
    2b78:	64a2                	ld	s1,8(sp)
    2b7a:	6105                	addi	sp,sp,32
    2b7c:	8082                	ret
    printf("%s: mkdir failed\n", s);
    2b7e:	85a6                	mv	a1,s1
    2b80:	00004517          	auipc	a0,0x4
    2b84:	e2050513          	addi	a0,a0,-480 # 69a0 <malloc+0x1204>
    2b88:	00003097          	auipc	ra,0x3
    2b8c:	b5c080e7          	jalr	-1188(ra) # 56e4 <printf>
    exit(1);
    2b90:	4505                	li	a0,1
    2b92:	00002097          	auipc	ra,0x2
    2b96:	7d8080e7          	jalr	2008(ra) # 536a <exit>
    printf("%s: chdir iputdir failed\n", s);
    2b9a:	85a6                	mv	a1,s1
    2b9c:	00004517          	auipc	a0,0x4
    2ba0:	e1c50513          	addi	a0,a0,-484 # 69b8 <malloc+0x121c>
    2ba4:	00003097          	auipc	ra,0x3
    2ba8:	b40080e7          	jalr	-1216(ra) # 56e4 <printf>
    exit(1);
    2bac:	4505                	li	a0,1
    2bae:	00002097          	auipc	ra,0x2
    2bb2:	7bc080e7          	jalr	1980(ra) # 536a <exit>
    printf("%s: unlink ../iputdir failed\n", s);
    2bb6:	85a6                	mv	a1,s1
    2bb8:	00004517          	auipc	a0,0x4
    2bbc:	e3050513          	addi	a0,a0,-464 # 69e8 <malloc+0x124c>
    2bc0:	00003097          	auipc	ra,0x3
    2bc4:	b24080e7          	jalr	-1244(ra) # 56e4 <printf>
    exit(1);
    2bc8:	4505                	li	a0,1
    2bca:	00002097          	auipc	ra,0x2
    2bce:	7a0080e7          	jalr	1952(ra) # 536a <exit>
    printf("%s: chdir / failed\n", s);
    2bd2:	85a6                	mv	a1,s1
    2bd4:	00004517          	auipc	a0,0x4
    2bd8:	e3c50513          	addi	a0,a0,-452 # 6a10 <malloc+0x1274>
    2bdc:	00003097          	auipc	ra,0x3
    2be0:	b08080e7          	jalr	-1272(ra) # 56e4 <printf>
    exit(1);
    2be4:	4505                	li	a0,1
    2be6:	00002097          	auipc	ra,0x2
    2bea:	784080e7          	jalr	1924(ra) # 536a <exit>

0000000000002bee <exitiputtest>:
{
    2bee:	7179                	addi	sp,sp,-48
    2bf0:	f406                	sd	ra,40(sp)
    2bf2:	f022                	sd	s0,32(sp)
    2bf4:	ec26                	sd	s1,24(sp)
    2bf6:	1800                	addi	s0,sp,48
    2bf8:	84aa                	mv	s1,a0
  pid = fork();
    2bfa:	00002097          	auipc	ra,0x2
    2bfe:	768080e7          	jalr	1896(ra) # 5362 <fork>
  if(pid < 0){
    2c02:	04054663          	bltz	a0,2c4e <exitiputtest+0x60>
  if(pid == 0){
    2c06:	ed45                	bnez	a0,2cbe <exitiputtest+0xd0>
    if(mkdir("iputdir") < 0){
    2c08:	00004517          	auipc	a0,0x4
    2c0c:	d9050513          	addi	a0,a0,-624 # 6998 <malloc+0x11fc>
    2c10:	00002097          	auipc	ra,0x2
    2c14:	7c2080e7          	jalr	1986(ra) # 53d2 <mkdir>
    2c18:	04054963          	bltz	a0,2c6a <exitiputtest+0x7c>
    if(chdir("iputdir") < 0){
    2c1c:	00004517          	auipc	a0,0x4
    2c20:	d7c50513          	addi	a0,a0,-644 # 6998 <malloc+0x11fc>
    2c24:	00002097          	auipc	ra,0x2
    2c28:	7b6080e7          	jalr	1974(ra) # 53da <chdir>
    2c2c:	04054d63          	bltz	a0,2c86 <exitiputtest+0x98>
    if(unlink("../iputdir") < 0){
    2c30:	00004517          	auipc	a0,0x4
    2c34:	da850513          	addi	a0,a0,-600 # 69d8 <malloc+0x123c>
    2c38:	00002097          	auipc	ra,0x2
    2c3c:	782080e7          	jalr	1922(ra) # 53ba <unlink>
    2c40:	06054163          	bltz	a0,2ca2 <exitiputtest+0xb4>
    exit(0);
    2c44:	4501                	li	a0,0
    2c46:	00002097          	auipc	ra,0x2
    2c4a:	724080e7          	jalr	1828(ra) # 536a <exit>
    printf("%s: fork failed\n", s);
    2c4e:	85a6                	mv	a1,s1
    2c50:	00003517          	auipc	a0,0x3
    2c54:	4c850513          	addi	a0,a0,1224 # 6118 <malloc+0x97c>
    2c58:	00003097          	auipc	ra,0x3
    2c5c:	a8c080e7          	jalr	-1396(ra) # 56e4 <printf>
    exit(1);
    2c60:	4505                	li	a0,1
    2c62:	00002097          	auipc	ra,0x2
    2c66:	708080e7          	jalr	1800(ra) # 536a <exit>
      printf("%s: mkdir failed\n", s);
    2c6a:	85a6                	mv	a1,s1
    2c6c:	00004517          	auipc	a0,0x4
    2c70:	d3450513          	addi	a0,a0,-716 # 69a0 <malloc+0x1204>
    2c74:	00003097          	auipc	ra,0x3
    2c78:	a70080e7          	jalr	-1424(ra) # 56e4 <printf>
      exit(1);
    2c7c:	4505                	li	a0,1
    2c7e:	00002097          	auipc	ra,0x2
    2c82:	6ec080e7          	jalr	1772(ra) # 536a <exit>
      printf("%s: child chdir failed\n", s);
    2c86:	85a6                	mv	a1,s1
    2c88:	00004517          	auipc	a0,0x4
    2c8c:	da050513          	addi	a0,a0,-608 # 6a28 <malloc+0x128c>
    2c90:	00003097          	auipc	ra,0x3
    2c94:	a54080e7          	jalr	-1452(ra) # 56e4 <printf>
      exit(1);
    2c98:	4505                	li	a0,1
    2c9a:	00002097          	auipc	ra,0x2
    2c9e:	6d0080e7          	jalr	1744(ra) # 536a <exit>
      printf("%s: unlink ../iputdir failed\n", s);
    2ca2:	85a6                	mv	a1,s1
    2ca4:	00004517          	auipc	a0,0x4
    2ca8:	d4450513          	addi	a0,a0,-700 # 69e8 <malloc+0x124c>
    2cac:	00003097          	auipc	ra,0x3
    2cb0:	a38080e7          	jalr	-1480(ra) # 56e4 <printf>
      exit(1);
    2cb4:	4505                	li	a0,1
    2cb6:	00002097          	auipc	ra,0x2
    2cba:	6b4080e7          	jalr	1716(ra) # 536a <exit>
  wait(&xstatus);
    2cbe:	fdc40513          	addi	a0,s0,-36
    2cc2:	00002097          	auipc	ra,0x2
    2cc6:	6b0080e7          	jalr	1712(ra) # 5372 <wait>
  exit(xstatus);
    2cca:	fdc42503          	lw	a0,-36(s0)
    2cce:	00002097          	auipc	ra,0x2
    2cd2:	69c080e7          	jalr	1692(ra) # 536a <exit>

0000000000002cd6 <subdir>:
{
    2cd6:	1101                	addi	sp,sp,-32
    2cd8:	ec06                	sd	ra,24(sp)
    2cda:	e822                	sd	s0,16(sp)
    2cdc:	e426                	sd	s1,8(sp)
    2cde:	e04a                	sd	s2,0(sp)
    2ce0:	1000                	addi	s0,sp,32
    2ce2:	892a                	mv	s2,a0
  unlink("ff");
    2ce4:	00004517          	auipc	a0,0x4
    2ce8:	e8c50513          	addi	a0,a0,-372 # 6b70 <malloc+0x13d4>
    2cec:	00002097          	auipc	ra,0x2
    2cf0:	6ce080e7          	jalr	1742(ra) # 53ba <unlink>
  if(mkdir("dd") != 0){
    2cf4:	00004517          	auipc	a0,0x4
    2cf8:	d4c50513          	addi	a0,a0,-692 # 6a40 <malloc+0x12a4>
    2cfc:	00002097          	auipc	ra,0x2
    2d00:	6d6080e7          	jalr	1750(ra) # 53d2 <mkdir>
    2d04:	38051663          	bnez	a0,3090 <subdir+0x3ba>
  fd = open("dd/ff", O_CREATE | O_RDWR);
    2d08:	20200593          	li	a1,514
    2d0c:	00004517          	auipc	a0,0x4
    2d10:	d5450513          	addi	a0,a0,-684 # 6a60 <malloc+0x12c4>
    2d14:	00002097          	auipc	ra,0x2
    2d18:	696080e7          	jalr	1686(ra) # 53aa <open>
    2d1c:	84aa                	mv	s1,a0
  if(fd < 0){
    2d1e:	38054763          	bltz	a0,30ac <subdir+0x3d6>
  write(fd, "ff", 2);
    2d22:	4609                	li	a2,2
    2d24:	00004597          	auipc	a1,0x4
    2d28:	e4c58593          	addi	a1,a1,-436 # 6b70 <malloc+0x13d4>
    2d2c:	00002097          	auipc	ra,0x2
    2d30:	65e080e7          	jalr	1630(ra) # 538a <write>
  close(fd);
    2d34:	8526                	mv	a0,s1
    2d36:	00002097          	auipc	ra,0x2
    2d3a:	65c080e7          	jalr	1628(ra) # 5392 <close>
  if(unlink("dd") >= 0){
    2d3e:	00004517          	auipc	a0,0x4
    2d42:	d0250513          	addi	a0,a0,-766 # 6a40 <malloc+0x12a4>
    2d46:	00002097          	auipc	ra,0x2
    2d4a:	674080e7          	jalr	1652(ra) # 53ba <unlink>
    2d4e:	36055d63          	bgez	a0,30c8 <subdir+0x3f2>
  if(mkdir("/dd/dd") != 0){
    2d52:	00004517          	auipc	a0,0x4
    2d56:	d6650513          	addi	a0,a0,-666 # 6ab8 <malloc+0x131c>
    2d5a:	00002097          	auipc	ra,0x2
    2d5e:	678080e7          	jalr	1656(ra) # 53d2 <mkdir>
    2d62:	38051163          	bnez	a0,30e4 <subdir+0x40e>
  fd = open("dd/dd/ff", O_CREATE | O_RDWR);
    2d66:	20200593          	li	a1,514
    2d6a:	00004517          	auipc	a0,0x4
    2d6e:	d7650513          	addi	a0,a0,-650 # 6ae0 <malloc+0x1344>
    2d72:	00002097          	auipc	ra,0x2
    2d76:	638080e7          	jalr	1592(ra) # 53aa <open>
    2d7a:	84aa                	mv	s1,a0
  if(fd < 0){
    2d7c:	38054263          	bltz	a0,3100 <subdir+0x42a>
  write(fd, "FF", 2);
    2d80:	4609                	li	a2,2
    2d82:	00004597          	auipc	a1,0x4
    2d86:	d8e58593          	addi	a1,a1,-626 # 6b10 <malloc+0x1374>
    2d8a:	00002097          	auipc	ra,0x2
    2d8e:	600080e7          	jalr	1536(ra) # 538a <write>
  close(fd);
    2d92:	8526                	mv	a0,s1
    2d94:	00002097          	auipc	ra,0x2
    2d98:	5fe080e7          	jalr	1534(ra) # 5392 <close>
  fd = open("dd/dd/../ff", 0);
    2d9c:	4581                	li	a1,0
    2d9e:	00004517          	auipc	a0,0x4
    2da2:	d7a50513          	addi	a0,a0,-646 # 6b18 <malloc+0x137c>
    2da6:	00002097          	auipc	ra,0x2
    2daa:	604080e7          	jalr	1540(ra) # 53aa <open>
    2dae:	84aa                	mv	s1,a0
  if(fd < 0){
    2db0:	36054663          	bltz	a0,311c <subdir+0x446>
  cc = read(fd, buf, sizeof(buf));
    2db4:	660d                	lui	a2,0x3
    2db6:	00009597          	auipc	a1,0x9
    2dba:	9ca58593          	addi	a1,a1,-1590 # b780 <buf>
    2dbe:	00002097          	auipc	ra,0x2
    2dc2:	5c4080e7          	jalr	1476(ra) # 5382 <read>
  if(cc != 2 || buf[0] != 'f'){
    2dc6:	4789                	li	a5,2
    2dc8:	36f51863          	bne	a0,a5,3138 <subdir+0x462>
    2dcc:	00009717          	auipc	a4,0x9
    2dd0:	9b474703          	lbu	a4,-1612(a4) # b780 <buf>
    2dd4:	06600793          	li	a5,102
    2dd8:	36f71063          	bne	a4,a5,3138 <subdir+0x462>
  close(fd);
    2ddc:	8526                	mv	a0,s1
    2dde:	00002097          	auipc	ra,0x2
    2de2:	5b4080e7          	jalr	1460(ra) # 5392 <close>
  if(link("dd/dd/ff", "dd/dd/ffff") != 0){
    2de6:	00004597          	auipc	a1,0x4
    2dea:	d8258593          	addi	a1,a1,-638 # 6b68 <malloc+0x13cc>
    2dee:	00004517          	auipc	a0,0x4
    2df2:	cf250513          	addi	a0,a0,-782 # 6ae0 <malloc+0x1344>
    2df6:	00002097          	auipc	ra,0x2
    2dfa:	5d4080e7          	jalr	1492(ra) # 53ca <link>
    2dfe:	34051b63          	bnez	a0,3154 <subdir+0x47e>
  if(unlink("dd/dd/ff") != 0){
    2e02:	00004517          	auipc	a0,0x4
    2e06:	cde50513          	addi	a0,a0,-802 # 6ae0 <malloc+0x1344>
    2e0a:	00002097          	auipc	ra,0x2
    2e0e:	5b0080e7          	jalr	1456(ra) # 53ba <unlink>
    2e12:	34051f63          	bnez	a0,3170 <subdir+0x49a>
  if(open("dd/dd/ff", O_RDONLY) >= 0){
    2e16:	4581                	li	a1,0
    2e18:	00004517          	auipc	a0,0x4
    2e1c:	cc850513          	addi	a0,a0,-824 # 6ae0 <malloc+0x1344>
    2e20:	00002097          	auipc	ra,0x2
    2e24:	58a080e7          	jalr	1418(ra) # 53aa <open>
    2e28:	36055263          	bgez	a0,318c <subdir+0x4b6>
  if(chdir("dd") != 0){
    2e2c:	00004517          	auipc	a0,0x4
    2e30:	c1450513          	addi	a0,a0,-1004 # 6a40 <malloc+0x12a4>
    2e34:	00002097          	auipc	ra,0x2
    2e38:	5a6080e7          	jalr	1446(ra) # 53da <chdir>
    2e3c:	36051663          	bnez	a0,31a8 <subdir+0x4d2>
  if(chdir("dd/../../dd") != 0){
    2e40:	00004517          	auipc	a0,0x4
    2e44:	dc050513          	addi	a0,a0,-576 # 6c00 <malloc+0x1464>
    2e48:	00002097          	auipc	ra,0x2
    2e4c:	592080e7          	jalr	1426(ra) # 53da <chdir>
    2e50:	36051a63          	bnez	a0,31c4 <subdir+0x4ee>
  if(chdir("dd/../../../dd") != 0){
    2e54:	00004517          	auipc	a0,0x4
    2e58:	ddc50513          	addi	a0,a0,-548 # 6c30 <malloc+0x1494>
    2e5c:	00002097          	auipc	ra,0x2
    2e60:	57e080e7          	jalr	1406(ra) # 53da <chdir>
    2e64:	36051e63          	bnez	a0,31e0 <subdir+0x50a>
  if(chdir("./..") != 0){
    2e68:	00004517          	auipc	a0,0x4
    2e6c:	df850513          	addi	a0,a0,-520 # 6c60 <malloc+0x14c4>
    2e70:	00002097          	auipc	ra,0x2
    2e74:	56a080e7          	jalr	1386(ra) # 53da <chdir>
    2e78:	38051263          	bnez	a0,31fc <subdir+0x526>
  fd = open("dd/dd/ffff", 0);
    2e7c:	4581                	li	a1,0
    2e7e:	00004517          	auipc	a0,0x4
    2e82:	cea50513          	addi	a0,a0,-790 # 6b68 <malloc+0x13cc>
    2e86:	00002097          	auipc	ra,0x2
    2e8a:	524080e7          	jalr	1316(ra) # 53aa <open>
    2e8e:	84aa                	mv	s1,a0
  if(fd < 0){
    2e90:	38054463          	bltz	a0,3218 <subdir+0x542>
  if(read(fd, buf, sizeof(buf)) != 2){
    2e94:	660d                	lui	a2,0x3
    2e96:	00009597          	auipc	a1,0x9
    2e9a:	8ea58593          	addi	a1,a1,-1814 # b780 <buf>
    2e9e:	00002097          	auipc	ra,0x2
    2ea2:	4e4080e7          	jalr	1252(ra) # 5382 <read>
    2ea6:	4789                	li	a5,2
    2ea8:	38f51663          	bne	a0,a5,3234 <subdir+0x55e>
  close(fd);
    2eac:	8526                	mv	a0,s1
    2eae:	00002097          	auipc	ra,0x2
    2eb2:	4e4080e7          	jalr	1252(ra) # 5392 <close>
  if(open("dd/dd/ff", O_RDONLY) >= 0){
    2eb6:	4581                	li	a1,0
    2eb8:	00004517          	auipc	a0,0x4
    2ebc:	c2850513          	addi	a0,a0,-984 # 6ae0 <malloc+0x1344>
    2ec0:	00002097          	auipc	ra,0x2
    2ec4:	4ea080e7          	jalr	1258(ra) # 53aa <open>
    2ec8:	38055463          	bgez	a0,3250 <subdir+0x57a>
  if(open("dd/ff/ff", O_CREATE|O_RDWR) >= 0){
    2ecc:	20200593          	li	a1,514
    2ed0:	00004517          	auipc	a0,0x4
    2ed4:	e2050513          	addi	a0,a0,-480 # 6cf0 <malloc+0x1554>
    2ed8:	00002097          	auipc	ra,0x2
    2edc:	4d2080e7          	jalr	1234(ra) # 53aa <open>
    2ee0:	38055663          	bgez	a0,326c <subdir+0x596>
  if(open("dd/xx/ff", O_CREATE|O_RDWR) >= 0){
    2ee4:	20200593          	li	a1,514
    2ee8:	00004517          	auipc	a0,0x4
    2eec:	e3850513          	addi	a0,a0,-456 # 6d20 <malloc+0x1584>
    2ef0:	00002097          	auipc	ra,0x2
    2ef4:	4ba080e7          	jalr	1210(ra) # 53aa <open>
    2ef8:	38055863          	bgez	a0,3288 <subdir+0x5b2>
  if(open("dd", O_CREATE) >= 0){
    2efc:	20000593          	li	a1,512
    2f00:	00004517          	auipc	a0,0x4
    2f04:	b4050513          	addi	a0,a0,-1216 # 6a40 <malloc+0x12a4>
    2f08:	00002097          	auipc	ra,0x2
    2f0c:	4a2080e7          	jalr	1186(ra) # 53aa <open>
    2f10:	38055a63          	bgez	a0,32a4 <subdir+0x5ce>
  if(open("dd", O_RDWR) >= 0){
    2f14:	4589                	li	a1,2
    2f16:	00004517          	auipc	a0,0x4
    2f1a:	b2a50513          	addi	a0,a0,-1238 # 6a40 <malloc+0x12a4>
    2f1e:	00002097          	auipc	ra,0x2
    2f22:	48c080e7          	jalr	1164(ra) # 53aa <open>
    2f26:	38055d63          	bgez	a0,32c0 <subdir+0x5ea>
  if(open("dd", O_WRONLY) >= 0){
    2f2a:	4585                	li	a1,1
    2f2c:	00004517          	auipc	a0,0x4
    2f30:	b1450513          	addi	a0,a0,-1260 # 6a40 <malloc+0x12a4>
    2f34:	00002097          	auipc	ra,0x2
    2f38:	476080e7          	jalr	1142(ra) # 53aa <open>
    2f3c:	3a055063          	bgez	a0,32dc <subdir+0x606>
  if(link("dd/ff/ff", "dd/dd/xx") == 0){
    2f40:	00004597          	auipc	a1,0x4
    2f44:	e7058593          	addi	a1,a1,-400 # 6db0 <malloc+0x1614>
    2f48:	00004517          	auipc	a0,0x4
    2f4c:	da850513          	addi	a0,a0,-600 # 6cf0 <malloc+0x1554>
    2f50:	00002097          	auipc	ra,0x2
    2f54:	47a080e7          	jalr	1146(ra) # 53ca <link>
    2f58:	3a050063          	beqz	a0,32f8 <subdir+0x622>
  if(link("dd/xx/ff", "dd/dd/xx") == 0){
    2f5c:	00004597          	auipc	a1,0x4
    2f60:	e5458593          	addi	a1,a1,-428 # 6db0 <malloc+0x1614>
    2f64:	00004517          	auipc	a0,0x4
    2f68:	dbc50513          	addi	a0,a0,-580 # 6d20 <malloc+0x1584>
    2f6c:	00002097          	auipc	ra,0x2
    2f70:	45e080e7          	jalr	1118(ra) # 53ca <link>
    2f74:	3a050063          	beqz	a0,3314 <subdir+0x63e>
  if(link("dd/ff", "dd/dd/ffff") == 0){
    2f78:	00004597          	auipc	a1,0x4
    2f7c:	bf058593          	addi	a1,a1,-1040 # 6b68 <malloc+0x13cc>
    2f80:	00004517          	auipc	a0,0x4
    2f84:	ae050513          	addi	a0,a0,-1312 # 6a60 <malloc+0x12c4>
    2f88:	00002097          	auipc	ra,0x2
    2f8c:	442080e7          	jalr	1090(ra) # 53ca <link>
    2f90:	3a050063          	beqz	a0,3330 <subdir+0x65a>
  if(mkdir("dd/ff/ff") == 0){
    2f94:	00004517          	auipc	a0,0x4
    2f98:	d5c50513          	addi	a0,a0,-676 # 6cf0 <malloc+0x1554>
    2f9c:	00002097          	auipc	ra,0x2
    2fa0:	436080e7          	jalr	1078(ra) # 53d2 <mkdir>
    2fa4:	3a050463          	beqz	a0,334c <subdir+0x676>
  if(mkdir("dd/xx/ff") == 0){
    2fa8:	00004517          	auipc	a0,0x4
    2fac:	d7850513          	addi	a0,a0,-648 # 6d20 <malloc+0x1584>
    2fb0:	00002097          	auipc	ra,0x2
    2fb4:	422080e7          	jalr	1058(ra) # 53d2 <mkdir>
    2fb8:	3a050863          	beqz	a0,3368 <subdir+0x692>
  if(mkdir("dd/dd/ffff") == 0){
    2fbc:	00004517          	auipc	a0,0x4
    2fc0:	bac50513          	addi	a0,a0,-1108 # 6b68 <malloc+0x13cc>
    2fc4:	00002097          	auipc	ra,0x2
    2fc8:	40e080e7          	jalr	1038(ra) # 53d2 <mkdir>
    2fcc:	3a050c63          	beqz	a0,3384 <subdir+0x6ae>
  if(unlink("dd/xx/ff") == 0){
    2fd0:	00004517          	auipc	a0,0x4
    2fd4:	d5050513          	addi	a0,a0,-688 # 6d20 <malloc+0x1584>
    2fd8:	00002097          	auipc	ra,0x2
    2fdc:	3e2080e7          	jalr	994(ra) # 53ba <unlink>
    2fe0:	3c050063          	beqz	a0,33a0 <subdir+0x6ca>
  if(unlink("dd/ff/ff") == 0){
    2fe4:	00004517          	auipc	a0,0x4
    2fe8:	d0c50513          	addi	a0,a0,-756 # 6cf0 <malloc+0x1554>
    2fec:	00002097          	auipc	ra,0x2
    2ff0:	3ce080e7          	jalr	974(ra) # 53ba <unlink>
    2ff4:	3c050463          	beqz	a0,33bc <subdir+0x6e6>
  if(chdir("dd/ff") == 0){
    2ff8:	00004517          	auipc	a0,0x4
    2ffc:	a6850513          	addi	a0,a0,-1432 # 6a60 <malloc+0x12c4>
    3000:	00002097          	auipc	ra,0x2
    3004:	3da080e7          	jalr	986(ra) # 53da <chdir>
    3008:	3c050863          	beqz	a0,33d8 <subdir+0x702>
  if(chdir("dd/xx") == 0){
    300c:	00004517          	auipc	a0,0x4
    3010:	ef450513          	addi	a0,a0,-268 # 6f00 <malloc+0x1764>
    3014:	00002097          	auipc	ra,0x2
    3018:	3c6080e7          	jalr	966(ra) # 53da <chdir>
    301c:	3c050c63          	beqz	a0,33f4 <subdir+0x71e>
  if(unlink("dd/dd/ffff") != 0){
    3020:	00004517          	auipc	a0,0x4
    3024:	b4850513          	addi	a0,a0,-1208 # 6b68 <malloc+0x13cc>
    3028:	00002097          	auipc	ra,0x2
    302c:	392080e7          	jalr	914(ra) # 53ba <unlink>
    3030:	3e051063          	bnez	a0,3410 <subdir+0x73a>
  if(unlink("dd/ff") != 0){
    3034:	00004517          	auipc	a0,0x4
    3038:	a2c50513          	addi	a0,a0,-1492 # 6a60 <malloc+0x12c4>
    303c:	00002097          	auipc	ra,0x2
    3040:	37e080e7          	jalr	894(ra) # 53ba <unlink>
    3044:	3e051463          	bnez	a0,342c <subdir+0x756>
  if(unlink("dd") == 0){
    3048:	00004517          	auipc	a0,0x4
    304c:	9f850513          	addi	a0,a0,-1544 # 6a40 <malloc+0x12a4>
    3050:	00002097          	auipc	ra,0x2
    3054:	36a080e7          	jalr	874(ra) # 53ba <unlink>
    3058:	3e050863          	beqz	a0,3448 <subdir+0x772>
  if(unlink("dd/dd") < 0){
    305c:	00004517          	auipc	a0,0x4
    3060:	f1450513          	addi	a0,a0,-236 # 6f70 <malloc+0x17d4>
    3064:	00002097          	auipc	ra,0x2
    3068:	356080e7          	jalr	854(ra) # 53ba <unlink>
    306c:	3e054c63          	bltz	a0,3464 <subdir+0x78e>
  if(unlink("dd") < 0){
    3070:	00004517          	auipc	a0,0x4
    3074:	9d050513          	addi	a0,a0,-1584 # 6a40 <malloc+0x12a4>
    3078:	00002097          	auipc	ra,0x2
    307c:	342080e7          	jalr	834(ra) # 53ba <unlink>
    3080:	40054063          	bltz	a0,3480 <subdir+0x7aa>
}
    3084:	60e2                	ld	ra,24(sp)
    3086:	6442                	ld	s0,16(sp)
    3088:	64a2                	ld	s1,8(sp)
    308a:	6902                	ld	s2,0(sp)
    308c:	6105                	addi	sp,sp,32
    308e:	8082                	ret
    printf("%s: mkdir dd failed\n", s);
    3090:	85ca                	mv	a1,s2
    3092:	00004517          	auipc	a0,0x4
    3096:	9b650513          	addi	a0,a0,-1610 # 6a48 <malloc+0x12ac>
    309a:	00002097          	auipc	ra,0x2
    309e:	64a080e7          	jalr	1610(ra) # 56e4 <printf>
    exit(1);
    30a2:	4505                	li	a0,1
    30a4:	00002097          	auipc	ra,0x2
    30a8:	2c6080e7          	jalr	710(ra) # 536a <exit>
    printf("%s: create dd/ff failed\n", s);
    30ac:	85ca                	mv	a1,s2
    30ae:	00004517          	auipc	a0,0x4
    30b2:	9ba50513          	addi	a0,a0,-1606 # 6a68 <malloc+0x12cc>
    30b6:	00002097          	auipc	ra,0x2
    30ba:	62e080e7          	jalr	1582(ra) # 56e4 <printf>
    exit(1);
    30be:	4505                	li	a0,1
    30c0:	00002097          	auipc	ra,0x2
    30c4:	2aa080e7          	jalr	682(ra) # 536a <exit>
    printf("%s: unlink dd (non-empty dir) succeeded!\n", s);
    30c8:	85ca                	mv	a1,s2
    30ca:	00004517          	auipc	a0,0x4
    30ce:	9be50513          	addi	a0,a0,-1602 # 6a88 <malloc+0x12ec>
    30d2:	00002097          	auipc	ra,0x2
    30d6:	612080e7          	jalr	1554(ra) # 56e4 <printf>
    exit(1);
    30da:	4505                	li	a0,1
    30dc:	00002097          	auipc	ra,0x2
    30e0:	28e080e7          	jalr	654(ra) # 536a <exit>
    printf("subdir mkdir dd/dd failed\n", s);
    30e4:	85ca                	mv	a1,s2
    30e6:	00004517          	auipc	a0,0x4
    30ea:	9da50513          	addi	a0,a0,-1574 # 6ac0 <malloc+0x1324>
    30ee:	00002097          	auipc	ra,0x2
    30f2:	5f6080e7          	jalr	1526(ra) # 56e4 <printf>
    exit(1);
    30f6:	4505                	li	a0,1
    30f8:	00002097          	auipc	ra,0x2
    30fc:	272080e7          	jalr	626(ra) # 536a <exit>
    printf("%s: create dd/dd/ff failed\n", s);
    3100:	85ca                	mv	a1,s2
    3102:	00004517          	auipc	a0,0x4
    3106:	9ee50513          	addi	a0,a0,-1554 # 6af0 <malloc+0x1354>
    310a:	00002097          	auipc	ra,0x2
    310e:	5da080e7          	jalr	1498(ra) # 56e4 <printf>
    exit(1);
    3112:	4505                	li	a0,1
    3114:	00002097          	auipc	ra,0x2
    3118:	256080e7          	jalr	598(ra) # 536a <exit>
    printf("%s: open dd/dd/../ff failed\n", s);
    311c:	85ca                	mv	a1,s2
    311e:	00004517          	auipc	a0,0x4
    3122:	a0a50513          	addi	a0,a0,-1526 # 6b28 <malloc+0x138c>
    3126:	00002097          	auipc	ra,0x2
    312a:	5be080e7          	jalr	1470(ra) # 56e4 <printf>
    exit(1);
    312e:	4505                	li	a0,1
    3130:	00002097          	auipc	ra,0x2
    3134:	23a080e7          	jalr	570(ra) # 536a <exit>
    printf("%s: dd/dd/../ff wrong content\n", s);
    3138:	85ca                	mv	a1,s2
    313a:	00004517          	auipc	a0,0x4
    313e:	a0e50513          	addi	a0,a0,-1522 # 6b48 <malloc+0x13ac>
    3142:	00002097          	auipc	ra,0x2
    3146:	5a2080e7          	jalr	1442(ra) # 56e4 <printf>
    exit(1);
    314a:	4505                	li	a0,1
    314c:	00002097          	auipc	ra,0x2
    3150:	21e080e7          	jalr	542(ra) # 536a <exit>
    printf("link dd/dd/ff dd/dd/ffff failed\n", s);
    3154:	85ca                	mv	a1,s2
    3156:	00004517          	auipc	a0,0x4
    315a:	a2250513          	addi	a0,a0,-1502 # 6b78 <malloc+0x13dc>
    315e:	00002097          	auipc	ra,0x2
    3162:	586080e7          	jalr	1414(ra) # 56e4 <printf>
    exit(1);
    3166:	4505                	li	a0,1
    3168:	00002097          	auipc	ra,0x2
    316c:	202080e7          	jalr	514(ra) # 536a <exit>
    printf("%s: unlink dd/dd/ff failed\n", s);
    3170:	85ca                	mv	a1,s2
    3172:	00004517          	auipc	a0,0x4
    3176:	a2e50513          	addi	a0,a0,-1490 # 6ba0 <malloc+0x1404>
    317a:	00002097          	auipc	ra,0x2
    317e:	56a080e7          	jalr	1386(ra) # 56e4 <printf>
    exit(1);
    3182:	4505                	li	a0,1
    3184:	00002097          	auipc	ra,0x2
    3188:	1e6080e7          	jalr	486(ra) # 536a <exit>
    printf("%s: open (unlinked) dd/dd/ff succeeded\n", s);
    318c:	85ca                	mv	a1,s2
    318e:	00004517          	auipc	a0,0x4
    3192:	a3250513          	addi	a0,a0,-1486 # 6bc0 <malloc+0x1424>
    3196:	00002097          	auipc	ra,0x2
    319a:	54e080e7          	jalr	1358(ra) # 56e4 <printf>
    exit(1);
    319e:	4505                	li	a0,1
    31a0:	00002097          	auipc	ra,0x2
    31a4:	1ca080e7          	jalr	458(ra) # 536a <exit>
    printf("%s: chdir dd failed\n", s);
    31a8:	85ca                	mv	a1,s2
    31aa:	00004517          	auipc	a0,0x4
    31ae:	a3e50513          	addi	a0,a0,-1474 # 6be8 <malloc+0x144c>
    31b2:	00002097          	auipc	ra,0x2
    31b6:	532080e7          	jalr	1330(ra) # 56e4 <printf>
    exit(1);
    31ba:	4505                	li	a0,1
    31bc:	00002097          	auipc	ra,0x2
    31c0:	1ae080e7          	jalr	430(ra) # 536a <exit>
    printf("%s: chdir dd/../../dd failed\n", s);
    31c4:	85ca                	mv	a1,s2
    31c6:	00004517          	auipc	a0,0x4
    31ca:	a4a50513          	addi	a0,a0,-1462 # 6c10 <malloc+0x1474>
    31ce:	00002097          	auipc	ra,0x2
    31d2:	516080e7          	jalr	1302(ra) # 56e4 <printf>
    exit(1);
    31d6:	4505                	li	a0,1
    31d8:	00002097          	auipc	ra,0x2
    31dc:	192080e7          	jalr	402(ra) # 536a <exit>
    printf("chdir dd/../../dd failed\n", s);
    31e0:	85ca                	mv	a1,s2
    31e2:	00004517          	auipc	a0,0x4
    31e6:	a5e50513          	addi	a0,a0,-1442 # 6c40 <malloc+0x14a4>
    31ea:	00002097          	auipc	ra,0x2
    31ee:	4fa080e7          	jalr	1274(ra) # 56e4 <printf>
    exit(1);
    31f2:	4505                	li	a0,1
    31f4:	00002097          	auipc	ra,0x2
    31f8:	176080e7          	jalr	374(ra) # 536a <exit>
    printf("%s: chdir ./.. failed\n", s);
    31fc:	85ca                	mv	a1,s2
    31fe:	00004517          	auipc	a0,0x4
    3202:	a6a50513          	addi	a0,a0,-1430 # 6c68 <malloc+0x14cc>
    3206:	00002097          	auipc	ra,0x2
    320a:	4de080e7          	jalr	1246(ra) # 56e4 <printf>
    exit(1);
    320e:	4505                	li	a0,1
    3210:	00002097          	auipc	ra,0x2
    3214:	15a080e7          	jalr	346(ra) # 536a <exit>
    printf("%s: open dd/dd/ffff failed\n", s);
    3218:	85ca                	mv	a1,s2
    321a:	00004517          	auipc	a0,0x4
    321e:	a6650513          	addi	a0,a0,-1434 # 6c80 <malloc+0x14e4>
    3222:	00002097          	auipc	ra,0x2
    3226:	4c2080e7          	jalr	1218(ra) # 56e4 <printf>
    exit(1);
    322a:	4505                	li	a0,1
    322c:	00002097          	auipc	ra,0x2
    3230:	13e080e7          	jalr	318(ra) # 536a <exit>
    printf("%s: read dd/dd/ffff wrong len\n", s);
    3234:	85ca                	mv	a1,s2
    3236:	00004517          	auipc	a0,0x4
    323a:	a6a50513          	addi	a0,a0,-1430 # 6ca0 <malloc+0x1504>
    323e:	00002097          	auipc	ra,0x2
    3242:	4a6080e7          	jalr	1190(ra) # 56e4 <printf>
    exit(1);
    3246:	4505                	li	a0,1
    3248:	00002097          	auipc	ra,0x2
    324c:	122080e7          	jalr	290(ra) # 536a <exit>
    printf("%s: open (unlinked) dd/dd/ff succeeded!\n", s);
    3250:	85ca                	mv	a1,s2
    3252:	00004517          	auipc	a0,0x4
    3256:	a6e50513          	addi	a0,a0,-1426 # 6cc0 <malloc+0x1524>
    325a:	00002097          	auipc	ra,0x2
    325e:	48a080e7          	jalr	1162(ra) # 56e4 <printf>
    exit(1);
    3262:	4505                	li	a0,1
    3264:	00002097          	auipc	ra,0x2
    3268:	106080e7          	jalr	262(ra) # 536a <exit>
    printf("%s: create dd/ff/ff succeeded!\n", s);
    326c:	85ca                	mv	a1,s2
    326e:	00004517          	auipc	a0,0x4
    3272:	a9250513          	addi	a0,a0,-1390 # 6d00 <malloc+0x1564>
    3276:	00002097          	auipc	ra,0x2
    327a:	46e080e7          	jalr	1134(ra) # 56e4 <printf>
    exit(1);
    327e:	4505                	li	a0,1
    3280:	00002097          	auipc	ra,0x2
    3284:	0ea080e7          	jalr	234(ra) # 536a <exit>
    printf("%s: create dd/xx/ff succeeded!\n", s);
    3288:	85ca                	mv	a1,s2
    328a:	00004517          	auipc	a0,0x4
    328e:	aa650513          	addi	a0,a0,-1370 # 6d30 <malloc+0x1594>
    3292:	00002097          	auipc	ra,0x2
    3296:	452080e7          	jalr	1106(ra) # 56e4 <printf>
    exit(1);
    329a:	4505                	li	a0,1
    329c:	00002097          	auipc	ra,0x2
    32a0:	0ce080e7          	jalr	206(ra) # 536a <exit>
    printf("%s: create dd succeeded!\n", s);
    32a4:	85ca                	mv	a1,s2
    32a6:	00004517          	auipc	a0,0x4
    32aa:	aaa50513          	addi	a0,a0,-1366 # 6d50 <malloc+0x15b4>
    32ae:	00002097          	auipc	ra,0x2
    32b2:	436080e7          	jalr	1078(ra) # 56e4 <printf>
    exit(1);
    32b6:	4505                	li	a0,1
    32b8:	00002097          	auipc	ra,0x2
    32bc:	0b2080e7          	jalr	178(ra) # 536a <exit>
    printf("%s: open dd rdwr succeeded!\n", s);
    32c0:	85ca                	mv	a1,s2
    32c2:	00004517          	auipc	a0,0x4
    32c6:	aae50513          	addi	a0,a0,-1362 # 6d70 <malloc+0x15d4>
    32ca:	00002097          	auipc	ra,0x2
    32ce:	41a080e7          	jalr	1050(ra) # 56e4 <printf>
    exit(1);
    32d2:	4505                	li	a0,1
    32d4:	00002097          	auipc	ra,0x2
    32d8:	096080e7          	jalr	150(ra) # 536a <exit>
    printf("%s: open dd wronly succeeded!\n", s);
    32dc:	85ca                	mv	a1,s2
    32de:	00004517          	auipc	a0,0x4
    32e2:	ab250513          	addi	a0,a0,-1358 # 6d90 <malloc+0x15f4>
    32e6:	00002097          	auipc	ra,0x2
    32ea:	3fe080e7          	jalr	1022(ra) # 56e4 <printf>
    exit(1);
    32ee:	4505                	li	a0,1
    32f0:	00002097          	auipc	ra,0x2
    32f4:	07a080e7          	jalr	122(ra) # 536a <exit>
    printf("%s: link dd/ff/ff dd/dd/xx succeeded!\n", s);
    32f8:	85ca                	mv	a1,s2
    32fa:	00004517          	auipc	a0,0x4
    32fe:	ac650513          	addi	a0,a0,-1338 # 6dc0 <malloc+0x1624>
    3302:	00002097          	auipc	ra,0x2
    3306:	3e2080e7          	jalr	994(ra) # 56e4 <printf>
    exit(1);
    330a:	4505                	li	a0,1
    330c:	00002097          	auipc	ra,0x2
    3310:	05e080e7          	jalr	94(ra) # 536a <exit>
    printf("%s: link dd/xx/ff dd/dd/xx succeeded!\n", s);
    3314:	85ca                	mv	a1,s2
    3316:	00004517          	auipc	a0,0x4
    331a:	ad250513          	addi	a0,a0,-1326 # 6de8 <malloc+0x164c>
    331e:	00002097          	auipc	ra,0x2
    3322:	3c6080e7          	jalr	966(ra) # 56e4 <printf>
    exit(1);
    3326:	4505                	li	a0,1
    3328:	00002097          	auipc	ra,0x2
    332c:	042080e7          	jalr	66(ra) # 536a <exit>
    printf("%s: link dd/ff dd/dd/ffff succeeded!\n", s);
    3330:	85ca                	mv	a1,s2
    3332:	00004517          	auipc	a0,0x4
    3336:	ade50513          	addi	a0,a0,-1314 # 6e10 <malloc+0x1674>
    333a:	00002097          	auipc	ra,0x2
    333e:	3aa080e7          	jalr	938(ra) # 56e4 <printf>
    exit(1);
    3342:	4505                	li	a0,1
    3344:	00002097          	auipc	ra,0x2
    3348:	026080e7          	jalr	38(ra) # 536a <exit>
    printf("%s: mkdir dd/ff/ff succeeded!\n", s);
    334c:	85ca                	mv	a1,s2
    334e:	00004517          	auipc	a0,0x4
    3352:	aea50513          	addi	a0,a0,-1302 # 6e38 <malloc+0x169c>
    3356:	00002097          	auipc	ra,0x2
    335a:	38e080e7          	jalr	910(ra) # 56e4 <printf>
    exit(1);
    335e:	4505                	li	a0,1
    3360:	00002097          	auipc	ra,0x2
    3364:	00a080e7          	jalr	10(ra) # 536a <exit>
    printf("%s: mkdir dd/xx/ff succeeded!\n", s);
    3368:	85ca                	mv	a1,s2
    336a:	00004517          	auipc	a0,0x4
    336e:	aee50513          	addi	a0,a0,-1298 # 6e58 <malloc+0x16bc>
    3372:	00002097          	auipc	ra,0x2
    3376:	372080e7          	jalr	882(ra) # 56e4 <printf>
    exit(1);
    337a:	4505                	li	a0,1
    337c:	00002097          	auipc	ra,0x2
    3380:	fee080e7          	jalr	-18(ra) # 536a <exit>
    printf("%s: mkdir dd/dd/ffff succeeded!\n", s);
    3384:	85ca                	mv	a1,s2
    3386:	00004517          	auipc	a0,0x4
    338a:	af250513          	addi	a0,a0,-1294 # 6e78 <malloc+0x16dc>
    338e:	00002097          	auipc	ra,0x2
    3392:	356080e7          	jalr	854(ra) # 56e4 <printf>
    exit(1);
    3396:	4505                	li	a0,1
    3398:	00002097          	auipc	ra,0x2
    339c:	fd2080e7          	jalr	-46(ra) # 536a <exit>
    printf("%s: unlink dd/xx/ff succeeded!\n", s);
    33a0:	85ca                	mv	a1,s2
    33a2:	00004517          	auipc	a0,0x4
    33a6:	afe50513          	addi	a0,a0,-1282 # 6ea0 <malloc+0x1704>
    33aa:	00002097          	auipc	ra,0x2
    33ae:	33a080e7          	jalr	826(ra) # 56e4 <printf>
    exit(1);
    33b2:	4505                	li	a0,1
    33b4:	00002097          	auipc	ra,0x2
    33b8:	fb6080e7          	jalr	-74(ra) # 536a <exit>
    printf("%s: unlink dd/ff/ff succeeded!\n", s);
    33bc:	85ca                	mv	a1,s2
    33be:	00004517          	auipc	a0,0x4
    33c2:	b0250513          	addi	a0,a0,-1278 # 6ec0 <malloc+0x1724>
    33c6:	00002097          	auipc	ra,0x2
    33ca:	31e080e7          	jalr	798(ra) # 56e4 <printf>
    exit(1);
    33ce:	4505                	li	a0,1
    33d0:	00002097          	auipc	ra,0x2
    33d4:	f9a080e7          	jalr	-102(ra) # 536a <exit>
    printf("%s: chdir dd/ff succeeded!\n", s);
    33d8:	85ca                	mv	a1,s2
    33da:	00004517          	auipc	a0,0x4
    33de:	b0650513          	addi	a0,a0,-1274 # 6ee0 <malloc+0x1744>
    33e2:	00002097          	auipc	ra,0x2
    33e6:	302080e7          	jalr	770(ra) # 56e4 <printf>
    exit(1);
    33ea:	4505                	li	a0,1
    33ec:	00002097          	auipc	ra,0x2
    33f0:	f7e080e7          	jalr	-130(ra) # 536a <exit>
    printf("%s: chdir dd/xx succeeded!\n", s);
    33f4:	85ca                	mv	a1,s2
    33f6:	00004517          	auipc	a0,0x4
    33fa:	b1250513          	addi	a0,a0,-1262 # 6f08 <malloc+0x176c>
    33fe:	00002097          	auipc	ra,0x2
    3402:	2e6080e7          	jalr	742(ra) # 56e4 <printf>
    exit(1);
    3406:	4505                	li	a0,1
    3408:	00002097          	auipc	ra,0x2
    340c:	f62080e7          	jalr	-158(ra) # 536a <exit>
    printf("%s: unlink dd/dd/ff failed\n", s);
    3410:	85ca                	mv	a1,s2
    3412:	00003517          	auipc	a0,0x3
    3416:	78e50513          	addi	a0,a0,1934 # 6ba0 <malloc+0x1404>
    341a:	00002097          	auipc	ra,0x2
    341e:	2ca080e7          	jalr	714(ra) # 56e4 <printf>
    exit(1);
    3422:	4505                	li	a0,1
    3424:	00002097          	auipc	ra,0x2
    3428:	f46080e7          	jalr	-186(ra) # 536a <exit>
    printf("%s: unlink dd/ff failed\n", s);
    342c:	85ca                	mv	a1,s2
    342e:	00004517          	auipc	a0,0x4
    3432:	afa50513          	addi	a0,a0,-1286 # 6f28 <malloc+0x178c>
    3436:	00002097          	auipc	ra,0x2
    343a:	2ae080e7          	jalr	686(ra) # 56e4 <printf>
    exit(1);
    343e:	4505                	li	a0,1
    3440:	00002097          	auipc	ra,0x2
    3444:	f2a080e7          	jalr	-214(ra) # 536a <exit>
    printf("%s: unlink non-empty dd succeeded!\n", s);
    3448:	85ca                	mv	a1,s2
    344a:	00004517          	auipc	a0,0x4
    344e:	afe50513          	addi	a0,a0,-1282 # 6f48 <malloc+0x17ac>
    3452:	00002097          	auipc	ra,0x2
    3456:	292080e7          	jalr	658(ra) # 56e4 <printf>
    exit(1);
    345a:	4505                	li	a0,1
    345c:	00002097          	auipc	ra,0x2
    3460:	f0e080e7          	jalr	-242(ra) # 536a <exit>
    printf("%s: unlink dd/dd failed\n", s);
    3464:	85ca                	mv	a1,s2
    3466:	00004517          	auipc	a0,0x4
    346a:	b1250513          	addi	a0,a0,-1262 # 6f78 <malloc+0x17dc>
    346e:	00002097          	auipc	ra,0x2
    3472:	276080e7          	jalr	630(ra) # 56e4 <printf>
    exit(1);
    3476:	4505                	li	a0,1
    3478:	00002097          	auipc	ra,0x2
    347c:	ef2080e7          	jalr	-270(ra) # 536a <exit>
    printf("%s: unlink dd failed\n", s);
    3480:	85ca                	mv	a1,s2
    3482:	00004517          	auipc	a0,0x4
    3486:	b1650513          	addi	a0,a0,-1258 # 6f98 <malloc+0x17fc>
    348a:	00002097          	auipc	ra,0x2
    348e:	25a080e7          	jalr	602(ra) # 56e4 <printf>
    exit(1);
    3492:	4505                	li	a0,1
    3494:	00002097          	auipc	ra,0x2
    3498:	ed6080e7          	jalr	-298(ra) # 536a <exit>

000000000000349c <rmdot>:
{
    349c:	1101                	addi	sp,sp,-32
    349e:	ec06                	sd	ra,24(sp)
    34a0:	e822                	sd	s0,16(sp)
    34a2:	e426                	sd	s1,8(sp)
    34a4:	1000                	addi	s0,sp,32
    34a6:	84aa                	mv	s1,a0
  if(mkdir("dots") != 0){
    34a8:	00004517          	auipc	a0,0x4
    34ac:	b0850513          	addi	a0,a0,-1272 # 6fb0 <malloc+0x1814>
    34b0:	00002097          	auipc	ra,0x2
    34b4:	f22080e7          	jalr	-222(ra) # 53d2 <mkdir>
    34b8:	e549                	bnez	a0,3542 <rmdot+0xa6>
  if(chdir("dots") != 0){
    34ba:	00004517          	auipc	a0,0x4
    34be:	af650513          	addi	a0,a0,-1290 # 6fb0 <malloc+0x1814>
    34c2:	00002097          	auipc	ra,0x2
    34c6:	f18080e7          	jalr	-232(ra) # 53da <chdir>
    34ca:	e951                	bnez	a0,355e <rmdot+0xc2>
  if(unlink(".") == 0){
    34cc:	00003517          	auipc	a0,0x3
    34d0:	aac50513          	addi	a0,a0,-1364 # 5f78 <malloc+0x7dc>
    34d4:	00002097          	auipc	ra,0x2
    34d8:	ee6080e7          	jalr	-282(ra) # 53ba <unlink>
    34dc:	cd59                	beqz	a0,357a <rmdot+0xde>
  if(unlink("..") == 0){
    34de:	00004517          	auipc	a0,0x4
    34e2:	b2250513          	addi	a0,a0,-1246 # 7000 <malloc+0x1864>
    34e6:	00002097          	auipc	ra,0x2
    34ea:	ed4080e7          	jalr	-300(ra) # 53ba <unlink>
    34ee:	c545                	beqz	a0,3596 <rmdot+0xfa>
  if(chdir("/") != 0){
    34f0:	00003517          	auipc	a0,0x3
    34f4:	51850513          	addi	a0,a0,1304 # 6a08 <malloc+0x126c>
    34f8:	00002097          	auipc	ra,0x2
    34fc:	ee2080e7          	jalr	-286(ra) # 53da <chdir>
    3500:	e94d                	bnez	a0,35b2 <rmdot+0x116>
  if(unlink("dots/.") == 0){
    3502:	00004517          	auipc	a0,0x4
    3506:	b1e50513          	addi	a0,a0,-1250 # 7020 <malloc+0x1884>
    350a:	00002097          	auipc	ra,0x2
    350e:	eb0080e7          	jalr	-336(ra) # 53ba <unlink>
    3512:	cd55                	beqz	a0,35ce <rmdot+0x132>
  if(unlink("dots/..") == 0){
    3514:	00004517          	auipc	a0,0x4
    3518:	b3450513          	addi	a0,a0,-1228 # 7048 <malloc+0x18ac>
    351c:	00002097          	auipc	ra,0x2
    3520:	e9e080e7          	jalr	-354(ra) # 53ba <unlink>
    3524:	c179                	beqz	a0,35ea <rmdot+0x14e>
  if(unlink("dots") != 0){
    3526:	00004517          	auipc	a0,0x4
    352a:	a8a50513          	addi	a0,a0,-1398 # 6fb0 <malloc+0x1814>
    352e:	00002097          	auipc	ra,0x2
    3532:	e8c080e7          	jalr	-372(ra) # 53ba <unlink>
    3536:	e961                	bnez	a0,3606 <rmdot+0x16a>
}
    3538:	60e2                	ld	ra,24(sp)
    353a:	6442                	ld	s0,16(sp)
    353c:	64a2                	ld	s1,8(sp)
    353e:	6105                	addi	sp,sp,32
    3540:	8082                	ret
    printf("%s: mkdir dots failed\n", s);
    3542:	85a6                	mv	a1,s1
    3544:	00004517          	auipc	a0,0x4
    3548:	a7450513          	addi	a0,a0,-1420 # 6fb8 <malloc+0x181c>
    354c:	00002097          	auipc	ra,0x2
    3550:	198080e7          	jalr	408(ra) # 56e4 <printf>
    exit(1);
    3554:	4505                	li	a0,1
    3556:	00002097          	auipc	ra,0x2
    355a:	e14080e7          	jalr	-492(ra) # 536a <exit>
    printf("%s: chdir dots failed\n", s);
    355e:	85a6                	mv	a1,s1
    3560:	00004517          	auipc	a0,0x4
    3564:	a7050513          	addi	a0,a0,-1424 # 6fd0 <malloc+0x1834>
    3568:	00002097          	auipc	ra,0x2
    356c:	17c080e7          	jalr	380(ra) # 56e4 <printf>
    exit(1);
    3570:	4505                	li	a0,1
    3572:	00002097          	auipc	ra,0x2
    3576:	df8080e7          	jalr	-520(ra) # 536a <exit>
    printf("%s: rm . worked!\n", s);
    357a:	85a6                	mv	a1,s1
    357c:	00004517          	auipc	a0,0x4
    3580:	a6c50513          	addi	a0,a0,-1428 # 6fe8 <malloc+0x184c>
    3584:	00002097          	auipc	ra,0x2
    3588:	160080e7          	jalr	352(ra) # 56e4 <printf>
    exit(1);
    358c:	4505                	li	a0,1
    358e:	00002097          	auipc	ra,0x2
    3592:	ddc080e7          	jalr	-548(ra) # 536a <exit>
    printf("%s: rm .. worked!\n", s);
    3596:	85a6                	mv	a1,s1
    3598:	00004517          	auipc	a0,0x4
    359c:	a7050513          	addi	a0,a0,-1424 # 7008 <malloc+0x186c>
    35a0:	00002097          	auipc	ra,0x2
    35a4:	144080e7          	jalr	324(ra) # 56e4 <printf>
    exit(1);
    35a8:	4505                	li	a0,1
    35aa:	00002097          	auipc	ra,0x2
    35ae:	dc0080e7          	jalr	-576(ra) # 536a <exit>
    printf("%s: chdir / failed\n", s);
    35b2:	85a6                	mv	a1,s1
    35b4:	00003517          	auipc	a0,0x3
    35b8:	45c50513          	addi	a0,a0,1116 # 6a10 <malloc+0x1274>
    35bc:	00002097          	auipc	ra,0x2
    35c0:	128080e7          	jalr	296(ra) # 56e4 <printf>
    exit(1);
    35c4:	4505                	li	a0,1
    35c6:	00002097          	auipc	ra,0x2
    35ca:	da4080e7          	jalr	-604(ra) # 536a <exit>
    printf("%s: unlink dots/. worked!\n", s);
    35ce:	85a6                	mv	a1,s1
    35d0:	00004517          	auipc	a0,0x4
    35d4:	a5850513          	addi	a0,a0,-1448 # 7028 <malloc+0x188c>
    35d8:	00002097          	auipc	ra,0x2
    35dc:	10c080e7          	jalr	268(ra) # 56e4 <printf>
    exit(1);
    35e0:	4505                	li	a0,1
    35e2:	00002097          	auipc	ra,0x2
    35e6:	d88080e7          	jalr	-632(ra) # 536a <exit>
    printf("%s: unlink dots/.. worked!\n", s);
    35ea:	85a6                	mv	a1,s1
    35ec:	00004517          	auipc	a0,0x4
    35f0:	a6450513          	addi	a0,a0,-1436 # 7050 <malloc+0x18b4>
    35f4:	00002097          	auipc	ra,0x2
    35f8:	0f0080e7          	jalr	240(ra) # 56e4 <printf>
    exit(1);
    35fc:	4505                	li	a0,1
    35fe:	00002097          	auipc	ra,0x2
    3602:	d6c080e7          	jalr	-660(ra) # 536a <exit>
    printf("%s: unlink dots failed!\n", s);
    3606:	85a6                	mv	a1,s1
    3608:	00004517          	auipc	a0,0x4
    360c:	a6850513          	addi	a0,a0,-1432 # 7070 <malloc+0x18d4>
    3610:	00002097          	auipc	ra,0x2
    3614:	0d4080e7          	jalr	212(ra) # 56e4 <printf>
    exit(1);
    3618:	4505                	li	a0,1
    361a:	00002097          	auipc	ra,0x2
    361e:	d50080e7          	jalr	-688(ra) # 536a <exit>

0000000000003622 <dirfile>:
{
    3622:	1101                	addi	sp,sp,-32
    3624:	ec06                	sd	ra,24(sp)
    3626:	e822                	sd	s0,16(sp)
    3628:	e426                	sd	s1,8(sp)
    362a:	e04a                	sd	s2,0(sp)
    362c:	1000                	addi	s0,sp,32
    362e:	892a                	mv	s2,a0
  fd = open("dirfile", O_CREATE);
    3630:	20000593          	li	a1,512
    3634:	00004517          	auipc	a0,0x4
    3638:	a5c50513          	addi	a0,a0,-1444 # 7090 <malloc+0x18f4>
    363c:	00002097          	auipc	ra,0x2
    3640:	d6e080e7          	jalr	-658(ra) # 53aa <open>
  if(fd < 0){
    3644:	0e054d63          	bltz	a0,373e <dirfile+0x11c>
  close(fd);
    3648:	00002097          	auipc	ra,0x2
    364c:	d4a080e7          	jalr	-694(ra) # 5392 <close>
  if(chdir("dirfile") == 0){
    3650:	00004517          	auipc	a0,0x4
    3654:	a4050513          	addi	a0,a0,-1472 # 7090 <malloc+0x18f4>
    3658:	00002097          	auipc	ra,0x2
    365c:	d82080e7          	jalr	-638(ra) # 53da <chdir>
    3660:	cd6d                	beqz	a0,375a <dirfile+0x138>
  fd = open("dirfile/xx", 0);
    3662:	4581                	li	a1,0
    3664:	00004517          	auipc	a0,0x4
    3668:	a7450513          	addi	a0,a0,-1420 # 70d8 <malloc+0x193c>
    366c:	00002097          	auipc	ra,0x2
    3670:	d3e080e7          	jalr	-706(ra) # 53aa <open>
  if(fd >= 0){
    3674:	10055163          	bgez	a0,3776 <dirfile+0x154>
  fd = open("dirfile/xx", O_CREATE);
    3678:	20000593          	li	a1,512
    367c:	00004517          	auipc	a0,0x4
    3680:	a5c50513          	addi	a0,a0,-1444 # 70d8 <malloc+0x193c>
    3684:	00002097          	auipc	ra,0x2
    3688:	d26080e7          	jalr	-730(ra) # 53aa <open>
  if(fd >= 0){
    368c:	10055363          	bgez	a0,3792 <dirfile+0x170>
  if(mkdir("dirfile/xx") == 0){
    3690:	00004517          	auipc	a0,0x4
    3694:	a4850513          	addi	a0,a0,-1464 # 70d8 <malloc+0x193c>
    3698:	00002097          	auipc	ra,0x2
    369c:	d3a080e7          	jalr	-710(ra) # 53d2 <mkdir>
    36a0:	10050763          	beqz	a0,37ae <dirfile+0x18c>
  if(unlink("dirfile/xx") == 0){
    36a4:	00004517          	auipc	a0,0x4
    36a8:	a3450513          	addi	a0,a0,-1484 # 70d8 <malloc+0x193c>
    36ac:	00002097          	auipc	ra,0x2
    36b0:	d0e080e7          	jalr	-754(ra) # 53ba <unlink>
    36b4:	10050b63          	beqz	a0,37ca <dirfile+0x1a8>
  if(link("README", "dirfile/xx") == 0){
    36b8:	00004597          	auipc	a1,0x4
    36bc:	a2058593          	addi	a1,a1,-1504 # 70d8 <malloc+0x193c>
    36c0:	00002517          	auipc	a0,0x2
    36c4:	3a850513          	addi	a0,a0,936 # 5a68 <malloc+0x2cc>
    36c8:	00002097          	auipc	ra,0x2
    36cc:	d02080e7          	jalr	-766(ra) # 53ca <link>
    36d0:	10050b63          	beqz	a0,37e6 <dirfile+0x1c4>
  if(unlink("dirfile") != 0){
    36d4:	00004517          	auipc	a0,0x4
    36d8:	9bc50513          	addi	a0,a0,-1604 # 7090 <malloc+0x18f4>
    36dc:	00002097          	auipc	ra,0x2
    36e0:	cde080e7          	jalr	-802(ra) # 53ba <unlink>
    36e4:	10051f63          	bnez	a0,3802 <dirfile+0x1e0>
  fd = open(".", O_RDWR);
    36e8:	4589                	li	a1,2
    36ea:	00003517          	auipc	a0,0x3
    36ee:	88e50513          	addi	a0,a0,-1906 # 5f78 <malloc+0x7dc>
    36f2:	00002097          	auipc	ra,0x2
    36f6:	cb8080e7          	jalr	-840(ra) # 53aa <open>
  if(fd >= 0){
    36fa:	12055263          	bgez	a0,381e <dirfile+0x1fc>
  fd = open(".", 0);
    36fe:	4581                	li	a1,0
    3700:	00003517          	auipc	a0,0x3
    3704:	87850513          	addi	a0,a0,-1928 # 5f78 <malloc+0x7dc>
    3708:	00002097          	auipc	ra,0x2
    370c:	ca2080e7          	jalr	-862(ra) # 53aa <open>
    3710:	84aa                	mv	s1,a0
  if(write(fd, "x", 1) > 0){
    3712:	4605                	li	a2,1
    3714:	00002597          	auipc	a1,0x2
    3718:	21c58593          	addi	a1,a1,540 # 5930 <malloc+0x194>
    371c:	00002097          	auipc	ra,0x2
    3720:	c6e080e7          	jalr	-914(ra) # 538a <write>
    3724:	10a04b63          	bgtz	a0,383a <dirfile+0x218>
  close(fd);
    3728:	8526                	mv	a0,s1
    372a:	00002097          	auipc	ra,0x2
    372e:	c68080e7          	jalr	-920(ra) # 5392 <close>
}
    3732:	60e2                	ld	ra,24(sp)
    3734:	6442                	ld	s0,16(sp)
    3736:	64a2                	ld	s1,8(sp)
    3738:	6902                	ld	s2,0(sp)
    373a:	6105                	addi	sp,sp,32
    373c:	8082                	ret
    printf("%s: create dirfile failed\n", s);
    373e:	85ca                	mv	a1,s2
    3740:	00004517          	auipc	a0,0x4
    3744:	95850513          	addi	a0,a0,-1704 # 7098 <malloc+0x18fc>
    3748:	00002097          	auipc	ra,0x2
    374c:	f9c080e7          	jalr	-100(ra) # 56e4 <printf>
    exit(1);
    3750:	4505                	li	a0,1
    3752:	00002097          	auipc	ra,0x2
    3756:	c18080e7          	jalr	-1000(ra) # 536a <exit>
    printf("%s: chdir dirfile succeeded!\n", s);
    375a:	85ca                	mv	a1,s2
    375c:	00004517          	auipc	a0,0x4
    3760:	95c50513          	addi	a0,a0,-1700 # 70b8 <malloc+0x191c>
    3764:	00002097          	auipc	ra,0x2
    3768:	f80080e7          	jalr	-128(ra) # 56e4 <printf>
    exit(1);
    376c:	4505                	li	a0,1
    376e:	00002097          	auipc	ra,0x2
    3772:	bfc080e7          	jalr	-1028(ra) # 536a <exit>
    printf("%s: create dirfile/xx succeeded!\n", s);
    3776:	85ca                	mv	a1,s2
    3778:	00004517          	auipc	a0,0x4
    377c:	97050513          	addi	a0,a0,-1680 # 70e8 <malloc+0x194c>
    3780:	00002097          	auipc	ra,0x2
    3784:	f64080e7          	jalr	-156(ra) # 56e4 <printf>
    exit(1);
    3788:	4505                	li	a0,1
    378a:	00002097          	auipc	ra,0x2
    378e:	be0080e7          	jalr	-1056(ra) # 536a <exit>
    printf("%s: create dirfile/xx succeeded!\n", s);
    3792:	85ca                	mv	a1,s2
    3794:	00004517          	auipc	a0,0x4
    3798:	95450513          	addi	a0,a0,-1708 # 70e8 <malloc+0x194c>
    379c:	00002097          	auipc	ra,0x2
    37a0:	f48080e7          	jalr	-184(ra) # 56e4 <printf>
    exit(1);
    37a4:	4505                	li	a0,1
    37a6:	00002097          	auipc	ra,0x2
    37aa:	bc4080e7          	jalr	-1084(ra) # 536a <exit>
    printf("%s: mkdir dirfile/xx succeeded!\n", s);
    37ae:	85ca                	mv	a1,s2
    37b0:	00004517          	auipc	a0,0x4
    37b4:	96050513          	addi	a0,a0,-1696 # 7110 <malloc+0x1974>
    37b8:	00002097          	auipc	ra,0x2
    37bc:	f2c080e7          	jalr	-212(ra) # 56e4 <printf>
    exit(1);
    37c0:	4505                	li	a0,1
    37c2:	00002097          	auipc	ra,0x2
    37c6:	ba8080e7          	jalr	-1112(ra) # 536a <exit>
    printf("%s: unlink dirfile/xx succeeded!\n", s);
    37ca:	85ca                	mv	a1,s2
    37cc:	00004517          	auipc	a0,0x4
    37d0:	96c50513          	addi	a0,a0,-1684 # 7138 <malloc+0x199c>
    37d4:	00002097          	auipc	ra,0x2
    37d8:	f10080e7          	jalr	-240(ra) # 56e4 <printf>
    exit(1);
    37dc:	4505                	li	a0,1
    37de:	00002097          	auipc	ra,0x2
    37e2:	b8c080e7          	jalr	-1140(ra) # 536a <exit>
    printf("%s: link to dirfile/xx succeeded!\n", s);
    37e6:	85ca                	mv	a1,s2
    37e8:	00004517          	auipc	a0,0x4
    37ec:	97850513          	addi	a0,a0,-1672 # 7160 <malloc+0x19c4>
    37f0:	00002097          	auipc	ra,0x2
    37f4:	ef4080e7          	jalr	-268(ra) # 56e4 <printf>
    exit(1);
    37f8:	4505                	li	a0,1
    37fa:	00002097          	auipc	ra,0x2
    37fe:	b70080e7          	jalr	-1168(ra) # 536a <exit>
    printf("%s: unlink dirfile failed!\n", s);
    3802:	85ca                	mv	a1,s2
    3804:	00004517          	auipc	a0,0x4
    3808:	98450513          	addi	a0,a0,-1660 # 7188 <malloc+0x19ec>
    380c:	00002097          	auipc	ra,0x2
    3810:	ed8080e7          	jalr	-296(ra) # 56e4 <printf>
    exit(1);
    3814:	4505                	li	a0,1
    3816:	00002097          	auipc	ra,0x2
    381a:	b54080e7          	jalr	-1196(ra) # 536a <exit>
    printf("%s: open . for writing succeeded!\n", s);
    381e:	85ca                	mv	a1,s2
    3820:	00004517          	auipc	a0,0x4
    3824:	98850513          	addi	a0,a0,-1656 # 71a8 <malloc+0x1a0c>
    3828:	00002097          	auipc	ra,0x2
    382c:	ebc080e7          	jalr	-324(ra) # 56e4 <printf>
    exit(1);
    3830:	4505                	li	a0,1
    3832:	00002097          	auipc	ra,0x2
    3836:	b38080e7          	jalr	-1224(ra) # 536a <exit>
    printf("%s: write . succeeded!\n", s);
    383a:	85ca                	mv	a1,s2
    383c:	00004517          	auipc	a0,0x4
    3840:	99450513          	addi	a0,a0,-1644 # 71d0 <malloc+0x1a34>
    3844:	00002097          	auipc	ra,0x2
    3848:	ea0080e7          	jalr	-352(ra) # 56e4 <printf>
    exit(1);
    384c:	4505                	li	a0,1
    384e:	00002097          	auipc	ra,0x2
    3852:	b1c080e7          	jalr	-1252(ra) # 536a <exit>

0000000000003856 <iref>:
{
    3856:	7139                	addi	sp,sp,-64
    3858:	fc06                	sd	ra,56(sp)
    385a:	f822                	sd	s0,48(sp)
    385c:	f426                	sd	s1,40(sp)
    385e:	f04a                	sd	s2,32(sp)
    3860:	ec4e                	sd	s3,24(sp)
    3862:	e852                	sd	s4,16(sp)
    3864:	e456                	sd	s5,8(sp)
    3866:	e05a                	sd	s6,0(sp)
    3868:	0080                	addi	s0,sp,64
    386a:	8b2a                	mv	s6,a0
    386c:	03300913          	li	s2,51
    if(mkdir("irefd") != 0){
    3870:	00004a17          	auipc	s4,0x4
    3874:	978a0a13          	addi	s4,s4,-1672 # 71e8 <malloc+0x1a4c>
    mkdir("");
    3878:	00003497          	auipc	s1,0x3
    387c:	47048493          	addi	s1,s1,1136 # 6ce8 <malloc+0x154c>
    link("README", "");
    3880:	00002a97          	auipc	s5,0x2
    3884:	1e8a8a93          	addi	s5,s5,488 # 5a68 <malloc+0x2cc>
    fd = open("xx", O_CREATE);
    3888:	00004997          	auipc	s3,0x4
    388c:	85898993          	addi	s3,s3,-1960 # 70e0 <malloc+0x1944>
    3890:	a891                	j	38e4 <iref+0x8e>
      printf("%s: mkdir irefd failed\n", s);
    3892:	85da                	mv	a1,s6
    3894:	00004517          	auipc	a0,0x4
    3898:	95c50513          	addi	a0,a0,-1700 # 71f0 <malloc+0x1a54>
    389c:	00002097          	auipc	ra,0x2
    38a0:	e48080e7          	jalr	-440(ra) # 56e4 <printf>
      exit(1);
    38a4:	4505                	li	a0,1
    38a6:	00002097          	auipc	ra,0x2
    38aa:	ac4080e7          	jalr	-1340(ra) # 536a <exit>
      printf("%s: chdir irefd failed\n", s);
    38ae:	85da                	mv	a1,s6
    38b0:	00004517          	auipc	a0,0x4
    38b4:	95850513          	addi	a0,a0,-1704 # 7208 <malloc+0x1a6c>
    38b8:	00002097          	auipc	ra,0x2
    38bc:	e2c080e7          	jalr	-468(ra) # 56e4 <printf>
      exit(1);
    38c0:	4505                	li	a0,1
    38c2:	00002097          	auipc	ra,0x2
    38c6:	aa8080e7          	jalr	-1368(ra) # 536a <exit>
      close(fd);
    38ca:	00002097          	auipc	ra,0x2
    38ce:	ac8080e7          	jalr	-1336(ra) # 5392 <close>
    38d2:	a889                	j	3924 <iref+0xce>
    unlink("xx");
    38d4:	854e                	mv	a0,s3
    38d6:	00002097          	auipc	ra,0x2
    38da:	ae4080e7          	jalr	-1308(ra) # 53ba <unlink>
  for(i = 0; i < NINODE + 1; i++){
    38de:	397d                	addiw	s2,s2,-1
    38e0:	06090063          	beqz	s2,3940 <iref+0xea>
    if(mkdir("irefd") != 0){
    38e4:	8552                	mv	a0,s4
    38e6:	00002097          	auipc	ra,0x2
    38ea:	aec080e7          	jalr	-1300(ra) # 53d2 <mkdir>
    38ee:	f155                	bnez	a0,3892 <iref+0x3c>
    if(chdir("irefd") != 0){
    38f0:	8552                	mv	a0,s4
    38f2:	00002097          	auipc	ra,0x2
    38f6:	ae8080e7          	jalr	-1304(ra) # 53da <chdir>
    38fa:	f955                	bnez	a0,38ae <iref+0x58>
    mkdir("");
    38fc:	8526                	mv	a0,s1
    38fe:	00002097          	auipc	ra,0x2
    3902:	ad4080e7          	jalr	-1324(ra) # 53d2 <mkdir>
    link("README", "");
    3906:	85a6                	mv	a1,s1
    3908:	8556                	mv	a0,s5
    390a:	00002097          	auipc	ra,0x2
    390e:	ac0080e7          	jalr	-1344(ra) # 53ca <link>
    fd = open("", O_CREATE);
    3912:	20000593          	li	a1,512
    3916:	8526                	mv	a0,s1
    3918:	00002097          	auipc	ra,0x2
    391c:	a92080e7          	jalr	-1390(ra) # 53aa <open>
    if(fd >= 0)
    3920:	fa0555e3          	bgez	a0,38ca <iref+0x74>
    fd = open("xx", O_CREATE);
    3924:	20000593          	li	a1,512
    3928:	854e                	mv	a0,s3
    392a:	00002097          	auipc	ra,0x2
    392e:	a80080e7          	jalr	-1408(ra) # 53aa <open>
    if(fd >= 0)
    3932:	fa0541e3          	bltz	a0,38d4 <iref+0x7e>
      close(fd);
    3936:	00002097          	auipc	ra,0x2
    393a:	a5c080e7          	jalr	-1444(ra) # 5392 <close>
    393e:	bf59                	j	38d4 <iref+0x7e>
    3940:	03300493          	li	s1,51
    chdir("..");
    3944:	00003997          	auipc	s3,0x3
    3948:	6bc98993          	addi	s3,s3,1724 # 7000 <malloc+0x1864>
    unlink("irefd");
    394c:	00004917          	auipc	s2,0x4
    3950:	89c90913          	addi	s2,s2,-1892 # 71e8 <malloc+0x1a4c>
    chdir("..");
    3954:	854e                	mv	a0,s3
    3956:	00002097          	auipc	ra,0x2
    395a:	a84080e7          	jalr	-1404(ra) # 53da <chdir>
    unlink("irefd");
    395e:	854a                	mv	a0,s2
    3960:	00002097          	auipc	ra,0x2
    3964:	a5a080e7          	jalr	-1446(ra) # 53ba <unlink>
  for(i = 0; i < NINODE + 1; i++){
    3968:	34fd                	addiw	s1,s1,-1
    396a:	f4ed                	bnez	s1,3954 <iref+0xfe>
  chdir("/");
    396c:	00003517          	auipc	a0,0x3
    3970:	09c50513          	addi	a0,a0,156 # 6a08 <malloc+0x126c>
    3974:	00002097          	auipc	ra,0x2
    3978:	a66080e7          	jalr	-1434(ra) # 53da <chdir>
}
    397c:	70e2                	ld	ra,56(sp)
    397e:	7442                	ld	s0,48(sp)
    3980:	74a2                	ld	s1,40(sp)
    3982:	7902                	ld	s2,32(sp)
    3984:	69e2                	ld	s3,24(sp)
    3986:	6a42                	ld	s4,16(sp)
    3988:	6aa2                	ld	s5,8(sp)
    398a:	6b02                	ld	s6,0(sp)
    398c:	6121                	addi	sp,sp,64
    398e:	8082                	ret

0000000000003990 <openiputtest>:
{
    3990:	7179                	addi	sp,sp,-48
    3992:	f406                	sd	ra,40(sp)
    3994:	f022                	sd	s0,32(sp)
    3996:	ec26                	sd	s1,24(sp)
    3998:	1800                	addi	s0,sp,48
    399a:	84aa                	mv	s1,a0
  if(mkdir("oidir") < 0){
    399c:	00004517          	auipc	a0,0x4
    39a0:	88450513          	addi	a0,a0,-1916 # 7220 <malloc+0x1a84>
    39a4:	00002097          	auipc	ra,0x2
    39a8:	a2e080e7          	jalr	-1490(ra) # 53d2 <mkdir>
    39ac:	04054263          	bltz	a0,39f0 <openiputtest+0x60>
  pid = fork();
    39b0:	00002097          	auipc	ra,0x2
    39b4:	9b2080e7          	jalr	-1614(ra) # 5362 <fork>
  if(pid < 0){
    39b8:	04054a63          	bltz	a0,3a0c <openiputtest+0x7c>
  if(pid == 0){
    39bc:	e93d                	bnez	a0,3a32 <openiputtest+0xa2>
    int fd = open("oidir", O_RDWR);
    39be:	4589                	li	a1,2
    39c0:	00004517          	auipc	a0,0x4
    39c4:	86050513          	addi	a0,a0,-1952 # 7220 <malloc+0x1a84>
    39c8:	00002097          	auipc	ra,0x2
    39cc:	9e2080e7          	jalr	-1566(ra) # 53aa <open>
    if(fd >= 0){
    39d0:	04054c63          	bltz	a0,3a28 <openiputtest+0x98>
      printf("%s: open directory for write succeeded\n", s);
    39d4:	85a6                	mv	a1,s1
    39d6:	00004517          	auipc	a0,0x4
    39da:	86a50513          	addi	a0,a0,-1942 # 7240 <malloc+0x1aa4>
    39de:	00002097          	auipc	ra,0x2
    39e2:	d06080e7          	jalr	-762(ra) # 56e4 <printf>
      exit(1);
    39e6:	4505                	li	a0,1
    39e8:	00002097          	auipc	ra,0x2
    39ec:	982080e7          	jalr	-1662(ra) # 536a <exit>
    printf("%s: mkdir oidir failed\n", s);
    39f0:	85a6                	mv	a1,s1
    39f2:	00004517          	auipc	a0,0x4
    39f6:	83650513          	addi	a0,a0,-1994 # 7228 <malloc+0x1a8c>
    39fa:	00002097          	auipc	ra,0x2
    39fe:	cea080e7          	jalr	-790(ra) # 56e4 <printf>
    exit(1);
    3a02:	4505                	li	a0,1
    3a04:	00002097          	auipc	ra,0x2
    3a08:	966080e7          	jalr	-1690(ra) # 536a <exit>
    printf("%s: fork failed\n", s);
    3a0c:	85a6                	mv	a1,s1
    3a0e:	00002517          	auipc	a0,0x2
    3a12:	70a50513          	addi	a0,a0,1802 # 6118 <malloc+0x97c>
    3a16:	00002097          	auipc	ra,0x2
    3a1a:	cce080e7          	jalr	-818(ra) # 56e4 <printf>
    exit(1);
    3a1e:	4505                	li	a0,1
    3a20:	00002097          	auipc	ra,0x2
    3a24:	94a080e7          	jalr	-1718(ra) # 536a <exit>
    exit(0);
    3a28:	4501                	li	a0,0
    3a2a:	00002097          	auipc	ra,0x2
    3a2e:	940080e7          	jalr	-1728(ra) # 536a <exit>
  sleep(1);
    3a32:	4505                	li	a0,1
    3a34:	00002097          	auipc	ra,0x2
    3a38:	9c6080e7          	jalr	-1594(ra) # 53fa <sleep>
  if(unlink("oidir") != 0){
    3a3c:	00003517          	auipc	a0,0x3
    3a40:	7e450513          	addi	a0,a0,2020 # 7220 <malloc+0x1a84>
    3a44:	00002097          	auipc	ra,0x2
    3a48:	976080e7          	jalr	-1674(ra) # 53ba <unlink>
    3a4c:	cd19                	beqz	a0,3a6a <openiputtest+0xda>
    printf("%s: unlink failed\n", s);
    3a4e:	85a6                	mv	a1,s1
    3a50:	00003517          	auipc	a0,0x3
    3a54:	8b850513          	addi	a0,a0,-1864 # 6308 <malloc+0xb6c>
    3a58:	00002097          	auipc	ra,0x2
    3a5c:	c8c080e7          	jalr	-884(ra) # 56e4 <printf>
    exit(1);
    3a60:	4505                	li	a0,1
    3a62:	00002097          	auipc	ra,0x2
    3a66:	908080e7          	jalr	-1784(ra) # 536a <exit>
  wait(&xstatus);
    3a6a:	fdc40513          	addi	a0,s0,-36
    3a6e:	00002097          	auipc	ra,0x2
    3a72:	904080e7          	jalr	-1788(ra) # 5372 <wait>
  exit(xstatus);
    3a76:	fdc42503          	lw	a0,-36(s0)
    3a7a:	00002097          	auipc	ra,0x2
    3a7e:	8f0080e7          	jalr	-1808(ra) # 536a <exit>

0000000000003a82 <forkforkfork>:
{
    3a82:	1101                	addi	sp,sp,-32
    3a84:	ec06                	sd	ra,24(sp)
    3a86:	e822                	sd	s0,16(sp)
    3a88:	e426                	sd	s1,8(sp)
    3a8a:	1000                	addi	s0,sp,32
    3a8c:	84aa                	mv	s1,a0
  unlink("stopforking");
    3a8e:	00003517          	auipc	a0,0x3
    3a92:	7da50513          	addi	a0,a0,2010 # 7268 <malloc+0x1acc>
    3a96:	00002097          	auipc	ra,0x2
    3a9a:	924080e7          	jalr	-1756(ra) # 53ba <unlink>
  int pid = fork();
    3a9e:	00002097          	auipc	ra,0x2
    3aa2:	8c4080e7          	jalr	-1852(ra) # 5362 <fork>
  if(pid < 0){
    3aa6:	04054563          	bltz	a0,3af0 <forkforkfork+0x6e>
  if(pid == 0){
    3aaa:	c12d                	beqz	a0,3b0c <forkforkfork+0x8a>
  sleep(20); // two seconds
    3aac:	4551                	li	a0,20
    3aae:	00002097          	auipc	ra,0x2
    3ab2:	94c080e7          	jalr	-1716(ra) # 53fa <sleep>
  close(open("stopforking", O_CREATE|O_RDWR));
    3ab6:	20200593          	li	a1,514
    3aba:	00003517          	auipc	a0,0x3
    3abe:	7ae50513          	addi	a0,a0,1966 # 7268 <malloc+0x1acc>
    3ac2:	00002097          	auipc	ra,0x2
    3ac6:	8e8080e7          	jalr	-1816(ra) # 53aa <open>
    3aca:	00002097          	auipc	ra,0x2
    3ace:	8c8080e7          	jalr	-1848(ra) # 5392 <close>
  wait(0);
    3ad2:	4501                	li	a0,0
    3ad4:	00002097          	auipc	ra,0x2
    3ad8:	89e080e7          	jalr	-1890(ra) # 5372 <wait>
  sleep(10); // one second
    3adc:	4529                	li	a0,10
    3ade:	00002097          	auipc	ra,0x2
    3ae2:	91c080e7          	jalr	-1764(ra) # 53fa <sleep>
}
    3ae6:	60e2                	ld	ra,24(sp)
    3ae8:	6442                	ld	s0,16(sp)
    3aea:	64a2                	ld	s1,8(sp)
    3aec:	6105                	addi	sp,sp,32
    3aee:	8082                	ret
    printf("%s: fork failed", s);
    3af0:	85a6                	mv	a1,s1
    3af2:	00002517          	auipc	a0,0x2
    3af6:	7e650513          	addi	a0,a0,2022 # 62d8 <malloc+0xb3c>
    3afa:	00002097          	auipc	ra,0x2
    3afe:	bea080e7          	jalr	-1046(ra) # 56e4 <printf>
    exit(1);
    3b02:	4505                	li	a0,1
    3b04:	00002097          	auipc	ra,0x2
    3b08:	866080e7          	jalr	-1946(ra) # 536a <exit>
      int fd = open("stopforking", 0);
    3b0c:	00003497          	auipc	s1,0x3
    3b10:	75c48493          	addi	s1,s1,1884 # 7268 <malloc+0x1acc>
    3b14:	4581                	li	a1,0
    3b16:	8526                	mv	a0,s1
    3b18:	00002097          	auipc	ra,0x2
    3b1c:	892080e7          	jalr	-1902(ra) # 53aa <open>
      if(fd >= 0){
    3b20:	02055463          	bgez	a0,3b48 <forkforkfork+0xc6>
      if(fork() < 0){
    3b24:	00002097          	auipc	ra,0x2
    3b28:	83e080e7          	jalr	-1986(ra) # 5362 <fork>
    3b2c:	fe0554e3          	bgez	a0,3b14 <forkforkfork+0x92>
        close(open("stopforking", O_CREATE|O_RDWR));
    3b30:	20200593          	li	a1,514
    3b34:	8526                	mv	a0,s1
    3b36:	00002097          	auipc	ra,0x2
    3b3a:	874080e7          	jalr	-1932(ra) # 53aa <open>
    3b3e:	00002097          	auipc	ra,0x2
    3b42:	854080e7          	jalr	-1964(ra) # 5392 <close>
    3b46:	b7f9                	j	3b14 <forkforkfork+0x92>
        exit(0);
    3b48:	4501                	li	a0,0
    3b4a:	00002097          	auipc	ra,0x2
    3b4e:	820080e7          	jalr	-2016(ra) # 536a <exit>

0000000000003b52 <preempt>:
{
    3b52:	7139                	addi	sp,sp,-64
    3b54:	fc06                	sd	ra,56(sp)
    3b56:	f822                	sd	s0,48(sp)
    3b58:	f426                	sd	s1,40(sp)
    3b5a:	f04a                	sd	s2,32(sp)
    3b5c:	ec4e                	sd	s3,24(sp)
    3b5e:	e852                	sd	s4,16(sp)
    3b60:	0080                	addi	s0,sp,64
    3b62:	892a                	mv	s2,a0
  pid1 = fork();
    3b64:	00001097          	auipc	ra,0x1
    3b68:	7fe080e7          	jalr	2046(ra) # 5362 <fork>
  if(pid1 < 0) {
    3b6c:	00054563          	bltz	a0,3b76 <preempt+0x24>
    3b70:	84aa                	mv	s1,a0
  if(pid1 == 0)
    3b72:	ed19                	bnez	a0,3b90 <preempt+0x3e>
    for(;;)
    3b74:	a001                	j	3b74 <preempt+0x22>
    printf("%s: fork failed");
    3b76:	00002517          	auipc	a0,0x2
    3b7a:	76250513          	addi	a0,a0,1890 # 62d8 <malloc+0xb3c>
    3b7e:	00002097          	auipc	ra,0x2
    3b82:	b66080e7          	jalr	-1178(ra) # 56e4 <printf>
    exit(1);
    3b86:	4505                	li	a0,1
    3b88:	00001097          	auipc	ra,0x1
    3b8c:	7e2080e7          	jalr	2018(ra) # 536a <exit>
  pid2 = fork();
    3b90:	00001097          	auipc	ra,0x1
    3b94:	7d2080e7          	jalr	2002(ra) # 5362 <fork>
    3b98:	89aa                	mv	s3,a0
  if(pid2 < 0) {
    3b9a:	00054463          	bltz	a0,3ba2 <preempt+0x50>
  if(pid2 == 0)
    3b9e:	e105                	bnez	a0,3bbe <preempt+0x6c>
    for(;;)
    3ba0:	a001                	j	3ba0 <preempt+0x4e>
    printf("%s: fork failed\n", s);
    3ba2:	85ca                	mv	a1,s2
    3ba4:	00002517          	auipc	a0,0x2
    3ba8:	57450513          	addi	a0,a0,1396 # 6118 <malloc+0x97c>
    3bac:	00002097          	auipc	ra,0x2
    3bb0:	b38080e7          	jalr	-1224(ra) # 56e4 <printf>
    exit(1);
    3bb4:	4505                	li	a0,1
    3bb6:	00001097          	auipc	ra,0x1
    3bba:	7b4080e7          	jalr	1972(ra) # 536a <exit>
  pipe(pfds);
    3bbe:	fc840513          	addi	a0,s0,-56
    3bc2:	00001097          	auipc	ra,0x1
    3bc6:	7b8080e7          	jalr	1976(ra) # 537a <pipe>
  pid3 = fork();
    3bca:	00001097          	auipc	ra,0x1
    3bce:	798080e7          	jalr	1944(ra) # 5362 <fork>
    3bd2:	8a2a                	mv	s4,a0
  if(pid3 < 0) {
    3bd4:	02054e63          	bltz	a0,3c10 <preempt+0xbe>
  if(pid3 == 0){
    3bd8:	e13d                	bnez	a0,3c3e <preempt+0xec>
    close(pfds[0]);
    3bda:	fc842503          	lw	a0,-56(s0)
    3bde:	00001097          	auipc	ra,0x1
    3be2:	7b4080e7          	jalr	1972(ra) # 5392 <close>
    if(write(pfds[1], "x", 1) != 1)
    3be6:	4605                	li	a2,1
    3be8:	00002597          	auipc	a1,0x2
    3bec:	d4858593          	addi	a1,a1,-696 # 5930 <malloc+0x194>
    3bf0:	fcc42503          	lw	a0,-52(s0)
    3bf4:	00001097          	auipc	ra,0x1
    3bf8:	796080e7          	jalr	1942(ra) # 538a <write>
    3bfc:	4785                	li	a5,1
    3bfe:	02f51763          	bne	a0,a5,3c2c <preempt+0xda>
    close(pfds[1]);
    3c02:	fcc42503          	lw	a0,-52(s0)
    3c06:	00001097          	auipc	ra,0x1
    3c0a:	78c080e7          	jalr	1932(ra) # 5392 <close>
    for(;;)
    3c0e:	a001                	j	3c0e <preempt+0xbc>
     printf("%s: fork failed\n", s);
    3c10:	85ca                	mv	a1,s2
    3c12:	00002517          	auipc	a0,0x2
    3c16:	50650513          	addi	a0,a0,1286 # 6118 <malloc+0x97c>
    3c1a:	00002097          	auipc	ra,0x2
    3c1e:	aca080e7          	jalr	-1334(ra) # 56e4 <printf>
     exit(1);
    3c22:	4505                	li	a0,1
    3c24:	00001097          	auipc	ra,0x1
    3c28:	746080e7          	jalr	1862(ra) # 536a <exit>
      printf("%s: preempt write error");
    3c2c:	00003517          	auipc	a0,0x3
    3c30:	64c50513          	addi	a0,a0,1612 # 7278 <malloc+0x1adc>
    3c34:	00002097          	auipc	ra,0x2
    3c38:	ab0080e7          	jalr	-1360(ra) # 56e4 <printf>
    3c3c:	b7d9                	j	3c02 <preempt+0xb0>
  close(pfds[1]);
    3c3e:	fcc42503          	lw	a0,-52(s0)
    3c42:	00001097          	auipc	ra,0x1
    3c46:	750080e7          	jalr	1872(ra) # 5392 <close>
  if(read(pfds[0], buf, sizeof(buf)) != 1){
    3c4a:	660d                	lui	a2,0x3
    3c4c:	00008597          	auipc	a1,0x8
    3c50:	b3458593          	addi	a1,a1,-1228 # b780 <buf>
    3c54:	fc842503          	lw	a0,-56(s0)
    3c58:	00001097          	auipc	ra,0x1
    3c5c:	72a080e7          	jalr	1834(ra) # 5382 <read>
    3c60:	4785                	li	a5,1
    3c62:	02f50263          	beq	a0,a5,3c86 <preempt+0x134>
    printf("%s: preempt read error");
    3c66:	00003517          	auipc	a0,0x3
    3c6a:	62a50513          	addi	a0,a0,1578 # 7290 <malloc+0x1af4>
    3c6e:	00002097          	auipc	ra,0x2
    3c72:	a76080e7          	jalr	-1418(ra) # 56e4 <printf>
}
    3c76:	70e2                	ld	ra,56(sp)
    3c78:	7442                	ld	s0,48(sp)
    3c7a:	74a2                	ld	s1,40(sp)
    3c7c:	7902                	ld	s2,32(sp)
    3c7e:	69e2                	ld	s3,24(sp)
    3c80:	6a42                	ld	s4,16(sp)
    3c82:	6121                	addi	sp,sp,64
    3c84:	8082                	ret
  close(pfds[0]);
    3c86:	fc842503          	lw	a0,-56(s0)
    3c8a:	00001097          	auipc	ra,0x1
    3c8e:	708080e7          	jalr	1800(ra) # 5392 <close>
  printf("kill... ");
    3c92:	00003517          	auipc	a0,0x3
    3c96:	61650513          	addi	a0,a0,1558 # 72a8 <malloc+0x1b0c>
    3c9a:	00002097          	auipc	ra,0x2
    3c9e:	a4a080e7          	jalr	-1462(ra) # 56e4 <printf>
  kill(pid1);
    3ca2:	8526                	mv	a0,s1
    3ca4:	00001097          	auipc	ra,0x1
    3ca8:	6f6080e7          	jalr	1782(ra) # 539a <kill>
  kill(pid2);
    3cac:	854e                	mv	a0,s3
    3cae:	00001097          	auipc	ra,0x1
    3cb2:	6ec080e7          	jalr	1772(ra) # 539a <kill>
  kill(pid3);
    3cb6:	8552                	mv	a0,s4
    3cb8:	00001097          	auipc	ra,0x1
    3cbc:	6e2080e7          	jalr	1762(ra) # 539a <kill>
  printf("wait... ");
    3cc0:	00003517          	auipc	a0,0x3
    3cc4:	5f850513          	addi	a0,a0,1528 # 72b8 <malloc+0x1b1c>
    3cc8:	00002097          	auipc	ra,0x2
    3ccc:	a1c080e7          	jalr	-1508(ra) # 56e4 <printf>
  wait(0);
    3cd0:	4501                	li	a0,0
    3cd2:	00001097          	auipc	ra,0x1
    3cd6:	6a0080e7          	jalr	1696(ra) # 5372 <wait>
  wait(0);
    3cda:	4501                	li	a0,0
    3cdc:	00001097          	auipc	ra,0x1
    3ce0:	696080e7          	jalr	1686(ra) # 5372 <wait>
  wait(0);
    3ce4:	4501                	li	a0,0
    3ce6:	00001097          	auipc	ra,0x1
    3cea:	68c080e7          	jalr	1676(ra) # 5372 <wait>
    3cee:	b761                	j	3c76 <preempt+0x124>

0000000000003cf0 <sbrkfail>:
{
    3cf0:	7119                	addi	sp,sp,-128
    3cf2:	fc86                	sd	ra,120(sp)
    3cf4:	f8a2                	sd	s0,112(sp)
    3cf6:	f4a6                	sd	s1,104(sp)
    3cf8:	f0ca                	sd	s2,96(sp)
    3cfa:	ecce                	sd	s3,88(sp)
    3cfc:	e8d2                	sd	s4,80(sp)
    3cfe:	e4d6                	sd	s5,72(sp)
    3d00:	0100                	addi	s0,sp,128
    3d02:	8aaa                	mv	s5,a0
  if(pipe(fds) != 0){
    3d04:	fb040513          	addi	a0,s0,-80
    3d08:	00001097          	auipc	ra,0x1
    3d0c:	672080e7          	jalr	1650(ra) # 537a <pipe>
    3d10:	e901                	bnez	a0,3d20 <sbrkfail+0x30>
    3d12:	f8040493          	addi	s1,s0,-128
    3d16:	fa840993          	addi	s3,s0,-88
    3d1a:	8926                	mv	s2,s1
    if(pids[i] != -1)
    3d1c:	5a7d                	li	s4,-1
    3d1e:	a085                	j	3d7e <sbrkfail+0x8e>
    printf("%s: pipe() failed\n", s);
    3d20:	85d6                	mv	a1,s5
    3d22:	00002517          	auipc	a0,0x2
    3d26:	4fe50513          	addi	a0,a0,1278 # 6220 <malloc+0xa84>
    3d2a:	00002097          	auipc	ra,0x2
    3d2e:	9ba080e7          	jalr	-1606(ra) # 56e4 <printf>
    exit(1);
    3d32:	4505                	li	a0,1
    3d34:	00001097          	auipc	ra,0x1
    3d38:	636080e7          	jalr	1590(ra) # 536a <exit>
      sbrk(BIG - (uint64)sbrk(0));
    3d3c:	00001097          	auipc	ra,0x1
    3d40:	6b6080e7          	jalr	1718(ra) # 53f2 <sbrk>
    3d44:	064007b7          	lui	a5,0x6400
    3d48:	40a7853b          	subw	a0,a5,a0
    3d4c:	00001097          	auipc	ra,0x1
    3d50:	6a6080e7          	jalr	1702(ra) # 53f2 <sbrk>
      write(fds[1], "x", 1);
    3d54:	4605                	li	a2,1
    3d56:	00002597          	auipc	a1,0x2
    3d5a:	bda58593          	addi	a1,a1,-1062 # 5930 <malloc+0x194>
    3d5e:	fb442503          	lw	a0,-76(s0)
    3d62:	00001097          	auipc	ra,0x1
    3d66:	628080e7          	jalr	1576(ra) # 538a <write>
      for(;;) sleep(1000);
    3d6a:	3e800513          	li	a0,1000
    3d6e:	00001097          	auipc	ra,0x1
    3d72:	68c080e7          	jalr	1676(ra) # 53fa <sleep>
    3d76:	bfd5                	j	3d6a <sbrkfail+0x7a>
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    3d78:	0911                	addi	s2,s2,4
    3d7a:	03390563          	beq	s2,s3,3da4 <sbrkfail+0xb4>
    if((pids[i] = fork()) == 0){
    3d7e:	00001097          	auipc	ra,0x1
    3d82:	5e4080e7          	jalr	1508(ra) # 5362 <fork>
    3d86:	00a92023          	sw	a0,0(s2)
    3d8a:	d94d                	beqz	a0,3d3c <sbrkfail+0x4c>
    if(pids[i] != -1)
    3d8c:	ff4506e3          	beq	a0,s4,3d78 <sbrkfail+0x88>
      read(fds[0], &scratch, 1);
    3d90:	4605                	li	a2,1
    3d92:	faf40593          	addi	a1,s0,-81
    3d96:	fb042503          	lw	a0,-80(s0)
    3d9a:	00001097          	auipc	ra,0x1
    3d9e:	5e8080e7          	jalr	1512(ra) # 5382 <read>
    3da2:	bfd9                	j	3d78 <sbrkfail+0x88>
  c = sbrk(PGSIZE);
    3da4:	6505                	lui	a0,0x1
    3da6:	00001097          	auipc	ra,0x1
    3daa:	64c080e7          	jalr	1612(ra) # 53f2 <sbrk>
    3dae:	8a2a                	mv	s4,a0
    if(pids[i] == -1)
    3db0:	597d                	li	s2,-1
    3db2:	a021                	j	3dba <sbrkfail+0xca>
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    3db4:	0491                	addi	s1,s1,4
    3db6:	01348f63          	beq	s1,s3,3dd4 <sbrkfail+0xe4>
    if(pids[i] == -1)
    3dba:	4088                	lw	a0,0(s1)
    3dbc:	ff250ce3          	beq	a0,s2,3db4 <sbrkfail+0xc4>
    kill(pids[i]);
    3dc0:	00001097          	auipc	ra,0x1
    3dc4:	5da080e7          	jalr	1498(ra) # 539a <kill>
    wait(0);
    3dc8:	4501                	li	a0,0
    3dca:	00001097          	auipc	ra,0x1
    3dce:	5a8080e7          	jalr	1448(ra) # 5372 <wait>
    3dd2:	b7cd                	j	3db4 <sbrkfail+0xc4>
  if(c == (char*)0xffffffffffffffffL){
    3dd4:	57fd                	li	a5,-1
    3dd6:	04fa0163          	beq	s4,a5,3e18 <sbrkfail+0x128>
  pid = fork();
    3dda:	00001097          	auipc	ra,0x1
    3dde:	588080e7          	jalr	1416(ra) # 5362 <fork>
    3de2:	84aa                	mv	s1,a0
  if(pid < 0){
    3de4:	04054863          	bltz	a0,3e34 <sbrkfail+0x144>
  if(pid == 0){
    3de8:	c525                	beqz	a0,3e50 <sbrkfail+0x160>
  wait(&xstatus);
    3dea:	fbc40513          	addi	a0,s0,-68
    3dee:	00001097          	auipc	ra,0x1
    3df2:	584080e7          	jalr	1412(ra) # 5372 <wait>
  if(xstatus != -1 && xstatus != 2)
    3df6:	fbc42783          	lw	a5,-68(s0)
    3dfa:	577d                	li	a4,-1
    3dfc:	00e78563          	beq	a5,a4,3e06 <sbrkfail+0x116>
    3e00:	4709                	li	a4,2
    3e02:	08e79c63          	bne	a5,a4,3e9a <sbrkfail+0x1aa>
}
    3e06:	70e6                	ld	ra,120(sp)
    3e08:	7446                	ld	s0,112(sp)
    3e0a:	74a6                	ld	s1,104(sp)
    3e0c:	7906                	ld	s2,96(sp)
    3e0e:	69e6                	ld	s3,88(sp)
    3e10:	6a46                	ld	s4,80(sp)
    3e12:	6aa6                	ld	s5,72(sp)
    3e14:	6109                	addi	sp,sp,128
    3e16:	8082                	ret
    printf("%s: failed sbrk leaked memory\n", s);
    3e18:	85d6                	mv	a1,s5
    3e1a:	00003517          	auipc	a0,0x3
    3e1e:	4ae50513          	addi	a0,a0,1198 # 72c8 <malloc+0x1b2c>
    3e22:	00002097          	auipc	ra,0x2
    3e26:	8c2080e7          	jalr	-1854(ra) # 56e4 <printf>
    exit(1);
    3e2a:	4505                	li	a0,1
    3e2c:	00001097          	auipc	ra,0x1
    3e30:	53e080e7          	jalr	1342(ra) # 536a <exit>
    printf("%s: fork failed\n", s);
    3e34:	85d6                	mv	a1,s5
    3e36:	00002517          	auipc	a0,0x2
    3e3a:	2e250513          	addi	a0,a0,738 # 6118 <malloc+0x97c>
    3e3e:	00002097          	auipc	ra,0x2
    3e42:	8a6080e7          	jalr	-1882(ra) # 56e4 <printf>
    exit(1);
    3e46:	4505                	li	a0,1
    3e48:	00001097          	auipc	ra,0x1
    3e4c:	522080e7          	jalr	1314(ra) # 536a <exit>
    a = sbrk(0);
    3e50:	4501                	li	a0,0
    3e52:	00001097          	auipc	ra,0x1
    3e56:	5a0080e7          	jalr	1440(ra) # 53f2 <sbrk>
    3e5a:	892a                	mv	s2,a0
    sbrk(10*BIG);
    3e5c:	3e800537          	lui	a0,0x3e800
    3e60:	00001097          	auipc	ra,0x1
    3e64:	592080e7          	jalr	1426(ra) # 53f2 <sbrk>
    for (i = 0; i < 10*BIG; i += PGSIZE) {
    3e68:	87ca                	mv	a5,s2
    3e6a:	3e800737          	lui	a4,0x3e800
    3e6e:	993a                	add	s2,s2,a4
    3e70:	6705                	lui	a4,0x1
      n += *(a+i);
    3e72:	0007c683          	lbu	a3,0(a5) # 6400000 <__BSS_END__+0x63f1870>
    3e76:	9cb5                	addw	s1,s1,a3
    for (i = 0; i < 10*BIG; i += PGSIZE) {
    3e78:	97ba                	add	a5,a5,a4
    3e7a:	ff279ce3          	bne	a5,s2,3e72 <sbrkfail+0x182>
    printf("%s: allocate a lot of memory succeeded %d\n", n);
    3e7e:	85a6                	mv	a1,s1
    3e80:	00003517          	auipc	a0,0x3
    3e84:	46850513          	addi	a0,a0,1128 # 72e8 <malloc+0x1b4c>
    3e88:	00002097          	auipc	ra,0x2
    3e8c:	85c080e7          	jalr	-1956(ra) # 56e4 <printf>
    exit(1);
    3e90:	4505                	li	a0,1
    3e92:	00001097          	auipc	ra,0x1
    3e96:	4d8080e7          	jalr	1240(ra) # 536a <exit>
    exit(1);
    3e9a:	4505                	li	a0,1
    3e9c:	00001097          	auipc	ra,0x1
    3ea0:	4ce080e7          	jalr	1230(ra) # 536a <exit>

0000000000003ea4 <reparent>:
{
    3ea4:	7179                	addi	sp,sp,-48
    3ea6:	f406                	sd	ra,40(sp)
    3ea8:	f022                	sd	s0,32(sp)
    3eaa:	ec26                	sd	s1,24(sp)
    3eac:	e84a                	sd	s2,16(sp)
    3eae:	e44e                	sd	s3,8(sp)
    3eb0:	e052                	sd	s4,0(sp)
    3eb2:	1800                	addi	s0,sp,48
    3eb4:	89aa                	mv	s3,a0
  int master_pid = getpid();
    3eb6:	00001097          	auipc	ra,0x1
    3eba:	534080e7          	jalr	1332(ra) # 53ea <getpid>
    3ebe:	8a2a                	mv	s4,a0
    3ec0:	0c800913          	li	s2,200
    int pid = fork();
    3ec4:	00001097          	auipc	ra,0x1
    3ec8:	49e080e7          	jalr	1182(ra) # 5362 <fork>
    3ecc:	84aa                	mv	s1,a0
    if(pid < 0){
    3ece:	02054263          	bltz	a0,3ef2 <reparent+0x4e>
    if(pid){
    3ed2:	cd21                	beqz	a0,3f2a <reparent+0x86>
      if(wait(0) != pid){
    3ed4:	4501                	li	a0,0
    3ed6:	00001097          	auipc	ra,0x1
    3eda:	49c080e7          	jalr	1180(ra) # 5372 <wait>
    3ede:	02951863          	bne	a0,s1,3f0e <reparent+0x6a>
  for(int i = 0; i < 200; i++){
    3ee2:	397d                	addiw	s2,s2,-1
    3ee4:	fe0910e3          	bnez	s2,3ec4 <reparent+0x20>
  exit(0);
    3ee8:	4501                	li	a0,0
    3eea:	00001097          	auipc	ra,0x1
    3eee:	480080e7          	jalr	1152(ra) # 536a <exit>
      printf("%s: fork failed\n", s);
    3ef2:	85ce                	mv	a1,s3
    3ef4:	00002517          	auipc	a0,0x2
    3ef8:	22450513          	addi	a0,a0,548 # 6118 <malloc+0x97c>
    3efc:	00001097          	auipc	ra,0x1
    3f00:	7e8080e7          	jalr	2024(ra) # 56e4 <printf>
      exit(1);
    3f04:	4505                	li	a0,1
    3f06:	00001097          	auipc	ra,0x1
    3f0a:	464080e7          	jalr	1124(ra) # 536a <exit>
        printf("%s: wait wrong pid\n", s);
    3f0e:	85ce                	mv	a1,s3
    3f10:	00002517          	auipc	a0,0x2
    3f14:	39050513          	addi	a0,a0,912 # 62a0 <malloc+0xb04>
    3f18:	00001097          	auipc	ra,0x1
    3f1c:	7cc080e7          	jalr	1996(ra) # 56e4 <printf>
        exit(1);
    3f20:	4505                	li	a0,1
    3f22:	00001097          	auipc	ra,0x1
    3f26:	448080e7          	jalr	1096(ra) # 536a <exit>
      int pid2 = fork();
    3f2a:	00001097          	auipc	ra,0x1
    3f2e:	438080e7          	jalr	1080(ra) # 5362 <fork>
      if(pid2 < 0){
    3f32:	00054763          	bltz	a0,3f40 <reparent+0x9c>
      exit(0);
    3f36:	4501                	li	a0,0
    3f38:	00001097          	auipc	ra,0x1
    3f3c:	432080e7          	jalr	1074(ra) # 536a <exit>
        kill(master_pid);
    3f40:	8552                	mv	a0,s4
    3f42:	00001097          	auipc	ra,0x1
    3f46:	458080e7          	jalr	1112(ra) # 539a <kill>
        exit(1);
    3f4a:	4505                	li	a0,1
    3f4c:	00001097          	auipc	ra,0x1
    3f50:	41e080e7          	jalr	1054(ra) # 536a <exit>

0000000000003f54 <mem>:
{
    3f54:	7139                	addi	sp,sp,-64
    3f56:	fc06                	sd	ra,56(sp)
    3f58:	f822                	sd	s0,48(sp)
    3f5a:	f426                	sd	s1,40(sp)
    3f5c:	f04a                	sd	s2,32(sp)
    3f5e:	ec4e                	sd	s3,24(sp)
    3f60:	0080                	addi	s0,sp,64
    3f62:	89aa                	mv	s3,a0
  if((pid = fork()) == 0){
    3f64:	00001097          	auipc	ra,0x1
    3f68:	3fe080e7          	jalr	1022(ra) # 5362 <fork>
    m1 = 0;
    3f6c:	4481                	li	s1,0
    while((m2 = malloc(10001)) != 0){
    3f6e:	6909                	lui	s2,0x2
    3f70:	71190913          	addi	s2,s2,1809 # 2711 <sbrkarg+0xc3>
  if((pid = fork()) == 0){
    3f74:	c115                	beqz	a0,3f98 <mem+0x44>
    wait(&xstatus);
    3f76:	fcc40513          	addi	a0,s0,-52
    3f7a:	00001097          	auipc	ra,0x1
    3f7e:	3f8080e7          	jalr	1016(ra) # 5372 <wait>
    if(xstatus == -1){
    3f82:	fcc42503          	lw	a0,-52(s0)
    3f86:	57fd                	li	a5,-1
    3f88:	06f50363          	beq	a0,a5,3fee <mem+0x9a>
    exit(xstatus);
    3f8c:	00001097          	auipc	ra,0x1
    3f90:	3de080e7          	jalr	990(ra) # 536a <exit>
      *(char**)m2 = m1;
    3f94:	e104                	sd	s1,0(a0)
      m1 = m2;
    3f96:	84aa                	mv	s1,a0
    while((m2 = malloc(10001)) != 0){
    3f98:	854a                	mv	a0,s2
    3f9a:	00002097          	auipc	ra,0x2
    3f9e:	802080e7          	jalr	-2046(ra) # 579c <malloc>
    3fa2:	f96d                	bnez	a0,3f94 <mem+0x40>
    while(m1){
    3fa4:	c881                	beqz	s1,3fb4 <mem+0x60>
      m2 = *(char**)m1;
    3fa6:	8526                	mv	a0,s1
    3fa8:	6084                	ld	s1,0(s1)
      free(m1);
    3faa:	00001097          	auipc	ra,0x1
    3fae:	770080e7          	jalr	1904(ra) # 571a <free>
    while(m1){
    3fb2:	f8f5                	bnez	s1,3fa6 <mem+0x52>
    m1 = malloc(1024*20);
    3fb4:	6515                	lui	a0,0x5
    3fb6:	00001097          	auipc	ra,0x1
    3fba:	7e6080e7          	jalr	2022(ra) # 579c <malloc>
    if(m1 == 0){
    3fbe:	c911                	beqz	a0,3fd2 <mem+0x7e>
    free(m1);
    3fc0:	00001097          	auipc	ra,0x1
    3fc4:	75a080e7          	jalr	1882(ra) # 571a <free>
    exit(0);
    3fc8:	4501                	li	a0,0
    3fca:	00001097          	auipc	ra,0x1
    3fce:	3a0080e7          	jalr	928(ra) # 536a <exit>
      printf("couldn't allocate mem?!!\n", s);
    3fd2:	85ce                	mv	a1,s3
    3fd4:	00003517          	auipc	a0,0x3
    3fd8:	34450513          	addi	a0,a0,836 # 7318 <malloc+0x1b7c>
    3fdc:	00001097          	auipc	ra,0x1
    3fe0:	708080e7          	jalr	1800(ra) # 56e4 <printf>
      exit(1);
    3fe4:	4505                	li	a0,1
    3fe6:	00001097          	auipc	ra,0x1
    3fea:	384080e7          	jalr	900(ra) # 536a <exit>
      exit(0);
    3fee:	4501                	li	a0,0
    3ff0:	00001097          	auipc	ra,0x1
    3ff4:	37a080e7          	jalr	890(ra) # 536a <exit>

0000000000003ff8 <sharedfd>:
{
    3ff8:	7159                	addi	sp,sp,-112
    3ffa:	f486                	sd	ra,104(sp)
    3ffc:	f0a2                	sd	s0,96(sp)
    3ffe:	eca6                	sd	s1,88(sp)
    4000:	e8ca                	sd	s2,80(sp)
    4002:	e4ce                	sd	s3,72(sp)
    4004:	e0d2                	sd	s4,64(sp)
    4006:	fc56                	sd	s5,56(sp)
    4008:	f85a                	sd	s6,48(sp)
    400a:	f45e                	sd	s7,40(sp)
    400c:	1880                	addi	s0,sp,112
    400e:	8a2a                	mv	s4,a0
  unlink("sharedfd");
    4010:	00003517          	auipc	a0,0x3
    4014:	32850513          	addi	a0,a0,808 # 7338 <malloc+0x1b9c>
    4018:	00001097          	auipc	ra,0x1
    401c:	3a2080e7          	jalr	930(ra) # 53ba <unlink>
  fd = open("sharedfd", O_CREATE|O_RDWR);
    4020:	20200593          	li	a1,514
    4024:	00003517          	auipc	a0,0x3
    4028:	31450513          	addi	a0,a0,788 # 7338 <malloc+0x1b9c>
    402c:	00001097          	auipc	ra,0x1
    4030:	37e080e7          	jalr	894(ra) # 53aa <open>
  if(fd < 0){
    4034:	04054a63          	bltz	a0,4088 <sharedfd+0x90>
    4038:	892a                	mv	s2,a0
  pid = fork();
    403a:	00001097          	auipc	ra,0x1
    403e:	328080e7          	jalr	808(ra) # 5362 <fork>
    4042:	89aa                	mv	s3,a0
  memset(buf, pid==0?'c':'p', sizeof(buf));
    4044:	06300593          	li	a1,99
    4048:	c119                	beqz	a0,404e <sharedfd+0x56>
    404a:	07000593          	li	a1,112
    404e:	4629                	li	a2,10
    4050:	fa040513          	addi	a0,s0,-96
    4054:	00001097          	auipc	ra,0x1
    4058:	11c080e7          	jalr	284(ra) # 5170 <memset>
    405c:	3e800493          	li	s1,1000
    if(write(fd, buf, sizeof(buf)) != sizeof(buf)){
    4060:	4629                	li	a2,10
    4062:	fa040593          	addi	a1,s0,-96
    4066:	854a                	mv	a0,s2
    4068:	00001097          	auipc	ra,0x1
    406c:	322080e7          	jalr	802(ra) # 538a <write>
    4070:	47a9                	li	a5,10
    4072:	02f51963          	bne	a0,a5,40a4 <sharedfd+0xac>
  for(i = 0; i < N; i++){
    4076:	34fd                	addiw	s1,s1,-1
    4078:	f4e5                	bnez	s1,4060 <sharedfd+0x68>
  if(pid == 0) {
    407a:	04099363          	bnez	s3,40c0 <sharedfd+0xc8>
    exit(0);
    407e:	4501                	li	a0,0
    4080:	00001097          	auipc	ra,0x1
    4084:	2ea080e7          	jalr	746(ra) # 536a <exit>
    printf("%s: cannot open sharedfd for writing", s);
    4088:	85d2                	mv	a1,s4
    408a:	00003517          	auipc	a0,0x3
    408e:	2be50513          	addi	a0,a0,702 # 7348 <malloc+0x1bac>
    4092:	00001097          	auipc	ra,0x1
    4096:	652080e7          	jalr	1618(ra) # 56e4 <printf>
    exit(1);
    409a:	4505                	li	a0,1
    409c:	00001097          	auipc	ra,0x1
    40a0:	2ce080e7          	jalr	718(ra) # 536a <exit>
      printf("%s: write sharedfd failed\n", s);
    40a4:	85d2                	mv	a1,s4
    40a6:	00003517          	auipc	a0,0x3
    40aa:	2ca50513          	addi	a0,a0,714 # 7370 <malloc+0x1bd4>
    40ae:	00001097          	auipc	ra,0x1
    40b2:	636080e7          	jalr	1590(ra) # 56e4 <printf>
      exit(1);
    40b6:	4505                	li	a0,1
    40b8:	00001097          	auipc	ra,0x1
    40bc:	2b2080e7          	jalr	690(ra) # 536a <exit>
    wait(&xstatus);
    40c0:	f9c40513          	addi	a0,s0,-100
    40c4:	00001097          	auipc	ra,0x1
    40c8:	2ae080e7          	jalr	686(ra) # 5372 <wait>
    if(xstatus != 0)
    40cc:	f9c42983          	lw	s3,-100(s0)
    40d0:	00098763          	beqz	s3,40de <sharedfd+0xe6>
      exit(xstatus);
    40d4:	854e                	mv	a0,s3
    40d6:	00001097          	auipc	ra,0x1
    40da:	294080e7          	jalr	660(ra) # 536a <exit>
  close(fd);
    40de:	854a                	mv	a0,s2
    40e0:	00001097          	auipc	ra,0x1
    40e4:	2b2080e7          	jalr	690(ra) # 5392 <close>
  fd = open("sharedfd", 0);
    40e8:	4581                	li	a1,0
    40ea:	00003517          	auipc	a0,0x3
    40ee:	24e50513          	addi	a0,a0,590 # 7338 <malloc+0x1b9c>
    40f2:	00001097          	auipc	ra,0x1
    40f6:	2b8080e7          	jalr	696(ra) # 53aa <open>
    40fa:	8baa                	mv	s7,a0
  nc = np = 0;
    40fc:	8ace                	mv	s5,s3
  if(fd < 0){
    40fe:	02054563          	bltz	a0,4128 <sharedfd+0x130>
    4102:	faa40913          	addi	s2,s0,-86
      if(buf[i] == 'c')
    4106:	06300493          	li	s1,99
      if(buf[i] == 'p')
    410a:	07000b13          	li	s6,112
  while((n = read(fd, buf, sizeof(buf))) > 0){
    410e:	4629                	li	a2,10
    4110:	fa040593          	addi	a1,s0,-96
    4114:	855e                	mv	a0,s7
    4116:	00001097          	auipc	ra,0x1
    411a:	26c080e7          	jalr	620(ra) # 5382 <read>
    411e:	02a05f63          	blez	a0,415c <sharedfd+0x164>
    4122:	fa040793          	addi	a5,s0,-96
    4126:	a01d                	j	414c <sharedfd+0x154>
    printf("%s: cannot open sharedfd for reading\n", s);
    4128:	85d2                	mv	a1,s4
    412a:	00003517          	auipc	a0,0x3
    412e:	26650513          	addi	a0,a0,614 # 7390 <malloc+0x1bf4>
    4132:	00001097          	auipc	ra,0x1
    4136:	5b2080e7          	jalr	1458(ra) # 56e4 <printf>
    exit(1);
    413a:	4505                	li	a0,1
    413c:	00001097          	auipc	ra,0x1
    4140:	22e080e7          	jalr	558(ra) # 536a <exit>
        nc++;
    4144:	2985                	addiw	s3,s3,1
    for(i = 0; i < sizeof(buf); i++){
    4146:	0785                	addi	a5,a5,1
    4148:	fd2783e3          	beq	a5,s2,410e <sharedfd+0x116>
      if(buf[i] == 'c')
    414c:	0007c703          	lbu	a4,0(a5)
    4150:	fe970ae3          	beq	a4,s1,4144 <sharedfd+0x14c>
      if(buf[i] == 'p')
    4154:	ff6719e3          	bne	a4,s6,4146 <sharedfd+0x14e>
        np++;
    4158:	2a85                	addiw	s5,s5,1
    415a:	b7f5                	j	4146 <sharedfd+0x14e>
  close(fd);
    415c:	855e                	mv	a0,s7
    415e:	00001097          	auipc	ra,0x1
    4162:	234080e7          	jalr	564(ra) # 5392 <close>
  unlink("sharedfd");
    4166:	00003517          	auipc	a0,0x3
    416a:	1d250513          	addi	a0,a0,466 # 7338 <malloc+0x1b9c>
    416e:	00001097          	auipc	ra,0x1
    4172:	24c080e7          	jalr	588(ra) # 53ba <unlink>
  if(nc == N*SZ && np == N*SZ){
    4176:	6789                	lui	a5,0x2
    4178:	71078793          	addi	a5,a5,1808 # 2710 <sbrkarg+0xc2>
    417c:	00f99763          	bne	s3,a5,418a <sharedfd+0x192>
    4180:	6789                	lui	a5,0x2
    4182:	71078793          	addi	a5,a5,1808 # 2710 <sbrkarg+0xc2>
    4186:	02fa8063          	beq	s5,a5,41a6 <sharedfd+0x1ae>
    printf("%s: nc/np test fails\n", s);
    418a:	85d2                	mv	a1,s4
    418c:	00003517          	auipc	a0,0x3
    4190:	22c50513          	addi	a0,a0,556 # 73b8 <malloc+0x1c1c>
    4194:	00001097          	auipc	ra,0x1
    4198:	550080e7          	jalr	1360(ra) # 56e4 <printf>
    exit(1);
    419c:	4505                	li	a0,1
    419e:	00001097          	auipc	ra,0x1
    41a2:	1cc080e7          	jalr	460(ra) # 536a <exit>
    exit(0);
    41a6:	4501                	li	a0,0
    41a8:	00001097          	auipc	ra,0x1
    41ac:	1c2080e7          	jalr	450(ra) # 536a <exit>

00000000000041b0 <fourfiles>:
{
    41b0:	7171                	addi	sp,sp,-176
    41b2:	f506                	sd	ra,168(sp)
    41b4:	f122                	sd	s0,160(sp)
    41b6:	ed26                	sd	s1,152(sp)
    41b8:	e94a                	sd	s2,144(sp)
    41ba:	e54e                	sd	s3,136(sp)
    41bc:	e152                	sd	s4,128(sp)
    41be:	fcd6                	sd	s5,120(sp)
    41c0:	f8da                	sd	s6,112(sp)
    41c2:	f4de                	sd	s7,104(sp)
    41c4:	f0e2                	sd	s8,96(sp)
    41c6:	ece6                	sd	s9,88(sp)
    41c8:	e8ea                	sd	s10,80(sp)
    41ca:	e4ee                	sd	s11,72(sp)
    41cc:	1900                	addi	s0,sp,176
    41ce:	f4a43c23          	sd	a0,-168(s0)
  char *names[] = { "f0", "f1", "f2", "f3" };
    41d2:	00003797          	auipc	a5,0x3
    41d6:	1fe78793          	addi	a5,a5,510 # 73d0 <malloc+0x1c34>
    41da:	f6f43823          	sd	a5,-144(s0)
    41de:	00003797          	auipc	a5,0x3
    41e2:	1fa78793          	addi	a5,a5,506 # 73d8 <malloc+0x1c3c>
    41e6:	f6f43c23          	sd	a5,-136(s0)
    41ea:	00003797          	auipc	a5,0x3
    41ee:	1f678793          	addi	a5,a5,502 # 73e0 <malloc+0x1c44>
    41f2:	f8f43023          	sd	a5,-128(s0)
    41f6:	00003797          	auipc	a5,0x3
    41fa:	1f278793          	addi	a5,a5,498 # 73e8 <malloc+0x1c4c>
    41fe:	f8f43423          	sd	a5,-120(s0)
  for(pi = 0; pi < NCHILD; pi++){
    4202:	f7040c13          	addi	s8,s0,-144
  char *names[] = { "f0", "f1", "f2", "f3" };
    4206:	8962                	mv	s2,s8
  for(pi = 0; pi < NCHILD; pi++){
    4208:	4481                	li	s1,0
    420a:	4a11                	li	s4,4
    fname = names[pi];
    420c:	00093983          	ld	s3,0(s2)
    unlink(fname);
    4210:	854e                	mv	a0,s3
    4212:	00001097          	auipc	ra,0x1
    4216:	1a8080e7          	jalr	424(ra) # 53ba <unlink>
    pid = fork();
    421a:	00001097          	auipc	ra,0x1
    421e:	148080e7          	jalr	328(ra) # 5362 <fork>
    if(pid < 0){
    4222:	04054463          	bltz	a0,426a <fourfiles+0xba>
    if(pid == 0){
    4226:	c12d                	beqz	a0,4288 <fourfiles+0xd8>
  for(pi = 0; pi < NCHILD; pi++){
    4228:	2485                	addiw	s1,s1,1
    422a:	0921                	addi	s2,s2,8
    422c:	ff4490e3          	bne	s1,s4,420c <fourfiles+0x5c>
    4230:	4491                	li	s1,4
    wait(&xstatus);
    4232:	f6c40513          	addi	a0,s0,-148
    4236:	00001097          	auipc	ra,0x1
    423a:	13c080e7          	jalr	316(ra) # 5372 <wait>
    if(xstatus != 0)
    423e:	f6c42b03          	lw	s6,-148(s0)
    4242:	0c0b1e63          	bnez	s6,431e <fourfiles+0x16e>
  for(pi = 0; pi < NCHILD; pi++){
    4246:	34fd                	addiw	s1,s1,-1
    4248:	f4ed                	bnez	s1,4232 <fourfiles+0x82>
    424a:	03000b93          	li	s7,48
    while((n = read(fd, buf, sizeof(buf))) > 0){
    424e:	00007a17          	auipc	s4,0x7
    4252:	532a0a13          	addi	s4,s4,1330 # b780 <buf>
    4256:	00007a97          	auipc	s5,0x7
    425a:	52ba8a93          	addi	s5,s5,1323 # b781 <buf+0x1>
    if(total != N*SZ){
    425e:	6d85                	lui	s11,0x1
    4260:	770d8d93          	addi	s11,s11,1904 # 1770 <pipe1+0x2c>
  for(i = 0; i < NCHILD; i++){
    4264:	03400d13          	li	s10,52
    4268:	aa1d                	j	439e <fourfiles+0x1ee>
      printf("fork failed\n", s);
    426a:	f5843583          	ld	a1,-168(s0)
    426e:	00002517          	auipc	a0,0x2
    4272:	29a50513          	addi	a0,a0,666 # 6508 <malloc+0xd6c>
    4276:	00001097          	auipc	ra,0x1
    427a:	46e080e7          	jalr	1134(ra) # 56e4 <printf>
      exit(1);
    427e:	4505                	li	a0,1
    4280:	00001097          	auipc	ra,0x1
    4284:	0ea080e7          	jalr	234(ra) # 536a <exit>
      fd = open(fname, O_CREATE | O_RDWR);
    4288:	20200593          	li	a1,514
    428c:	854e                	mv	a0,s3
    428e:	00001097          	auipc	ra,0x1
    4292:	11c080e7          	jalr	284(ra) # 53aa <open>
    4296:	892a                	mv	s2,a0
      if(fd < 0){
    4298:	04054763          	bltz	a0,42e6 <fourfiles+0x136>
      memset(buf, '0'+pi, SZ);
    429c:	1f400613          	li	a2,500
    42a0:	0304859b          	addiw	a1,s1,48
    42a4:	00007517          	auipc	a0,0x7
    42a8:	4dc50513          	addi	a0,a0,1244 # b780 <buf>
    42ac:	00001097          	auipc	ra,0x1
    42b0:	ec4080e7          	jalr	-316(ra) # 5170 <memset>
    42b4:	44b1                	li	s1,12
        if((n = write(fd, buf, SZ)) != SZ){
    42b6:	00007997          	auipc	s3,0x7
    42ba:	4ca98993          	addi	s3,s3,1226 # b780 <buf>
    42be:	1f400613          	li	a2,500
    42c2:	85ce                	mv	a1,s3
    42c4:	854a                	mv	a0,s2
    42c6:	00001097          	auipc	ra,0x1
    42ca:	0c4080e7          	jalr	196(ra) # 538a <write>
    42ce:	85aa                	mv	a1,a0
    42d0:	1f400793          	li	a5,500
    42d4:	02f51863          	bne	a0,a5,4304 <fourfiles+0x154>
      for(i = 0; i < N; i++){
    42d8:	34fd                	addiw	s1,s1,-1
    42da:	f0f5                	bnez	s1,42be <fourfiles+0x10e>
      exit(0);
    42dc:	4501                	li	a0,0
    42de:	00001097          	auipc	ra,0x1
    42e2:	08c080e7          	jalr	140(ra) # 536a <exit>
        printf("create failed\n", s);
    42e6:	f5843583          	ld	a1,-168(s0)
    42ea:	00003517          	auipc	a0,0x3
    42ee:	10650513          	addi	a0,a0,262 # 73f0 <malloc+0x1c54>
    42f2:	00001097          	auipc	ra,0x1
    42f6:	3f2080e7          	jalr	1010(ra) # 56e4 <printf>
        exit(1);
    42fa:	4505                	li	a0,1
    42fc:	00001097          	auipc	ra,0x1
    4300:	06e080e7          	jalr	110(ra) # 536a <exit>
          printf("write failed %d\n", n);
    4304:	00003517          	auipc	a0,0x3
    4308:	0fc50513          	addi	a0,a0,252 # 7400 <malloc+0x1c64>
    430c:	00001097          	auipc	ra,0x1
    4310:	3d8080e7          	jalr	984(ra) # 56e4 <printf>
          exit(1);
    4314:	4505                	li	a0,1
    4316:	00001097          	auipc	ra,0x1
    431a:	054080e7          	jalr	84(ra) # 536a <exit>
      exit(xstatus);
    431e:	855a                	mv	a0,s6
    4320:	00001097          	auipc	ra,0x1
    4324:	04a080e7          	jalr	74(ra) # 536a <exit>
          printf("wrong char\n", s);
    4328:	f5843583          	ld	a1,-168(s0)
    432c:	00003517          	auipc	a0,0x3
    4330:	0ec50513          	addi	a0,a0,236 # 7418 <malloc+0x1c7c>
    4334:	00001097          	auipc	ra,0x1
    4338:	3b0080e7          	jalr	944(ra) # 56e4 <printf>
          exit(1);
    433c:	4505                	li	a0,1
    433e:	00001097          	auipc	ra,0x1
    4342:	02c080e7          	jalr	44(ra) # 536a <exit>
      total += n;
    4346:	00a9093b          	addw	s2,s2,a0
    while((n = read(fd, buf, sizeof(buf))) > 0){
    434a:	660d                	lui	a2,0x3
    434c:	85d2                	mv	a1,s4
    434e:	854e                	mv	a0,s3
    4350:	00001097          	auipc	ra,0x1
    4354:	032080e7          	jalr	50(ra) # 5382 <read>
    4358:	02a05363          	blez	a0,437e <fourfiles+0x1ce>
    435c:	00007797          	auipc	a5,0x7
    4360:	42478793          	addi	a5,a5,1060 # b780 <buf>
    4364:	fff5069b          	addiw	a3,a0,-1
    4368:	1682                	slli	a3,a3,0x20
    436a:	9281                	srli	a3,a3,0x20
    436c:	96d6                	add	a3,a3,s5
        if(buf[j] != '0'+i){
    436e:	0007c703          	lbu	a4,0(a5)
    4372:	fa971be3          	bne	a4,s1,4328 <fourfiles+0x178>
      for(j = 0; j < n; j++){
    4376:	0785                	addi	a5,a5,1
    4378:	fed79be3          	bne	a5,a3,436e <fourfiles+0x1be>
    437c:	b7e9                	j	4346 <fourfiles+0x196>
    close(fd);
    437e:	854e                	mv	a0,s3
    4380:	00001097          	auipc	ra,0x1
    4384:	012080e7          	jalr	18(ra) # 5392 <close>
    if(total != N*SZ){
    4388:	03b91863          	bne	s2,s11,43b8 <fourfiles+0x208>
    unlink(fname);
    438c:	8566                	mv	a0,s9
    438e:	00001097          	auipc	ra,0x1
    4392:	02c080e7          	jalr	44(ra) # 53ba <unlink>
  for(i = 0; i < NCHILD; i++){
    4396:	0c21                	addi	s8,s8,8
    4398:	2b85                	addiw	s7,s7,1
    439a:	03ab8d63          	beq	s7,s10,43d4 <fourfiles+0x224>
    fname = names[i];
    439e:	000c3c83          	ld	s9,0(s8)
    fd = open(fname, 0);
    43a2:	4581                	li	a1,0
    43a4:	8566                	mv	a0,s9
    43a6:	00001097          	auipc	ra,0x1
    43aa:	004080e7          	jalr	4(ra) # 53aa <open>
    43ae:	89aa                	mv	s3,a0
    total = 0;
    43b0:	895a                	mv	s2,s6
        if(buf[j] != '0'+i){
    43b2:	000b849b          	sext.w	s1,s7
    while((n = read(fd, buf, sizeof(buf))) > 0){
    43b6:	bf51                	j	434a <fourfiles+0x19a>
      printf("wrong length %d\n", total);
    43b8:	85ca                	mv	a1,s2
    43ba:	00003517          	auipc	a0,0x3
    43be:	06e50513          	addi	a0,a0,110 # 7428 <malloc+0x1c8c>
    43c2:	00001097          	auipc	ra,0x1
    43c6:	322080e7          	jalr	802(ra) # 56e4 <printf>
      exit(1);
    43ca:	4505                	li	a0,1
    43cc:	00001097          	auipc	ra,0x1
    43d0:	f9e080e7          	jalr	-98(ra) # 536a <exit>
}
    43d4:	70aa                	ld	ra,168(sp)
    43d6:	740a                	ld	s0,160(sp)
    43d8:	64ea                	ld	s1,152(sp)
    43da:	694a                	ld	s2,144(sp)
    43dc:	69aa                	ld	s3,136(sp)
    43de:	6a0a                	ld	s4,128(sp)
    43e0:	7ae6                	ld	s5,120(sp)
    43e2:	7b46                	ld	s6,112(sp)
    43e4:	7ba6                	ld	s7,104(sp)
    43e6:	7c06                	ld	s8,96(sp)
    43e8:	6ce6                	ld	s9,88(sp)
    43ea:	6d46                	ld	s10,80(sp)
    43ec:	6da6                	ld	s11,72(sp)
    43ee:	614d                	addi	sp,sp,176
    43f0:	8082                	ret

00000000000043f2 <concreate>:
{
    43f2:	7135                	addi	sp,sp,-160
    43f4:	ed06                	sd	ra,152(sp)
    43f6:	e922                	sd	s0,144(sp)
    43f8:	e526                	sd	s1,136(sp)
    43fa:	e14a                	sd	s2,128(sp)
    43fc:	fcce                	sd	s3,120(sp)
    43fe:	f8d2                	sd	s4,112(sp)
    4400:	f4d6                	sd	s5,104(sp)
    4402:	f0da                	sd	s6,96(sp)
    4404:	ecde                	sd	s7,88(sp)
    4406:	1100                	addi	s0,sp,160
    4408:	89aa                	mv	s3,a0
  file[0] = 'C';
    440a:	04300793          	li	a5,67
    440e:	faf40423          	sb	a5,-88(s0)
  file[2] = '\0';
    4412:	fa040523          	sb	zero,-86(s0)
  for(i = 0; i < N; i++){
    4416:	4901                	li	s2,0
    if(pid && (i % 3) == 1){
    4418:	4b0d                	li	s6,3
    441a:	4a85                	li	s5,1
      link("C0", file);
    441c:	00003b97          	auipc	s7,0x3
    4420:	024b8b93          	addi	s7,s7,36 # 7440 <malloc+0x1ca4>
  for(i = 0; i < N; i++){
    4424:	02800a13          	li	s4,40
    4428:	acc9                	j	46fa <concreate+0x308>
      link("C0", file);
    442a:	fa840593          	addi	a1,s0,-88
    442e:	855e                	mv	a0,s7
    4430:	00001097          	auipc	ra,0x1
    4434:	f9a080e7          	jalr	-102(ra) # 53ca <link>
    if(pid == 0) {
    4438:	a465                	j	46e0 <concreate+0x2ee>
    } else if(pid == 0 && (i % 5) == 1){
    443a:	4795                	li	a5,5
    443c:	02f9693b          	remw	s2,s2,a5
    4440:	4785                	li	a5,1
    4442:	02f90b63          	beq	s2,a5,4478 <concreate+0x86>
      fd = open(file, O_CREATE | O_RDWR);
    4446:	20200593          	li	a1,514
    444a:	fa840513          	addi	a0,s0,-88
    444e:	00001097          	auipc	ra,0x1
    4452:	f5c080e7          	jalr	-164(ra) # 53aa <open>
      if(fd < 0){
    4456:	26055c63          	bgez	a0,46ce <concreate+0x2dc>
        printf("concreate create %s failed\n", file);
    445a:	fa840593          	addi	a1,s0,-88
    445e:	00003517          	auipc	a0,0x3
    4462:	fea50513          	addi	a0,a0,-22 # 7448 <malloc+0x1cac>
    4466:	00001097          	auipc	ra,0x1
    446a:	27e080e7          	jalr	638(ra) # 56e4 <printf>
        exit(1);
    446e:	4505                	li	a0,1
    4470:	00001097          	auipc	ra,0x1
    4474:	efa080e7          	jalr	-262(ra) # 536a <exit>
      link("C0", file);
    4478:	fa840593          	addi	a1,s0,-88
    447c:	00003517          	auipc	a0,0x3
    4480:	fc450513          	addi	a0,a0,-60 # 7440 <malloc+0x1ca4>
    4484:	00001097          	auipc	ra,0x1
    4488:	f46080e7          	jalr	-186(ra) # 53ca <link>
      exit(0);
    448c:	4501                	li	a0,0
    448e:	00001097          	auipc	ra,0x1
    4492:	edc080e7          	jalr	-292(ra) # 536a <exit>
        exit(1);
    4496:	4505                	li	a0,1
    4498:	00001097          	auipc	ra,0x1
    449c:	ed2080e7          	jalr	-302(ra) # 536a <exit>
  memset(fa, 0, sizeof(fa));
    44a0:	02800613          	li	a2,40
    44a4:	4581                	li	a1,0
    44a6:	f8040513          	addi	a0,s0,-128
    44aa:	00001097          	auipc	ra,0x1
    44ae:	cc6080e7          	jalr	-826(ra) # 5170 <memset>
  fd = open(".", 0);
    44b2:	4581                	li	a1,0
    44b4:	00002517          	auipc	a0,0x2
    44b8:	ac450513          	addi	a0,a0,-1340 # 5f78 <malloc+0x7dc>
    44bc:	00001097          	auipc	ra,0x1
    44c0:	eee080e7          	jalr	-274(ra) # 53aa <open>
    44c4:	892a                	mv	s2,a0
  n = 0;
    44c6:	8aa6                	mv	s5,s1
    if(de.name[0] == 'C' && de.name[2] == '\0'){
    44c8:	04300a13          	li	s4,67
      if(i < 0 || i >= sizeof(fa)){
    44cc:	02700b13          	li	s6,39
      fa[i] = 1;
    44d0:	4b85                	li	s7,1
  while(read(fd, &de, sizeof(de)) > 0){
    44d2:	4641                	li	a2,16
    44d4:	f7040593          	addi	a1,s0,-144
    44d8:	854a                	mv	a0,s2
    44da:	00001097          	auipc	ra,0x1
    44de:	ea8080e7          	jalr	-344(ra) # 5382 <read>
    44e2:	08a05263          	blez	a0,4566 <concreate+0x174>
    if(de.inum == 0)
    44e6:	f7045783          	lhu	a5,-144(s0)
    44ea:	d7e5                	beqz	a5,44d2 <concreate+0xe0>
    if(de.name[0] == 'C' && de.name[2] == '\0'){
    44ec:	f7244783          	lbu	a5,-142(s0)
    44f0:	ff4791e3          	bne	a5,s4,44d2 <concreate+0xe0>
    44f4:	f7444783          	lbu	a5,-140(s0)
    44f8:	ffe9                	bnez	a5,44d2 <concreate+0xe0>
      i = de.name[1] - '0';
    44fa:	f7344783          	lbu	a5,-141(s0)
    44fe:	fd07879b          	addiw	a5,a5,-48
    4502:	0007871b          	sext.w	a4,a5
      if(i < 0 || i >= sizeof(fa)){
    4506:	02eb6063          	bltu	s6,a4,4526 <concreate+0x134>
      if(fa[i]){
    450a:	fb070793          	addi	a5,a4,-80 # fb0 <bigdir+0x48>
    450e:	97a2                	add	a5,a5,s0
    4510:	fd07c783          	lbu	a5,-48(a5)
    4514:	eb8d                	bnez	a5,4546 <concreate+0x154>
      fa[i] = 1;
    4516:	fb070793          	addi	a5,a4,-80
    451a:	00878733          	add	a4,a5,s0
    451e:	fd770823          	sb	s7,-48(a4)
      n++;
    4522:	2a85                	addiw	s5,s5,1
    4524:	b77d                	j	44d2 <concreate+0xe0>
        printf("%s: concreate weird file %s\n", s, de.name);
    4526:	f7240613          	addi	a2,s0,-142
    452a:	85ce                	mv	a1,s3
    452c:	00003517          	auipc	a0,0x3
    4530:	f3c50513          	addi	a0,a0,-196 # 7468 <malloc+0x1ccc>
    4534:	00001097          	auipc	ra,0x1
    4538:	1b0080e7          	jalr	432(ra) # 56e4 <printf>
        exit(1);
    453c:	4505                	li	a0,1
    453e:	00001097          	auipc	ra,0x1
    4542:	e2c080e7          	jalr	-468(ra) # 536a <exit>
        printf("%s: concreate duplicate file %s\n", s, de.name);
    4546:	f7240613          	addi	a2,s0,-142
    454a:	85ce                	mv	a1,s3
    454c:	00003517          	auipc	a0,0x3
    4550:	f3c50513          	addi	a0,a0,-196 # 7488 <malloc+0x1cec>
    4554:	00001097          	auipc	ra,0x1
    4558:	190080e7          	jalr	400(ra) # 56e4 <printf>
        exit(1);
    455c:	4505                	li	a0,1
    455e:	00001097          	auipc	ra,0x1
    4562:	e0c080e7          	jalr	-500(ra) # 536a <exit>
  close(fd);
    4566:	854a                	mv	a0,s2
    4568:	00001097          	auipc	ra,0x1
    456c:	e2a080e7          	jalr	-470(ra) # 5392 <close>
  if(n != N){
    4570:	02800793          	li	a5,40
    4574:	00fa9763          	bne	s5,a5,4582 <concreate+0x190>
    if(((i % 3) == 0 && pid == 0) ||
    4578:	4a8d                	li	s5,3
    457a:	4b05                	li	s6,1
  for(i = 0; i < N; i++){
    457c:	02800a13          	li	s4,40
    4580:	a8c9                	j	4652 <concreate+0x260>
    printf("%s: concreate not enough files in directory listing\n", s);
    4582:	85ce                	mv	a1,s3
    4584:	00003517          	auipc	a0,0x3
    4588:	f2c50513          	addi	a0,a0,-212 # 74b0 <malloc+0x1d14>
    458c:	00001097          	auipc	ra,0x1
    4590:	158080e7          	jalr	344(ra) # 56e4 <printf>
    exit(1);
    4594:	4505                	li	a0,1
    4596:	00001097          	auipc	ra,0x1
    459a:	dd4080e7          	jalr	-556(ra) # 536a <exit>
      printf("%s: fork failed\n", s);
    459e:	85ce                	mv	a1,s3
    45a0:	00002517          	auipc	a0,0x2
    45a4:	b7850513          	addi	a0,a0,-1160 # 6118 <malloc+0x97c>
    45a8:	00001097          	auipc	ra,0x1
    45ac:	13c080e7          	jalr	316(ra) # 56e4 <printf>
      exit(1);
    45b0:	4505                	li	a0,1
    45b2:	00001097          	auipc	ra,0x1
    45b6:	db8080e7          	jalr	-584(ra) # 536a <exit>
      close(open(file, 0));
    45ba:	4581                	li	a1,0
    45bc:	fa840513          	addi	a0,s0,-88
    45c0:	00001097          	auipc	ra,0x1
    45c4:	dea080e7          	jalr	-534(ra) # 53aa <open>
    45c8:	00001097          	auipc	ra,0x1
    45cc:	dca080e7          	jalr	-566(ra) # 5392 <close>
      close(open(file, 0));
    45d0:	4581                	li	a1,0
    45d2:	fa840513          	addi	a0,s0,-88
    45d6:	00001097          	auipc	ra,0x1
    45da:	dd4080e7          	jalr	-556(ra) # 53aa <open>
    45de:	00001097          	auipc	ra,0x1
    45e2:	db4080e7          	jalr	-588(ra) # 5392 <close>
      close(open(file, 0));
    45e6:	4581                	li	a1,0
    45e8:	fa840513          	addi	a0,s0,-88
    45ec:	00001097          	auipc	ra,0x1
    45f0:	dbe080e7          	jalr	-578(ra) # 53aa <open>
    45f4:	00001097          	auipc	ra,0x1
    45f8:	d9e080e7          	jalr	-610(ra) # 5392 <close>
      close(open(file, 0));
    45fc:	4581                	li	a1,0
    45fe:	fa840513          	addi	a0,s0,-88
    4602:	00001097          	auipc	ra,0x1
    4606:	da8080e7          	jalr	-600(ra) # 53aa <open>
    460a:	00001097          	auipc	ra,0x1
    460e:	d88080e7          	jalr	-632(ra) # 5392 <close>
      close(open(file, 0));
    4612:	4581                	li	a1,0
    4614:	fa840513          	addi	a0,s0,-88
    4618:	00001097          	auipc	ra,0x1
    461c:	d92080e7          	jalr	-622(ra) # 53aa <open>
    4620:	00001097          	auipc	ra,0x1
    4624:	d72080e7          	jalr	-654(ra) # 5392 <close>
      close(open(file, 0));
    4628:	4581                	li	a1,0
    462a:	fa840513          	addi	a0,s0,-88
    462e:	00001097          	auipc	ra,0x1
    4632:	d7c080e7          	jalr	-644(ra) # 53aa <open>
    4636:	00001097          	auipc	ra,0x1
    463a:	d5c080e7          	jalr	-676(ra) # 5392 <close>
    if(pid == 0)
    463e:	08090363          	beqz	s2,46c4 <concreate+0x2d2>
      wait(0);
    4642:	4501                	li	a0,0
    4644:	00001097          	auipc	ra,0x1
    4648:	d2e080e7          	jalr	-722(ra) # 5372 <wait>
  for(i = 0; i < N; i++){
    464c:	2485                	addiw	s1,s1,1
    464e:	0f448563          	beq	s1,s4,4738 <concreate+0x346>
    file[1] = '0' + i;
    4652:	0304879b          	addiw	a5,s1,48
    4656:	faf404a3          	sb	a5,-87(s0)
    pid = fork();
    465a:	00001097          	auipc	ra,0x1
    465e:	d08080e7          	jalr	-760(ra) # 5362 <fork>
    4662:	892a                	mv	s2,a0
    if(pid < 0){
    4664:	f2054de3          	bltz	a0,459e <concreate+0x1ac>
    if(((i % 3) == 0 && pid == 0) ||
    4668:	0354e73b          	remw	a4,s1,s5
    466c:	00a767b3          	or	a5,a4,a0
    4670:	2781                	sext.w	a5,a5
    4672:	d7a1                	beqz	a5,45ba <concreate+0x1c8>
    4674:	01671363          	bne	a4,s6,467a <concreate+0x288>
       ((i % 3) == 1 && pid != 0)){
    4678:	f129                	bnez	a0,45ba <concreate+0x1c8>
      unlink(file);
    467a:	fa840513          	addi	a0,s0,-88
    467e:	00001097          	auipc	ra,0x1
    4682:	d3c080e7          	jalr	-708(ra) # 53ba <unlink>
      unlink(file);
    4686:	fa840513          	addi	a0,s0,-88
    468a:	00001097          	auipc	ra,0x1
    468e:	d30080e7          	jalr	-720(ra) # 53ba <unlink>
      unlink(file);
    4692:	fa840513          	addi	a0,s0,-88
    4696:	00001097          	auipc	ra,0x1
    469a:	d24080e7          	jalr	-732(ra) # 53ba <unlink>
      unlink(file);
    469e:	fa840513          	addi	a0,s0,-88
    46a2:	00001097          	auipc	ra,0x1
    46a6:	d18080e7          	jalr	-744(ra) # 53ba <unlink>
      unlink(file);
    46aa:	fa840513          	addi	a0,s0,-88
    46ae:	00001097          	auipc	ra,0x1
    46b2:	d0c080e7          	jalr	-756(ra) # 53ba <unlink>
      unlink(file);
    46b6:	fa840513          	addi	a0,s0,-88
    46ba:	00001097          	auipc	ra,0x1
    46be:	d00080e7          	jalr	-768(ra) # 53ba <unlink>
    46c2:	bfb5                	j	463e <concreate+0x24c>
      exit(0);
    46c4:	4501                	li	a0,0
    46c6:	00001097          	auipc	ra,0x1
    46ca:	ca4080e7          	jalr	-860(ra) # 536a <exit>
      close(fd);
    46ce:	00001097          	auipc	ra,0x1
    46d2:	cc4080e7          	jalr	-828(ra) # 5392 <close>
    if(pid == 0) {
    46d6:	bb5d                	j	448c <concreate+0x9a>
      close(fd);
    46d8:	00001097          	auipc	ra,0x1
    46dc:	cba080e7          	jalr	-838(ra) # 5392 <close>
      wait(&xstatus);
    46e0:	f6c40513          	addi	a0,s0,-148
    46e4:	00001097          	auipc	ra,0x1
    46e8:	c8e080e7          	jalr	-882(ra) # 5372 <wait>
      if(xstatus != 0)
    46ec:	f6c42483          	lw	s1,-148(s0)
    46f0:	da0493e3          	bnez	s1,4496 <concreate+0xa4>
  for(i = 0; i < N; i++){
    46f4:	2905                	addiw	s2,s2,1
    46f6:	db4905e3          	beq	s2,s4,44a0 <concreate+0xae>
    file[1] = '0' + i;
    46fa:	0309079b          	addiw	a5,s2,48
    46fe:	faf404a3          	sb	a5,-87(s0)
    unlink(file);
    4702:	fa840513          	addi	a0,s0,-88
    4706:	00001097          	auipc	ra,0x1
    470a:	cb4080e7          	jalr	-844(ra) # 53ba <unlink>
    pid = fork();
    470e:	00001097          	auipc	ra,0x1
    4712:	c54080e7          	jalr	-940(ra) # 5362 <fork>
    if(pid && (i % 3) == 1){
    4716:	d20502e3          	beqz	a0,443a <concreate+0x48>
    471a:	036967bb          	remw	a5,s2,s6
    471e:	d15786e3          	beq	a5,s5,442a <concreate+0x38>
      fd = open(file, O_CREATE | O_RDWR);
    4722:	20200593          	li	a1,514
    4726:	fa840513          	addi	a0,s0,-88
    472a:	00001097          	auipc	ra,0x1
    472e:	c80080e7          	jalr	-896(ra) # 53aa <open>
      if(fd < 0){
    4732:	fa0553e3          	bgez	a0,46d8 <concreate+0x2e6>
    4736:	b315                	j	445a <concreate+0x68>
}
    4738:	60ea                	ld	ra,152(sp)
    473a:	644a                	ld	s0,144(sp)
    473c:	64aa                	ld	s1,136(sp)
    473e:	690a                	ld	s2,128(sp)
    4740:	79e6                	ld	s3,120(sp)
    4742:	7a46                	ld	s4,112(sp)
    4744:	7aa6                	ld	s5,104(sp)
    4746:	7b06                	ld	s6,96(sp)
    4748:	6be6                	ld	s7,88(sp)
    474a:	610d                	addi	sp,sp,160
    474c:	8082                	ret

000000000000474e <bigfile>:
{
    474e:	7139                	addi	sp,sp,-64
    4750:	fc06                	sd	ra,56(sp)
    4752:	f822                	sd	s0,48(sp)
    4754:	f426                	sd	s1,40(sp)
    4756:	f04a                	sd	s2,32(sp)
    4758:	ec4e                	sd	s3,24(sp)
    475a:	e852                	sd	s4,16(sp)
    475c:	e456                	sd	s5,8(sp)
    475e:	0080                	addi	s0,sp,64
    4760:	8aaa                	mv	s5,a0
  unlink("bigfile.dat");
    4762:	00003517          	auipc	a0,0x3
    4766:	d8650513          	addi	a0,a0,-634 # 74e8 <malloc+0x1d4c>
    476a:	00001097          	auipc	ra,0x1
    476e:	c50080e7          	jalr	-944(ra) # 53ba <unlink>
  fd = open("bigfile.dat", O_CREATE | O_RDWR);
    4772:	20200593          	li	a1,514
    4776:	00003517          	auipc	a0,0x3
    477a:	d7250513          	addi	a0,a0,-654 # 74e8 <malloc+0x1d4c>
    477e:	00001097          	auipc	ra,0x1
    4782:	c2c080e7          	jalr	-980(ra) # 53aa <open>
    4786:	89aa                	mv	s3,a0
  for(i = 0; i < N; i++){
    4788:	4481                	li	s1,0
    memset(buf, i, SZ);
    478a:	00007917          	auipc	s2,0x7
    478e:	ff690913          	addi	s2,s2,-10 # b780 <buf>
  for(i = 0; i < N; i++){
    4792:	4a51                	li	s4,20
  if(fd < 0){
    4794:	0a054063          	bltz	a0,4834 <bigfile+0xe6>
    memset(buf, i, SZ);
    4798:	25800613          	li	a2,600
    479c:	85a6                	mv	a1,s1
    479e:	854a                	mv	a0,s2
    47a0:	00001097          	auipc	ra,0x1
    47a4:	9d0080e7          	jalr	-1584(ra) # 5170 <memset>
    if(write(fd, buf, SZ) != SZ){
    47a8:	25800613          	li	a2,600
    47ac:	85ca                	mv	a1,s2
    47ae:	854e                	mv	a0,s3
    47b0:	00001097          	auipc	ra,0x1
    47b4:	bda080e7          	jalr	-1062(ra) # 538a <write>
    47b8:	25800793          	li	a5,600
    47bc:	08f51a63          	bne	a0,a5,4850 <bigfile+0x102>
  for(i = 0; i < N; i++){
    47c0:	2485                	addiw	s1,s1,1
    47c2:	fd449be3          	bne	s1,s4,4798 <bigfile+0x4a>
  close(fd);
    47c6:	854e                	mv	a0,s3
    47c8:	00001097          	auipc	ra,0x1
    47cc:	bca080e7          	jalr	-1078(ra) # 5392 <close>
  fd = open("bigfile.dat", 0);
    47d0:	4581                	li	a1,0
    47d2:	00003517          	auipc	a0,0x3
    47d6:	d1650513          	addi	a0,a0,-746 # 74e8 <malloc+0x1d4c>
    47da:	00001097          	auipc	ra,0x1
    47de:	bd0080e7          	jalr	-1072(ra) # 53aa <open>
    47e2:	8a2a                	mv	s4,a0
  total = 0;
    47e4:	4981                	li	s3,0
  for(i = 0; ; i++){
    47e6:	4481                	li	s1,0
    cc = read(fd, buf, SZ/2);
    47e8:	00007917          	auipc	s2,0x7
    47ec:	f9890913          	addi	s2,s2,-104 # b780 <buf>
  if(fd < 0){
    47f0:	06054e63          	bltz	a0,486c <bigfile+0x11e>
    cc = read(fd, buf, SZ/2);
    47f4:	12c00613          	li	a2,300
    47f8:	85ca                	mv	a1,s2
    47fa:	8552                	mv	a0,s4
    47fc:	00001097          	auipc	ra,0x1
    4800:	b86080e7          	jalr	-1146(ra) # 5382 <read>
    if(cc < 0){
    4804:	08054263          	bltz	a0,4888 <bigfile+0x13a>
    if(cc == 0)
    4808:	c971                	beqz	a0,48dc <bigfile+0x18e>
    if(cc != SZ/2){
    480a:	12c00793          	li	a5,300
    480e:	08f51b63          	bne	a0,a5,48a4 <bigfile+0x156>
    if(buf[0] != i/2 || buf[SZ/2-1] != i/2){
    4812:	01f4d79b          	srliw	a5,s1,0x1f
    4816:	9fa5                	addw	a5,a5,s1
    4818:	4017d79b          	sraiw	a5,a5,0x1
    481c:	00094703          	lbu	a4,0(s2)
    4820:	0af71063          	bne	a4,a5,48c0 <bigfile+0x172>
    4824:	12b94703          	lbu	a4,299(s2)
    4828:	08f71c63          	bne	a4,a5,48c0 <bigfile+0x172>
    total += cc;
    482c:	12c9899b          	addiw	s3,s3,300
  for(i = 0; ; i++){
    4830:	2485                	addiw	s1,s1,1
    cc = read(fd, buf, SZ/2);
    4832:	b7c9                	j	47f4 <bigfile+0xa6>
    printf("%s: cannot create bigfile", s);
    4834:	85d6                	mv	a1,s5
    4836:	00003517          	auipc	a0,0x3
    483a:	cc250513          	addi	a0,a0,-830 # 74f8 <malloc+0x1d5c>
    483e:	00001097          	auipc	ra,0x1
    4842:	ea6080e7          	jalr	-346(ra) # 56e4 <printf>
    exit(1);
    4846:	4505                	li	a0,1
    4848:	00001097          	auipc	ra,0x1
    484c:	b22080e7          	jalr	-1246(ra) # 536a <exit>
      printf("%s: write bigfile failed\n", s);
    4850:	85d6                	mv	a1,s5
    4852:	00003517          	auipc	a0,0x3
    4856:	cc650513          	addi	a0,a0,-826 # 7518 <malloc+0x1d7c>
    485a:	00001097          	auipc	ra,0x1
    485e:	e8a080e7          	jalr	-374(ra) # 56e4 <printf>
      exit(1);
    4862:	4505                	li	a0,1
    4864:	00001097          	auipc	ra,0x1
    4868:	b06080e7          	jalr	-1274(ra) # 536a <exit>
    printf("%s: cannot open bigfile\n", s);
    486c:	85d6                	mv	a1,s5
    486e:	00003517          	auipc	a0,0x3
    4872:	cca50513          	addi	a0,a0,-822 # 7538 <malloc+0x1d9c>
    4876:	00001097          	auipc	ra,0x1
    487a:	e6e080e7          	jalr	-402(ra) # 56e4 <printf>
    exit(1);
    487e:	4505                	li	a0,1
    4880:	00001097          	auipc	ra,0x1
    4884:	aea080e7          	jalr	-1302(ra) # 536a <exit>
      printf("%s: read bigfile failed\n", s);
    4888:	85d6                	mv	a1,s5
    488a:	00003517          	auipc	a0,0x3
    488e:	cce50513          	addi	a0,a0,-818 # 7558 <malloc+0x1dbc>
    4892:	00001097          	auipc	ra,0x1
    4896:	e52080e7          	jalr	-430(ra) # 56e4 <printf>
      exit(1);
    489a:	4505                	li	a0,1
    489c:	00001097          	auipc	ra,0x1
    48a0:	ace080e7          	jalr	-1330(ra) # 536a <exit>
      printf("%s: short read bigfile\n", s);
    48a4:	85d6                	mv	a1,s5
    48a6:	00003517          	auipc	a0,0x3
    48aa:	cd250513          	addi	a0,a0,-814 # 7578 <malloc+0x1ddc>
    48ae:	00001097          	auipc	ra,0x1
    48b2:	e36080e7          	jalr	-458(ra) # 56e4 <printf>
      exit(1);
    48b6:	4505                	li	a0,1
    48b8:	00001097          	auipc	ra,0x1
    48bc:	ab2080e7          	jalr	-1358(ra) # 536a <exit>
      printf("%s: read bigfile wrong data\n", s);
    48c0:	85d6                	mv	a1,s5
    48c2:	00003517          	auipc	a0,0x3
    48c6:	cce50513          	addi	a0,a0,-818 # 7590 <malloc+0x1df4>
    48ca:	00001097          	auipc	ra,0x1
    48ce:	e1a080e7          	jalr	-486(ra) # 56e4 <printf>
      exit(1);
    48d2:	4505                	li	a0,1
    48d4:	00001097          	auipc	ra,0x1
    48d8:	a96080e7          	jalr	-1386(ra) # 536a <exit>
  close(fd);
    48dc:	8552                	mv	a0,s4
    48de:	00001097          	auipc	ra,0x1
    48e2:	ab4080e7          	jalr	-1356(ra) # 5392 <close>
  if(total != N*SZ){
    48e6:	678d                	lui	a5,0x3
    48e8:	ee078793          	addi	a5,a5,-288 # 2ee0 <subdir+0x20a>
    48ec:	02f99363          	bne	s3,a5,4912 <bigfile+0x1c4>
  unlink("bigfile.dat");
    48f0:	00003517          	auipc	a0,0x3
    48f4:	bf850513          	addi	a0,a0,-1032 # 74e8 <malloc+0x1d4c>
    48f8:	00001097          	auipc	ra,0x1
    48fc:	ac2080e7          	jalr	-1342(ra) # 53ba <unlink>
}
    4900:	70e2                	ld	ra,56(sp)
    4902:	7442                	ld	s0,48(sp)
    4904:	74a2                	ld	s1,40(sp)
    4906:	7902                	ld	s2,32(sp)
    4908:	69e2                	ld	s3,24(sp)
    490a:	6a42                	ld	s4,16(sp)
    490c:	6aa2                	ld	s5,8(sp)
    490e:	6121                	addi	sp,sp,64
    4910:	8082                	ret
    printf("%s: read bigfile wrong total\n", s);
    4912:	85d6                	mv	a1,s5
    4914:	00003517          	auipc	a0,0x3
    4918:	c9c50513          	addi	a0,a0,-868 # 75b0 <malloc+0x1e14>
    491c:	00001097          	auipc	ra,0x1
    4920:	dc8080e7          	jalr	-568(ra) # 56e4 <printf>
    exit(1);
    4924:	4505                	li	a0,1
    4926:	00001097          	auipc	ra,0x1
    492a:	a44080e7          	jalr	-1468(ra) # 536a <exit>

000000000000492e <dirtest>:
{
    492e:	1101                	addi	sp,sp,-32
    4930:	ec06                	sd	ra,24(sp)
    4932:	e822                	sd	s0,16(sp)
    4934:	e426                	sd	s1,8(sp)
    4936:	1000                	addi	s0,sp,32
    4938:	84aa                	mv	s1,a0
  printf("mkdir test\n");
    493a:	00003517          	auipc	a0,0x3
    493e:	c9650513          	addi	a0,a0,-874 # 75d0 <malloc+0x1e34>
    4942:	00001097          	auipc	ra,0x1
    4946:	da2080e7          	jalr	-606(ra) # 56e4 <printf>
  if(mkdir("dir0") < 0){
    494a:	00003517          	auipc	a0,0x3
    494e:	c9650513          	addi	a0,a0,-874 # 75e0 <malloc+0x1e44>
    4952:	00001097          	auipc	ra,0x1
    4956:	a80080e7          	jalr	-1408(ra) # 53d2 <mkdir>
    495a:	04054d63          	bltz	a0,49b4 <dirtest+0x86>
  if(chdir("dir0") < 0){
    495e:	00003517          	auipc	a0,0x3
    4962:	c8250513          	addi	a0,a0,-894 # 75e0 <malloc+0x1e44>
    4966:	00001097          	auipc	ra,0x1
    496a:	a74080e7          	jalr	-1420(ra) # 53da <chdir>
    496e:	06054163          	bltz	a0,49d0 <dirtest+0xa2>
  if(chdir("..") < 0){
    4972:	00002517          	auipc	a0,0x2
    4976:	68e50513          	addi	a0,a0,1678 # 7000 <malloc+0x1864>
    497a:	00001097          	auipc	ra,0x1
    497e:	a60080e7          	jalr	-1440(ra) # 53da <chdir>
    4982:	06054563          	bltz	a0,49ec <dirtest+0xbe>
  if(unlink("dir0") < 0){
    4986:	00003517          	auipc	a0,0x3
    498a:	c5a50513          	addi	a0,a0,-934 # 75e0 <malloc+0x1e44>
    498e:	00001097          	auipc	ra,0x1
    4992:	a2c080e7          	jalr	-1492(ra) # 53ba <unlink>
    4996:	06054963          	bltz	a0,4a08 <dirtest+0xda>
  printf("%s: mkdir test ok\n");
    499a:	00003517          	auipc	a0,0x3
    499e:	c9650513          	addi	a0,a0,-874 # 7630 <malloc+0x1e94>
    49a2:	00001097          	auipc	ra,0x1
    49a6:	d42080e7          	jalr	-702(ra) # 56e4 <printf>
}
    49aa:	60e2                	ld	ra,24(sp)
    49ac:	6442                	ld	s0,16(sp)
    49ae:	64a2                	ld	s1,8(sp)
    49b0:	6105                	addi	sp,sp,32
    49b2:	8082                	ret
    printf("%s: mkdir failed\n", s);
    49b4:	85a6                	mv	a1,s1
    49b6:	00002517          	auipc	a0,0x2
    49ba:	fea50513          	addi	a0,a0,-22 # 69a0 <malloc+0x1204>
    49be:	00001097          	auipc	ra,0x1
    49c2:	d26080e7          	jalr	-730(ra) # 56e4 <printf>
    exit(1);
    49c6:	4505                	li	a0,1
    49c8:	00001097          	auipc	ra,0x1
    49cc:	9a2080e7          	jalr	-1630(ra) # 536a <exit>
    printf("%s: chdir dir0 failed\n", s);
    49d0:	85a6                	mv	a1,s1
    49d2:	00003517          	auipc	a0,0x3
    49d6:	c1650513          	addi	a0,a0,-1002 # 75e8 <malloc+0x1e4c>
    49da:	00001097          	auipc	ra,0x1
    49de:	d0a080e7          	jalr	-758(ra) # 56e4 <printf>
    exit(1);
    49e2:	4505                	li	a0,1
    49e4:	00001097          	auipc	ra,0x1
    49e8:	986080e7          	jalr	-1658(ra) # 536a <exit>
    printf("%s: chdir .. failed\n", s);
    49ec:	85a6                	mv	a1,s1
    49ee:	00003517          	auipc	a0,0x3
    49f2:	c1250513          	addi	a0,a0,-1006 # 7600 <malloc+0x1e64>
    49f6:	00001097          	auipc	ra,0x1
    49fa:	cee080e7          	jalr	-786(ra) # 56e4 <printf>
    exit(1);
    49fe:	4505                	li	a0,1
    4a00:	00001097          	auipc	ra,0x1
    4a04:	96a080e7          	jalr	-1686(ra) # 536a <exit>
    printf("%s: unlink dir0 failed\n", s);
    4a08:	85a6                	mv	a1,s1
    4a0a:	00003517          	auipc	a0,0x3
    4a0e:	c0e50513          	addi	a0,a0,-1010 # 7618 <malloc+0x1e7c>
    4a12:	00001097          	auipc	ra,0x1
    4a16:	cd2080e7          	jalr	-814(ra) # 56e4 <printf>
    exit(1);
    4a1a:	4505                	li	a0,1
    4a1c:	00001097          	auipc	ra,0x1
    4a20:	94e080e7          	jalr	-1714(ra) # 536a <exit>

0000000000004a24 <fsfull>:
{
    4a24:	7171                	addi	sp,sp,-176
    4a26:	f506                	sd	ra,168(sp)
    4a28:	f122                	sd	s0,160(sp)
    4a2a:	ed26                	sd	s1,152(sp)
    4a2c:	e94a                	sd	s2,144(sp)
    4a2e:	e54e                	sd	s3,136(sp)
    4a30:	e152                	sd	s4,128(sp)
    4a32:	fcd6                	sd	s5,120(sp)
    4a34:	f8da                	sd	s6,112(sp)
    4a36:	f4de                	sd	s7,104(sp)
    4a38:	f0e2                	sd	s8,96(sp)
    4a3a:	ece6                	sd	s9,88(sp)
    4a3c:	e8ea                	sd	s10,80(sp)
    4a3e:	e4ee                	sd	s11,72(sp)
    4a40:	1900                	addi	s0,sp,176
  printf("fsfull test\n");
    4a42:	00003517          	auipc	a0,0x3
    4a46:	c0650513          	addi	a0,a0,-1018 # 7648 <malloc+0x1eac>
    4a4a:	00001097          	auipc	ra,0x1
    4a4e:	c9a080e7          	jalr	-870(ra) # 56e4 <printf>
  for(nfiles = 0; ; nfiles++){
    4a52:	4481                	li	s1,0
    name[0] = 'f';
    4a54:	06600d13          	li	s10,102
    name[1] = '0' + nfiles / 1000;
    4a58:	3e800c13          	li	s8,1000
    name[2] = '0' + (nfiles % 1000) / 100;
    4a5c:	06400b93          	li	s7,100
    name[3] = '0' + (nfiles % 100) / 10;
    4a60:	4b29                	li	s6,10
    printf("%s: writing %s\n", name);
    4a62:	00003c97          	auipc	s9,0x3
    4a66:	bf6c8c93          	addi	s9,s9,-1034 # 7658 <malloc+0x1ebc>
    int total = 0;
    4a6a:	4d81                	li	s11,0
      int cc = write(fd, buf, BSIZE);
    4a6c:	00007a17          	auipc	s4,0x7
    4a70:	d14a0a13          	addi	s4,s4,-748 # b780 <buf>
    name[0] = 'f';
    4a74:	f5a40823          	sb	s10,-176(s0)
    name[1] = '0' + nfiles / 1000;
    4a78:	0384c7bb          	divw	a5,s1,s8
    4a7c:	0307879b          	addiw	a5,a5,48
    4a80:	f4f408a3          	sb	a5,-175(s0)
    name[2] = '0' + (nfiles % 1000) / 100;
    4a84:	0384e7bb          	remw	a5,s1,s8
    4a88:	0377c7bb          	divw	a5,a5,s7
    4a8c:	0307879b          	addiw	a5,a5,48
    4a90:	f4f40923          	sb	a5,-174(s0)
    name[3] = '0' + (nfiles % 100) / 10;
    4a94:	0374e7bb          	remw	a5,s1,s7
    4a98:	0367c7bb          	divw	a5,a5,s6
    4a9c:	0307879b          	addiw	a5,a5,48
    4aa0:	f4f409a3          	sb	a5,-173(s0)
    name[4] = '0' + (nfiles % 10);
    4aa4:	0364e7bb          	remw	a5,s1,s6
    4aa8:	0307879b          	addiw	a5,a5,48
    4aac:	f4f40a23          	sb	a5,-172(s0)
    name[5] = '\0';
    4ab0:	f4040aa3          	sb	zero,-171(s0)
    printf("%s: writing %s\n", name);
    4ab4:	f5040593          	addi	a1,s0,-176
    4ab8:	8566                	mv	a0,s9
    4aba:	00001097          	auipc	ra,0x1
    4abe:	c2a080e7          	jalr	-982(ra) # 56e4 <printf>
    int fd = open(name, O_CREATE|O_RDWR);
    4ac2:	20200593          	li	a1,514
    4ac6:	f5040513          	addi	a0,s0,-176
    4aca:	00001097          	auipc	ra,0x1
    4ace:	8e0080e7          	jalr	-1824(ra) # 53aa <open>
    4ad2:	892a                	mv	s2,a0
    if(fd < 0){
    4ad4:	0a055663          	bgez	a0,4b80 <fsfull+0x15c>
      printf("%s: open %s failed\n", name);
    4ad8:	f5040593          	addi	a1,s0,-176
    4adc:	00003517          	auipc	a0,0x3
    4ae0:	b8c50513          	addi	a0,a0,-1140 # 7668 <malloc+0x1ecc>
    4ae4:	00001097          	auipc	ra,0x1
    4ae8:	c00080e7          	jalr	-1024(ra) # 56e4 <printf>
  while(nfiles >= 0){
    4aec:	0604c363          	bltz	s1,4b52 <fsfull+0x12e>
    name[0] = 'f';
    4af0:	06600b13          	li	s6,102
    name[1] = '0' + nfiles / 1000;
    4af4:	3e800a13          	li	s4,1000
    name[2] = '0' + (nfiles % 1000) / 100;
    4af8:	06400993          	li	s3,100
    name[3] = '0' + (nfiles % 100) / 10;
    4afc:	4929                	li	s2,10
  while(nfiles >= 0){
    4afe:	5afd                	li	s5,-1
    name[0] = 'f';
    4b00:	f5640823          	sb	s6,-176(s0)
    name[1] = '0' + nfiles / 1000;
    4b04:	0344c7bb          	divw	a5,s1,s4
    4b08:	0307879b          	addiw	a5,a5,48
    4b0c:	f4f408a3          	sb	a5,-175(s0)
    name[2] = '0' + (nfiles % 1000) / 100;
    4b10:	0344e7bb          	remw	a5,s1,s4
    4b14:	0337c7bb          	divw	a5,a5,s3
    4b18:	0307879b          	addiw	a5,a5,48
    4b1c:	f4f40923          	sb	a5,-174(s0)
    name[3] = '0' + (nfiles % 100) / 10;
    4b20:	0334e7bb          	remw	a5,s1,s3
    4b24:	0327c7bb          	divw	a5,a5,s2
    4b28:	0307879b          	addiw	a5,a5,48
    4b2c:	f4f409a3          	sb	a5,-173(s0)
    name[4] = '0' + (nfiles % 10);
    4b30:	0324e7bb          	remw	a5,s1,s2
    4b34:	0307879b          	addiw	a5,a5,48
    4b38:	f4f40a23          	sb	a5,-172(s0)
    name[5] = '\0';
    4b3c:	f4040aa3          	sb	zero,-171(s0)
    unlink(name);
    4b40:	f5040513          	addi	a0,s0,-176
    4b44:	00001097          	auipc	ra,0x1
    4b48:	876080e7          	jalr	-1930(ra) # 53ba <unlink>
    nfiles--;
    4b4c:	34fd                	addiw	s1,s1,-1
  while(nfiles >= 0){
    4b4e:	fb5499e3          	bne	s1,s5,4b00 <fsfull+0xdc>
  printf("fsfull test finished\n");
    4b52:	00003517          	auipc	a0,0x3
    4b56:	b4650513          	addi	a0,a0,-1210 # 7698 <malloc+0x1efc>
    4b5a:	00001097          	auipc	ra,0x1
    4b5e:	b8a080e7          	jalr	-1142(ra) # 56e4 <printf>
}
    4b62:	70aa                	ld	ra,168(sp)
    4b64:	740a                	ld	s0,160(sp)
    4b66:	64ea                	ld	s1,152(sp)
    4b68:	694a                	ld	s2,144(sp)
    4b6a:	69aa                	ld	s3,136(sp)
    4b6c:	6a0a                	ld	s4,128(sp)
    4b6e:	7ae6                	ld	s5,120(sp)
    4b70:	7b46                	ld	s6,112(sp)
    4b72:	7ba6                	ld	s7,104(sp)
    4b74:	7c06                	ld	s8,96(sp)
    4b76:	6ce6                	ld	s9,88(sp)
    4b78:	6d46                	ld	s10,80(sp)
    4b7a:	6da6                	ld	s11,72(sp)
    4b7c:	614d                	addi	sp,sp,176
    4b7e:	8082                	ret
    int total = 0;
    4b80:	89ee                	mv	s3,s11
      if(cc < BSIZE)
    4b82:	3ff00a93          	li	s5,1023
      int cc = write(fd, buf, BSIZE);
    4b86:	40000613          	li	a2,1024
    4b8a:	85d2                	mv	a1,s4
    4b8c:	854a                	mv	a0,s2
    4b8e:	00000097          	auipc	ra,0x0
    4b92:	7fc080e7          	jalr	2044(ra) # 538a <write>
      if(cc < BSIZE)
    4b96:	00aad563          	bge	s5,a0,4ba0 <fsfull+0x17c>
      total += cc;
    4b9a:	00a989bb          	addw	s3,s3,a0
    while(1){
    4b9e:	b7e5                	j	4b86 <fsfull+0x162>
    printf("%s: wrote %d bytes\n", total);
    4ba0:	85ce                	mv	a1,s3
    4ba2:	00003517          	auipc	a0,0x3
    4ba6:	ade50513          	addi	a0,a0,-1314 # 7680 <malloc+0x1ee4>
    4baa:	00001097          	auipc	ra,0x1
    4bae:	b3a080e7          	jalr	-1222(ra) # 56e4 <printf>
    close(fd);
    4bb2:	854a                	mv	a0,s2
    4bb4:	00000097          	auipc	ra,0x0
    4bb8:	7de080e7          	jalr	2014(ra) # 5392 <close>
    if(total == 0)
    4bbc:	f20988e3          	beqz	s3,4aec <fsfull+0xc8>
  for(nfiles = 0; ; nfiles++){
    4bc0:	2485                	addiw	s1,s1,1
    4bc2:	bd4d                	j	4a74 <fsfull+0x50>

0000000000004bc4 <rand>:
{
    4bc4:	1141                	addi	sp,sp,-16
    4bc6:	e422                	sd	s0,8(sp)
    4bc8:	0800                	addi	s0,sp,16
  randstate = randstate * 1664525 + 1013904223;
    4bca:	00003717          	auipc	a4,0x3
    4bce:	38670713          	addi	a4,a4,902 # 7f50 <randstate>
    4bd2:	6308                	ld	a0,0(a4)
    4bd4:	001967b7          	lui	a5,0x196
    4bd8:	60d78793          	addi	a5,a5,1549 # 19660d <__BSS_END__+0x187e7d>
    4bdc:	02f50533          	mul	a0,a0,a5
    4be0:	3c6ef7b7          	lui	a5,0x3c6ef
    4be4:	35f78793          	addi	a5,a5,863 # 3c6ef35f <__BSS_END__+0x3c6e0bcf>
    4be8:	953e                	add	a0,a0,a5
    4bea:	e308                	sd	a0,0(a4)
}
    4bec:	2501                	sext.w	a0,a0
    4bee:	6422                	ld	s0,8(sp)
    4bf0:	0141                	addi	sp,sp,16
    4bf2:	8082                	ret

0000000000004bf4 <badwrite>:
{
    4bf4:	7179                	addi	sp,sp,-48
    4bf6:	f406                	sd	ra,40(sp)
    4bf8:	f022                	sd	s0,32(sp)
    4bfa:	ec26                	sd	s1,24(sp)
    4bfc:	e84a                	sd	s2,16(sp)
    4bfe:	e44e                	sd	s3,8(sp)
    4c00:	e052                	sd	s4,0(sp)
    4c02:	1800                	addi	s0,sp,48
  unlink("junk");
    4c04:	00003517          	auipc	a0,0x3
    4c08:	aac50513          	addi	a0,a0,-1364 # 76b0 <malloc+0x1f14>
    4c0c:	00000097          	auipc	ra,0x0
    4c10:	7ae080e7          	jalr	1966(ra) # 53ba <unlink>
    4c14:	25800913          	li	s2,600
    int fd = open("junk", O_CREATE|O_WRONLY);
    4c18:	00003997          	auipc	s3,0x3
    4c1c:	a9898993          	addi	s3,s3,-1384 # 76b0 <malloc+0x1f14>
    write(fd, (char*)0xffffffffffL, 1);
    4c20:	5a7d                	li	s4,-1
    4c22:	018a5a13          	srli	s4,s4,0x18
    int fd = open("junk", O_CREATE|O_WRONLY);
    4c26:	20100593          	li	a1,513
    4c2a:	854e                	mv	a0,s3
    4c2c:	00000097          	auipc	ra,0x0
    4c30:	77e080e7          	jalr	1918(ra) # 53aa <open>
    4c34:	84aa                	mv	s1,a0
    if(fd < 0){
    4c36:	06054b63          	bltz	a0,4cac <badwrite+0xb8>
    write(fd, (char*)0xffffffffffL, 1);
    4c3a:	4605                	li	a2,1
    4c3c:	85d2                	mv	a1,s4
    4c3e:	00000097          	auipc	ra,0x0
    4c42:	74c080e7          	jalr	1868(ra) # 538a <write>
    close(fd);
    4c46:	8526                	mv	a0,s1
    4c48:	00000097          	auipc	ra,0x0
    4c4c:	74a080e7          	jalr	1866(ra) # 5392 <close>
    unlink("junk");
    4c50:	854e                	mv	a0,s3
    4c52:	00000097          	auipc	ra,0x0
    4c56:	768080e7          	jalr	1896(ra) # 53ba <unlink>
  for(int i = 0; i < assumed_free; i++){
    4c5a:	397d                	addiw	s2,s2,-1
    4c5c:	fc0915e3          	bnez	s2,4c26 <badwrite+0x32>
  int fd = open("junk", O_CREATE|O_WRONLY);
    4c60:	20100593          	li	a1,513
    4c64:	00003517          	auipc	a0,0x3
    4c68:	a4c50513          	addi	a0,a0,-1460 # 76b0 <malloc+0x1f14>
    4c6c:	00000097          	auipc	ra,0x0
    4c70:	73e080e7          	jalr	1854(ra) # 53aa <open>
    4c74:	84aa                	mv	s1,a0
  if(fd < 0){
    4c76:	04054863          	bltz	a0,4cc6 <badwrite+0xd2>
  if(write(fd, "x", 1) != 1){
    4c7a:	4605                	li	a2,1
    4c7c:	00001597          	auipc	a1,0x1
    4c80:	cb458593          	addi	a1,a1,-844 # 5930 <malloc+0x194>
    4c84:	00000097          	auipc	ra,0x0
    4c88:	706080e7          	jalr	1798(ra) # 538a <write>
    4c8c:	4785                	li	a5,1
    4c8e:	04f50963          	beq	a0,a5,4ce0 <badwrite+0xec>
    printf("write failed\n");
    4c92:	00003517          	auipc	a0,0x3
    4c96:	a3e50513          	addi	a0,a0,-1474 # 76d0 <malloc+0x1f34>
    4c9a:	00001097          	auipc	ra,0x1
    4c9e:	a4a080e7          	jalr	-1462(ra) # 56e4 <printf>
    exit(1);
    4ca2:	4505                	li	a0,1
    4ca4:	00000097          	auipc	ra,0x0
    4ca8:	6c6080e7          	jalr	1734(ra) # 536a <exit>
      printf("open junk failed\n");
    4cac:	00003517          	auipc	a0,0x3
    4cb0:	a0c50513          	addi	a0,a0,-1524 # 76b8 <malloc+0x1f1c>
    4cb4:	00001097          	auipc	ra,0x1
    4cb8:	a30080e7          	jalr	-1488(ra) # 56e4 <printf>
      exit(1);
    4cbc:	4505                	li	a0,1
    4cbe:	00000097          	auipc	ra,0x0
    4cc2:	6ac080e7          	jalr	1708(ra) # 536a <exit>
    printf("open junk failed\n");
    4cc6:	00003517          	auipc	a0,0x3
    4cca:	9f250513          	addi	a0,a0,-1550 # 76b8 <malloc+0x1f1c>
    4cce:	00001097          	auipc	ra,0x1
    4cd2:	a16080e7          	jalr	-1514(ra) # 56e4 <printf>
    exit(1);
    4cd6:	4505                	li	a0,1
    4cd8:	00000097          	auipc	ra,0x0
    4cdc:	692080e7          	jalr	1682(ra) # 536a <exit>
  close(fd);
    4ce0:	8526                	mv	a0,s1
    4ce2:	00000097          	auipc	ra,0x0
    4ce6:	6b0080e7          	jalr	1712(ra) # 5392 <close>
  unlink("junk");
    4cea:	00003517          	auipc	a0,0x3
    4cee:	9c650513          	addi	a0,a0,-1594 # 76b0 <malloc+0x1f14>
    4cf2:	00000097          	auipc	ra,0x0
    4cf6:	6c8080e7          	jalr	1736(ra) # 53ba <unlink>
  exit(0);
    4cfa:	4501                	li	a0,0
    4cfc:	00000097          	auipc	ra,0x0
    4d00:	66e080e7          	jalr	1646(ra) # 536a <exit>

0000000000004d04 <countfree>:
// because out of memory with lazy allocation results in the process
// taking a fault and being killed, fork and report back.
//
int
countfree()
{
    4d04:	7139                	addi	sp,sp,-64
    4d06:	fc06                	sd	ra,56(sp)
    4d08:	f822                	sd	s0,48(sp)
    4d0a:	f426                	sd	s1,40(sp)
    4d0c:	f04a                	sd	s2,32(sp)
    4d0e:	ec4e                	sd	s3,24(sp)
    4d10:	0080                	addi	s0,sp,64
  int fds[2];

  if(pipe(fds) < 0){
    4d12:	fc840513          	addi	a0,s0,-56
    4d16:	00000097          	auipc	ra,0x0
    4d1a:	664080e7          	jalr	1636(ra) # 537a <pipe>
    4d1e:	06054763          	bltz	a0,4d8c <countfree+0x88>
    printf("pipe() failed in countfree()\n");
    exit(1);
  }
  
  int pid = fork();
    4d22:	00000097          	auipc	ra,0x0
    4d26:	640080e7          	jalr	1600(ra) # 5362 <fork>

  if(pid < 0){
    4d2a:	06054e63          	bltz	a0,4da6 <countfree+0xa2>
    printf("fork failed in countfree()\n");
    exit(1);
  }

  if(pid == 0){
    4d2e:	ed51                	bnez	a0,4dca <countfree+0xc6>
    close(fds[0]);
    4d30:	fc842503          	lw	a0,-56(s0)
    4d34:	00000097          	auipc	ra,0x0
    4d38:	65e080e7          	jalr	1630(ra) # 5392 <close>
    
    while(1){
      uint64 a = (uint64) sbrk(4096);
      if(a == 0xffffffffffffffff){
    4d3c:	597d                	li	s2,-1
        break;
      }

      // modify the memory to make sure it's really allocated.
      *(char *)(a + 4096 - 1) = 1;
    4d3e:	4485                	li	s1,1

      // report back one more page.
      if(write(fds[1], "x", 1) != 1){
    4d40:	00001997          	auipc	s3,0x1
    4d44:	bf098993          	addi	s3,s3,-1040 # 5930 <malloc+0x194>
      uint64 a = (uint64) sbrk(4096);
    4d48:	6505                	lui	a0,0x1
    4d4a:	00000097          	auipc	ra,0x0
    4d4e:	6a8080e7          	jalr	1704(ra) # 53f2 <sbrk>
      if(a == 0xffffffffffffffff){
    4d52:	07250763          	beq	a0,s2,4dc0 <countfree+0xbc>
      *(char *)(a + 4096 - 1) = 1;
    4d56:	6785                	lui	a5,0x1
    4d58:	97aa                	add	a5,a5,a0
    4d5a:	fe978fa3          	sb	s1,-1(a5) # fff <bigdir+0x97>
      if(write(fds[1], "x", 1) != 1){
    4d5e:	8626                	mv	a2,s1
    4d60:	85ce                	mv	a1,s3
    4d62:	fcc42503          	lw	a0,-52(s0)
    4d66:	00000097          	auipc	ra,0x0
    4d6a:	624080e7          	jalr	1572(ra) # 538a <write>
    4d6e:	fc950de3          	beq	a0,s1,4d48 <countfree+0x44>
        printf("write() failed in countfree()\n");
    4d72:	00003517          	auipc	a0,0x3
    4d76:	9ae50513          	addi	a0,a0,-1618 # 7720 <malloc+0x1f84>
    4d7a:	00001097          	auipc	ra,0x1
    4d7e:	96a080e7          	jalr	-1686(ra) # 56e4 <printf>
        exit(1);
    4d82:	4505                	li	a0,1
    4d84:	00000097          	auipc	ra,0x0
    4d88:	5e6080e7          	jalr	1510(ra) # 536a <exit>
    printf("pipe() failed in countfree()\n");
    4d8c:	00003517          	auipc	a0,0x3
    4d90:	95450513          	addi	a0,a0,-1708 # 76e0 <malloc+0x1f44>
    4d94:	00001097          	auipc	ra,0x1
    4d98:	950080e7          	jalr	-1712(ra) # 56e4 <printf>
    exit(1);
    4d9c:	4505                	li	a0,1
    4d9e:	00000097          	auipc	ra,0x0
    4da2:	5cc080e7          	jalr	1484(ra) # 536a <exit>
    printf("fork failed in countfree()\n");
    4da6:	00003517          	auipc	a0,0x3
    4daa:	95a50513          	addi	a0,a0,-1702 # 7700 <malloc+0x1f64>
    4dae:	00001097          	auipc	ra,0x1
    4db2:	936080e7          	jalr	-1738(ra) # 56e4 <printf>
    exit(1);
    4db6:	4505                	li	a0,1
    4db8:	00000097          	auipc	ra,0x0
    4dbc:	5b2080e7          	jalr	1458(ra) # 536a <exit>
      }
    }

    exit(0);
    4dc0:	4501                	li	a0,0
    4dc2:	00000097          	auipc	ra,0x0
    4dc6:	5a8080e7          	jalr	1448(ra) # 536a <exit>
  }

  close(fds[1]);
    4dca:	fcc42503          	lw	a0,-52(s0)
    4dce:	00000097          	auipc	ra,0x0
    4dd2:	5c4080e7          	jalr	1476(ra) # 5392 <close>

  int n = 0;
    4dd6:	4481                	li	s1,0
  while(1){
    char c;
    int cc = read(fds[0], &c, 1);
    4dd8:	4605                	li	a2,1
    4dda:	fc740593          	addi	a1,s0,-57
    4dde:	fc842503          	lw	a0,-56(s0)
    4de2:	00000097          	auipc	ra,0x0
    4de6:	5a0080e7          	jalr	1440(ra) # 5382 <read>
    if(cc < 0){
    4dea:	00054563          	bltz	a0,4df4 <countfree+0xf0>
      printf("read() failed in countfree()\n");
      exit(1);
    }
    if(cc == 0)
    4dee:	c105                	beqz	a0,4e0e <countfree+0x10a>
      break;
    n += 1;
    4df0:	2485                	addiw	s1,s1,1
  while(1){
    4df2:	b7dd                	j	4dd8 <countfree+0xd4>
      printf("read() failed in countfree()\n");
    4df4:	00003517          	auipc	a0,0x3
    4df8:	94c50513          	addi	a0,a0,-1716 # 7740 <malloc+0x1fa4>
    4dfc:	00001097          	auipc	ra,0x1
    4e00:	8e8080e7          	jalr	-1816(ra) # 56e4 <printf>
      exit(1);
    4e04:	4505                	li	a0,1
    4e06:	00000097          	auipc	ra,0x0
    4e0a:	564080e7          	jalr	1380(ra) # 536a <exit>
  }

  close(fds[0]);
    4e0e:	fc842503          	lw	a0,-56(s0)
    4e12:	00000097          	auipc	ra,0x0
    4e16:	580080e7          	jalr	1408(ra) # 5392 <close>
  wait((int*)0);
    4e1a:	4501                	li	a0,0
    4e1c:	00000097          	auipc	ra,0x0
    4e20:	556080e7          	jalr	1366(ra) # 5372 <wait>
  
  return n;
}
    4e24:	8526                	mv	a0,s1
    4e26:	70e2                	ld	ra,56(sp)
    4e28:	7442                	ld	s0,48(sp)
    4e2a:	74a2                	ld	s1,40(sp)
    4e2c:	7902                	ld	s2,32(sp)
    4e2e:	69e2                	ld	s3,24(sp)
    4e30:	6121                	addi	sp,sp,64
    4e32:	8082                	ret

0000000000004e34 <run>:

// run each test in its own process. run returns 1 if child's exit()
// indicates success.
int
run(void f(char *), char *s) {
    4e34:	7179                	addi	sp,sp,-48
    4e36:	f406                	sd	ra,40(sp)
    4e38:	f022                	sd	s0,32(sp)
    4e3a:	ec26                	sd	s1,24(sp)
    4e3c:	e84a                	sd	s2,16(sp)
    4e3e:	1800                	addi	s0,sp,48
    4e40:	84aa                	mv	s1,a0
    4e42:	892e                	mv	s2,a1
  int pid;
  int xstatus;

  printf("test %s: ", s);
    4e44:	00003517          	auipc	a0,0x3
    4e48:	91c50513          	addi	a0,a0,-1764 # 7760 <malloc+0x1fc4>
    4e4c:	00001097          	auipc	ra,0x1
    4e50:	898080e7          	jalr	-1896(ra) # 56e4 <printf>
  if((pid = fork()) < 0) {
    4e54:	00000097          	auipc	ra,0x0
    4e58:	50e080e7          	jalr	1294(ra) # 5362 <fork>
    4e5c:	02054e63          	bltz	a0,4e98 <run+0x64>
    printf("runtest: fork error\n");
    exit(1);
  }
  if(pid == 0) {
    4e60:	c929                	beqz	a0,4eb2 <run+0x7e>
    f(s);
    exit(0);
  } else {
    wait(&xstatus);
    4e62:	fdc40513          	addi	a0,s0,-36
    4e66:	00000097          	auipc	ra,0x0
    4e6a:	50c080e7          	jalr	1292(ra) # 5372 <wait>
    if(xstatus != 0) 
    4e6e:	fdc42783          	lw	a5,-36(s0)
    4e72:	c7b9                	beqz	a5,4ec0 <run+0x8c>
      printf("FAILED\n");
    4e74:	00003517          	auipc	a0,0x3
    4e78:	91450513          	addi	a0,a0,-1772 # 7788 <malloc+0x1fec>
    4e7c:	00001097          	auipc	ra,0x1
    4e80:	868080e7          	jalr	-1944(ra) # 56e4 <printf>
    else
      printf("OK\n");
    return xstatus == 0;
    4e84:	fdc42503          	lw	a0,-36(s0)
  }
}
    4e88:	00153513          	seqz	a0,a0
    4e8c:	70a2                	ld	ra,40(sp)
    4e8e:	7402                	ld	s0,32(sp)
    4e90:	64e2                	ld	s1,24(sp)
    4e92:	6942                	ld	s2,16(sp)
    4e94:	6145                	addi	sp,sp,48
    4e96:	8082                	ret
    printf("runtest: fork error\n");
    4e98:	00003517          	auipc	a0,0x3
    4e9c:	8d850513          	addi	a0,a0,-1832 # 7770 <malloc+0x1fd4>
    4ea0:	00001097          	auipc	ra,0x1
    4ea4:	844080e7          	jalr	-1980(ra) # 56e4 <printf>
    exit(1);
    4ea8:	4505                	li	a0,1
    4eaa:	00000097          	auipc	ra,0x0
    4eae:	4c0080e7          	jalr	1216(ra) # 536a <exit>
    f(s);
    4eb2:	854a                	mv	a0,s2
    4eb4:	9482                	jalr	s1
    exit(0);
    4eb6:	4501                	li	a0,0
    4eb8:	00000097          	auipc	ra,0x0
    4ebc:	4b2080e7          	jalr	1202(ra) # 536a <exit>
      printf("OK\n");
    4ec0:	00003517          	auipc	a0,0x3
    4ec4:	8d050513          	addi	a0,a0,-1840 # 7790 <malloc+0x1ff4>
    4ec8:	00001097          	auipc	ra,0x1
    4ecc:	81c080e7          	jalr	-2020(ra) # 56e4 <printf>
    4ed0:	bf55                	j	4e84 <run+0x50>

0000000000004ed2 <main>:

int
main(int argc, char *argv[])
{
    4ed2:	c4010113          	addi	sp,sp,-960
    4ed6:	3a113c23          	sd	ra,952(sp)
    4eda:	3a813823          	sd	s0,944(sp)
    4ede:	3a913423          	sd	s1,936(sp)
    4ee2:	3b213023          	sd	s2,928(sp)
    4ee6:	39313c23          	sd	s3,920(sp)
    4eea:	39413823          	sd	s4,912(sp)
    4eee:	39513423          	sd	s5,904(sp)
    4ef2:	39613023          	sd	s6,896(sp)
    4ef6:	0780                	addi	s0,sp,960
    4ef8:	89aa                	mv	s3,a0
  int continuous = 0;
  char *justone = 0;

  if(argc == 2 && strcmp(argv[1], "-c") == 0){
    4efa:	4789                	li	a5,2
    4efc:	08f50763          	beq	a0,a5,4f8a <main+0xb8>
    continuous = 1;
  } else if(argc == 2 && strcmp(argv[1], "-C") == 0){
    continuous = 2;
  } else if(argc == 2 && argv[1][0] != '-'){
    justone = argv[1];
  } else if(argc > 1){
    4f00:	4785                	li	a5,1
  char *justone = 0;
    4f02:	4901                	li	s2,0
  } else if(argc > 1){
    4f04:	0ca7c163          	blt	a5,a0,4fc6 <main+0xf4>
  }
  
  struct test {
    void (*f)(char *);
    char *s;
  } tests[] = {
    4f08:	00003797          	auipc	a5,0x3
    4f0c:	c4878793          	addi	a5,a5,-952 # 7b50 <malloc+0x23b4>
    4f10:	c4040713          	addi	a4,s0,-960
    4f14:	00003817          	auipc	a6,0x3
    4f18:	fbc80813          	addi	a6,a6,-68 # 7ed0 <malloc+0x2734>
    4f1c:	6388                	ld	a0,0(a5)
    4f1e:	678c                	ld	a1,8(a5)
    4f20:	6b90                	ld	a2,16(a5)
    4f22:	6f94                	ld	a3,24(a5)
    4f24:	e308                	sd	a0,0(a4)
    4f26:	e70c                	sd	a1,8(a4)
    4f28:	eb10                	sd	a2,16(a4)
    4f2a:	ef14                	sd	a3,24(a4)
    4f2c:	02078793          	addi	a5,a5,32
    4f30:	02070713          	addi	a4,a4,32
    4f34:	ff0794e3          	bne	a5,a6,4f1c <main+0x4a>
          exit(1);
      }
    }
  }

  printf("usertests starting\n");
    4f38:	00003517          	auipc	a0,0x3
    4f3c:	91050513          	addi	a0,a0,-1776 # 7848 <malloc+0x20ac>
    4f40:	00000097          	auipc	ra,0x0
    4f44:	7a4080e7          	jalr	1956(ra) # 56e4 <printf>
  int free0 = countfree();
    4f48:	00000097          	auipc	ra,0x0
    4f4c:	dbc080e7          	jalr	-580(ra) # 4d04 <countfree>
    4f50:	8a2a                	mv	s4,a0
  int free1 = 0;
  int fail = 0;
  for (struct test *t = tests; t->s != 0; t++) {
    4f52:	c4843503          	ld	a0,-952(s0)
    4f56:	c4040493          	addi	s1,s0,-960
  int fail = 0;
    4f5a:	4981                	li	s3,0
    if((justone == 0) || strcmp(t->s, justone) == 0) {
      if(!run(t->f, t->s))
        fail = 1;
    4f5c:	4a85                	li	s5,1
  for (struct test *t = tests; t->s != 0; t++) {
    4f5e:	e55d                	bnez	a0,500c <main+0x13a>
  }

  if(fail){
    printf("SOME TESTS FAILED\n");
    exit(1);
  } else if((free1 = countfree()) < free0){
    4f60:	00000097          	auipc	ra,0x0
    4f64:	da4080e7          	jalr	-604(ra) # 4d04 <countfree>
    4f68:	85aa                	mv	a1,a0
    4f6a:	0f455163          	bge	a0,s4,504c <main+0x17a>
    printf("FAILED -- lost some free pages %d (out of %d)\n", free1, free0);
    4f6e:	8652                	mv	a2,s4
    4f70:	00003517          	auipc	a0,0x3
    4f74:	89050513          	addi	a0,a0,-1904 # 7800 <malloc+0x2064>
    4f78:	00000097          	auipc	ra,0x0
    4f7c:	76c080e7          	jalr	1900(ra) # 56e4 <printf>
    exit(1);
    4f80:	4505                	li	a0,1
    4f82:	00000097          	auipc	ra,0x0
    4f86:	3e8080e7          	jalr	1000(ra) # 536a <exit>
    4f8a:	84ae                	mv	s1,a1
  if(argc == 2 && strcmp(argv[1], "-c") == 0){
    4f8c:	00003597          	auipc	a1,0x3
    4f90:	80c58593          	addi	a1,a1,-2036 # 7798 <malloc+0x1ffc>
    4f94:	6488                	ld	a0,8(s1)
    4f96:	00000097          	auipc	ra,0x0
    4f9a:	184080e7          	jalr	388(ra) # 511a <strcmp>
    4f9e:	10050563          	beqz	a0,50a8 <main+0x1d6>
  } else if(argc == 2 && strcmp(argv[1], "-C") == 0){
    4fa2:	00003597          	auipc	a1,0x3
    4fa6:	8de58593          	addi	a1,a1,-1826 # 7880 <malloc+0x20e4>
    4faa:	6488                	ld	a0,8(s1)
    4fac:	00000097          	auipc	ra,0x0
    4fb0:	16e080e7          	jalr	366(ra) # 511a <strcmp>
    4fb4:	c97d                	beqz	a0,50aa <main+0x1d8>
  } else if(argc == 2 && argv[1][0] != '-'){
    4fb6:	0084b903          	ld	s2,8(s1)
    4fba:	00094703          	lbu	a4,0(s2)
    4fbe:	02d00793          	li	a5,45
    4fc2:	f4f713e3          	bne	a4,a5,4f08 <main+0x36>
    printf("Usage: usertests [-c] [testname]\n");
    4fc6:	00002517          	auipc	a0,0x2
    4fca:	7da50513          	addi	a0,a0,2010 # 77a0 <malloc+0x2004>
    4fce:	00000097          	auipc	ra,0x0
    4fd2:	716080e7          	jalr	1814(ra) # 56e4 <printf>
    exit(1);
    4fd6:	4505                	li	a0,1
    4fd8:	00000097          	auipc	ra,0x0
    4fdc:	392080e7          	jalr	914(ra) # 536a <exit>
          exit(1);
    4fe0:	4505                	li	a0,1
    4fe2:	00000097          	auipc	ra,0x0
    4fe6:	388080e7          	jalr	904(ra) # 536a <exit>
        printf("FAILED -- lost %d free pages\n", free0 - free1);
    4fea:	40a905bb          	subw	a1,s2,a0
    4fee:	855a                	mv	a0,s6
    4ff0:	00000097          	auipc	ra,0x0
    4ff4:	6f4080e7          	jalr	1780(ra) # 56e4 <printf>
        if(continuous != 2)
    4ff8:	09498463          	beq	s3,s4,5080 <main+0x1ae>
          exit(1);
    4ffc:	4505                	li	a0,1
    4ffe:	00000097          	auipc	ra,0x0
    5002:	36c080e7          	jalr	876(ra) # 536a <exit>
  for (struct test *t = tests; t->s != 0; t++) {
    5006:	04c1                	addi	s1,s1,16
    5008:	6488                	ld	a0,8(s1)
    500a:	c115                	beqz	a0,502e <main+0x15c>
    if((justone == 0) || strcmp(t->s, justone) == 0) {
    500c:	00090863          	beqz	s2,501c <main+0x14a>
    5010:	85ca                	mv	a1,s2
    5012:	00000097          	auipc	ra,0x0
    5016:	108080e7          	jalr	264(ra) # 511a <strcmp>
    501a:	f575                	bnez	a0,5006 <main+0x134>
      if(!run(t->f, t->s))
    501c:	648c                	ld	a1,8(s1)
    501e:	6088                	ld	a0,0(s1)
    5020:	00000097          	auipc	ra,0x0
    5024:	e14080e7          	jalr	-492(ra) # 4e34 <run>
    5028:	fd79                	bnez	a0,5006 <main+0x134>
        fail = 1;
    502a:	89d6                	mv	s3,s5
    502c:	bfe9                	j	5006 <main+0x134>
  if(fail){
    502e:	f20989e3          	beqz	s3,4f60 <main+0x8e>
    printf("SOME TESTS FAILED\n");
    5032:	00002517          	auipc	a0,0x2
    5036:	7b650513          	addi	a0,a0,1974 # 77e8 <malloc+0x204c>
    503a:	00000097          	auipc	ra,0x0
    503e:	6aa080e7          	jalr	1706(ra) # 56e4 <printf>
    exit(1);
    5042:	4505                	li	a0,1
    5044:	00000097          	auipc	ra,0x0
    5048:	326080e7          	jalr	806(ra) # 536a <exit>
  } else {
    printf("ALL TESTS PASSED\n");
    504c:	00002517          	auipc	a0,0x2
    5050:	7e450513          	addi	a0,a0,2020 # 7830 <malloc+0x2094>
    5054:	00000097          	auipc	ra,0x0
    5058:	690080e7          	jalr	1680(ra) # 56e4 <printf>
    exit(0);
    505c:	4501                	li	a0,0
    505e:	00000097          	auipc	ra,0x0
    5062:	30c080e7          	jalr	780(ra) # 536a <exit>
        printf("SOME TESTS FAILED\n");
    5066:	8556                	mv	a0,s5
    5068:	00000097          	auipc	ra,0x0
    506c:	67c080e7          	jalr	1660(ra) # 56e4 <printf>
        if(continuous != 2)
    5070:	f74998e3          	bne	s3,s4,4fe0 <main+0x10e>
      int free1 = countfree();
    5074:	00000097          	auipc	ra,0x0
    5078:	c90080e7          	jalr	-880(ra) # 4d04 <countfree>
      if(free1 < free0){
    507c:	f72547e3          	blt	a0,s2,4fea <main+0x118>
      int free0 = countfree();
    5080:	00000097          	auipc	ra,0x0
    5084:	c84080e7          	jalr	-892(ra) # 4d04 <countfree>
    5088:	892a                	mv	s2,a0
      for (struct test *t = tests; t->s != 0; t++) {
    508a:	c4843583          	ld	a1,-952(s0)
    508e:	d1fd                	beqz	a1,5074 <main+0x1a2>
    5090:	c4040493          	addi	s1,s0,-960
        if(!run(t->f, t->s)){
    5094:	6088                	ld	a0,0(s1)
    5096:	00000097          	auipc	ra,0x0
    509a:	d9e080e7          	jalr	-610(ra) # 4e34 <run>
    509e:	d561                	beqz	a0,5066 <main+0x194>
      for (struct test *t = tests; t->s != 0; t++) {
    50a0:	04c1                	addi	s1,s1,16
    50a2:	648c                	ld	a1,8(s1)
    50a4:	f9e5                	bnez	a1,5094 <main+0x1c2>
    50a6:	b7f9                	j	5074 <main+0x1a2>
    continuous = 1;
    50a8:	4985                	li	s3,1
  } tests[] = {
    50aa:	00003797          	auipc	a5,0x3
    50ae:	aa678793          	addi	a5,a5,-1370 # 7b50 <malloc+0x23b4>
    50b2:	c4040713          	addi	a4,s0,-960
    50b6:	00003817          	auipc	a6,0x3
    50ba:	e1a80813          	addi	a6,a6,-486 # 7ed0 <malloc+0x2734>
    50be:	6388                	ld	a0,0(a5)
    50c0:	678c                	ld	a1,8(a5)
    50c2:	6b90                	ld	a2,16(a5)
    50c4:	6f94                	ld	a3,24(a5)
    50c6:	e308                	sd	a0,0(a4)
    50c8:	e70c                	sd	a1,8(a4)
    50ca:	eb10                	sd	a2,16(a4)
    50cc:	ef14                	sd	a3,24(a4)
    50ce:	02078793          	addi	a5,a5,32
    50d2:	02070713          	addi	a4,a4,32
    50d6:	ff0794e3          	bne	a5,a6,50be <main+0x1ec>
    printf("continuous usertests starting\n");
    50da:	00002517          	auipc	a0,0x2
    50de:	78650513          	addi	a0,a0,1926 # 7860 <malloc+0x20c4>
    50e2:	00000097          	auipc	ra,0x0
    50e6:	602080e7          	jalr	1538(ra) # 56e4 <printf>
        printf("SOME TESTS FAILED\n");
    50ea:	00002a97          	auipc	s5,0x2
    50ee:	6fea8a93          	addi	s5,s5,1790 # 77e8 <malloc+0x204c>
        if(continuous != 2)
    50f2:	4a09                	li	s4,2
        printf("FAILED -- lost %d free pages\n", free0 - free1);
    50f4:	00002b17          	auipc	s6,0x2
    50f8:	6d4b0b13          	addi	s6,s6,1748 # 77c8 <malloc+0x202c>
    50fc:	b751                	j	5080 <main+0x1ae>

00000000000050fe <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
    50fe:	1141                	addi	sp,sp,-16
    5100:	e422                	sd	s0,8(sp)
    5102:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
    5104:	87aa                	mv	a5,a0
    5106:	0585                	addi	a1,a1,1
    5108:	0785                	addi	a5,a5,1
    510a:	fff5c703          	lbu	a4,-1(a1)
    510e:	fee78fa3          	sb	a4,-1(a5)
    5112:	fb75                	bnez	a4,5106 <strcpy+0x8>
    ;
  return os;
}
    5114:	6422                	ld	s0,8(sp)
    5116:	0141                	addi	sp,sp,16
    5118:	8082                	ret

000000000000511a <strcmp>:

int
strcmp(const char *p, const char *q)
{
    511a:	1141                	addi	sp,sp,-16
    511c:	e422                	sd	s0,8(sp)
    511e:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
    5120:	00054783          	lbu	a5,0(a0)
    5124:	cb91                	beqz	a5,5138 <strcmp+0x1e>
    5126:	0005c703          	lbu	a4,0(a1)
    512a:	00f71763          	bne	a4,a5,5138 <strcmp+0x1e>
    p++, q++;
    512e:	0505                	addi	a0,a0,1
    5130:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
    5132:	00054783          	lbu	a5,0(a0)
    5136:	fbe5                	bnez	a5,5126 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
    5138:	0005c503          	lbu	a0,0(a1)
}
    513c:	40a7853b          	subw	a0,a5,a0
    5140:	6422                	ld	s0,8(sp)
    5142:	0141                	addi	sp,sp,16
    5144:	8082                	ret

0000000000005146 <strlen>:

uint
strlen(const char *s)
{
    5146:	1141                	addi	sp,sp,-16
    5148:	e422                	sd	s0,8(sp)
    514a:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    514c:	00054783          	lbu	a5,0(a0)
    5150:	cf91                	beqz	a5,516c <strlen+0x26>
    5152:	0505                	addi	a0,a0,1
    5154:	87aa                	mv	a5,a0
    5156:	4685                	li	a3,1
    5158:	9e89                	subw	a3,a3,a0
    515a:	00f6853b          	addw	a0,a3,a5
    515e:	0785                	addi	a5,a5,1
    5160:	fff7c703          	lbu	a4,-1(a5)
    5164:	fb7d                	bnez	a4,515a <strlen+0x14>
    ;
  return n;
}
    5166:	6422                	ld	s0,8(sp)
    5168:	0141                	addi	sp,sp,16
    516a:	8082                	ret
  for(n = 0; s[n]; n++)
    516c:	4501                	li	a0,0
    516e:	bfe5                	j	5166 <strlen+0x20>

0000000000005170 <memset>:

void*
memset(void *dst, int c, uint n)
{
    5170:	1141                	addi	sp,sp,-16
    5172:	e422                	sd	s0,8(sp)
    5174:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    5176:	ca19                	beqz	a2,518c <memset+0x1c>
    5178:	87aa                	mv	a5,a0
    517a:	1602                	slli	a2,a2,0x20
    517c:	9201                	srli	a2,a2,0x20
    517e:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    5182:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    5186:	0785                	addi	a5,a5,1
    5188:	fee79de3          	bne	a5,a4,5182 <memset+0x12>
  }
  return dst;
}
    518c:	6422                	ld	s0,8(sp)
    518e:	0141                	addi	sp,sp,16
    5190:	8082                	ret

0000000000005192 <strchr>:

char*
strchr(const char *s, char c)
{
    5192:	1141                	addi	sp,sp,-16
    5194:	e422                	sd	s0,8(sp)
    5196:	0800                	addi	s0,sp,16
  for(; *s; s++)
    5198:	00054783          	lbu	a5,0(a0)
    519c:	cb99                	beqz	a5,51b2 <strchr+0x20>
    if(*s == c)
    519e:	00f58763          	beq	a1,a5,51ac <strchr+0x1a>
  for(; *s; s++)
    51a2:	0505                	addi	a0,a0,1
    51a4:	00054783          	lbu	a5,0(a0)
    51a8:	fbfd                	bnez	a5,519e <strchr+0xc>
      return (char*)s;
  return 0;
    51aa:	4501                	li	a0,0
}
    51ac:	6422                	ld	s0,8(sp)
    51ae:	0141                	addi	sp,sp,16
    51b0:	8082                	ret
  return 0;
    51b2:	4501                	li	a0,0
    51b4:	bfe5                	j	51ac <strchr+0x1a>

00000000000051b6 <gets>:

char*
gets(char *buf, int max)
{
    51b6:	711d                	addi	sp,sp,-96
    51b8:	ec86                	sd	ra,88(sp)
    51ba:	e8a2                	sd	s0,80(sp)
    51bc:	e4a6                	sd	s1,72(sp)
    51be:	e0ca                	sd	s2,64(sp)
    51c0:	fc4e                	sd	s3,56(sp)
    51c2:	f852                	sd	s4,48(sp)
    51c4:	f456                	sd	s5,40(sp)
    51c6:	f05a                	sd	s6,32(sp)
    51c8:	ec5e                	sd	s7,24(sp)
    51ca:	1080                	addi	s0,sp,96
    51cc:	8baa                	mv	s7,a0
    51ce:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    51d0:	892a                	mv	s2,a0
    51d2:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
    51d4:	4aa9                	li	s5,10
    51d6:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
    51d8:	89a6                	mv	s3,s1
    51da:	2485                	addiw	s1,s1,1
    51dc:	0344d863          	bge	s1,s4,520c <gets+0x56>
    cc = read(0, &c, 1);
    51e0:	4605                	li	a2,1
    51e2:	faf40593          	addi	a1,s0,-81
    51e6:	4501                	li	a0,0
    51e8:	00000097          	auipc	ra,0x0
    51ec:	19a080e7          	jalr	410(ra) # 5382 <read>
    if(cc < 1)
    51f0:	00a05e63          	blez	a0,520c <gets+0x56>
    buf[i++] = c;
    51f4:	faf44783          	lbu	a5,-81(s0)
    51f8:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
    51fc:	01578763          	beq	a5,s5,520a <gets+0x54>
    5200:	0905                	addi	s2,s2,1
    5202:	fd679be3          	bne	a5,s6,51d8 <gets+0x22>
  for(i=0; i+1 < max; ){
    5206:	89a6                	mv	s3,s1
    5208:	a011                	j	520c <gets+0x56>
    520a:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
    520c:	99de                	add	s3,s3,s7
    520e:	00098023          	sb	zero,0(s3)
  return buf;
}
    5212:	855e                	mv	a0,s7
    5214:	60e6                	ld	ra,88(sp)
    5216:	6446                	ld	s0,80(sp)
    5218:	64a6                	ld	s1,72(sp)
    521a:	6906                	ld	s2,64(sp)
    521c:	79e2                	ld	s3,56(sp)
    521e:	7a42                	ld	s4,48(sp)
    5220:	7aa2                	ld	s5,40(sp)
    5222:	7b02                	ld	s6,32(sp)
    5224:	6be2                	ld	s7,24(sp)
    5226:	6125                	addi	sp,sp,96
    5228:	8082                	ret

000000000000522a <stat>:

int
stat(const char *n, struct stat *st)
{
    522a:	1101                	addi	sp,sp,-32
    522c:	ec06                	sd	ra,24(sp)
    522e:	e822                	sd	s0,16(sp)
    5230:	e426                	sd	s1,8(sp)
    5232:	e04a                	sd	s2,0(sp)
    5234:	1000                	addi	s0,sp,32
    5236:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    5238:	4581                	li	a1,0
    523a:	00000097          	auipc	ra,0x0
    523e:	170080e7          	jalr	368(ra) # 53aa <open>
  if(fd < 0)
    5242:	02054563          	bltz	a0,526c <stat+0x42>
    5246:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
    5248:	85ca                	mv	a1,s2
    524a:	00000097          	auipc	ra,0x0
    524e:	178080e7          	jalr	376(ra) # 53c2 <fstat>
    5252:	892a                	mv	s2,a0
  close(fd);
    5254:	8526                	mv	a0,s1
    5256:	00000097          	auipc	ra,0x0
    525a:	13c080e7          	jalr	316(ra) # 5392 <close>
  return r;
}
    525e:	854a                	mv	a0,s2
    5260:	60e2                	ld	ra,24(sp)
    5262:	6442                	ld	s0,16(sp)
    5264:	64a2                	ld	s1,8(sp)
    5266:	6902                	ld	s2,0(sp)
    5268:	6105                	addi	sp,sp,32
    526a:	8082                	ret
    return -1;
    526c:	597d                	li	s2,-1
    526e:	bfc5                	j	525e <stat+0x34>

0000000000005270 <atoi>:

int
atoi(const char *s)
{
    5270:	1141                	addi	sp,sp,-16
    5272:	e422                	sd	s0,8(sp)
    5274:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    5276:	00054683          	lbu	a3,0(a0)
    527a:	fd06879b          	addiw	a5,a3,-48
    527e:	0ff7f793          	zext.b	a5,a5
    5282:	4625                	li	a2,9
    5284:	02f66863          	bltu	a2,a5,52b4 <atoi+0x44>
    5288:	872a                	mv	a4,a0
  n = 0;
    528a:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
    528c:	0705                	addi	a4,a4,1
    528e:	0025179b          	slliw	a5,a0,0x2
    5292:	9fa9                	addw	a5,a5,a0
    5294:	0017979b          	slliw	a5,a5,0x1
    5298:	9fb5                	addw	a5,a5,a3
    529a:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
    529e:	00074683          	lbu	a3,0(a4)
    52a2:	fd06879b          	addiw	a5,a3,-48
    52a6:	0ff7f793          	zext.b	a5,a5
    52aa:	fef671e3          	bgeu	a2,a5,528c <atoi+0x1c>
  return n;
}
    52ae:	6422                	ld	s0,8(sp)
    52b0:	0141                	addi	sp,sp,16
    52b2:	8082                	ret
  n = 0;
    52b4:	4501                	li	a0,0
    52b6:	bfe5                	j	52ae <atoi+0x3e>

00000000000052b8 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
    52b8:	1141                	addi	sp,sp,-16
    52ba:	e422                	sd	s0,8(sp)
    52bc:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
    52be:	02b57463          	bgeu	a0,a1,52e6 <memmove+0x2e>
    while(n-- > 0)
    52c2:	00c05f63          	blez	a2,52e0 <memmove+0x28>
    52c6:	1602                	slli	a2,a2,0x20
    52c8:	9201                	srli	a2,a2,0x20
    52ca:	00c507b3          	add	a5,a0,a2
  dst = vdst;
    52ce:	872a                	mv	a4,a0
      *dst++ = *src++;
    52d0:	0585                	addi	a1,a1,1
    52d2:	0705                	addi	a4,a4,1
    52d4:	fff5c683          	lbu	a3,-1(a1)
    52d8:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    52dc:	fee79ae3          	bne	a5,a4,52d0 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
    52e0:	6422                	ld	s0,8(sp)
    52e2:	0141                	addi	sp,sp,16
    52e4:	8082                	ret
    dst += n;
    52e6:	00c50733          	add	a4,a0,a2
    src += n;
    52ea:	95b2                	add	a1,a1,a2
    while(n-- > 0)
    52ec:	fec05ae3          	blez	a2,52e0 <memmove+0x28>
    52f0:	fff6079b          	addiw	a5,a2,-1 # 2fff <subdir+0x329>
    52f4:	1782                	slli	a5,a5,0x20
    52f6:	9381                	srli	a5,a5,0x20
    52f8:	fff7c793          	not	a5,a5
    52fc:	97ba                	add	a5,a5,a4
      *--dst = *--src;
    52fe:	15fd                	addi	a1,a1,-1
    5300:	177d                	addi	a4,a4,-1
    5302:	0005c683          	lbu	a3,0(a1)
    5306:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
    530a:	fee79ae3          	bne	a5,a4,52fe <memmove+0x46>
    530e:	bfc9                	j	52e0 <memmove+0x28>

0000000000005310 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
    5310:	1141                	addi	sp,sp,-16
    5312:	e422                	sd	s0,8(sp)
    5314:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
    5316:	ca05                	beqz	a2,5346 <memcmp+0x36>
    5318:	fff6069b          	addiw	a3,a2,-1
    531c:	1682                	slli	a3,a3,0x20
    531e:	9281                	srli	a3,a3,0x20
    5320:	0685                	addi	a3,a3,1
    5322:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
    5324:	00054783          	lbu	a5,0(a0)
    5328:	0005c703          	lbu	a4,0(a1)
    532c:	00e79863          	bne	a5,a4,533c <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
    5330:	0505                	addi	a0,a0,1
    p2++;
    5332:	0585                	addi	a1,a1,1
  while (n-- > 0) {
    5334:	fed518e3          	bne	a0,a3,5324 <memcmp+0x14>
  }
  return 0;
    5338:	4501                	li	a0,0
    533a:	a019                	j	5340 <memcmp+0x30>
      return *p1 - *p2;
    533c:	40e7853b          	subw	a0,a5,a4
}
    5340:	6422                	ld	s0,8(sp)
    5342:	0141                	addi	sp,sp,16
    5344:	8082                	ret
  return 0;
    5346:	4501                	li	a0,0
    5348:	bfe5                	j	5340 <memcmp+0x30>

000000000000534a <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
    534a:	1141                	addi	sp,sp,-16
    534c:	e406                	sd	ra,8(sp)
    534e:	e022                	sd	s0,0(sp)
    5350:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    5352:	00000097          	auipc	ra,0x0
    5356:	f66080e7          	jalr	-154(ra) # 52b8 <memmove>
}
    535a:	60a2                	ld	ra,8(sp)
    535c:	6402                	ld	s0,0(sp)
    535e:	0141                	addi	sp,sp,16
    5360:	8082                	ret

0000000000005362 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
    5362:	4885                	li	a7,1
 ecall
    5364:	00000073          	ecall
 ret
    5368:	8082                	ret

000000000000536a <exit>:
.global exit
exit:
 li a7, SYS_exit
    536a:	4889                	li	a7,2
 ecall
    536c:	00000073          	ecall
 ret
    5370:	8082                	ret

0000000000005372 <wait>:
.global wait
wait:
 li a7, SYS_wait
    5372:	488d                	li	a7,3
 ecall
    5374:	00000073          	ecall
 ret
    5378:	8082                	ret

000000000000537a <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
    537a:	4891                	li	a7,4
 ecall
    537c:	00000073          	ecall
 ret
    5380:	8082                	ret

0000000000005382 <read>:
.global read
read:
 li a7, SYS_read
    5382:	4895                	li	a7,5
 ecall
    5384:	00000073          	ecall
 ret
    5388:	8082                	ret

000000000000538a <write>:
.global write
write:
 li a7, SYS_write
    538a:	48c1                	li	a7,16
 ecall
    538c:	00000073          	ecall
 ret
    5390:	8082                	ret

0000000000005392 <close>:
.global close
close:
 li a7, SYS_close
    5392:	48d5                	li	a7,21
 ecall
    5394:	00000073          	ecall
 ret
    5398:	8082                	ret

000000000000539a <kill>:
.global kill
kill:
 li a7, SYS_kill
    539a:	4899                	li	a7,6
 ecall
    539c:	00000073          	ecall
 ret
    53a0:	8082                	ret

00000000000053a2 <exec>:
.global exec
exec:
 li a7, SYS_exec
    53a2:	489d                	li	a7,7
 ecall
    53a4:	00000073          	ecall
 ret
    53a8:	8082                	ret

00000000000053aa <open>:
.global open
open:
 li a7, SYS_open
    53aa:	48bd                	li	a7,15
 ecall
    53ac:	00000073          	ecall
 ret
    53b0:	8082                	ret

00000000000053b2 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
    53b2:	48c5                	li	a7,17
 ecall
    53b4:	00000073          	ecall
 ret
    53b8:	8082                	ret

00000000000053ba <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
    53ba:	48c9                	li	a7,18
 ecall
    53bc:	00000073          	ecall
 ret
    53c0:	8082                	ret

00000000000053c2 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
    53c2:	48a1                	li	a7,8
 ecall
    53c4:	00000073          	ecall
 ret
    53c8:	8082                	ret

00000000000053ca <link>:
.global link
link:
 li a7, SYS_link
    53ca:	48cd                	li	a7,19
 ecall
    53cc:	00000073          	ecall
 ret
    53d0:	8082                	ret

00000000000053d2 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
    53d2:	48d1                	li	a7,20
 ecall
    53d4:	00000073          	ecall
 ret
    53d8:	8082                	ret

00000000000053da <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
    53da:	48a5                	li	a7,9
 ecall
    53dc:	00000073          	ecall
 ret
    53e0:	8082                	ret

00000000000053e2 <dup>:
.global dup
dup:
 li a7, SYS_dup
    53e2:	48a9                	li	a7,10
 ecall
    53e4:	00000073          	ecall
 ret
    53e8:	8082                	ret

00000000000053ea <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
    53ea:	48ad                	li	a7,11
 ecall
    53ec:	00000073          	ecall
 ret
    53f0:	8082                	ret

00000000000053f2 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
    53f2:	48b1                	li	a7,12
 ecall
    53f4:	00000073          	ecall
 ret
    53f8:	8082                	ret

00000000000053fa <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
    53fa:	48b5                	li	a7,13
 ecall
    53fc:	00000073          	ecall
 ret
    5400:	8082                	ret

0000000000005402 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
    5402:	48b9                	li	a7,14
 ecall
    5404:	00000073          	ecall
 ret
    5408:	8082                	ret

000000000000540a <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
    540a:	1101                	addi	sp,sp,-32
    540c:	ec06                	sd	ra,24(sp)
    540e:	e822                	sd	s0,16(sp)
    5410:	1000                	addi	s0,sp,32
    5412:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
    5416:	4605                	li	a2,1
    5418:	fef40593          	addi	a1,s0,-17
    541c:	00000097          	auipc	ra,0x0
    5420:	f6e080e7          	jalr	-146(ra) # 538a <write>
}
    5424:	60e2                	ld	ra,24(sp)
    5426:	6442                	ld	s0,16(sp)
    5428:	6105                	addi	sp,sp,32
    542a:	8082                	ret

000000000000542c <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
    542c:	7139                	addi	sp,sp,-64
    542e:	fc06                	sd	ra,56(sp)
    5430:	f822                	sd	s0,48(sp)
    5432:	f426                	sd	s1,40(sp)
    5434:	f04a                	sd	s2,32(sp)
    5436:	ec4e                	sd	s3,24(sp)
    5438:	0080                	addi	s0,sp,64
    543a:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    543c:	c299                	beqz	a3,5442 <printint+0x16>
    543e:	0805c963          	bltz	a1,54d0 <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
    5442:	2581                	sext.w	a1,a1
  neg = 0;
    5444:	4881                	li	a7,0
    5446:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
    544a:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
    544c:	2601                	sext.w	a2,a2
    544e:	00003517          	auipc	a0,0x3
    5452:	ae250513          	addi	a0,a0,-1310 # 7f30 <digits>
    5456:	883a                	mv	a6,a4
    5458:	2705                	addiw	a4,a4,1
    545a:	02c5f7bb          	remuw	a5,a1,a2
    545e:	1782                	slli	a5,a5,0x20
    5460:	9381                	srli	a5,a5,0x20
    5462:	97aa                	add	a5,a5,a0
    5464:	0007c783          	lbu	a5,0(a5)
    5468:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
    546c:	0005879b          	sext.w	a5,a1
    5470:	02c5d5bb          	divuw	a1,a1,a2
    5474:	0685                	addi	a3,a3,1
    5476:	fec7f0e3          	bgeu	a5,a2,5456 <printint+0x2a>
  if(neg)
    547a:	00088c63          	beqz	a7,5492 <printint+0x66>
    buf[i++] = '-';
    547e:	fd070793          	addi	a5,a4,-48
    5482:	00878733          	add	a4,a5,s0
    5486:	02d00793          	li	a5,45
    548a:	fef70823          	sb	a5,-16(a4)
    548e:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    5492:	02e05863          	blez	a4,54c2 <printint+0x96>
    5496:	fc040793          	addi	a5,s0,-64
    549a:	00e78933          	add	s2,a5,a4
    549e:	fff78993          	addi	s3,a5,-1
    54a2:	99ba                	add	s3,s3,a4
    54a4:	377d                	addiw	a4,a4,-1
    54a6:	1702                	slli	a4,a4,0x20
    54a8:	9301                	srli	a4,a4,0x20
    54aa:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
    54ae:	fff94583          	lbu	a1,-1(s2)
    54b2:	8526                	mv	a0,s1
    54b4:	00000097          	auipc	ra,0x0
    54b8:	f56080e7          	jalr	-170(ra) # 540a <putc>
  while(--i >= 0)
    54bc:	197d                	addi	s2,s2,-1
    54be:	ff3918e3          	bne	s2,s3,54ae <printint+0x82>
}
    54c2:	70e2                	ld	ra,56(sp)
    54c4:	7442                	ld	s0,48(sp)
    54c6:	74a2                	ld	s1,40(sp)
    54c8:	7902                	ld	s2,32(sp)
    54ca:	69e2                	ld	s3,24(sp)
    54cc:	6121                	addi	sp,sp,64
    54ce:	8082                	ret
    x = -xx;
    54d0:	40b005bb          	negw	a1,a1
    neg = 1;
    54d4:	4885                	li	a7,1
    x = -xx;
    54d6:	bf85                	j	5446 <printint+0x1a>

00000000000054d8 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
    54d8:	7119                	addi	sp,sp,-128
    54da:	fc86                	sd	ra,120(sp)
    54dc:	f8a2                	sd	s0,112(sp)
    54de:	f4a6                	sd	s1,104(sp)
    54e0:	f0ca                	sd	s2,96(sp)
    54e2:	ecce                	sd	s3,88(sp)
    54e4:	e8d2                	sd	s4,80(sp)
    54e6:	e4d6                	sd	s5,72(sp)
    54e8:	e0da                	sd	s6,64(sp)
    54ea:	fc5e                	sd	s7,56(sp)
    54ec:	f862                	sd	s8,48(sp)
    54ee:	f466                	sd	s9,40(sp)
    54f0:	f06a                	sd	s10,32(sp)
    54f2:	ec6e                	sd	s11,24(sp)
    54f4:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
    54f6:	0005c903          	lbu	s2,0(a1)
    54fa:	18090f63          	beqz	s2,5698 <vprintf+0x1c0>
    54fe:	8aaa                	mv	s5,a0
    5500:	8b32                	mv	s6,a2
    5502:	00158493          	addi	s1,a1,1
  state = 0;
    5506:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
    5508:	02500a13          	li	s4,37
    550c:	4c55                	li	s8,21
    550e:	00003c97          	auipc	s9,0x3
    5512:	9cac8c93          	addi	s9,s9,-1590 # 7ed8 <malloc+0x273c>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
        s = va_arg(ap, char*);
        if(s == 0)
          s = "(null)";
        while(*s != 0){
    5516:	02800d93          	li	s11,40
  putc(fd, 'x');
    551a:	4d41                	li	s10,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    551c:	00003b97          	auipc	s7,0x3
    5520:	a14b8b93          	addi	s7,s7,-1516 # 7f30 <digits>
    5524:	a839                	j	5542 <vprintf+0x6a>
        putc(fd, c);
    5526:	85ca                	mv	a1,s2
    5528:	8556                	mv	a0,s5
    552a:	00000097          	auipc	ra,0x0
    552e:	ee0080e7          	jalr	-288(ra) # 540a <putc>
    5532:	a019                	j	5538 <vprintf+0x60>
    } else if(state == '%'){
    5534:	01498d63          	beq	s3,s4,554e <vprintf+0x76>
  for(i = 0; fmt[i]; i++){
    5538:	0485                	addi	s1,s1,1
    553a:	fff4c903          	lbu	s2,-1(s1)
    553e:	14090d63          	beqz	s2,5698 <vprintf+0x1c0>
    if(state == 0){
    5542:	fe0999e3          	bnez	s3,5534 <vprintf+0x5c>
      if(c == '%'){
    5546:	ff4910e3          	bne	s2,s4,5526 <vprintf+0x4e>
        state = '%';
    554a:	89d2                	mv	s3,s4
    554c:	b7f5                	j	5538 <vprintf+0x60>
      if(c == 'd'){
    554e:	11490c63          	beq	s2,s4,5666 <vprintf+0x18e>
    5552:	f9d9079b          	addiw	a5,s2,-99
    5556:	0ff7f793          	zext.b	a5,a5
    555a:	10fc6e63          	bltu	s8,a5,5676 <vprintf+0x19e>
    555e:	f9d9079b          	addiw	a5,s2,-99
    5562:	0ff7f713          	zext.b	a4,a5
    5566:	10ec6863          	bltu	s8,a4,5676 <vprintf+0x19e>
    556a:	00271793          	slli	a5,a4,0x2
    556e:	97e6                	add	a5,a5,s9
    5570:	439c                	lw	a5,0(a5)
    5572:	97e6                	add	a5,a5,s9
    5574:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
    5576:	008b0913          	addi	s2,s6,8
    557a:	4685                	li	a3,1
    557c:	4629                	li	a2,10
    557e:	000b2583          	lw	a1,0(s6)
    5582:	8556                	mv	a0,s5
    5584:	00000097          	auipc	ra,0x0
    5588:	ea8080e7          	jalr	-344(ra) # 542c <printint>
    558c:	8b4a                	mv	s6,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
    558e:	4981                	li	s3,0
    5590:	b765                	j	5538 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
    5592:	008b0913          	addi	s2,s6,8
    5596:	4681                	li	a3,0
    5598:	4629                	li	a2,10
    559a:	000b2583          	lw	a1,0(s6)
    559e:	8556                	mv	a0,s5
    55a0:	00000097          	auipc	ra,0x0
    55a4:	e8c080e7          	jalr	-372(ra) # 542c <printint>
    55a8:	8b4a                	mv	s6,s2
      state = 0;
    55aa:	4981                	li	s3,0
    55ac:	b771                	j	5538 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
    55ae:	008b0913          	addi	s2,s6,8
    55b2:	4681                	li	a3,0
    55b4:	866a                	mv	a2,s10
    55b6:	000b2583          	lw	a1,0(s6)
    55ba:	8556                	mv	a0,s5
    55bc:	00000097          	auipc	ra,0x0
    55c0:	e70080e7          	jalr	-400(ra) # 542c <printint>
    55c4:	8b4a                	mv	s6,s2
      state = 0;
    55c6:	4981                	li	s3,0
    55c8:	bf85                	j	5538 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
    55ca:	008b0793          	addi	a5,s6,8
    55ce:	f8f43423          	sd	a5,-120(s0)
    55d2:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
    55d6:	03000593          	li	a1,48
    55da:	8556                	mv	a0,s5
    55dc:	00000097          	auipc	ra,0x0
    55e0:	e2e080e7          	jalr	-466(ra) # 540a <putc>
  putc(fd, 'x');
    55e4:	07800593          	li	a1,120
    55e8:	8556                	mv	a0,s5
    55ea:	00000097          	auipc	ra,0x0
    55ee:	e20080e7          	jalr	-480(ra) # 540a <putc>
    55f2:	896a                	mv	s2,s10
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    55f4:	03c9d793          	srli	a5,s3,0x3c
    55f8:	97de                	add	a5,a5,s7
    55fa:	0007c583          	lbu	a1,0(a5)
    55fe:	8556                	mv	a0,s5
    5600:	00000097          	auipc	ra,0x0
    5604:	e0a080e7          	jalr	-502(ra) # 540a <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    5608:	0992                	slli	s3,s3,0x4
    560a:	397d                	addiw	s2,s2,-1
    560c:	fe0914e3          	bnez	s2,55f4 <vprintf+0x11c>
        printptr(fd, va_arg(ap, uint64));
    5610:	f8843b03          	ld	s6,-120(s0)
      state = 0;
    5614:	4981                	li	s3,0
    5616:	b70d                	j	5538 <vprintf+0x60>
        s = va_arg(ap, char*);
    5618:	008b0913          	addi	s2,s6,8
    561c:	000b3983          	ld	s3,0(s6)
        if(s == 0)
    5620:	02098163          	beqz	s3,5642 <vprintf+0x16a>
        while(*s != 0){
    5624:	0009c583          	lbu	a1,0(s3)
    5628:	c5ad                	beqz	a1,5692 <vprintf+0x1ba>
          putc(fd, *s);
    562a:	8556                	mv	a0,s5
    562c:	00000097          	auipc	ra,0x0
    5630:	dde080e7          	jalr	-546(ra) # 540a <putc>
          s++;
    5634:	0985                	addi	s3,s3,1
        while(*s != 0){
    5636:	0009c583          	lbu	a1,0(s3)
    563a:	f9e5                	bnez	a1,562a <vprintf+0x152>
        s = va_arg(ap, char*);
    563c:	8b4a                	mv	s6,s2
      state = 0;
    563e:	4981                	li	s3,0
    5640:	bde5                	j	5538 <vprintf+0x60>
          s = "(null)";
    5642:	00003997          	auipc	s3,0x3
    5646:	88e98993          	addi	s3,s3,-1906 # 7ed0 <malloc+0x2734>
        while(*s != 0){
    564a:	85ee                	mv	a1,s11
    564c:	bff9                	j	562a <vprintf+0x152>
        putc(fd, va_arg(ap, uint));
    564e:	008b0913          	addi	s2,s6,8
    5652:	000b4583          	lbu	a1,0(s6)
    5656:	8556                	mv	a0,s5
    5658:	00000097          	auipc	ra,0x0
    565c:	db2080e7          	jalr	-590(ra) # 540a <putc>
    5660:	8b4a                	mv	s6,s2
      state = 0;
    5662:	4981                	li	s3,0
    5664:	bdd1                	j	5538 <vprintf+0x60>
        putc(fd, c);
    5666:	85d2                	mv	a1,s4
    5668:	8556                	mv	a0,s5
    566a:	00000097          	auipc	ra,0x0
    566e:	da0080e7          	jalr	-608(ra) # 540a <putc>
      state = 0;
    5672:	4981                	li	s3,0
    5674:	b5d1                	j	5538 <vprintf+0x60>
        putc(fd, '%');
    5676:	85d2                	mv	a1,s4
    5678:	8556                	mv	a0,s5
    567a:	00000097          	auipc	ra,0x0
    567e:	d90080e7          	jalr	-624(ra) # 540a <putc>
        putc(fd, c);
    5682:	85ca                	mv	a1,s2
    5684:	8556                	mv	a0,s5
    5686:	00000097          	auipc	ra,0x0
    568a:	d84080e7          	jalr	-636(ra) # 540a <putc>
      state = 0;
    568e:	4981                	li	s3,0
    5690:	b565                	j	5538 <vprintf+0x60>
        s = va_arg(ap, char*);
    5692:	8b4a                	mv	s6,s2
      state = 0;
    5694:	4981                	li	s3,0
    5696:	b54d                	j	5538 <vprintf+0x60>
    }
  }
}
    5698:	70e6                	ld	ra,120(sp)
    569a:	7446                	ld	s0,112(sp)
    569c:	74a6                	ld	s1,104(sp)
    569e:	7906                	ld	s2,96(sp)
    56a0:	69e6                	ld	s3,88(sp)
    56a2:	6a46                	ld	s4,80(sp)
    56a4:	6aa6                	ld	s5,72(sp)
    56a6:	6b06                	ld	s6,64(sp)
    56a8:	7be2                	ld	s7,56(sp)
    56aa:	7c42                	ld	s8,48(sp)
    56ac:	7ca2                	ld	s9,40(sp)
    56ae:	7d02                	ld	s10,32(sp)
    56b0:	6de2                	ld	s11,24(sp)
    56b2:	6109                	addi	sp,sp,128
    56b4:	8082                	ret

00000000000056b6 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
    56b6:	715d                	addi	sp,sp,-80
    56b8:	ec06                	sd	ra,24(sp)
    56ba:	e822                	sd	s0,16(sp)
    56bc:	1000                	addi	s0,sp,32
    56be:	e010                	sd	a2,0(s0)
    56c0:	e414                	sd	a3,8(s0)
    56c2:	e818                	sd	a4,16(s0)
    56c4:	ec1c                	sd	a5,24(s0)
    56c6:	03043023          	sd	a6,32(s0)
    56ca:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
    56ce:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
    56d2:	8622                	mv	a2,s0
    56d4:	00000097          	auipc	ra,0x0
    56d8:	e04080e7          	jalr	-508(ra) # 54d8 <vprintf>
}
    56dc:	60e2                	ld	ra,24(sp)
    56de:	6442                	ld	s0,16(sp)
    56e0:	6161                	addi	sp,sp,80
    56e2:	8082                	ret

00000000000056e4 <printf>:

void
printf(const char *fmt, ...)
{
    56e4:	711d                	addi	sp,sp,-96
    56e6:	ec06                	sd	ra,24(sp)
    56e8:	e822                	sd	s0,16(sp)
    56ea:	1000                	addi	s0,sp,32
    56ec:	e40c                	sd	a1,8(s0)
    56ee:	e810                	sd	a2,16(s0)
    56f0:	ec14                	sd	a3,24(s0)
    56f2:	f018                	sd	a4,32(s0)
    56f4:	f41c                	sd	a5,40(s0)
    56f6:	03043823          	sd	a6,48(s0)
    56fa:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
    56fe:	00840613          	addi	a2,s0,8
    5702:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
    5706:	85aa                	mv	a1,a0
    5708:	4505                	li	a0,1
    570a:	00000097          	auipc	ra,0x0
    570e:	dce080e7          	jalr	-562(ra) # 54d8 <vprintf>
}
    5712:	60e2                	ld	ra,24(sp)
    5714:	6442                	ld	s0,16(sp)
    5716:	6125                	addi	sp,sp,96
    5718:	8082                	ret

000000000000571a <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    571a:	1141                	addi	sp,sp,-16
    571c:	e422                	sd	s0,8(sp)
    571e:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
    5720:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    5724:	00003797          	auipc	a5,0x3
    5728:	83c7b783          	ld	a5,-1988(a5) # 7f60 <freep>
    572c:	a02d                	j	5756 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
    572e:	4618                	lw	a4,8(a2)
    5730:	9f2d                	addw	a4,a4,a1
    5732:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
    5736:	6398                	ld	a4,0(a5)
    5738:	6310                	ld	a2,0(a4)
    573a:	a83d                	j	5778 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
    573c:	ff852703          	lw	a4,-8(a0)
    5740:	9f31                	addw	a4,a4,a2
    5742:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
    5744:	ff053683          	ld	a3,-16(a0)
    5748:	a091                	j	578c <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    574a:	6398                	ld	a4,0(a5)
    574c:	00e7e463          	bltu	a5,a4,5754 <free+0x3a>
    5750:	00e6ea63          	bltu	a3,a4,5764 <free+0x4a>
{
    5754:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    5756:	fed7fae3          	bgeu	a5,a3,574a <free+0x30>
    575a:	6398                	ld	a4,0(a5)
    575c:	00e6e463          	bltu	a3,a4,5764 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    5760:	fee7eae3          	bltu	a5,a4,5754 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
    5764:	ff852583          	lw	a1,-8(a0)
    5768:	6390                	ld	a2,0(a5)
    576a:	02059813          	slli	a6,a1,0x20
    576e:	01c85713          	srli	a4,a6,0x1c
    5772:	9736                	add	a4,a4,a3
    5774:	fae60de3          	beq	a2,a4,572e <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
    5778:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
    577c:	4790                	lw	a2,8(a5)
    577e:	02061593          	slli	a1,a2,0x20
    5782:	01c5d713          	srli	a4,a1,0x1c
    5786:	973e                	add	a4,a4,a5
    5788:	fae68ae3          	beq	a3,a4,573c <free+0x22>
    p->s.ptr = bp->s.ptr;
    578c:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
    578e:	00002717          	auipc	a4,0x2
    5792:	7cf73923          	sd	a5,2002(a4) # 7f60 <freep>
}
    5796:	6422                	ld	s0,8(sp)
    5798:	0141                	addi	sp,sp,16
    579a:	8082                	ret

000000000000579c <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    579c:	7139                	addi	sp,sp,-64
    579e:	fc06                	sd	ra,56(sp)
    57a0:	f822                	sd	s0,48(sp)
    57a2:	f426                	sd	s1,40(sp)
    57a4:	f04a                	sd	s2,32(sp)
    57a6:	ec4e                	sd	s3,24(sp)
    57a8:	e852                	sd	s4,16(sp)
    57aa:	e456                	sd	s5,8(sp)
    57ac:	e05a                	sd	s6,0(sp)
    57ae:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    57b0:	02051493          	slli	s1,a0,0x20
    57b4:	9081                	srli	s1,s1,0x20
    57b6:	04bd                	addi	s1,s1,15
    57b8:	8091                	srli	s1,s1,0x4
    57ba:	0014899b          	addiw	s3,s1,1
    57be:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
    57c0:	00002517          	auipc	a0,0x2
    57c4:	7a053503          	ld	a0,1952(a0) # 7f60 <freep>
    57c8:	c515                	beqz	a0,57f4 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    57ca:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    57cc:	4798                	lw	a4,8(a5)
    57ce:	02977f63          	bgeu	a4,s1,580c <malloc+0x70>
    57d2:	8a4e                	mv	s4,s3
    57d4:	0009871b          	sext.w	a4,s3
    57d8:	6685                	lui	a3,0x1
    57da:	00d77363          	bgeu	a4,a3,57e0 <malloc+0x44>
    57de:	6a05                	lui	s4,0x1
    57e0:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
    57e4:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    57e8:	00002917          	auipc	s2,0x2
    57ec:	77890913          	addi	s2,s2,1912 # 7f60 <freep>
  if(p == (char*)-1)
    57f0:	5afd                	li	s5,-1
    57f2:	a895                	j	5866 <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
    57f4:	00009797          	auipc	a5,0x9
    57f8:	f8c78793          	addi	a5,a5,-116 # e780 <base>
    57fc:	00002717          	auipc	a4,0x2
    5800:	76f73223          	sd	a5,1892(a4) # 7f60 <freep>
    5804:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
    5806:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
    580a:	b7e1                	j	57d2 <malloc+0x36>
      if(p->s.size == nunits)
    580c:	02e48c63          	beq	s1,a4,5844 <malloc+0xa8>
        p->s.size -= nunits;
    5810:	4137073b          	subw	a4,a4,s3
    5814:	c798                	sw	a4,8(a5)
        p += p->s.size;
    5816:	02071693          	slli	a3,a4,0x20
    581a:	01c6d713          	srli	a4,a3,0x1c
    581e:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
    5820:	0137a423          	sw	s3,8(a5)
      freep = prevp;
    5824:	00002717          	auipc	a4,0x2
    5828:	72a73e23          	sd	a0,1852(a4) # 7f60 <freep>
      return (void*)(p + 1);
    582c:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
    5830:	70e2                	ld	ra,56(sp)
    5832:	7442                	ld	s0,48(sp)
    5834:	74a2                	ld	s1,40(sp)
    5836:	7902                	ld	s2,32(sp)
    5838:	69e2                	ld	s3,24(sp)
    583a:	6a42                	ld	s4,16(sp)
    583c:	6aa2                	ld	s5,8(sp)
    583e:	6b02                	ld	s6,0(sp)
    5840:	6121                	addi	sp,sp,64
    5842:	8082                	ret
        prevp->s.ptr = p->s.ptr;
    5844:	6398                	ld	a4,0(a5)
    5846:	e118                	sd	a4,0(a0)
    5848:	bff1                	j	5824 <malloc+0x88>
  hp->s.size = nu;
    584a:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
    584e:	0541                	addi	a0,a0,16
    5850:	00000097          	auipc	ra,0x0
    5854:	eca080e7          	jalr	-310(ra) # 571a <free>
  return freep;
    5858:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
    585c:	d971                	beqz	a0,5830 <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    585e:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    5860:	4798                	lw	a4,8(a5)
    5862:	fa9775e3          	bgeu	a4,s1,580c <malloc+0x70>
    if(p == freep)
    5866:	00093703          	ld	a4,0(s2)
    586a:	853e                	mv	a0,a5
    586c:	fef719e3          	bne	a4,a5,585e <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
    5870:	8552                	mv	a0,s4
    5872:	00000097          	auipc	ra,0x0
    5876:	b80080e7          	jalr	-1152(ra) # 53f2 <sbrk>
  if(p == (char*)-1)
    587a:	fd5518e3          	bne	a0,s5,584a <malloc+0xae>
        return 0;
    587e:	4501                	li	a0,0
    5880:	bf45                	j	5830 <malloc+0x94>
