
kernel/kernel：     文件格式 elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	0000a117          	auipc	sp,0xa
    80000004:	83010113          	addi	sp,sp,-2000 # 80009830 <stack0>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	070000ef          	jal	ra,80000086 <start>

000000008000001a <spin>:
    8000001a:	a001                	j	8000001a <spin>

000000008000001c <timerinit>:
// which arrive at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
void
timerinit()
{
    8000001c:	1141                	addi	sp,sp,-16
    8000001e:	e422                	sd	s0,8(sp)
    80000020:	0800                	addi	s0,sp,16
// which hart (core) is this?
static inline uint64
r_mhartid()
{
  uint64 x;
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80000022:	f14027f3          	csrr	a5,mhartid
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();

  // ask the CLINT for a timer interrupt.
  int interval = 1000000; // cycles; about 1/10th second in qemu.
  *(uint64*)CLINT_MTIMECMP(id) = *(uint64*)CLINT_MTIME + interval;
    80000026:	0037969b          	slliw	a3,a5,0x3
    8000002a:	02004737          	lui	a4,0x2004
    8000002e:	96ba                	add	a3,a3,a4
    80000030:	0200c737          	lui	a4,0x200c
    80000034:	ff873603          	ld	a2,-8(a4) # 200bff8 <_entry-0x7dff4008>
    80000038:	000f4737          	lui	a4,0xf4
    8000003c:	24070713          	addi	a4,a4,576 # f4240 <_entry-0x7ff0bdc0>
    80000040:	963a                	add	a2,a2,a4
    80000042:	e290                	sd	a2,0(a3)

  // prepare information in scratch[] for timervec.
  // scratch[0..3] : space for timervec to save registers.
  // scratch[4] : address of CLINT MTIMECMP register.
  // scratch[5] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &mscratch0[32 * id];
    80000044:	0057979b          	slliw	a5,a5,0x5
    80000048:	078e                	slli	a5,a5,0x3
    8000004a:	00009617          	auipc	a2,0x9
    8000004e:	fe660613          	addi	a2,a2,-26 # 80009030 <mscratch0>
    80000052:	97b2                	add	a5,a5,a2
  scratch[4] = CLINT_MTIMECMP(id);
    80000054:	f394                	sd	a3,32(a5)
  scratch[5] = interval;
    80000056:	f798                	sd	a4,40(a5)
}

static inline void 
w_mscratch(uint64 x)
{
  asm volatile("csrw mscratch, %0" : : "r" (x));
    80000058:	34079073          	csrw	mscratch,a5
  asm volatile("csrw mtvec, %0" : : "r" (x));
    8000005c:	00006797          	auipc	a5,0x6
    80000060:	b2478793          	addi	a5,a5,-1244 # 80005b80 <timervec>
    80000064:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80000068:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    8000006c:	0087e793          	ori	a5,a5,8
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80000070:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie" : "=r" (x) );
    80000074:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    80000078:	0807e793          	ori	a5,a5,128
  asm volatile("csrw mie, %0" : : "r" (x));
    8000007c:	30479073          	csrw	mie,a5
}
    80000080:	6422                	ld	s0,8(sp)
    80000082:	0141                	addi	sp,sp,16
    80000084:	8082                	ret

0000000080000086 <start>:
{
    80000086:	1141                	addi	sp,sp,-16
    80000088:	e406                	sd	ra,8(sp)
    8000008a:	e022                	sd	s0,0(sp)
    8000008c:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    8000008e:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    80000092:	7779                	lui	a4,0xffffe
    80000094:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffd87ff>
    80000098:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    8000009a:	6705                	lui	a4,0x1
    8000009c:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    800000a0:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    800000a2:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    800000a6:	00001797          	auipc	a5,0x1
    800000aa:	e0478793          	addi	a5,a5,-508 # 80000eaa <main>
    800000ae:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    800000b2:	4781                	li	a5,0
    800000b4:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    800000b8:	67c1                	lui	a5,0x10
    800000ba:	17fd                	addi	a5,a5,-1 # ffff <_entry-0x7fff0001>
    800000bc:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    800000c0:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    800000c4:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    800000c8:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    800000cc:	10479073          	csrw	sie,a5
  timerinit();
    800000d0:	00000097          	auipc	ra,0x0
    800000d4:	f4c080e7          	jalr	-180(ra) # 8000001c <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    800000d8:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    800000dc:	2781                	sext.w	a5,a5
}

static inline void 
w_tp(uint64 x)
{
  asm volatile("mv tp, %0" : : "r" (x));
    800000de:	823e                	mv	tp,a5
  asm volatile("mret");
    800000e0:	30200073          	mret
}
    800000e4:	60a2                	ld	ra,8(sp)
    800000e6:	6402                	ld	s0,0(sp)
    800000e8:	0141                	addi	sp,sp,16
    800000ea:	8082                	ret

00000000800000ec <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    800000ec:	715d                	addi	sp,sp,-80
    800000ee:	e486                	sd	ra,72(sp)
    800000f0:	e0a2                	sd	s0,64(sp)
    800000f2:	fc26                	sd	s1,56(sp)
    800000f4:	f84a                	sd	s2,48(sp)
    800000f6:	f44e                	sd	s3,40(sp)
    800000f8:	f052                	sd	s4,32(sp)
    800000fa:	ec56                	sd	s5,24(sp)
    800000fc:	0880                	addi	s0,sp,80
    800000fe:	8a2a                	mv	s4,a0
    80000100:	84ae                	mv	s1,a1
    80000102:	89b2                	mv	s3,a2
  int i;

  acquire(&cons.lock);
    80000104:	00011517          	auipc	a0,0x11
    80000108:	72c50513          	addi	a0,a0,1836 # 80011830 <cons>
    8000010c:	00001097          	auipc	ra,0x1
    80000110:	af4080e7          	jalr	-1292(ra) # 80000c00 <acquire>
  for(i = 0; i < n; i++){
    80000114:	05305c63          	blez	s3,8000016c <consolewrite+0x80>
    80000118:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    8000011a:	5afd                	li	s5,-1
    8000011c:	4685                	li	a3,1
    8000011e:	8626                	mv	a2,s1
    80000120:	85d2                	mv	a1,s4
    80000122:	fbf40513          	addi	a0,s0,-65
    80000126:	00002097          	auipc	ra,0x2
    8000012a:	36a080e7          	jalr	874(ra) # 80002490 <either_copyin>
    8000012e:	01550d63          	beq	a0,s5,80000148 <consolewrite+0x5c>
      break;
    uartputc(c);
    80000132:	fbf44503          	lbu	a0,-65(s0)
    80000136:	00000097          	auipc	ra,0x0
    8000013a:	79a080e7          	jalr	1946(ra) # 800008d0 <uartputc>
  for(i = 0; i < n; i++){
    8000013e:	2905                	addiw	s2,s2,1
    80000140:	0485                	addi	s1,s1,1
    80000142:	fd299de3          	bne	s3,s2,8000011c <consolewrite+0x30>
    80000146:	894e                	mv	s2,s3
  }
  release(&cons.lock);
    80000148:	00011517          	auipc	a0,0x11
    8000014c:	6e850513          	addi	a0,a0,1768 # 80011830 <cons>
    80000150:	00001097          	auipc	ra,0x1
    80000154:	b64080e7          	jalr	-1180(ra) # 80000cb4 <release>

  return i;
}
    80000158:	854a                	mv	a0,s2
    8000015a:	60a6                	ld	ra,72(sp)
    8000015c:	6406                	ld	s0,64(sp)
    8000015e:	74e2                	ld	s1,56(sp)
    80000160:	7942                	ld	s2,48(sp)
    80000162:	79a2                	ld	s3,40(sp)
    80000164:	7a02                	ld	s4,32(sp)
    80000166:	6ae2                	ld	s5,24(sp)
    80000168:	6161                	addi	sp,sp,80
    8000016a:	8082                	ret
  for(i = 0; i < n; i++){
    8000016c:	4901                	li	s2,0
    8000016e:	bfe9                	j	80000148 <consolewrite+0x5c>

0000000080000170 <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    80000170:	7159                	addi	sp,sp,-112
    80000172:	f486                	sd	ra,104(sp)
    80000174:	f0a2                	sd	s0,96(sp)
    80000176:	eca6                	sd	s1,88(sp)
    80000178:	e8ca                	sd	s2,80(sp)
    8000017a:	e4ce                	sd	s3,72(sp)
    8000017c:	e0d2                	sd	s4,64(sp)
    8000017e:	fc56                	sd	s5,56(sp)
    80000180:	f85a                	sd	s6,48(sp)
    80000182:	f45e                	sd	s7,40(sp)
    80000184:	f062                	sd	s8,32(sp)
    80000186:	ec66                	sd	s9,24(sp)
    80000188:	e86a                	sd	s10,16(sp)
    8000018a:	1880                	addi	s0,sp,112
    8000018c:	8aaa                	mv	s5,a0
    8000018e:	8a2e                	mv	s4,a1
    80000190:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    80000192:	00060b1b          	sext.w	s6,a2
  acquire(&cons.lock);
    80000196:	00011517          	auipc	a0,0x11
    8000019a:	69a50513          	addi	a0,a0,1690 # 80011830 <cons>
    8000019e:	00001097          	auipc	ra,0x1
    800001a2:	a62080e7          	jalr	-1438(ra) # 80000c00 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    800001a6:	00011497          	auipc	s1,0x11
    800001aa:	68a48493          	addi	s1,s1,1674 # 80011830 <cons>
      if(myproc()->killed){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    800001ae:	00011917          	auipc	s2,0x11
    800001b2:	71a90913          	addi	s2,s2,1818 # 800118c8 <cons+0x98>
    }

    c = cons.buf[cons.r++ % INPUT_BUF];

    if(c == C('D')){  // end-of-file
    800001b6:	4b91                	li	s7,4
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    800001b8:	5c7d                	li	s8,-1
      break;

    dst++;
    --n;

    if(c == '\n'){
    800001ba:	4ca9                	li	s9,10
  while(n > 0){
    800001bc:	07305863          	blez	s3,8000022c <consoleread+0xbc>
    while(cons.r == cons.w){
    800001c0:	0984a783          	lw	a5,152(s1)
    800001c4:	09c4a703          	lw	a4,156(s1)
    800001c8:	02f71463          	bne	a4,a5,800001f0 <consoleread+0x80>
      if(myproc()->killed){
    800001cc:	00002097          	auipc	ra,0x2
    800001d0:	800080e7          	jalr	-2048(ra) # 800019cc <myproc>
    800001d4:	591c                	lw	a5,48(a0)
    800001d6:	e7b5                	bnez	a5,80000242 <consoleread+0xd2>
      sleep(&cons.r, &cons.lock);
    800001d8:	85a6                	mv	a1,s1
    800001da:	854a                	mv	a0,s2
    800001dc:	00002097          	auipc	ra,0x2
    800001e0:	004080e7          	jalr	4(ra) # 800021e0 <sleep>
    while(cons.r == cons.w){
    800001e4:	0984a783          	lw	a5,152(s1)
    800001e8:	09c4a703          	lw	a4,156(s1)
    800001ec:	fef700e3          	beq	a4,a5,800001cc <consoleread+0x5c>
    c = cons.buf[cons.r++ % INPUT_BUF];
    800001f0:	0017871b          	addiw	a4,a5,1
    800001f4:	08e4ac23          	sw	a4,152(s1)
    800001f8:	07f7f713          	andi	a4,a5,127
    800001fc:	9726                	add	a4,a4,s1
    800001fe:	01874703          	lbu	a4,24(a4)
    80000202:	00070d1b          	sext.w	s10,a4
    if(c == C('D')){  // end-of-file
    80000206:	077d0563          	beq	s10,s7,80000270 <consoleread+0x100>
    cbuf = c;
    8000020a:	f8e40fa3          	sb	a4,-97(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    8000020e:	4685                	li	a3,1
    80000210:	f9f40613          	addi	a2,s0,-97
    80000214:	85d2                	mv	a1,s4
    80000216:	8556                	mv	a0,s5
    80000218:	00002097          	auipc	ra,0x2
    8000021c:	222080e7          	jalr	546(ra) # 8000243a <either_copyout>
    80000220:	01850663          	beq	a0,s8,8000022c <consoleread+0xbc>
    dst++;
    80000224:	0a05                	addi	s4,s4,1
    --n;
    80000226:	39fd                	addiw	s3,s3,-1
    if(c == '\n'){
    80000228:	f99d1ae3          	bne	s10,s9,800001bc <consoleread+0x4c>
      // a whole line has arrived, return to
      // the user-level read().
      break;
    }
  }
  release(&cons.lock);
    8000022c:	00011517          	auipc	a0,0x11
    80000230:	60450513          	addi	a0,a0,1540 # 80011830 <cons>
    80000234:	00001097          	auipc	ra,0x1
    80000238:	a80080e7          	jalr	-1408(ra) # 80000cb4 <release>

  return target - n;
    8000023c:	413b053b          	subw	a0,s6,s3
    80000240:	a811                	j	80000254 <consoleread+0xe4>
        release(&cons.lock);
    80000242:	00011517          	auipc	a0,0x11
    80000246:	5ee50513          	addi	a0,a0,1518 # 80011830 <cons>
    8000024a:	00001097          	auipc	ra,0x1
    8000024e:	a6a080e7          	jalr	-1430(ra) # 80000cb4 <release>
        return -1;
    80000252:	557d                	li	a0,-1
}
    80000254:	70a6                	ld	ra,104(sp)
    80000256:	7406                	ld	s0,96(sp)
    80000258:	64e6                	ld	s1,88(sp)
    8000025a:	6946                	ld	s2,80(sp)
    8000025c:	69a6                	ld	s3,72(sp)
    8000025e:	6a06                	ld	s4,64(sp)
    80000260:	7ae2                	ld	s5,56(sp)
    80000262:	7b42                	ld	s6,48(sp)
    80000264:	7ba2                	ld	s7,40(sp)
    80000266:	7c02                	ld	s8,32(sp)
    80000268:	6ce2                	ld	s9,24(sp)
    8000026a:	6d42                	ld	s10,16(sp)
    8000026c:	6165                	addi	sp,sp,112
    8000026e:	8082                	ret
      if(n < target){
    80000270:	0009871b          	sext.w	a4,s3
    80000274:	fb677ce3          	bgeu	a4,s6,8000022c <consoleread+0xbc>
        cons.r--;
    80000278:	00011717          	auipc	a4,0x11
    8000027c:	64f72823          	sw	a5,1616(a4) # 800118c8 <cons+0x98>
    80000280:	b775                	j	8000022c <consoleread+0xbc>

0000000080000282 <consputc>:
{
    80000282:	1141                	addi	sp,sp,-16
    80000284:	e406                	sd	ra,8(sp)
    80000286:	e022                	sd	s0,0(sp)
    80000288:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    8000028a:	10000793          	li	a5,256
    8000028e:	00f50a63          	beq	a0,a5,800002a2 <consputc+0x20>
    uartputc_sync(c);
    80000292:	00000097          	auipc	ra,0x0
    80000296:	560080e7          	jalr	1376(ra) # 800007f2 <uartputc_sync>
}
    8000029a:	60a2                	ld	ra,8(sp)
    8000029c:	6402                	ld	s0,0(sp)
    8000029e:	0141                	addi	sp,sp,16
    800002a0:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    800002a2:	4521                	li	a0,8
    800002a4:	00000097          	auipc	ra,0x0
    800002a8:	54e080e7          	jalr	1358(ra) # 800007f2 <uartputc_sync>
    800002ac:	02000513          	li	a0,32
    800002b0:	00000097          	auipc	ra,0x0
    800002b4:	542080e7          	jalr	1346(ra) # 800007f2 <uartputc_sync>
    800002b8:	4521                	li	a0,8
    800002ba:	00000097          	auipc	ra,0x0
    800002be:	538080e7          	jalr	1336(ra) # 800007f2 <uartputc_sync>
    800002c2:	bfe1                	j	8000029a <consputc+0x18>

00000000800002c4 <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    800002c4:	1101                	addi	sp,sp,-32
    800002c6:	ec06                	sd	ra,24(sp)
    800002c8:	e822                	sd	s0,16(sp)
    800002ca:	e426                	sd	s1,8(sp)
    800002cc:	e04a                	sd	s2,0(sp)
    800002ce:	1000                	addi	s0,sp,32
    800002d0:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    800002d2:	00011517          	auipc	a0,0x11
    800002d6:	55e50513          	addi	a0,a0,1374 # 80011830 <cons>
    800002da:	00001097          	auipc	ra,0x1
    800002de:	926080e7          	jalr	-1754(ra) # 80000c00 <acquire>

  switch(c){
    800002e2:	47d5                	li	a5,21
    800002e4:	0af48663          	beq	s1,a5,80000390 <consoleintr+0xcc>
    800002e8:	0297ca63          	blt	a5,s1,8000031c <consoleintr+0x58>
    800002ec:	47a1                	li	a5,8
    800002ee:	0ef48763          	beq	s1,a5,800003dc <consoleintr+0x118>
    800002f2:	47c1                	li	a5,16
    800002f4:	10f49a63          	bne	s1,a5,80000408 <consoleintr+0x144>
  case C('P'):  // Print process list.
    procdump();
    800002f8:	00002097          	auipc	ra,0x2
    800002fc:	1ee080e7          	jalr	494(ra) # 800024e6 <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    80000300:	00011517          	auipc	a0,0x11
    80000304:	53050513          	addi	a0,a0,1328 # 80011830 <cons>
    80000308:	00001097          	auipc	ra,0x1
    8000030c:	9ac080e7          	jalr	-1620(ra) # 80000cb4 <release>
}
    80000310:	60e2                	ld	ra,24(sp)
    80000312:	6442                	ld	s0,16(sp)
    80000314:	64a2                	ld	s1,8(sp)
    80000316:	6902                	ld	s2,0(sp)
    80000318:	6105                	addi	sp,sp,32
    8000031a:	8082                	ret
  switch(c){
    8000031c:	07f00793          	li	a5,127
    80000320:	0af48e63          	beq	s1,a5,800003dc <consoleintr+0x118>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    80000324:	00011717          	auipc	a4,0x11
    80000328:	50c70713          	addi	a4,a4,1292 # 80011830 <cons>
    8000032c:	0a072783          	lw	a5,160(a4)
    80000330:	09872703          	lw	a4,152(a4)
    80000334:	9f99                	subw	a5,a5,a4
    80000336:	07f00713          	li	a4,127
    8000033a:	fcf763e3          	bltu	a4,a5,80000300 <consoleintr+0x3c>
      c = (c == '\r') ? '\n' : c;
    8000033e:	47b5                	li	a5,13
    80000340:	0cf48763          	beq	s1,a5,8000040e <consoleintr+0x14a>
      consputc(c);
    80000344:	8526                	mv	a0,s1
    80000346:	00000097          	auipc	ra,0x0
    8000034a:	f3c080e7          	jalr	-196(ra) # 80000282 <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    8000034e:	00011797          	auipc	a5,0x11
    80000352:	4e278793          	addi	a5,a5,1250 # 80011830 <cons>
    80000356:	0a07a703          	lw	a4,160(a5)
    8000035a:	0017069b          	addiw	a3,a4,1
    8000035e:	0006861b          	sext.w	a2,a3
    80000362:	0ad7a023          	sw	a3,160(a5)
    80000366:	07f77713          	andi	a4,a4,127
    8000036a:	97ba                	add	a5,a5,a4
    8000036c:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e == cons.r+INPUT_BUF){
    80000370:	47a9                	li	a5,10
    80000372:	0cf48563          	beq	s1,a5,8000043c <consoleintr+0x178>
    80000376:	4791                	li	a5,4
    80000378:	0cf48263          	beq	s1,a5,8000043c <consoleintr+0x178>
    8000037c:	00011797          	auipc	a5,0x11
    80000380:	54c7a783          	lw	a5,1356(a5) # 800118c8 <cons+0x98>
    80000384:	0807879b          	addiw	a5,a5,128
    80000388:	f6f61ce3          	bne	a2,a5,80000300 <consoleintr+0x3c>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    8000038c:	863e                	mv	a2,a5
    8000038e:	a07d                	j	8000043c <consoleintr+0x178>
    while(cons.e != cons.w &&
    80000390:	00011717          	auipc	a4,0x11
    80000394:	4a070713          	addi	a4,a4,1184 # 80011830 <cons>
    80000398:	0a072783          	lw	a5,160(a4)
    8000039c:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    800003a0:	00011497          	auipc	s1,0x11
    800003a4:	49048493          	addi	s1,s1,1168 # 80011830 <cons>
    while(cons.e != cons.w &&
    800003a8:	4929                	li	s2,10
    800003aa:	f4f70be3          	beq	a4,a5,80000300 <consoleintr+0x3c>
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    800003ae:	37fd                	addiw	a5,a5,-1
    800003b0:	07f7f713          	andi	a4,a5,127
    800003b4:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    800003b6:	01874703          	lbu	a4,24(a4)
    800003ba:	f52703e3          	beq	a4,s2,80000300 <consoleintr+0x3c>
      cons.e--;
    800003be:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    800003c2:	10000513          	li	a0,256
    800003c6:	00000097          	auipc	ra,0x0
    800003ca:	ebc080e7          	jalr	-324(ra) # 80000282 <consputc>
    while(cons.e != cons.w &&
    800003ce:	0a04a783          	lw	a5,160(s1)
    800003d2:	09c4a703          	lw	a4,156(s1)
    800003d6:	fcf71ce3          	bne	a4,a5,800003ae <consoleintr+0xea>
    800003da:	b71d                	j	80000300 <consoleintr+0x3c>
    if(cons.e != cons.w){
    800003dc:	00011717          	auipc	a4,0x11
    800003e0:	45470713          	addi	a4,a4,1108 # 80011830 <cons>
    800003e4:	0a072783          	lw	a5,160(a4)
    800003e8:	09c72703          	lw	a4,156(a4)
    800003ec:	f0f70ae3          	beq	a4,a5,80000300 <consoleintr+0x3c>
      cons.e--;
    800003f0:	37fd                	addiw	a5,a5,-1
    800003f2:	00011717          	auipc	a4,0x11
    800003f6:	4cf72f23          	sw	a5,1246(a4) # 800118d0 <cons+0xa0>
      consputc(BACKSPACE);
    800003fa:	10000513          	li	a0,256
    800003fe:	00000097          	auipc	ra,0x0
    80000402:	e84080e7          	jalr	-380(ra) # 80000282 <consputc>
    80000406:	bded                	j	80000300 <consoleintr+0x3c>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    80000408:	ee048ce3          	beqz	s1,80000300 <consoleintr+0x3c>
    8000040c:	bf21                	j	80000324 <consoleintr+0x60>
      consputc(c);
    8000040e:	4529                	li	a0,10
    80000410:	00000097          	auipc	ra,0x0
    80000414:	e72080e7          	jalr	-398(ra) # 80000282 <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80000418:	00011797          	auipc	a5,0x11
    8000041c:	41878793          	addi	a5,a5,1048 # 80011830 <cons>
    80000420:	0a07a703          	lw	a4,160(a5)
    80000424:	0017069b          	addiw	a3,a4,1
    80000428:	0006861b          	sext.w	a2,a3
    8000042c:	0ad7a023          	sw	a3,160(a5)
    80000430:	07f77713          	andi	a4,a4,127
    80000434:	97ba                	add	a5,a5,a4
    80000436:	4729                	li	a4,10
    80000438:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    8000043c:	00011797          	auipc	a5,0x11
    80000440:	48c7a823          	sw	a2,1168(a5) # 800118cc <cons+0x9c>
        wakeup(&cons.r);
    80000444:	00011517          	auipc	a0,0x11
    80000448:	48450513          	addi	a0,a0,1156 # 800118c8 <cons+0x98>
    8000044c:	00002097          	auipc	ra,0x2
    80000450:	f14080e7          	jalr	-236(ra) # 80002360 <wakeup>
    80000454:	b575                	j	80000300 <consoleintr+0x3c>

0000000080000456 <consoleinit>:

void
consoleinit(void)
{
    80000456:	1141                	addi	sp,sp,-16
    80000458:	e406                	sd	ra,8(sp)
    8000045a:	e022                	sd	s0,0(sp)
    8000045c:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    8000045e:	00008597          	auipc	a1,0x8
    80000462:	bb258593          	addi	a1,a1,-1102 # 80008010 <etext+0x10>
    80000466:	00011517          	auipc	a0,0x11
    8000046a:	3ca50513          	addi	a0,a0,970 # 80011830 <cons>
    8000046e:	00000097          	auipc	ra,0x0
    80000472:	702080e7          	jalr	1794(ra) # 80000b70 <initlock>

  uartinit();
    80000476:	00000097          	auipc	ra,0x0
    8000047a:	32c080e7          	jalr	812(ra) # 800007a2 <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    8000047e:	00021797          	auipc	a5,0x21
    80000482:	53278793          	addi	a5,a5,1330 # 800219b0 <devsw>
    80000486:	00000717          	auipc	a4,0x0
    8000048a:	cea70713          	addi	a4,a4,-790 # 80000170 <consoleread>
    8000048e:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    80000490:	00000717          	auipc	a4,0x0
    80000494:	c5c70713          	addi	a4,a4,-932 # 800000ec <consolewrite>
    80000498:	ef98                	sd	a4,24(a5)
}
    8000049a:	60a2                	ld	ra,8(sp)
    8000049c:	6402                	ld	s0,0(sp)
    8000049e:	0141                	addi	sp,sp,16
    800004a0:	8082                	ret

00000000800004a2 <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(int xx, int base, int sign)
{
    800004a2:	7179                	addi	sp,sp,-48
    800004a4:	f406                	sd	ra,40(sp)
    800004a6:	f022                	sd	s0,32(sp)
    800004a8:	ec26                	sd	s1,24(sp)
    800004aa:	e84a                	sd	s2,16(sp)
    800004ac:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    800004ae:	c219                	beqz	a2,800004b4 <printint+0x12>
    800004b0:	08054763          	bltz	a0,8000053e <printint+0x9c>
    x = -xx;
  else
    x = xx;
    800004b4:	2501                	sext.w	a0,a0
    800004b6:	4881                	li	a7,0
    800004b8:	fd040693          	addi	a3,s0,-48

  i = 0;
    800004bc:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    800004be:	2581                	sext.w	a1,a1
    800004c0:	00008617          	auipc	a2,0x8
    800004c4:	b8060613          	addi	a2,a2,-1152 # 80008040 <digits>
    800004c8:	883a                	mv	a6,a4
    800004ca:	2705                	addiw	a4,a4,1
    800004cc:	02b577bb          	remuw	a5,a0,a1
    800004d0:	1782                	slli	a5,a5,0x20
    800004d2:	9381                	srli	a5,a5,0x20
    800004d4:	97b2                	add	a5,a5,a2
    800004d6:	0007c783          	lbu	a5,0(a5)
    800004da:	00f68023          	sb	a5,0(a3)
  } while((x /= base) != 0);
    800004de:	0005079b          	sext.w	a5,a0
    800004e2:	02b5553b          	divuw	a0,a0,a1
    800004e6:	0685                	addi	a3,a3,1
    800004e8:	feb7f0e3          	bgeu	a5,a1,800004c8 <printint+0x26>

  if(sign)
    800004ec:	00088c63          	beqz	a7,80000504 <printint+0x62>
    buf[i++] = '-';
    800004f0:	fe070793          	addi	a5,a4,-32
    800004f4:	00878733          	add	a4,a5,s0
    800004f8:	02d00793          	li	a5,45
    800004fc:	fef70823          	sb	a5,-16(a4)
    80000500:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    80000504:	02e05763          	blez	a4,80000532 <printint+0x90>
    80000508:	fd040793          	addi	a5,s0,-48
    8000050c:	00e784b3          	add	s1,a5,a4
    80000510:	fff78913          	addi	s2,a5,-1
    80000514:	993a                	add	s2,s2,a4
    80000516:	377d                	addiw	a4,a4,-1
    80000518:	1702                	slli	a4,a4,0x20
    8000051a:	9301                	srli	a4,a4,0x20
    8000051c:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    80000520:	fff4c503          	lbu	a0,-1(s1)
    80000524:	00000097          	auipc	ra,0x0
    80000528:	d5e080e7          	jalr	-674(ra) # 80000282 <consputc>
  while(--i >= 0)
    8000052c:	14fd                	addi	s1,s1,-1
    8000052e:	ff2499e3          	bne	s1,s2,80000520 <printint+0x7e>
}
    80000532:	70a2                	ld	ra,40(sp)
    80000534:	7402                	ld	s0,32(sp)
    80000536:	64e2                	ld	s1,24(sp)
    80000538:	6942                	ld	s2,16(sp)
    8000053a:	6145                	addi	sp,sp,48
    8000053c:	8082                	ret
    x = -xx;
    8000053e:	40a0053b          	negw	a0,a0
  if(sign && (sign = xx < 0))
    80000542:	4885                	li	a7,1
    x = -xx;
    80000544:	bf95                	j	800004b8 <printint+0x16>

0000000080000546 <panic>:
    release(&pr.lock);
}

void
panic(char *s)
{
    80000546:	1101                	addi	sp,sp,-32
    80000548:	ec06                	sd	ra,24(sp)
    8000054a:	e822                	sd	s0,16(sp)
    8000054c:	e426                	sd	s1,8(sp)
    8000054e:	1000                	addi	s0,sp,32
    80000550:	84aa                	mv	s1,a0
  pr.locking = 0;
    80000552:	00011797          	auipc	a5,0x11
    80000556:	3807af23          	sw	zero,926(a5) # 800118f0 <pr+0x18>
  printf("panic: ");
    8000055a:	00008517          	auipc	a0,0x8
    8000055e:	abe50513          	addi	a0,a0,-1346 # 80008018 <etext+0x18>
    80000562:	00000097          	auipc	ra,0x0
    80000566:	02e080e7          	jalr	46(ra) # 80000590 <printf>
  printf(s);
    8000056a:	8526                	mv	a0,s1
    8000056c:	00000097          	auipc	ra,0x0
    80000570:	024080e7          	jalr	36(ra) # 80000590 <printf>
  printf("\n");
    80000574:	00008517          	auipc	a0,0x8
    80000578:	b5450513          	addi	a0,a0,-1196 # 800080c8 <digits+0x88>
    8000057c:	00000097          	auipc	ra,0x0
    80000580:	014080e7          	jalr	20(ra) # 80000590 <printf>
  panicked = 1; // freeze uart output from other CPUs
    80000584:	4785                	li	a5,1
    80000586:	00009717          	auipc	a4,0x9
    8000058a:	a6f72d23          	sw	a5,-1414(a4) # 80009000 <panicked>
  for(;;)
    8000058e:	a001                	j	8000058e <panic+0x48>

0000000080000590 <printf>:
{
    80000590:	7131                	addi	sp,sp,-192
    80000592:	fc86                	sd	ra,120(sp)
    80000594:	f8a2                	sd	s0,112(sp)
    80000596:	f4a6                	sd	s1,104(sp)
    80000598:	f0ca                	sd	s2,96(sp)
    8000059a:	ecce                	sd	s3,88(sp)
    8000059c:	e8d2                	sd	s4,80(sp)
    8000059e:	e4d6                	sd	s5,72(sp)
    800005a0:	e0da                	sd	s6,64(sp)
    800005a2:	fc5e                	sd	s7,56(sp)
    800005a4:	f862                	sd	s8,48(sp)
    800005a6:	f466                	sd	s9,40(sp)
    800005a8:	f06a                	sd	s10,32(sp)
    800005aa:	ec6e                	sd	s11,24(sp)
    800005ac:	0100                	addi	s0,sp,128
    800005ae:	8a2a                	mv	s4,a0
    800005b0:	e40c                	sd	a1,8(s0)
    800005b2:	e810                	sd	a2,16(s0)
    800005b4:	ec14                	sd	a3,24(s0)
    800005b6:	f018                	sd	a4,32(s0)
    800005b8:	f41c                	sd	a5,40(s0)
    800005ba:	03043823          	sd	a6,48(s0)
    800005be:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    800005c2:	00011d97          	auipc	s11,0x11
    800005c6:	32edad83          	lw	s11,814(s11) # 800118f0 <pr+0x18>
  if(locking)
    800005ca:	020d9b63          	bnez	s11,80000600 <printf+0x70>
  if (fmt == 0)
    800005ce:	040a0263          	beqz	s4,80000612 <printf+0x82>
  va_start(ap, fmt);
    800005d2:	00840793          	addi	a5,s0,8
    800005d6:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    800005da:	000a4503          	lbu	a0,0(s4)
    800005de:	14050f63          	beqz	a0,8000073c <printf+0x1ac>
    800005e2:	4981                	li	s3,0
    if(c != '%'){
    800005e4:	02500a93          	li	s5,37
    switch(c){
    800005e8:	07000b93          	li	s7,112
  consputc('x');
    800005ec:	4d41                	li	s10,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    800005ee:	00008b17          	auipc	s6,0x8
    800005f2:	a52b0b13          	addi	s6,s6,-1454 # 80008040 <digits>
    switch(c){
    800005f6:	07300c93          	li	s9,115
    800005fa:	06400c13          	li	s8,100
    800005fe:	a82d                	j	80000638 <printf+0xa8>
    acquire(&pr.lock);
    80000600:	00011517          	auipc	a0,0x11
    80000604:	2d850513          	addi	a0,a0,728 # 800118d8 <pr>
    80000608:	00000097          	auipc	ra,0x0
    8000060c:	5f8080e7          	jalr	1528(ra) # 80000c00 <acquire>
    80000610:	bf7d                	j	800005ce <printf+0x3e>
    panic("null fmt");
    80000612:	00008517          	auipc	a0,0x8
    80000616:	a1650513          	addi	a0,a0,-1514 # 80008028 <etext+0x28>
    8000061a:	00000097          	auipc	ra,0x0
    8000061e:	f2c080e7          	jalr	-212(ra) # 80000546 <panic>
      consputc(c);
    80000622:	00000097          	auipc	ra,0x0
    80000626:	c60080e7          	jalr	-928(ra) # 80000282 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    8000062a:	2985                	addiw	s3,s3,1
    8000062c:	013a07b3          	add	a5,s4,s3
    80000630:	0007c503          	lbu	a0,0(a5)
    80000634:	10050463          	beqz	a0,8000073c <printf+0x1ac>
    if(c != '%'){
    80000638:	ff5515e3          	bne	a0,s5,80000622 <printf+0x92>
    c = fmt[++i] & 0xff;
    8000063c:	2985                	addiw	s3,s3,1
    8000063e:	013a07b3          	add	a5,s4,s3
    80000642:	0007c783          	lbu	a5,0(a5)
    80000646:	0007849b          	sext.w	s1,a5
    if(c == 0)
    8000064a:	cbed                	beqz	a5,8000073c <printf+0x1ac>
    switch(c){
    8000064c:	05778a63          	beq	a5,s7,800006a0 <printf+0x110>
    80000650:	02fbf663          	bgeu	s7,a5,8000067c <printf+0xec>
    80000654:	09978863          	beq	a5,s9,800006e4 <printf+0x154>
    80000658:	07800713          	li	a4,120
    8000065c:	0ce79563          	bne	a5,a4,80000726 <printf+0x196>
      printint(va_arg(ap, int), 16, 1);
    80000660:	f8843783          	ld	a5,-120(s0)
    80000664:	00878713          	addi	a4,a5,8
    80000668:	f8e43423          	sd	a4,-120(s0)
    8000066c:	4605                	li	a2,1
    8000066e:	85ea                	mv	a1,s10
    80000670:	4388                	lw	a0,0(a5)
    80000672:	00000097          	auipc	ra,0x0
    80000676:	e30080e7          	jalr	-464(ra) # 800004a2 <printint>
      break;
    8000067a:	bf45                	j	8000062a <printf+0x9a>
    switch(c){
    8000067c:	09578f63          	beq	a5,s5,8000071a <printf+0x18a>
    80000680:	0b879363          	bne	a5,s8,80000726 <printf+0x196>
      printint(va_arg(ap, int), 10, 1);
    80000684:	f8843783          	ld	a5,-120(s0)
    80000688:	00878713          	addi	a4,a5,8
    8000068c:	f8e43423          	sd	a4,-120(s0)
    80000690:	4605                	li	a2,1
    80000692:	45a9                	li	a1,10
    80000694:	4388                	lw	a0,0(a5)
    80000696:	00000097          	auipc	ra,0x0
    8000069a:	e0c080e7          	jalr	-500(ra) # 800004a2 <printint>
      break;
    8000069e:	b771                	j	8000062a <printf+0x9a>
      printptr(va_arg(ap, uint64));
    800006a0:	f8843783          	ld	a5,-120(s0)
    800006a4:	00878713          	addi	a4,a5,8
    800006a8:	f8e43423          	sd	a4,-120(s0)
    800006ac:	0007b903          	ld	s2,0(a5)
  consputc('0');
    800006b0:	03000513          	li	a0,48
    800006b4:	00000097          	auipc	ra,0x0
    800006b8:	bce080e7          	jalr	-1074(ra) # 80000282 <consputc>
  consputc('x');
    800006bc:	07800513          	li	a0,120
    800006c0:	00000097          	auipc	ra,0x0
    800006c4:	bc2080e7          	jalr	-1086(ra) # 80000282 <consputc>
    800006c8:	84ea                	mv	s1,s10
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    800006ca:	03c95793          	srli	a5,s2,0x3c
    800006ce:	97da                	add	a5,a5,s6
    800006d0:	0007c503          	lbu	a0,0(a5)
    800006d4:	00000097          	auipc	ra,0x0
    800006d8:	bae080e7          	jalr	-1106(ra) # 80000282 <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    800006dc:	0912                	slli	s2,s2,0x4
    800006de:	34fd                	addiw	s1,s1,-1
    800006e0:	f4ed                	bnez	s1,800006ca <printf+0x13a>
    800006e2:	b7a1                	j	8000062a <printf+0x9a>
      if((s = va_arg(ap, char*)) == 0)
    800006e4:	f8843783          	ld	a5,-120(s0)
    800006e8:	00878713          	addi	a4,a5,8
    800006ec:	f8e43423          	sd	a4,-120(s0)
    800006f0:	6384                	ld	s1,0(a5)
    800006f2:	cc89                	beqz	s1,8000070c <printf+0x17c>
      for(; *s; s++)
    800006f4:	0004c503          	lbu	a0,0(s1)
    800006f8:	d90d                	beqz	a0,8000062a <printf+0x9a>
        consputc(*s);
    800006fa:	00000097          	auipc	ra,0x0
    800006fe:	b88080e7          	jalr	-1144(ra) # 80000282 <consputc>
      for(; *s; s++)
    80000702:	0485                	addi	s1,s1,1
    80000704:	0004c503          	lbu	a0,0(s1)
    80000708:	f96d                	bnez	a0,800006fa <printf+0x16a>
    8000070a:	b705                	j	8000062a <printf+0x9a>
        s = "(null)";
    8000070c:	00008497          	auipc	s1,0x8
    80000710:	91448493          	addi	s1,s1,-1772 # 80008020 <etext+0x20>
      for(; *s; s++)
    80000714:	02800513          	li	a0,40
    80000718:	b7cd                	j	800006fa <printf+0x16a>
      consputc('%');
    8000071a:	8556                	mv	a0,s5
    8000071c:	00000097          	auipc	ra,0x0
    80000720:	b66080e7          	jalr	-1178(ra) # 80000282 <consputc>
      break;
    80000724:	b719                	j	8000062a <printf+0x9a>
      consputc('%');
    80000726:	8556                	mv	a0,s5
    80000728:	00000097          	auipc	ra,0x0
    8000072c:	b5a080e7          	jalr	-1190(ra) # 80000282 <consputc>
      consputc(c);
    80000730:	8526                	mv	a0,s1
    80000732:	00000097          	auipc	ra,0x0
    80000736:	b50080e7          	jalr	-1200(ra) # 80000282 <consputc>
      break;
    8000073a:	bdc5                	j	8000062a <printf+0x9a>
  if(locking)
    8000073c:	020d9163          	bnez	s11,8000075e <printf+0x1ce>
}
    80000740:	70e6                	ld	ra,120(sp)
    80000742:	7446                	ld	s0,112(sp)
    80000744:	74a6                	ld	s1,104(sp)
    80000746:	7906                	ld	s2,96(sp)
    80000748:	69e6                	ld	s3,88(sp)
    8000074a:	6a46                	ld	s4,80(sp)
    8000074c:	6aa6                	ld	s5,72(sp)
    8000074e:	6b06                	ld	s6,64(sp)
    80000750:	7be2                	ld	s7,56(sp)
    80000752:	7c42                	ld	s8,48(sp)
    80000754:	7ca2                	ld	s9,40(sp)
    80000756:	7d02                	ld	s10,32(sp)
    80000758:	6de2                	ld	s11,24(sp)
    8000075a:	6129                	addi	sp,sp,192
    8000075c:	8082                	ret
    release(&pr.lock);
    8000075e:	00011517          	auipc	a0,0x11
    80000762:	17a50513          	addi	a0,a0,378 # 800118d8 <pr>
    80000766:	00000097          	auipc	ra,0x0
    8000076a:	54e080e7          	jalr	1358(ra) # 80000cb4 <release>
}
    8000076e:	bfc9                	j	80000740 <printf+0x1b0>

0000000080000770 <printfinit>:
    ;
}

void
printfinit(void)
{
    80000770:	1101                	addi	sp,sp,-32
    80000772:	ec06                	sd	ra,24(sp)
    80000774:	e822                	sd	s0,16(sp)
    80000776:	e426                	sd	s1,8(sp)
    80000778:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    8000077a:	00011497          	auipc	s1,0x11
    8000077e:	15e48493          	addi	s1,s1,350 # 800118d8 <pr>
    80000782:	00008597          	auipc	a1,0x8
    80000786:	8b658593          	addi	a1,a1,-1866 # 80008038 <etext+0x38>
    8000078a:	8526                	mv	a0,s1
    8000078c:	00000097          	auipc	ra,0x0
    80000790:	3e4080e7          	jalr	996(ra) # 80000b70 <initlock>
  pr.locking = 1;
    80000794:	4785                	li	a5,1
    80000796:	cc9c                	sw	a5,24(s1)
}
    80000798:	60e2                	ld	ra,24(sp)
    8000079a:	6442                	ld	s0,16(sp)
    8000079c:	64a2                	ld	s1,8(sp)
    8000079e:	6105                	addi	sp,sp,32
    800007a0:	8082                	ret

00000000800007a2 <uartinit>:

void uartstart();

void
uartinit(void)
{
    800007a2:	1141                	addi	sp,sp,-16
    800007a4:	e406                	sd	ra,8(sp)
    800007a6:	e022                	sd	s0,0(sp)
    800007a8:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    800007aa:	100007b7          	lui	a5,0x10000
    800007ae:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    800007b2:	f8000713          	li	a4,-128
    800007b6:	00e781a3          	sb	a4,3(a5)

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    800007ba:	470d                	li	a4,3
    800007bc:	00e78023          	sb	a4,0(a5)

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    800007c0:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    800007c4:	00e781a3          	sb	a4,3(a5)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    800007c8:	469d                	li	a3,7
    800007ca:	00d78123          	sb	a3,2(a5)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    800007ce:	00e780a3          	sb	a4,1(a5)

  initlock(&uart_tx_lock, "uart");
    800007d2:	00008597          	auipc	a1,0x8
    800007d6:	88658593          	addi	a1,a1,-1914 # 80008058 <digits+0x18>
    800007da:	00011517          	auipc	a0,0x11
    800007de:	11e50513          	addi	a0,a0,286 # 800118f8 <uart_tx_lock>
    800007e2:	00000097          	auipc	ra,0x0
    800007e6:	38e080e7          	jalr	910(ra) # 80000b70 <initlock>
}
    800007ea:	60a2                	ld	ra,8(sp)
    800007ec:	6402                	ld	s0,0(sp)
    800007ee:	0141                	addi	sp,sp,16
    800007f0:	8082                	ret

00000000800007f2 <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    800007f2:	1101                	addi	sp,sp,-32
    800007f4:	ec06                	sd	ra,24(sp)
    800007f6:	e822                	sd	s0,16(sp)
    800007f8:	e426                	sd	s1,8(sp)
    800007fa:	1000                	addi	s0,sp,32
    800007fc:	84aa                	mv	s1,a0
  push_off();
    800007fe:	00000097          	auipc	ra,0x0
    80000802:	3b6080e7          	jalr	950(ra) # 80000bb4 <push_off>

  if(panicked){
    80000806:	00008797          	auipc	a5,0x8
    8000080a:	7fa7a783          	lw	a5,2042(a5) # 80009000 <panicked>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    8000080e:	10000737          	lui	a4,0x10000
  if(panicked){
    80000812:	c391                	beqz	a5,80000816 <uartputc_sync+0x24>
    for(;;)
    80000814:	a001                	j	80000814 <uartputc_sync+0x22>
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80000816:	00574783          	lbu	a5,5(a4) # 10000005 <_entry-0x6ffffffb>
    8000081a:	0207f793          	andi	a5,a5,32
    8000081e:	dfe5                	beqz	a5,80000816 <uartputc_sync+0x24>
    ;
  WriteReg(THR, c);
    80000820:	0ff4f513          	zext.b	a0,s1
    80000824:	100007b7          	lui	a5,0x10000
    80000828:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  pop_off();
    8000082c:	00000097          	auipc	ra,0x0
    80000830:	428080e7          	jalr	1064(ra) # 80000c54 <pop_off>
}
    80000834:	60e2                	ld	ra,24(sp)
    80000836:	6442                	ld	s0,16(sp)
    80000838:	64a2                	ld	s1,8(sp)
    8000083a:	6105                	addi	sp,sp,32
    8000083c:	8082                	ret

000000008000083e <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    8000083e:	00008797          	auipc	a5,0x8
    80000842:	7c67a783          	lw	a5,1990(a5) # 80009004 <uart_tx_r>
    80000846:	00008717          	auipc	a4,0x8
    8000084a:	7c272703          	lw	a4,1986(a4) # 80009008 <uart_tx_w>
    8000084e:	08f70063          	beq	a4,a5,800008ce <uartstart+0x90>
{
    80000852:	7139                	addi	sp,sp,-64
    80000854:	fc06                	sd	ra,56(sp)
    80000856:	f822                	sd	s0,48(sp)
    80000858:	f426                	sd	s1,40(sp)
    8000085a:	f04a                	sd	s2,32(sp)
    8000085c:	ec4e                	sd	s3,24(sp)
    8000085e:	e852                	sd	s4,16(sp)
    80000860:	e456                	sd	s5,8(sp)
    80000862:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80000864:	10000937          	lui	s2,0x10000
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r];
    80000868:	00011a97          	auipc	s5,0x11
    8000086c:	090a8a93          	addi	s5,s5,144 # 800118f8 <uart_tx_lock>
    uart_tx_r = (uart_tx_r + 1) % UART_TX_BUF_SIZE;
    80000870:	00008497          	auipc	s1,0x8
    80000874:	79448493          	addi	s1,s1,1940 # 80009004 <uart_tx_r>
    if(uart_tx_w == uart_tx_r){
    80000878:	00008a17          	auipc	s4,0x8
    8000087c:	790a0a13          	addi	s4,s4,1936 # 80009008 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80000880:	00594703          	lbu	a4,5(s2) # 10000005 <_entry-0x6ffffffb>
    80000884:	02077713          	andi	a4,a4,32
    80000888:	cb15                	beqz	a4,800008bc <uartstart+0x7e>
    int c = uart_tx_buf[uart_tx_r];
    8000088a:	00fa8733          	add	a4,s5,a5
    8000088e:	01874983          	lbu	s3,24(a4)
    uart_tx_r = (uart_tx_r + 1) % UART_TX_BUF_SIZE;
    80000892:	2785                	addiw	a5,a5,1
    80000894:	41f7d71b          	sraiw	a4,a5,0x1f
    80000898:	01b7571b          	srliw	a4,a4,0x1b
    8000089c:	9fb9                	addw	a5,a5,a4
    8000089e:	8bfd                	andi	a5,a5,31
    800008a0:	9f99                	subw	a5,a5,a4
    800008a2:	c09c                	sw	a5,0(s1)
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    800008a4:	8526                	mv	a0,s1
    800008a6:	00002097          	auipc	ra,0x2
    800008aa:	aba080e7          	jalr	-1350(ra) # 80002360 <wakeup>
    
    WriteReg(THR, c);
    800008ae:	01390023          	sb	s3,0(s2)
    if(uart_tx_w == uart_tx_r){
    800008b2:	409c                	lw	a5,0(s1)
    800008b4:	000a2703          	lw	a4,0(s4)
    800008b8:	fcf714e3          	bne	a4,a5,80000880 <uartstart+0x42>
  }
}
    800008bc:	70e2                	ld	ra,56(sp)
    800008be:	7442                	ld	s0,48(sp)
    800008c0:	74a2                	ld	s1,40(sp)
    800008c2:	7902                	ld	s2,32(sp)
    800008c4:	69e2                	ld	s3,24(sp)
    800008c6:	6a42                	ld	s4,16(sp)
    800008c8:	6aa2                	ld	s5,8(sp)
    800008ca:	6121                	addi	sp,sp,64
    800008cc:	8082                	ret
    800008ce:	8082                	ret

00000000800008d0 <uartputc>:
{
    800008d0:	7179                	addi	sp,sp,-48
    800008d2:	f406                	sd	ra,40(sp)
    800008d4:	f022                	sd	s0,32(sp)
    800008d6:	ec26                	sd	s1,24(sp)
    800008d8:	e84a                	sd	s2,16(sp)
    800008da:	e44e                	sd	s3,8(sp)
    800008dc:	e052                	sd	s4,0(sp)
    800008de:	1800                	addi	s0,sp,48
    800008e0:	84aa                	mv	s1,a0
  acquire(&uart_tx_lock);
    800008e2:	00011517          	auipc	a0,0x11
    800008e6:	01650513          	addi	a0,a0,22 # 800118f8 <uart_tx_lock>
    800008ea:	00000097          	auipc	ra,0x0
    800008ee:	316080e7          	jalr	790(ra) # 80000c00 <acquire>
  if(panicked){
    800008f2:	00008797          	auipc	a5,0x8
    800008f6:	70e7a783          	lw	a5,1806(a5) # 80009000 <panicked>
    800008fa:	c391                	beqz	a5,800008fe <uartputc+0x2e>
    for(;;)
    800008fc:	a001                	j	800008fc <uartputc+0x2c>
    if(((uart_tx_w + 1) % UART_TX_BUF_SIZE) == uart_tx_r){
    800008fe:	00008697          	auipc	a3,0x8
    80000902:	70a6a683          	lw	a3,1802(a3) # 80009008 <uart_tx_w>
    80000906:	0016879b          	addiw	a5,a3,1
    8000090a:	41f7d71b          	sraiw	a4,a5,0x1f
    8000090e:	01b7571b          	srliw	a4,a4,0x1b
    80000912:	9fb9                	addw	a5,a5,a4
    80000914:	8bfd                	andi	a5,a5,31
    80000916:	9f99                	subw	a5,a5,a4
    80000918:	00008717          	auipc	a4,0x8
    8000091c:	6ec72703          	lw	a4,1772(a4) # 80009004 <uart_tx_r>
    80000920:	04f71363          	bne	a4,a5,80000966 <uartputc+0x96>
      sleep(&uart_tx_r, &uart_tx_lock);
    80000924:	00011a17          	auipc	s4,0x11
    80000928:	fd4a0a13          	addi	s4,s4,-44 # 800118f8 <uart_tx_lock>
    8000092c:	00008917          	auipc	s2,0x8
    80000930:	6d890913          	addi	s2,s2,1752 # 80009004 <uart_tx_r>
    if(((uart_tx_w + 1) % UART_TX_BUF_SIZE) == uart_tx_r){
    80000934:	00008997          	auipc	s3,0x8
    80000938:	6d498993          	addi	s3,s3,1748 # 80009008 <uart_tx_w>
      sleep(&uart_tx_r, &uart_tx_lock);
    8000093c:	85d2                	mv	a1,s4
    8000093e:	854a                	mv	a0,s2
    80000940:	00002097          	auipc	ra,0x2
    80000944:	8a0080e7          	jalr	-1888(ra) # 800021e0 <sleep>
    if(((uart_tx_w + 1) % UART_TX_BUF_SIZE) == uart_tx_r){
    80000948:	0009a683          	lw	a3,0(s3)
    8000094c:	0016879b          	addiw	a5,a3,1
    80000950:	41f7d71b          	sraiw	a4,a5,0x1f
    80000954:	01b7571b          	srliw	a4,a4,0x1b
    80000958:	9fb9                	addw	a5,a5,a4
    8000095a:	8bfd                	andi	a5,a5,31
    8000095c:	9f99                	subw	a5,a5,a4
    8000095e:	00092703          	lw	a4,0(s2)
    80000962:	fcf70de3          	beq	a4,a5,8000093c <uartputc+0x6c>
      uart_tx_buf[uart_tx_w] = c;
    80000966:	00011917          	auipc	s2,0x11
    8000096a:	f9290913          	addi	s2,s2,-110 # 800118f8 <uart_tx_lock>
    8000096e:	96ca                	add	a3,a3,s2
    80000970:	00968c23          	sb	s1,24(a3)
      uart_tx_w = (uart_tx_w + 1) % UART_TX_BUF_SIZE;
    80000974:	00008717          	auipc	a4,0x8
    80000978:	68f72a23          	sw	a5,1684(a4) # 80009008 <uart_tx_w>
      uartstart();
    8000097c:	00000097          	auipc	ra,0x0
    80000980:	ec2080e7          	jalr	-318(ra) # 8000083e <uartstart>
      release(&uart_tx_lock);
    80000984:	854a                	mv	a0,s2
    80000986:	00000097          	auipc	ra,0x0
    8000098a:	32e080e7          	jalr	814(ra) # 80000cb4 <release>
}
    8000098e:	70a2                	ld	ra,40(sp)
    80000990:	7402                	ld	s0,32(sp)
    80000992:	64e2                	ld	s1,24(sp)
    80000994:	6942                	ld	s2,16(sp)
    80000996:	69a2                	ld	s3,8(sp)
    80000998:	6a02                	ld	s4,0(sp)
    8000099a:	6145                	addi	sp,sp,48
    8000099c:	8082                	ret

000000008000099e <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    8000099e:	1141                	addi	sp,sp,-16
    800009a0:	e422                	sd	s0,8(sp)
    800009a2:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    800009a4:	100007b7          	lui	a5,0x10000
    800009a8:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    800009ac:	8b85                	andi	a5,a5,1
    800009ae:	cb81                	beqz	a5,800009be <uartgetc+0x20>
    // input data is ready.
    return ReadReg(RHR);
    800009b0:	100007b7          	lui	a5,0x10000
    800009b4:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
  } else {
    return -1;
  }
}
    800009b8:	6422                	ld	s0,8(sp)
    800009ba:	0141                	addi	sp,sp,16
    800009bc:	8082                	ret
    return -1;
    800009be:	557d                	li	a0,-1
    800009c0:	bfe5                	j	800009b8 <uartgetc+0x1a>

00000000800009c2 <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from trap.c.
void
uartintr(void)
{
    800009c2:	1101                	addi	sp,sp,-32
    800009c4:	ec06                	sd	ra,24(sp)
    800009c6:	e822                	sd	s0,16(sp)
    800009c8:	e426                	sd	s1,8(sp)
    800009ca:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    800009cc:	54fd                	li	s1,-1
    800009ce:	a029                	j	800009d8 <uartintr+0x16>
      break;
    consoleintr(c);
    800009d0:	00000097          	auipc	ra,0x0
    800009d4:	8f4080e7          	jalr	-1804(ra) # 800002c4 <consoleintr>
    int c = uartgetc();
    800009d8:	00000097          	auipc	ra,0x0
    800009dc:	fc6080e7          	jalr	-58(ra) # 8000099e <uartgetc>
    if(c == -1)
    800009e0:	fe9518e3          	bne	a0,s1,800009d0 <uartintr+0xe>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    800009e4:	00011497          	auipc	s1,0x11
    800009e8:	f1448493          	addi	s1,s1,-236 # 800118f8 <uart_tx_lock>
    800009ec:	8526                	mv	a0,s1
    800009ee:	00000097          	auipc	ra,0x0
    800009f2:	212080e7          	jalr	530(ra) # 80000c00 <acquire>
  uartstart();
    800009f6:	00000097          	auipc	ra,0x0
    800009fa:	e48080e7          	jalr	-440(ra) # 8000083e <uartstart>
  release(&uart_tx_lock);
    800009fe:	8526                	mv	a0,s1
    80000a00:	00000097          	auipc	ra,0x0
    80000a04:	2b4080e7          	jalr	692(ra) # 80000cb4 <release>
}
    80000a08:	60e2                	ld	ra,24(sp)
    80000a0a:	6442                	ld	s0,16(sp)
    80000a0c:	64a2                	ld	s1,8(sp)
    80000a0e:	6105                	addi	sp,sp,32
    80000a10:	8082                	ret

0000000080000a12 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
    80000a12:	1101                	addi	sp,sp,-32
    80000a14:	ec06                	sd	ra,24(sp)
    80000a16:	e822                	sd	s0,16(sp)
    80000a18:	e426                	sd	s1,8(sp)
    80000a1a:	e04a                	sd	s2,0(sp)
    80000a1c:	1000                	addi	s0,sp,32
  struct run *r;
  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    80000a1e:	03451793          	slli	a5,a0,0x34
    80000a22:	ebb9                	bnez	a5,80000a78 <kfree+0x66>
    80000a24:	84aa                	mv	s1,a0
    80000a26:	00025797          	auipc	a5,0x25
    80000a2a:	5da78793          	addi	a5,a5,1498 # 80026000 <end>
    80000a2e:	04f56563          	bltu	a0,a5,80000a78 <kfree+0x66>
    80000a32:	47c5                	li	a5,17
    80000a34:	07ee                	slli	a5,a5,0x1b
    80000a36:	04f57163          	bgeu	a0,a5,80000a78 <kfree+0x66>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);
    80000a3a:	6605                	lui	a2,0x1
    80000a3c:	4585                	li	a1,1
    80000a3e:	00000097          	auipc	ra,0x0
    80000a42:	2be080e7          	jalr	702(ra) # 80000cfc <memset>

  r = (struct run*)pa;

  acquire(&kmem.lock);
    80000a46:	00011917          	auipc	s2,0x11
    80000a4a:	eea90913          	addi	s2,s2,-278 # 80011930 <kmem>
    80000a4e:	854a                	mv	a0,s2
    80000a50:	00000097          	auipc	ra,0x0
    80000a54:	1b0080e7          	jalr	432(ra) # 80000c00 <acquire>
  r->next = kmem.freelist;
    80000a58:	01893783          	ld	a5,24(s2)
    80000a5c:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000a5e:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    80000a62:	854a                	mv	a0,s2
    80000a64:	00000097          	auipc	ra,0x0
    80000a68:	250080e7          	jalr	592(ra) # 80000cb4 <release>
}
    80000a6c:	60e2                	ld	ra,24(sp)
    80000a6e:	6442                	ld	s0,16(sp)
    80000a70:	64a2                	ld	s1,8(sp)
    80000a72:	6902                	ld	s2,0(sp)
    80000a74:	6105                	addi	sp,sp,32
    80000a76:	8082                	ret
    panic("kfree");
    80000a78:	00007517          	auipc	a0,0x7
    80000a7c:	5e850513          	addi	a0,a0,1512 # 80008060 <digits+0x20>
    80000a80:	00000097          	auipc	ra,0x0
    80000a84:	ac6080e7          	jalr	-1338(ra) # 80000546 <panic>

0000000080000a88 <freerange>:
{
    80000a88:	7179                	addi	sp,sp,-48
    80000a8a:	f406                	sd	ra,40(sp)
    80000a8c:	f022                	sd	s0,32(sp)
    80000a8e:	ec26                	sd	s1,24(sp)
    80000a90:	e84a                	sd	s2,16(sp)
    80000a92:	e44e                	sd	s3,8(sp)
    80000a94:	e052                	sd	s4,0(sp)
    80000a96:	1800                	addi	s0,sp,48
  p = (char*)PGROUNDUP((uint64)pa_start);
    80000a98:	6785                	lui	a5,0x1
    80000a9a:	fff78713          	addi	a4,a5,-1 # fff <_entry-0x7ffff001>
    80000a9e:	00e504b3          	add	s1,a0,a4
    80000aa2:	777d                	lui	a4,0xfffff
    80000aa4:	8cf9                	and	s1,s1,a4
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000aa6:	94be                	add	s1,s1,a5
    80000aa8:	0095ee63          	bltu	a1,s1,80000ac4 <freerange+0x3c>
    80000aac:	892e                	mv	s2,a1
    kfree(p);
    80000aae:	7a7d                	lui	s4,0xfffff
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000ab0:	6985                	lui	s3,0x1
    kfree(p);
    80000ab2:	01448533          	add	a0,s1,s4
    80000ab6:	00000097          	auipc	ra,0x0
    80000aba:	f5c080e7          	jalr	-164(ra) # 80000a12 <kfree>
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000abe:	94ce                	add	s1,s1,s3
    80000ac0:	fe9979e3          	bgeu	s2,s1,80000ab2 <freerange+0x2a>
}
    80000ac4:	70a2                	ld	ra,40(sp)
    80000ac6:	7402                	ld	s0,32(sp)
    80000ac8:	64e2                	ld	s1,24(sp)
    80000aca:	6942                	ld	s2,16(sp)
    80000acc:	69a2                	ld	s3,8(sp)
    80000ace:	6a02                	ld	s4,0(sp)
    80000ad0:	6145                	addi	sp,sp,48
    80000ad2:	8082                	ret

0000000080000ad4 <kinit>:
{
    80000ad4:	1141                	addi	sp,sp,-16
    80000ad6:	e406                	sd	ra,8(sp)
    80000ad8:	e022                	sd	s0,0(sp)
    80000ada:	0800                	addi	s0,sp,16
  initlock(&kmem.lock, "kmem");
    80000adc:	00007597          	auipc	a1,0x7
    80000ae0:	58c58593          	addi	a1,a1,1420 # 80008068 <digits+0x28>
    80000ae4:	00011517          	auipc	a0,0x11
    80000ae8:	e4c50513          	addi	a0,a0,-436 # 80011930 <kmem>
    80000aec:	00000097          	auipc	ra,0x0
    80000af0:	084080e7          	jalr	132(ra) # 80000b70 <initlock>
  freerange(end, (void*)PHYSTOP);
    80000af4:	45c5                	li	a1,17
    80000af6:	05ee                	slli	a1,a1,0x1b
    80000af8:	00025517          	auipc	a0,0x25
    80000afc:	50850513          	addi	a0,a0,1288 # 80026000 <end>
    80000b00:	00000097          	auipc	ra,0x0
    80000b04:	f88080e7          	jalr	-120(ra) # 80000a88 <freerange>
}
    80000b08:	60a2                	ld	ra,8(sp)
    80000b0a:	6402                	ld	s0,0(sp)
    80000b0c:	0141                	addi	sp,sp,16
    80000b0e:	8082                	ret

0000000080000b10 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    80000b10:	1101                	addi	sp,sp,-32
    80000b12:	ec06                	sd	ra,24(sp)
    80000b14:	e822                	sd	s0,16(sp)
    80000b16:	e426                	sd	s1,8(sp)
    80000b18:	1000                	addi	s0,sp,32
  struct run *r;

  acquire(&kmem.lock);
    80000b1a:	00011497          	auipc	s1,0x11
    80000b1e:	e1648493          	addi	s1,s1,-490 # 80011930 <kmem>
    80000b22:	8526                	mv	a0,s1
    80000b24:	00000097          	auipc	ra,0x0
    80000b28:	0dc080e7          	jalr	220(ra) # 80000c00 <acquire>
  r = kmem.freelist;
    80000b2c:	6c84                	ld	s1,24(s1)
  if(r)
    80000b2e:	c885                	beqz	s1,80000b5e <kalloc+0x4e>
    kmem.freelist = r->next;
    80000b30:	609c                	ld	a5,0(s1)
    80000b32:	00011517          	auipc	a0,0x11
    80000b36:	dfe50513          	addi	a0,a0,-514 # 80011930 <kmem>
    80000b3a:	ed1c                	sd	a5,24(a0)
  release(&kmem.lock);
    80000b3c:	00000097          	auipc	ra,0x0
    80000b40:	178080e7          	jalr	376(ra) # 80000cb4 <release>

  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk
    80000b44:	6605                	lui	a2,0x1
    80000b46:	4595                	li	a1,5
    80000b48:	8526                	mv	a0,s1
    80000b4a:	00000097          	auipc	ra,0x0
    80000b4e:	1b2080e7          	jalr	434(ra) # 80000cfc <memset>
  return (void*)r;
}
    80000b52:	8526                	mv	a0,s1
    80000b54:	60e2                	ld	ra,24(sp)
    80000b56:	6442                	ld	s0,16(sp)
    80000b58:	64a2                	ld	s1,8(sp)
    80000b5a:	6105                	addi	sp,sp,32
    80000b5c:	8082                	ret
  release(&kmem.lock);
    80000b5e:	00011517          	auipc	a0,0x11
    80000b62:	dd250513          	addi	a0,a0,-558 # 80011930 <kmem>
    80000b66:	00000097          	auipc	ra,0x0
    80000b6a:	14e080e7          	jalr	334(ra) # 80000cb4 <release>
  if(r)
    80000b6e:	b7d5                	j	80000b52 <kalloc+0x42>

0000000080000b70 <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    80000b70:	1141                	addi	sp,sp,-16
    80000b72:	e422                	sd	s0,8(sp)
    80000b74:	0800                	addi	s0,sp,16
  lk->name = name;
    80000b76:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    80000b78:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    80000b7c:	00053823          	sd	zero,16(a0)
}
    80000b80:	6422                	ld	s0,8(sp)
    80000b82:	0141                	addi	sp,sp,16
    80000b84:	8082                	ret

0000000080000b86 <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    80000b86:	411c                	lw	a5,0(a0)
    80000b88:	e399                	bnez	a5,80000b8e <holding+0x8>
    80000b8a:	4501                	li	a0,0
  return r;
}
    80000b8c:	8082                	ret
{
    80000b8e:	1101                	addi	sp,sp,-32
    80000b90:	ec06                	sd	ra,24(sp)
    80000b92:	e822                	sd	s0,16(sp)
    80000b94:	e426                	sd	s1,8(sp)
    80000b96:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    80000b98:	6904                	ld	s1,16(a0)
    80000b9a:	00001097          	auipc	ra,0x1
    80000b9e:	e16080e7          	jalr	-490(ra) # 800019b0 <mycpu>
    80000ba2:	40a48533          	sub	a0,s1,a0
    80000ba6:	00153513          	seqz	a0,a0
}
    80000baa:	60e2                	ld	ra,24(sp)
    80000bac:	6442                	ld	s0,16(sp)
    80000bae:	64a2                	ld	s1,8(sp)
    80000bb0:	6105                	addi	sp,sp,32
    80000bb2:	8082                	ret

0000000080000bb4 <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    80000bb4:	1101                	addi	sp,sp,-32
    80000bb6:	ec06                	sd	ra,24(sp)
    80000bb8:	e822                	sd	s0,16(sp)
    80000bba:	e426                	sd	s1,8(sp)
    80000bbc:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000bbe:	100024f3          	csrr	s1,sstatus
    80000bc2:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80000bc6:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80000bc8:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    80000bcc:	00001097          	auipc	ra,0x1
    80000bd0:	de4080e7          	jalr	-540(ra) # 800019b0 <mycpu>
    80000bd4:	5d3c                	lw	a5,120(a0)
    80000bd6:	cf89                	beqz	a5,80000bf0 <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    80000bd8:	00001097          	auipc	ra,0x1
    80000bdc:	dd8080e7          	jalr	-552(ra) # 800019b0 <mycpu>
    80000be0:	5d3c                	lw	a5,120(a0)
    80000be2:	2785                	addiw	a5,a5,1
    80000be4:	dd3c                	sw	a5,120(a0)
}
    80000be6:	60e2                	ld	ra,24(sp)
    80000be8:	6442                	ld	s0,16(sp)
    80000bea:	64a2                	ld	s1,8(sp)
    80000bec:	6105                	addi	sp,sp,32
    80000bee:	8082                	ret
    mycpu()->intena = old;
    80000bf0:	00001097          	auipc	ra,0x1
    80000bf4:	dc0080e7          	jalr	-576(ra) # 800019b0 <mycpu>
  return (x & SSTATUS_SIE) != 0;
    80000bf8:	8085                	srli	s1,s1,0x1
    80000bfa:	8885                	andi	s1,s1,1
    80000bfc:	dd64                	sw	s1,124(a0)
    80000bfe:	bfe9                	j	80000bd8 <push_off+0x24>

0000000080000c00 <acquire>:
{
    80000c00:	1101                	addi	sp,sp,-32
    80000c02:	ec06                	sd	ra,24(sp)
    80000c04:	e822                	sd	s0,16(sp)
    80000c06:	e426                	sd	s1,8(sp)
    80000c08:	1000                	addi	s0,sp,32
    80000c0a:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    80000c0c:	00000097          	auipc	ra,0x0
    80000c10:	fa8080e7          	jalr	-88(ra) # 80000bb4 <push_off>
  if(holding(lk))
    80000c14:	8526                	mv	a0,s1
    80000c16:	00000097          	auipc	ra,0x0
    80000c1a:	f70080e7          	jalr	-144(ra) # 80000b86 <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80000c1e:	4705                	li	a4,1
  if(holding(lk))
    80000c20:	e115                	bnez	a0,80000c44 <acquire+0x44>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80000c22:	87ba                	mv	a5,a4
    80000c24:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    80000c28:	2781                	sext.w	a5,a5
    80000c2a:	ffe5                	bnez	a5,80000c22 <acquire+0x22>
  __sync_synchronize();
    80000c2c:	0ff0000f          	fence
  lk->cpu = mycpu();
    80000c30:	00001097          	auipc	ra,0x1
    80000c34:	d80080e7          	jalr	-640(ra) # 800019b0 <mycpu>
    80000c38:	e888                	sd	a0,16(s1)
}
    80000c3a:	60e2                	ld	ra,24(sp)
    80000c3c:	6442                	ld	s0,16(sp)
    80000c3e:	64a2                	ld	s1,8(sp)
    80000c40:	6105                	addi	sp,sp,32
    80000c42:	8082                	ret
    panic("acquire");
    80000c44:	00007517          	auipc	a0,0x7
    80000c48:	42c50513          	addi	a0,a0,1068 # 80008070 <digits+0x30>
    80000c4c:	00000097          	auipc	ra,0x0
    80000c50:	8fa080e7          	jalr	-1798(ra) # 80000546 <panic>

0000000080000c54 <pop_off>:

void
pop_off(void)
{
    80000c54:	1141                	addi	sp,sp,-16
    80000c56:	e406                	sd	ra,8(sp)
    80000c58:	e022                	sd	s0,0(sp)
    80000c5a:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    80000c5c:	00001097          	auipc	ra,0x1
    80000c60:	d54080e7          	jalr	-684(ra) # 800019b0 <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000c64:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80000c68:	8b89                	andi	a5,a5,2
  if(intr_get())
    80000c6a:	e78d                	bnez	a5,80000c94 <pop_off+0x40>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    80000c6c:	5d3c                	lw	a5,120(a0)
    80000c6e:	02f05b63          	blez	a5,80000ca4 <pop_off+0x50>
    panic("pop_off");
  c->noff -= 1;
    80000c72:	37fd                	addiw	a5,a5,-1
    80000c74:	0007871b          	sext.w	a4,a5
    80000c78:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    80000c7a:	eb09                	bnez	a4,80000c8c <pop_off+0x38>
    80000c7c:	5d7c                	lw	a5,124(a0)
    80000c7e:	c799                	beqz	a5,80000c8c <pop_off+0x38>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000c80:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80000c84:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80000c88:	10079073          	csrw	sstatus,a5
    intr_on();
}
    80000c8c:	60a2                	ld	ra,8(sp)
    80000c8e:	6402                	ld	s0,0(sp)
    80000c90:	0141                	addi	sp,sp,16
    80000c92:	8082                	ret
    panic("pop_off - interruptible");
    80000c94:	00007517          	auipc	a0,0x7
    80000c98:	3e450513          	addi	a0,a0,996 # 80008078 <digits+0x38>
    80000c9c:	00000097          	auipc	ra,0x0
    80000ca0:	8aa080e7          	jalr	-1878(ra) # 80000546 <panic>
    panic("pop_off");
    80000ca4:	00007517          	auipc	a0,0x7
    80000ca8:	3ec50513          	addi	a0,a0,1004 # 80008090 <digits+0x50>
    80000cac:	00000097          	auipc	ra,0x0
    80000cb0:	89a080e7          	jalr	-1894(ra) # 80000546 <panic>

0000000080000cb4 <release>:
{
    80000cb4:	1101                	addi	sp,sp,-32
    80000cb6:	ec06                	sd	ra,24(sp)
    80000cb8:	e822                	sd	s0,16(sp)
    80000cba:	e426                	sd	s1,8(sp)
    80000cbc:	1000                	addi	s0,sp,32
    80000cbe:	84aa                	mv	s1,a0
  if(!holding(lk))
    80000cc0:	00000097          	auipc	ra,0x0
    80000cc4:	ec6080e7          	jalr	-314(ra) # 80000b86 <holding>
    80000cc8:	c115                	beqz	a0,80000cec <release+0x38>
  lk->cpu = 0;
    80000cca:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    80000cce:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    80000cd2:	0f50000f          	fence	iorw,ow
    80000cd6:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    80000cda:	00000097          	auipc	ra,0x0
    80000cde:	f7a080e7          	jalr	-134(ra) # 80000c54 <pop_off>
}
    80000ce2:	60e2                	ld	ra,24(sp)
    80000ce4:	6442                	ld	s0,16(sp)
    80000ce6:	64a2                	ld	s1,8(sp)
    80000ce8:	6105                	addi	sp,sp,32
    80000cea:	8082                	ret
    panic("release");
    80000cec:	00007517          	auipc	a0,0x7
    80000cf0:	3ac50513          	addi	a0,a0,940 # 80008098 <digits+0x58>
    80000cf4:	00000097          	auipc	ra,0x0
    80000cf8:	852080e7          	jalr	-1966(ra) # 80000546 <panic>

0000000080000cfc <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    80000cfc:	1141                	addi	sp,sp,-16
    80000cfe:	e422                	sd	s0,8(sp)
    80000d00:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    80000d02:	ca19                	beqz	a2,80000d18 <memset+0x1c>
    80000d04:	87aa                	mv	a5,a0
    80000d06:	1602                	slli	a2,a2,0x20
    80000d08:	9201                	srli	a2,a2,0x20
    80000d0a:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    80000d0e:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    80000d12:	0785                	addi	a5,a5,1
    80000d14:	fee79de3          	bne	a5,a4,80000d0e <memset+0x12>
  }
  return dst;
}
    80000d18:	6422                	ld	s0,8(sp)
    80000d1a:	0141                	addi	sp,sp,16
    80000d1c:	8082                	ret

0000000080000d1e <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    80000d1e:	1141                	addi	sp,sp,-16
    80000d20:	e422                	sd	s0,8(sp)
    80000d22:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    80000d24:	ca05                	beqz	a2,80000d54 <memcmp+0x36>
    80000d26:	fff6069b          	addiw	a3,a2,-1 # fff <_entry-0x7ffff001>
    80000d2a:	1682                	slli	a3,a3,0x20
    80000d2c:	9281                	srli	a3,a3,0x20
    80000d2e:	0685                	addi	a3,a3,1
    80000d30:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    80000d32:	00054783          	lbu	a5,0(a0)
    80000d36:	0005c703          	lbu	a4,0(a1)
    80000d3a:	00e79863          	bne	a5,a4,80000d4a <memcmp+0x2c>
      return *s1 - *s2;
    s1++, s2++;
    80000d3e:	0505                	addi	a0,a0,1
    80000d40:	0585                	addi	a1,a1,1
  while(n-- > 0){
    80000d42:	fed518e3          	bne	a0,a3,80000d32 <memcmp+0x14>
  }

  return 0;
    80000d46:	4501                	li	a0,0
    80000d48:	a019                	j	80000d4e <memcmp+0x30>
      return *s1 - *s2;
    80000d4a:	40e7853b          	subw	a0,a5,a4
}
    80000d4e:	6422                	ld	s0,8(sp)
    80000d50:	0141                	addi	sp,sp,16
    80000d52:	8082                	ret
  return 0;
    80000d54:	4501                	li	a0,0
    80000d56:	bfe5                	j	80000d4e <memcmp+0x30>

0000000080000d58 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    80000d58:	1141                	addi	sp,sp,-16
    80000d5a:	e422                	sd	s0,8(sp)
    80000d5c:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
    80000d5e:	02a5e563          	bltu	a1,a0,80000d88 <memmove+0x30>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    80000d62:	fff6069b          	addiw	a3,a2,-1
    80000d66:	ce11                	beqz	a2,80000d82 <memmove+0x2a>
    80000d68:	1682                	slli	a3,a3,0x20
    80000d6a:	9281                	srli	a3,a3,0x20
    80000d6c:	0685                	addi	a3,a3,1
    80000d6e:	96ae                	add	a3,a3,a1
    80000d70:	87aa                	mv	a5,a0
      *d++ = *s++;
    80000d72:	0585                	addi	a1,a1,1
    80000d74:	0785                	addi	a5,a5,1
    80000d76:	fff5c703          	lbu	a4,-1(a1)
    80000d7a:	fee78fa3          	sb	a4,-1(a5)
    while(n-- > 0)
    80000d7e:	fed59ae3          	bne	a1,a3,80000d72 <memmove+0x1a>

  return dst;
}
    80000d82:	6422                	ld	s0,8(sp)
    80000d84:	0141                	addi	sp,sp,16
    80000d86:	8082                	ret
  if(s < d && s + n > d){
    80000d88:	02061713          	slli	a4,a2,0x20
    80000d8c:	9301                	srli	a4,a4,0x20
    80000d8e:	00e587b3          	add	a5,a1,a4
    80000d92:	fcf578e3          	bgeu	a0,a5,80000d62 <memmove+0xa>
    d += n;
    80000d96:	972a                	add	a4,a4,a0
    while(n-- > 0)
    80000d98:	fff6069b          	addiw	a3,a2,-1
    80000d9c:	d27d                	beqz	a2,80000d82 <memmove+0x2a>
    80000d9e:	02069613          	slli	a2,a3,0x20
    80000da2:	9201                	srli	a2,a2,0x20
    80000da4:	fff64613          	not	a2,a2
    80000da8:	963e                	add	a2,a2,a5
      *--d = *--s;
    80000daa:	17fd                	addi	a5,a5,-1
    80000dac:	177d                	addi	a4,a4,-1 # ffffffffffffefff <end+0xffffffff7ffd8fff>
    80000dae:	0007c683          	lbu	a3,0(a5)
    80000db2:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
    80000db6:	fef61ae3          	bne	a2,a5,80000daa <memmove+0x52>
    80000dba:	b7e1                	j	80000d82 <memmove+0x2a>

0000000080000dbc <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    80000dbc:	1141                	addi	sp,sp,-16
    80000dbe:	e406                	sd	ra,8(sp)
    80000dc0:	e022                	sd	s0,0(sp)
    80000dc2:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    80000dc4:	00000097          	auipc	ra,0x0
    80000dc8:	f94080e7          	jalr	-108(ra) # 80000d58 <memmove>
}
    80000dcc:	60a2                	ld	ra,8(sp)
    80000dce:	6402                	ld	s0,0(sp)
    80000dd0:	0141                	addi	sp,sp,16
    80000dd2:	8082                	ret

0000000080000dd4 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    80000dd4:	1141                	addi	sp,sp,-16
    80000dd6:	e422                	sd	s0,8(sp)
    80000dd8:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    80000dda:	ce11                	beqz	a2,80000df6 <strncmp+0x22>
    80000ddc:	00054783          	lbu	a5,0(a0)
    80000de0:	cf89                	beqz	a5,80000dfa <strncmp+0x26>
    80000de2:	0005c703          	lbu	a4,0(a1)
    80000de6:	00f71a63          	bne	a4,a5,80000dfa <strncmp+0x26>
    n--, p++, q++;
    80000dea:	367d                	addiw	a2,a2,-1
    80000dec:	0505                	addi	a0,a0,1
    80000dee:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    80000df0:	f675                	bnez	a2,80000ddc <strncmp+0x8>
  if(n == 0)
    return 0;
    80000df2:	4501                	li	a0,0
    80000df4:	a809                	j	80000e06 <strncmp+0x32>
    80000df6:	4501                	li	a0,0
    80000df8:	a039                	j	80000e06 <strncmp+0x32>
  if(n == 0)
    80000dfa:	ca09                	beqz	a2,80000e0c <strncmp+0x38>
  return (uchar)*p - (uchar)*q;
    80000dfc:	00054503          	lbu	a0,0(a0)
    80000e00:	0005c783          	lbu	a5,0(a1)
    80000e04:	9d1d                	subw	a0,a0,a5
}
    80000e06:	6422                	ld	s0,8(sp)
    80000e08:	0141                	addi	sp,sp,16
    80000e0a:	8082                	ret
    return 0;
    80000e0c:	4501                	li	a0,0
    80000e0e:	bfe5                	j	80000e06 <strncmp+0x32>

0000000080000e10 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    80000e10:	1141                	addi	sp,sp,-16
    80000e12:	e422                	sd	s0,8(sp)
    80000e14:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    80000e16:	872a                	mv	a4,a0
    80000e18:	8832                	mv	a6,a2
    80000e1a:	367d                	addiw	a2,a2,-1
    80000e1c:	01005963          	blez	a6,80000e2e <strncpy+0x1e>
    80000e20:	0705                	addi	a4,a4,1
    80000e22:	0005c783          	lbu	a5,0(a1)
    80000e26:	fef70fa3          	sb	a5,-1(a4)
    80000e2a:	0585                	addi	a1,a1,1
    80000e2c:	f7f5                	bnez	a5,80000e18 <strncpy+0x8>
    ;
  while(n-- > 0)
    80000e2e:	86ba                	mv	a3,a4
    80000e30:	00c05c63          	blez	a2,80000e48 <strncpy+0x38>
    *s++ = 0;
    80000e34:	0685                	addi	a3,a3,1
    80000e36:	fe068fa3          	sb	zero,-1(a3)
  while(n-- > 0)
    80000e3a:	40d707bb          	subw	a5,a4,a3
    80000e3e:	37fd                	addiw	a5,a5,-1
    80000e40:	010787bb          	addw	a5,a5,a6
    80000e44:	fef048e3          	bgtz	a5,80000e34 <strncpy+0x24>
  return os;
}
    80000e48:	6422                	ld	s0,8(sp)
    80000e4a:	0141                	addi	sp,sp,16
    80000e4c:	8082                	ret

0000000080000e4e <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    80000e4e:	1141                	addi	sp,sp,-16
    80000e50:	e422                	sd	s0,8(sp)
    80000e52:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    80000e54:	02c05363          	blez	a2,80000e7a <safestrcpy+0x2c>
    80000e58:	fff6069b          	addiw	a3,a2,-1
    80000e5c:	1682                	slli	a3,a3,0x20
    80000e5e:	9281                	srli	a3,a3,0x20
    80000e60:	96ae                	add	a3,a3,a1
    80000e62:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    80000e64:	00d58963          	beq	a1,a3,80000e76 <safestrcpy+0x28>
    80000e68:	0585                	addi	a1,a1,1
    80000e6a:	0785                	addi	a5,a5,1
    80000e6c:	fff5c703          	lbu	a4,-1(a1)
    80000e70:	fee78fa3          	sb	a4,-1(a5)
    80000e74:	fb65                	bnez	a4,80000e64 <safestrcpy+0x16>
    ;
  *s = 0;
    80000e76:	00078023          	sb	zero,0(a5)
  return os;
}
    80000e7a:	6422                	ld	s0,8(sp)
    80000e7c:	0141                	addi	sp,sp,16
    80000e7e:	8082                	ret

0000000080000e80 <strlen>:

int
strlen(const char *s)
{
    80000e80:	1141                	addi	sp,sp,-16
    80000e82:	e422                	sd	s0,8(sp)
    80000e84:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    80000e86:	00054783          	lbu	a5,0(a0)
    80000e8a:	cf91                	beqz	a5,80000ea6 <strlen+0x26>
    80000e8c:	0505                	addi	a0,a0,1
    80000e8e:	87aa                	mv	a5,a0
    80000e90:	4685                	li	a3,1
    80000e92:	9e89                	subw	a3,a3,a0
    80000e94:	00f6853b          	addw	a0,a3,a5
    80000e98:	0785                	addi	a5,a5,1
    80000e9a:	fff7c703          	lbu	a4,-1(a5)
    80000e9e:	fb7d                	bnez	a4,80000e94 <strlen+0x14>
    ;
  return n;
}
    80000ea0:	6422                	ld	s0,8(sp)
    80000ea2:	0141                	addi	sp,sp,16
    80000ea4:	8082                	ret
  for(n = 0; s[n]; n++)
    80000ea6:	4501                	li	a0,0
    80000ea8:	bfe5                	j	80000ea0 <strlen+0x20>

0000000080000eaa <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    80000eaa:	1141                	addi	sp,sp,-16
    80000eac:	e406                	sd	ra,8(sp)
    80000eae:	e022                	sd	s0,0(sp)
    80000eb0:	0800                	addi	s0,sp,16
  if(cpuid() == 0){
    80000eb2:	00001097          	auipc	ra,0x1
    80000eb6:	aee080e7          	jalr	-1298(ra) # 800019a0 <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    80000eba:	00008717          	auipc	a4,0x8
    80000ebe:	15270713          	addi	a4,a4,338 # 8000900c <started>
  if(cpuid() == 0){
    80000ec2:	c139                	beqz	a0,80000f08 <main+0x5e>
    while(started == 0)
    80000ec4:	431c                	lw	a5,0(a4)
    80000ec6:	2781                	sext.w	a5,a5
    80000ec8:	dff5                	beqz	a5,80000ec4 <main+0x1a>
      ;
    __sync_synchronize();
    80000eca:	0ff0000f          	fence
    printf("hart %d starting\n", cpuid());
    80000ece:	00001097          	auipc	ra,0x1
    80000ed2:	ad2080e7          	jalr	-1326(ra) # 800019a0 <cpuid>
    80000ed6:	85aa                	mv	a1,a0
    80000ed8:	00007517          	auipc	a0,0x7
    80000edc:	1e050513          	addi	a0,a0,480 # 800080b8 <digits+0x78>
    80000ee0:	fffff097          	auipc	ra,0xfffff
    80000ee4:	6b0080e7          	jalr	1712(ra) # 80000590 <printf>
    kvminithart();    // turn on paging
    80000ee8:	00000097          	auipc	ra,0x0
    80000eec:	0d8080e7          	jalr	216(ra) # 80000fc0 <kvminithart>
    trapinithart();   // install kernel trap vector
    80000ef0:	00001097          	auipc	ra,0x1
    80000ef4:	738080e7          	jalr	1848(ra) # 80002628 <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80000ef8:	00005097          	auipc	ra,0x5
    80000efc:	cc8080e7          	jalr	-824(ra) # 80005bc0 <plicinithart>
  }

  scheduler();        
    80000f00:	00001097          	auipc	ra,0x1
    80000f04:	004080e7          	jalr	4(ra) # 80001f04 <scheduler>
    consoleinit();
    80000f08:	fffff097          	auipc	ra,0xfffff
    80000f0c:	54e080e7          	jalr	1358(ra) # 80000456 <consoleinit>
    printfinit();
    80000f10:	00000097          	auipc	ra,0x0
    80000f14:	860080e7          	jalr	-1952(ra) # 80000770 <printfinit>
    printf("\n");
    80000f18:	00007517          	auipc	a0,0x7
    80000f1c:	1b050513          	addi	a0,a0,432 # 800080c8 <digits+0x88>
    80000f20:	fffff097          	auipc	ra,0xfffff
    80000f24:	670080e7          	jalr	1648(ra) # 80000590 <printf>
    printf("xv6 kernel is booting\n");
    80000f28:	00007517          	auipc	a0,0x7
    80000f2c:	17850513          	addi	a0,a0,376 # 800080a0 <digits+0x60>
    80000f30:	fffff097          	auipc	ra,0xfffff
    80000f34:	660080e7          	jalr	1632(ra) # 80000590 <printf>
    printf("\n");
    80000f38:	00007517          	auipc	a0,0x7
    80000f3c:	19050513          	addi	a0,a0,400 # 800080c8 <digits+0x88>
    80000f40:	fffff097          	auipc	ra,0xfffff
    80000f44:	650080e7          	jalr	1616(ra) # 80000590 <printf>
    kinit();         // physical page allocator
    80000f48:	00000097          	auipc	ra,0x0
    80000f4c:	b8c080e7          	jalr	-1140(ra) # 80000ad4 <kinit>
    kvminit();       // create kernel page table
    80000f50:	00000097          	auipc	ra,0x0
    80000f54:	2a0080e7          	jalr	672(ra) # 800011f0 <kvminit>
    kvminithart();   // turn on paging
    80000f58:	00000097          	auipc	ra,0x0
    80000f5c:	068080e7          	jalr	104(ra) # 80000fc0 <kvminithart>
    procinit();      // process table
    80000f60:	00001097          	auipc	ra,0x1
    80000f64:	970080e7          	jalr	-1680(ra) # 800018d0 <procinit>
    trapinit();      // trap vectors
    80000f68:	00001097          	auipc	ra,0x1
    80000f6c:	698080e7          	jalr	1688(ra) # 80002600 <trapinit>
    trapinithart();  // install kernel trap vector
    80000f70:	00001097          	auipc	ra,0x1
    80000f74:	6b8080e7          	jalr	1720(ra) # 80002628 <trapinithart>
    plicinit();      // set up interrupt controller
    80000f78:	00005097          	auipc	ra,0x5
    80000f7c:	c32080e7          	jalr	-974(ra) # 80005baa <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    80000f80:	00005097          	auipc	ra,0x5
    80000f84:	c40080e7          	jalr	-960(ra) # 80005bc0 <plicinithart>
    binit();         // buffer cache
    80000f88:	00002097          	auipc	ra,0x2
    80000f8c:	de2080e7          	jalr	-542(ra) # 80002d6a <binit>
    iinit();         // inode cache
    80000f90:	00002097          	auipc	ra,0x2
    80000f94:	470080e7          	jalr	1136(ra) # 80003400 <iinit>
    fileinit();      // file table
    80000f98:	00003097          	auipc	ra,0x3
    80000f9c:	412080e7          	jalr	1042(ra) # 800043aa <fileinit>
    virtio_disk_init(); // emulated hard disk
    80000fa0:	00005097          	auipc	ra,0x5
    80000fa4:	d26080e7          	jalr	-730(ra) # 80005cc6 <virtio_disk_init>
    userinit();      // first user process
    80000fa8:	00001097          	auipc	ra,0x1
    80000fac:	cee080e7          	jalr	-786(ra) # 80001c96 <userinit>
    __sync_synchronize();
    80000fb0:	0ff0000f          	fence
    started = 1;
    80000fb4:	4785                	li	a5,1
    80000fb6:	00008717          	auipc	a4,0x8
    80000fba:	04f72b23          	sw	a5,86(a4) # 8000900c <started>
    80000fbe:	b789                	j	80000f00 <main+0x56>

0000000080000fc0 <kvminithart>:

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void
kvminithart()
{
    80000fc0:	1141                	addi	sp,sp,-16
    80000fc2:	e422                	sd	s0,8(sp)
    80000fc4:	0800                	addi	s0,sp,16
  w_satp(MAKE_SATP(kernel_pagetable));
    80000fc6:	00008797          	auipc	a5,0x8
    80000fca:	04a7b783          	ld	a5,74(a5) # 80009010 <kernel_pagetable>
    80000fce:	83b1                	srli	a5,a5,0xc
    80000fd0:	577d                	li	a4,-1
    80000fd2:	177e                	slli	a4,a4,0x3f
    80000fd4:	8fd9                	or	a5,a5,a4
  asm volatile("csrw satp, %0" : : "r" (x));
    80000fd6:	18079073          	csrw	satp,a5
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    80000fda:	12000073          	sfence.vma
  sfence_vma();
}
    80000fde:	6422                	ld	s0,8(sp)
    80000fe0:	0141                	addi	sp,sp,16
    80000fe2:	8082                	ret

0000000080000fe4 <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    80000fe4:	7139                	addi	sp,sp,-64
    80000fe6:	fc06                	sd	ra,56(sp)
    80000fe8:	f822                	sd	s0,48(sp)
    80000fea:	f426                	sd	s1,40(sp)
    80000fec:	f04a                	sd	s2,32(sp)
    80000fee:	ec4e                	sd	s3,24(sp)
    80000ff0:	e852                	sd	s4,16(sp)
    80000ff2:	e456                	sd	s5,8(sp)
    80000ff4:	e05a                	sd	s6,0(sp)
    80000ff6:	0080                	addi	s0,sp,64
    80000ff8:	84aa                	mv	s1,a0
    80000ffa:	89ae                	mv	s3,a1
    80000ffc:	8ab2                	mv	s5,a2
  if(va >= MAXVA)
    80000ffe:	57fd                	li	a5,-1
    80001000:	83e9                	srli	a5,a5,0x1a
    80001002:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    80001004:	4b31                	li	s6,12
  if(va >= MAXVA)
    80001006:	04b7f263          	bgeu	a5,a1,8000104a <walk+0x66>
    panic("walk");
    8000100a:	00007517          	auipc	a0,0x7
    8000100e:	0c650513          	addi	a0,a0,198 # 800080d0 <digits+0x90>
    80001012:	fffff097          	auipc	ra,0xfffff
    80001016:	534080e7          	jalr	1332(ra) # 80000546 <panic>
    pte_t *pte = &pagetable[PX(level, va)];
    if(*pte & PTE_V) {
      pagetable = (pagetable_t)PTE2PA(*pte);
    } else {
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    8000101a:	060a8663          	beqz	s5,80001086 <walk+0xa2>
    8000101e:	00000097          	auipc	ra,0x0
    80001022:	af2080e7          	jalr	-1294(ra) # 80000b10 <kalloc>
    80001026:	84aa                	mv	s1,a0
    80001028:	c529                	beqz	a0,80001072 <walk+0x8e>
        return 0;
      memset(pagetable, 0, PGSIZE);
    8000102a:	6605                	lui	a2,0x1
    8000102c:	4581                	li	a1,0
    8000102e:	00000097          	auipc	ra,0x0
    80001032:	cce080e7          	jalr	-818(ra) # 80000cfc <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    80001036:	00c4d793          	srli	a5,s1,0xc
    8000103a:	07aa                	slli	a5,a5,0xa
    8000103c:	0017e793          	ori	a5,a5,1
    80001040:	00f93023          	sd	a5,0(s2)
  for(int level = 2; level > 0; level--) {
    80001044:	3a5d                	addiw	s4,s4,-9 # ffffffffffffeff7 <end+0xffffffff7ffd8ff7>
    80001046:	036a0063          	beq	s4,s6,80001066 <walk+0x82>
    pte_t *pte = &pagetable[PX(level, va)];
    8000104a:	0149d933          	srl	s2,s3,s4
    8000104e:	1ff97913          	andi	s2,s2,511
    80001052:	090e                	slli	s2,s2,0x3
    80001054:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    80001056:	00093483          	ld	s1,0(s2)
    8000105a:	0014f793          	andi	a5,s1,1
    8000105e:	dfd5                	beqz	a5,8000101a <walk+0x36>
      pagetable = (pagetable_t)PTE2PA(*pte);
    80001060:	80a9                	srli	s1,s1,0xa
    80001062:	04b2                	slli	s1,s1,0xc
    80001064:	b7c5                	j	80001044 <walk+0x60>
    }
  }
  return &pagetable[PX(0, va)];
    80001066:	00c9d513          	srli	a0,s3,0xc
    8000106a:	1ff57513          	andi	a0,a0,511
    8000106e:	050e                	slli	a0,a0,0x3
    80001070:	9526                	add	a0,a0,s1
}
    80001072:	70e2                	ld	ra,56(sp)
    80001074:	7442                	ld	s0,48(sp)
    80001076:	74a2                	ld	s1,40(sp)
    80001078:	7902                	ld	s2,32(sp)
    8000107a:	69e2                	ld	s3,24(sp)
    8000107c:	6a42                	ld	s4,16(sp)
    8000107e:	6aa2                	ld	s5,8(sp)
    80001080:	6b02                	ld	s6,0(sp)
    80001082:	6121                	addi	sp,sp,64
    80001084:	8082                	ret
        return 0;
    80001086:	4501                	li	a0,0
    80001088:	b7ed                	j	80001072 <walk+0x8e>

000000008000108a <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    8000108a:	57fd                	li	a5,-1
    8000108c:	83e9                	srli	a5,a5,0x1a
    8000108e:	00b7f463          	bgeu	a5,a1,80001096 <walkaddr+0xc>
    return 0;
    80001092:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    80001094:	8082                	ret
{
    80001096:	1141                	addi	sp,sp,-16
    80001098:	e406                	sd	ra,8(sp)
    8000109a:	e022                	sd	s0,0(sp)
    8000109c:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    8000109e:	4601                	li	a2,0
    800010a0:	00000097          	auipc	ra,0x0
    800010a4:	f44080e7          	jalr	-188(ra) # 80000fe4 <walk>
  if(pte == 0)
    800010a8:	c105                	beqz	a0,800010c8 <walkaddr+0x3e>
  if((*pte & PTE_V) == 0)
    800010aa:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    800010ac:	0117f693          	andi	a3,a5,17
    800010b0:	4745                	li	a4,17
    return 0;
    800010b2:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    800010b4:	00e68663          	beq	a3,a4,800010c0 <walkaddr+0x36>
}
    800010b8:	60a2                	ld	ra,8(sp)
    800010ba:	6402                	ld	s0,0(sp)
    800010bc:	0141                	addi	sp,sp,16
    800010be:	8082                	ret
  pa = PTE2PA(*pte);
    800010c0:	83a9                	srli	a5,a5,0xa
    800010c2:	00c79513          	slli	a0,a5,0xc
  return pa;
    800010c6:	bfcd                	j	800010b8 <walkaddr+0x2e>
    return 0;
    800010c8:	4501                	li	a0,0
    800010ca:	b7fd                	j	800010b8 <walkaddr+0x2e>

00000000800010cc <kvmpa>:
// a physical address. only needed for
// addresses on the stack.
// assumes va is page aligned.
uint64
kvmpa(uint64 va)
{
    800010cc:	1101                	addi	sp,sp,-32
    800010ce:	ec06                	sd	ra,24(sp)
    800010d0:	e822                	sd	s0,16(sp)
    800010d2:	e426                	sd	s1,8(sp)
    800010d4:	1000                	addi	s0,sp,32
    800010d6:	85aa                	mv	a1,a0
  uint64 off = va % PGSIZE;
    800010d8:	1552                	slli	a0,a0,0x34
    800010da:	03455493          	srli	s1,a0,0x34
  pte_t *pte;
  uint64 pa;
  
  pte = walk(kernel_pagetable, va, 0);
    800010de:	4601                	li	a2,0
    800010e0:	00008517          	auipc	a0,0x8
    800010e4:	f3053503          	ld	a0,-208(a0) # 80009010 <kernel_pagetable>
    800010e8:	00000097          	auipc	ra,0x0
    800010ec:	efc080e7          	jalr	-260(ra) # 80000fe4 <walk>
  if(pte == 0)
    800010f0:	cd09                	beqz	a0,8000110a <kvmpa+0x3e>
    panic("kvmpa");
  if((*pte & PTE_V) == 0)
    800010f2:	6108                	ld	a0,0(a0)
    800010f4:	00157793          	andi	a5,a0,1
    800010f8:	c38d                	beqz	a5,8000111a <kvmpa+0x4e>
    panic("kvmpa");
  pa = PTE2PA(*pte);
    800010fa:	8129                	srli	a0,a0,0xa
    800010fc:	0532                	slli	a0,a0,0xc
  return pa+off;
}
    800010fe:	9526                	add	a0,a0,s1
    80001100:	60e2                	ld	ra,24(sp)
    80001102:	6442                	ld	s0,16(sp)
    80001104:	64a2                	ld	s1,8(sp)
    80001106:	6105                	addi	sp,sp,32
    80001108:	8082                	ret
    panic("kvmpa");
    8000110a:	00007517          	auipc	a0,0x7
    8000110e:	fce50513          	addi	a0,a0,-50 # 800080d8 <digits+0x98>
    80001112:	fffff097          	auipc	ra,0xfffff
    80001116:	434080e7          	jalr	1076(ra) # 80000546 <panic>
    panic("kvmpa");
    8000111a:	00007517          	auipc	a0,0x7
    8000111e:	fbe50513          	addi	a0,a0,-66 # 800080d8 <digits+0x98>
    80001122:	fffff097          	auipc	ra,0xfffff
    80001126:	424080e7          	jalr	1060(ra) # 80000546 <panic>

000000008000112a <mappages>:
// physical addresses starting at pa. va and size might not
// be page-aligned. Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    8000112a:	715d                	addi	sp,sp,-80
    8000112c:	e486                	sd	ra,72(sp)
    8000112e:	e0a2                	sd	s0,64(sp)
    80001130:	fc26                	sd	s1,56(sp)
    80001132:	f84a                	sd	s2,48(sp)
    80001134:	f44e                	sd	s3,40(sp)
    80001136:	f052                	sd	s4,32(sp)
    80001138:	ec56                	sd	s5,24(sp)
    8000113a:	e85a                	sd	s6,16(sp)
    8000113c:	e45e                	sd	s7,8(sp)
    8000113e:	0880                	addi	s0,sp,80
    80001140:	8aaa                	mv	s5,a0
    80001142:	8b3a                	mv	s6,a4
  uint64 a, last;
  pte_t *pte;

  a = PGROUNDDOWN(va);
    80001144:	777d                	lui	a4,0xfffff
    80001146:	00e5f7b3          	and	a5,a1,a4
  last = PGROUNDDOWN(va + size - 1);
    8000114a:	fff60993          	addi	s3,a2,-1 # fff <_entry-0x7ffff001>
    8000114e:	99ae                	add	s3,s3,a1
    80001150:	00e9f9b3          	and	s3,s3,a4
  a = PGROUNDDOWN(va);
    80001154:	893e                	mv	s2,a5
    80001156:	40f68a33          	sub	s4,a3,a5
    if(*pte & PTE_V)
      panic("remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    8000115a:	6b85                	lui	s7,0x1
    8000115c:	012a04b3          	add	s1,s4,s2
    if((pte = walk(pagetable, a, 1)) == 0)
    80001160:	4605                	li	a2,1
    80001162:	85ca                	mv	a1,s2
    80001164:	8556                	mv	a0,s5
    80001166:	00000097          	auipc	ra,0x0
    8000116a:	e7e080e7          	jalr	-386(ra) # 80000fe4 <walk>
    8000116e:	c51d                	beqz	a0,8000119c <mappages+0x72>
    if(*pte & PTE_V)
    80001170:	611c                	ld	a5,0(a0)
    80001172:	8b85                	andi	a5,a5,1
    80001174:	ef81                	bnez	a5,8000118c <mappages+0x62>
    *pte = PA2PTE(pa) | perm | PTE_V;
    80001176:	80b1                	srli	s1,s1,0xc
    80001178:	04aa                	slli	s1,s1,0xa
    8000117a:	0164e4b3          	or	s1,s1,s6
    8000117e:	0014e493          	ori	s1,s1,1
    80001182:	e104                	sd	s1,0(a0)
    if(a == last)
    80001184:	03390863          	beq	s2,s3,800011b4 <mappages+0x8a>
    a += PGSIZE;
    80001188:	995e                	add	s2,s2,s7
    if((pte = walk(pagetable, a, 1)) == 0)
    8000118a:	bfc9                	j	8000115c <mappages+0x32>
      panic("remap");
    8000118c:	00007517          	auipc	a0,0x7
    80001190:	f5450513          	addi	a0,a0,-172 # 800080e0 <digits+0xa0>
    80001194:	fffff097          	auipc	ra,0xfffff
    80001198:	3b2080e7          	jalr	946(ra) # 80000546 <panic>
      return -1;
    8000119c:	557d                	li	a0,-1
    pa += PGSIZE;
  }
  return 0;
}
    8000119e:	60a6                	ld	ra,72(sp)
    800011a0:	6406                	ld	s0,64(sp)
    800011a2:	74e2                	ld	s1,56(sp)
    800011a4:	7942                	ld	s2,48(sp)
    800011a6:	79a2                	ld	s3,40(sp)
    800011a8:	7a02                	ld	s4,32(sp)
    800011aa:	6ae2                	ld	s5,24(sp)
    800011ac:	6b42                	ld	s6,16(sp)
    800011ae:	6ba2                	ld	s7,8(sp)
    800011b0:	6161                	addi	sp,sp,80
    800011b2:	8082                	ret
  return 0;
    800011b4:	4501                	li	a0,0
    800011b6:	b7e5                	j	8000119e <mappages+0x74>

00000000800011b8 <kvmmap>:
{
    800011b8:	1141                	addi	sp,sp,-16
    800011ba:	e406                	sd	ra,8(sp)
    800011bc:	e022                	sd	s0,0(sp)
    800011be:	0800                	addi	s0,sp,16
    800011c0:	8736                	mv	a4,a3
  if(mappages(kernel_pagetable, va, sz, pa, perm) != 0)
    800011c2:	86ae                	mv	a3,a1
    800011c4:	85aa                	mv	a1,a0
    800011c6:	00008517          	auipc	a0,0x8
    800011ca:	e4a53503          	ld	a0,-438(a0) # 80009010 <kernel_pagetable>
    800011ce:	00000097          	auipc	ra,0x0
    800011d2:	f5c080e7          	jalr	-164(ra) # 8000112a <mappages>
    800011d6:	e509                	bnez	a0,800011e0 <kvmmap+0x28>
}
    800011d8:	60a2                	ld	ra,8(sp)
    800011da:	6402                	ld	s0,0(sp)
    800011dc:	0141                	addi	sp,sp,16
    800011de:	8082                	ret
    panic("kvmmap");
    800011e0:	00007517          	auipc	a0,0x7
    800011e4:	f0850513          	addi	a0,a0,-248 # 800080e8 <digits+0xa8>
    800011e8:	fffff097          	auipc	ra,0xfffff
    800011ec:	35e080e7          	jalr	862(ra) # 80000546 <panic>

00000000800011f0 <kvminit>:
{
    800011f0:	1101                	addi	sp,sp,-32
    800011f2:	ec06                	sd	ra,24(sp)
    800011f4:	e822                	sd	s0,16(sp)
    800011f6:	e426                	sd	s1,8(sp)
    800011f8:	1000                	addi	s0,sp,32
  kernel_pagetable = (pagetable_t) kalloc();
    800011fa:	00000097          	auipc	ra,0x0
    800011fe:	916080e7          	jalr	-1770(ra) # 80000b10 <kalloc>
    80001202:	00008717          	auipc	a4,0x8
    80001206:	e0a73723          	sd	a0,-498(a4) # 80009010 <kernel_pagetable>
  memset(kernel_pagetable, 0, PGSIZE);
    8000120a:	6605                	lui	a2,0x1
    8000120c:	4581                	li	a1,0
    8000120e:	00000097          	auipc	ra,0x0
    80001212:	aee080e7          	jalr	-1298(ra) # 80000cfc <memset>
  kvmmap(UART0, UART0, PGSIZE, PTE_R | PTE_W);
    80001216:	4699                	li	a3,6
    80001218:	6605                	lui	a2,0x1
    8000121a:	100005b7          	lui	a1,0x10000
    8000121e:	10000537          	lui	a0,0x10000
    80001222:	00000097          	auipc	ra,0x0
    80001226:	f96080e7          	jalr	-106(ra) # 800011b8 <kvmmap>
  kvmmap(VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    8000122a:	4699                	li	a3,6
    8000122c:	6605                	lui	a2,0x1
    8000122e:	100015b7          	lui	a1,0x10001
    80001232:	10001537          	lui	a0,0x10001
    80001236:	00000097          	auipc	ra,0x0
    8000123a:	f82080e7          	jalr	-126(ra) # 800011b8 <kvmmap>
  kvmmap(CLINT, CLINT, 0x10000, PTE_R | PTE_W);
    8000123e:	4699                	li	a3,6
    80001240:	6641                	lui	a2,0x10
    80001242:	020005b7          	lui	a1,0x2000
    80001246:	02000537          	lui	a0,0x2000
    8000124a:	00000097          	auipc	ra,0x0
    8000124e:	f6e080e7          	jalr	-146(ra) # 800011b8 <kvmmap>
  kvmmap(PLIC, PLIC, 0x400000, PTE_R | PTE_W);
    80001252:	4699                	li	a3,6
    80001254:	00400637          	lui	a2,0x400
    80001258:	0c0005b7          	lui	a1,0xc000
    8000125c:	0c000537          	lui	a0,0xc000
    80001260:	00000097          	auipc	ra,0x0
    80001264:	f58080e7          	jalr	-168(ra) # 800011b8 <kvmmap>
  kvmmap(KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    80001268:	00007497          	auipc	s1,0x7
    8000126c:	d9848493          	addi	s1,s1,-616 # 80008000 <etext>
    80001270:	46a9                	li	a3,10
    80001272:	80007617          	auipc	a2,0x80007
    80001276:	d8e60613          	addi	a2,a2,-626 # 8000 <_entry-0x7fff8000>
    8000127a:	4585                	li	a1,1
    8000127c:	05fe                	slli	a1,a1,0x1f
    8000127e:	852e                	mv	a0,a1
    80001280:	00000097          	auipc	ra,0x0
    80001284:	f38080e7          	jalr	-200(ra) # 800011b8 <kvmmap>
  kvmmap((uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    80001288:	4699                	li	a3,6
    8000128a:	4645                	li	a2,17
    8000128c:	066e                	slli	a2,a2,0x1b
    8000128e:	8e05                	sub	a2,a2,s1
    80001290:	85a6                	mv	a1,s1
    80001292:	8526                	mv	a0,s1
    80001294:	00000097          	auipc	ra,0x0
    80001298:	f24080e7          	jalr	-220(ra) # 800011b8 <kvmmap>
  kvmmap(TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    8000129c:	46a9                	li	a3,10
    8000129e:	6605                	lui	a2,0x1
    800012a0:	00006597          	auipc	a1,0x6
    800012a4:	d6058593          	addi	a1,a1,-672 # 80007000 <_trampoline>
    800012a8:	04000537          	lui	a0,0x4000
    800012ac:	157d                	addi	a0,a0,-1 # 3ffffff <_entry-0x7c000001>
    800012ae:	0532                	slli	a0,a0,0xc
    800012b0:	00000097          	auipc	ra,0x0
    800012b4:	f08080e7          	jalr	-248(ra) # 800011b8 <kvmmap>
}
    800012b8:	60e2                	ld	ra,24(sp)
    800012ba:	6442                	ld	s0,16(sp)
    800012bc:	64a2                	ld	s1,8(sp)
    800012be:	6105                	addi	sp,sp,32
    800012c0:	8082                	ret

00000000800012c2 <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    800012c2:	715d                	addi	sp,sp,-80
    800012c4:	e486                	sd	ra,72(sp)
    800012c6:	e0a2                	sd	s0,64(sp)
    800012c8:	fc26                	sd	s1,56(sp)
    800012ca:	f84a                	sd	s2,48(sp)
    800012cc:	f44e                	sd	s3,40(sp)
    800012ce:	f052                	sd	s4,32(sp)
    800012d0:	ec56                	sd	s5,24(sp)
    800012d2:	e85a                	sd	s6,16(sp)
    800012d4:	e45e                	sd	s7,8(sp)
    800012d6:	0880                	addi	s0,sp,80
  uint64 a;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    800012d8:	03459793          	slli	a5,a1,0x34
    800012dc:	e795                	bnez	a5,80001308 <uvmunmap+0x46>
    800012de:	8a2a                	mv	s4,a0
    800012e0:	892e                	mv	s2,a1
    800012e2:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    800012e4:	0632                	slli	a2,a2,0xc
    800012e6:	00b609b3          	add	s3,a2,a1
    if((pte = walk(pagetable, a, 0)) == 0)
      panic("uvmunmap: walk");
    if((*pte & PTE_V) == 0)
      panic("uvmunmap: not mapped");
    if(PTE_FLAGS(*pte) == PTE_V)
    800012ea:	4b85                	li	s7,1
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    800012ec:	6b05                	lui	s6,0x1
    800012ee:	0735e263          	bltu	a1,s3,80001352 <uvmunmap+0x90>
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
  }
}
    800012f2:	60a6                	ld	ra,72(sp)
    800012f4:	6406                	ld	s0,64(sp)
    800012f6:	74e2                	ld	s1,56(sp)
    800012f8:	7942                	ld	s2,48(sp)
    800012fa:	79a2                	ld	s3,40(sp)
    800012fc:	7a02                	ld	s4,32(sp)
    800012fe:	6ae2                	ld	s5,24(sp)
    80001300:	6b42                	ld	s6,16(sp)
    80001302:	6ba2                	ld	s7,8(sp)
    80001304:	6161                	addi	sp,sp,80
    80001306:	8082                	ret
    panic("uvmunmap: not aligned");
    80001308:	00007517          	auipc	a0,0x7
    8000130c:	de850513          	addi	a0,a0,-536 # 800080f0 <digits+0xb0>
    80001310:	fffff097          	auipc	ra,0xfffff
    80001314:	236080e7          	jalr	566(ra) # 80000546 <panic>
      panic("uvmunmap: walk");
    80001318:	00007517          	auipc	a0,0x7
    8000131c:	df050513          	addi	a0,a0,-528 # 80008108 <digits+0xc8>
    80001320:	fffff097          	auipc	ra,0xfffff
    80001324:	226080e7          	jalr	550(ra) # 80000546 <panic>
      panic("uvmunmap: not mapped");
    80001328:	00007517          	auipc	a0,0x7
    8000132c:	df050513          	addi	a0,a0,-528 # 80008118 <digits+0xd8>
    80001330:	fffff097          	auipc	ra,0xfffff
    80001334:	216080e7          	jalr	534(ra) # 80000546 <panic>
      panic("uvmunmap: not a leaf");
    80001338:	00007517          	auipc	a0,0x7
    8000133c:	df850513          	addi	a0,a0,-520 # 80008130 <digits+0xf0>
    80001340:	fffff097          	auipc	ra,0xfffff
    80001344:	206080e7          	jalr	518(ra) # 80000546 <panic>
    *pte = 0;
    80001348:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    8000134c:	995a                	add	s2,s2,s6
    8000134e:	fb3972e3          	bgeu	s2,s3,800012f2 <uvmunmap+0x30>
    if((pte = walk(pagetable, a, 0)) == 0)
    80001352:	4601                	li	a2,0
    80001354:	85ca                	mv	a1,s2
    80001356:	8552                	mv	a0,s4
    80001358:	00000097          	auipc	ra,0x0
    8000135c:	c8c080e7          	jalr	-884(ra) # 80000fe4 <walk>
    80001360:	84aa                	mv	s1,a0
    80001362:	d95d                	beqz	a0,80001318 <uvmunmap+0x56>
    if((*pte & PTE_V) == 0)
    80001364:	6108                	ld	a0,0(a0)
    80001366:	00157793          	andi	a5,a0,1
    8000136a:	dfdd                	beqz	a5,80001328 <uvmunmap+0x66>
    if(PTE_FLAGS(*pte) == PTE_V)
    8000136c:	3ff57793          	andi	a5,a0,1023
    80001370:	fd7784e3          	beq	a5,s7,80001338 <uvmunmap+0x76>
    if(do_free){
    80001374:	fc0a8ae3          	beqz	s5,80001348 <uvmunmap+0x86>
      uint64 pa = PTE2PA(*pte);
    80001378:	8129                	srli	a0,a0,0xa
      kfree((void*)pa);
    8000137a:	0532                	slli	a0,a0,0xc
    8000137c:	fffff097          	auipc	ra,0xfffff
    80001380:	696080e7          	jalr	1686(ra) # 80000a12 <kfree>
    80001384:	b7d1                	j	80001348 <uvmunmap+0x86>

0000000080001386 <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    80001386:	1101                	addi	sp,sp,-32
    80001388:	ec06                	sd	ra,24(sp)
    8000138a:	e822                	sd	s0,16(sp)
    8000138c:	e426                	sd	s1,8(sp)
    8000138e:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    80001390:	fffff097          	auipc	ra,0xfffff
    80001394:	780080e7          	jalr	1920(ra) # 80000b10 <kalloc>
    80001398:	84aa                	mv	s1,a0
  if(pagetable == 0)
    8000139a:	c519                	beqz	a0,800013a8 <uvmcreate+0x22>
    return 0;
  memset(pagetable, 0, PGSIZE);
    8000139c:	6605                	lui	a2,0x1
    8000139e:	4581                	li	a1,0
    800013a0:	00000097          	auipc	ra,0x0
    800013a4:	95c080e7          	jalr	-1700(ra) # 80000cfc <memset>
  return pagetable;
}
    800013a8:	8526                	mv	a0,s1
    800013aa:	60e2                	ld	ra,24(sp)
    800013ac:	6442                	ld	s0,16(sp)
    800013ae:	64a2                	ld	s1,8(sp)
    800013b0:	6105                	addi	sp,sp,32
    800013b2:	8082                	ret

00000000800013b4 <uvminit>:
// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void
uvminit(pagetable_t pagetable, uchar *src, uint sz)
{
    800013b4:	7179                	addi	sp,sp,-48
    800013b6:	f406                	sd	ra,40(sp)
    800013b8:	f022                	sd	s0,32(sp)
    800013ba:	ec26                	sd	s1,24(sp)
    800013bc:	e84a                	sd	s2,16(sp)
    800013be:	e44e                	sd	s3,8(sp)
    800013c0:	e052                	sd	s4,0(sp)
    800013c2:	1800                	addi	s0,sp,48
  char *mem;

  if(sz >= PGSIZE)
    800013c4:	6785                	lui	a5,0x1
    800013c6:	04f67863          	bgeu	a2,a5,80001416 <uvminit+0x62>
    800013ca:	8a2a                	mv	s4,a0
    800013cc:	89ae                	mv	s3,a1
    800013ce:	84b2                	mv	s1,a2
    panic("inituvm: more than a page");
  mem = kalloc();
    800013d0:	fffff097          	auipc	ra,0xfffff
    800013d4:	740080e7          	jalr	1856(ra) # 80000b10 <kalloc>
    800013d8:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    800013da:	6605                	lui	a2,0x1
    800013dc:	4581                	li	a1,0
    800013de:	00000097          	auipc	ra,0x0
    800013e2:	91e080e7          	jalr	-1762(ra) # 80000cfc <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    800013e6:	4779                	li	a4,30
    800013e8:	86ca                	mv	a3,s2
    800013ea:	6605                	lui	a2,0x1
    800013ec:	4581                	li	a1,0
    800013ee:	8552                	mv	a0,s4
    800013f0:	00000097          	auipc	ra,0x0
    800013f4:	d3a080e7          	jalr	-710(ra) # 8000112a <mappages>
  memmove(mem, src, sz);
    800013f8:	8626                	mv	a2,s1
    800013fa:	85ce                	mv	a1,s3
    800013fc:	854a                	mv	a0,s2
    800013fe:	00000097          	auipc	ra,0x0
    80001402:	95a080e7          	jalr	-1702(ra) # 80000d58 <memmove>
}
    80001406:	70a2                	ld	ra,40(sp)
    80001408:	7402                	ld	s0,32(sp)
    8000140a:	64e2                	ld	s1,24(sp)
    8000140c:	6942                	ld	s2,16(sp)
    8000140e:	69a2                	ld	s3,8(sp)
    80001410:	6a02                	ld	s4,0(sp)
    80001412:	6145                	addi	sp,sp,48
    80001414:	8082                	ret
    panic("inituvm: more than a page");
    80001416:	00007517          	auipc	a0,0x7
    8000141a:	d3250513          	addi	a0,a0,-718 # 80008148 <digits+0x108>
    8000141e:	fffff097          	auipc	ra,0xfffff
    80001422:	128080e7          	jalr	296(ra) # 80000546 <panic>

0000000080001426 <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    80001426:	1101                	addi	sp,sp,-32
    80001428:	ec06                	sd	ra,24(sp)
    8000142a:	e822                	sd	s0,16(sp)
    8000142c:	e426                	sd	s1,8(sp)
    8000142e:	1000                	addi	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    80001430:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    80001432:	00b67d63          	bgeu	a2,a1,8000144c <uvmdealloc+0x26>
    80001436:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    80001438:	6785                	lui	a5,0x1
    8000143a:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    8000143c:	00f60733          	add	a4,a2,a5
    80001440:	76fd                	lui	a3,0xfffff
    80001442:	8f75                	and	a4,a4,a3
    80001444:	97ae                	add	a5,a5,a1
    80001446:	8ff5                	and	a5,a5,a3
    80001448:	00f76863          	bltu	a4,a5,80001458 <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    8000144c:	8526                	mv	a0,s1
    8000144e:	60e2                	ld	ra,24(sp)
    80001450:	6442                	ld	s0,16(sp)
    80001452:	64a2                	ld	s1,8(sp)
    80001454:	6105                	addi	sp,sp,32
    80001456:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    80001458:	8f99                	sub	a5,a5,a4
    8000145a:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    8000145c:	4685                	li	a3,1
    8000145e:	0007861b          	sext.w	a2,a5
    80001462:	85ba                	mv	a1,a4
    80001464:	00000097          	auipc	ra,0x0
    80001468:	e5e080e7          	jalr	-418(ra) # 800012c2 <uvmunmap>
    8000146c:	b7c5                	j	8000144c <uvmdealloc+0x26>

000000008000146e <uvmalloc>:
  if(newsz < oldsz)
    8000146e:	0ab66163          	bltu	a2,a1,80001510 <uvmalloc+0xa2>
{
    80001472:	7139                	addi	sp,sp,-64
    80001474:	fc06                	sd	ra,56(sp)
    80001476:	f822                	sd	s0,48(sp)
    80001478:	f426                	sd	s1,40(sp)
    8000147a:	f04a                	sd	s2,32(sp)
    8000147c:	ec4e                	sd	s3,24(sp)
    8000147e:	e852                	sd	s4,16(sp)
    80001480:	e456                	sd	s5,8(sp)
    80001482:	0080                	addi	s0,sp,64
    80001484:	8aaa                	mv	s5,a0
    80001486:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    80001488:	6785                	lui	a5,0x1
    8000148a:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    8000148c:	95be                	add	a1,a1,a5
    8000148e:	77fd                	lui	a5,0xfffff
    80001490:	00f5f9b3          	and	s3,a1,a5
  for(a = oldsz; a < newsz; a += PGSIZE){
    80001494:	08c9f063          	bgeu	s3,a2,80001514 <uvmalloc+0xa6>
    80001498:	894e                	mv	s2,s3
    mem = kalloc();
    8000149a:	fffff097          	auipc	ra,0xfffff
    8000149e:	676080e7          	jalr	1654(ra) # 80000b10 <kalloc>
    800014a2:	84aa                	mv	s1,a0
    if(mem == 0){
    800014a4:	c51d                	beqz	a0,800014d2 <uvmalloc+0x64>
    memset(mem, 0, PGSIZE);
    800014a6:	6605                	lui	a2,0x1
    800014a8:	4581                	li	a1,0
    800014aa:	00000097          	auipc	ra,0x0
    800014ae:	852080e7          	jalr	-1966(ra) # 80000cfc <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_W|PTE_X|PTE_R|PTE_U) != 0){
    800014b2:	4779                	li	a4,30
    800014b4:	86a6                	mv	a3,s1
    800014b6:	6605                	lui	a2,0x1
    800014b8:	85ca                	mv	a1,s2
    800014ba:	8556                	mv	a0,s5
    800014bc:	00000097          	auipc	ra,0x0
    800014c0:	c6e080e7          	jalr	-914(ra) # 8000112a <mappages>
    800014c4:	e905                	bnez	a0,800014f4 <uvmalloc+0x86>
  for(a = oldsz; a < newsz; a += PGSIZE){
    800014c6:	6785                	lui	a5,0x1
    800014c8:	993e                	add	s2,s2,a5
    800014ca:	fd4968e3          	bltu	s2,s4,8000149a <uvmalloc+0x2c>
  return newsz;
    800014ce:	8552                	mv	a0,s4
    800014d0:	a809                	j	800014e2 <uvmalloc+0x74>
      uvmdealloc(pagetable, a, oldsz);
    800014d2:	864e                	mv	a2,s3
    800014d4:	85ca                	mv	a1,s2
    800014d6:	8556                	mv	a0,s5
    800014d8:	00000097          	auipc	ra,0x0
    800014dc:	f4e080e7          	jalr	-178(ra) # 80001426 <uvmdealloc>
      return 0;
    800014e0:	4501                	li	a0,0
}
    800014e2:	70e2                	ld	ra,56(sp)
    800014e4:	7442                	ld	s0,48(sp)
    800014e6:	74a2                	ld	s1,40(sp)
    800014e8:	7902                	ld	s2,32(sp)
    800014ea:	69e2                	ld	s3,24(sp)
    800014ec:	6a42                	ld	s4,16(sp)
    800014ee:	6aa2                	ld	s5,8(sp)
    800014f0:	6121                	addi	sp,sp,64
    800014f2:	8082                	ret
      kfree(mem);
    800014f4:	8526                	mv	a0,s1
    800014f6:	fffff097          	auipc	ra,0xfffff
    800014fa:	51c080e7          	jalr	1308(ra) # 80000a12 <kfree>
      uvmdealloc(pagetable, a, oldsz);
    800014fe:	864e                	mv	a2,s3
    80001500:	85ca                	mv	a1,s2
    80001502:	8556                	mv	a0,s5
    80001504:	00000097          	auipc	ra,0x0
    80001508:	f22080e7          	jalr	-222(ra) # 80001426 <uvmdealloc>
      return 0;
    8000150c:	4501                	li	a0,0
    8000150e:	bfd1                	j	800014e2 <uvmalloc+0x74>
    return oldsz;
    80001510:	852e                	mv	a0,a1
}
    80001512:	8082                	ret
  return newsz;
    80001514:	8532                	mv	a0,a2
    80001516:	b7f1                	j	800014e2 <uvmalloc+0x74>

0000000080001518 <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    80001518:	7179                	addi	sp,sp,-48
    8000151a:	f406                	sd	ra,40(sp)
    8000151c:	f022                	sd	s0,32(sp)
    8000151e:	ec26                	sd	s1,24(sp)
    80001520:	e84a                	sd	s2,16(sp)
    80001522:	e44e                	sd	s3,8(sp)
    80001524:	e052                	sd	s4,0(sp)
    80001526:	1800                	addi	s0,sp,48
    80001528:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    8000152a:	84aa                	mv	s1,a0
    8000152c:	6905                	lui	s2,0x1
    8000152e:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80001530:	4985                	li	s3,1
    80001532:	a829                	j	8000154c <freewalk+0x34>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    80001534:	83a9                	srli	a5,a5,0xa
      freewalk((pagetable_t)child);
    80001536:	00c79513          	slli	a0,a5,0xc
    8000153a:	00000097          	auipc	ra,0x0
    8000153e:	fde080e7          	jalr	-34(ra) # 80001518 <freewalk>
      pagetable[i] = 0;
    80001542:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    80001546:	04a1                	addi	s1,s1,8
    80001548:	03248163          	beq	s1,s2,8000156a <freewalk+0x52>
    pte_t pte = pagetable[i];
    8000154c:	609c                	ld	a5,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    8000154e:	00f7f713          	andi	a4,a5,15
    80001552:	ff3701e3          	beq	a4,s3,80001534 <freewalk+0x1c>
    } else if(pte & PTE_V){
    80001556:	8b85                	andi	a5,a5,1
    80001558:	d7fd                	beqz	a5,80001546 <freewalk+0x2e>
      panic("freewalk: leaf");
    8000155a:	00007517          	auipc	a0,0x7
    8000155e:	c0e50513          	addi	a0,a0,-1010 # 80008168 <digits+0x128>
    80001562:	fffff097          	auipc	ra,0xfffff
    80001566:	fe4080e7          	jalr	-28(ra) # 80000546 <panic>
    }
  }
  kfree((void*)pagetable);
    8000156a:	8552                	mv	a0,s4
    8000156c:	fffff097          	auipc	ra,0xfffff
    80001570:	4a6080e7          	jalr	1190(ra) # 80000a12 <kfree>
}
    80001574:	70a2                	ld	ra,40(sp)
    80001576:	7402                	ld	s0,32(sp)
    80001578:	64e2                	ld	s1,24(sp)
    8000157a:	6942                	ld	s2,16(sp)
    8000157c:	69a2                	ld	s3,8(sp)
    8000157e:	6a02                	ld	s4,0(sp)
    80001580:	6145                	addi	sp,sp,48
    80001582:	8082                	ret

0000000080001584 <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    80001584:	1101                	addi	sp,sp,-32
    80001586:	ec06                	sd	ra,24(sp)
    80001588:	e822                	sd	s0,16(sp)
    8000158a:	e426                	sd	s1,8(sp)
    8000158c:	1000                	addi	s0,sp,32
    8000158e:	84aa                	mv	s1,a0
  if(sz > 0)
    80001590:	e999                	bnez	a1,800015a6 <uvmfree+0x22>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    80001592:	8526                	mv	a0,s1
    80001594:	00000097          	auipc	ra,0x0
    80001598:	f84080e7          	jalr	-124(ra) # 80001518 <freewalk>
}
    8000159c:	60e2                	ld	ra,24(sp)
    8000159e:	6442                	ld	s0,16(sp)
    800015a0:	64a2                	ld	s1,8(sp)
    800015a2:	6105                	addi	sp,sp,32
    800015a4:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    800015a6:	6785                	lui	a5,0x1
    800015a8:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800015aa:	95be                	add	a1,a1,a5
    800015ac:	4685                	li	a3,1
    800015ae:	00c5d613          	srli	a2,a1,0xc
    800015b2:	4581                	li	a1,0
    800015b4:	00000097          	auipc	ra,0x0
    800015b8:	d0e080e7          	jalr	-754(ra) # 800012c2 <uvmunmap>
    800015bc:	bfd9                	j	80001592 <uvmfree+0xe>

00000000800015be <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for(i = 0; i < sz; i += PGSIZE){
    800015be:	c679                	beqz	a2,8000168c <uvmcopy+0xce>
{
    800015c0:	715d                	addi	sp,sp,-80
    800015c2:	e486                	sd	ra,72(sp)
    800015c4:	e0a2                	sd	s0,64(sp)
    800015c6:	fc26                	sd	s1,56(sp)
    800015c8:	f84a                	sd	s2,48(sp)
    800015ca:	f44e                	sd	s3,40(sp)
    800015cc:	f052                	sd	s4,32(sp)
    800015ce:	ec56                	sd	s5,24(sp)
    800015d0:	e85a                	sd	s6,16(sp)
    800015d2:	e45e                	sd	s7,8(sp)
    800015d4:	0880                	addi	s0,sp,80
    800015d6:	8b2a                	mv	s6,a0
    800015d8:	8aae                	mv	s5,a1
    800015da:	8a32                	mv	s4,a2
  for(i = 0; i < sz; i += PGSIZE){
    800015dc:	4981                	li	s3,0
    if((pte = walk(old, i, 0)) == 0)
    800015de:	4601                	li	a2,0
    800015e0:	85ce                	mv	a1,s3
    800015e2:	855a                	mv	a0,s6
    800015e4:	00000097          	auipc	ra,0x0
    800015e8:	a00080e7          	jalr	-1536(ra) # 80000fe4 <walk>
    800015ec:	c531                	beqz	a0,80001638 <uvmcopy+0x7a>
      panic("uvmcopy: pte should exist");
    if((*pte & PTE_V) == 0)
    800015ee:	6118                	ld	a4,0(a0)
    800015f0:	00177793          	andi	a5,a4,1
    800015f4:	cbb1                	beqz	a5,80001648 <uvmcopy+0x8a>
      panic("uvmcopy: page not present");
    pa = PTE2PA(*pte);
    800015f6:	00a75593          	srli	a1,a4,0xa
    800015fa:	00c59b93          	slli	s7,a1,0xc
    flags = PTE_FLAGS(*pte);
    800015fe:	3ff77493          	andi	s1,a4,1023
    if((mem = kalloc()) == 0)
    80001602:	fffff097          	auipc	ra,0xfffff
    80001606:	50e080e7          	jalr	1294(ra) # 80000b10 <kalloc>
    8000160a:	892a                	mv	s2,a0
    8000160c:	c939                	beqz	a0,80001662 <uvmcopy+0xa4>
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    8000160e:	6605                	lui	a2,0x1
    80001610:	85de                	mv	a1,s7
    80001612:	fffff097          	auipc	ra,0xfffff
    80001616:	746080e7          	jalr	1862(ra) # 80000d58 <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    8000161a:	8726                	mv	a4,s1
    8000161c:	86ca                	mv	a3,s2
    8000161e:	6605                	lui	a2,0x1
    80001620:	85ce                	mv	a1,s3
    80001622:	8556                	mv	a0,s5
    80001624:	00000097          	auipc	ra,0x0
    80001628:	b06080e7          	jalr	-1274(ra) # 8000112a <mappages>
    8000162c:	e515                	bnez	a0,80001658 <uvmcopy+0x9a>
  for(i = 0; i < sz; i += PGSIZE){
    8000162e:	6785                	lui	a5,0x1
    80001630:	99be                	add	s3,s3,a5
    80001632:	fb49e6e3          	bltu	s3,s4,800015de <uvmcopy+0x20>
    80001636:	a081                	j	80001676 <uvmcopy+0xb8>
      panic("uvmcopy: pte should exist");
    80001638:	00007517          	auipc	a0,0x7
    8000163c:	b4050513          	addi	a0,a0,-1216 # 80008178 <digits+0x138>
    80001640:	fffff097          	auipc	ra,0xfffff
    80001644:	f06080e7          	jalr	-250(ra) # 80000546 <panic>
      panic("uvmcopy: page not present");
    80001648:	00007517          	auipc	a0,0x7
    8000164c:	b5050513          	addi	a0,a0,-1200 # 80008198 <digits+0x158>
    80001650:	fffff097          	auipc	ra,0xfffff
    80001654:	ef6080e7          	jalr	-266(ra) # 80000546 <panic>
      kfree(mem);
    80001658:	854a                	mv	a0,s2
    8000165a:	fffff097          	auipc	ra,0xfffff
    8000165e:	3b8080e7          	jalr	952(ra) # 80000a12 <kfree>
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    80001662:	4685                	li	a3,1
    80001664:	00c9d613          	srli	a2,s3,0xc
    80001668:	4581                	li	a1,0
    8000166a:	8556                	mv	a0,s5
    8000166c:	00000097          	auipc	ra,0x0
    80001670:	c56080e7          	jalr	-938(ra) # 800012c2 <uvmunmap>
  return -1;
    80001674:	557d                	li	a0,-1
}
    80001676:	60a6                	ld	ra,72(sp)
    80001678:	6406                	ld	s0,64(sp)
    8000167a:	74e2                	ld	s1,56(sp)
    8000167c:	7942                	ld	s2,48(sp)
    8000167e:	79a2                	ld	s3,40(sp)
    80001680:	7a02                	ld	s4,32(sp)
    80001682:	6ae2                	ld	s5,24(sp)
    80001684:	6b42                	ld	s6,16(sp)
    80001686:	6ba2                	ld	s7,8(sp)
    80001688:	6161                	addi	sp,sp,80
    8000168a:	8082                	ret
  return 0;
    8000168c:	4501                	li	a0,0
}
    8000168e:	8082                	ret

0000000080001690 <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    80001690:	1141                	addi	sp,sp,-16
    80001692:	e406                	sd	ra,8(sp)
    80001694:	e022                	sd	s0,0(sp)
    80001696:	0800                	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    80001698:	4601                	li	a2,0
    8000169a:	00000097          	auipc	ra,0x0
    8000169e:	94a080e7          	jalr	-1718(ra) # 80000fe4 <walk>
  if(pte == 0)
    800016a2:	c901                	beqz	a0,800016b2 <uvmclear+0x22>
    panic("uvmclear");
  *pte &= ~PTE_U;
    800016a4:	611c                	ld	a5,0(a0)
    800016a6:	9bbd                	andi	a5,a5,-17
    800016a8:	e11c                	sd	a5,0(a0)
}
    800016aa:	60a2                	ld	ra,8(sp)
    800016ac:	6402                	ld	s0,0(sp)
    800016ae:	0141                	addi	sp,sp,16
    800016b0:	8082                	ret
    panic("uvmclear");
    800016b2:	00007517          	auipc	a0,0x7
    800016b6:	b0650513          	addi	a0,a0,-1274 # 800081b8 <digits+0x178>
    800016ba:	fffff097          	auipc	ra,0xfffff
    800016be:	e8c080e7          	jalr	-372(ra) # 80000546 <panic>

00000000800016c2 <copyout>:
int
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    800016c2:	c6bd                	beqz	a3,80001730 <copyout+0x6e>
{
    800016c4:	715d                	addi	sp,sp,-80
    800016c6:	e486                	sd	ra,72(sp)
    800016c8:	e0a2                	sd	s0,64(sp)
    800016ca:	fc26                	sd	s1,56(sp)
    800016cc:	f84a                	sd	s2,48(sp)
    800016ce:	f44e                	sd	s3,40(sp)
    800016d0:	f052                	sd	s4,32(sp)
    800016d2:	ec56                	sd	s5,24(sp)
    800016d4:	e85a                	sd	s6,16(sp)
    800016d6:	e45e                	sd	s7,8(sp)
    800016d8:	e062                	sd	s8,0(sp)
    800016da:	0880                	addi	s0,sp,80
    800016dc:	8b2a                	mv	s6,a0
    800016de:	8c2e                	mv	s8,a1
    800016e0:	8a32                	mv	s4,a2
    800016e2:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(dstva);
    800016e4:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (dstva - va0);
    800016e6:	6a85                	lui	s5,0x1
    800016e8:	a015                	j	8000170c <copyout+0x4a>
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    800016ea:	9562                	add	a0,a0,s8
    800016ec:	0004861b          	sext.w	a2,s1
    800016f0:	85d2                	mv	a1,s4
    800016f2:	41250533          	sub	a0,a0,s2
    800016f6:	fffff097          	auipc	ra,0xfffff
    800016fa:	662080e7          	jalr	1634(ra) # 80000d58 <memmove>

    len -= n;
    800016fe:	409989b3          	sub	s3,s3,s1
    src += n;
    80001702:	9a26                	add	s4,s4,s1
    dstva = va0 + PGSIZE;
    80001704:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80001708:	02098263          	beqz	s3,8000172c <copyout+0x6a>
    va0 = PGROUNDDOWN(dstva);
    8000170c:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80001710:	85ca                	mv	a1,s2
    80001712:	855a                	mv	a0,s6
    80001714:	00000097          	auipc	ra,0x0
    80001718:	976080e7          	jalr	-1674(ra) # 8000108a <walkaddr>
    if(pa0 == 0)
    8000171c:	cd01                	beqz	a0,80001734 <copyout+0x72>
    n = PGSIZE - (dstva - va0);
    8000171e:	418904b3          	sub	s1,s2,s8
    80001722:	94d6                	add	s1,s1,s5
    80001724:	fc99f3e3          	bgeu	s3,s1,800016ea <copyout+0x28>
    80001728:	84ce                	mv	s1,s3
    8000172a:	b7c1                	j	800016ea <copyout+0x28>
  }
  return 0;
    8000172c:	4501                	li	a0,0
    8000172e:	a021                	j	80001736 <copyout+0x74>
    80001730:	4501                	li	a0,0
}
    80001732:	8082                	ret
      return -1;
    80001734:	557d                	li	a0,-1
}
    80001736:	60a6                	ld	ra,72(sp)
    80001738:	6406                	ld	s0,64(sp)
    8000173a:	74e2                	ld	s1,56(sp)
    8000173c:	7942                	ld	s2,48(sp)
    8000173e:	79a2                	ld	s3,40(sp)
    80001740:	7a02                	ld	s4,32(sp)
    80001742:	6ae2                	ld	s5,24(sp)
    80001744:	6b42                	ld	s6,16(sp)
    80001746:	6ba2                	ld	s7,8(sp)
    80001748:	6c02                	ld	s8,0(sp)
    8000174a:	6161                	addi	sp,sp,80
    8000174c:	8082                	ret

000000008000174e <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    8000174e:	caa5                	beqz	a3,800017be <copyin+0x70>
{
    80001750:	715d                	addi	sp,sp,-80
    80001752:	e486                	sd	ra,72(sp)
    80001754:	e0a2                	sd	s0,64(sp)
    80001756:	fc26                	sd	s1,56(sp)
    80001758:	f84a                	sd	s2,48(sp)
    8000175a:	f44e                	sd	s3,40(sp)
    8000175c:	f052                	sd	s4,32(sp)
    8000175e:	ec56                	sd	s5,24(sp)
    80001760:	e85a                	sd	s6,16(sp)
    80001762:	e45e                	sd	s7,8(sp)
    80001764:	e062                	sd	s8,0(sp)
    80001766:	0880                	addi	s0,sp,80
    80001768:	8b2a                	mv	s6,a0
    8000176a:	8a2e                	mv	s4,a1
    8000176c:	8c32                	mv	s8,a2
    8000176e:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    80001770:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80001772:	6a85                	lui	s5,0x1
    80001774:	a01d                	j	8000179a <copyin+0x4c>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80001776:	018505b3          	add	a1,a0,s8
    8000177a:	0004861b          	sext.w	a2,s1
    8000177e:	412585b3          	sub	a1,a1,s2
    80001782:	8552                	mv	a0,s4
    80001784:	fffff097          	auipc	ra,0xfffff
    80001788:	5d4080e7          	jalr	1492(ra) # 80000d58 <memmove>

    len -= n;
    8000178c:	409989b3          	sub	s3,s3,s1
    dst += n;
    80001790:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    80001792:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80001796:	02098263          	beqz	s3,800017ba <copyin+0x6c>
    va0 = PGROUNDDOWN(srcva);
    8000179a:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    8000179e:	85ca                	mv	a1,s2
    800017a0:	855a                	mv	a0,s6
    800017a2:	00000097          	auipc	ra,0x0
    800017a6:	8e8080e7          	jalr	-1816(ra) # 8000108a <walkaddr>
    if(pa0 == 0)
    800017aa:	cd01                	beqz	a0,800017c2 <copyin+0x74>
    n = PGSIZE - (srcva - va0);
    800017ac:	418904b3          	sub	s1,s2,s8
    800017b0:	94d6                	add	s1,s1,s5
    800017b2:	fc99f2e3          	bgeu	s3,s1,80001776 <copyin+0x28>
    800017b6:	84ce                	mv	s1,s3
    800017b8:	bf7d                	j	80001776 <copyin+0x28>
  }
  return 0;
    800017ba:	4501                	li	a0,0
    800017bc:	a021                	j	800017c4 <copyin+0x76>
    800017be:	4501                	li	a0,0
}
    800017c0:	8082                	ret
      return -1;
    800017c2:	557d                	li	a0,-1
}
    800017c4:	60a6                	ld	ra,72(sp)
    800017c6:	6406                	ld	s0,64(sp)
    800017c8:	74e2                	ld	s1,56(sp)
    800017ca:	7942                	ld	s2,48(sp)
    800017cc:	79a2                	ld	s3,40(sp)
    800017ce:	7a02                	ld	s4,32(sp)
    800017d0:	6ae2                	ld	s5,24(sp)
    800017d2:	6b42                	ld	s6,16(sp)
    800017d4:	6ba2                	ld	s7,8(sp)
    800017d6:	6c02                	ld	s8,0(sp)
    800017d8:	6161                	addi	sp,sp,80
    800017da:	8082                	ret

00000000800017dc <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    800017dc:	c2dd                	beqz	a3,80001882 <copyinstr+0xa6>
{
    800017de:	715d                	addi	sp,sp,-80
    800017e0:	e486                	sd	ra,72(sp)
    800017e2:	e0a2                	sd	s0,64(sp)
    800017e4:	fc26                	sd	s1,56(sp)
    800017e6:	f84a                	sd	s2,48(sp)
    800017e8:	f44e                	sd	s3,40(sp)
    800017ea:	f052                	sd	s4,32(sp)
    800017ec:	ec56                	sd	s5,24(sp)
    800017ee:	e85a                	sd	s6,16(sp)
    800017f0:	e45e                	sd	s7,8(sp)
    800017f2:	0880                	addi	s0,sp,80
    800017f4:	8a2a                	mv	s4,a0
    800017f6:	8b2e                	mv	s6,a1
    800017f8:	8bb2                	mv	s7,a2
    800017fa:	84b6                	mv	s1,a3
    va0 = PGROUNDDOWN(srcva);
    800017fc:	7afd                	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    800017fe:	6985                	lui	s3,0x1
    80001800:	a02d                	j	8000182a <copyinstr+0x4e>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    80001802:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    80001806:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    80001808:	37fd                	addiw	a5,a5,-1
    8000180a:	0007851b          	sext.w	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    8000180e:	60a6                	ld	ra,72(sp)
    80001810:	6406                	ld	s0,64(sp)
    80001812:	74e2                	ld	s1,56(sp)
    80001814:	7942                	ld	s2,48(sp)
    80001816:	79a2                	ld	s3,40(sp)
    80001818:	7a02                	ld	s4,32(sp)
    8000181a:	6ae2                	ld	s5,24(sp)
    8000181c:	6b42                	ld	s6,16(sp)
    8000181e:	6ba2                	ld	s7,8(sp)
    80001820:	6161                	addi	sp,sp,80
    80001822:	8082                	ret
    srcva = va0 + PGSIZE;
    80001824:	01390bb3          	add	s7,s2,s3
  while(got_null == 0 && max > 0){
    80001828:	c8a9                	beqz	s1,8000187a <copyinstr+0x9e>
    va0 = PGROUNDDOWN(srcva);
    8000182a:	015bf933          	and	s2,s7,s5
    pa0 = walkaddr(pagetable, va0);
    8000182e:	85ca                	mv	a1,s2
    80001830:	8552                	mv	a0,s4
    80001832:	00000097          	auipc	ra,0x0
    80001836:	858080e7          	jalr	-1960(ra) # 8000108a <walkaddr>
    if(pa0 == 0)
    8000183a:	c131                	beqz	a0,8000187e <copyinstr+0xa2>
    n = PGSIZE - (srcva - va0);
    8000183c:	417906b3          	sub	a3,s2,s7
    80001840:	96ce                	add	a3,a3,s3
    80001842:	00d4f363          	bgeu	s1,a3,80001848 <copyinstr+0x6c>
    80001846:	86a6                	mv	a3,s1
    char *p = (char *) (pa0 + (srcva - va0));
    80001848:	955e                	add	a0,a0,s7
    8000184a:	41250533          	sub	a0,a0,s2
    while(n > 0){
    8000184e:	daf9                	beqz	a3,80001824 <copyinstr+0x48>
    80001850:	87da                	mv	a5,s6
      if(*p == '\0'){
    80001852:	41650633          	sub	a2,a0,s6
    80001856:	fff48593          	addi	a1,s1,-1
    8000185a:	95da                	add	a1,a1,s6
    while(n > 0){
    8000185c:	96da                	add	a3,a3,s6
      if(*p == '\0'){
    8000185e:	00f60733          	add	a4,a2,a5
    80001862:	00074703          	lbu	a4,0(a4)
    80001866:	df51                	beqz	a4,80001802 <copyinstr+0x26>
        *dst = *p;
    80001868:	00e78023          	sb	a4,0(a5)
      --max;
    8000186c:	40f584b3          	sub	s1,a1,a5
      dst++;
    80001870:	0785                	addi	a5,a5,1
    while(n > 0){
    80001872:	fed796e3          	bne	a5,a3,8000185e <copyinstr+0x82>
      dst++;
    80001876:	8b3e                	mv	s6,a5
    80001878:	b775                	j	80001824 <copyinstr+0x48>
    8000187a:	4781                	li	a5,0
    8000187c:	b771                	j	80001808 <copyinstr+0x2c>
      return -1;
    8000187e:	557d                	li	a0,-1
    80001880:	b779                	j	8000180e <copyinstr+0x32>
  int got_null = 0;
    80001882:	4781                	li	a5,0
  if(got_null){
    80001884:	37fd                	addiw	a5,a5,-1
    80001886:	0007851b          	sext.w	a0,a5
}
    8000188a:	8082                	ret

000000008000188c <wakeup1>:

// Wake up p if it is sleeping in wait(); used by exit().
// Caller must hold p->lock.
static void
wakeup1(struct proc *p)
{
    8000188c:	1101                	addi	sp,sp,-32
    8000188e:	ec06                	sd	ra,24(sp)
    80001890:	e822                	sd	s0,16(sp)
    80001892:	e426                	sd	s1,8(sp)
    80001894:	1000                	addi	s0,sp,32
    80001896:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    80001898:	fffff097          	auipc	ra,0xfffff
    8000189c:	2ee080e7          	jalr	750(ra) # 80000b86 <holding>
    800018a0:	c909                	beqz	a0,800018b2 <wakeup1+0x26>
    panic("wakeup1");
  if(p->chan == p && p->state == SLEEPING) {
    800018a2:	749c                	ld	a5,40(s1)
    800018a4:	00978f63          	beq	a5,s1,800018c2 <wakeup1+0x36>
    p->state = RUNNABLE;
  }
}
    800018a8:	60e2                	ld	ra,24(sp)
    800018aa:	6442                	ld	s0,16(sp)
    800018ac:	64a2                	ld	s1,8(sp)
    800018ae:	6105                	addi	sp,sp,32
    800018b0:	8082                	ret
    panic("wakeup1");
    800018b2:	00007517          	auipc	a0,0x7
    800018b6:	91650513          	addi	a0,a0,-1770 # 800081c8 <digits+0x188>
    800018ba:	fffff097          	auipc	ra,0xfffff
    800018be:	c8c080e7          	jalr	-884(ra) # 80000546 <panic>
  if(p->chan == p && p->state == SLEEPING) {
    800018c2:	4c98                	lw	a4,24(s1)
    800018c4:	4785                	li	a5,1
    800018c6:	fef711e3          	bne	a4,a5,800018a8 <wakeup1+0x1c>
    p->state = RUNNABLE;
    800018ca:	4789                	li	a5,2
    800018cc:	cc9c                	sw	a5,24(s1)
}
    800018ce:	bfe9                	j	800018a8 <wakeup1+0x1c>

00000000800018d0 <procinit>:
{
    800018d0:	715d                	addi	sp,sp,-80
    800018d2:	e486                	sd	ra,72(sp)
    800018d4:	e0a2                	sd	s0,64(sp)
    800018d6:	fc26                	sd	s1,56(sp)
    800018d8:	f84a                	sd	s2,48(sp)
    800018da:	f44e                	sd	s3,40(sp)
    800018dc:	f052                	sd	s4,32(sp)
    800018de:	ec56                	sd	s5,24(sp)
    800018e0:	e85a                	sd	s6,16(sp)
    800018e2:	e45e                	sd	s7,8(sp)
    800018e4:	0880                	addi	s0,sp,80
  initlock(&pid_lock, "nextpid");
    800018e6:	00007597          	auipc	a1,0x7
    800018ea:	8ea58593          	addi	a1,a1,-1814 # 800081d0 <digits+0x190>
    800018ee:	00010517          	auipc	a0,0x10
    800018f2:	06250513          	addi	a0,a0,98 # 80011950 <pid_lock>
    800018f6:	fffff097          	auipc	ra,0xfffff
    800018fa:	27a080e7          	jalr	634(ra) # 80000b70 <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    800018fe:	00010917          	auipc	s2,0x10
    80001902:	46a90913          	addi	s2,s2,1130 # 80011d68 <proc>
      initlock(&p->lock, "proc");
    80001906:	00007b97          	auipc	s7,0x7
    8000190a:	8d2b8b93          	addi	s7,s7,-1838 # 800081d8 <digits+0x198>
      uint64 va = KSTACK((int) (p - proc));
    8000190e:	8b4a                	mv	s6,s2
    80001910:	00006a97          	auipc	s5,0x6
    80001914:	6f0a8a93          	addi	s5,s5,1776 # 80008000 <etext>
    80001918:	040009b7          	lui	s3,0x4000
    8000191c:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    8000191e:	09b2                	slli	s3,s3,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80001920:	00016a17          	auipc	s4,0x16
    80001924:	e48a0a13          	addi	s4,s4,-440 # 80017768 <tickslock>
      initlock(&p->lock, "proc");
    80001928:	85de                	mv	a1,s7
    8000192a:	854a                	mv	a0,s2
    8000192c:	fffff097          	auipc	ra,0xfffff
    80001930:	244080e7          	jalr	580(ra) # 80000b70 <initlock>
      char *pa = kalloc();
    80001934:	fffff097          	auipc	ra,0xfffff
    80001938:	1dc080e7          	jalr	476(ra) # 80000b10 <kalloc>
    8000193c:	85aa                	mv	a1,a0
      if(pa == 0)
    8000193e:	c929                	beqz	a0,80001990 <procinit+0xc0>
      uint64 va = KSTACK((int) (p - proc));
    80001940:	416904b3          	sub	s1,s2,s6
    80001944:	848d                	srai	s1,s1,0x3
    80001946:	000ab783          	ld	a5,0(s5)
    8000194a:	02f484b3          	mul	s1,s1,a5
    8000194e:	2485                	addiw	s1,s1,1
    80001950:	00d4949b          	slliw	s1,s1,0xd
    80001954:	409984b3          	sub	s1,s3,s1
      kvmmap(va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80001958:	4699                	li	a3,6
    8000195a:	6605                	lui	a2,0x1
    8000195c:	8526                	mv	a0,s1
    8000195e:	00000097          	auipc	ra,0x0
    80001962:	85a080e7          	jalr	-1958(ra) # 800011b8 <kvmmap>
      p->kstack = va;
    80001966:	04993023          	sd	s1,64(s2)
  for(p = proc; p < &proc[NPROC]; p++) {
    8000196a:	16890913          	addi	s2,s2,360
    8000196e:	fb491de3          	bne	s2,s4,80001928 <procinit+0x58>
  kvminithart();
    80001972:	fffff097          	auipc	ra,0xfffff
    80001976:	64e080e7          	jalr	1614(ra) # 80000fc0 <kvminithart>
}
    8000197a:	60a6                	ld	ra,72(sp)
    8000197c:	6406                	ld	s0,64(sp)
    8000197e:	74e2                	ld	s1,56(sp)
    80001980:	7942                	ld	s2,48(sp)
    80001982:	79a2                	ld	s3,40(sp)
    80001984:	7a02                	ld	s4,32(sp)
    80001986:	6ae2                	ld	s5,24(sp)
    80001988:	6b42                	ld	s6,16(sp)
    8000198a:	6ba2                	ld	s7,8(sp)
    8000198c:	6161                	addi	sp,sp,80
    8000198e:	8082                	ret
        panic("kalloc");
    80001990:	00007517          	auipc	a0,0x7
    80001994:	85050513          	addi	a0,a0,-1968 # 800081e0 <digits+0x1a0>
    80001998:	fffff097          	auipc	ra,0xfffff
    8000199c:	bae080e7          	jalr	-1106(ra) # 80000546 <panic>

00000000800019a0 <cpuid>:
{
    800019a0:	1141                	addi	sp,sp,-16
    800019a2:	e422                	sd	s0,8(sp)
    800019a4:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    800019a6:	8512                	mv	a0,tp
}
    800019a8:	2501                	sext.w	a0,a0
    800019aa:	6422                	ld	s0,8(sp)
    800019ac:	0141                	addi	sp,sp,16
    800019ae:	8082                	ret

00000000800019b0 <mycpu>:
mycpu(void) {
    800019b0:	1141                	addi	sp,sp,-16
    800019b2:	e422                	sd	s0,8(sp)
    800019b4:	0800                	addi	s0,sp,16
    800019b6:	8792                	mv	a5,tp
  struct cpu *c = &cpus[id];
    800019b8:	2781                	sext.w	a5,a5
    800019ba:	079e                	slli	a5,a5,0x7
}
    800019bc:	00010517          	auipc	a0,0x10
    800019c0:	fac50513          	addi	a0,a0,-84 # 80011968 <cpus>
    800019c4:	953e                	add	a0,a0,a5
    800019c6:	6422                	ld	s0,8(sp)
    800019c8:	0141                	addi	sp,sp,16
    800019ca:	8082                	ret

00000000800019cc <myproc>:
myproc(void) {
    800019cc:	1101                	addi	sp,sp,-32
    800019ce:	ec06                	sd	ra,24(sp)
    800019d0:	e822                	sd	s0,16(sp)
    800019d2:	e426                	sd	s1,8(sp)
    800019d4:	1000                	addi	s0,sp,32
  push_off();
    800019d6:	fffff097          	auipc	ra,0xfffff
    800019da:	1de080e7          	jalr	478(ra) # 80000bb4 <push_off>
    800019de:	8792                	mv	a5,tp
  struct proc *p = c->proc;
    800019e0:	2781                	sext.w	a5,a5
    800019e2:	079e                	slli	a5,a5,0x7
    800019e4:	00010717          	auipc	a4,0x10
    800019e8:	f6c70713          	addi	a4,a4,-148 # 80011950 <pid_lock>
    800019ec:	97ba                	add	a5,a5,a4
    800019ee:	6f84                	ld	s1,24(a5)
  pop_off();
    800019f0:	fffff097          	auipc	ra,0xfffff
    800019f4:	264080e7          	jalr	612(ra) # 80000c54 <pop_off>
}
    800019f8:	8526                	mv	a0,s1
    800019fa:	60e2                	ld	ra,24(sp)
    800019fc:	6442                	ld	s0,16(sp)
    800019fe:	64a2                	ld	s1,8(sp)
    80001a00:	6105                	addi	sp,sp,32
    80001a02:	8082                	ret

0000000080001a04 <forkret>:
{
    80001a04:	1141                	addi	sp,sp,-16
    80001a06:	e406                	sd	ra,8(sp)
    80001a08:	e022                	sd	s0,0(sp)
    80001a0a:	0800                	addi	s0,sp,16
  release(&myproc()->lock);
    80001a0c:	00000097          	auipc	ra,0x0
    80001a10:	fc0080e7          	jalr	-64(ra) # 800019cc <myproc>
    80001a14:	fffff097          	auipc	ra,0xfffff
    80001a18:	2a0080e7          	jalr	672(ra) # 80000cb4 <release>
  if (first) {
    80001a1c:	00007797          	auipc	a5,0x7
    80001a20:	df47a783          	lw	a5,-524(a5) # 80008810 <first.1>
    80001a24:	eb89                	bnez	a5,80001a36 <forkret+0x32>
  usertrapret();
    80001a26:	00001097          	auipc	ra,0x1
    80001a2a:	c1a080e7          	jalr	-998(ra) # 80002640 <usertrapret>
}
    80001a2e:	60a2                	ld	ra,8(sp)
    80001a30:	6402                	ld	s0,0(sp)
    80001a32:	0141                	addi	sp,sp,16
    80001a34:	8082                	ret
    first = 0;
    80001a36:	00007797          	auipc	a5,0x7
    80001a3a:	dc07ad23          	sw	zero,-550(a5) # 80008810 <first.1>
    fsinit(ROOTDEV);
    80001a3e:	4505                	li	a0,1
    80001a40:	00002097          	auipc	ra,0x2
    80001a44:	940080e7          	jalr	-1728(ra) # 80003380 <fsinit>
    80001a48:	bff9                	j	80001a26 <forkret+0x22>

0000000080001a4a <allocpid>:
allocpid() {
    80001a4a:	1101                	addi	sp,sp,-32
    80001a4c:	ec06                	sd	ra,24(sp)
    80001a4e:	e822                	sd	s0,16(sp)
    80001a50:	e426                	sd	s1,8(sp)
    80001a52:	e04a                	sd	s2,0(sp)
    80001a54:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80001a56:	00010917          	auipc	s2,0x10
    80001a5a:	efa90913          	addi	s2,s2,-262 # 80011950 <pid_lock>
    80001a5e:	854a                	mv	a0,s2
    80001a60:	fffff097          	auipc	ra,0xfffff
    80001a64:	1a0080e7          	jalr	416(ra) # 80000c00 <acquire>
  pid = nextpid;
    80001a68:	00007797          	auipc	a5,0x7
    80001a6c:	dac78793          	addi	a5,a5,-596 # 80008814 <nextpid>
    80001a70:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80001a72:	0014871b          	addiw	a4,s1,1
    80001a76:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80001a78:	854a                	mv	a0,s2
    80001a7a:	fffff097          	auipc	ra,0xfffff
    80001a7e:	23a080e7          	jalr	570(ra) # 80000cb4 <release>
}
    80001a82:	8526                	mv	a0,s1
    80001a84:	60e2                	ld	ra,24(sp)
    80001a86:	6442                	ld	s0,16(sp)
    80001a88:	64a2                	ld	s1,8(sp)
    80001a8a:	6902                	ld	s2,0(sp)
    80001a8c:	6105                	addi	sp,sp,32
    80001a8e:	8082                	ret

0000000080001a90 <proc_pagetable>:
{
    80001a90:	1101                	addi	sp,sp,-32
    80001a92:	ec06                	sd	ra,24(sp)
    80001a94:	e822                	sd	s0,16(sp)
    80001a96:	e426                	sd	s1,8(sp)
    80001a98:	e04a                	sd	s2,0(sp)
    80001a9a:	1000                	addi	s0,sp,32
    80001a9c:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80001a9e:	00000097          	auipc	ra,0x0
    80001aa2:	8e8080e7          	jalr	-1816(ra) # 80001386 <uvmcreate>
    80001aa6:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80001aa8:	c121                	beqz	a0,80001ae8 <proc_pagetable+0x58>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    80001aaa:	4729                	li	a4,10
    80001aac:	00005697          	auipc	a3,0x5
    80001ab0:	55468693          	addi	a3,a3,1364 # 80007000 <_trampoline>
    80001ab4:	6605                	lui	a2,0x1
    80001ab6:	040005b7          	lui	a1,0x4000
    80001aba:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001abc:	05b2                	slli	a1,a1,0xc
    80001abe:	fffff097          	auipc	ra,0xfffff
    80001ac2:	66c080e7          	jalr	1644(ra) # 8000112a <mappages>
    80001ac6:	02054863          	bltz	a0,80001af6 <proc_pagetable+0x66>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    80001aca:	4719                	li	a4,6
    80001acc:	05893683          	ld	a3,88(s2)
    80001ad0:	6605                	lui	a2,0x1
    80001ad2:	020005b7          	lui	a1,0x2000
    80001ad6:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80001ad8:	05b6                	slli	a1,a1,0xd
    80001ada:	8526                	mv	a0,s1
    80001adc:	fffff097          	auipc	ra,0xfffff
    80001ae0:	64e080e7          	jalr	1614(ra) # 8000112a <mappages>
    80001ae4:	02054163          	bltz	a0,80001b06 <proc_pagetable+0x76>
}
    80001ae8:	8526                	mv	a0,s1
    80001aea:	60e2                	ld	ra,24(sp)
    80001aec:	6442                	ld	s0,16(sp)
    80001aee:	64a2                	ld	s1,8(sp)
    80001af0:	6902                	ld	s2,0(sp)
    80001af2:	6105                	addi	sp,sp,32
    80001af4:	8082                	ret
    uvmfree(pagetable, 0);
    80001af6:	4581                	li	a1,0
    80001af8:	8526                	mv	a0,s1
    80001afa:	00000097          	auipc	ra,0x0
    80001afe:	a8a080e7          	jalr	-1398(ra) # 80001584 <uvmfree>
    return 0;
    80001b02:	4481                	li	s1,0
    80001b04:	b7d5                	j	80001ae8 <proc_pagetable+0x58>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001b06:	4681                	li	a3,0
    80001b08:	4605                	li	a2,1
    80001b0a:	040005b7          	lui	a1,0x4000
    80001b0e:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001b10:	05b2                	slli	a1,a1,0xc
    80001b12:	8526                	mv	a0,s1
    80001b14:	fffff097          	auipc	ra,0xfffff
    80001b18:	7ae080e7          	jalr	1966(ra) # 800012c2 <uvmunmap>
    uvmfree(pagetable, 0);
    80001b1c:	4581                	li	a1,0
    80001b1e:	8526                	mv	a0,s1
    80001b20:	00000097          	auipc	ra,0x0
    80001b24:	a64080e7          	jalr	-1436(ra) # 80001584 <uvmfree>
    return 0;
    80001b28:	4481                	li	s1,0
    80001b2a:	bf7d                	j	80001ae8 <proc_pagetable+0x58>

0000000080001b2c <proc_freepagetable>:
{
    80001b2c:	1101                	addi	sp,sp,-32
    80001b2e:	ec06                	sd	ra,24(sp)
    80001b30:	e822                	sd	s0,16(sp)
    80001b32:	e426                	sd	s1,8(sp)
    80001b34:	e04a                	sd	s2,0(sp)
    80001b36:	1000                	addi	s0,sp,32
    80001b38:	84aa                	mv	s1,a0
    80001b3a:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001b3c:	4681                	li	a3,0
    80001b3e:	4605                	li	a2,1
    80001b40:	040005b7          	lui	a1,0x4000
    80001b44:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001b46:	05b2                	slli	a1,a1,0xc
    80001b48:	fffff097          	auipc	ra,0xfffff
    80001b4c:	77a080e7          	jalr	1914(ra) # 800012c2 <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80001b50:	4681                	li	a3,0
    80001b52:	4605                	li	a2,1
    80001b54:	020005b7          	lui	a1,0x2000
    80001b58:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80001b5a:	05b6                	slli	a1,a1,0xd
    80001b5c:	8526                	mv	a0,s1
    80001b5e:	fffff097          	auipc	ra,0xfffff
    80001b62:	764080e7          	jalr	1892(ra) # 800012c2 <uvmunmap>
  uvmfree(pagetable, sz);
    80001b66:	85ca                	mv	a1,s2
    80001b68:	8526                	mv	a0,s1
    80001b6a:	00000097          	auipc	ra,0x0
    80001b6e:	a1a080e7          	jalr	-1510(ra) # 80001584 <uvmfree>
}
    80001b72:	60e2                	ld	ra,24(sp)
    80001b74:	6442                	ld	s0,16(sp)
    80001b76:	64a2                	ld	s1,8(sp)
    80001b78:	6902                	ld	s2,0(sp)
    80001b7a:	6105                	addi	sp,sp,32
    80001b7c:	8082                	ret

0000000080001b7e <freeproc>:
{
    80001b7e:	1101                	addi	sp,sp,-32
    80001b80:	ec06                	sd	ra,24(sp)
    80001b82:	e822                	sd	s0,16(sp)
    80001b84:	e426                	sd	s1,8(sp)
    80001b86:	1000                	addi	s0,sp,32
    80001b88:	84aa                	mv	s1,a0
  if(p->trapframe)
    80001b8a:	6d28                	ld	a0,88(a0)
    80001b8c:	c509                	beqz	a0,80001b96 <freeproc+0x18>
    kfree((void*)p->trapframe);
    80001b8e:	fffff097          	auipc	ra,0xfffff
    80001b92:	e84080e7          	jalr	-380(ra) # 80000a12 <kfree>
  p->trapframe = 0;
    80001b96:	0404bc23          	sd	zero,88(s1)
  if(p->pagetable)
    80001b9a:	68a8                	ld	a0,80(s1)
    80001b9c:	c511                	beqz	a0,80001ba8 <freeproc+0x2a>
    proc_freepagetable(p->pagetable, p->sz);
    80001b9e:	64ac                	ld	a1,72(s1)
    80001ba0:	00000097          	auipc	ra,0x0
    80001ba4:	f8c080e7          	jalr	-116(ra) # 80001b2c <proc_freepagetable>
  p->pagetable = 0;
    80001ba8:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    80001bac:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    80001bb0:	0204ac23          	sw	zero,56(s1)
  p->parent = 0;
    80001bb4:	0204b023          	sd	zero,32(s1)
  p->name[0] = 0;
    80001bb8:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    80001bbc:	0204b423          	sd	zero,40(s1)
  p->killed = 0;
    80001bc0:	0204a823          	sw	zero,48(s1)
  p->xstate = 0;
    80001bc4:	0204aa23          	sw	zero,52(s1)
  p->state = UNUSED;
    80001bc8:	0004ac23          	sw	zero,24(s1)
}
    80001bcc:	60e2                	ld	ra,24(sp)
    80001bce:	6442                	ld	s0,16(sp)
    80001bd0:	64a2                	ld	s1,8(sp)
    80001bd2:	6105                	addi	sp,sp,32
    80001bd4:	8082                	ret

0000000080001bd6 <allocproc>:
{
    80001bd6:	1101                	addi	sp,sp,-32
    80001bd8:	ec06                	sd	ra,24(sp)
    80001bda:	e822                	sd	s0,16(sp)
    80001bdc:	e426                	sd	s1,8(sp)
    80001bde:	e04a                	sd	s2,0(sp)
    80001be0:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    80001be2:	00010497          	auipc	s1,0x10
    80001be6:	18648493          	addi	s1,s1,390 # 80011d68 <proc>
    80001bea:	00016917          	auipc	s2,0x16
    80001bee:	b7e90913          	addi	s2,s2,-1154 # 80017768 <tickslock>
    acquire(&p->lock);
    80001bf2:	8526                	mv	a0,s1
    80001bf4:	fffff097          	auipc	ra,0xfffff
    80001bf8:	00c080e7          	jalr	12(ra) # 80000c00 <acquire>
    if(p->state == UNUSED) {
    80001bfc:	4c9c                	lw	a5,24(s1)
    80001bfe:	cf81                	beqz	a5,80001c16 <allocproc+0x40>
      release(&p->lock);
    80001c00:	8526                	mv	a0,s1
    80001c02:	fffff097          	auipc	ra,0xfffff
    80001c06:	0b2080e7          	jalr	178(ra) # 80000cb4 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001c0a:	16848493          	addi	s1,s1,360
    80001c0e:	ff2492e3          	bne	s1,s2,80001bf2 <allocproc+0x1c>
  return 0;
    80001c12:	4481                	li	s1,0
    80001c14:	a0b9                	j	80001c62 <allocproc+0x8c>
  p->pid = allocpid();
    80001c16:	00000097          	auipc	ra,0x0
    80001c1a:	e34080e7          	jalr	-460(ra) # 80001a4a <allocpid>
    80001c1e:	dc88                	sw	a0,56(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    80001c20:	fffff097          	auipc	ra,0xfffff
    80001c24:	ef0080e7          	jalr	-272(ra) # 80000b10 <kalloc>
    80001c28:	892a                	mv	s2,a0
    80001c2a:	eca8                	sd	a0,88(s1)
    80001c2c:	c131                	beqz	a0,80001c70 <allocproc+0x9a>
  p->pagetable = proc_pagetable(p);
    80001c2e:	8526                	mv	a0,s1
    80001c30:	00000097          	auipc	ra,0x0
    80001c34:	e60080e7          	jalr	-416(ra) # 80001a90 <proc_pagetable>
    80001c38:	892a                	mv	s2,a0
    80001c3a:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    80001c3c:	c129                	beqz	a0,80001c7e <allocproc+0xa8>
  memset(&p->context, 0, sizeof(p->context));
    80001c3e:	07000613          	li	a2,112
    80001c42:	4581                	li	a1,0
    80001c44:	06048513          	addi	a0,s1,96
    80001c48:	fffff097          	auipc	ra,0xfffff
    80001c4c:	0b4080e7          	jalr	180(ra) # 80000cfc <memset>
  p->context.ra = (uint64)forkret;
    80001c50:	00000797          	auipc	a5,0x0
    80001c54:	db478793          	addi	a5,a5,-588 # 80001a04 <forkret>
    80001c58:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    80001c5a:	60bc                	ld	a5,64(s1)
    80001c5c:	6705                	lui	a4,0x1
    80001c5e:	97ba                	add	a5,a5,a4
    80001c60:	f4bc                	sd	a5,104(s1)
}
    80001c62:	8526                	mv	a0,s1
    80001c64:	60e2                	ld	ra,24(sp)
    80001c66:	6442                	ld	s0,16(sp)
    80001c68:	64a2                	ld	s1,8(sp)
    80001c6a:	6902                	ld	s2,0(sp)
    80001c6c:	6105                	addi	sp,sp,32
    80001c6e:	8082                	ret
    release(&p->lock);
    80001c70:	8526                	mv	a0,s1
    80001c72:	fffff097          	auipc	ra,0xfffff
    80001c76:	042080e7          	jalr	66(ra) # 80000cb4 <release>
    return 0;
    80001c7a:	84ca                	mv	s1,s2
    80001c7c:	b7dd                	j	80001c62 <allocproc+0x8c>
    freeproc(p);
    80001c7e:	8526                	mv	a0,s1
    80001c80:	00000097          	auipc	ra,0x0
    80001c84:	efe080e7          	jalr	-258(ra) # 80001b7e <freeproc>
    release(&p->lock);
    80001c88:	8526                	mv	a0,s1
    80001c8a:	fffff097          	auipc	ra,0xfffff
    80001c8e:	02a080e7          	jalr	42(ra) # 80000cb4 <release>
    return 0;
    80001c92:	84ca                	mv	s1,s2
    80001c94:	b7f9                	j	80001c62 <allocproc+0x8c>

0000000080001c96 <userinit>:
{
    80001c96:	1101                	addi	sp,sp,-32
    80001c98:	ec06                	sd	ra,24(sp)
    80001c9a:	e822                	sd	s0,16(sp)
    80001c9c:	e426                	sd	s1,8(sp)
    80001c9e:	1000                	addi	s0,sp,32
  p = allocproc();
    80001ca0:	00000097          	auipc	ra,0x0
    80001ca4:	f36080e7          	jalr	-202(ra) # 80001bd6 <allocproc>
    80001ca8:	84aa                	mv	s1,a0
  initproc = p;
    80001caa:	00007797          	auipc	a5,0x7
    80001cae:	36a7b723          	sd	a0,878(a5) # 80009018 <initproc>
  uvminit(p->pagetable, initcode, sizeof(initcode));
    80001cb2:	03400613          	li	a2,52
    80001cb6:	00007597          	auipc	a1,0x7
    80001cba:	b6a58593          	addi	a1,a1,-1174 # 80008820 <initcode>
    80001cbe:	6928                	ld	a0,80(a0)
    80001cc0:	fffff097          	auipc	ra,0xfffff
    80001cc4:	6f4080e7          	jalr	1780(ra) # 800013b4 <uvminit>
  p->sz = PGSIZE;
    80001cc8:	6785                	lui	a5,0x1
    80001cca:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;      // user program counter
    80001ccc:	6cb8                	ld	a4,88(s1)
    80001cce:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    80001cd2:	6cb8                	ld	a4,88(s1)
    80001cd4:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    80001cd6:	4641                	li	a2,16
    80001cd8:	00006597          	auipc	a1,0x6
    80001cdc:	51058593          	addi	a1,a1,1296 # 800081e8 <digits+0x1a8>
    80001ce0:	15848513          	addi	a0,s1,344
    80001ce4:	fffff097          	auipc	ra,0xfffff
    80001ce8:	16a080e7          	jalr	362(ra) # 80000e4e <safestrcpy>
  p->cwd = namei("/");
    80001cec:	00006517          	auipc	a0,0x6
    80001cf0:	50c50513          	addi	a0,a0,1292 # 800081f8 <digits+0x1b8>
    80001cf4:	00002097          	auipc	ra,0x2
    80001cf8:	0bc080e7          	jalr	188(ra) # 80003db0 <namei>
    80001cfc:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    80001d00:	4789                	li	a5,2
    80001d02:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    80001d04:	8526                	mv	a0,s1
    80001d06:	fffff097          	auipc	ra,0xfffff
    80001d0a:	fae080e7          	jalr	-82(ra) # 80000cb4 <release>
}
    80001d0e:	60e2                	ld	ra,24(sp)
    80001d10:	6442                	ld	s0,16(sp)
    80001d12:	64a2                	ld	s1,8(sp)
    80001d14:	6105                	addi	sp,sp,32
    80001d16:	8082                	ret

0000000080001d18 <growproc>:
{
    80001d18:	1101                	addi	sp,sp,-32
    80001d1a:	ec06                	sd	ra,24(sp)
    80001d1c:	e822                	sd	s0,16(sp)
    80001d1e:	e426                	sd	s1,8(sp)
    80001d20:	e04a                	sd	s2,0(sp)
    80001d22:	1000                	addi	s0,sp,32
    80001d24:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001d26:	00000097          	auipc	ra,0x0
    80001d2a:	ca6080e7          	jalr	-858(ra) # 800019cc <myproc>
    80001d2e:	892a                	mv	s2,a0
  sz = p->sz;
    80001d30:	652c                	ld	a1,72(a0)
    80001d32:	0005879b          	sext.w	a5,a1
  if(n > 0){
    80001d36:	00904f63          	bgtz	s1,80001d54 <growproc+0x3c>
  } else if(n < 0){
    80001d3a:	0204cd63          	bltz	s1,80001d74 <growproc+0x5c>
  p->sz = sz;
    80001d3e:	1782                	slli	a5,a5,0x20
    80001d40:	9381                	srli	a5,a5,0x20
    80001d42:	04f93423          	sd	a5,72(s2)
  return 0;
    80001d46:	4501                	li	a0,0
}
    80001d48:	60e2                	ld	ra,24(sp)
    80001d4a:	6442                	ld	s0,16(sp)
    80001d4c:	64a2                	ld	s1,8(sp)
    80001d4e:	6902                	ld	s2,0(sp)
    80001d50:	6105                	addi	sp,sp,32
    80001d52:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n)) == 0) {
    80001d54:	00f4863b          	addw	a2,s1,a5
    80001d58:	1602                	slli	a2,a2,0x20
    80001d5a:	9201                	srli	a2,a2,0x20
    80001d5c:	1582                	slli	a1,a1,0x20
    80001d5e:	9181                	srli	a1,a1,0x20
    80001d60:	6928                	ld	a0,80(a0)
    80001d62:	fffff097          	auipc	ra,0xfffff
    80001d66:	70c080e7          	jalr	1804(ra) # 8000146e <uvmalloc>
    80001d6a:	0005079b          	sext.w	a5,a0
    80001d6e:	fbe1                	bnez	a5,80001d3e <growproc+0x26>
      return -1;
    80001d70:	557d                	li	a0,-1
    80001d72:	bfd9                	j	80001d48 <growproc+0x30>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    80001d74:	00f4863b          	addw	a2,s1,a5
    80001d78:	1602                	slli	a2,a2,0x20
    80001d7a:	9201                	srli	a2,a2,0x20
    80001d7c:	1582                	slli	a1,a1,0x20
    80001d7e:	9181                	srli	a1,a1,0x20
    80001d80:	6928                	ld	a0,80(a0)
    80001d82:	fffff097          	auipc	ra,0xfffff
    80001d86:	6a4080e7          	jalr	1700(ra) # 80001426 <uvmdealloc>
    80001d8a:	0005079b          	sext.w	a5,a0
    80001d8e:	bf45                	j	80001d3e <growproc+0x26>

0000000080001d90 <fork>:
{
    80001d90:	7139                	addi	sp,sp,-64
    80001d92:	fc06                	sd	ra,56(sp)
    80001d94:	f822                	sd	s0,48(sp)
    80001d96:	f426                	sd	s1,40(sp)
    80001d98:	f04a                	sd	s2,32(sp)
    80001d9a:	ec4e                	sd	s3,24(sp)
    80001d9c:	e852                	sd	s4,16(sp)
    80001d9e:	e456                	sd	s5,8(sp)
    80001da0:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    80001da2:	00000097          	auipc	ra,0x0
    80001da6:	c2a080e7          	jalr	-982(ra) # 800019cc <myproc>
    80001daa:	8aaa                	mv	s5,a0
  if((np = allocproc()) == 0){
    80001dac:	00000097          	auipc	ra,0x0
    80001db0:	e2a080e7          	jalr	-470(ra) # 80001bd6 <allocproc>
    80001db4:	c17d                	beqz	a0,80001e9a <fork+0x10a>
    80001db6:	8a2a                	mv	s4,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    80001db8:	048ab603          	ld	a2,72(s5)
    80001dbc:	692c                	ld	a1,80(a0)
    80001dbe:	050ab503          	ld	a0,80(s5)
    80001dc2:	fffff097          	auipc	ra,0xfffff
    80001dc6:	7fc080e7          	jalr	2044(ra) # 800015be <uvmcopy>
    80001dca:	04054a63          	bltz	a0,80001e1e <fork+0x8e>
  np->sz = p->sz;
    80001dce:	048ab783          	ld	a5,72(s5)
    80001dd2:	04fa3423          	sd	a5,72(s4)
  np->parent = p;
    80001dd6:	035a3023          	sd	s5,32(s4)
  *(np->trapframe) = *(p->trapframe);
    80001dda:	058ab683          	ld	a3,88(s5)
    80001dde:	87b6                	mv	a5,a3
    80001de0:	058a3703          	ld	a4,88(s4)
    80001de4:	12068693          	addi	a3,a3,288
    80001de8:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    80001dec:	6788                	ld	a0,8(a5)
    80001dee:	6b8c                	ld	a1,16(a5)
    80001df0:	6f90                	ld	a2,24(a5)
    80001df2:	01073023          	sd	a6,0(a4)
    80001df6:	e708                	sd	a0,8(a4)
    80001df8:	eb0c                	sd	a1,16(a4)
    80001dfa:	ef10                	sd	a2,24(a4)
    80001dfc:	02078793          	addi	a5,a5,32
    80001e00:	02070713          	addi	a4,a4,32
    80001e04:	fed792e3          	bne	a5,a3,80001de8 <fork+0x58>
  np->trapframe->a0 = 0;
    80001e08:	058a3783          	ld	a5,88(s4)
    80001e0c:	0607b823          	sd	zero,112(a5)
  for(i = 0; i < NOFILE; i++)
    80001e10:	0d0a8493          	addi	s1,s5,208
    80001e14:	0d0a0913          	addi	s2,s4,208
    80001e18:	150a8993          	addi	s3,s5,336
    80001e1c:	a00d                	j	80001e3e <fork+0xae>
    freeproc(np);
    80001e1e:	8552                	mv	a0,s4
    80001e20:	00000097          	auipc	ra,0x0
    80001e24:	d5e080e7          	jalr	-674(ra) # 80001b7e <freeproc>
    release(&np->lock);
    80001e28:	8552                	mv	a0,s4
    80001e2a:	fffff097          	auipc	ra,0xfffff
    80001e2e:	e8a080e7          	jalr	-374(ra) # 80000cb4 <release>
    return -1;
    80001e32:	54fd                	li	s1,-1
    80001e34:	a889                	j	80001e86 <fork+0xf6>
  for(i = 0; i < NOFILE; i++)
    80001e36:	04a1                	addi	s1,s1,8
    80001e38:	0921                	addi	s2,s2,8
    80001e3a:	01348b63          	beq	s1,s3,80001e50 <fork+0xc0>
    if(p->ofile[i])
    80001e3e:	6088                	ld	a0,0(s1)
    80001e40:	d97d                	beqz	a0,80001e36 <fork+0xa6>
      np->ofile[i] = filedup(p->ofile[i]);
    80001e42:	00002097          	auipc	ra,0x2
    80001e46:	5fa080e7          	jalr	1530(ra) # 8000443c <filedup>
    80001e4a:	00a93023          	sd	a0,0(s2)
    80001e4e:	b7e5                	j	80001e36 <fork+0xa6>
  np->cwd = idup(p->cwd);
    80001e50:	150ab503          	ld	a0,336(s5)
    80001e54:	00001097          	auipc	ra,0x1
    80001e58:	768080e7          	jalr	1896(ra) # 800035bc <idup>
    80001e5c:	14aa3823          	sd	a0,336(s4)
  safestrcpy(np->name, p->name, sizeof(p->name));
    80001e60:	4641                	li	a2,16
    80001e62:	158a8593          	addi	a1,s5,344
    80001e66:	158a0513          	addi	a0,s4,344
    80001e6a:	fffff097          	auipc	ra,0xfffff
    80001e6e:	fe4080e7          	jalr	-28(ra) # 80000e4e <safestrcpy>
  pid = np->pid;
    80001e72:	038a2483          	lw	s1,56(s4)
  np->state = RUNNABLE;
    80001e76:	4789                	li	a5,2
    80001e78:	00fa2c23          	sw	a5,24(s4)
  release(&np->lock);
    80001e7c:	8552                	mv	a0,s4
    80001e7e:	fffff097          	auipc	ra,0xfffff
    80001e82:	e36080e7          	jalr	-458(ra) # 80000cb4 <release>
}
    80001e86:	8526                	mv	a0,s1
    80001e88:	70e2                	ld	ra,56(sp)
    80001e8a:	7442                	ld	s0,48(sp)
    80001e8c:	74a2                	ld	s1,40(sp)
    80001e8e:	7902                	ld	s2,32(sp)
    80001e90:	69e2                	ld	s3,24(sp)
    80001e92:	6a42                	ld	s4,16(sp)
    80001e94:	6aa2                	ld	s5,8(sp)
    80001e96:	6121                	addi	sp,sp,64
    80001e98:	8082                	ret
    return -1;
    80001e9a:	54fd                	li	s1,-1
    80001e9c:	b7ed                	j	80001e86 <fork+0xf6>

0000000080001e9e <reparent>:
{
    80001e9e:	7179                	addi	sp,sp,-48
    80001ea0:	f406                	sd	ra,40(sp)
    80001ea2:	f022                	sd	s0,32(sp)
    80001ea4:	ec26                	sd	s1,24(sp)
    80001ea6:	e84a                	sd	s2,16(sp)
    80001ea8:	e44e                	sd	s3,8(sp)
    80001eaa:	e052                	sd	s4,0(sp)
    80001eac:	1800                	addi	s0,sp,48
    80001eae:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001eb0:	00010497          	auipc	s1,0x10
    80001eb4:	eb848493          	addi	s1,s1,-328 # 80011d68 <proc>
      pp->parent = initproc;
    80001eb8:	00007a17          	auipc	s4,0x7
    80001ebc:	160a0a13          	addi	s4,s4,352 # 80009018 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001ec0:	00016997          	auipc	s3,0x16
    80001ec4:	8a898993          	addi	s3,s3,-1880 # 80017768 <tickslock>
    80001ec8:	a029                	j	80001ed2 <reparent+0x34>
    80001eca:	16848493          	addi	s1,s1,360
    80001ece:	03348363          	beq	s1,s3,80001ef4 <reparent+0x56>
    if(pp->parent == p){
    80001ed2:	709c                	ld	a5,32(s1)
    80001ed4:	ff279be3          	bne	a5,s2,80001eca <reparent+0x2c>
      acquire(&pp->lock);
    80001ed8:	8526                	mv	a0,s1
    80001eda:	fffff097          	auipc	ra,0xfffff
    80001ede:	d26080e7          	jalr	-730(ra) # 80000c00 <acquire>
      pp->parent = initproc;
    80001ee2:	000a3783          	ld	a5,0(s4)
    80001ee6:	f09c                	sd	a5,32(s1)
      release(&pp->lock);
    80001ee8:	8526                	mv	a0,s1
    80001eea:	fffff097          	auipc	ra,0xfffff
    80001eee:	dca080e7          	jalr	-566(ra) # 80000cb4 <release>
    80001ef2:	bfe1                	j	80001eca <reparent+0x2c>
}
    80001ef4:	70a2                	ld	ra,40(sp)
    80001ef6:	7402                	ld	s0,32(sp)
    80001ef8:	64e2                	ld	s1,24(sp)
    80001efa:	6942                	ld	s2,16(sp)
    80001efc:	69a2                	ld	s3,8(sp)
    80001efe:	6a02                	ld	s4,0(sp)
    80001f00:	6145                	addi	sp,sp,48
    80001f02:	8082                	ret

0000000080001f04 <scheduler>:
{
    80001f04:	715d                	addi	sp,sp,-80
    80001f06:	e486                	sd	ra,72(sp)
    80001f08:	e0a2                	sd	s0,64(sp)
    80001f0a:	fc26                	sd	s1,56(sp)
    80001f0c:	f84a                	sd	s2,48(sp)
    80001f0e:	f44e                	sd	s3,40(sp)
    80001f10:	f052                	sd	s4,32(sp)
    80001f12:	ec56                	sd	s5,24(sp)
    80001f14:	e85a                	sd	s6,16(sp)
    80001f16:	e45e                	sd	s7,8(sp)
    80001f18:	e062                	sd	s8,0(sp)
    80001f1a:	0880                	addi	s0,sp,80
    80001f1c:	8792                	mv	a5,tp
  int id = r_tp();
    80001f1e:	2781                	sext.w	a5,a5
  c->proc = 0;
    80001f20:	00779b13          	slli	s6,a5,0x7
    80001f24:	00010717          	auipc	a4,0x10
    80001f28:	a2c70713          	addi	a4,a4,-1492 # 80011950 <pid_lock>
    80001f2c:	975a                	add	a4,a4,s6
    80001f2e:	00073c23          	sd	zero,24(a4)
        swtch(&c->context, &p->context);
    80001f32:	00010717          	auipc	a4,0x10
    80001f36:	a3e70713          	addi	a4,a4,-1474 # 80011970 <cpus+0x8>
    80001f3a:	9b3a                	add	s6,s6,a4
        p->state = RUNNING;
    80001f3c:	4c0d                	li	s8,3
        c->proc = p;
    80001f3e:	079e                	slli	a5,a5,0x7
    80001f40:	00010a17          	auipc	s4,0x10
    80001f44:	a10a0a13          	addi	s4,s4,-1520 # 80011950 <pid_lock>
    80001f48:	9a3e                	add	s4,s4,a5
        found = 1;
    80001f4a:	4b85                	li	s7,1
    for(p = proc; p < &proc[NPROC]; p++) {
    80001f4c:	00016997          	auipc	s3,0x16
    80001f50:	81c98993          	addi	s3,s3,-2020 # 80017768 <tickslock>
    80001f54:	a899                	j	80001faa <scheduler+0xa6>
      release(&p->lock);
    80001f56:	8526                	mv	a0,s1
    80001f58:	fffff097          	auipc	ra,0xfffff
    80001f5c:	d5c080e7          	jalr	-676(ra) # 80000cb4 <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    80001f60:	16848493          	addi	s1,s1,360
    80001f64:	03348963          	beq	s1,s3,80001f96 <scheduler+0x92>
      acquire(&p->lock);
    80001f68:	8526                	mv	a0,s1
    80001f6a:	fffff097          	auipc	ra,0xfffff
    80001f6e:	c96080e7          	jalr	-874(ra) # 80000c00 <acquire>
      if(p->state == RUNNABLE) {
    80001f72:	4c9c                	lw	a5,24(s1)
    80001f74:	ff2791e3          	bne	a5,s2,80001f56 <scheduler+0x52>
        p->state = RUNNING;
    80001f78:	0184ac23          	sw	s8,24(s1)
        c->proc = p;
    80001f7c:	009a3c23          	sd	s1,24(s4)
        swtch(&c->context, &p->context);
    80001f80:	06048593          	addi	a1,s1,96
    80001f84:	855a                	mv	a0,s6
    80001f86:	00000097          	auipc	ra,0x0
    80001f8a:	610080e7          	jalr	1552(ra) # 80002596 <swtch>
        c->proc = 0;
    80001f8e:	000a3c23          	sd	zero,24(s4)
        found = 1;
    80001f92:	8ade                	mv	s5,s7
    80001f94:	b7c9                	j	80001f56 <scheduler+0x52>
    if(found == 0) {
    80001f96:	000a9a63          	bnez	s5,80001faa <scheduler+0xa6>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001f9a:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001f9e:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001fa2:	10079073          	csrw	sstatus,a5
      asm volatile("wfi");
    80001fa6:	10500073          	wfi
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001faa:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001fae:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001fb2:	10079073          	csrw	sstatus,a5
    int found = 0;
    80001fb6:	4a81                	li	s5,0
    for(p = proc; p < &proc[NPROC]; p++) {
    80001fb8:	00010497          	auipc	s1,0x10
    80001fbc:	db048493          	addi	s1,s1,-592 # 80011d68 <proc>
      if(p->state == RUNNABLE) {
    80001fc0:	4909                	li	s2,2
    80001fc2:	b75d                	j	80001f68 <scheduler+0x64>

0000000080001fc4 <sched>:
{
    80001fc4:	7179                	addi	sp,sp,-48
    80001fc6:	f406                	sd	ra,40(sp)
    80001fc8:	f022                	sd	s0,32(sp)
    80001fca:	ec26                	sd	s1,24(sp)
    80001fcc:	e84a                	sd	s2,16(sp)
    80001fce:	e44e                	sd	s3,8(sp)
    80001fd0:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80001fd2:	00000097          	auipc	ra,0x0
    80001fd6:	9fa080e7          	jalr	-1542(ra) # 800019cc <myproc>
    80001fda:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    80001fdc:	fffff097          	auipc	ra,0xfffff
    80001fe0:	baa080e7          	jalr	-1110(ra) # 80000b86 <holding>
    80001fe4:	c93d                	beqz	a0,8000205a <sched+0x96>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001fe6:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    80001fe8:	2781                	sext.w	a5,a5
    80001fea:	079e                	slli	a5,a5,0x7
    80001fec:	00010717          	auipc	a4,0x10
    80001ff0:	96470713          	addi	a4,a4,-1692 # 80011950 <pid_lock>
    80001ff4:	97ba                	add	a5,a5,a4
    80001ff6:	0907a703          	lw	a4,144(a5)
    80001ffa:	4785                	li	a5,1
    80001ffc:	06f71763          	bne	a4,a5,8000206a <sched+0xa6>
  if(p->state == RUNNING)
    80002000:	4c98                	lw	a4,24(s1)
    80002002:	478d                	li	a5,3
    80002004:	06f70b63          	beq	a4,a5,8000207a <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002008:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    8000200c:	8b89                	andi	a5,a5,2
  if(intr_get())
    8000200e:	efb5                	bnez	a5,8000208a <sched+0xc6>
  asm volatile("mv %0, tp" : "=r" (x) );
    80002010:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    80002012:	00010917          	auipc	s2,0x10
    80002016:	93e90913          	addi	s2,s2,-1730 # 80011950 <pid_lock>
    8000201a:	2781                	sext.w	a5,a5
    8000201c:	079e                	slli	a5,a5,0x7
    8000201e:	97ca                	add	a5,a5,s2
    80002020:	0947a983          	lw	s3,148(a5)
    80002024:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    80002026:	2781                	sext.w	a5,a5
    80002028:	079e                	slli	a5,a5,0x7
    8000202a:	00010597          	auipc	a1,0x10
    8000202e:	94658593          	addi	a1,a1,-1722 # 80011970 <cpus+0x8>
    80002032:	95be                	add	a1,a1,a5
    80002034:	06048513          	addi	a0,s1,96
    80002038:	00000097          	auipc	ra,0x0
    8000203c:	55e080e7          	jalr	1374(ra) # 80002596 <swtch>
    80002040:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    80002042:	2781                	sext.w	a5,a5
    80002044:	079e                	slli	a5,a5,0x7
    80002046:	993e                	add	s2,s2,a5
    80002048:	09392a23          	sw	s3,148(s2)
}
    8000204c:	70a2                	ld	ra,40(sp)
    8000204e:	7402                	ld	s0,32(sp)
    80002050:	64e2                	ld	s1,24(sp)
    80002052:	6942                	ld	s2,16(sp)
    80002054:	69a2                	ld	s3,8(sp)
    80002056:	6145                	addi	sp,sp,48
    80002058:	8082                	ret
    panic("sched p->lock");
    8000205a:	00006517          	auipc	a0,0x6
    8000205e:	1a650513          	addi	a0,a0,422 # 80008200 <digits+0x1c0>
    80002062:	ffffe097          	auipc	ra,0xffffe
    80002066:	4e4080e7          	jalr	1252(ra) # 80000546 <panic>
    panic("sched locks");
    8000206a:	00006517          	auipc	a0,0x6
    8000206e:	1a650513          	addi	a0,a0,422 # 80008210 <digits+0x1d0>
    80002072:	ffffe097          	auipc	ra,0xffffe
    80002076:	4d4080e7          	jalr	1236(ra) # 80000546 <panic>
    panic("sched running");
    8000207a:	00006517          	auipc	a0,0x6
    8000207e:	1a650513          	addi	a0,a0,422 # 80008220 <digits+0x1e0>
    80002082:	ffffe097          	auipc	ra,0xffffe
    80002086:	4c4080e7          	jalr	1220(ra) # 80000546 <panic>
    panic("sched interruptible");
    8000208a:	00006517          	auipc	a0,0x6
    8000208e:	1a650513          	addi	a0,a0,422 # 80008230 <digits+0x1f0>
    80002092:	ffffe097          	auipc	ra,0xffffe
    80002096:	4b4080e7          	jalr	1204(ra) # 80000546 <panic>

000000008000209a <exit>:
{
    8000209a:	7179                	addi	sp,sp,-48
    8000209c:	f406                	sd	ra,40(sp)
    8000209e:	f022                	sd	s0,32(sp)
    800020a0:	ec26                	sd	s1,24(sp)
    800020a2:	e84a                	sd	s2,16(sp)
    800020a4:	e44e                	sd	s3,8(sp)
    800020a6:	e052                	sd	s4,0(sp)
    800020a8:	1800                	addi	s0,sp,48
    800020aa:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    800020ac:	00000097          	auipc	ra,0x0
    800020b0:	920080e7          	jalr	-1760(ra) # 800019cc <myproc>
    800020b4:	89aa                	mv	s3,a0
  if(p == initproc)
    800020b6:	00007797          	auipc	a5,0x7
    800020ba:	f627b783          	ld	a5,-158(a5) # 80009018 <initproc>
    800020be:	0d050493          	addi	s1,a0,208
    800020c2:	15050913          	addi	s2,a0,336
    800020c6:	02a79363          	bne	a5,a0,800020ec <exit+0x52>
    panic("init exiting");
    800020ca:	00006517          	auipc	a0,0x6
    800020ce:	17e50513          	addi	a0,a0,382 # 80008248 <digits+0x208>
    800020d2:	ffffe097          	auipc	ra,0xffffe
    800020d6:	474080e7          	jalr	1140(ra) # 80000546 <panic>
      fileclose(f);
    800020da:	00002097          	auipc	ra,0x2
    800020de:	3b4080e7          	jalr	948(ra) # 8000448e <fileclose>
      p->ofile[fd] = 0;
    800020e2:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    800020e6:	04a1                	addi	s1,s1,8
    800020e8:	01248563          	beq	s1,s2,800020f2 <exit+0x58>
    if(p->ofile[fd]){
    800020ec:	6088                	ld	a0,0(s1)
    800020ee:	f575                	bnez	a0,800020da <exit+0x40>
    800020f0:	bfdd                	j	800020e6 <exit+0x4c>
  begin_op();
    800020f2:	00002097          	auipc	ra,0x2
    800020f6:	ece080e7          	jalr	-306(ra) # 80003fc0 <begin_op>
  iput(p->cwd);
    800020fa:	1509b503          	ld	a0,336(s3)
    800020fe:	00001097          	auipc	ra,0x1
    80002102:	6b6080e7          	jalr	1718(ra) # 800037b4 <iput>
  end_op();
    80002106:	00002097          	auipc	ra,0x2
    8000210a:	f38080e7          	jalr	-200(ra) # 8000403e <end_op>
  p->cwd = 0;
    8000210e:	1409b823          	sd	zero,336(s3)
  acquire(&initproc->lock);
    80002112:	00007497          	auipc	s1,0x7
    80002116:	f0648493          	addi	s1,s1,-250 # 80009018 <initproc>
    8000211a:	6088                	ld	a0,0(s1)
    8000211c:	fffff097          	auipc	ra,0xfffff
    80002120:	ae4080e7          	jalr	-1308(ra) # 80000c00 <acquire>
  wakeup1(initproc);
    80002124:	6088                	ld	a0,0(s1)
    80002126:	fffff097          	auipc	ra,0xfffff
    8000212a:	766080e7          	jalr	1894(ra) # 8000188c <wakeup1>
  release(&initproc->lock);
    8000212e:	6088                	ld	a0,0(s1)
    80002130:	fffff097          	auipc	ra,0xfffff
    80002134:	b84080e7          	jalr	-1148(ra) # 80000cb4 <release>
  acquire(&p->lock);
    80002138:	854e                	mv	a0,s3
    8000213a:	fffff097          	auipc	ra,0xfffff
    8000213e:	ac6080e7          	jalr	-1338(ra) # 80000c00 <acquire>
  struct proc *original_parent = p->parent;
    80002142:	0209b483          	ld	s1,32(s3)
  release(&p->lock);
    80002146:	854e                	mv	a0,s3
    80002148:	fffff097          	auipc	ra,0xfffff
    8000214c:	b6c080e7          	jalr	-1172(ra) # 80000cb4 <release>
  acquire(&original_parent->lock);
    80002150:	8526                	mv	a0,s1
    80002152:	fffff097          	auipc	ra,0xfffff
    80002156:	aae080e7          	jalr	-1362(ra) # 80000c00 <acquire>
  acquire(&p->lock);
    8000215a:	854e                	mv	a0,s3
    8000215c:	fffff097          	auipc	ra,0xfffff
    80002160:	aa4080e7          	jalr	-1372(ra) # 80000c00 <acquire>
  reparent(p);
    80002164:	854e                	mv	a0,s3
    80002166:	00000097          	auipc	ra,0x0
    8000216a:	d38080e7          	jalr	-712(ra) # 80001e9e <reparent>
  wakeup1(original_parent);
    8000216e:	8526                	mv	a0,s1
    80002170:	fffff097          	auipc	ra,0xfffff
    80002174:	71c080e7          	jalr	1820(ra) # 8000188c <wakeup1>
  p->xstate = status;
    80002178:	0349aa23          	sw	s4,52(s3)
  p->state = ZOMBIE;
    8000217c:	4791                	li	a5,4
    8000217e:	00f9ac23          	sw	a5,24(s3)
  release(&original_parent->lock);
    80002182:	8526                	mv	a0,s1
    80002184:	fffff097          	auipc	ra,0xfffff
    80002188:	b30080e7          	jalr	-1232(ra) # 80000cb4 <release>
  sched();
    8000218c:	00000097          	auipc	ra,0x0
    80002190:	e38080e7          	jalr	-456(ra) # 80001fc4 <sched>
  panic("zombie exit");
    80002194:	00006517          	auipc	a0,0x6
    80002198:	0c450513          	addi	a0,a0,196 # 80008258 <digits+0x218>
    8000219c:	ffffe097          	auipc	ra,0xffffe
    800021a0:	3aa080e7          	jalr	938(ra) # 80000546 <panic>

00000000800021a4 <yield>:
{
    800021a4:	1101                	addi	sp,sp,-32
    800021a6:	ec06                	sd	ra,24(sp)
    800021a8:	e822                	sd	s0,16(sp)
    800021aa:	e426                	sd	s1,8(sp)
    800021ac:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    800021ae:	00000097          	auipc	ra,0x0
    800021b2:	81e080e7          	jalr	-2018(ra) # 800019cc <myproc>
    800021b6:	84aa                	mv	s1,a0
  acquire(&p->lock);
    800021b8:	fffff097          	auipc	ra,0xfffff
    800021bc:	a48080e7          	jalr	-1464(ra) # 80000c00 <acquire>
  p->state = RUNNABLE;
    800021c0:	4789                	li	a5,2
    800021c2:	cc9c                	sw	a5,24(s1)
  sched();
    800021c4:	00000097          	auipc	ra,0x0
    800021c8:	e00080e7          	jalr	-512(ra) # 80001fc4 <sched>
  release(&p->lock);
    800021cc:	8526                	mv	a0,s1
    800021ce:	fffff097          	auipc	ra,0xfffff
    800021d2:	ae6080e7          	jalr	-1306(ra) # 80000cb4 <release>
}
    800021d6:	60e2                	ld	ra,24(sp)
    800021d8:	6442                	ld	s0,16(sp)
    800021da:	64a2                	ld	s1,8(sp)
    800021dc:	6105                	addi	sp,sp,32
    800021de:	8082                	ret

00000000800021e0 <sleep>:
{
    800021e0:	7179                	addi	sp,sp,-48
    800021e2:	f406                	sd	ra,40(sp)
    800021e4:	f022                	sd	s0,32(sp)
    800021e6:	ec26                	sd	s1,24(sp)
    800021e8:	e84a                	sd	s2,16(sp)
    800021ea:	e44e                	sd	s3,8(sp)
    800021ec:	1800                	addi	s0,sp,48
    800021ee:	89aa                	mv	s3,a0
    800021f0:	892e                	mv	s2,a1
  struct proc *p = myproc();
    800021f2:	fffff097          	auipc	ra,0xfffff
    800021f6:	7da080e7          	jalr	2010(ra) # 800019cc <myproc>
    800021fa:	84aa                	mv	s1,a0
  if(lk != &p->lock){  //DOC: sleeplock0
    800021fc:	05250663          	beq	a0,s2,80002248 <sleep+0x68>
    acquire(&p->lock);  //DOC: sleeplock1
    80002200:	fffff097          	auipc	ra,0xfffff
    80002204:	a00080e7          	jalr	-1536(ra) # 80000c00 <acquire>
    release(lk);
    80002208:	854a                	mv	a0,s2
    8000220a:	fffff097          	auipc	ra,0xfffff
    8000220e:	aaa080e7          	jalr	-1366(ra) # 80000cb4 <release>
  p->chan = chan;
    80002212:	0334b423          	sd	s3,40(s1)
  p->state = SLEEPING;
    80002216:	4785                	li	a5,1
    80002218:	cc9c                	sw	a5,24(s1)
  sched();
    8000221a:	00000097          	auipc	ra,0x0
    8000221e:	daa080e7          	jalr	-598(ra) # 80001fc4 <sched>
  p->chan = 0;
    80002222:	0204b423          	sd	zero,40(s1)
    release(&p->lock);
    80002226:	8526                	mv	a0,s1
    80002228:	fffff097          	auipc	ra,0xfffff
    8000222c:	a8c080e7          	jalr	-1396(ra) # 80000cb4 <release>
    acquire(lk);
    80002230:	854a                	mv	a0,s2
    80002232:	fffff097          	auipc	ra,0xfffff
    80002236:	9ce080e7          	jalr	-1586(ra) # 80000c00 <acquire>
}
    8000223a:	70a2                	ld	ra,40(sp)
    8000223c:	7402                	ld	s0,32(sp)
    8000223e:	64e2                	ld	s1,24(sp)
    80002240:	6942                	ld	s2,16(sp)
    80002242:	69a2                	ld	s3,8(sp)
    80002244:	6145                	addi	sp,sp,48
    80002246:	8082                	ret
  p->chan = chan;
    80002248:	03353423          	sd	s3,40(a0)
  p->state = SLEEPING;
    8000224c:	4785                	li	a5,1
    8000224e:	cd1c                	sw	a5,24(a0)
  sched();
    80002250:	00000097          	auipc	ra,0x0
    80002254:	d74080e7          	jalr	-652(ra) # 80001fc4 <sched>
  p->chan = 0;
    80002258:	0204b423          	sd	zero,40(s1)
  if(lk != &p->lock){
    8000225c:	bff9                	j	8000223a <sleep+0x5a>

000000008000225e <wait>:
{
    8000225e:	715d                	addi	sp,sp,-80
    80002260:	e486                	sd	ra,72(sp)
    80002262:	e0a2                	sd	s0,64(sp)
    80002264:	fc26                	sd	s1,56(sp)
    80002266:	f84a                	sd	s2,48(sp)
    80002268:	f44e                	sd	s3,40(sp)
    8000226a:	f052                	sd	s4,32(sp)
    8000226c:	ec56                	sd	s5,24(sp)
    8000226e:	e85a                	sd	s6,16(sp)
    80002270:	e45e                	sd	s7,8(sp)
    80002272:	0880                	addi	s0,sp,80
    80002274:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    80002276:	fffff097          	auipc	ra,0xfffff
    8000227a:	756080e7          	jalr	1878(ra) # 800019cc <myproc>
    8000227e:	892a                	mv	s2,a0
  acquire(&p->lock);
    80002280:	fffff097          	auipc	ra,0xfffff
    80002284:	980080e7          	jalr	-1664(ra) # 80000c00 <acquire>
    havekids = 0;
    80002288:	4b81                	li	s7,0
        if(np->state == ZOMBIE){
    8000228a:	4a11                	li	s4,4
        havekids = 1;
    8000228c:	4a85                	li	s5,1
    for(np = proc; np < &proc[NPROC]; np++){
    8000228e:	00015997          	auipc	s3,0x15
    80002292:	4da98993          	addi	s3,s3,1242 # 80017768 <tickslock>
    havekids = 0;
    80002296:	875e                	mv	a4,s7
    for(np = proc; np < &proc[NPROC]; np++){
    80002298:	00010497          	auipc	s1,0x10
    8000229c:	ad048493          	addi	s1,s1,-1328 # 80011d68 <proc>
    800022a0:	a08d                	j	80002302 <wait+0xa4>
          pid = np->pid;
    800022a2:	0384a983          	lw	s3,56(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&np->xstate,
    800022a6:	000b0e63          	beqz	s6,800022c2 <wait+0x64>
    800022aa:	4691                	li	a3,4
    800022ac:	03448613          	addi	a2,s1,52
    800022b0:	85da                	mv	a1,s6
    800022b2:	05093503          	ld	a0,80(s2)
    800022b6:	fffff097          	auipc	ra,0xfffff
    800022ba:	40c080e7          	jalr	1036(ra) # 800016c2 <copyout>
    800022be:	02054263          	bltz	a0,800022e2 <wait+0x84>
          freeproc(np);
    800022c2:	8526                	mv	a0,s1
    800022c4:	00000097          	auipc	ra,0x0
    800022c8:	8ba080e7          	jalr	-1862(ra) # 80001b7e <freeproc>
          release(&np->lock);
    800022cc:	8526                	mv	a0,s1
    800022ce:	fffff097          	auipc	ra,0xfffff
    800022d2:	9e6080e7          	jalr	-1562(ra) # 80000cb4 <release>
          release(&p->lock);
    800022d6:	854a                	mv	a0,s2
    800022d8:	fffff097          	auipc	ra,0xfffff
    800022dc:	9dc080e7          	jalr	-1572(ra) # 80000cb4 <release>
          return pid;
    800022e0:	a8a9                	j	8000233a <wait+0xdc>
            release(&np->lock);
    800022e2:	8526                	mv	a0,s1
    800022e4:	fffff097          	auipc	ra,0xfffff
    800022e8:	9d0080e7          	jalr	-1584(ra) # 80000cb4 <release>
            release(&p->lock);
    800022ec:	854a                	mv	a0,s2
    800022ee:	fffff097          	auipc	ra,0xfffff
    800022f2:	9c6080e7          	jalr	-1594(ra) # 80000cb4 <release>
            return -1;
    800022f6:	59fd                	li	s3,-1
    800022f8:	a089                	j	8000233a <wait+0xdc>
    for(np = proc; np < &proc[NPROC]; np++){
    800022fa:	16848493          	addi	s1,s1,360
    800022fe:	03348463          	beq	s1,s3,80002326 <wait+0xc8>
      if(np->parent == p){
    80002302:	709c                	ld	a5,32(s1)
    80002304:	ff279be3          	bne	a5,s2,800022fa <wait+0x9c>
        acquire(&np->lock);
    80002308:	8526                	mv	a0,s1
    8000230a:	fffff097          	auipc	ra,0xfffff
    8000230e:	8f6080e7          	jalr	-1802(ra) # 80000c00 <acquire>
        if(np->state == ZOMBIE){
    80002312:	4c9c                	lw	a5,24(s1)
    80002314:	f94787e3          	beq	a5,s4,800022a2 <wait+0x44>
        release(&np->lock);
    80002318:	8526                	mv	a0,s1
    8000231a:	fffff097          	auipc	ra,0xfffff
    8000231e:	99a080e7          	jalr	-1638(ra) # 80000cb4 <release>
        havekids = 1;
    80002322:	8756                	mv	a4,s5
    80002324:	bfd9                	j	800022fa <wait+0x9c>
    if(!havekids || p->killed){
    80002326:	c701                	beqz	a4,8000232e <wait+0xd0>
    80002328:	03092783          	lw	a5,48(s2)
    8000232c:	c39d                	beqz	a5,80002352 <wait+0xf4>
      release(&p->lock);
    8000232e:	854a                	mv	a0,s2
    80002330:	fffff097          	auipc	ra,0xfffff
    80002334:	984080e7          	jalr	-1660(ra) # 80000cb4 <release>
      return -1;
    80002338:	59fd                	li	s3,-1
}
    8000233a:	854e                	mv	a0,s3
    8000233c:	60a6                	ld	ra,72(sp)
    8000233e:	6406                	ld	s0,64(sp)
    80002340:	74e2                	ld	s1,56(sp)
    80002342:	7942                	ld	s2,48(sp)
    80002344:	79a2                	ld	s3,40(sp)
    80002346:	7a02                	ld	s4,32(sp)
    80002348:	6ae2                	ld	s5,24(sp)
    8000234a:	6b42                	ld	s6,16(sp)
    8000234c:	6ba2                	ld	s7,8(sp)
    8000234e:	6161                	addi	sp,sp,80
    80002350:	8082                	ret
    sleep(p, &p->lock);  //DOC: wait-sleep
    80002352:	85ca                	mv	a1,s2
    80002354:	854a                	mv	a0,s2
    80002356:	00000097          	auipc	ra,0x0
    8000235a:	e8a080e7          	jalr	-374(ra) # 800021e0 <sleep>
    havekids = 0;
    8000235e:	bf25                	j	80002296 <wait+0x38>

0000000080002360 <wakeup>:
{
    80002360:	7139                	addi	sp,sp,-64
    80002362:	fc06                	sd	ra,56(sp)
    80002364:	f822                	sd	s0,48(sp)
    80002366:	f426                	sd	s1,40(sp)
    80002368:	f04a                	sd	s2,32(sp)
    8000236a:	ec4e                	sd	s3,24(sp)
    8000236c:	e852                	sd	s4,16(sp)
    8000236e:	e456                	sd	s5,8(sp)
    80002370:	0080                	addi	s0,sp,64
    80002372:	8a2a                	mv	s4,a0
  for(p = proc; p < &proc[NPROC]; p++) {
    80002374:	00010497          	auipc	s1,0x10
    80002378:	9f448493          	addi	s1,s1,-1548 # 80011d68 <proc>
    if(p->state == SLEEPING && p->chan == chan) {
    8000237c:	4985                	li	s3,1
      p->state = RUNNABLE;
    8000237e:	4a89                	li	s5,2
  for(p = proc; p < &proc[NPROC]; p++) {
    80002380:	00015917          	auipc	s2,0x15
    80002384:	3e890913          	addi	s2,s2,1000 # 80017768 <tickslock>
    80002388:	a811                	j	8000239c <wakeup+0x3c>
    release(&p->lock);
    8000238a:	8526                	mv	a0,s1
    8000238c:	fffff097          	auipc	ra,0xfffff
    80002390:	928080e7          	jalr	-1752(ra) # 80000cb4 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80002394:	16848493          	addi	s1,s1,360
    80002398:	03248063          	beq	s1,s2,800023b8 <wakeup+0x58>
    acquire(&p->lock);
    8000239c:	8526                	mv	a0,s1
    8000239e:	fffff097          	auipc	ra,0xfffff
    800023a2:	862080e7          	jalr	-1950(ra) # 80000c00 <acquire>
    if(p->state == SLEEPING && p->chan == chan) {
    800023a6:	4c9c                	lw	a5,24(s1)
    800023a8:	ff3791e3          	bne	a5,s3,8000238a <wakeup+0x2a>
    800023ac:	749c                	ld	a5,40(s1)
    800023ae:	fd479ee3          	bne	a5,s4,8000238a <wakeup+0x2a>
      p->state = RUNNABLE;
    800023b2:	0154ac23          	sw	s5,24(s1)
    800023b6:	bfd1                	j	8000238a <wakeup+0x2a>
}
    800023b8:	70e2                	ld	ra,56(sp)
    800023ba:	7442                	ld	s0,48(sp)
    800023bc:	74a2                	ld	s1,40(sp)
    800023be:	7902                	ld	s2,32(sp)
    800023c0:	69e2                	ld	s3,24(sp)
    800023c2:	6a42                	ld	s4,16(sp)
    800023c4:	6aa2                	ld	s5,8(sp)
    800023c6:	6121                	addi	sp,sp,64
    800023c8:	8082                	ret

00000000800023ca <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    800023ca:	7179                	addi	sp,sp,-48
    800023cc:	f406                	sd	ra,40(sp)
    800023ce:	f022                	sd	s0,32(sp)
    800023d0:	ec26                	sd	s1,24(sp)
    800023d2:	e84a                	sd	s2,16(sp)
    800023d4:	e44e                	sd	s3,8(sp)
    800023d6:	1800                	addi	s0,sp,48
    800023d8:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    800023da:	00010497          	auipc	s1,0x10
    800023de:	98e48493          	addi	s1,s1,-1650 # 80011d68 <proc>
    800023e2:	00015997          	auipc	s3,0x15
    800023e6:	38698993          	addi	s3,s3,902 # 80017768 <tickslock>
    acquire(&p->lock);
    800023ea:	8526                	mv	a0,s1
    800023ec:	fffff097          	auipc	ra,0xfffff
    800023f0:	814080e7          	jalr	-2028(ra) # 80000c00 <acquire>
    if(p->pid == pid){
    800023f4:	5c9c                	lw	a5,56(s1)
    800023f6:	01278d63          	beq	a5,s2,80002410 <kill+0x46>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    800023fa:	8526                	mv	a0,s1
    800023fc:	fffff097          	auipc	ra,0xfffff
    80002400:	8b8080e7          	jalr	-1864(ra) # 80000cb4 <release>
  for(p = proc; p < &proc[NPROC]; p++){
    80002404:	16848493          	addi	s1,s1,360
    80002408:	ff3491e3          	bne	s1,s3,800023ea <kill+0x20>
  }
  return -1;
    8000240c:	557d                	li	a0,-1
    8000240e:	a821                	j	80002426 <kill+0x5c>
      p->killed = 1;
    80002410:	4785                	li	a5,1
    80002412:	d89c                	sw	a5,48(s1)
      if(p->state == SLEEPING){
    80002414:	4c98                	lw	a4,24(s1)
    80002416:	00f70f63          	beq	a4,a5,80002434 <kill+0x6a>
      release(&p->lock);
    8000241a:	8526                	mv	a0,s1
    8000241c:	fffff097          	auipc	ra,0xfffff
    80002420:	898080e7          	jalr	-1896(ra) # 80000cb4 <release>
      return 0;
    80002424:	4501                	li	a0,0
}
    80002426:	70a2                	ld	ra,40(sp)
    80002428:	7402                	ld	s0,32(sp)
    8000242a:	64e2                	ld	s1,24(sp)
    8000242c:	6942                	ld	s2,16(sp)
    8000242e:	69a2                	ld	s3,8(sp)
    80002430:	6145                	addi	sp,sp,48
    80002432:	8082                	ret
        p->state = RUNNABLE;
    80002434:	4789                	li	a5,2
    80002436:	cc9c                	sw	a5,24(s1)
    80002438:	b7cd                	j	8000241a <kill+0x50>

000000008000243a <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    8000243a:	7179                	addi	sp,sp,-48
    8000243c:	f406                	sd	ra,40(sp)
    8000243e:	f022                	sd	s0,32(sp)
    80002440:	ec26                	sd	s1,24(sp)
    80002442:	e84a                	sd	s2,16(sp)
    80002444:	e44e                	sd	s3,8(sp)
    80002446:	e052                	sd	s4,0(sp)
    80002448:	1800                	addi	s0,sp,48
    8000244a:	84aa                	mv	s1,a0
    8000244c:	892e                	mv	s2,a1
    8000244e:	89b2                	mv	s3,a2
    80002450:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80002452:	fffff097          	auipc	ra,0xfffff
    80002456:	57a080e7          	jalr	1402(ra) # 800019cc <myproc>
  if(user_dst){
    8000245a:	c08d                	beqz	s1,8000247c <either_copyout+0x42>
    return copyout(p->pagetable, dst, src, len);
    8000245c:	86d2                	mv	a3,s4
    8000245e:	864e                	mv	a2,s3
    80002460:	85ca                	mv	a1,s2
    80002462:	6928                	ld	a0,80(a0)
    80002464:	fffff097          	auipc	ra,0xfffff
    80002468:	25e080e7          	jalr	606(ra) # 800016c2 <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    8000246c:	70a2                	ld	ra,40(sp)
    8000246e:	7402                	ld	s0,32(sp)
    80002470:	64e2                	ld	s1,24(sp)
    80002472:	6942                	ld	s2,16(sp)
    80002474:	69a2                	ld	s3,8(sp)
    80002476:	6a02                	ld	s4,0(sp)
    80002478:	6145                	addi	sp,sp,48
    8000247a:	8082                	ret
    memmove((char *)dst, src, len);
    8000247c:	000a061b          	sext.w	a2,s4
    80002480:	85ce                	mv	a1,s3
    80002482:	854a                	mv	a0,s2
    80002484:	fffff097          	auipc	ra,0xfffff
    80002488:	8d4080e7          	jalr	-1836(ra) # 80000d58 <memmove>
    return 0;
    8000248c:	8526                	mv	a0,s1
    8000248e:	bff9                	j	8000246c <either_copyout+0x32>

0000000080002490 <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    80002490:	7179                	addi	sp,sp,-48
    80002492:	f406                	sd	ra,40(sp)
    80002494:	f022                	sd	s0,32(sp)
    80002496:	ec26                	sd	s1,24(sp)
    80002498:	e84a                	sd	s2,16(sp)
    8000249a:	e44e                	sd	s3,8(sp)
    8000249c:	e052                	sd	s4,0(sp)
    8000249e:	1800                	addi	s0,sp,48
    800024a0:	892a                	mv	s2,a0
    800024a2:	84ae                	mv	s1,a1
    800024a4:	89b2                	mv	s3,a2
    800024a6:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    800024a8:	fffff097          	auipc	ra,0xfffff
    800024ac:	524080e7          	jalr	1316(ra) # 800019cc <myproc>
  if(user_src){
    800024b0:	c08d                	beqz	s1,800024d2 <either_copyin+0x42>
    return copyin(p->pagetable, dst, src, len);
    800024b2:	86d2                	mv	a3,s4
    800024b4:	864e                	mv	a2,s3
    800024b6:	85ca                	mv	a1,s2
    800024b8:	6928                	ld	a0,80(a0)
    800024ba:	fffff097          	auipc	ra,0xfffff
    800024be:	294080e7          	jalr	660(ra) # 8000174e <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    800024c2:	70a2                	ld	ra,40(sp)
    800024c4:	7402                	ld	s0,32(sp)
    800024c6:	64e2                	ld	s1,24(sp)
    800024c8:	6942                	ld	s2,16(sp)
    800024ca:	69a2                	ld	s3,8(sp)
    800024cc:	6a02                	ld	s4,0(sp)
    800024ce:	6145                	addi	sp,sp,48
    800024d0:	8082                	ret
    memmove(dst, (char*)src, len);
    800024d2:	000a061b          	sext.w	a2,s4
    800024d6:	85ce                	mv	a1,s3
    800024d8:	854a                	mv	a0,s2
    800024da:	fffff097          	auipc	ra,0xfffff
    800024de:	87e080e7          	jalr	-1922(ra) # 80000d58 <memmove>
    return 0;
    800024e2:	8526                	mv	a0,s1
    800024e4:	bff9                	j	800024c2 <either_copyin+0x32>

00000000800024e6 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    800024e6:	715d                	addi	sp,sp,-80
    800024e8:	e486                	sd	ra,72(sp)
    800024ea:	e0a2                	sd	s0,64(sp)
    800024ec:	fc26                	sd	s1,56(sp)
    800024ee:	f84a                	sd	s2,48(sp)
    800024f0:	f44e                	sd	s3,40(sp)
    800024f2:	f052                	sd	s4,32(sp)
    800024f4:	ec56                	sd	s5,24(sp)
    800024f6:	e85a                	sd	s6,16(sp)
    800024f8:	e45e                	sd	s7,8(sp)
    800024fa:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    800024fc:	00006517          	auipc	a0,0x6
    80002500:	bcc50513          	addi	a0,a0,-1076 # 800080c8 <digits+0x88>
    80002504:	ffffe097          	auipc	ra,0xffffe
    80002508:	08c080e7          	jalr	140(ra) # 80000590 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    8000250c:	00010497          	auipc	s1,0x10
    80002510:	9b448493          	addi	s1,s1,-1612 # 80011ec0 <proc+0x158>
    80002514:	00015917          	auipc	s2,0x15
    80002518:	3ac90913          	addi	s2,s2,940 # 800178c0 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    8000251c:	4b11                	li	s6,4
      state = states[p->state];
    else
      state = "???";
    8000251e:	00006997          	auipc	s3,0x6
    80002522:	d4a98993          	addi	s3,s3,-694 # 80008268 <digits+0x228>
    printf("%d %s %s", p->pid, state, p->name);
    80002526:	00006a97          	auipc	s5,0x6
    8000252a:	d4aa8a93          	addi	s5,s5,-694 # 80008270 <digits+0x230>
    printf("\n");
    8000252e:	00006a17          	auipc	s4,0x6
    80002532:	b9aa0a13          	addi	s4,s4,-1126 # 800080c8 <digits+0x88>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002536:	00006b97          	auipc	s7,0x6
    8000253a:	d72b8b93          	addi	s7,s7,-654 # 800082a8 <states.0>
    8000253e:	a00d                	j	80002560 <procdump+0x7a>
    printf("%d %s %s", p->pid, state, p->name);
    80002540:	ee06a583          	lw	a1,-288(a3)
    80002544:	8556                	mv	a0,s5
    80002546:	ffffe097          	auipc	ra,0xffffe
    8000254a:	04a080e7          	jalr	74(ra) # 80000590 <printf>
    printf("\n");
    8000254e:	8552                	mv	a0,s4
    80002550:	ffffe097          	auipc	ra,0xffffe
    80002554:	040080e7          	jalr	64(ra) # 80000590 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80002558:	16848493          	addi	s1,s1,360
    8000255c:	03248263          	beq	s1,s2,80002580 <procdump+0x9a>
    if(p->state == UNUSED)
    80002560:	86a6                	mv	a3,s1
    80002562:	ec04a783          	lw	a5,-320(s1)
    80002566:	dbed                	beqz	a5,80002558 <procdump+0x72>
      state = "???";
    80002568:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    8000256a:	fcfb6be3          	bltu	s6,a5,80002540 <procdump+0x5a>
    8000256e:	02079713          	slli	a4,a5,0x20
    80002572:	01d75793          	srli	a5,a4,0x1d
    80002576:	97de                	add	a5,a5,s7
    80002578:	6390                	ld	a2,0(a5)
    8000257a:	f279                	bnez	a2,80002540 <procdump+0x5a>
      state = "???";
    8000257c:	864e                	mv	a2,s3
    8000257e:	b7c9                	j	80002540 <procdump+0x5a>
  }
}
    80002580:	60a6                	ld	ra,72(sp)
    80002582:	6406                	ld	s0,64(sp)
    80002584:	74e2                	ld	s1,56(sp)
    80002586:	7942                	ld	s2,48(sp)
    80002588:	79a2                	ld	s3,40(sp)
    8000258a:	7a02                	ld	s4,32(sp)
    8000258c:	6ae2                	ld	s5,24(sp)
    8000258e:	6b42                	ld	s6,16(sp)
    80002590:	6ba2                	ld	s7,8(sp)
    80002592:	6161                	addi	sp,sp,80
    80002594:	8082                	ret

0000000080002596 <swtch>:
    80002596:	00153023          	sd	ra,0(a0)
    8000259a:	00253423          	sd	sp,8(a0)
    8000259e:	e900                	sd	s0,16(a0)
    800025a0:	ed04                	sd	s1,24(a0)
    800025a2:	03253023          	sd	s2,32(a0)
    800025a6:	03353423          	sd	s3,40(a0)
    800025aa:	03453823          	sd	s4,48(a0)
    800025ae:	03553c23          	sd	s5,56(a0)
    800025b2:	05653023          	sd	s6,64(a0)
    800025b6:	05753423          	sd	s7,72(a0)
    800025ba:	05853823          	sd	s8,80(a0)
    800025be:	05953c23          	sd	s9,88(a0)
    800025c2:	07a53023          	sd	s10,96(a0)
    800025c6:	07b53423          	sd	s11,104(a0)
    800025ca:	0005b083          	ld	ra,0(a1)
    800025ce:	0085b103          	ld	sp,8(a1)
    800025d2:	6980                	ld	s0,16(a1)
    800025d4:	6d84                	ld	s1,24(a1)
    800025d6:	0205b903          	ld	s2,32(a1)
    800025da:	0285b983          	ld	s3,40(a1)
    800025de:	0305ba03          	ld	s4,48(a1)
    800025e2:	0385ba83          	ld	s5,56(a1)
    800025e6:	0405bb03          	ld	s6,64(a1)
    800025ea:	0485bb83          	ld	s7,72(a1)
    800025ee:	0505bc03          	ld	s8,80(a1)
    800025f2:	0585bc83          	ld	s9,88(a1)
    800025f6:	0605bd03          	ld	s10,96(a1)
    800025fa:	0685bd83          	ld	s11,104(a1)
    800025fe:	8082                	ret

0000000080002600 <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80002600:	1141                	addi	sp,sp,-16
    80002602:	e406                	sd	ra,8(sp)
    80002604:	e022                	sd	s0,0(sp)
    80002606:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80002608:	00006597          	auipc	a1,0x6
    8000260c:	cc858593          	addi	a1,a1,-824 # 800082d0 <states.0+0x28>
    80002610:	00015517          	auipc	a0,0x15
    80002614:	15850513          	addi	a0,a0,344 # 80017768 <tickslock>
    80002618:	ffffe097          	auipc	ra,0xffffe
    8000261c:	558080e7          	jalr	1368(ra) # 80000b70 <initlock>
}
    80002620:	60a2                	ld	ra,8(sp)
    80002622:	6402                	ld	s0,0(sp)
    80002624:	0141                	addi	sp,sp,16
    80002626:	8082                	ret

0000000080002628 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80002628:	1141                	addi	sp,sp,-16
    8000262a:	e422                	sd	s0,8(sp)
    8000262c:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    8000262e:	00003797          	auipc	a5,0x3
    80002632:	4c278793          	addi	a5,a5,1218 # 80005af0 <kernelvec>
    80002636:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    8000263a:	6422                	ld	s0,8(sp)
    8000263c:	0141                	addi	sp,sp,16
    8000263e:	8082                	ret

0000000080002640 <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    80002640:	1141                	addi	sp,sp,-16
    80002642:	e406                	sd	ra,8(sp)
    80002644:	e022                	sd	s0,0(sp)
    80002646:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80002648:	fffff097          	auipc	ra,0xfffff
    8000264c:	384080e7          	jalr	900(ra) # 800019cc <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002650:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80002654:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002656:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to trampoline.S
  w_stvec(TRAMPOLINE + (uservec - trampoline));
    8000265a:	00005697          	auipc	a3,0x5
    8000265e:	9a668693          	addi	a3,a3,-1626 # 80007000 <_trampoline>
    80002662:	00005717          	auipc	a4,0x5
    80002666:	99e70713          	addi	a4,a4,-1634 # 80007000 <_trampoline>
    8000266a:	8f15                	sub	a4,a4,a3
    8000266c:	040007b7          	lui	a5,0x4000
    80002670:	17fd                	addi	a5,a5,-1 # 3ffffff <_entry-0x7c000001>
    80002672:	07b2                	slli	a5,a5,0xc
    80002674:	973e                	add	a4,a4,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80002676:	10571073          	csrw	stvec,a4

  // set up trapframe values that uservec will need when
  // the process next re-enters the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    8000267a:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    8000267c:	18002673          	csrr	a2,satp
    80002680:	e310                	sd	a2,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80002682:	6d30                	ld	a2,88(a0)
    80002684:	6138                	ld	a4,64(a0)
    80002686:	6585                	lui	a1,0x1
    80002688:	972e                	add	a4,a4,a1
    8000268a:	e618                	sd	a4,8(a2)
  p->trapframe->kernel_trap = (uint64)usertrap;
    8000268c:	6d38                	ld	a4,88(a0)
    8000268e:	00000617          	auipc	a2,0x0
    80002692:	13860613          	addi	a2,a2,312 # 800027c6 <usertrap>
    80002696:	eb10                	sd	a2,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80002698:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    8000269a:	8612                	mv	a2,tp
    8000269c:	f310                	sd	a2,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000269e:	10002773          	csrr	a4,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    800026a2:	eff77713          	andi	a4,a4,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    800026a6:	02076713          	ori	a4,a4,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800026aa:	10071073          	csrw	sstatus,a4
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    800026ae:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    800026b0:	6f18                	ld	a4,24(a4)
    800026b2:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    800026b6:	692c                	ld	a1,80(a0)
    800026b8:	81b1                	srli	a1,a1,0xc

  // jump to trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 fn = TRAMPOLINE + (userret - trampoline);
    800026ba:	00005717          	auipc	a4,0x5
    800026be:	9d670713          	addi	a4,a4,-1578 # 80007090 <userret>
    800026c2:	8f15                	sub	a4,a4,a3
    800026c4:	97ba                	add	a5,a5,a4
  ((void (*)(uint64,uint64))fn)(TRAPFRAME, satp);
    800026c6:	577d                	li	a4,-1
    800026c8:	177e                	slli	a4,a4,0x3f
    800026ca:	8dd9                	or	a1,a1,a4
    800026cc:	02000537          	lui	a0,0x2000
    800026d0:	157d                	addi	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    800026d2:	0536                	slli	a0,a0,0xd
    800026d4:	9782                	jalr	a5
}
    800026d6:	60a2                	ld	ra,8(sp)
    800026d8:	6402                	ld	s0,0(sp)
    800026da:	0141                	addi	sp,sp,16
    800026dc:	8082                	ret

00000000800026de <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    800026de:	1101                	addi	sp,sp,-32
    800026e0:	ec06                	sd	ra,24(sp)
    800026e2:	e822                	sd	s0,16(sp)
    800026e4:	e426                	sd	s1,8(sp)
    800026e6:	1000                	addi	s0,sp,32
  acquire(&tickslock);
    800026e8:	00015497          	auipc	s1,0x15
    800026ec:	08048493          	addi	s1,s1,128 # 80017768 <tickslock>
    800026f0:	8526                	mv	a0,s1
    800026f2:	ffffe097          	auipc	ra,0xffffe
    800026f6:	50e080e7          	jalr	1294(ra) # 80000c00 <acquire>
  ticks++;
    800026fa:	00007517          	auipc	a0,0x7
    800026fe:	92650513          	addi	a0,a0,-1754 # 80009020 <ticks>
    80002702:	411c                	lw	a5,0(a0)
    80002704:	2785                	addiw	a5,a5,1
    80002706:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    80002708:	00000097          	auipc	ra,0x0
    8000270c:	c58080e7          	jalr	-936(ra) # 80002360 <wakeup>
  release(&tickslock);
    80002710:	8526                	mv	a0,s1
    80002712:	ffffe097          	auipc	ra,0xffffe
    80002716:	5a2080e7          	jalr	1442(ra) # 80000cb4 <release>
}
    8000271a:	60e2                	ld	ra,24(sp)
    8000271c:	6442                	ld	s0,16(sp)
    8000271e:	64a2                	ld	s1,8(sp)
    80002720:	6105                	addi	sp,sp,32
    80002722:	8082                	ret

0000000080002724 <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    80002724:	1101                	addi	sp,sp,-32
    80002726:	ec06                	sd	ra,24(sp)
    80002728:	e822                	sd	s0,16(sp)
    8000272a:	e426                	sd	s1,8(sp)
    8000272c:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    8000272e:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if((scause & 0x8000000000000000L) &&
    80002732:	00074d63          	bltz	a4,8000274c <devintr+0x28>
    // now allowed to interrupt again.
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000001L){
    80002736:	57fd                	li	a5,-1
    80002738:	17fe                	slli	a5,a5,0x3f
    8000273a:	0785                	addi	a5,a5,1
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);

    return 2;
  } else {
    return 0;
    8000273c:	4501                	li	a0,0
  } else if(scause == 0x8000000000000001L){
    8000273e:	06f70363          	beq	a4,a5,800027a4 <devintr+0x80>
  }
}
    80002742:	60e2                	ld	ra,24(sp)
    80002744:	6442                	ld	s0,16(sp)
    80002746:	64a2                	ld	s1,8(sp)
    80002748:	6105                	addi	sp,sp,32
    8000274a:	8082                	ret
     (scause & 0xff) == 9){
    8000274c:	0ff77793          	zext.b	a5,a4
  if((scause & 0x8000000000000000L) &&
    80002750:	46a5                	li	a3,9
    80002752:	fed792e3          	bne	a5,a3,80002736 <devintr+0x12>
    int irq = plic_claim();
    80002756:	00003097          	auipc	ra,0x3
    8000275a:	4a2080e7          	jalr	1186(ra) # 80005bf8 <plic_claim>
    8000275e:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80002760:	47a9                	li	a5,10
    80002762:	02f50763          	beq	a0,a5,80002790 <devintr+0x6c>
    } else if(irq == VIRTIO0_IRQ){
    80002766:	4785                	li	a5,1
    80002768:	02f50963          	beq	a0,a5,8000279a <devintr+0x76>
    return 1;
    8000276c:	4505                	li	a0,1
    } else if(irq){
    8000276e:	d8f1                	beqz	s1,80002742 <devintr+0x1e>
      printf("unexpected interrupt irq=%d\n", irq);
    80002770:	85a6                	mv	a1,s1
    80002772:	00006517          	auipc	a0,0x6
    80002776:	b6650513          	addi	a0,a0,-1178 # 800082d8 <states.0+0x30>
    8000277a:	ffffe097          	auipc	ra,0xffffe
    8000277e:	e16080e7          	jalr	-490(ra) # 80000590 <printf>
      plic_complete(irq);
    80002782:	8526                	mv	a0,s1
    80002784:	00003097          	auipc	ra,0x3
    80002788:	498080e7          	jalr	1176(ra) # 80005c1c <plic_complete>
    return 1;
    8000278c:	4505                	li	a0,1
    8000278e:	bf55                	j	80002742 <devintr+0x1e>
      uartintr();
    80002790:	ffffe097          	auipc	ra,0xffffe
    80002794:	232080e7          	jalr	562(ra) # 800009c2 <uartintr>
    80002798:	b7ed                	j	80002782 <devintr+0x5e>
      virtio_disk_intr();
    8000279a:	00004097          	auipc	ra,0x4
    8000279e:	8f6080e7          	jalr	-1802(ra) # 80006090 <virtio_disk_intr>
    800027a2:	b7c5                	j	80002782 <devintr+0x5e>
    if(cpuid() == 0){
    800027a4:	fffff097          	auipc	ra,0xfffff
    800027a8:	1fc080e7          	jalr	508(ra) # 800019a0 <cpuid>
    800027ac:	c901                	beqz	a0,800027bc <devintr+0x98>
  asm volatile("csrr %0, sip" : "=r" (x) );
    800027ae:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    800027b2:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    800027b4:	14479073          	csrw	sip,a5
    return 2;
    800027b8:	4509                	li	a0,2
    800027ba:	b761                	j	80002742 <devintr+0x1e>
      clockintr();
    800027bc:	00000097          	auipc	ra,0x0
    800027c0:	f22080e7          	jalr	-222(ra) # 800026de <clockintr>
    800027c4:	b7ed                	j	800027ae <devintr+0x8a>

00000000800027c6 <usertrap>:
{
    800027c6:	1101                	addi	sp,sp,-32
    800027c8:	ec06                	sd	ra,24(sp)
    800027ca:	e822                	sd	s0,16(sp)
    800027cc:	e426                	sd	s1,8(sp)
    800027ce:	e04a                	sd	s2,0(sp)
    800027d0:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800027d2:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    800027d6:	1007f793          	andi	a5,a5,256
    800027da:	e3ad                	bnez	a5,8000283c <usertrap+0x76>
  asm volatile("csrw stvec, %0" : : "r" (x));
    800027dc:	00003797          	auipc	a5,0x3
    800027e0:	31478793          	addi	a5,a5,788 # 80005af0 <kernelvec>
    800027e4:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    800027e8:	fffff097          	auipc	ra,0xfffff
    800027ec:	1e4080e7          	jalr	484(ra) # 800019cc <myproc>
    800027f0:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    800027f2:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    800027f4:	14102773          	csrr	a4,sepc
    800027f8:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    800027fa:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    800027fe:	47a1                	li	a5,8
    80002800:	04f71c63          	bne	a4,a5,80002858 <usertrap+0x92>
    if(p->killed)
    80002804:	591c                	lw	a5,48(a0)
    80002806:	e3b9                	bnez	a5,8000284c <usertrap+0x86>
    p->trapframe->epc += 4;
    80002808:	6cb8                	ld	a4,88(s1)
    8000280a:	6f1c                	ld	a5,24(a4)
    8000280c:	0791                	addi	a5,a5,4
    8000280e:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002810:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80002814:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002818:	10079073          	csrw	sstatus,a5
    syscall();
    8000281c:	00000097          	auipc	ra,0x0
    80002820:	2e0080e7          	jalr	736(ra) # 80002afc <syscall>
  if(p->killed)
    80002824:	589c                	lw	a5,48(s1)
    80002826:	ebc1                	bnez	a5,800028b6 <usertrap+0xf0>
  usertrapret();
    80002828:	00000097          	auipc	ra,0x0
    8000282c:	e18080e7          	jalr	-488(ra) # 80002640 <usertrapret>
}
    80002830:	60e2                	ld	ra,24(sp)
    80002832:	6442                	ld	s0,16(sp)
    80002834:	64a2                	ld	s1,8(sp)
    80002836:	6902                	ld	s2,0(sp)
    80002838:	6105                	addi	sp,sp,32
    8000283a:	8082                	ret
    panic("usertrap: not from user mode");
    8000283c:	00006517          	auipc	a0,0x6
    80002840:	abc50513          	addi	a0,a0,-1348 # 800082f8 <states.0+0x50>
    80002844:	ffffe097          	auipc	ra,0xffffe
    80002848:	d02080e7          	jalr	-766(ra) # 80000546 <panic>
      exit(-1);
    8000284c:	557d                	li	a0,-1
    8000284e:	00000097          	auipc	ra,0x0
    80002852:	84c080e7          	jalr	-1972(ra) # 8000209a <exit>
    80002856:	bf4d                	j	80002808 <usertrap+0x42>
  } else if((which_dev = devintr()) != 0){
    80002858:	00000097          	auipc	ra,0x0
    8000285c:	ecc080e7          	jalr	-308(ra) # 80002724 <devintr>
    80002860:	892a                	mv	s2,a0
    80002862:	c501                	beqz	a0,8000286a <usertrap+0xa4>
  if(p->killed)
    80002864:	589c                	lw	a5,48(s1)
    80002866:	c3a1                	beqz	a5,800028a6 <usertrap+0xe0>
    80002868:	a815                	j	8000289c <usertrap+0xd6>
  asm volatile("csrr %0, scause" : "=r" (x) );
    8000286a:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    8000286e:	5c90                	lw	a2,56(s1)
    80002870:	00006517          	auipc	a0,0x6
    80002874:	aa850513          	addi	a0,a0,-1368 # 80008318 <states.0+0x70>
    80002878:	ffffe097          	auipc	ra,0xffffe
    8000287c:	d18080e7          	jalr	-744(ra) # 80000590 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002880:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80002884:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80002888:	00006517          	auipc	a0,0x6
    8000288c:	ac050513          	addi	a0,a0,-1344 # 80008348 <states.0+0xa0>
    80002890:	ffffe097          	auipc	ra,0xffffe
    80002894:	d00080e7          	jalr	-768(ra) # 80000590 <printf>
    p->killed = 1;
    80002898:	4785                	li	a5,1
    8000289a:	d89c                	sw	a5,48(s1)
    exit(-1);
    8000289c:	557d                	li	a0,-1
    8000289e:	fffff097          	auipc	ra,0xfffff
    800028a2:	7fc080e7          	jalr	2044(ra) # 8000209a <exit>
  if(which_dev == 2)
    800028a6:	4789                	li	a5,2
    800028a8:	f8f910e3          	bne	s2,a5,80002828 <usertrap+0x62>
    yield();
    800028ac:	00000097          	auipc	ra,0x0
    800028b0:	8f8080e7          	jalr	-1800(ra) # 800021a4 <yield>
    800028b4:	bf95                	j	80002828 <usertrap+0x62>
  int which_dev = 0;
    800028b6:	4901                	li	s2,0
    800028b8:	b7d5                	j	8000289c <usertrap+0xd6>

00000000800028ba <kerneltrap>:
{
    800028ba:	7179                	addi	sp,sp,-48
    800028bc:	f406                	sd	ra,40(sp)
    800028be:	f022                	sd	s0,32(sp)
    800028c0:	ec26                	sd	s1,24(sp)
    800028c2:	e84a                	sd	s2,16(sp)
    800028c4:	e44e                	sd	s3,8(sp)
    800028c6:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    800028c8:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800028cc:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    800028d0:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    800028d4:	1004f793          	andi	a5,s1,256
    800028d8:	cb85                	beqz	a5,80002908 <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800028da:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    800028de:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    800028e0:	ef85                	bnez	a5,80002918 <kerneltrap+0x5e>
  if((which_dev = devintr()) == 0){
    800028e2:	00000097          	auipc	ra,0x0
    800028e6:	e42080e7          	jalr	-446(ra) # 80002724 <devintr>
    800028ea:	cd1d                	beqz	a0,80002928 <kerneltrap+0x6e>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    800028ec:	4789                	li	a5,2
    800028ee:	06f50a63          	beq	a0,a5,80002962 <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    800028f2:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800028f6:	10049073          	csrw	sstatus,s1
}
    800028fa:	70a2                	ld	ra,40(sp)
    800028fc:	7402                	ld	s0,32(sp)
    800028fe:	64e2                	ld	s1,24(sp)
    80002900:	6942                	ld	s2,16(sp)
    80002902:	69a2                	ld	s3,8(sp)
    80002904:	6145                	addi	sp,sp,48
    80002906:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80002908:	00006517          	auipc	a0,0x6
    8000290c:	a6050513          	addi	a0,a0,-1440 # 80008368 <states.0+0xc0>
    80002910:	ffffe097          	auipc	ra,0xffffe
    80002914:	c36080e7          	jalr	-970(ra) # 80000546 <panic>
    panic("kerneltrap: interrupts enabled");
    80002918:	00006517          	auipc	a0,0x6
    8000291c:	a7850513          	addi	a0,a0,-1416 # 80008390 <states.0+0xe8>
    80002920:	ffffe097          	auipc	ra,0xffffe
    80002924:	c26080e7          	jalr	-986(ra) # 80000546 <panic>
    printf("scause %p\n", scause);
    80002928:	85ce                	mv	a1,s3
    8000292a:	00006517          	auipc	a0,0x6
    8000292e:	a8650513          	addi	a0,a0,-1402 # 800083b0 <states.0+0x108>
    80002932:	ffffe097          	auipc	ra,0xffffe
    80002936:	c5e080e7          	jalr	-930(ra) # 80000590 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    8000293a:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    8000293e:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80002942:	00006517          	auipc	a0,0x6
    80002946:	a7e50513          	addi	a0,a0,-1410 # 800083c0 <states.0+0x118>
    8000294a:	ffffe097          	auipc	ra,0xffffe
    8000294e:	c46080e7          	jalr	-954(ra) # 80000590 <printf>
    panic("kerneltrap");
    80002952:	00006517          	auipc	a0,0x6
    80002956:	a8650513          	addi	a0,a0,-1402 # 800083d8 <states.0+0x130>
    8000295a:	ffffe097          	auipc	ra,0xffffe
    8000295e:	bec080e7          	jalr	-1044(ra) # 80000546 <panic>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80002962:	fffff097          	auipc	ra,0xfffff
    80002966:	06a080e7          	jalr	106(ra) # 800019cc <myproc>
    8000296a:	d541                	beqz	a0,800028f2 <kerneltrap+0x38>
    8000296c:	fffff097          	auipc	ra,0xfffff
    80002970:	060080e7          	jalr	96(ra) # 800019cc <myproc>
    80002974:	4d18                	lw	a4,24(a0)
    80002976:	478d                	li	a5,3
    80002978:	f6f71de3          	bne	a4,a5,800028f2 <kerneltrap+0x38>
    yield();
    8000297c:	00000097          	auipc	ra,0x0
    80002980:	828080e7          	jalr	-2008(ra) # 800021a4 <yield>
    80002984:	b7bd                	j	800028f2 <kerneltrap+0x38>

0000000080002986 <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80002986:	1101                	addi	sp,sp,-32
    80002988:	ec06                	sd	ra,24(sp)
    8000298a:	e822                	sd	s0,16(sp)
    8000298c:	e426                	sd	s1,8(sp)
    8000298e:	1000                	addi	s0,sp,32
    80002990:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80002992:	fffff097          	auipc	ra,0xfffff
    80002996:	03a080e7          	jalr	58(ra) # 800019cc <myproc>
  switch (n) {
    8000299a:	4795                	li	a5,5
    8000299c:	0497e163          	bltu	a5,s1,800029de <argraw+0x58>
    800029a0:	048a                	slli	s1,s1,0x2
    800029a2:	00006717          	auipc	a4,0x6
    800029a6:	a6e70713          	addi	a4,a4,-1426 # 80008410 <states.0+0x168>
    800029aa:	94ba                	add	s1,s1,a4
    800029ac:	409c                	lw	a5,0(s1)
    800029ae:	97ba                	add	a5,a5,a4
    800029b0:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    800029b2:	6d3c                	ld	a5,88(a0)
    800029b4:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    800029b6:	60e2                	ld	ra,24(sp)
    800029b8:	6442                	ld	s0,16(sp)
    800029ba:	64a2                	ld	s1,8(sp)
    800029bc:	6105                	addi	sp,sp,32
    800029be:	8082                	ret
    return p->trapframe->a1;
    800029c0:	6d3c                	ld	a5,88(a0)
    800029c2:	7fa8                	ld	a0,120(a5)
    800029c4:	bfcd                	j	800029b6 <argraw+0x30>
    return p->trapframe->a2;
    800029c6:	6d3c                	ld	a5,88(a0)
    800029c8:	63c8                	ld	a0,128(a5)
    800029ca:	b7f5                	j	800029b6 <argraw+0x30>
    return p->trapframe->a3;
    800029cc:	6d3c                	ld	a5,88(a0)
    800029ce:	67c8                	ld	a0,136(a5)
    800029d0:	b7dd                	j	800029b6 <argraw+0x30>
    return p->trapframe->a4;
    800029d2:	6d3c                	ld	a5,88(a0)
    800029d4:	6bc8                	ld	a0,144(a5)
    800029d6:	b7c5                	j	800029b6 <argraw+0x30>
    return p->trapframe->a5;
    800029d8:	6d3c                	ld	a5,88(a0)
    800029da:	6fc8                	ld	a0,152(a5)
    800029dc:	bfe9                	j	800029b6 <argraw+0x30>
  panic("argraw");
    800029de:	00006517          	auipc	a0,0x6
    800029e2:	a0a50513          	addi	a0,a0,-1526 # 800083e8 <states.0+0x140>
    800029e6:	ffffe097          	auipc	ra,0xffffe
    800029ea:	b60080e7          	jalr	-1184(ra) # 80000546 <panic>

00000000800029ee <fetchaddr>:
{
    800029ee:	1101                	addi	sp,sp,-32
    800029f0:	ec06                	sd	ra,24(sp)
    800029f2:	e822                	sd	s0,16(sp)
    800029f4:	e426                	sd	s1,8(sp)
    800029f6:	e04a                	sd	s2,0(sp)
    800029f8:	1000                	addi	s0,sp,32
    800029fa:	84aa                	mv	s1,a0
    800029fc:	892e                	mv	s2,a1
  struct proc *p = myproc();
    800029fe:	fffff097          	auipc	ra,0xfffff
    80002a02:	fce080e7          	jalr	-50(ra) # 800019cc <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz)
    80002a06:	653c                	ld	a5,72(a0)
    80002a08:	02f4f863          	bgeu	s1,a5,80002a38 <fetchaddr+0x4a>
    80002a0c:	00848713          	addi	a4,s1,8
    80002a10:	02e7e663          	bltu	a5,a4,80002a3c <fetchaddr+0x4e>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80002a14:	46a1                	li	a3,8
    80002a16:	8626                	mv	a2,s1
    80002a18:	85ca                	mv	a1,s2
    80002a1a:	6928                	ld	a0,80(a0)
    80002a1c:	fffff097          	auipc	ra,0xfffff
    80002a20:	d32080e7          	jalr	-718(ra) # 8000174e <copyin>
    80002a24:	00a03533          	snez	a0,a0
    80002a28:	40a00533          	neg	a0,a0
}
    80002a2c:	60e2                	ld	ra,24(sp)
    80002a2e:	6442                	ld	s0,16(sp)
    80002a30:	64a2                	ld	s1,8(sp)
    80002a32:	6902                	ld	s2,0(sp)
    80002a34:	6105                	addi	sp,sp,32
    80002a36:	8082                	ret
    return -1;
    80002a38:	557d                	li	a0,-1
    80002a3a:	bfcd                	j	80002a2c <fetchaddr+0x3e>
    80002a3c:	557d                	li	a0,-1
    80002a3e:	b7fd                	j	80002a2c <fetchaddr+0x3e>

0000000080002a40 <fetchstr>:
{
    80002a40:	7179                	addi	sp,sp,-48
    80002a42:	f406                	sd	ra,40(sp)
    80002a44:	f022                	sd	s0,32(sp)
    80002a46:	ec26                	sd	s1,24(sp)
    80002a48:	e84a                	sd	s2,16(sp)
    80002a4a:	e44e                	sd	s3,8(sp)
    80002a4c:	1800                	addi	s0,sp,48
    80002a4e:	892a                	mv	s2,a0
    80002a50:	84ae                	mv	s1,a1
    80002a52:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80002a54:	fffff097          	auipc	ra,0xfffff
    80002a58:	f78080e7          	jalr	-136(ra) # 800019cc <myproc>
  int err = copyinstr(p->pagetable, buf, addr, max);
    80002a5c:	86ce                	mv	a3,s3
    80002a5e:	864a                	mv	a2,s2
    80002a60:	85a6                	mv	a1,s1
    80002a62:	6928                	ld	a0,80(a0)
    80002a64:	fffff097          	auipc	ra,0xfffff
    80002a68:	d78080e7          	jalr	-648(ra) # 800017dc <copyinstr>
  if(err < 0)
    80002a6c:	00054763          	bltz	a0,80002a7a <fetchstr+0x3a>
  return strlen(buf);
    80002a70:	8526                	mv	a0,s1
    80002a72:	ffffe097          	auipc	ra,0xffffe
    80002a76:	40e080e7          	jalr	1038(ra) # 80000e80 <strlen>
}
    80002a7a:	70a2                	ld	ra,40(sp)
    80002a7c:	7402                	ld	s0,32(sp)
    80002a7e:	64e2                	ld	s1,24(sp)
    80002a80:	6942                	ld	s2,16(sp)
    80002a82:	69a2                	ld	s3,8(sp)
    80002a84:	6145                	addi	sp,sp,48
    80002a86:	8082                	ret

0000000080002a88 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
    80002a88:	1101                	addi	sp,sp,-32
    80002a8a:	ec06                	sd	ra,24(sp)
    80002a8c:	e822                	sd	s0,16(sp)
    80002a8e:	e426                	sd	s1,8(sp)
    80002a90:	1000                	addi	s0,sp,32
    80002a92:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002a94:	00000097          	auipc	ra,0x0
    80002a98:	ef2080e7          	jalr	-270(ra) # 80002986 <argraw>
    80002a9c:	c088                	sw	a0,0(s1)
  return 0;
}
    80002a9e:	4501                	li	a0,0
    80002aa0:	60e2                	ld	ra,24(sp)
    80002aa2:	6442                	ld	s0,16(sp)
    80002aa4:	64a2                	ld	s1,8(sp)
    80002aa6:	6105                	addi	sp,sp,32
    80002aa8:	8082                	ret

0000000080002aaa <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
int
argaddr(int n, uint64 *ip)
{
    80002aaa:	1101                	addi	sp,sp,-32
    80002aac:	ec06                	sd	ra,24(sp)
    80002aae:	e822                	sd	s0,16(sp)
    80002ab0:	e426                	sd	s1,8(sp)
    80002ab2:	1000                	addi	s0,sp,32
    80002ab4:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002ab6:	00000097          	auipc	ra,0x0
    80002aba:	ed0080e7          	jalr	-304(ra) # 80002986 <argraw>
    80002abe:	e088                	sd	a0,0(s1)
  return 0;
}
    80002ac0:	4501                	li	a0,0
    80002ac2:	60e2                	ld	ra,24(sp)
    80002ac4:	6442                	ld	s0,16(sp)
    80002ac6:	64a2                	ld	s1,8(sp)
    80002ac8:	6105                	addi	sp,sp,32
    80002aca:	8082                	ret

0000000080002acc <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    80002acc:	1101                	addi	sp,sp,-32
    80002ace:	ec06                	sd	ra,24(sp)
    80002ad0:	e822                	sd	s0,16(sp)
    80002ad2:	e426                	sd	s1,8(sp)
    80002ad4:	e04a                	sd	s2,0(sp)
    80002ad6:	1000                	addi	s0,sp,32
    80002ad8:	84ae                	mv	s1,a1
    80002ada:	8932                	mv	s2,a2
  *ip = argraw(n);
    80002adc:	00000097          	auipc	ra,0x0
    80002ae0:	eaa080e7          	jalr	-342(ra) # 80002986 <argraw>
  uint64 addr;
  if(argaddr(n, &addr) < 0)
    return -1;
  return fetchstr(addr, buf, max);
    80002ae4:	864a                	mv	a2,s2
    80002ae6:	85a6                	mv	a1,s1
    80002ae8:	00000097          	auipc	ra,0x0
    80002aec:	f58080e7          	jalr	-168(ra) # 80002a40 <fetchstr>
}
    80002af0:	60e2                	ld	ra,24(sp)
    80002af2:	6442                	ld	s0,16(sp)
    80002af4:	64a2                	ld	s1,8(sp)
    80002af6:	6902                	ld	s2,0(sp)
    80002af8:	6105                	addi	sp,sp,32
    80002afa:	8082                	ret

0000000080002afc <syscall>:
[SYS_close]   sys_close,
};

void
syscall(void)
{
    80002afc:	1101                	addi	sp,sp,-32
    80002afe:	ec06                	sd	ra,24(sp)
    80002b00:	e822                	sd	s0,16(sp)
    80002b02:	e426                	sd	s1,8(sp)
    80002b04:	e04a                	sd	s2,0(sp)
    80002b06:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    80002b08:	fffff097          	auipc	ra,0xfffff
    80002b0c:	ec4080e7          	jalr	-316(ra) # 800019cc <myproc>
    80002b10:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    80002b12:	05853903          	ld	s2,88(a0)
    80002b16:	0a893783          	ld	a5,168(s2)
    80002b1a:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80002b1e:	37fd                	addiw	a5,a5,-1
    80002b20:	4751                	li	a4,20
    80002b22:	00f76f63          	bltu	a4,a5,80002b40 <syscall+0x44>
    80002b26:	00369713          	slli	a4,a3,0x3
    80002b2a:	00006797          	auipc	a5,0x6
    80002b2e:	8fe78793          	addi	a5,a5,-1794 # 80008428 <syscalls>
    80002b32:	97ba                	add	a5,a5,a4
    80002b34:	639c                	ld	a5,0(a5)
    80002b36:	c789                	beqz	a5,80002b40 <syscall+0x44>
    p->trapframe->a0 = syscalls[num]();
    80002b38:	9782                	jalr	a5
    80002b3a:	06a93823          	sd	a0,112(s2)
    80002b3e:	a839                	j	80002b5c <syscall+0x60>
  } else {
    printf("%d %s: unknown sys call %d\n",
    80002b40:	15848613          	addi	a2,s1,344
    80002b44:	5c8c                	lw	a1,56(s1)
    80002b46:	00006517          	auipc	a0,0x6
    80002b4a:	8aa50513          	addi	a0,a0,-1878 # 800083f0 <states.0+0x148>
    80002b4e:	ffffe097          	auipc	ra,0xffffe
    80002b52:	a42080e7          	jalr	-1470(ra) # 80000590 <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    80002b56:	6cbc                	ld	a5,88(s1)
    80002b58:	577d                	li	a4,-1
    80002b5a:	fbb8                	sd	a4,112(a5)
  }
}
    80002b5c:	60e2                	ld	ra,24(sp)
    80002b5e:	6442                	ld	s0,16(sp)
    80002b60:	64a2                	ld	s1,8(sp)
    80002b62:	6902                	ld	s2,0(sp)
    80002b64:	6105                	addi	sp,sp,32
    80002b66:	8082                	ret

0000000080002b68 <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    80002b68:	1101                	addi	sp,sp,-32
    80002b6a:	ec06                	sd	ra,24(sp)
    80002b6c:	e822                	sd	s0,16(sp)
    80002b6e:	1000                	addi	s0,sp,32
  int n;
  if(argint(0, &n) < 0)
    80002b70:	fec40593          	addi	a1,s0,-20
    80002b74:	4501                	li	a0,0
    80002b76:	00000097          	auipc	ra,0x0
    80002b7a:	f12080e7          	jalr	-238(ra) # 80002a88 <argint>
    return -1;
    80002b7e:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    80002b80:	00054963          	bltz	a0,80002b92 <sys_exit+0x2a>
  exit(n);
    80002b84:	fec42503          	lw	a0,-20(s0)
    80002b88:	fffff097          	auipc	ra,0xfffff
    80002b8c:	512080e7          	jalr	1298(ra) # 8000209a <exit>
  return 0;  // not reached
    80002b90:	4781                	li	a5,0
}
    80002b92:	853e                	mv	a0,a5
    80002b94:	60e2                	ld	ra,24(sp)
    80002b96:	6442                	ld	s0,16(sp)
    80002b98:	6105                	addi	sp,sp,32
    80002b9a:	8082                	ret

0000000080002b9c <sys_getpid>:

uint64
sys_getpid(void)
{
    80002b9c:	1141                	addi	sp,sp,-16
    80002b9e:	e406                	sd	ra,8(sp)
    80002ba0:	e022                	sd	s0,0(sp)
    80002ba2:	0800                	addi	s0,sp,16
  return myproc()->pid;
    80002ba4:	fffff097          	auipc	ra,0xfffff
    80002ba8:	e28080e7          	jalr	-472(ra) # 800019cc <myproc>
}
    80002bac:	5d08                	lw	a0,56(a0)
    80002bae:	60a2                	ld	ra,8(sp)
    80002bb0:	6402                	ld	s0,0(sp)
    80002bb2:	0141                	addi	sp,sp,16
    80002bb4:	8082                	ret

0000000080002bb6 <sys_fork>:

uint64
sys_fork(void)
{
    80002bb6:	1141                	addi	sp,sp,-16
    80002bb8:	e406                	sd	ra,8(sp)
    80002bba:	e022                	sd	s0,0(sp)
    80002bbc:	0800                	addi	s0,sp,16
  return fork();
    80002bbe:	fffff097          	auipc	ra,0xfffff
    80002bc2:	1d2080e7          	jalr	466(ra) # 80001d90 <fork>
}
    80002bc6:	60a2                	ld	ra,8(sp)
    80002bc8:	6402                	ld	s0,0(sp)
    80002bca:	0141                	addi	sp,sp,16
    80002bcc:	8082                	ret

0000000080002bce <sys_wait>:

uint64
sys_wait(void)
{
    80002bce:	1101                	addi	sp,sp,-32
    80002bd0:	ec06                	sd	ra,24(sp)
    80002bd2:	e822                	sd	s0,16(sp)
    80002bd4:	1000                	addi	s0,sp,32
  uint64 p;
  if(argaddr(0, &p) < 0)
    80002bd6:	fe840593          	addi	a1,s0,-24
    80002bda:	4501                	li	a0,0
    80002bdc:	00000097          	auipc	ra,0x0
    80002be0:	ece080e7          	jalr	-306(ra) # 80002aaa <argaddr>
    80002be4:	87aa                	mv	a5,a0
    return -1;
    80002be6:	557d                	li	a0,-1
  if(argaddr(0, &p) < 0)
    80002be8:	0007c863          	bltz	a5,80002bf8 <sys_wait+0x2a>
  return wait(p);
    80002bec:	fe843503          	ld	a0,-24(s0)
    80002bf0:	fffff097          	auipc	ra,0xfffff
    80002bf4:	66e080e7          	jalr	1646(ra) # 8000225e <wait>
}
    80002bf8:	60e2                	ld	ra,24(sp)
    80002bfa:	6442                	ld	s0,16(sp)
    80002bfc:	6105                	addi	sp,sp,32
    80002bfe:	8082                	ret

0000000080002c00 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    80002c00:	7179                	addi	sp,sp,-48
    80002c02:	f406                	sd	ra,40(sp)
    80002c04:	f022                	sd	s0,32(sp)
    80002c06:	ec26                	sd	s1,24(sp)
    80002c08:	1800                	addi	s0,sp,48
  int addr;
  int n;

  if(argint(0, &n) < 0)
    80002c0a:	fdc40593          	addi	a1,s0,-36
    80002c0e:	4501                	li	a0,0
    80002c10:	00000097          	auipc	ra,0x0
    80002c14:	e78080e7          	jalr	-392(ra) # 80002a88 <argint>
    80002c18:	87aa                	mv	a5,a0
    return -1;
    80002c1a:	557d                	li	a0,-1
  if(argint(0, &n) < 0)
    80002c1c:	0207c063          	bltz	a5,80002c3c <sys_sbrk+0x3c>
  addr = myproc()->sz;
    80002c20:	fffff097          	auipc	ra,0xfffff
    80002c24:	dac080e7          	jalr	-596(ra) # 800019cc <myproc>
    80002c28:	4524                	lw	s1,72(a0)
  if(growproc(n) < 0)
    80002c2a:	fdc42503          	lw	a0,-36(s0)
    80002c2e:	fffff097          	auipc	ra,0xfffff
    80002c32:	0ea080e7          	jalr	234(ra) # 80001d18 <growproc>
    80002c36:	00054863          	bltz	a0,80002c46 <sys_sbrk+0x46>
    return -1;
  return addr;
    80002c3a:	8526                	mv	a0,s1
}
    80002c3c:	70a2                	ld	ra,40(sp)
    80002c3e:	7402                	ld	s0,32(sp)
    80002c40:	64e2                	ld	s1,24(sp)
    80002c42:	6145                	addi	sp,sp,48
    80002c44:	8082                	ret
    return -1;
    80002c46:	557d                	li	a0,-1
    80002c48:	bfd5                	j	80002c3c <sys_sbrk+0x3c>

0000000080002c4a <sys_sleep>:

uint64
sys_sleep(void)
{
    80002c4a:	7139                	addi	sp,sp,-64
    80002c4c:	fc06                	sd	ra,56(sp)
    80002c4e:	f822                	sd	s0,48(sp)
    80002c50:	f426                	sd	s1,40(sp)
    80002c52:	f04a                	sd	s2,32(sp)
    80002c54:	ec4e                	sd	s3,24(sp)
    80002c56:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
    80002c58:	fcc40593          	addi	a1,s0,-52
    80002c5c:	4501                	li	a0,0
    80002c5e:	00000097          	auipc	ra,0x0
    80002c62:	e2a080e7          	jalr	-470(ra) # 80002a88 <argint>
    return -1;
    80002c66:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    80002c68:	06054563          	bltz	a0,80002cd2 <sys_sleep+0x88>
  acquire(&tickslock);
    80002c6c:	00015517          	auipc	a0,0x15
    80002c70:	afc50513          	addi	a0,a0,-1284 # 80017768 <tickslock>
    80002c74:	ffffe097          	auipc	ra,0xffffe
    80002c78:	f8c080e7          	jalr	-116(ra) # 80000c00 <acquire>
  ticks0 = ticks;
    80002c7c:	00006917          	auipc	s2,0x6
    80002c80:	3a492903          	lw	s2,932(s2) # 80009020 <ticks>
  while(ticks - ticks0 < n){
    80002c84:	fcc42783          	lw	a5,-52(s0)
    80002c88:	cf85                	beqz	a5,80002cc0 <sys_sleep+0x76>
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    80002c8a:	00015997          	auipc	s3,0x15
    80002c8e:	ade98993          	addi	s3,s3,-1314 # 80017768 <tickslock>
    80002c92:	00006497          	auipc	s1,0x6
    80002c96:	38e48493          	addi	s1,s1,910 # 80009020 <ticks>
    if(myproc()->killed){
    80002c9a:	fffff097          	auipc	ra,0xfffff
    80002c9e:	d32080e7          	jalr	-718(ra) # 800019cc <myproc>
    80002ca2:	591c                	lw	a5,48(a0)
    80002ca4:	ef9d                	bnez	a5,80002ce2 <sys_sleep+0x98>
    sleep(&ticks, &tickslock);
    80002ca6:	85ce                	mv	a1,s3
    80002ca8:	8526                	mv	a0,s1
    80002caa:	fffff097          	auipc	ra,0xfffff
    80002cae:	536080e7          	jalr	1334(ra) # 800021e0 <sleep>
  while(ticks - ticks0 < n){
    80002cb2:	409c                	lw	a5,0(s1)
    80002cb4:	412787bb          	subw	a5,a5,s2
    80002cb8:	fcc42703          	lw	a4,-52(s0)
    80002cbc:	fce7efe3          	bltu	a5,a4,80002c9a <sys_sleep+0x50>
  }
  release(&tickslock);
    80002cc0:	00015517          	auipc	a0,0x15
    80002cc4:	aa850513          	addi	a0,a0,-1368 # 80017768 <tickslock>
    80002cc8:	ffffe097          	auipc	ra,0xffffe
    80002ccc:	fec080e7          	jalr	-20(ra) # 80000cb4 <release>
  return 0;
    80002cd0:	4781                	li	a5,0
}
    80002cd2:	853e                	mv	a0,a5
    80002cd4:	70e2                	ld	ra,56(sp)
    80002cd6:	7442                	ld	s0,48(sp)
    80002cd8:	74a2                	ld	s1,40(sp)
    80002cda:	7902                	ld	s2,32(sp)
    80002cdc:	69e2                	ld	s3,24(sp)
    80002cde:	6121                	addi	sp,sp,64
    80002ce0:	8082                	ret
      release(&tickslock);
    80002ce2:	00015517          	auipc	a0,0x15
    80002ce6:	a8650513          	addi	a0,a0,-1402 # 80017768 <tickslock>
    80002cea:	ffffe097          	auipc	ra,0xffffe
    80002cee:	fca080e7          	jalr	-54(ra) # 80000cb4 <release>
      return -1;
    80002cf2:	57fd                	li	a5,-1
    80002cf4:	bff9                	j	80002cd2 <sys_sleep+0x88>

0000000080002cf6 <sys_kill>:

uint64
sys_kill(void)
{
    80002cf6:	1101                	addi	sp,sp,-32
    80002cf8:	ec06                	sd	ra,24(sp)
    80002cfa:	e822                	sd	s0,16(sp)
    80002cfc:	1000                	addi	s0,sp,32
  int pid;

  if(argint(0, &pid) < 0)
    80002cfe:	fec40593          	addi	a1,s0,-20
    80002d02:	4501                	li	a0,0
    80002d04:	00000097          	auipc	ra,0x0
    80002d08:	d84080e7          	jalr	-636(ra) # 80002a88 <argint>
    80002d0c:	87aa                	mv	a5,a0
    return -1;
    80002d0e:	557d                	li	a0,-1
  if(argint(0, &pid) < 0)
    80002d10:	0007c863          	bltz	a5,80002d20 <sys_kill+0x2a>
  return kill(pid);
    80002d14:	fec42503          	lw	a0,-20(s0)
    80002d18:	fffff097          	auipc	ra,0xfffff
    80002d1c:	6b2080e7          	jalr	1714(ra) # 800023ca <kill>
}
    80002d20:	60e2                	ld	ra,24(sp)
    80002d22:	6442                	ld	s0,16(sp)
    80002d24:	6105                	addi	sp,sp,32
    80002d26:	8082                	ret

0000000080002d28 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    80002d28:	1101                	addi	sp,sp,-32
    80002d2a:	ec06                	sd	ra,24(sp)
    80002d2c:	e822                	sd	s0,16(sp)
    80002d2e:	e426                	sd	s1,8(sp)
    80002d30:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    80002d32:	00015517          	auipc	a0,0x15
    80002d36:	a3650513          	addi	a0,a0,-1482 # 80017768 <tickslock>
    80002d3a:	ffffe097          	auipc	ra,0xffffe
    80002d3e:	ec6080e7          	jalr	-314(ra) # 80000c00 <acquire>
  xticks = ticks;
    80002d42:	00006497          	auipc	s1,0x6
    80002d46:	2de4a483          	lw	s1,734(s1) # 80009020 <ticks>
  release(&tickslock);
    80002d4a:	00015517          	auipc	a0,0x15
    80002d4e:	a1e50513          	addi	a0,a0,-1506 # 80017768 <tickslock>
    80002d52:	ffffe097          	auipc	ra,0xffffe
    80002d56:	f62080e7          	jalr	-158(ra) # 80000cb4 <release>
  return xticks;
}
    80002d5a:	02049513          	slli	a0,s1,0x20
    80002d5e:	9101                	srli	a0,a0,0x20
    80002d60:	60e2                	ld	ra,24(sp)
    80002d62:	6442                	ld	s0,16(sp)
    80002d64:	64a2                	ld	s1,8(sp)
    80002d66:	6105                	addi	sp,sp,32
    80002d68:	8082                	ret

0000000080002d6a <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    80002d6a:	7179                	addi	sp,sp,-48
    80002d6c:	f406                	sd	ra,40(sp)
    80002d6e:	f022                	sd	s0,32(sp)
    80002d70:	ec26                	sd	s1,24(sp)
    80002d72:	e84a                	sd	s2,16(sp)
    80002d74:	e44e                	sd	s3,8(sp)
    80002d76:	e052                	sd	s4,0(sp)
    80002d78:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    80002d7a:	00005597          	auipc	a1,0x5
    80002d7e:	75e58593          	addi	a1,a1,1886 # 800084d8 <syscalls+0xb0>
    80002d82:	00015517          	auipc	a0,0x15
    80002d86:	9fe50513          	addi	a0,a0,-1538 # 80017780 <bcache>
    80002d8a:	ffffe097          	auipc	ra,0xffffe
    80002d8e:	de6080e7          	jalr	-538(ra) # 80000b70 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    80002d92:	0001d797          	auipc	a5,0x1d
    80002d96:	9ee78793          	addi	a5,a5,-1554 # 8001f780 <bcache+0x8000>
    80002d9a:	0001d717          	auipc	a4,0x1d
    80002d9e:	c4e70713          	addi	a4,a4,-946 # 8001f9e8 <bcache+0x8268>
    80002da2:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    80002da6:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002daa:	00015497          	auipc	s1,0x15
    80002dae:	9ee48493          	addi	s1,s1,-1554 # 80017798 <bcache+0x18>
    b->next = bcache.head.next;
    80002db2:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    80002db4:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    80002db6:	00005a17          	auipc	s4,0x5
    80002dba:	72aa0a13          	addi	s4,s4,1834 # 800084e0 <syscalls+0xb8>
    b->next = bcache.head.next;
    80002dbe:	2b893783          	ld	a5,696(s2)
    80002dc2:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    80002dc4:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    80002dc8:	85d2                	mv	a1,s4
    80002dca:	01048513          	addi	a0,s1,16
    80002dce:	00001097          	auipc	ra,0x1
    80002dd2:	4b2080e7          	jalr	1202(ra) # 80004280 <initsleeplock>
    bcache.head.next->prev = b;
    80002dd6:	2b893783          	ld	a5,696(s2)
    80002dda:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    80002ddc:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002de0:	45848493          	addi	s1,s1,1112
    80002de4:	fd349de3          	bne	s1,s3,80002dbe <binit+0x54>
  }
}
    80002de8:	70a2                	ld	ra,40(sp)
    80002dea:	7402                	ld	s0,32(sp)
    80002dec:	64e2                	ld	s1,24(sp)
    80002dee:	6942                	ld	s2,16(sp)
    80002df0:	69a2                	ld	s3,8(sp)
    80002df2:	6a02                	ld	s4,0(sp)
    80002df4:	6145                	addi	sp,sp,48
    80002df6:	8082                	ret

0000000080002df8 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    80002df8:	7179                	addi	sp,sp,-48
    80002dfa:	f406                	sd	ra,40(sp)
    80002dfc:	f022                	sd	s0,32(sp)
    80002dfe:	ec26                	sd	s1,24(sp)
    80002e00:	e84a                	sd	s2,16(sp)
    80002e02:	e44e                	sd	s3,8(sp)
    80002e04:	1800                	addi	s0,sp,48
    80002e06:	892a                	mv	s2,a0
    80002e08:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    80002e0a:	00015517          	auipc	a0,0x15
    80002e0e:	97650513          	addi	a0,a0,-1674 # 80017780 <bcache>
    80002e12:	ffffe097          	auipc	ra,0xffffe
    80002e16:	dee080e7          	jalr	-530(ra) # 80000c00 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    80002e1a:	0001d497          	auipc	s1,0x1d
    80002e1e:	c1e4b483          	ld	s1,-994(s1) # 8001fa38 <bcache+0x82b8>
    80002e22:	0001d797          	auipc	a5,0x1d
    80002e26:	bc678793          	addi	a5,a5,-1082 # 8001f9e8 <bcache+0x8268>
    80002e2a:	02f48f63          	beq	s1,a5,80002e68 <bread+0x70>
    80002e2e:	873e                	mv	a4,a5
    80002e30:	a021                	j	80002e38 <bread+0x40>
    80002e32:	68a4                	ld	s1,80(s1)
    80002e34:	02e48a63          	beq	s1,a4,80002e68 <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    80002e38:	449c                	lw	a5,8(s1)
    80002e3a:	ff279ce3          	bne	a5,s2,80002e32 <bread+0x3a>
    80002e3e:	44dc                	lw	a5,12(s1)
    80002e40:	ff3799e3          	bne	a5,s3,80002e32 <bread+0x3a>
      b->refcnt++;
    80002e44:	40bc                	lw	a5,64(s1)
    80002e46:	2785                	addiw	a5,a5,1
    80002e48:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002e4a:	00015517          	auipc	a0,0x15
    80002e4e:	93650513          	addi	a0,a0,-1738 # 80017780 <bcache>
    80002e52:	ffffe097          	auipc	ra,0xffffe
    80002e56:	e62080e7          	jalr	-414(ra) # 80000cb4 <release>
      acquiresleep(&b->lock);
    80002e5a:	01048513          	addi	a0,s1,16
    80002e5e:	00001097          	auipc	ra,0x1
    80002e62:	45c080e7          	jalr	1116(ra) # 800042ba <acquiresleep>
      return b;
    80002e66:	a8b9                	j	80002ec4 <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002e68:	0001d497          	auipc	s1,0x1d
    80002e6c:	bc84b483          	ld	s1,-1080(s1) # 8001fa30 <bcache+0x82b0>
    80002e70:	0001d797          	auipc	a5,0x1d
    80002e74:	b7878793          	addi	a5,a5,-1160 # 8001f9e8 <bcache+0x8268>
    80002e78:	00f48863          	beq	s1,a5,80002e88 <bread+0x90>
    80002e7c:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    80002e7e:	40bc                	lw	a5,64(s1)
    80002e80:	cf81                	beqz	a5,80002e98 <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002e82:	64a4                	ld	s1,72(s1)
    80002e84:	fee49de3          	bne	s1,a4,80002e7e <bread+0x86>
  panic("bget: no buffers");
    80002e88:	00005517          	auipc	a0,0x5
    80002e8c:	66050513          	addi	a0,a0,1632 # 800084e8 <syscalls+0xc0>
    80002e90:	ffffd097          	auipc	ra,0xffffd
    80002e94:	6b6080e7          	jalr	1718(ra) # 80000546 <panic>
      b->dev = dev;
    80002e98:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    80002e9c:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    80002ea0:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    80002ea4:	4785                	li	a5,1
    80002ea6:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002ea8:	00015517          	auipc	a0,0x15
    80002eac:	8d850513          	addi	a0,a0,-1832 # 80017780 <bcache>
    80002eb0:	ffffe097          	auipc	ra,0xffffe
    80002eb4:	e04080e7          	jalr	-508(ra) # 80000cb4 <release>
      acquiresleep(&b->lock);
    80002eb8:	01048513          	addi	a0,s1,16
    80002ebc:	00001097          	auipc	ra,0x1
    80002ec0:	3fe080e7          	jalr	1022(ra) # 800042ba <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    80002ec4:	409c                	lw	a5,0(s1)
    80002ec6:	cb89                	beqz	a5,80002ed8 <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    80002ec8:	8526                	mv	a0,s1
    80002eca:	70a2                	ld	ra,40(sp)
    80002ecc:	7402                	ld	s0,32(sp)
    80002ece:	64e2                	ld	s1,24(sp)
    80002ed0:	6942                	ld	s2,16(sp)
    80002ed2:	69a2                	ld	s3,8(sp)
    80002ed4:	6145                	addi	sp,sp,48
    80002ed6:	8082                	ret
    virtio_disk_rw(b, 0);
    80002ed8:	4581                	li	a1,0
    80002eda:	8526                	mv	a0,s1
    80002edc:	00003097          	auipc	ra,0x3
    80002ee0:	f2c080e7          	jalr	-212(ra) # 80005e08 <virtio_disk_rw>
    b->valid = 1;
    80002ee4:	4785                	li	a5,1
    80002ee6:	c09c                	sw	a5,0(s1)
  return b;
    80002ee8:	b7c5                	j	80002ec8 <bread+0xd0>

0000000080002eea <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    80002eea:	1101                	addi	sp,sp,-32
    80002eec:	ec06                	sd	ra,24(sp)
    80002eee:	e822                	sd	s0,16(sp)
    80002ef0:	e426                	sd	s1,8(sp)
    80002ef2:	1000                	addi	s0,sp,32
    80002ef4:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002ef6:	0541                	addi	a0,a0,16
    80002ef8:	00001097          	auipc	ra,0x1
    80002efc:	45c080e7          	jalr	1116(ra) # 80004354 <holdingsleep>
    80002f00:	cd01                	beqz	a0,80002f18 <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    80002f02:	4585                	li	a1,1
    80002f04:	8526                	mv	a0,s1
    80002f06:	00003097          	auipc	ra,0x3
    80002f0a:	f02080e7          	jalr	-254(ra) # 80005e08 <virtio_disk_rw>
}
    80002f0e:	60e2                	ld	ra,24(sp)
    80002f10:	6442                	ld	s0,16(sp)
    80002f12:	64a2                	ld	s1,8(sp)
    80002f14:	6105                	addi	sp,sp,32
    80002f16:	8082                	ret
    panic("bwrite");
    80002f18:	00005517          	auipc	a0,0x5
    80002f1c:	5e850513          	addi	a0,a0,1512 # 80008500 <syscalls+0xd8>
    80002f20:	ffffd097          	auipc	ra,0xffffd
    80002f24:	626080e7          	jalr	1574(ra) # 80000546 <panic>

0000000080002f28 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    80002f28:	1101                	addi	sp,sp,-32
    80002f2a:	ec06                	sd	ra,24(sp)
    80002f2c:	e822                	sd	s0,16(sp)
    80002f2e:	e426                	sd	s1,8(sp)
    80002f30:	e04a                	sd	s2,0(sp)
    80002f32:	1000                	addi	s0,sp,32
    80002f34:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002f36:	01050913          	addi	s2,a0,16
    80002f3a:	854a                	mv	a0,s2
    80002f3c:	00001097          	auipc	ra,0x1
    80002f40:	418080e7          	jalr	1048(ra) # 80004354 <holdingsleep>
    80002f44:	c92d                	beqz	a0,80002fb6 <brelse+0x8e>
    panic("brelse");

  releasesleep(&b->lock);
    80002f46:	854a                	mv	a0,s2
    80002f48:	00001097          	auipc	ra,0x1
    80002f4c:	3c8080e7          	jalr	968(ra) # 80004310 <releasesleep>

  acquire(&bcache.lock);
    80002f50:	00015517          	auipc	a0,0x15
    80002f54:	83050513          	addi	a0,a0,-2000 # 80017780 <bcache>
    80002f58:	ffffe097          	auipc	ra,0xffffe
    80002f5c:	ca8080e7          	jalr	-856(ra) # 80000c00 <acquire>
  b->refcnt--;
    80002f60:	40bc                	lw	a5,64(s1)
    80002f62:	37fd                	addiw	a5,a5,-1
    80002f64:	0007871b          	sext.w	a4,a5
    80002f68:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    80002f6a:	eb05                	bnez	a4,80002f9a <brelse+0x72>
    // no one is waiting for it.
    b->next->prev = b->prev;
    80002f6c:	68bc                	ld	a5,80(s1)
    80002f6e:	64b8                	ld	a4,72(s1)
    80002f70:	e7b8                	sd	a4,72(a5)
    b->prev->next = b->next;
    80002f72:	64bc                	ld	a5,72(s1)
    80002f74:	68b8                	ld	a4,80(s1)
    80002f76:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    80002f78:	0001d797          	auipc	a5,0x1d
    80002f7c:	80878793          	addi	a5,a5,-2040 # 8001f780 <bcache+0x8000>
    80002f80:	2b87b703          	ld	a4,696(a5)
    80002f84:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    80002f86:	0001d717          	auipc	a4,0x1d
    80002f8a:	a6270713          	addi	a4,a4,-1438 # 8001f9e8 <bcache+0x8268>
    80002f8e:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    80002f90:	2b87b703          	ld	a4,696(a5)
    80002f94:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    80002f96:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    80002f9a:	00014517          	auipc	a0,0x14
    80002f9e:	7e650513          	addi	a0,a0,2022 # 80017780 <bcache>
    80002fa2:	ffffe097          	auipc	ra,0xffffe
    80002fa6:	d12080e7          	jalr	-750(ra) # 80000cb4 <release>
}
    80002faa:	60e2                	ld	ra,24(sp)
    80002fac:	6442                	ld	s0,16(sp)
    80002fae:	64a2                	ld	s1,8(sp)
    80002fb0:	6902                	ld	s2,0(sp)
    80002fb2:	6105                	addi	sp,sp,32
    80002fb4:	8082                	ret
    panic("brelse");
    80002fb6:	00005517          	auipc	a0,0x5
    80002fba:	55250513          	addi	a0,a0,1362 # 80008508 <syscalls+0xe0>
    80002fbe:	ffffd097          	auipc	ra,0xffffd
    80002fc2:	588080e7          	jalr	1416(ra) # 80000546 <panic>

0000000080002fc6 <bpin>:

void
bpin(struct buf *b) {
    80002fc6:	1101                	addi	sp,sp,-32
    80002fc8:	ec06                	sd	ra,24(sp)
    80002fca:	e822                	sd	s0,16(sp)
    80002fcc:	e426                	sd	s1,8(sp)
    80002fce:	1000                	addi	s0,sp,32
    80002fd0:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002fd2:	00014517          	auipc	a0,0x14
    80002fd6:	7ae50513          	addi	a0,a0,1966 # 80017780 <bcache>
    80002fda:	ffffe097          	auipc	ra,0xffffe
    80002fde:	c26080e7          	jalr	-986(ra) # 80000c00 <acquire>
  b->refcnt++;
    80002fe2:	40bc                	lw	a5,64(s1)
    80002fe4:	2785                	addiw	a5,a5,1
    80002fe6:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002fe8:	00014517          	auipc	a0,0x14
    80002fec:	79850513          	addi	a0,a0,1944 # 80017780 <bcache>
    80002ff0:	ffffe097          	auipc	ra,0xffffe
    80002ff4:	cc4080e7          	jalr	-828(ra) # 80000cb4 <release>
}
    80002ff8:	60e2                	ld	ra,24(sp)
    80002ffa:	6442                	ld	s0,16(sp)
    80002ffc:	64a2                	ld	s1,8(sp)
    80002ffe:	6105                	addi	sp,sp,32
    80003000:	8082                	ret

0000000080003002 <bunpin>:

void
bunpin(struct buf *b) {
    80003002:	1101                	addi	sp,sp,-32
    80003004:	ec06                	sd	ra,24(sp)
    80003006:	e822                	sd	s0,16(sp)
    80003008:	e426                	sd	s1,8(sp)
    8000300a:	1000                	addi	s0,sp,32
    8000300c:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    8000300e:	00014517          	auipc	a0,0x14
    80003012:	77250513          	addi	a0,a0,1906 # 80017780 <bcache>
    80003016:	ffffe097          	auipc	ra,0xffffe
    8000301a:	bea080e7          	jalr	-1046(ra) # 80000c00 <acquire>
  b->refcnt--;
    8000301e:	40bc                	lw	a5,64(s1)
    80003020:	37fd                	addiw	a5,a5,-1
    80003022:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80003024:	00014517          	auipc	a0,0x14
    80003028:	75c50513          	addi	a0,a0,1884 # 80017780 <bcache>
    8000302c:	ffffe097          	auipc	ra,0xffffe
    80003030:	c88080e7          	jalr	-888(ra) # 80000cb4 <release>
}
    80003034:	60e2                	ld	ra,24(sp)
    80003036:	6442                	ld	s0,16(sp)
    80003038:	64a2                	ld	s1,8(sp)
    8000303a:	6105                	addi	sp,sp,32
    8000303c:	8082                	ret

000000008000303e <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    8000303e:	1101                	addi	sp,sp,-32
    80003040:	ec06                	sd	ra,24(sp)
    80003042:	e822                	sd	s0,16(sp)
    80003044:	e426                	sd	s1,8(sp)
    80003046:	e04a                	sd	s2,0(sp)
    80003048:	1000                	addi	s0,sp,32
    8000304a:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    8000304c:	00d5d59b          	srliw	a1,a1,0xd
    80003050:	0001d797          	auipc	a5,0x1d
    80003054:	e0c7a783          	lw	a5,-500(a5) # 8001fe5c <sb+0x1c>
    80003058:	9dbd                	addw	a1,a1,a5
    8000305a:	00000097          	auipc	ra,0x0
    8000305e:	d9e080e7          	jalr	-610(ra) # 80002df8 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    80003062:	0074f713          	andi	a4,s1,7
    80003066:	4785                	li	a5,1
    80003068:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    8000306c:	14ce                	slli	s1,s1,0x33
    8000306e:	90d9                	srli	s1,s1,0x36
    80003070:	00950733          	add	a4,a0,s1
    80003074:	05874703          	lbu	a4,88(a4)
    80003078:	00e7f6b3          	and	a3,a5,a4
    8000307c:	c69d                	beqz	a3,800030aa <bfree+0x6c>
    8000307e:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    80003080:	94aa                	add	s1,s1,a0
    80003082:	fff7c793          	not	a5,a5
    80003086:	8f7d                	and	a4,a4,a5
    80003088:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    8000308c:	00001097          	auipc	ra,0x1
    80003090:	108080e7          	jalr	264(ra) # 80004194 <log_write>
  brelse(bp);
    80003094:	854a                	mv	a0,s2
    80003096:	00000097          	auipc	ra,0x0
    8000309a:	e92080e7          	jalr	-366(ra) # 80002f28 <brelse>
}
    8000309e:	60e2                	ld	ra,24(sp)
    800030a0:	6442                	ld	s0,16(sp)
    800030a2:	64a2                	ld	s1,8(sp)
    800030a4:	6902                	ld	s2,0(sp)
    800030a6:	6105                	addi	sp,sp,32
    800030a8:	8082                	ret
    panic("freeing free block");
    800030aa:	00005517          	auipc	a0,0x5
    800030ae:	46650513          	addi	a0,a0,1126 # 80008510 <syscalls+0xe8>
    800030b2:	ffffd097          	auipc	ra,0xffffd
    800030b6:	494080e7          	jalr	1172(ra) # 80000546 <panic>

00000000800030ba <balloc>:
{
    800030ba:	711d                	addi	sp,sp,-96
    800030bc:	ec86                	sd	ra,88(sp)
    800030be:	e8a2                	sd	s0,80(sp)
    800030c0:	e4a6                	sd	s1,72(sp)
    800030c2:	e0ca                	sd	s2,64(sp)
    800030c4:	fc4e                	sd	s3,56(sp)
    800030c6:	f852                	sd	s4,48(sp)
    800030c8:	f456                	sd	s5,40(sp)
    800030ca:	f05a                	sd	s6,32(sp)
    800030cc:	ec5e                	sd	s7,24(sp)
    800030ce:	e862                	sd	s8,16(sp)
    800030d0:	e466                	sd	s9,8(sp)
    800030d2:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    800030d4:	0001d797          	auipc	a5,0x1d
    800030d8:	d707a783          	lw	a5,-656(a5) # 8001fe44 <sb+0x4>
    800030dc:	cbc1                	beqz	a5,8000316c <balloc+0xb2>
    800030de:	8baa                	mv	s7,a0
    800030e0:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    800030e2:	0001db17          	auipc	s6,0x1d
    800030e6:	d5eb0b13          	addi	s6,s6,-674 # 8001fe40 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800030ea:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    800030ec:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800030ee:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    800030f0:	6c89                	lui	s9,0x2
    800030f2:	a831                	j	8000310e <balloc+0x54>
    brelse(bp);
    800030f4:	854a                	mv	a0,s2
    800030f6:	00000097          	auipc	ra,0x0
    800030fa:	e32080e7          	jalr	-462(ra) # 80002f28 <brelse>
  for(b = 0; b < sb.size; b += BPB){
    800030fe:	015c87bb          	addw	a5,s9,s5
    80003102:	00078a9b          	sext.w	s5,a5
    80003106:	004b2703          	lw	a4,4(s6)
    8000310a:	06eaf163          	bgeu	s5,a4,8000316c <balloc+0xb2>
    bp = bread(dev, BBLOCK(b, sb));
    8000310e:	41fad79b          	sraiw	a5,s5,0x1f
    80003112:	0137d79b          	srliw	a5,a5,0x13
    80003116:	015787bb          	addw	a5,a5,s5
    8000311a:	40d7d79b          	sraiw	a5,a5,0xd
    8000311e:	01cb2583          	lw	a1,28(s6)
    80003122:	9dbd                	addw	a1,a1,a5
    80003124:	855e                	mv	a0,s7
    80003126:	00000097          	auipc	ra,0x0
    8000312a:	cd2080e7          	jalr	-814(ra) # 80002df8 <bread>
    8000312e:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80003130:	004b2503          	lw	a0,4(s6)
    80003134:	000a849b          	sext.w	s1,s5
    80003138:	8762                	mv	a4,s8
    8000313a:	faa4fde3          	bgeu	s1,a0,800030f4 <balloc+0x3a>
      m = 1 << (bi % 8);
    8000313e:	00777693          	andi	a3,a4,7
    80003142:	00d996bb          	sllw	a3,s3,a3
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    80003146:	41f7579b          	sraiw	a5,a4,0x1f
    8000314a:	01d7d79b          	srliw	a5,a5,0x1d
    8000314e:	9fb9                	addw	a5,a5,a4
    80003150:	4037d79b          	sraiw	a5,a5,0x3
    80003154:	00f90633          	add	a2,s2,a5
    80003158:	05864603          	lbu	a2,88(a2)
    8000315c:	00c6f5b3          	and	a1,a3,a2
    80003160:	cd91                	beqz	a1,8000317c <balloc+0xc2>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80003162:	2705                	addiw	a4,a4,1
    80003164:	2485                	addiw	s1,s1,1
    80003166:	fd471ae3          	bne	a4,s4,8000313a <balloc+0x80>
    8000316a:	b769                	j	800030f4 <balloc+0x3a>
  panic("balloc: out of blocks");
    8000316c:	00005517          	auipc	a0,0x5
    80003170:	3bc50513          	addi	a0,a0,956 # 80008528 <syscalls+0x100>
    80003174:	ffffd097          	auipc	ra,0xffffd
    80003178:	3d2080e7          	jalr	978(ra) # 80000546 <panic>
        bp->data[bi/8] |= m;  // Mark block in use.
    8000317c:	97ca                	add	a5,a5,s2
    8000317e:	8e55                	or	a2,a2,a3
    80003180:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    80003184:	854a                	mv	a0,s2
    80003186:	00001097          	auipc	ra,0x1
    8000318a:	00e080e7          	jalr	14(ra) # 80004194 <log_write>
        brelse(bp);
    8000318e:	854a                	mv	a0,s2
    80003190:	00000097          	auipc	ra,0x0
    80003194:	d98080e7          	jalr	-616(ra) # 80002f28 <brelse>
  bp = bread(dev, bno);
    80003198:	85a6                	mv	a1,s1
    8000319a:	855e                	mv	a0,s7
    8000319c:	00000097          	auipc	ra,0x0
    800031a0:	c5c080e7          	jalr	-932(ra) # 80002df8 <bread>
    800031a4:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    800031a6:	40000613          	li	a2,1024
    800031aa:	4581                	li	a1,0
    800031ac:	05850513          	addi	a0,a0,88
    800031b0:	ffffe097          	auipc	ra,0xffffe
    800031b4:	b4c080e7          	jalr	-1204(ra) # 80000cfc <memset>
  log_write(bp);
    800031b8:	854a                	mv	a0,s2
    800031ba:	00001097          	auipc	ra,0x1
    800031be:	fda080e7          	jalr	-38(ra) # 80004194 <log_write>
  brelse(bp);
    800031c2:	854a                	mv	a0,s2
    800031c4:	00000097          	auipc	ra,0x0
    800031c8:	d64080e7          	jalr	-668(ra) # 80002f28 <brelse>
}
    800031cc:	8526                	mv	a0,s1
    800031ce:	60e6                	ld	ra,88(sp)
    800031d0:	6446                	ld	s0,80(sp)
    800031d2:	64a6                	ld	s1,72(sp)
    800031d4:	6906                	ld	s2,64(sp)
    800031d6:	79e2                	ld	s3,56(sp)
    800031d8:	7a42                	ld	s4,48(sp)
    800031da:	7aa2                	ld	s5,40(sp)
    800031dc:	7b02                	ld	s6,32(sp)
    800031de:	6be2                	ld	s7,24(sp)
    800031e0:	6c42                	ld	s8,16(sp)
    800031e2:	6ca2                	ld	s9,8(sp)
    800031e4:	6125                	addi	sp,sp,96
    800031e6:	8082                	ret

00000000800031e8 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
    800031e8:	7179                	addi	sp,sp,-48
    800031ea:	f406                	sd	ra,40(sp)
    800031ec:	f022                	sd	s0,32(sp)
    800031ee:	ec26                	sd	s1,24(sp)
    800031f0:	e84a                	sd	s2,16(sp)
    800031f2:	e44e                	sd	s3,8(sp)
    800031f4:	e052                	sd	s4,0(sp)
    800031f6:	1800                	addi	s0,sp,48
    800031f8:	892a                	mv	s2,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    800031fa:	47ad                	li	a5,11
    800031fc:	04b7fe63          	bgeu	a5,a1,80003258 <bmap+0x70>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
    80003200:	ff45849b          	addiw	s1,a1,-12
    80003204:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    80003208:	0ff00793          	li	a5,255
    8000320c:	0ae7e463          	bltu	a5,a4,800032b4 <bmap+0xcc>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
    80003210:	08052583          	lw	a1,128(a0)
    80003214:	c5b5                	beqz	a1,80003280 <bmap+0x98>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
    80003216:	00092503          	lw	a0,0(s2)
    8000321a:	00000097          	auipc	ra,0x0
    8000321e:	bde080e7          	jalr	-1058(ra) # 80002df8 <bread>
    80003222:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    80003224:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    80003228:	02049713          	slli	a4,s1,0x20
    8000322c:	01e75593          	srli	a1,a4,0x1e
    80003230:	00b784b3          	add	s1,a5,a1
    80003234:	0004a983          	lw	s3,0(s1)
    80003238:	04098e63          	beqz	s3,80003294 <bmap+0xac>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
    8000323c:	8552                	mv	a0,s4
    8000323e:	00000097          	auipc	ra,0x0
    80003242:	cea080e7          	jalr	-790(ra) # 80002f28 <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
    80003246:	854e                	mv	a0,s3
    80003248:	70a2                	ld	ra,40(sp)
    8000324a:	7402                	ld	s0,32(sp)
    8000324c:	64e2                	ld	s1,24(sp)
    8000324e:	6942                	ld	s2,16(sp)
    80003250:	69a2                	ld	s3,8(sp)
    80003252:	6a02                	ld	s4,0(sp)
    80003254:	6145                	addi	sp,sp,48
    80003256:	8082                	ret
    if((addr = ip->addrs[bn]) == 0)
    80003258:	02059793          	slli	a5,a1,0x20
    8000325c:	01e7d593          	srli	a1,a5,0x1e
    80003260:	00b504b3          	add	s1,a0,a1
    80003264:	0504a983          	lw	s3,80(s1)
    80003268:	fc099fe3          	bnez	s3,80003246 <bmap+0x5e>
      ip->addrs[bn] = addr = balloc(ip->dev);
    8000326c:	4108                	lw	a0,0(a0)
    8000326e:	00000097          	auipc	ra,0x0
    80003272:	e4c080e7          	jalr	-436(ra) # 800030ba <balloc>
    80003276:	0005099b          	sext.w	s3,a0
    8000327a:	0534a823          	sw	s3,80(s1)
    8000327e:	b7e1                	j	80003246 <bmap+0x5e>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    80003280:	4108                	lw	a0,0(a0)
    80003282:	00000097          	auipc	ra,0x0
    80003286:	e38080e7          	jalr	-456(ra) # 800030ba <balloc>
    8000328a:	0005059b          	sext.w	a1,a0
    8000328e:	08b92023          	sw	a1,128(s2)
    80003292:	b751                	j	80003216 <bmap+0x2e>
      a[bn] = addr = balloc(ip->dev);
    80003294:	00092503          	lw	a0,0(s2)
    80003298:	00000097          	auipc	ra,0x0
    8000329c:	e22080e7          	jalr	-478(ra) # 800030ba <balloc>
    800032a0:	0005099b          	sext.w	s3,a0
    800032a4:	0134a023          	sw	s3,0(s1)
      log_write(bp);
    800032a8:	8552                	mv	a0,s4
    800032aa:	00001097          	auipc	ra,0x1
    800032ae:	eea080e7          	jalr	-278(ra) # 80004194 <log_write>
    800032b2:	b769                	j	8000323c <bmap+0x54>
  panic("bmap: out of range");
    800032b4:	00005517          	auipc	a0,0x5
    800032b8:	28c50513          	addi	a0,a0,652 # 80008540 <syscalls+0x118>
    800032bc:	ffffd097          	auipc	ra,0xffffd
    800032c0:	28a080e7          	jalr	650(ra) # 80000546 <panic>

00000000800032c4 <iget>:
{
    800032c4:	7179                	addi	sp,sp,-48
    800032c6:	f406                	sd	ra,40(sp)
    800032c8:	f022                	sd	s0,32(sp)
    800032ca:	ec26                	sd	s1,24(sp)
    800032cc:	e84a                	sd	s2,16(sp)
    800032ce:	e44e                	sd	s3,8(sp)
    800032d0:	e052                	sd	s4,0(sp)
    800032d2:	1800                	addi	s0,sp,48
    800032d4:	89aa                	mv	s3,a0
    800032d6:	8a2e                	mv	s4,a1
  acquire(&icache.lock);
    800032d8:	0001d517          	auipc	a0,0x1d
    800032dc:	b8850513          	addi	a0,a0,-1144 # 8001fe60 <icache>
    800032e0:	ffffe097          	auipc	ra,0xffffe
    800032e4:	920080e7          	jalr	-1760(ra) # 80000c00 <acquire>
  empty = 0;
    800032e8:	4901                	li	s2,0
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
    800032ea:	0001d497          	auipc	s1,0x1d
    800032ee:	b8e48493          	addi	s1,s1,-1138 # 8001fe78 <icache+0x18>
    800032f2:	0001e697          	auipc	a3,0x1e
    800032f6:	61668693          	addi	a3,a3,1558 # 80021908 <log>
    800032fa:	a039                	j	80003308 <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    800032fc:	02090b63          	beqz	s2,80003332 <iget+0x6e>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
    80003300:	08848493          	addi	s1,s1,136
    80003304:	02d48a63          	beq	s1,a3,80003338 <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    80003308:	449c                	lw	a5,8(s1)
    8000330a:	fef059e3          	blez	a5,800032fc <iget+0x38>
    8000330e:	4098                	lw	a4,0(s1)
    80003310:	ff3716e3          	bne	a4,s3,800032fc <iget+0x38>
    80003314:	40d8                	lw	a4,4(s1)
    80003316:	ff4713e3          	bne	a4,s4,800032fc <iget+0x38>
      ip->ref++;
    8000331a:	2785                	addiw	a5,a5,1
    8000331c:	c49c                	sw	a5,8(s1)
      release(&icache.lock);
    8000331e:	0001d517          	auipc	a0,0x1d
    80003322:	b4250513          	addi	a0,a0,-1214 # 8001fe60 <icache>
    80003326:	ffffe097          	auipc	ra,0xffffe
    8000332a:	98e080e7          	jalr	-1650(ra) # 80000cb4 <release>
      return ip;
    8000332e:	8926                	mv	s2,s1
    80003330:	a03d                	j	8000335e <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80003332:	f7f9                	bnez	a5,80003300 <iget+0x3c>
    80003334:	8926                	mv	s2,s1
    80003336:	b7e9                	j	80003300 <iget+0x3c>
  if(empty == 0)
    80003338:	02090c63          	beqz	s2,80003370 <iget+0xac>
  ip->dev = dev;
    8000333c:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    80003340:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    80003344:	4785                	li	a5,1
    80003346:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    8000334a:	04092023          	sw	zero,64(s2)
  release(&icache.lock);
    8000334e:	0001d517          	auipc	a0,0x1d
    80003352:	b1250513          	addi	a0,a0,-1262 # 8001fe60 <icache>
    80003356:	ffffe097          	auipc	ra,0xffffe
    8000335a:	95e080e7          	jalr	-1698(ra) # 80000cb4 <release>
}
    8000335e:	854a                	mv	a0,s2
    80003360:	70a2                	ld	ra,40(sp)
    80003362:	7402                	ld	s0,32(sp)
    80003364:	64e2                	ld	s1,24(sp)
    80003366:	6942                	ld	s2,16(sp)
    80003368:	69a2                	ld	s3,8(sp)
    8000336a:	6a02                	ld	s4,0(sp)
    8000336c:	6145                	addi	sp,sp,48
    8000336e:	8082                	ret
    panic("iget: no inodes");
    80003370:	00005517          	auipc	a0,0x5
    80003374:	1e850513          	addi	a0,a0,488 # 80008558 <syscalls+0x130>
    80003378:	ffffd097          	auipc	ra,0xffffd
    8000337c:	1ce080e7          	jalr	462(ra) # 80000546 <panic>

0000000080003380 <fsinit>:
fsinit(int dev) {
    80003380:	7179                	addi	sp,sp,-48
    80003382:	f406                	sd	ra,40(sp)
    80003384:	f022                	sd	s0,32(sp)
    80003386:	ec26                	sd	s1,24(sp)
    80003388:	e84a                	sd	s2,16(sp)
    8000338a:	e44e                	sd	s3,8(sp)
    8000338c:	1800                	addi	s0,sp,48
    8000338e:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80003390:	4585                	li	a1,1
    80003392:	00000097          	auipc	ra,0x0
    80003396:	a66080e7          	jalr	-1434(ra) # 80002df8 <bread>
    8000339a:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    8000339c:	0001d997          	auipc	s3,0x1d
    800033a0:	aa498993          	addi	s3,s3,-1372 # 8001fe40 <sb>
    800033a4:	02000613          	li	a2,32
    800033a8:	05850593          	addi	a1,a0,88
    800033ac:	854e                	mv	a0,s3
    800033ae:	ffffe097          	auipc	ra,0xffffe
    800033b2:	9aa080e7          	jalr	-1622(ra) # 80000d58 <memmove>
  brelse(bp);
    800033b6:	8526                	mv	a0,s1
    800033b8:	00000097          	auipc	ra,0x0
    800033bc:	b70080e7          	jalr	-1168(ra) # 80002f28 <brelse>
  if(sb.magic != FSMAGIC)
    800033c0:	0009a703          	lw	a4,0(s3)
    800033c4:	102037b7          	lui	a5,0x10203
    800033c8:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    800033cc:	02f71263          	bne	a4,a5,800033f0 <fsinit+0x70>
  initlog(dev, &sb);
    800033d0:	0001d597          	auipc	a1,0x1d
    800033d4:	a7058593          	addi	a1,a1,-1424 # 8001fe40 <sb>
    800033d8:	854a                	mv	a0,s2
    800033da:	00001097          	auipc	ra,0x1
    800033de:	b42080e7          	jalr	-1214(ra) # 80003f1c <initlog>
}
    800033e2:	70a2                	ld	ra,40(sp)
    800033e4:	7402                	ld	s0,32(sp)
    800033e6:	64e2                	ld	s1,24(sp)
    800033e8:	6942                	ld	s2,16(sp)
    800033ea:	69a2                	ld	s3,8(sp)
    800033ec:	6145                	addi	sp,sp,48
    800033ee:	8082                	ret
    panic("invalid file system");
    800033f0:	00005517          	auipc	a0,0x5
    800033f4:	17850513          	addi	a0,a0,376 # 80008568 <syscalls+0x140>
    800033f8:	ffffd097          	auipc	ra,0xffffd
    800033fc:	14e080e7          	jalr	334(ra) # 80000546 <panic>

0000000080003400 <iinit>:
{
    80003400:	7179                	addi	sp,sp,-48
    80003402:	f406                	sd	ra,40(sp)
    80003404:	f022                	sd	s0,32(sp)
    80003406:	ec26                	sd	s1,24(sp)
    80003408:	e84a                	sd	s2,16(sp)
    8000340a:	e44e                	sd	s3,8(sp)
    8000340c:	1800                	addi	s0,sp,48
  initlock(&icache.lock, "icache");
    8000340e:	00005597          	auipc	a1,0x5
    80003412:	17258593          	addi	a1,a1,370 # 80008580 <syscalls+0x158>
    80003416:	0001d517          	auipc	a0,0x1d
    8000341a:	a4a50513          	addi	a0,a0,-1462 # 8001fe60 <icache>
    8000341e:	ffffd097          	auipc	ra,0xffffd
    80003422:	752080e7          	jalr	1874(ra) # 80000b70 <initlock>
  for(i = 0; i < NINODE; i++) {
    80003426:	0001d497          	auipc	s1,0x1d
    8000342a:	a6248493          	addi	s1,s1,-1438 # 8001fe88 <icache+0x28>
    8000342e:	0001e997          	auipc	s3,0x1e
    80003432:	4ea98993          	addi	s3,s3,1258 # 80021918 <log+0x10>
    initsleeplock(&icache.inode[i].lock, "inode");
    80003436:	00005917          	auipc	s2,0x5
    8000343a:	15290913          	addi	s2,s2,338 # 80008588 <syscalls+0x160>
    8000343e:	85ca                	mv	a1,s2
    80003440:	8526                	mv	a0,s1
    80003442:	00001097          	auipc	ra,0x1
    80003446:	e3e080e7          	jalr	-450(ra) # 80004280 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    8000344a:	08848493          	addi	s1,s1,136
    8000344e:	ff3498e3          	bne	s1,s3,8000343e <iinit+0x3e>
}
    80003452:	70a2                	ld	ra,40(sp)
    80003454:	7402                	ld	s0,32(sp)
    80003456:	64e2                	ld	s1,24(sp)
    80003458:	6942                	ld	s2,16(sp)
    8000345a:	69a2                	ld	s3,8(sp)
    8000345c:	6145                	addi	sp,sp,48
    8000345e:	8082                	ret

0000000080003460 <ialloc>:
{
    80003460:	715d                	addi	sp,sp,-80
    80003462:	e486                	sd	ra,72(sp)
    80003464:	e0a2                	sd	s0,64(sp)
    80003466:	fc26                	sd	s1,56(sp)
    80003468:	f84a                	sd	s2,48(sp)
    8000346a:	f44e                	sd	s3,40(sp)
    8000346c:	f052                	sd	s4,32(sp)
    8000346e:	ec56                	sd	s5,24(sp)
    80003470:	e85a                	sd	s6,16(sp)
    80003472:	e45e                	sd	s7,8(sp)
    80003474:	0880                	addi	s0,sp,80
  for(inum = 1; inum < sb.ninodes; inum++){
    80003476:	0001d717          	auipc	a4,0x1d
    8000347a:	9d672703          	lw	a4,-1578(a4) # 8001fe4c <sb+0xc>
    8000347e:	4785                	li	a5,1
    80003480:	04e7fa63          	bgeu	a5,a4,800034d4 <ialloc+0x74>
    80003484:	8aaa                	mv	s5,a0
    80003486:	8bae                	mv	s7,a1
    80003488:	4485                	li	s1,1
    bp = bread(dev, IBLOCK(inum, sb));
    8000348a:	0001da17          	auipc	s4,0x1d
    8000348e:	9b6a0a13          	addi	s4,s4,-1610 # 8001fe40 <sb>
    80003492:	00048b1b          	sext.w	s6,s1
    80003496:	0044d593          	srli	a1,s1,0x4
    8000349a:	018a2783          	lw	a5,24(s4)
    8000349e:	9dbd                	addw	a1,a1,a5
    800034a0:	8556                	mv	a0,s5
    800034a2:	00000097          	auipc	ra,0x0
    800034a6:	956080e7          	jalr	-1706(ra) # 80002df8 <bread>
    800034aa:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    800034ac:	05850993          	addi	s3,a0,88
    800034b0:	00f4f793          	andi	a5,s1,15
    800034b4:	079a                	slli	a5,a5,0x6
    800034b6:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    800034b8:	00099783          	lh	a5,0(s3)
    800034bc:	c785                	beqz	a5,800034e4 <ialloc+0x84>
    brelse(bp);
    800034be:	00000097          	auipc	ra,0x0
    800034c2:	a6a080e7          	jalr	-1430(ra) # 80002f28 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    800034c6:	0485                	addi	s1,s1,1
    800034c8:	00ca2703          	lw	a4,12(s4)
    800034cc:	0004879b          	sext.w	a5,s1
    800034d0:	fce7e1e3          	bltu	a5,a4,80003492 <ialloc+0x32>
  panic("ialloc: no inodes");
    800034d4:	00005517          	auipc	a0,0x5
    800034d8:	0bc50513          	addi	a0,a0,188 # 80008590 <syscalls+0x168>
    800034dc:	ffffd097          	auipc	ra,0xffffd
    800034e0:	06a080e7          	jalr	106(ra) # 80000546 <panic>
      memset(dip, 0, sizeof(*dip));
    800034e4:	04000613          	li	a2,64
    800034e8:	4581                	li	a1,0
    800034ea:	854e                	mv	a0,s3
    800034ec:	ffffe097          	auipc	ra,0xffffe
    800034f0:	810080e7          	jalr	-2032(ra) # 80000cfc <memset>
      dip->type = type;
    800034f4:	01799023          	sh	s7,0(s3)
      log_write(bp);   // mark it allocated on the disk
    800034f8:	854a                	mv	a0,s2
    800034fa:	00001097          	auipc	ra,0x1
    800034fe:	c9a080e7          	jalr	-870(ra) # 80004194 <log_write>
      brelse(bp);
    80003502:	854a                	mv	a0,s2
    80003504:	00000097          	auipc	ra,0x0
    80003508:	a24080e7          	jalr	-1500(ra) # 80002f28 <brelse>
      return iget(dev, inum);
    8000350c:	85da                	mv	a1,s6
    8000350e:	8556                	mv	a0,s5
    80003510:	00000097          	auipc	ra,0x0
    80003514:	db4080e7          	jalr	-588(ra) # 800032c4 <iget>
}
    80003518:	60a6                	ld	ra,72(sp)
    8000351a:	6406                	ld	s0,64(sp)
    8000351c:	74e2                	ld	s1,56(sp)
    8000351e:	7942                	ld	s2,48(sp)
    80003520:	79a2                	ld	s3,40(sp)
    80003522:	7a02                	ld	s4,32(sp)
    80003524:	6ae2                	ld	s5,24(sp)
    80003526:	6b42                	ld	s6,16(sp)
    80003528:	6ba2                	ld	s7,8(sp)
    8000352a:	6161                	addi	sp,sp,80
    8000352c:	8082                	ret

000000008000352e <iupdate>:
{
    8000352e:	1101                	addi	sp,sp,-32
    80003530:	ec06                	sd	ra,24(sp)
    80003532:	e822                	sd	s0,16(sp)
    80003534:	e426                	sd	s1,8(sp)
    80003536:	e04a                	sd	s2,0(sp)
    80003538:	1000                	addi	s0,sp,32
    8000353a:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    8000353c:	415c                	lw	a5,4(a0)
    8000353e:	0047d79b          	srliw	a5,a5,0x4
    80003542:	0001d597          	auipc	a1,0x1d
    80003546:	9165a583          	lw	a1,-1770(a1) # 8001fe58 <sb+0x18>
    8000354a:	9dbd                	addw	a1,a1,a5
    8000354c:	4108                	lw	a0,0(a0)
    8000354e:	00000097          	auipc	ra,0x0
    80003552:	8aa080e7          	jalr	-1878(ra) # 80002df8 <bread>
    80003556:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80003558:	05850793          	addi	a5,a0,88
    8000355c:	40d8                	lw	a4,4(s1)
    8000355e:	8b3d                	andi	a4,a4,15
    80003560:	071a                	slli	a4,a4,0x6
    80003562:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    80003564:	04449703          	lh	a4,68(s1)
    80003568:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    8000356c:	04649703          	lh	a4,70(s1)
    80003570:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    80003574:	04849703          	lh	a4,72(s1)
    80003578:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    8000357c:	04a49703          	lh	a4,74(s1)
    80003580:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    80003584:	44f8                	lw	a4,76(s1)
    80003586:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80003588:	03400613          	li	a2,52
    8000358c:	05048593          	addi	a1,s1,80
    80003590:	00c78513          	addi	a0,a5,12
    80003594:	ffffd097          	auipc	ra,0xffffd
    80003598:	7c4080e7          	jalr	1988(ra) # 80000d58 <memmove>
  log_write(bp);
    8000359c:	854a                	mv	a0,s2
    8000359e:	00001097          	auipc	ra,0x1
    800035a2:	bf6080e7          	jalr	-1034(ra) # 80004194 <log_write>
  brelse(bp);
    800035a6:	854a                	mv	a0,s2
    800035a8:	00000097          	auipc	ra,0x0
    800035ac:	980080e7          	jalr	-1664(ra) # 80002f28 <brelse>
}
    800035b0:	60e2                	ld	ra,24(sp)
    800035b2:	6442                	ld	s0,16(sp)
    800035b4:	64a2                	ld	s1,8(sp)
    800035b6:	6902                	ld	s2,0(sp)
    800035b8:	6105                	addi	sp,sp,32
    800035ba:	8082                	ret

00000000800035bc <idup>:
{
    800035bc:	1101                	addi	sp,sp,-32
    800035be:	ec06                	sd	ra,24(sp)
    800035c0:	e822                	sd	s0,16(sp)
    800035c2:	e426                	sd	s1,8(sp)
    800035c4:	1000                	addi	s0,sp,32
    800035c6:	84aa                	mv	s1,a0
  acquire(&icache.lock);
    800035c8:	0001d517          	auipc	a0,0x1d
    800035cc:	89850513          	addi	a0,a0,-1896 # 8001fe60 <icache>
    800035d0:	ffffd097          	auipc	ra,0xffffd
    800035d4:	630080e7          	jalr	1584(ra) # 80000c00 <acquire>
  ip->ref++;
    800035d8:	449c                	lw	a5,8(s1)
    800035da:	2785                	addiw	a5,a5,1
    800035dc:	c49c                	sw	a5,8(s1)
  release(&icache.lock);
    800035de:	0001d517          	auipc	a0,0x1d
    800035e2:	88250513          	addi	a0,a0,-1918 # 8001fe60 <icache>
    800035e6:	ffffd097          	auipc	ra,0xffffd
    800035ea:	6ce080e7          	jalr	1742(ra) # 80000cb4 <release>
}
    800035ee:	8526                	mv	a0,s1
    800035f0:	60e2                	ld	ra,24(sp)
    800035f2:	6442                	ld	s0,16(sp)
    800035f4:	64a2                	ld	s1,8(sp)
    800035f6:	6105                	addi	sp,sp,32
    800035f8:	8082                	ret

00000000800035fa <ilock>:
{
    800035fa:	1101                	addi	sp,sp,-32
    800035fc:	ec06                	sd	ra,24(sp)
    800035fe:	e822                	sd	s0,16(sp)
    80003600:	e426                	sd	s1,8(sp)
    80003602:	e04a                	sd	s2,0(sp)
    80003604:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80003606:	c115                	beqz	a0,8000362a <ilock+0x30>
    80003608:	84aa                	mv	s1,a0
    8000360a:	451c                	lw	a5,8(a0)
    8000360c:	00f05f63          	blez	a5,8000362a <ilock+0x30>
  acquiresleep(&ip->lock);
    80003610:	0541                	addi	a0,a0,16
    80003612:	00001097          	auipc	ra,0x1
    80003616:	ca8080e7          	jalr	-856(ra) # 800042ba <acquiresleep>
  if(ip->valid == 0){
    8000361a:	40bc                	lw	a5,64(s1)
    8000361c:	cf99                	beqz	a5,8000363a <ilock+0x40>
}
    8000361e:	60e2                	ld	ra,24(sp)
    80003620:	6442                	ld	s0,16(sp)
    80003622:	64a2                	ld	s1,8(sp)
    80003624:	6902                	ld	s2,0(sp)
    80003626:	6105                	addi	sp,sp,32
    80003628:	8082                	ret
    panic("ilock");
    8000362a:	00005517          	auipc	a0,0x5
    8000362e:	f7e50513          	addi	a0,a0,-130 # 800085a8 <syscalls+0x180>
    80003632:	ffffd097          	auipc	ra,0xffffd
    80003636:	f14080e7          	jalr	-236(ra) # 80000546 <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    8000363a:	40dc                	lw	a5,4(s1)
    8000363c:	0047d79b          	srliw	a5,a5,0x4
    80003640:	0001d597          	auipc	a1,0x1d
    80003644:	8185a583          	lw	a1,-2024(a1) # 8001fe58 <sb+0x18>
    80003648:	9dbd                	addw	a1,a1,a5
    8000364a:	4088                	lw	a0,0(s1)
    8000364c:	fffff097          	auipc	ra,0xfffff
    80003650:	7ac080e7          	jalr	1964(ra) # 80002df8 <bread>
    80003654:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80003656:	05850593          	addi	a1,a0,88
    8000365a:	40dc                	lw	a5,4(s1)
    8000365c:	8bbd                	andi	a5,a5,15
    8000365e:	079a                	slli	a5,a5,0x6
    80003660:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80003662:	00059783          	lh	a5,0(a1)
    80003666:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    8000366a:	00259783          	lh	a5,2(a1)
    8000366e:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80003672:	00459783          	lh	a5,4(a1)
    80003676:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    8000367a:	00659783          	lh	a5,6(a1)
    8000367e:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80003682:	459c                	lw	a5,8(a1)
    80003684:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80003686:	03400613          	li	a2,52
    8000368a:	05b1                	addi	a1,a1,12
    8000368c:	05048513          	addi	a0,s1,80
    80003690:	ffffd097          	auipc	ra,0xffffd
    80003694:	6c8080e7          	jalr	1736(ra) # 80000d58 <memmove>
    brelse(bp);
    80003698:	854a                	mv	a0,s2
    8000369a:	00000097          	auipc	ra,0x0
    8000369e:	88e080e7          	jalr	-1906(ra) # 80002f28 <brelse>
    ip->valid = 1;
    800036a2:	4785                	li	a5,1
    800036a4:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    800036a6:	04449783          	lh	a5,68(s1)
    800036aa:	fbb5                	bnez	a5,8000361e <ilock+0x24>
      panic("ilock: no type");
    800036ac:	00005517          	auipc	a0,0x5
    800036b0:	f0450513          	addi	a0,a0,-252 # 800085b0 <syscalls+0x188>
    800036b4:	ffffd097          	auipc	ra,0xffffd
    800036b8:	e92080e7          	jalr	-366(ra) # 80000546 <panic>

00000000800036bc <iunlock>:
{
    800036bc:	1101                	addi	sp,sp,-32
    800036be:	ec06                	sd	ra,24(sp)
    800036c0:	e822                	sd	s0,16(sp)
    800036c2:	e426                	sd	s1,8(sp)
    800036c4:	e04a                	sd	s2,0(sp)
    800036c6:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    800036c8:	c905                	beqz	a0,800036f8 <iunlock+0x3c>
    800036ca:	84aa                	mv	s1,a0
    800036cc:	01050913          	addi	s2,a0,16
    800036d0:	854a                	mv	a0,s2
    800036d2:	00001097          	auipc	ra,0x1
    800036d6:	c82080e7          	jalr	-894(ra) # 80004354 <holdingsleep>
    800036da:	cd19                	beqz	a0,800036f8 <iunlock+0x3c>
    800036dc:	449c                	lw	a5,8(s1)
    800036de:	00f05d63          	blez	a5,800036f8 <iunlock+0x3c>
  releasesleep(&ip->lock);
    800036e2:	854a                	mv	a0,s2
    800036e4:	00001097          	auipc	ra,0x1
    800036e8:	c2c080e7          	jalr	-980(ra) # 80004310 <releasesleep>
}
    800036ec:	60e2                	ld	ra,24(sp)
    800036ee:	6442                	ld	s0,16(sp)
    800036f0:	64a2                	ld	s1,8(sp)
    800036f2:	6902                	ld	s2,0(sp)
    800036f4:	6105                	addi	sp,sp,32
    800036f6:	8082                	ret
    panic("iunlock");
    800036f8:	00005517          	auipc	a0,0x5
    800036fc:	ec850513          	addi	a0,a0,-312 # 800085c0 <syscalls+0x198>
    80003700:	ffffd097          	auipc	ra,0xffffd
    80003704:	e46080e7          	jalr	-442(ra) # 80000546 <panic>

0000000080003708 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80003708:	7179                	addi	sp,sp,-48
    8000370a:	f406                	sd	ra,40(sp)
    8000370c:	f022                	sd	s0,32(sp)
    8000370e:	ec26                	sd	s1,24(sp)
    80003710:	e84a                	sd	s2,16(sp)
    80003712:	e44e                	sd	s3,8(sp)
    80003714:	e052                	sd	s4,0(sp)
    80003716:	1800                	addi	s0,sp,48
    80003718:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    8000371a:	05050493          	addi	s1,a0,80
    8000371e:	08050913          	addi	s2,a0,128
    80003722:	a021                	j	8000372a <itrunc+0x22>
    80003724:	0491                	addi	s1,s1,4
    80003726:	01248d63          	beq	s1,s2,80003740 <itrunc+0x38>
    if(ip->addrs[i]){
    8000372a:	408c                	lw	a1,0(s1)
    8000372c:	dde5                	beqz	a1,80003724 <itrunc+0x1c>
      bfree(ip->dev, ip->addrs[i]);
    8000372e:	0009a503          	lw	a0,0(s3)
    80003732:	00000097          	auipc	ra,0x0
    80003736:	90c080e7          	jalr	-1780(ra) # 8000303e <bfree>
      ip->addrs[i] = 0;
    8000373a:	0004a023          	sw	zero,0(s1)
    8000373e:	b7dd                	j	80003724 <itrunc+0x1c>
    }
  }

  if(ip->addrs[NDIRECT]){
    80003740:	0809a583          	lw	a1,128(s3)
    80003744:	e185                	bnez	a1,80003764 <itrunc+0x5c>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80003746:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    8000374a:	854e                	mv	a0,s3
    8000374c:	00000097          	auipc	ra,0x0
    80003750:	de2080e7          	jalr	-542(ra) # 8000352e <iupdate>
}
    80003754:	70a2                	ld	ra,40(sp)
    80003756:	7402                	ld	s0,32(sp)
    80003758:	64e2                	ld	s1,24(sp)
    8000375a:	6942                	ld	s2,16(sp)
    8000375c:	69a2                	ld	s3,8(sp)
    8000375e:	6a02                	ld	s4,0(sp)
    80003760:	6145                	addi	sp,sp,48
    80003762:	8082                	ret
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80003764:	0009a503          	lw	a0,0(s3)
    80003768:	fffff097          	auipc	ra,0xfffff
    8000376c:	690080e7          	jalr	1680(ra) # 80002df8 <bread>
    80003770:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80003772:	05850493          	addi	s1,a0,88
    80003776:	45850913          	addi	s2,a0,1112
    8000377a:	a021                	j	80003782 <itrunc+0x7a>
    8000377c:	0491                	addi	s1,s1,4
    8000377e:	01248b63          	beq	s1,s2,80003794 <itrunc+0x8c>
      if(a[j])
    80003782:	408c                	lw	a1,0(s1)
    80003784:	dde5                	beqz	a1,8000377c <itrunc+0x74>
        bfree(ip->dev, a[j]);
    80003786:	0009a503          	lw	a0,0(s3)
    8000378a:	00000097          	auipc	ra,0x0
    8000378e:	8b4080e7          	jalr	-1868(ra) # 8000303e <bfree>
    80003792:	b7ed                	j	8000377c <itrunc+0x74>
    brelse(bp);
    80003794:	8552                	mv	a0,s4
    80003796:	fffff097          	auipc	ra,0xfffff
    8000379a:	792080e7          	jalr	1938(ra) # 80002f28 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    8000379e:	0809a583          	lw	a1,128(s3)
    800037a2:	0009a503          	lw	a0,0(s3)
    800037a6:	00000097          	auipc	ra,0x0
    800037aa:	898080e7          	jalr	-1896(ra) # 8000303e <bfree>
    ip->addrs[NDIRECT] = 0;
    800037ae:	0809a023          	sw	zero,128(s3)
    800037b2:	bf51                	j	80003746 <itrunc+0x3e>

00000000800037b4 <iput>:
{
    800037b4:	1101                	addi	sp,sp,-32
    800037b6:	ec06                	sd	ra,24(sp)
    800037b8:	e822                	sd	s0,16(sp)
    800037ba:	e426                	sd	s1,8(sp)
    800037bc:	e04a                	sd	s2,0(sp)
    800037be:	1000                	addi	s0,sp,32
    800037c0:	84aa                	mv	s1,a0
  acquire(&icache.lock);
    800037c2:	0001c517          	auipc	a0,0x1c
    800037c6:	69e50513          	addi	a0,a0,1694 # 8001fe60 <icache>
    800037ca:	ffffd097          	auipc	ra,0xffffd
    800037ce:	436080e7          	jalr	1078(ra) # 80000c00 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    800037d2:	4498                	lw	a4,8(s1)
    800037d4:	4785                	li	a5,1
    800037d6:	02f70363          	beq	a4,a5,800037fc <iput+0x48>
  ip->ref--;
    800037da:	449c                	lw	a5,8(s1)
    800037dc:	37fd                	addiw	a5,a5,-1
    800037de:	c49c                	sw	a5,8(s1)
  release(&icache.lock);
    800037e0:	0001c517          	auipc	a0,0x1c
    800037e4:	68050513          	addi	a0,a0,1664 # 8001fe60 <icache>
    800037e8:	ffffd097          	auipc	ra,0xffffd
    800037ec:	4cc080e7          	jalr	1228(ra) # 80000cb4 <release>
}
    800037f0:	60e2                	ld	ra,24(sp)
    800037f2:	6442                	ld	s0,16(sp)
    800037f4:	64a2                	ld	s1,8(sp)
    800037f6:	6902                	ld	s2,0(sp)
    800037f8:	6105                	addi	sp,sp,32
    800037fa:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    800037fc:	40bc                	lw	a5,64(s1)
    800037fe:	dff1                	beqz	a5,800037da <iput+0x26>
    80003800:	04a49783          	lh	a5,74(s1)
    80003804:	fbf9                	bnez	a5,800037da <iput+0x26>
    acquiresleep(&ip->lock);
    80003806:	01048913          	addi	s2,s1,16
    8000380a:	854a                	mv	a0,s2
    8000380c:	00001097          	auipc	ra,0x1
    80003810:	aae080e7          	jalr	-1362(ra) # 800042ba <acquiresleep>
    release(&icache.lock);
    80003814:	0001c517          	auipc	a0,0x1c
    80003818:	64c50513          	addi	a0,a0,1612 # 8001fe60 <icache>
    8000381c:	ffffd097          	auipc	ra,0xffffd
    80003820:	498080e7          	jalr	1176(ra) # 80000cb4 <release>
    itrunc(ip);
    80003824:	8526                	mv	a0,s1
    80003826:	00000097          	auipc	ra,0x0
    8000382a:	ee2080e7          	jalr	-286(ra) # 80003708 <itrunc>
    ip->type = 0;
    8000382e:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80003832:	8526                	mv	a0,s1
    80003834:	00000097          	auipc	ra,0x0
    80003838:	cfa080e7          	jalr	-774(ra) # 8000352e <iupdate>
    ip->valid = 0;
    8000383c:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80003840:	854a                	mv	a0,s2
    80003842:	00001097          	auipc	ra,0x1
    80003846:	ace080e7          	jalr	-1330(ra) # 80004310 <releasesleep>
    acquire(&icache.lock);
    8000384a:	0001c517          	auipc	a0,0x1c
    8000384e:	61650513          	addi	a0,a0,1558 # 8001fe60 <icache>
    80003852:	ffffd097          	auipc	ra,0xffffd
    80003856:	3ae080e7          	jalr	942(ra) # 80000c00 <acquire>
    8000385a:	b741                	j	800037da <iput+0x26>

000000008000385c <iunlockput>:
{
    8000385c:	1101                	addi	sp,sp,-32
    8000385e:	ec06                	sd	ra,24(sp)
    80003860:	e822                	sd	s0,16(sp)
    80003862:	e426                	sd	s1,8(sp)
    80003864:	1000                	addi	s0,sp,32
    80003866:	84aa                	mv	s1,a0
  iunlock(ip);
    80003868:	00000097          	auipc	ra,0x0
    8000386c:	e54080e7          	jalr	-428(ra) # 800036bc <iunlock>
  iput(ip);
    80003870:	8526                	mv	a0,s1
    80003872:	00000097          	auipc	ra,0x0
    80003876:	f42080e7          	jalr	-190(ra) # 800037b4 <iput>
}
    8000387a:	60e2                	ld	ra,24(sp)
    8000387c:	6442                	ld	s0,16(sp)
    8000387e:	64a2                	ld	s1,8(sp)
    80003880:	6105                	addi	sp,sp,32
    80003882:	8082                	ret

0000000080003884 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80003884:	1141                	addi	sp,sp,-16
    80003886:	e422                	sd	s0,8(sp)
    80003888:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    8000388a:	411c                	lw	a5,0(a0)
    8000388c:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    8000388e:	415c                	lw	a5,4(a0)
    80003890:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80003892:	04451783          	lh	a5,68(a0)
    80003896:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    8000389a:	04a51783          	lh	a5,74(a0)
    8000389e:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    800038a2:	04c56783          	lwu	a5,76(a0)
    800038a6:	e99c                	sd	a5,16(a1)
}
    800038a8:	6422                	ld	s0,8(sp)
    800038aa:	0141                	addi	sp,sp,16
    800038ac:	8082                	ret

00000000800038ae <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    800038ae:	457c                	lw	a5,76(a0)
    800038b0:	0ed7e863          	bltu	a5,a3,800039a0 <readi+0xf2>
{
    800038b4:	7159                	addi	sp,sp,-112
    800038b6:	f486                	sd	ra,104(sp)
    800038b8:	f0a2                	sd	s0,96(sp)
    800038ba:	eca6                	sd	s1,88(sp)
    800038bc:	e8ca                	sd	s2,80(sp)
    800038be:	e4ce                	sd	s3,72(sp)
    800038c0:	e0d2                	sd	s4,64(sp)
    800038c2:	fc56                	sd	s5,56(sp)
    800038c4:	f85a                	sd	s6,48(sp)
    800038c6:	f45e                	sd	s7,40(sp)
    800038c8:	f062                	sd	s8,32(sp)
    800038ca:	ec66                	sd	s9,24(sp)
    800038cc:	e86a                	sd	s10,16(sp)
    800038ce:	e46e                	sd	s11,8(sp)
    800038d0:	1880                	addi	s0,sp,112
    800038d2:	8baa                	mv	s7,a0
    800038d4:	8c2e                	mv	s8,a1
    800038d6:	8ab2                	mv	s5,a2
    800038d8:	84b6                	mv	s1,a3
    800038da:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    800038dc:	9f35                	addw	a4,a4,a3
    return 0;
    800038de:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    800038e0:	08d76f63          	bltu	a4,a3,8000397e <readi+0xd0>
  if(off + n > ip->size)
    800038e4:	00e7f463          	bgeu	a5,a4,800038ec <readi+0x3e>
    n = ip->size - off;
    800038e8:	40d78b3b          	subw	s6,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    800038ec:	0a0b0863          	beqz	s6,8000399c <readi+0xee>
    800038f0:	4981                	li	s3,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    800038f2:	40000d13          	li	s10,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    800038f6:	5cfd                	li	s9,-1
    800038f8:	a82d                	j	80003932 <readi+0x84>
    800038fa:	020a1d93          	slli	s11,s4,0x20
    800038fe:	020ddd93          	srli	s11,s11,0x20
    80003902:	05890613          	addi	a2,s2,88
    80003906:	86ee                	mv	a3,s11
    80003908:	963a                	add	a2,a2,a4
    8000390a:	85d6                	mv	a1,s5
    8000390c:	8562                	mv	a0,s8
    8000390e:	fffff097          	auipc	ra,0xfffff
    80003912:	b2c080e7          	jalr	-1236(ra) # 8000243a <either_copyout>
    80003916:	05950d63          	beq	a0,s9,80003970 <readi+0xc2>
      brelse(bp);
      break;
    }
    brelse(bp);
    8000391a:	854a                	mv	a0,s2
    8000391c:	fffff097          	auipc	ra,0xfffff
    80003920:	60c080e7          	jalr	1548(ra) # 80002f28 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003924:	013a09bb          	addw	s3,s4,s3
    80003928:	009a04bb          	addw	s1,s4,s1
    8000392c:	9aee                	add	s5,s5,s11
    8000392e:	0569f663          	bgeu	s3,s6,8000397a <readi+0xcc>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    80003932:	000ba903          	lw	s2,0(s7)
    80003936:	00a4d59b          	srliw	a1,s1,0xa
    8000393a:	855e                	mv	a0,s7
    8000393c:	00000097          	auipc	ra,0x0
    80003940:	8ac080e7          	jalr	-1876(ra) # 800031e8 <bmap>
    80003944:	0005059b          	sext.w	a1,a0
    80003948:	854a                	mv	a0,s2
    8000394a:	fffff097          	auipc	ra,0xfffff
    8000394e:	4ae080e7          	jalr	1198(ra) # 80002df8 <bread>
    80003952:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003954:	3ff4f713          	andi	a4,s1,1023
    80003958:	40ed07bb          	subw	a5,s10,a4
    8000395c:	413b06bb          	subw	a3,s6,s3
    80003960:	8a3e                	mv	s4,a5
    80003962:	2781                	sext.w	a5,a5
    80003964:	0006861b          	sext.w	a2,a3
    80003968:	f8f679e3          	bgeu	a2,a5,800038fa <readi+0x4c>
    8000396c:	8a36                	mv	s4,a3
    8000396e:	b771                	j	800038fa <readi+0x4c>
      brelse(bp);
    80003970:	854a                	mv	a0,s2
    80003972:	fffff097          	auipc	ra,0xfffff
    80003976:	5b6080e7          	jalr	1462(ra) # 80002f28 <brelse>
  }
  return tot;
    8000397a:	0009851b          	sext.w	a0,s3
}
    8000397e:	70a6                	ld	ra,104(sp)
    80003980:	7406                	ld	s0,96(sp)
    80003982:	64e6                	ld	s1,88(sp)
    80003984:	6946                	ld	s2,80(sp)
    80003986:	69a6                	ld	s3,72(sp)
    80003988:	6a06                	ld	s4,64(sp)
    8000398a:	7ae2                	ld	s5,56(sp)
    8000398c:	7b42                	ld	s6,48(sp)
    8000398e:	7ba2                	ld	s7,40(sp)
    80003990:	7c02                	ld	s8,32(sp)
    80003992:	6ce2                	ld	s9,24(sp)
    80003994:	6d42                	ld	s10,16(sp)
    80003996:	6da2                	ld	s11,8(sp)
    80003998:	6165                	addi	sp,sp,112
    8000399a:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    8000399c:	89da                	mv	s3,s6
    8000399e:	bff1                	j	8000397a <readi+0xcc>
    return 0;
    800039a0:	4501                	li	a0,0
}
    800039a2:	8082                	ret

00000000800039a4 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    800039a4:	457c                	lw	a5,76(a0)
    800039a6:	10d7e663          	bltu	a5,a3,80003ab2 <writei+0x10e>
{
    800039aa:	7159                	addi	sp,sp,-112
    800039ac:	f486                	sd	ra,104(sp)
    800039ae:	f0a2                	sd	s0,96(sp)
    800039b0:	eca6                	sd	s1,88(sp)
    800039b2:	e8ca                	sd	s2,80(sp)
    800039b4:	e4ce                	sd	s3,72(sp)
    800039b6:	e0d2                	sd	s4,64(sp)
    800039b8:	fc56                	sd	s5,56(sp)
    800039ba:	f85a                	sd	s6,48(sp)
    800039bc:	f45e                	sd	s7,40(sp)
    800039be:	f062                	sd	s8,32(sp)
    800039c0:	ec66                	sd	s9,24(sp)
    800039c2:	e86a                	sd	s10,16(sp)
    800039c4:	e46e                	sd	s11,8(sp)
    800039c6:	1880                	addi	s0,sp,112
    800039c8:	8baa                	mv	s7,a0
    800039ca:	8c2e                	mv	s8,a1
    800039cc:	8ab2                	mv	s5,a2
    800039ce:	8936                	mv	s2,a3
    800039d0:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    800039d2:	00e687bb          	addw	a5,a3,a4
    800039d6:	0ed7e063          	bltu	a5,a3,80003ab6 <writei+0x112>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    800039da:	00043737          	lui	a4,0x43
    800039de:	0cf76e63          	bltu	a4,a5,80003aba <writei+0x116>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    800039e2:	0a0b0763          	beqz	s6,80003a90 <writei+0xec>
    800039e6:	4a01                	li	s4,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    800039e8:	40000d13          	li	s10,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    800039ec:	5cfd                	li	s9,-1
    800039ee:	a091                	j	80003a32 <writei+0x8e>
    800039f0:	02099d93          	slli	s11,s3,0x20
    800039f4:	020ddd93          	srli	s11,s11,0x20
    800039f8:	05848513          	addi	a0,s1,88
    800039fc:	86ee                	mv	a3,s11
    800039fe:	8656                	mv	a2,s5
    80003a00:	85e2                	mv	a1,s8
    80003a02:	953a                	add	a0,a0,a4
    80003a04:	fffff097          	auipc	ra,0xfffff
    80003a08:	a8c080e7          	jalr	-1396(ra) # 80002490 <either_copyin>
    80003a0c:	07950263          	beq	a0,s9,80003a70 <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    80003a10:	8526                	mv	a0,s1
    80003a12:	00000097          	auipc	ra,0x0
    80003a16:	782080e7          	jalr	1922(ra) # 80004194 <log_write>
    brelse(bp);
    80003a1a:	8526                	mv	a0,s1
    80003a1c:	fffff097          	auipc	ra,0xfffff
    80003a20:	50c080e7          	jalr	1292(ra) # 80002f28 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003a24:	01498a3b          	addw	s4,s3,s4
    80003a28:	0129893b          	addw	s2,s3,s2
    80003a2c:	9aee                	add	s5,s5,s11
    80003a2e:	056a7663          	bgeu	s4,s6,80003a7a <writei+0xd6>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    80003a32:	000ba483          	lw	s1,0(s7)
    80003a36:	00a9559b          	srliw	a1,s2,0xa
    80003a3a:	855e                	mv	a0,s7
    80003a3c:	fffff097          	auipc	ra,0xfffff
    80003a40:	7ac080e7          	jalr	1964(ra) # 800031e8 <bmap>
    80003a44:	0005059b          	sext.w	a1,a0
    80003a48:	8526                	mv	a0,s1
    80003a4a:	fffff097          	auipc	ra,0xfffff
    80003a4e:	3ae080e7          	jalr	942(ra) # 80002df8 <bread>
    80003a52:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003a54:	3ff97713          	andi	a4,s2,1023
    80003a58:	40ed07bb          	subw	a5,s10,a4
    80003a5c:	414b06bb          	subw	a3,s6,s4
    80003a60:	89be                	mv	s3,a5
    80003a62:	2781                	sext.w	a5,a5
    80003a64:	0006861b          	sext.w	a2,a3
    80003a68:	f8f674e3          	bgeu	a2,a5,800039f0 <writei+0x4c>
    80003a6c:	89b6                	mv	s3,a3
    80003a6e:	b749                	j	800039f0 <writei+0x4c>
      brelse(bp);
    80003a70:	8526                	mv	a0,s1
    80003a72:	fffff097          	auipc	ra,0xfffff
    80003a76:	4b6080e7          	jalr	1206(ra) # 80002f28 <brelse>
  }

  if(n > 0){
    if(off > ip->size)
    80003a7a:	04cba783          	lw	a5,76(s7)
    80003a7e:	0127f463          	bgeu	a5,s2,80003a86 <writei+0xe2>
      ip->size = off;
    80003a82:	052ba623          	sw	s2,76(s7)
    // write the i-node back to disk even if the size didn't change
    // because the loop above might have called bmap() and added a new
    // block to ip->addrs[].
    iupdate(ip);
    80003a86:	855e                	mv	a0,s7
    80003a88:	00000097          	auipc	ra,0x0
    80003a8c:	aa6080e7          	jalr	-1370(ra) # 8000352e <iupdate>
  }

  return n;
    80003a90:	000b051b          	sext.w	a0,s6
}
    80003a94:	70a6                	ld	ra,104(sp)
    80003a96:	7406                	ld	s0,96(sp)
    80003a98:	64e6                	ld	s1,88(sp)
    80003a9a:	6946                	ld	s2,80(sp)
    80003a9c:	69a6                	ld	s3,72(sp)
    80003a9e:	6a06                	ld	s4,64(sp)
    80003aa0:	7ae2                	ld	s5,56(sp)
    80003aa2:	7b42                	ld	s6,48(sp)
    80003aa4:	7ba2                	ld	s7,40(sp)
    80003aa6:	7c02                	ld	s8,32(sp)
    80003aa8:	6ce2                	ld	s9,24(sp)
    80003aaa:	6d42                	ld	s10,16(sp)
    80003aac:	6da2                	ld	s11,8(sp)
    80003aae:	6165                	addi	sp,sp,112
    80003ab0:	8082                	ret
    return -1;
    80003ab2:	557d                	li	a0,-1
}
    80003ab4:	8082                	ret
    return -1;
    80003ab6:	557d                	li	a0,-1
    80003ab8:	bff1                	j	80003a94 <writei+0xf0>
    return -1;
    80003aba:	557d                	li	a0,-1
    80003abc:	bfe1                	j	80003a94 <writei+0xf0>

0000000080003abe <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80003abe:	1141                	addi	sp,sp,-16
    80003ac0:	e406                	sd	ra,8(sp)
    80003ac2:	e022                	sd	s0,0(sp)
    80003ac4:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80003ac6:	4639                	li	a2,14
    80003ac8:	ffffd097          	auipc	ra,0xffffd
    80003acc:	30c080e7          	jalr	780(ra) # 80000dd4 <strncmp>
}
    80003ad0:	60a2                	ld	ra,8(sp)
    80003ad2:	6402                	ld	s0,0(sp)
    80003ad4:	0141                	addi	sp,sp,16
    80003ad6:	8082                	ret

0000000080003ad8 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80003ad8:	7139                	addi	sp,sp,-64
    80003ada:	fc06                	sd	ra,56(sp)
    80003adc:	f822                	sd	s0,48(sp)
    80003ade:	f426                	sd	s1,40(sp)
    80003ae0:	f04a                	sd	s2,32(sp)
    80003ae2:	ec4e                	sd	s3,24(sp)
    80003ae4:	e852                	sd	s4,16(sp)
    80003ae6:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    80003ae8:	04451703          	lh	a4,68(a0)
    80003aec:	4785                	li	a5,1
    80003aee:	00f71a63          	bne	a4,a5,80003b02 <dirlookup+0x2a>
    80003af2:	892a                	mv	s2,a0
    80003af4:	89ae                	mv	s3,a1
    80003af6:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    80003af8:	457c                	lw	a5,76(a0)
    80003afa:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80003afc:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003afe:	e79d                	bnez	a5,80003b2c <dirlookup+0x54>
    80003b00:	a8a5                	j	80003b78 <dirlookup+0xa0>
    panic("dirlookup not DIR");
    80003b02:	00005517          	auipc	a0,0x5
    80003b06:	ac650513          	addi	a0,a0,-1338 # 800085c8 <syscalls+0x1a0>
    80003b0a:	ffffd097          	auipc	ra,0xffffd
    80003b0e:	a3c080e7          	jalr	-1476(ra) # 80000546 <panic>
      panic("dirlookup read");
    80003b12:	00005517          	auipc	a0,0x5
    80003b16:	ace50513          	addi	a0,a0,-1330 # 800085e0 <syscalls+0x1b8>
    80003b1a:	ffffd097          	auipc	ra,0xffffd
    80003b1e:	a2c080e7          	jalr	-1492(ra) # 80000546 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003b22:	24c1                	addiw	s1,s1,16
    80003b24:	04c92783          	lw	a5,76(s2)
    80003b28:	04f4f763          	bgeu	s1,a5,80003b76 <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003b2c:	4741                	li	a4,16
    80003b2e:	86a6                	mv	a3,s1
    80003b30:	fc040613          	addi	a2,s0,-64
    80003b34:	4581                	li	a1,0
    80003b36:	854a                	mv	a0,s2
    80003b38:	00000097          	auipc	ra,0x0
    80003b3c:	d76080e7          	jalr	-650(ra) # 800038ae <readi>
    80003b40:	47c1                	li	a5,16
    80003b42:	fcf518e3          	bne	a0,a5,80003b12 <dirlookup+0x3a>
    if(de.inum == 0)
    80003b46:	fc045783          	lhu	a5,-64(s0)
    80003b4a:	dfe1                	beqz	a5,80003b22 <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    80003b4c:	fc240593          	addi	a1,s0,-62
    80003b50:	854e                	mv	a0,s3
    80003b52:	00000097          	auipc	ra,0x0
    80003b56:	f6c080e7          	jalr	-148(ra) # 80003abe <namecmp>
    80003b5a:	f561                	bnez	a0,80003b22 <dirlookup+0x4a>
      if(poff)
    80003b5c:	000a0463          	beqz	s4,80003b64 <dirlookup+0x8c>
        *poff = off;
    80003b60:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    80003b64:	fc045583          	lhu	a1,-64(s0)
    80003b68:	00092503          	lw	a0,0(s2)
    80003b6c:	fffff097          	auipc	ra,0xfffff
    80003b70:	758080e7          	jalr	1880(ra) # 800032c4 <iget>
    80003b74:	a011                	j	80003b78 <dirlookup+0xa0>
  return 0;
    80003b76:	4501                	li	a0,0
}
    80003b78:	70e2                	ld	ra,56(sp)
    80003b7a:	7442                	ld	s0,48(sp)
    80003b7c:	74a2                	ld	s1,40(sp)
    80003b7e:	7902                	ld	s2,32(sp)
    80003b80:	69e2                	ld	s3,24(sp)
    80003b82:	6a42                	ld	s4,16(sp)
    80003b84:	6121                	addi	sp,sp,64
    80003b86:	8082                	ret

0000000080003b88 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    80003b88:	711d                	addi	sp,sp,-96
    80003b8a:	ec86                	sd	ra,88(sp)
    80003b8c:	e8a2                	sd	s0,80(sp)
    80003b8e:	e4a6                	sd	s1,72(sp)
    80003b90:	e0ca                	sd	s2,64(sp)
    80003b92:	fc4e                	sd	s3,56(sp)
    80003b94:	f852                	sd	s4,48(sp)
    80003b96:	f456                	sd	s5,40(sp)
    80003b98:	f05a                	sd	s6,32(sp)
    80003b9a:	ec5e                	sd	s7,24(sp)
    80003b9c:	e862                	sd	s8,16(sp)
    80003b9e:	e466                	sd	s9,8(sp)
    80003ba0:	e06a                	sd	s10,0(sp)
    80003ba2:	1080                	addi	s0,sp,96
    80003ba4:	84aa                	mv	s1,a0
    80003ba6:	8b2e                	mv	s6,a1
    80003ba8:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    80003baa:	00054703          	lbu	a4,0(a0)
    80003bae:	02f00793          	li	a5,47
    80003bb2:	02f70363          	beq	a4,a5,80003bd8 <namex+0x50>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    80003bb6:	ffffe097          	auipc	ra,0xffffe
    80003bba:	e16080e7          	jalr	-490(ra) # 800019cc <myproc>
    80003bbe:	15053503          	ld	a0,336(a0)
    80003bc2:	00000097          	auipc	ra,0x0
    80003bc6:	9fa080e7          	jalr	-1542(ra) # 800035bc <idup>
    80003bca:	8a2a                	mv	s4,a0
  while(*path == '/')
    80003bcc:	02f00913          	li	s2,47
  if(len >= DIRSIZ)
    80003bd0:	4cb5                	li	s9,13
  len = path - s;
    80003bd2:	4b81                	li	s7,0

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    80003bd4:	4c05                	li	s8,1
    80003bd6:	a87d                	j	80003c94 <namex+0x10c>
    ip = iget(ROOTDEV, ROOTINO);
    80003bd8:	4585                	li	a1,1
    80003bda:	4505                	li	a0,1
    80003bdc:	fffff097          	auipc	ra,0xfffff
    80003be0:	6e8080e7          	jalr	1768(ra) # 800032c4 <iget>
    80003be4:	8a2a                	mv	s4,a0
    80003be6:	b7dd                	j	80003bcc <namex+0x44>
      iunlockput(ip);
    80003be8:	8552                	mv	a0,s4
    80003bea:	00000097          	auipc	ra,0x0
    80003bee:	c72080e7          	jalr	-910(ra) # 8000385c <iunlockput>
      return 0;
    80003bf2:	4a01                	li	s4,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    80003bf4:	8552                	mv	a0,s4
    80003bf6:	60e6                	ld	ra,88(sp)
    80003bf8:	6446                	ld	s0,80(sp)
    80003bfa:	64a6                	ld	s1,72(sp)
    80003bfc:	6906                	ld	s2,64(sp)
    80003bfe:	79e2                	ld	s3,56(sp)
    80003c00:	7a42                	ld	s4,48(sp)
    80003c02:	7aa2                	ld	s5,40(sp)
    80003c04:	7b02                	ld	s6,32(sp)
    80003c06:	6be2                	ld	s7,24(sp)
    80003c08:	6c42                	ld	s8,16(sp)
    80003c0a:	6ca2                	ld	s9,8(sp)
    80003c0c:	6d02                	ld	s10,0(sp)
    80003c0e:	6125                	addi	sp,sp,96
    80003c10:	8082                	ret
      iunlock(ip);
    80003c12:	8552                	mv	a0,s4
    80003c14:	00000097          	auipc	ra,0x0
    80003c18:	aa8080e7          	jalr	-1368(ra) # 800036bc <iunlock>
      return ip;
    80003c1c:	bfe1                	j	80003bf4 <namex+0x6c>
      iunlockput(ip);
    80003c1e:	8552                	mv	a0,s4
    80003c20:	00000097          	auipc	ra,0x0
    80003c24:	c3c080e7          	jalr	-964(ra) # 8000385c <iunlockput>
      return 0;
    80003c28:	8a4e                	mv	s4,s3
    80003c2a:	b7e9                	j	80003bf4 <namex+0x6c>
  len = path - s;
    80003c2c:	40998633          	sub	a2,s3,s1
    80003c30:	00060d1b          	sext.w	s10,a2
  if(len >= DIRSIZ)
    80003c34:	09acd863          	bge	s9,s10,80003cc4 <namex+0x13c>
    memmove(name, s, DIRSIZ);
    80003c38:	4639                	li	a2,14
    80003c3a:	85a6                	mv	a1,s1
    80003c3c:	8556                	mv	a0,s5
    80003c3e:	ffffd097          	auipc	ra,0xffffd
    80003c42:	11a080e7          	jalr	282(ra) # 80000d58 <memmove>
    80003c46:	84ce                	mv	s1,s3
  while(*path == '/')
    80003c48:	0004c783          	lbu	a5,0(s1)
    80003c4c:	01279763          	bne	a5,s2,80003c5a <namex+0xd2>
    path++;
    80003c50:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003c52:	0004c783          	lbu	a5,0(s1)
    80003c56:	ff278de3          	beq	a5,s2,80003c50 <namex+0xc8>
    ilock(ip);
    80003c5a:	8552                	mv	a0,s4
    80003c5c:	00000097          	auipc	ra,0x0
    80003c60:	99e080e7          	jalr	-1634(ra) # 800035fa <ilock>
    if(ip->type != T_DIR){
    80003c64:	044a1783          	lh	a5,68(s4)
    80003c68:	f98790e3          	bne	a5,s8,80003be8 <namex+0x60>
    if(nameiparent && *path == '\0'){
    80003c6c:	000b0563          	beqz	s6,80003c76 <namex+0xee>
    80003c70:	0004c783          	lbu	a5,0(s1)
    80003c74:	dfd9                	beqz	a5,80003c12 <namex+0x8a>
    if((next = dirlookup(ip, name, 0)) == 0){
    80003c76:	865e                	mv	a2,s7
    80003c78:	85d6                	mv	a1,s5
    80003c7a:	8552                	mv	a0,s4
    80003c7c:	00000097          	auipc	ra,0x0
    80003c80:	e5c080e7          	jalr	-420(ra) # 80003ad8 <dirlookup>
    80003c84:	89aa                	mv	s3,a0
    80003c86:	dd41                	beqz	a0,80003c1e <namex+0x96>
    iunlockput(ip);
    80003c88:	8552                	mv	a0,s4
    80003c8a:	00000097          	auipc	ra,0x0
    80003c8e:	bd2080e7          	jalr	-1070(ra) # 8000385c <iunlockput>
    ip = next;
    80003c92:	8a4e                	mv	s4,s3
  while(*path == '/')
    80003c94:	0004c783          	lbu	a5,0(s1)
    80003c98:	01279763          	bne	a5,s2,80003ca6 <namex+0x11e>
    path++;
    80003c9c:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003c9e:	0004c783          	lbu	a5,0(s1)
    80003ca2:	ff278de3          	beq	a5,s2,80003c9c <namex+0x114>
  if(*path == 0)
    80003ca6:	cb9d                	beqz	a5,80003cdc <namex+0x154>
  while(*path != '/' && *path != 0)
    80003ca8:	0004c783          	lbu	a5,0(s1)
    80003cac:	89a6                	mv	s3,s1
  len = path - s;
    80003cae:	8d5e                	mv	s10,s7
    80003cb0:	865e                	mv	a2,s7
  while(*path != '/' && *path != 0)
    80003cb2:	01278963          	beq	a5,s2,80003cc4 <namex+0x13c>
    80003cb6:	dbbd                	beqz	a5,80003c2c <namex+0xa4>
    path++;
    80003cb8:	0985                	addi	s3,s3,1
  while(*path != '/' && *path != 0)
    80003cba:	0009c783          	lbu	a5,0(s3)
    80003cbe:	ff279ce3          	bne	a5,s2,80003cb6 <namex+0x12e>
    80003cc2:	b7ad                	j	80003c2c <namex+0xa4>
    memmove(name, s, len);
    80003cc4:	2601                	sext.w	a2,a2
    80003cc6:	85a6                	mv	a1,s1
    80003cc8:	8556                	mv	a0,s5
    80003cca:	ffffd097          	auipc	ra,0xffffd
    80003cce:	08e080e7          	jalr	142(ra) # 80000d58 <memmove>
    name[len] = 0;
    80003cd2:	9d56                	add	s10,s10,s5
    80003cd4:	000d0023          	sb	zero,0(s10)
    80003cd8:	84ce                	mv	s1,s3
    80003cda:	b7bd                	j	80003c48 <namex+0xc0>
  if(nameiparent){
    80003cdc:	f00b0ce3          	beqz	s6,80003bf4 <namex+0x6c>
    iput(ip);
    80003ce0:	8552                	mv	a0,s4
    80003ce2:	00000097          	auipc	ra,0x0
    80003ce6:	ad2080e7          	jalr	-1326(ra) # 800037b4 <iput>
    return 0;
    80003cea:	4a01                	li	s4,0
    80003cec:	b721                	j	80003bf4 <namex+0x6c>

0000000080003cee <dirlink>:
{
    80003cee:	7139                	addi	sp,sp,-64
    80003cf0:	fc06                	sd	ra,56(sp)
    80003cf2:	f822                	sd	s0,48(sp)
    80003cf4:	f426                	sd	s1,40(sp)
    80003cf6:	f04a                	sd	s2,32(sp)
    80003cf8:	ec4e                	sd	s3,24(sp)
    80003cfa:	e852                	sd	s4,16(sp)
    80003cfc:	0080                	addi	s0,sp,64
    80003cfe:	892a                	mv	s2,a0
    80003d00:	8a2e                	mv	s4,a1
    80003d02:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    80003d04:	4601                	li	a2,0
    80003d06:	00000097          	auipc	ra,0x0
    80003d0a:	dd2080e7          	jalr	-558(ra) # 80003ad8 <dirlookup>
    80003d0e:	e93d                	bnez	a0,80003d84 <dirlink+0x96>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003d10:	04c92483          	lw	s1,76(s2)
    80003d14:	c49d                	beqz	s1,80003d42 <dirlink+0x54>
    80003d16:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003d18:	4741                	li	a4,16
    80003d1a:	86a6                	mv	a3,s1
    80003d1c:	fc040613          	addi	a2,s0,-64
    80003d20:	4581                	li	a1,0
    80003d22:	854a                	mv	a0,s2
    80003d24:	00000097          	auipc	ra,0x0
    80003d28:	b8a080e7          	jalr	-1142(ra) # 800038ae <readi>
    80003d2c:	47c1                	li	a5,16
    80003d2e:	06f51163          	bne	a0,a5,80003d90 <dirlink+0xa2>
    if(de.inum == 0)
    80003d32:	fc045783          	lhu	a5,-64(s0)
    80003d36:	c791                	beqz	a5,80003d42 <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003d38:	24c1                	addiw	s1,s1,16
    80003d3a:	04c92783          	lw	a5,76(s2)
    80003d3e:	fcf4ede3          	bltu	s1,a5,80003d18 <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    80003d42:	4639                	li	a2,14
    80003d44:	85d2                	mv	a1,s4
    80003d46:	fc240513          	addi	a0,s0,-62
    80003d4a:	ffffd097          	auipc	ra,0xffffd
    80003d4e:	0c6080e7          	jalr	198(ra) # 80000e10 <strncpy>
  de.inum = inum;
    80003d52:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003d56:	4741                	li	a4,16
    80003d58:	86a6                	mv	a3,s1
    80003d5a:	fc040613          	addi	a2,s0,-64
    80003d5e:	4581                	li	a1,0
    80003d60:	854a                	mv	a0,s2
    80003d62:	00000097          	auipc	ra,0x0
    80003d66:	c42080e7          	jalr	-958(ra) # 800039a4 <writei>
    80003d6a:	872a                	mv	a4,a0
    80003d6c:	47c1                	li	a5,16
  return 0;
    80003d6e:	4501                	li	a0,0
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003d70:	02f71863          	bne	a4,a5,80003da0 <dirlink+0xb2>
}
    80003d74:	70e2                	ld	ra,56(sp)
    80003d76:	7442                	ld	s0,48(sp)
    80003d78:	74a2                	ld	s1,40(sp)
    80003d7a:	7902                	ld	s2,32(sp)
    80003d7c:	69e2                	ld	s3,24(sp)
    80003d7e:	6a42                	ld	s4,16(sp)
    80003d80:	6121                	addi	sp,sp,64
    80003d82:	8082                	ret
    iput(ip);
    80003d84:	00000097          	auipc	ra,0x0
    80003d88:	a30080e7          	jalr	-1488(ra) # 800037b4 <iput>
    return -1;
    80003d8c:	557d                	li	a0,-1
    80003d8e:	b7dd                	j	80003d74 <dirlink+0x86>
      panic("dirlink read");
    80003d90:	00005517          	auipc	a0,0x5
    80003d94:	86050513          	addi	a0,a0,-1952 # 800085f0 <syscalls+0x1c8>
    80003d98:	ffffc097          	auipc	ra,0xffffc
    80003d9c:	7ae080e7          	jalr	1966(ra) # 80000546 <panic>
    panic("dirlink");
    80003da0:	00005517          	auipc	a0,0x5
    80003da4:	97050513          	addi	a0,a0,-1680 # 80008710 <syscalls+0x2e8>
    80003da8:	ffffc097          	auipc	ra,0xffffc
    80003dac:	79e080e7          	jalr	1950(ra) # 80000546 <panic>

0000000080003db0 <namei>:

struct inode*
namei(char *path)
{
    80003db0:	1101                	addi	sp,sp,-32
    80003db2:	ec06                	sd	ra,24(sp)
    80003db4:	e822                	sd	s0,16(sp)
    80003db6:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    80003db8:	fe040613          	addi	a2,s0,-32
    80003dbc:	4581                	li	a1,0
    80003dbe:	00000097          	auipc	ra,0x0
    80003dc2:	dca080e7          	jalr	-566(ra) # 80003b88 <namex>
}
    80003dc6:	60e2                	ld	ra,24(sp)
    80003dc8:	6442                	ld	s0,16(sp)
    80003dca:	6105                	addi	sp,sp,32
    80003dcc:	8082                	ret

0000000080003dce <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    80003dce:	1141                	addi	sp,sp,-16
    80003dd0:	e406                	sd	ra,8(sp)
    80003dd2:	e022                	sd	s0,0(sp)
    80003dd4:	0800                	addi	s0,sp,16
    80003dd6:	862e                	mv	a2,a1
  return namex(path, 1, name);
    80003dd8:	4585                	li	a1,1
    80003dda:	00000097          	auipc	ra,0x0
    80003dde:	dae080e7          	jalr	-594(ra) # 80003b88 <namex>
}
    80003de2:	60a2                	ld	ra,8(sp)
    80003de4:	6402                	ld	s0,0(sp)
    80003de6:	0141                	addi	sp,sp,16
    80003de8:	8082                	ret

0000000080003dea <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    80003dea:	1101                	addi	sp,sp,-32
    80003dec:	ec06                	sd	ra,24(sp)
    80003dee:	e822                	sd	s0,16(sp)
    80003df0:	e426                	sd	s1,8(sp)
    80003df2:	e04a                	sd	s2,0(sp)
    80003df4:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    80003df6:	0001e917          	auipc	s2,0x1e
    80003dfa:	b1290913          	addi	s2,s2,-1262 # 80021908 <log>
    80003dfe:	01892583          	lw	a1,24(s2)
    80003e02:	02892503          	lw	a0,40(s2)
    80003e06:	fffff097          	auipc	ra,0xfffff
    80003e0a:	ff2080e7          	jalr	-14(ra) # 80002df8 <bread>
    80003e0e:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    80003e10:	02c92683          	lw	a3,44(s2)
    80003e14:	cd34                	sw	a3,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    80003e16:	02d05863          	blez	a3,80003e46 <write_head+0x5c>
    80003e1a:	0001e797          	auipc	a5,0x1e
    80003e1e:	b1e78793          	addi	a5,a5,-1250 # 80021938 <log+0x30>
    80003e22:	05c50713          	addi	a4,a0,92
    80003e26:	36fd                	addiw	a3,a3,-1
    80003e28:	02069613          	slli	a2,a3,0x20
    80003e2c:	01e65693          	srli	a3,a2,0x1e
    80003e30:	0001e617          	auipc	a2,0x1e
    80003e34:	b0c60613          	addi	a2,a2,-1268 # 8002193c <log+0x34>
    80003e38:	96b2                	add	a3,a3,a2
    hb->block[i] = log.lh.block[i];
    80003e3a:	4390                	lw	a2,0(a5)
    80003e3c:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80003e3e:	0791                	addi	a5,a5,4
    80003e40:	0711                	addi	a4,a4,4 # 43004 <_entry-0x7ffbcffc>
    80003e42:	fed79ce3          	bne	a5,a3,80003e3a <write_head+0x50>
  }
  bwrite(buf);
    80003e46:	8526                	mv	a0,s1
    80003e48:	fffff097          	auipc	ra,0xfffff
    80003e4c:	0a2080e7          	jalr	162(ra) # 80002eea <bwrite>
  brelse(buf);
    80003e50:	8526                	mv	a0,s1
    80003e52:	fffff097          	auipc	ra,0xfffff
    80003e56:	0d6080e7          	jalr	214(ra) # 80002f28 <brelse>
}
    80003e5a:	60e2                	ld	ra,24(sp)
    80003e5c:	6442                	ld	s0,16(sp)
    80003e5e:	64a2                	ld	s1,8(sp)
    80003e60:	6902                	ld	s2,0(sp)
    80003e62:	6105                	addi	sp,sp,32
    80003e64:	8082                	ret

0000000080003e66 <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    80003e66:	0001e797          	auipc	a5,0x1e
    80003e6a:	ace7a783          	lw	a5,-1330(a5) # 80021934 <log+0x2c>
    80003e6e:	0af05663          	blez	a5,80003f1a <install_trans+0xb4>
{
    80003e72:	7139                	addi	sp,sp,-64
    80003e74:	fc06                	sd	ra,56(sp)
    80003e76:	f822                	sd	s0,48(sp)
    80003e78:	f426                	sd	s1,40(sp)
    80003e7a:	f04a                	sd	s2,32(sp)
    80003e7c:	ec4e                	sd	s3,24(sp)
    80003e7e:	e852                	sd	s4,16(sp)
    80003e80:	e456                	sd	s5,8(sp)
    80003e82:	0080                	addi	s0,sp,64
    80003e84:	0001ea97          	auipc	s5,0x1e
    80003e88:	ab4a8a93          	addi	s5,s5,-1356 # 80021938 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003e8c:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003e8e:	0001e997          	auipc	s3,0x1e
    80003e92:	a7a98993          	addi	s3,s3,-1414 # 80021908 <log>
    80003e96:	0189a583          	lw	a1,24(s3)
    80003e9a:	014585bb          	addw	a1,a1,s4
    80003e9e:	2585                	addiw	a1,a1,1
    80003ea0:	0289a503          	lw	a0,40(s3)
    80003ea4:	fffff097          	auipc	ra,0xfffff
    80003ea8:	f54080e7          	jalr	-172(ra) # 80002df8 <bread>
    80003eac:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    80003eae:	000aa583          	lw	a1,0(s5)
    80003eb2:	0289a503          	lw	a0,40(s3)
    80003eb6:	fffff097          	auipc	ra,0xfffff
    80003eba:	f42080e7          	jalr	-190(ra) # 80002df8 <bread>
    80003ebe:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    80003ec0:	40000613          	li	a2,1024
    80003ec4:	05890593          	addi	a1,s2,88
    80003ec8:	05850513          	addi	a0,a0,88
    80003ecc:	ffffd097          	auipc	ra,0xffffd
    80003ed0:	e8c080e7          	jalr	-372(ra) # 80000d58 <memmove>
    bwrite(dbuf);  // write dst to disk
    80003ed4:	8526                	mv	a0,s1
    80003ed6:	fffff097          	auipc	ra,0xfffff
    80003eda:	014080e7          	jalr	20(ra) # 80002eea <bwrite>
    bunpin(dbuf);
    80003ede:	8526                	mv	a0,s1
    80003ee0:	fffff097          	auipc	ra,0xfffff
    80003ee4:	122080e7          	jalr	290(ra) # 80003002 <bunpin>
    brelse(lbuf);
    80003ee8:	854a                	mv	a0,s2
    80003eea:	fffff097          	auipc	ra,0xfffff
    80003eee:	03e080e7          	jalr	62(ra) # 80002f28 <brelse>
    brelse(dbuf);
    80003ef2:	8526                	mv	a0,s1
    80003ef4:	fffff097          	auipc	ra,0xfffff
    80003ef8:	034080e7          	jalr	52(ra) # 80002f28 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003efc:	2a05                	addiw	s4,s4,1
    80003efe:	0a91                	addi	s5,s5,4
    80003f00:	02c9a783          	lw	a5,44(s3)
    80003f04:	f8fa49e3          	blt	s4,a5,80003e96 <install_trans+0x30>
}
    80003f08:	70e2                	ld	ra,56(sp)
    80003f0a:	7442                	ld	s0,48(sp)
    80003f0c:	74a2                	ld	s1,40(sp)
    80003f0e:	7902                	ld	s2,32(sp)
    80003f10:	69e2                	ld	s3,24(sp)
    80003f12:	6a42                	ld	s4,16(sp)
    80003f14:	6aa2                	ld	s5,8(sp)
    80003f16:	6121                	addi	sp,sp,64
    80003f18:	8082                	ret
    80003f1a:	8082                	ret

0000000080003f1c <initlog>:
{
    80003f1c:	7179                	addi	sp,sp,-48
    80003f1e:	f406                	sd	ra,40(sp)
    80003f20:	f022                	sd	s0,32(sp)
    80003f22:	ec26                	sd	s1,24(sp)
    80003f24:	e84a                	sd	s2,16(sp)
    80003f26:	e44e                	sd	s3,8(sp)
    80003f28:	1800                	addi	s0,sp,48
    80003f2a:	892a                	mv	s2,a0
    80003f2c:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    80003f2e:	0001e497          	auipc	s1,0x1e
    80003f32:	9da48493          	addi	s1,s1,-1574 # 80021908 <log>
    80003f36:	00004597          	auipc	a1,0x4
    80003f3a:	6ca58593          	addi	a1,a1,1738 # 80008600 <syscalls+0x1d8>
    80003f3e:	8526                	mv	a0,s1
    80003f40:	ffffd097          	auipc	ra,0xffffd
    80003f44:	c30080e7          	jalr	-976(ra) # 80000b70 <initlock>
  log.start = sb->logstart;
    80003f48:	0149a583          	lw	a1,20(s3)
    80003f4c:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    80003f4e:	0109a783          	lw	a5,16(s3)
    80003f52:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    80003f54:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    80003f58:	854a                	mv	a0,s2
    80003f5a:	fffff097          	auipc	ra,0xfffff
    80003f5e:	e9e080e7          	jalr	-354(ra) # 80002df8 <bread>
  log.lh.n = lh->n;
    80003f62:	4d34                	lw	a3,88(a0)
    80003f64:	d4d4                	sw	a3,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    80003f66:	02d05663          	blez	a3,80003f92 <initlog+0x76>
    80003f6a:	05c50793          	addi	a5,a0,92
    80003f6e:	0001e717          	auipc	a4,0x1e
    80003f72:	9ca70713          	addi	a4,a4,-1590 # 80021938 <log+0x30>
    80003f76:	36fd                	addiw	a3,a3,-1
    80003f78:	02069613          	slli	a2,a3,0x20
    80003f7c:	01e65693          	srli	a3,a2,0x1e
    80003f80:	06050613          	addi	a2,a0,96
    80003f84:	96b2                	add	a3,a3,a2
    log.lh.block[i] = lh->block[i];
    80003f86:	4390                	lw	a2,0(a5)
    80003f88:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80003f8a:	0791                	addi	a5,a5,4
    80003f8c:	0711                	addi	a4,a4,4
    80003f8e:	fed79ce3          	bne	a5,a3,80003f86 <initlog+0x6a>
  brelse(buf);
    80003f92:	fffff097          	auipc	ra,0xfffff
    80003f96:	f96080e7          	jalr	-106(ra) # 80002f28 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
    80003f9a:	00000097          	auipc	ra,0x0
    80003f9e:	ecc080e7          	jalr	-308(ra) # 80003e66 <install_trans>
  log.lh.n = 0;
    80003fa2:	0001e797          	auipc	a5,0x1e
    80003fa6:	9807a923          	sw	zero,-1646(a5) # 80021934 <log+0x2c>
  write_head(); // clear the log
    80003faa:	00000097          	auipc	ra,0x0
    80003fae:	e40080e7          	jalr	-448(ra) # 80003dea <write_head>
}
    80003fb2:	70a2                	ld	ra,40(sp)
    80003fb4:	7402                	ld	s0,32(sp)
    80003fb6:	64e2                	ld	s1,24(sp)
    80003fb8:	6942                	ld	s2,16(sp)
    80003fba:	69a2                	ld	s3,8(sp)
    80003fbc:	6145                	addi	sp,sp,48
    80003fbe:	8082                	ret

0000000080003fc0 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    80003fc0:	1101                	addi	sp,sp,-32
    80003fc2:	ec06                	sd	ra,24(sp)
    80003fc4:	e822                	sd	s0,16(sp)
    80003fc6:	e426                	sd	s1,8(sp)
    80003fc8:	e04a                	sd	s2,0(sp)
    80003fca:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    80003fcc:	0001e517          	auipc	a0,0x1e
    80003fd0:	93c50513          	addi	a0,a0,-1732 # 80021908 <log>
    80003fd4:	ffffd097          	auipc	ra,0xffffd
    80003fd8:	c2c080e7          	jalr	-980(ra) # 80000c00 <acquire>
  while(1){
    if(log.committing){
    80003fdc:	0001e497          	auipc	s1,0x1e
    80003fe0:	92c48493          	addi	s1,s1,-1748 # 80021908 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80003fe4:	4979                	li	s2,30
    80003fe6:	a039                	j	80003ff4 <begin_op+0x34>
      sleep(&log, &log.lock);
    80003fe8:	85a6                	mv	a1,s1
    80003fea:	8526                	mv	a0,s1
    80003fec:	ffffe097          	auipc	ra,0xffffe
    80003ff0:	1f4080e7          	jalr	500(ra) # 800021e0 <sleep>
    if(log.committing){
    80003ff4:	50dc                	lw	a5,36(s1)
    80003ff6:	fbed                	bnez	a5,80003fe8 <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80003ff8:	5098                	lw	a4,32(s1)
    80003ffa:	2705                	addiw	a4,a4,1
    80003ffc:	0007069b          	sext.w	a3,a4
    80004000:	0027179b          	slliw	a5,a4,0x2
    80004004:	9fb9                	addw	a5,a5,a4
    80004006:	0017979b          	slliw	a5,a5,0x1
    8000400a:	54d8                	lw	a4,44(s1)
    8000400c:	9fb9                	addw	a5,a5,a4
    8000400e:	00f95963          	bge	s2,a5,80004020 <begin_op+0x60>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    80004012:	85a6                	mv	a1,s1
    80004014:	8526                	mv	a0,s1
    80004016:	ffffe097          	auipc	ra,0xffffe
    8000401a:	1ca080e7          	jalr	458(ra) # 800021e0 <sleep>
    8000401e:	bfd9                	j	80003ff4 <begin_op+0x34>
    } else {
      log.outstanding += 1;
    80004020:	0001e517          	auipc	a0,0x1e
    80004024:	8e850513          	addi	a0,a0,-1816 # 80021908 <log>
    80004028:	d114                	sw	a3,32(a0)
      release(&log.lock);
    8000402a:	ffffd097          	auipc	ra,0xffffd
    8000402e:	c8a080e7          	jalr	-886(ra) # 80000cb4 <release>
      break;
    }
  }
}
    80004032:	60e2                	ld	ra,24(sp)
    80004034:	6442                	ld	s0,16(sp)
    80004036:	64a2                	ld	s1,8(sp)
    80004038:	6902                	ld	s2,0(sp)
    8000403a:	6105                	addi	sp,sp,32
    8000403c:	8082                	ret

000000008000403e <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    8000403e:	7139                	addi	sp,sp,-64
    80004040:	fc06                	sd	ra,56(sp)
    80004042:	f822                	sd	s0,48(sp)
    80004044:	f426                	sd	s1,40(sp)
    80004046:	f04a                	sd	s2,32(sp)
    80004048:	ec4e                	sd	s3,24(sp)
    8000404a:	e852                	sd	s4,16(sp)
    8000404c:	e456                	sd	s5,8(sp)
    8000404e:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    80004050:	0001e497          	auipc	s1,0x1e
    80004054:	8b848493          	addi	s1,s1,-1864 # 80021908 <log>
    80004058:	8526                	mv	a0,s1
    8000405a:	ffffd097          	auipc	ra,0xffffd
    8000405e:	ba6080e7          	jalr	-1114(ra) # 80000c00 <acquire>
  log.outstanding -= 1;
    80004062:	509c                	lw	a5,32(s1)
    80004064:	37fd                	addiw	a5,a5,-1
    80004066:	0007891b          	sext.w	s2,a5
    8000406a:	d09c                	sw	a5,32(s1)
  if(log.committing)
    8000406c:	50dc                	lw	a5,36(s1)
    8000406e:	e7b9                	bnez	a5,800040bc <end_op+0x7e>
    panic("log.committing");
  if(log.outstanding == 0){
    80004070:	04091e63          	bnez	s2,800040cc <end_op+0x8e>
    do_commit = 1;
    log.committing = 1;
    80004074:	0001e497          	auipc	s1,0x1e
    80004078:	89448493          	addi	s1,s1,-1900 # 80021908 <log>
    8000407c:	4785                	li	a5,1
    8000407e:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    80004080:	8526                	mv	a0,s1
    80004082:	ffffd097          	auipc	ra,0xffffd
    80004086:	c32080e7          	jalr	-974(ra) # 80000cb4 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    8000408a:	54dc                	lw	a5,44(s1)
    8000408c:	06f04763          	bgtz	a5,800040fa <end_op+0xbc>
    acquire(&log.lock);
    80004090:	0001e497          	auipc	s1,0x1e
    80004094:	87848493          	addi	s1,s1,-1928 # 80021908 <log>
    80004098:	8526                	mv	a0,s1
    8000409a:	ffffd097          	auipc	ra,0xffffd
    8000409e:	b66080e7          	jalr	-1178(ra) # 80000c00 <acquire>
    log.committing = 0;
    800040a2:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    800040a6:	8526                	mv	a0,s1
    800040a8:	ffffe097          	auipc	ra,0xffffe
    800040ac:	2b8080e7          	jalr	696(ra) # 80002360 <wakeup>
    release(&log.lock);
    800040b0:	8526                	mv	a0,s1
    800040b2:	ffffd097          	auipc	ra,0xffffd
    800040b6:	c02080e7          	jalr	-1022(ra) # 80000cb4 <release>
}
    800040ba:	a03d                	j	800040e8 <end_op+0xaa>
    panic("log.committing");
    800040bc:	00004517          	auipc	a0,0x4
    800040c0:	54c50513          	addi	a0,a0,1356 # 80008608 <syscalls+0x1e0>
    800040c4:	ffffc097          	auipc	ra,0xffffc
    800040c8:	482080e7          	jalr	1154(ra) # 80000546 <panic>
    wakeup(&log);
    800040cc:	0001e497          	auipc	s1,0x1e
    800040d0:	83c48493          	addi	s1,s1,-1988 # 80021908 <log>
    800040d4:	8526                	mv	a0,s1
    800040d6:	ffffe097          	auipc	ra,0xffffe
    800040da:	28a080e7          	jalr	650(ra) # 80002360 <wakeup>
  release(&log.lock);
    800040de:	8526                	mv	a0,s1
    800040e0:	ffffd097          	auipc	ra,0xffffd
    800040e4:	bd4080e7          	jalr	-1068(ra) # 80000cb4 <release>
}
    800040e8:	70e2                	ld	ra,56(sp)
    800040ea:	7442                	ld	s0,48(sp)
    800040ec:	74a2                	ld	s1,40(sp)
    800040ee:	7902                	ld	s2,32(sp)
    800040f0:	69e2                	ld	s3,24(sp)
    800040f2:	6a42                	ld	s4,16(sp)
    800040f4:	6aa2                	ld	s5,8(sp)
    800040f6:	6121                	addi	sp,sp,64
    800040f8:	8082                	ret
  for (tail = 0; tail < log.lh.n; tail++) {
    800040fa:	0001ea97          	auipc	s5,0x1e
    800040fe:	83ea8a93          	addi	s5,s5,-1986 # 80021938 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    80004102:	0001ea17          	auipc	s4,0x1e
    80004106:	806a0a13          	addi	s4,s4,-2042 # 80021908 <log>
    8000410a:	018a2583          	lw	a1,24(s4)
    8000410e:	012585bb          	addw	a1,a1,s2
    80004112:	2585                	addiw	a1,a1,1
    80004114:	028a2503          	lw	a0,40(s4)
    80004118:	fffff097          	auipc	ra,0xfffff
    8000411c:	ce0080e7          	jalr	-800(ra) # 80002df8 <bread>
    80004120:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    80004122:	000aa583          	lw	a1,0(s5)
    80004126:	028a2503          	lw	a0,40(s4)
    8000412a:	fffff097          	auipc	ra,0xfffff
    8000412e:	cce080e7          	jalr	-818(ra) # 80002df8 <bread>
    80004132:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    80004134:	40000613          	li	a2,1024
    80004138:	05850593          	addi	a1,a0,88
    8000413c:	05848513          	addi	a0,s1,88
    80004140:	ffffd097          	auipc	ra,0xffffd
    80004144:	c18080e7          	jalr	-1000(ra) # 80000d58 <memmove>
    bwrite(to);  // write the log
    80004148:	8526                	mv	a0,s1
    8000414a:	fffff097          	auipc	ra,0xfffff
    8000414e:	da0080e7          	jalr	-608(ra) # 80002eea <bwrite>
    brelse(from);
    80004152:	854e                	mv	a0,s3
    80004154:	fffff097          	auipc	ra,0xfffff
    80004158:	dd4080e7          	jalr	-556(ra) # 80002f28 <brelse>
    brelse(to);
    8000415c:	8526                	mv	a0,s1
    8000415e:	fffff097          	auipc	ra,0xfffff
    80004162:	dca080e7          	jalr	-566(ra) # 80002f28 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80004166:	2905                	addiw	s2,s2,1
    80004168:	0a91                	addi	s5,s5,4
    8000416a:	02ca2783          	lw	a5,44(s4)
    8000416e:	f8f94ee3          	blt	s2,a5,8000410a <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    80004172:	00000097          	auipc	ra,0x0
    80004176:	c78080e7          	jalr	-904(ra) # 80003dea <write_head>
    install_trans(); // Now install writes to home locations
    8000417a:	00000097          	auipc	ra,0x0
    8000417e:	cec080e7          	jalr	-788(ra) # 80003e66 <install_trans>
    log.lh.n = 0;
    80004182:	0001d797          	auipc	a5,0x1d
    80004186:	7a07a923          	sw	zero,1970(a5) # 80021934 <log+0x2c>
    write_head();    // Erase the transaction from the log
    8000418a:	00000097          	auipc	ra,0x0
    8000418e:	c60080e7          	jalr	-928(ra) # 80003dea <write_head>
    80004192:	bdfd                	j	80004090 <end_op+0x52>

0000000080004194 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    80004194:	1101                	addi	sp,sp,-32
    80004196:	ec06                	sd	ra,24(sp)
    80004198:	e822                	sd	s0,16(sp)
    8000419a:	e426                	sd	s1,8(sp)
    8000419c:	e04a                	sd	s2,0(sp)
    8000419e:	1000                	addi	s0,sp,32
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    800041a0:	0001d717          	auipc	a4,0x1d
    800041a4:	79472703          	lw	a4,1940(a4) # 80021934 <log+0x2c>
    800041a8:	47f5                	li	a5,29
    800041aa:	08e7c063          	blt	a5,a4,8000422a <log_write+0x96>
    800041ae:	84aa                	mv	s1,a0
    800041b0:	0001d797          	auipc	a5,0x1d
    800041b4:	7747a783          	lw	a5,1908(a5) # 80021924 <log+0x1c>
    800041b8:	37fd                	addiw	a5,a5,-1
    800041ba:	06f75863          	bge	a4,a5,8000422a <log_write+0x96>
    panic("too big a transaction");
  if (log.outstanding < 1)
    800041be:	0001d797          	auipc	a5,0x1d
    800041c2:	76a7a783          	lw	a5,1898(a5) # 80021928 <log+0x20>
    800041c6:	06f05a63          	blez	a5,8000423a <log_write+0xa6>
    panic("log_write outside of trans");

  acquire(&log.lock);
    800041ca:	0001d917          	auipc	s2,0x1d
    800041ce:	73e90913          	addi	s2,s2,1854 # 80021908 <log>
    800041d2:	854a                	mv	a0,s2
    800041d4:	ffffd097          	auipc	ra,0xffffd
    800041d8:	a2c080e7          	jalr	-1492(ra) # 80000c00 <acquire>
  for (i = 0; i < log.lh.n; i++) {
    800041dc:	02c92603          	lw	a2,44(s2)
    800041e0:	06c05563          	blez	a2,8000424a <log_write+0xb6>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
    800041e4:	44cc                	lw	a1,12(s1)
    800041e6:	0001d717          	auipc	a4,0x1d
    800041ea:	75270713          	addi	a4,a4,1874 # 80021938 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    800041ee:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorbtion
    800041f0:	4314                	lw	a3,0(a4)
    800041f2:	04b68d63          	beq	a3,a1,8000424c <log_write+0xb8>
  for (i = 0; i < log.lh.n; i++) {
    800041f6:	2785                	addiw	a5,a5,1
    800041f8:	0711                	addi	a4,a4,4
    800041fa:	fec79be3          	bne	a5,a2,800041f0 <log_write+0x5c>
      break;
  }
  log.lh.block[i] = b->blockno;
    800041fe:	0621                	addi	a2,a2,8
    80004200:	060a                	slli	a2,a2,0x2
    80004202:	0001d797          	auipc	a5,0x1d
    80004206:	70678793          	addi	a5,a5,1798 # 80021908 <log>
    8000420a:	97b2                	add	a5,a5,a2
    8000420c:	44d8                	lw	a4,12(s1)
    8000420e:	cb98                	sw	a4,16(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    80004210:	8526                	mv	a0,s1
    80004212:	fffff097          	auipc	ra,0xfffff
    80004216:	db4080e7          	jalr	-588(ra) # 80002fc6 <bpin>
    log.lh.n++;
    8000421a:	0001d717          	auipc	a4,0x1d
    8000421e:	6ee70713          	addi	a4,a4,1774 # 80021908 <log>
    80004222:	575c                	lw	a5,44(a4)
    80004224:	2785                	addiw	a5,a5,1
    80004226:	d75c                	sw	a5,44(a4)
    80004228:	a835                	j	80004264 <log_write+0xd0>
    panic("too big a transaction");
    8000422a:	00004517          	auipc	a0,0x4
    8000422e:	3ee50513          	addi	a0,a0,1006 # 80008618 <syscalls+0x1f0>
    80004232:	ffffc097          	auipc	ra,0xffffc
    80004236:	314080e7          	jalr	788(ra) # 80000546 <panic>
    panic("log_write outside of trans");
    8000423a:	00004517          	auipc	a0,0x4
    8000423e:	3f650513          	addi	a0,a0,1014 # 80008630 <syscalls+0x208>
    80004242:	ffffc097          	auipc	ra,0xffffc
    80004246:	304080e7          	jalr	772(ra) # 80000546 <panic>
  for (i = 0; i < log.lh.n; i++) {
    8000424a:	4781                	li	a5,0
  log.lh.block[i] = b->blockno;
    8000424c:	00878693          	addi	a3,a5,8
    80004250:	068a                	slli	a3,a3,0x2
    80004252:	0001d717          	auipc	a4,0x1d
    80004256:	6b670713          	addi	a4,a4,1718 # 80021908 <log>
    8000425a:	9736                	add	a4,a4,a3
    8000425c:	44d4                	lw	a3,12(s1)
    8000425e:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    80004260:	faf608e3          	beq	a2,a5,80004210 <log_write+0x7c>
  }
  release(&log.lock);
    80004264:	0001d517          	auipc	a0,0x1d
    80004268:	6a450513          	addi	a0,a0,1700 # 80021908 <log>
    8000426c:	ffffd097          	auipc	ra,0xffffd
    80004270:	a48080e7          	jalr	-1464(ra) # 80000cb4 <release>
}
    80004274:	60e2                	ld	ra,24(sp)
    80004276:	6442                	ld	s0,16(sp)
    80004278:	64a2                	ld	s1,8(sp)
    8000427a:	6902                	ld	s2,0(sp)
    8000427c:	6105                	addi	sp,sp,32
    8000427e:	8082                	ret

0000000080004280 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    80004280:	1101                	addi	sp,sp,-32
    80004282:	ec06                	sd	ra,24(sp)
    80004284:	e822                	sd	s0,16(sp)
    80004286:	e426                	sd	s1,8(sp)
    80004288:	e04a                	sd	s2,0(sp)
    8000428a:	1000                	addi	s0,sp,32
    8000428c:	84aa                	mv	s1,a0
    8000428e:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    80004290:	00004597          	auipc	a1,0x4
    80004294:	3c058593          	addi	a1,a1,960 # 80008650 <syscalls+0x228>
    80004298:	0521                	addi	a0,a0,8
    8000429a:	ffffd097          	auipc	ra,0xffffd
    8000429e:	8d6080e7          	jalr	-1834(ra) # 80000b70 <initlock>
  lk->name = name;
    800042a2:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    800042a6:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    800042aa:	0204a423          	sw	zero,40(s1)
}
    800042ae:	60e2                	ld	ra,24(sp)
    800042b0:	6442                	ld	s0,16(sp)
    800042b2:	64a2                	ld	s1,8(sp)
    800042b4:	6902                	ld	s2,0(sp)
    800042b6:	6105                	addi	sp,sp,32
    800042b8:	8082                	ret

00000000800042ba <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    800042ba:	1101                	addi	sp,sp,-32
    800042bc:	ec06                	sd	ra,24(sp)
    800042be:	e822                	sd	s0,16(sp)
    800042c0:	e426                	sd	s1,8(sp)
    800042c2:	e04a                	sd	s2,0(sp)
    800042c4:	1000                	addi	s0,sp,32
    800042c6:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    800042c8:	00850913          	addi	s2,a0,8
    800042cc:	854a                	mv	a0,s2
    800042ce:	ffffd097          	auipc	ra,0xffffd
    800042d2:	932080e7          	jalr	-1742(ra) # 80000c00 <acquire>
  while (lk->locked) {
    800042d6:	409c                	lw	a5,0(s1)
    800042d8:	cb89                	beqz	a5,800042ea <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    800042da:	85ca                	mv	a1,s2
    800042dc:	8526                	mv	a0,s1
    800042de:	ffffe097          	auipc	ra,0xffffe
    800042e2:	f02080e7          	jalr	-254(ra) # 800021e0 <sleep>
  while (lk->locked) {
    800042e6:	409c                	lw	a5,0(s1)
    800042e8:	fbed                	bnez	a5,800042da <acquiresleep+0x20>
  }
  lk->locked = 1;
    800042ea:	4785                	li	a5,1
    800042ec:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    800042ee:	ffffd097          	auipc	ra,0xffffd
    800042f2:	6de080e7          	jalr	1758(ra) # 800019cc <myproc>
    800042f6:	5d1c                	lw	a5,56(a0)
    800042f8:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    800042fa:	854a                	mv	a0,s2
    800042fc:	ffffd097          	auipc	ra,0xffffd
    80004300:	9b8080e7          	jalr	-1608(ra) # 80000cb4 <release>
}
    80004304:	60e2                	ld	ra,24(sp)
    80004306:	6442                	ld	s0,16(sp)
    80004308:	64a2                	ld	s1,8(sp)
    8000430a:	6902                	ld	s2,0(sp)
    8000430c:	6105                	addi	sp,sp,32
    8000430e:	8082                	ret

0000000080004310 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    80004310:	1101                	addi	sp,sp,-32
    80004312:	ec06                	sd	ra,24(sp)
    80004314:	e822                	sd	s0,16(sp)
    80004316:	e426                	sd	s1,8(sp)
    80004318:	e04a                	sd	s2,0(sp)
    8000431a:	1000                	addi	s0,sp,32
    8000431c:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    8000431e:	00850913          	addi	s2,a0,8
    80004322:	854a                	mv	a0,s2
    80004324:	ffffd097          	auipc	ra,0xffffd
    80004328:	8dc080e7          	jalr	-1828(ra) # 80000c00 <acquire>
  lk->locked = 0;
    8000432c:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80004330:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    80004334:	8526                	mv	a0,s1
    80004336:	ffffe097          	auipc	ra,0xffffe
    8000433a:	02a080e7          	jalr	42(ra) # 80002360 <wakeup>
  release(&lk->lk);
    8000433e:	854a                	mv	a0,s2
    80004340:	ffffd097          	auipc	ra,0xffffd
    80004344:	974080e7          	jalr	-1676(ra) # 80000cb4 <release>
}
    80004348:	60e2                	ld	ra,24(sp)
    8000434a:	6442                	ld	s0,16(sp)
    8000434c:	64a2                	ld	s1,8(sp)
    8000434e:	6902                	ld	s2,0(sp)
    80004350:	6105                	addi	sp,sp,32
    80004352:	8082                	ret

0000000080004354 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    80004354:	7179                	addi	sp,sp,-48
    80004356:	f406                	sd	ra,40(sp)
    80004358:	f022                	sd	s0,32(sp)
    8000435a:	ec26                	sd	s1,24(sp)
    8000435c:	e84a                	sd	s2,16(sp)
    8000435e:	e44e                	sd	s3,8(sp)
    80004360:	1800                	addi	s0,sp,48
    80004362:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    80004364:	00850913          	addi	s2,a0,8
    80004368:	854a                	mv	a0,s2
    8000436a:	ffffd097          	auipc	ra,0xffffd
    8000436e:	896080e7          	jalr	-1898(ra) # 80000c00 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80004372:	409c                	lw	a5,0(s1)
    80004374:	ef99                	bnez	a5,80004392 <holdingsleep+0x3e>
    80004376:	4481                	li	s1,0
  release(&lk->lk);
    80004378:	854a                	mv	a0,s2
    8000437a:	ffffd097          	auipc	ra,0xffffd
    8000437e:	93a080e7          	jalr	-1734(ra) # 80000cb4 <release>
  return r;
}
    80004382:	8526                	mv	a0,s1
    80004384:	70a2                	ld	ra,40(sp)
    80004386:	7402                	ld	s0,32(sp)
    80004388:	64e2                	ld	s1,24(sp)
    8000438a:	6942                	ld	s2,16(sp)
    8000438c:	69a2                	ld	s3,8(sp)
    8000438e:	6145                	addi	sp,sp,48
    80004390:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    80004392:	0284a983          	lw	s3,40(s1)
    80004396:	ffffd097          	auipc	ra,0xffffd
    8000439a:	636080e7          	jalr	1590(ra) # 800019cc <myproc>
    8000439e:	5d04                	lw	s1,56(a0)
    800043a0:	413484b3          	sub	s1,s1,s3
    800043a4:	0014b493          	seqz	s1,s1
    800043a8:	bfc1                	j	80004378 <holdingsleep+0x24>

00000000800043aa <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    800043aa:	1141                	addi	sp,sp,-16
    800043ac:	e406                	sd	ra,8(sp)
    800043ae:	e022                	sd	s0,0(sp)
    800043b0:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    800043b2:	00004597          	auipc	a1,0x4
    800043b6:	2ae58593          	addi	a1,a1,686 # 80008660 <syscalls+0x238>
    800043ba:	0001d517          	auipc	a0,0x1d
    800043be:	69650513          	addi	a0,a0,1686 # 80021a50 <ftable>
    800043c2:	ffffc097          	auipc	ra,0xffffc
    800043c6:	7ae080e7          	jalr	1966(ra) # 80000b70 <initlock>
}
    800043ca:	60a2                	ld	ra,8(sp)
    800043cc:	6402                	ld	s0,0(sp)
    800043ce:	0141                	addi	sp,sp,16
    800043d0:	8082                	ret

00000000800043d2 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    800043d2:	1101                	addi	sp,sp,-32
    800043d4:	ec06                	sd	ra,24(sp)
    800043d6:	e822                	sd	s0,16(sp)
    800043d8:	e426                	sd	s1,8(sp)
    800043da:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    800043dc:	0001d517          	auipc	a0,0x1d
    800043e0:	67450513          	addi	a0,a0,1652 # 80021a50 <ftable>
    800043e4:	ffffd097          	auipc	ra,0xffffd
    800043e8:	81c080e7          	jalr	-2020(ra) # 80000c00 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    800043ec:	0001d497          	auipc	s1,0x1d
    800043f0:	67c48493          	addi	s1,s1,1660 # 80021a68 <ftable+0x18>
    800043f4:	0001e717          	auipc	a4,0x1e
    800043f8:	61470713          	addi	a4,a4,1556 # 80022a08 <ftable+0xfb8>
    if(f->ref == 0){
    800043fc:	40dc                	lw	a5,4(s1)
    800043fe:	cf99                	beqz	a5,8000441c <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80004400:	02848493          	addi	s1,s1,40
    80004404:	fee49ce3          	bne	s1,a4,800043fc <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80004408:	0001d517          	auipc	a0,0x1d
    8000440c:	64850513          	addi	a0,a0,1608 # 80021a50 <ftable>
    80004410:	ffffd097          	auipc	ra,0xffffd
    80004414:	8a4080e7          	jalr	-1884(ra) # 80000cb4 <release>
  return 0;
    80004418:	4481                	li	s1,0
    8000441a:	a819                	j	80004430 <filealloc+0x5e>
      f->ref = 1;
    8000441c:	4785                	li	a5,1
    8000441e:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80004420:	0001d517          	auipc	a0,0x1d
    80004424:	63050513          	addi	a0,a0,1584 # 80021a50 <ftable>
    80004428:	ffffd097          	auipc	ra,0xffffd
    8000442c:	88c080e7          	jalr	-1908(ra) # 80000cb4 <release>
}
    80004430:	8526                	mv	a0,s1
    80004432:	60e2                	ld	ra,24(sp)
    80004434:	6442                	ld	s0,16(sp)
    80004436:	64a2                	ld	s1,8(sp)
    80004438:	6105                	addi	sp,sp,32
    8000443a:	8082                	ret

000000008000443c <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    8000443c:	1101                	addi	sp,sp,-32
    8000443e:	ec06                	sd	ra,24(sp)
    80004440:	e822                	sd	s0,16(sp)
    80004442:	e426                	sd	s1,8(sp)
    80004444:	1000                	addi	s0,sp,32
    80004446:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80004448:	0001d517          	auipc	a0,0x1d
    8000444c:	60850513          	addi	a0,a0,1544 # 80021a50 <ftable>
    80004450:	ffffc097          	auipc	ra,0xffffc
    80004454:	7b0080e7          	jalr	1968(ra) # 80000c00 <acquire>
  if(f->ref < 1)
    80004458:	40dc                	lw	a5,4(s1)
    8000445a:	02f05263          	blez	a5,8000447e <filedup+0x42>
    panic("filedup");
  f->ref++;
    8000445e:	2785                	addiw	a5,a5,1
    80004460:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80004462:	0001d517          	auipc	a0,0x1d
    80004466:	5ee50513          	addi	a0,a0,1518 # 80021a50 <ftable>
    8000446a:	ffffd097          	auipc	ra,0xffffd
    8000446e:	84a080e7          	jalr	-1974(ra) # 80000cb4 <release>
  return f;
}
    80004472:	8526                	mv	a0,s1
    80004474:	60e2                	ld	ra,24(sp)
    80004476:	6442                	ld	s0,16(sp)
    80004478:	64a2                	ld	s1,8(sp)
    8000447a:	6105                	addi	sp,sp,32
    8000447c:	8082                	ret
    panic("filedup");
    8000447e:	00004517          	auipc	a0,0x4
    80004482:	1ea50513          	addi	a0,a0,490 # 80008668 <syscalls+0x240>
    80004486:	ffffc097          	auipc	ra,0xffffc
    8000448a:	0c0080e7          	jalr	192(ra) # 80000546 <panic>

000000008000448e <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    8000448e:	7139                	addi	sp,sp,-64
    80004490:	fc06                	sd	ra,56(sp)
    80004492:	f822                	sd	s0,48(sp)
    80004494:	f426                	sd	s1,40(sp)
    80004496:	f04a                	sd	s2,32(sp)
    80004498:	ec4e                	sd	s3,24(sp)
    8000449a:	e852                	sd	s4,16(sp)
    8000449c:	e456                	sd	s5,8(sp)
    8000449e:	0080                	addi	s0,sp,64
    800044a0:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    800044a2:	0001d517          	auipc	a0,0x1d
    800044a6:	5ae50513          	addi	a0,a0,1454 # 80021a50 <ftable>
    800044aa:	ffffc097          	auipc	ra,0xffffc
    800044ae:	756080e7          	jalr	1878(ra) # 80000c00 <acquire>
  if(f->ref < 1)
    800044b2:	40dc                	lw	a5,4(s1)
    800044b4:	06f05163          	blez	a5,80004516 <fileclose+0x88>
    panic("fileclose");
  if(--f->ref > 0){
    800044b8:	37fd                	addiw	a5,a5,-1
    800044ba:	0007871b          	sext.w	a4,a5
    800044be:	c0dc                	sw	a5,4(s1)
    800044c0:	06e04363          	bgtz	a4,80004526 <fileclose+0x98>
    release(&ftable.lock);
    return;
  }
  ff = *f;
    800044c4:	0004a903          	lw	s2,0(s1)
    800044c8:	0094ca83          	lbu	s5,9(s1)
    800044cc:	0104ba03          	ld	s4,16(s1)
    800044d0:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    800044d4:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    800044d8:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    800044dc:	0001d517          	auipc	a0,0x1d
    800044e0:	57450513          	addi	a0,a0,1396 # 80021a50 <ftable>
    800044e4:	ffffc097          	auipc	ra,0xffffc
    800044e8:	7d0080e7          	jalr	2000(ra) # 80000cb4 <release>

  if(ff.type == FD_PIPE){
    800044ec:	4785                	li	a5,1
    800044ee:	04f90d63          	beq	s2,a5,80004548 <fileclose+0xba>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    800044f2:	3979                	addiw	s2,s2,-2
    800044f4:	4785                	li	a5,1
    800044f6:	0527e063          	bltu	a5,s2,80004536 <fileclose+0xa8>
    begin_op();
    800044fa:	00000097          	auipc	ra,0x0
    800044fe:	ac6080e7          	jalr	-1338(ra) # 80003fc0 <begin_op>
    iput(ff.ip);
    80004502:	854e                	mv	a0,s3
    80004504:	fffff097          	auipc	ra,0xfffff
    80004508:	2b0080e7          	jalr	688(ra) # 800037b4 <iput>
    end_op();
    8000450c:	00000097          	auipc	ra,0x0
    80004510:	b32080e7          	jalr	-1230(ra) # 8000403e <end_op>
    80004514:	a00d                	j	80004536 <fileclose+0xa8>
    panic("fileclose");
    80004516:	00004517          	auipc	a0,0x4
    8000451a:	15a50513          	addi	a0,a0,346 # 80008670 <syscalls+0x248>
    8000451e:	ffffc097          	auipc	ra,0xffffc
    80004522:	028080e7          	jalr	40(ra) # 80000546 <panic>
    release(&ftable.lock);
    80004526:	0001d517          	auipc	a0,0x1d
    8000452a:	52a50513          	addi	a0,a0,1322 # 80021a50 <ftable>
    8000452e:	ffffc097          	auipc	ra,0xffffc
    80004532:	786080e7          	jalr	1926(ra) # 80000cb4 <release>
  }
}
    80004536:	70e2                	ld	ra,56(sp)
    80004538:	7442                	ld	s0,48(sp)
    8000453a:	74a2                	ld	s1,40(sp)
    8000453c:	7902                	ld	s2,32(sp)
    8000453e:	69e2                	ld	s3,24(sp)
    80004540:	6a42                	ld	s4,16(sp)
    80004542:	6aa2                	ld	s5,8(sp)
    80004544:	6121                	addi	sp,sp,64
    80004546:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80004548:	85d6                	mv	a1,s5
    8000454a:	8552                	mv	a0,s4
    8000454c:	00000097          	auipc	ra,0x0
    80004550:	372080e7          	jalr	882(ra) # 800048be <pipeclose>
    80004554:	b7cd                	j	80004536 <fileclose+0xa8>

0000000080004556 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80004556:	715d                	addi	sp,sp,-80
    80004558:	e486                	sd	ra,72(sp)
    8000455a:	e0a2                	sd	s0,64(sp)
    8000455c:	fc26                	sd	s1,56(sp)
    8000455e:	f84a                	sd	s2,48(sp)
    80004560:	f44e                	sd	s3,40(sp)
    80004562:	0880                	addi	s0,sp,80
    80004564:	84aa                	mv	s1,a0
    80004566:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80004568:	ffffd097          	auipc	ra,0xffffd
    8000456c:	464080e7          	jalr	1124(ra) # 800019cc <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80004570:	409c                	lw	a5,0(s1)
    80004572:	37f9                	addiw	a5,a5,-2
    80004574:	4705                	li	a4,1
    80004576:	04f76763          	bltu	a4,a5,800045c4 <filestat+0x6e>
    8000457a:	892a                	mv	s2,a0
    ilock(f->ip);
    8000457c:	6c88                	ld	a0,24(s1)
    8000457e:	fffff097          	auipc	ra,0xfffff
    80004582:	07c080e7          	jalr	124(ra) # 800035fa <ilock>
    stati(f->ip, &st);
    80004586:	fb840593          	addi	a1,s0,-72
    8000458a:	6c88                	ld	a0,24(s1)
    8000458c:	fffff097          	auipc	ra,0xfffff
    80004590:	2f8080e7          	jalr	760(ra) # 80003884 <stati>
    iunlock(f->ip);
    80004594:	6c88                	ld	a0,24(s1)
    80004596:	fffff097          	auipc	ra,0xfffff
    8000459a:	126080e7          	jalr	294(ra) # 800036bc <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    8000459e:	46e1                	li	a3,24
    800045a0:	fb840613          	addi	a2,s0,-72
    800045a4:	85ce                	mv	a1,s3
    800045a6:	05093503          	ld	a0,80(s2)
    800045aa:	ffffd097          	auipc	ra,0xffffd
    800045ae:	118080e7          	jalr	280(ra) # 800016c2 <copyout>
    800045b2:	41f5551b          	sraiw	a0,a0,0x1f
      return -1;
    return 0;
  }
  return -1;
}
    800045b6:	60a6                	ld	ra,72(sp)
    800045b8:	6406                	ld	s0,64(sp)
    800045ba:	74e2                	ld	s1,56(sp)
    800045bc:	7942                	ld	s2,48(sp)
    800045be:	79a2                	ld	s3,40(sp)
    800045c0:	6161                	addi	sp,sp,80
    800045c2:	8082                	ret
  return -1;
    800045c4:	557d                	li	a0,-1
    800045c6:	bfc5                	j	800045b6 <filestat+0x60>

00000000800045c8 <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    800045c8:	7179                	addi	sp,sp,-48
    800045ca:	f406                	sd	ra,40(sp)
    800045cc:	f022                	sd	s0,32(sp)
    800045ce:	ec26                	sd	s1,24(sp)
    800045d0:	e84a                	sd	s2,16(sp)
    800045d2:	e44e                	sd	s3,8(sp)
    800045d4:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    800045d6:	00854783          	lbu	a5,8(a0)
    800045da:	c3d5                	beqz	a5,8000467e <fileread+0xb6>
    800045dc:	84aa                	mv	s1,a0
    800045de:	89ae                	mv	s3,a1
    800045e0:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    800045e2:	411c                	lw	a5,0(a0)
    800045e4:	4705                	li	a4,1
    800045e6:	04e78963          	beq	a5,a4,80004638 <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    800045ea:	470d                	li	a4,3
    800045ec:	04e78d63          	beq	a5,a4,80004646 <fileread+0x7e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    800045f0:	4709                	li	a4,2
    800045f2:	06e79e63          	bne	a5,a4,8000466e <fileread+0xa6>
    ilock(f->ip);
    800045f6:	6d08                	ld	a0,24(a0)
    800045f8:	fffff097          	auipc	ra,0xfffff
    800045fc:	002080e7          	jalr	2(ra) # 800035fa <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80004600:	874a                	mv	a4,s2
    80004602:	5094                	lw	a3,32(s1)
    80004604:	864e                	mv	a2,s3
    80004606:	4585                	li	a1,1
    80004608:	6c88                	ld	a0,24(s1)
    8000460a:	fffff097          	auipc	ra,0xfffff
    8000460e:	2a4080e7          	jalr	676(ra) # 800038ae <readi>
    80004612:	892a                	mv	s2,a0
    80004614:	00a05563          	blez	a0,8000461e <fileread+0x56>
      f->off += r;
    80004618:	509c                	lw	a5,32(s1)
    8000461a:	9fa9                	addw	a5,a5,a0
    8000461c:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    8000461e:	6c88                	ld	a0,24(s1)
    80004620:	fffff097          	auipc	ra,0xfffff
    80004624:	09c080e7          	jalr	156(ra) # 800036bc <iunlock>
  } else {
    panic("fileread");
  }

  return r;
}
    80004628:	854a                	mv	a0,s2
    8000462a:	70a2                	ld	ra,40(sp)
    8000462c:	7402                	ld	s0,32(sp)
    8000462e:	64e2                	ld	s1,24(sp)
    80004630:	6942                	ld	s2,16(sp)
    80004632:	69a2                	ld	s3,8(sp)
    80004634:	6145                	addi	sp,sp,48
    80004636:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80004638:	6908                	ld	a0,16(a0)
    8000463a:	00000097          	auipc	ra,0x0
    8000463e:	3f6080e7          	jalr	1014(ra) # 80004a30 <piperead>
    80004642:	892a                	mv	s2,a0
    80004644:	b7d5                	j	80004628 <fileread+0x60>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80004646:	02451783          	lh	a5,36(a0)
    8000464a:	03079693          	slli	a3,a5,0x30
    8000464e:	92c1                	srli	a3,a3,0x30
    80004650:	4725                	li	a4,9
    80004652:	02d76863          	bltu	a4,a3,80004682 <fileread+0xba>
    80004656:	0792                	slli	a5,a5,0x4
    80004658:	0001d717          	auipc	a4,0x1d
    8000465c:	35870713          	addi	a4,a4,856 # 800219b0 <devsw>
    80004660:	97ba                	add	a5,a5,a4
    80004662:	639c                	ld	a5,0(a5)
    80004664:	c38d                	beqz	a5,80004686 <fileread+0xbe>
    r = devsw[f->major].read(1, addr, n);
    80004666:	4505                	li	a0,1
    80004668:	9782                	jalr	a5
    8000466a:	892a                	mv	s2,a0
    8000466c:	bf75                	j	80004628 <fileread+0x60>
    panic("fileread");
    8000466e:	00004517          	auipc	a0,0x4
    80004672:	01250513          	addi	a0,a0,18 # 80008680 <syscalls+0x258>
    80004676:	ffffc097          	auipc	ra,0xffffc
    8000467a:	ed0080e7          	jalr	-304(ra) # 80000546 <panic>
    return -1;
    8000467e:	597d                	li	s2,-1
    80004680:	b765                	j	80004628 <fileread+0x60>
      return -1;
    80004682:	597d                	li	s2,-1
    80004684:	b755                	j	80004628 <fileread+0x60>
    80004686:	597d                	li	s2,-1
    80004688:	b745                	j	80004628 <fileread+0x60>

000000008000468a <filewrite>:
int
filewrite(struct file *f, uint64 addr, int n)
{
  int r, ret = 0;

  if(f->writable == 0)
    8000468a:	00954783          	lbu	a5,9(a0)
    8000468e:	14078563          	beqz	a5,800047d8 <filewrite+0x14e>
{
    80004692:	715d                	addi	sp,sp,-80
    80004694:	e486                	sd	ra,72(sp)
    80004696:	e0a2                	sd	s0,64(sp)
    80004698:	fc26                	sd	s1,56(sp)
    8000469a:	f84a                	sd	s2,48(sp)
    8000469c:	f44e                	sd	s3,40(sp)
    8000469e:	f052                	sd	s4,32(sp)
    800046a0:	ec56                	sd	s5,24(sp)
    800046a2:	e85a                	sd	s6,16(sp)
    800046a4:	e45e                	sd	s7,8(sp)
    800046a6:	e062                	sd	s8,0(sp)
    800046a8:	0880                	addi	s0,sp,80
    800046aa:	892a                	mv	s2,a0
    800046ac:	8b2e                	mv	s6,a1
    800046ae:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    800046b0:	411c                	lw	a5,0(a0)
    800046b2:	4705                	li	a4,1
    800046b4:	02e78263          	beq	a5,a4,800046d8 <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    800046b8:	470d                	li	a4,3
    800046ba:	02e78563          	beq	a5,a4,800046e4 <filewrite+0x5a>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    800046be:	4709                	li	a4,2
    800046c0:	10e79463          	bne	a5,a4,800047c8 <filewrite+0x13e>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    800046c4:	0ec05e63          	blez	a2,800047c0 <filewrite+0x136>
    int i = 0;
    800046c8:	4981                	li	s3,0
    800046ca:	6b85                	lui	s7,0x1
    800046cc:	c00b8b93          	addi	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    800046d0:	6c05                	lui	s8,0x1
    800046d2:	c00c0c1b          	addiw	s8,s8,-1024 # c00 <_entry-0x7ffff400>
    800046d6:	a851                	j	8000476a <filewrite+0xe0>
    ret = pipewrite(f->pipe, addr, n);
    800046d8:	6908                	ld	a0,16(a0)
    800046da:	00000097          	auipc	ra,0x0
    800046de:	254080e7          	jalr	596(ra) # 8000492e <pipewrite>
    800046e2:	a85d                	j	80004798 <filewrite+0x10e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    800046e4:	02451783          	lh	a5,36(a0)
    800046e8:	03079693          	slli	a3,a5,0x30
    800046ec:	92c1                	srli	a3,a3,0x30
    800046ee:	4725                	li	a4,9
    800046f0:	0ed76663          	bltu	a4,a3,800047dc <filewrite+0x152>
    800046f4:	0792                	slli	a5,a5,0x4
    800046f6:	0001d717          	auipc	a4,0x1d
    800046fa:	2ba70713          	addi	a4,a4,698 # 800219b0 <devsw>
    800046fe:	97ba                	add	a5,a5,a4
    80004700:	679c                	ld	a5,8(a5)
    80004702:	cff9                	beqz	a5,800047e0 <filewrite+0x156>
    ret = devsw[f->major].write(1, addr, n);
    80004704:	4505                	li	a0,1
    80004706:	9782                	jalr	a5
    80004708:	a841                	j	80004798 <filewrite+0x10e>
    8000470a:	00048a9b          	sext.w	s5,s1
      int n1 = n - i;
      if(n1 > max)
        n1 = max;

      begin_op();
    8000470e:	00000097          	auipc	ra,0x0
    80004712:	8b2080e7          	jalr	-1870(ra) # 80003fc0 <begin_op>
      ilock(f->ip);
    80004716:	01893503          	ld	a0,24(s2)
    8000471a:	fffff097          	auipc	ra,0xfffff
    8000471e:	ee0080e7          	jalr	-288(ra) # 800035fa <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80004722:	8756                	mv	a4,s5
    80004724:	02092683          	lw	a3,32(s2)
    80004728:	01698633          	add	a2,s3,s6
    8000472c:	4585                	li	a1,1
    8000472e:	01893503          	ld	a0,24(s2)
    80004732:	fffff097          	auipc	ra,0xfffff
    80004736:	272080e7          	jalr	626(ra) # 800039a4 <writei>
    8000473a:	84aa                	mv	s1,a0
    8000473c:	02a05f63          	blez	a0,8000477a <filewrite+0xf0>
        f->off += r;
    80004740:	02092783          	lw	a5,32(s2)
    80004744:	9fa9                	addw	a5,a5,a0
    80004746:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    8000474a:	01893503          	ld	a0,24(s2)
    8000474e:	fffff097          	auipc	ra,0xfffff
    80004752:	f6e080e7          	jalr	-146(ra) # 800036bc <iunlock>
      end_op();
    80004756:	00000097          	auipc	ra,0x0
    8000475a:	8e8080e7          	jalr	-1816(ra) # 8000403e <end_op>

      if(r < 0)
        break;
      if(r != n1)
    8000475e:	049a9963          	bne	s5,s1,800047b0 <filewrite+0x126>
        panic("short filewrite");
      i += r;
    80004762:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80004766:	0349d663          	bge	s3,s4,80004792 <filewrite+0x108>
      int n1 = n - i;
    8000476a:	413a04bb          	subw	s1,s4,s3
    8000476e:	0004879b          	sext.w	a5,s1
    80004772:	f8fbdce3          	bge	s7,a5,8000470a <filewrite+0x80>
    80004776:	84e2                	mv	s1,s8
    80004778:	bf49                	j	8000470a <filewrite+0x80>
      iunlock(f->ip);
    8000477a:	01893503          	ld	a0,24(s2)
    8000477e:	fffff097          	auipc	ra,0xfffff
    80004782:	f3e080e7          	jalr	-194(ra) # 800036bc <iunlock>
      end_op();
    80004786:	00000097          	auipc	ra,0x0
    8000478a:	8b8080e7          	jalr	-1864(ra) # 8000403e <end_op>
      if(r < 0)
    8000478e:	fc04d8e3          	bgez	s1,8000475e <filewrite+0xd4>
    }
    ret = (i == n ? n : -1);
    80004792:	8552                	mv	a0,s4
    80004794:	033a1863          	bne	s4,s3,800047c4 <filewrite+0x13a>
  } else {
    panic("filewrite");
  }

  return ret;
}
    80004798:	60a6                	ld	ra,72(sp)
    8000479a:	6406                	ld	s0,64(sp)
    8000479c:	74e2                	ld	s1,56(sp)
    8000479e:	7942                	ld	s2,48(sp)
    800047a0:	79a2                	ld	s3,40(sp)
    800047a2:	7a02                	ld	s4,32(sp)
    800047a4:	6ae2                	ld	s5,24(sp)
    800047a6:	6b42                	ld	s6,16(sp)
    800047a8:	6ba2                	ld	s7,8(sp)
    800047aa:	6c02                	ld	s8,0(sp)
    800047ac:	6161                	addi	sp,sp,80
    800047ae:	8082                	ret
        panic("short filewrite");
    800047b0:	00004517          	auipc	a0,0x4
    800047b4:	ee050513          	addi	a0,a0,-288 # 80008690 <syscalls+0x268>
    800047b8:	ffffc097          	auipc	ra,0xffffc
    800047bc:	d8e080e7          	jalr	-626(ra) # 80000546 <panic>
    int i = 0;
    800047c0:	4981                	li	s3,0
    800047c2:	bfc1                	j	80004792 <filewrite+0x108>
    ret = (i == n ? n : -1);
    800047c4:	557d                	li	a0,-1
    800047c6:	bfc9                	j	80004798 <filewrite+0x10e>
    panic("filewrite");
    800047c8:	00004517          	auipc	a0,0x4
    800047cc:	ed850513          	addi	a0,a0,-296 # 800086a0 <syscalls+0x278>
    800047d0:	ffffc097          	auipc	ra,0xffffc
    800047d4:	d76080e7          	jalr	-650(ra) # 80000546 <panic>
    return -1;
    800047d8:	557d                	li	a0,-1
}
    800047da:	8082                	ret
      return -1;
    800047dc:	557d                	li	a0,-1
    800047de:	bf6d                	j	80004798 <filewrite+0x10e>
    800047e0:	557d                	li	a0,-1
    800047e2:	bf5d                	j	80004798 <filewrite+0x10e>

00000000800047e4 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    800047e4:	7179                	addi	sp,sp,-48
    800047e6:	f406                	sd	ra,40(sp)
    800047e8:	f022                	sd	s0,32(sp)
    800047ea:	ec26                	sd	s1,24(sp)
    800047ec:	e84a                	sd	s2,16(sp)
    800047ee:	e44e                	sd	s3,8(sp)
    800047f0:	e052                	sd	s4,0(sp)
    800047f2:	1800                	addi	s0,sp,48
    800047f4:	84aa                	mv	s1,a0
    800047f6:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    800047f8:	0005b023          	sd	zero,0(a1)
    800047fc:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80004800:	00000097          	auipc	ra,0x0
    80004804:	bd2080e7          	jalr	-1070(ra) # 800043d2 <filealloc>
    80004808:	e088                	sd	a0,0(s1)
    8000480a:	c551                	beqz	a0,80004896 <pipealloc+0xb2>
    8000480c:	00000097          	auipc	ra,0x0
    80004810:	bc6080e7          	jalr	-1082(ra) # 800043d2 <filealloc>
    80004814:	00aa3023          	sd	a0,0(s4)
    80004818:	c92d                	beqz	a0,8000488a <pipealloc+0xa6>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    8000481a:	ffffc097          	auipc	ra,0xffffc
    8000481e:	2f6080e7          	jalr	758(ra) # 80000b10 <kalloc>
    80004822:	892a                	mv	s2,a0
    80004824:	c125                	beqz	a0,80004884 <pipealloc+0xa0>
    goto bad;
  pi->readopen = 1;
    80004826:	4985                	li	s3,1
    80004828:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    8000482c:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80004830:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80004834:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80004838:	00004597          	auipc	a1,0x4
    8000483c:	e7858593          	addi	a1,a1,-392 # 800086b0 <syscalls+0x288>
    80004840:	ffffc097          	auipc	ra,0xffffc
    80004844:	330080e7          	jalr	816(ra) # 80000b70 <initlock>
  (*f0)->type = FD_PIPE;
    80004848:	609c                	ld	a5,0(s1)
    8000484a:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    8000484e:	609c                	ld	a5,0(s1)
    80004850:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80004854:	609c                	ld	a5,0(s1)
    80004856:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    8000485a:	609c                	ld	a5,0(s1)
    8000485c:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80004860:	000a3783          	ld	a5,0(s4)
    80004864:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80004868:	000a3783          	ld	a5,0(s4)
    8000486c:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80004870:	000a3783          	ld	a5,0(s4)
    80004874:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80004878:	000a3783          	ld	a5,0(s4)
    8000487c:	0127b823          	sd	s2,16(a5)
  return 0;
    80004880:	4501                	li	a0,0
    80004882:	a025                	j	800048aa <pipealloc+0xc6>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80004884:	6088                	ld	a0,0(s1)
    80004886:	e501                	bnez	a0,8000488e <pipealloc+0xaa>
    80004888:	a039                	j	80004896 <pipealloc+0xb2>
    8000488a:	6088                	ld	a0,0(s1)
    8000488c:	c51d                	beqz	a0,800048ba <pipealloc+0xd6>
    fileclose(*f0);
    8000488e:	00000097          	auipc	ra,0x0
    80004892:	c00080e7          	jalr	-1024(ra) # 8000448e <fileclose>
  if(*f1)
    80004896:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    8000489a:	557d                	li	a0,-1
  if(*f1)
    8000489c:	c799                	beqz	a5,800048aa <pipealloc+0xc6>
    fileclose(*f1);
    8000489e:	853e                	mv	a0,a5
    800048a0:	00000097          	auipc	ra,0x0
    800048a4:	bee080e7          	jalr	-1042(ra) # 8000448e <fileclose>
  return -1;
    800048a8:	557d                	li	a0,-1
}
    800048aa:	70a2                	ld	ra,40(sp)
    800048ac:	7402                	ld	s0,32(sp)
    800048ae:	64e2                	ld	s1,24(sp)
    800048b0:	6942                	ld	s2,16(sp)
    800048b2:	69a2                	ld	s3,8(sp)
    800048b4:	6a02                	ld	s4,0(sp)
    800048b6:	6145                	addi	sp,sp,48
    800048b8:	8082                	ret
  return -1;
    800048ba:	557d                	li	a0,-1
    800048bc:	b7fd                	j	800048aa <pipealloc+0xc6>

00000000800048be <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    800048be:	1101                	addi	sp,sp,-32
    800048c0:	ec06                	sd	ra,24(sp)
    800048c2:	e822                	sd	s0,16(sp)
    800048c4:	e426                	sd	s1,8(sp)
    800048c6:	e04a                	sd	s2,0(sp)
    800048c8:	1000                	addi	s0,sp,32
    800048ca:	84aa                	mv	s1,a0
    800048cc:	892e                	mv	s2,a1
  acquire(&pi->lock);
    800048ce:	ffffc097          	auipc	ra,0xffffc
    800048d2:	332080e7          	jalr	818(ra) # 80000c00 <acquire>
  if(writable){
    800048d6:	02090d63          	beqz	s2,80004910 <pipeclose+0x52>
    pi->writeopen = 0;
    800048da:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    800048de:	21848513          	addi	a0,s1,536
    800048e2:	ffffe097          	auipc	ra,0xffffe
    800048e6:	a7e080e7          	jalr	-1410(ra) # 80002360 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    800048ea:	2204b783          	ld	a5,544(s1)
    800048ee:	eb95                	bnez	a5,80004922 <pipeclose+0x64>
    release(&pi->lock);
    800048f0:	8526                	mv	a0,s1
    800048f2:	ffffc097          	auipc	ra,0xffffc
    800048f6:	3c2080e7          	jalr	962(ra) # 80000cb4 <release>
    kfree((char*)pi);
    800048fa:	8526                	mv	a0,s1
    800048fc:	ffffc097          	auipc	ra,0xffffc
    80004900:	116080e7          	jalr	278(ra) # 80000a12 <kfree>
  } else
    release(&pi->lock);
}
    80004904:	60e2                	ld	ra,24(sp)
    80004906:	6442                	ld	s0,16(sp)
    80004908:	64a2                	ld	s1,8(sp)
    8000490a:	6902                	ld	s2,0(sp)
    8000490c:	6105                	addi	sp,sp,32
    8000490e:	8082                	ret
    pi->readopen = 0;
    80004910:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80004914:	21c48513          	addi	a0,s1,540
    80004918:	ffffe097          	auipc	ra,0xffffe
    8000491c:	a48080e7          	jalr	-1464(ra) # 80002360 <wakeup>
    80004920:	b7e9                	j	800048ea <pipeclose+0x2c>
    release(&pi->lock);
    80004922:	8526                	mv	a0,s1
    80004924:	ffffc097          	auipc	ra,0xffffc
    80004928:	390080e7          	jalr	912(ra) # 80000cb4 <release>
}
    8000492c:	bfe1                	j	80004904 <pipeclose+0x46>

000000008000492e <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    8000492e:	711d                	addi	sp,sp,-96
    80004930:	ec86                	sd	ra,88(sp)
    80004932:	e8a2                	sd	s0,80(sp)
    80004934:	e4a6                	sd	s1,72(sp)
    80004936:	e0ca                	sd	s2,64(sp)
    80004938:	fc4e                	sd	s3,56(sp)
    8000493a:	f852                	sd	s4,48(sp)
    8000493c:	f456                	sd	s5,40(sp)
    8000493e:	f05a                	sd	s6,32(sp)
    80004940:	ec5e                	sd	s7,24(sp)
    80004942:	e862                	sd	s8,16(sp)
    80004944:	1080                	addi	s0,sp,96
    80004946:	84aa                	mv	s1,a0
    80004948:	8b2e                	mv	s6,a1
    8000494a:	8ab2                	mv	s5,a2
  int i;
  char ch;
  struct proc *pr = myproc();
    8000494c:	ffffd097          	auipc	ra,0xffffd
    80004950:	080080e7          	jalr	128(ra) # 800019cc <myproc>
    80004954:	892a                	mv	s2,a0

  acquire(&pi->lock);
    80004956:	8526                	mv	a0,s1
    80004958:	ffffc097          	auipc	ra,0xffffc
    8000495c:	2a8080e7          	jalr	680(ra) # 80000c00 <acquire>
  for(i = 0; i < n; i++){
    80004960:	09505863          	blez	s5,800049f0 <pipewrite+0xc2>
    80004964:	4b81                	li	s7,0
    while(pi->nwrite == pi->nread + PIPESIZE){  //DOC: pipewrite-full
      if(pi->readopen == 0 || pr->killed){
        release(&pi->lock);
        return -1;
      }
      wakeup(&pi->nread);
    80004966:	21848a13          	addi	s4,s1,536
      sleep(&pi->nwrite, &pi->lock);
    8000496a:	21c48993          	addi	s3,s1,540
    }
    if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    8000496e:	5c7d                	li	s8,-1
    while(pi->nwrite == pi->nread + PIPESIZE){  //DOC: pipewrite-full
    80004970:	2184a783          	lw	a5,536(s1)
    80004974:	21c4a703          	lw	a4,540(s1)
    80004978:	2007879b          	addiw	a5,a5,512
    8000497c:	02f71b63          	bne	a4,a5,800049b2 <pipewrite+0x84>
      if(pi->readopen == 0 || pr->killed){
    80004980:	2204a783          	lw	a5,544(s1)
    80004984:	c3d9                	beqz	a5,80004a0a <pipewrite+0xdc>
    80004986:	03092783          	lw	a5,48(s2)
    8000498a:	e3c1                	bnez	a5,80004a0a <pipewrite+0xdc>
      wakeup(&pi->nread);
    8000498c:	8552                	mv	a0,s4
    8000498e:	ffffe097          	auipc	ra,0xffffe
    80004992:	9d2080e7          	jalr	-1582(ra) # 80002360 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80004996:	85a6                	mv	a1,s1
    80004998:	854e                	mv	a0,s3
    8000499a:	ffffe097          	auipc	ra,0xffffe
    8000499e:	846080e7          	jalr	-1978(ra) # 800021e0 <sleep>
    while(pi->nwrite == pi->nread + PIPESIZE){  //DOC: pipewrite-full
    800049a2:	2184a783          	lw	a5,536(s1)
    800049a6:	21c4a703          	lw	a4,540(s1)
    800049aa:	2007879b          	addiw	a5,a5,512
    800049ae:	fcf709e3          	beq	a4,a5,80004980 <pipewrite+0x52>
    if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    800049b2:	4685                	li	a3,1
    800049b4:	865a                	mv	a2,s6
    800049b6:	faf40593          	addi	a1,s0,-81
    800049ba:	05093503          	ld	a0,80(s2)
    800049be:	ffffd097          	auipc	ra,0xffffd
    800049c2:	d90080e7          	jalr	-624(ra) # 8000174e <copyin>
    800049c6:	03850663          	beq	a0,s8,800049f2 <pipewrite+0xc4>
      break;
    pi->data[pi->nwrite++ % PIPESIZE] = ch;
    800049ca:	21c4a783          	lw	a5,540(s1)
    800049ce:	0017871b          	addiw	a4,a5,1
    800049d2:	20e4ae23          	sw	a4,540(s1)
    800049d6:	1ff7f793          	andi	a5,a5,511
    800049da:	97a6                	add	a5,a5,s1
    800049dc:	faf44703          	lbu	a4,-81(s0)
    800049e0:	00e78c23          	sb	a4,24(a5)
  for(i = 0; i < n; i++){
    800049e4:	2b85                	addiw	s7,s7,1
    800049e6:	0b05                	addi	s6,s6,1
    800049e8:	f97a94e3          	bne	s5,s7,80004970 <pipewrite+0x42>
    800049ec:	8bd6                	mv	s7,s5
    800049ee:	a011                	j	800049f2 <pipewrite+0xc4>
    800049f0:	4b81                	li	s7,0
  }
  wakeup(&pi->nread);
    800049f2:	21848513          	addi	a0,s1,536
    800049f6:	ffffe097          	auipc	ra,0xffffe
    800049fa:	96a080e7          	jalr	-1686(ra) # 80002360 <wakeup>
  release(&pi->lock);
    800049fe:	8526                	mv	a0,s1
    80004a00:	ffffc097          	auipc	ra,0xffffc
    80004a04:	2b4080e7          	jalr	692(ra) # 80000cb4 <release>
  return i;
    80004a08:	a039                	j	80004a16 <pipewrite+0xe8>
        release(&pi->lock);
    80004a0a:	8526                	mv	a0,s1
    80004a0c:	ffffc097          	auipc	ra,0xffffc
    80004a10:	2a8080e7          	jalr	680(ra) # 80000cb4 <release>
        return -1;
    80004a14:	5bfd                	li	s7,-1
}
    80004a16:	855e                	mv	a0,s7
    80004a18:	60e6                	ld	ra,88(sp)
    80004a1a:	6446                	ld	s0,80(sp)
    80004a1c:	64a6                	ld	s1,72(sp)
    80004a1e:	6906                	ld	s2,64(sp)
    80004a20:	79e2                	ld	s3,56(sp)
    80004a22:	7a42                	ld	s4,48(sp)
    80004a24:	7aa2                	ld	s5,40(sp)
    80004a26:	7b02                	ld	s6,32(sp)
    80004a28:	6be2                	ld	s7,24(sp)
    80004a2a:	6c42                	ld	s8,16(sp)
    80004a2c:	6125                	addi	sp,sp,96
    80004a2e:	8082                	ret

0000000080004a30 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80004a30:	715d                	addi	sp,sp,-80
    80004a32:	e486                	sd	ra,72(sp)
    80004a34:	e0a2                	sd	s0,64(sp)
    80004a36:	fc26                	sd	s1,56(sp)
    80004a38:	f84a                	sd	s2,48(sp)
    80004a3a:	f44e                	sd	s3,40(sp)
    80004a3c:	f052                	sd	s4,32(sp)
    80004a3e:	ec56                	sd	s5,24(sp)
    80004a40:	e85a                	sd	s6,16(sp)
    80004a42:	0880                	addi	s0,sp,80
    80004a44:	84aa                	mv	s1,a0
    80004a46:	892e                	mv	s2,a1
    80004a48:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80004a4a:	ffffd097          	auipc	ra,0xffffd
    80004a4e:	f82080e7          	jalr	-126(ra) # 800019cc <myproc>
    80004a52:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    80004a54:	8526                	mv	a0,s1
    80004a56:	ffffc097          	auipc	ra,0xffffc
    80004a5a:	1aa080e7          	jalr	426(ra) # 80000c00 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004a5e:	2184a703          	lw	a4,536(s1)
    80004a62:	21c4a783          	lw	a5,540(s1)
    if(pr->killed){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004a66:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004a6a:	02f71463          	bne	a4,a5,80004a92 <piperead+0x62>
    80004a6e:	2244a783          	lw	a5,548(s1)
    80004a72:	c385                	beqz	a5,80004a92 <piperead+0x62>
    if(pr->killed){
    80004a74:	030a2783          	lw	a5,48(s4)
    80004a78:	ebc9                	bnez	a5,80004b0a <piperead+0xda>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004a7a:	85a6                	mv	a1,s1
    80004a7c:	854e                	mv	a0,s3
    80004a7e:	ffffd097          	auipc	ra,0xffffd
    80004a82:	762080e7          	jalr	1890(ra) # 800021e0 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004a86:	2184a703          	lw	a4,536(s1)
    80004a8a:	21c4a783          	lw	a5,540(s1)
    80004a8e:	fef700e3          	beq	a4,a5,80004a6e <piperead+0x3e>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004a92:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004a94:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004a96:	05505463          	blez	s5,80004ade <piperead+0xae>
    if(pi->nread == pi->nwrite)
    80004a9a:	2184a783          	lw	a5,536(s1)
    80004a9e:	21c4a703          	lw	a4,540(s1)
    80004aa2:	02f70e63          	beq	a4,a5,80004ade <piperead+0xae>
    ch = pi->data[pi->nread++ % PIPESIZE];
    80004aa6:	0017871b          	addiw	a4,a5,1
    80004aaa:	20e4ac23          	sw	a4,536(s1)
    80004aae:	1ff7f793          	andi	a5,a5,511
    80004ab2:	97a6                	add	a5,a5,s1
    80004ab4:	0187c783          	lbu	a5,24(a5)
    80004ab8:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004abc:	4685                	li	a3,1
    80004abe:	fbf40613          	addi	a2,s0,-65
    80004ac2:	85ca                	mv	a1,s2
    80004ac4:	050a3503          	ld	a0,80(s4)
    80004ac8:	ffffd097          	auipc	ra,0xffffd
    80004acc:	bfa080e7          	jalr	-1030(ra) # 800016c2 <copyout>
    80004ad0:	01650763          	beq	a0,s6,80004ade <piperead+0xae>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004ad4:	2985                	addiw	s3,s3,1
    80004ad6:	0905                	addi	s2,s2,1
    80004ad8:	fd3a91e3          	bne	s5,s3,80004a9a <piperead+0x6a>
    80004adc:	89d6                	mv	s3,s5
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    80004ade:	21c48513          	addi	a0,s1,540
    80004ae2:	ffffe097          	auipc	ra,0xffffe
    80004ae6:	87e080e7          	jalr	-1922(ra) # 80002360 <wakeup>
  release(&pi->lock);
    80004aea:	8526                	mv	a0,s1
    80004aec:	ffffc097          	auipc	ra,0xffffc
    80004af0:	1c8080e7          	jalr	456(ra) # 80000cb4 <release>
  return i;
}
    80004af4:	854e                	mv	a0,s3
    80004af6:	60a6                	ld	ra,72(sp)
    80004af8:	6406                	ld	s0,64(sp)
    80004afa:	74e2                	ld	s1,56(sp)
    80004afc:	7942                	ld	s2,48(sp)
    80004afe:	79a2                	ld	s3,40(sp)
    80004b00:	7a02                	ld	s4,32(sp)
    80004b02:	6ae2                	ld	s5,24(sp)
    80004b04:	6b42                	ld	s6,16(sp)
    80004b06:	6161                	addi	sp,sp,80
    80004b08:	8082                	ret
      release(&pi->lock);
    80004b0a:	8526                	mv	a0,s1
    80004b0c:	ffffc097          	auipc	ra,0xffffc
    80004b10:	1a8080e7          	jalr	424(ra) # 80000cb4 <release>
      return -1;
    80004b14:	59fd                	li	s3,-1
    80004b16:	bff9                	j	80004af4 <piperead+0xc4>

0000000080004b18 <exec>:

static int loadseg(pde_t *pgdir, uint64 addr, struct inode *ip, uint offset, uint sz);

int
exec(char *path, char **argv)
{
    80004b18:	de010113          	addi	sp,sp,-544
    80004b1c:	20113c23          	sd	ra,536(sp)
    80004b20:	20813823          	sd	s0,528(sp)
    80004b24:	20913423          	sd	s1,520(sp)
    80004b28:	21213023          	sd	s2,512(sp)
    80004b2c:	ffce                	sd	s3,504(sp)
    80004b2e:	fbd2                	sd	s4,496(sp)
    80004b30:	f7d6                	sd	s5,488(sp)
    80004b32:	f3da                	sd	s6,480(sp)
    80004b34:	efde                	sd	s7,472(sp)
    80004b36:	ebe2                	sd	s8,464(sp)
    80004b38:	e7e6                	sd	s9,456(sp)
    80004b3a:	e3ea                	sd	s10,448(sp)
    80004b3c:	ff6e                	sd	s11,440(sp)
    80004b3e:	1400                	addi	s0,sp,544
    80004b40:	892a                	mv	s2,a0
    80004b42:	dea43423          	sd	a0,-536(s0)
    80004b46:	deb43823          	sd	a1,-528(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG+1], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    80004b4a:	ffffd097          	auipc	ra,0xffffd
    80004b4e:	e82080e7          	jalr	-382(ra) # 800019cc <myproc>
    80004b52:	84aa                	mv	s1,a0

  begin_op();
    80004b54:	fffff097          	auipc	ra,0xfffff
    80004b58:	46c080e7          	jalr	1132(ra) # 80003fc0 <begin_op>

  if((ip = namei(path)) == 0){
    80004b5c:	854a                	mv	a0,s2
    80004b5e:	fffff097          	auipc	ra,0xfffff
    80004b62:	252080e7          	jalr	594(ra) # 80003db0 <namei>
    80004b66:	c93d                	beqz	a0,80004bdc <exec+0xc4>
    80004b68:	8aaa                	mv	s5,a0
    end_op();
    return -1;
  }
  ilock(ip);
    80004b6a:	fffff097          	auipc	ra,0xfffff
    80004b6e:	a90080e7          	jalr	-1392(ra) # 800035fa <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    80004b72:	04000713          	li	a4,64
    80004b76:	4681                	li	a3,0
    80004b78:	e4840613          	addi	a2,s0,-440
    80004b7c:	4581                	li	a1,0
    80004b7e:	8556                	mv	a0,s5
    80004b80:	fffff097          	auipc	ra,0xfffff
    80004b84:	d2e080e7          	jalr	-722(ra) # 800038ae <readi>
    80004b88:	04000793          	li	a5,64
    80004b8c:	00f51a63          	bne	a0,a5,80004ba0 <exec+0x88>
    goto bad;
  if(elf.magic != ELF_MAGIC)
    80004b90:	e4842703          	lw	a4,-440(s0)
    80004b94:	464c47b7          	lui	a5,0x464c4
    80004b98:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    80004b9c:	04f70663          	beq	a4,a5,80004be8 <exec+0xd0>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    80004ba0:	8556                	mv	a0,s5
    80004ba2:	fffff097          	auipc	ra,0xfffff
    80004ba6:	cba080e7          	jalr	-838(ra) # 8000385c <iunlockput>
    end_op();
    80004baa:	fffff097          	auipc	ra,0xfffff
    80004bae:	494080e7          	jalr	1172(ra) # 8000403e <end_op>
  }
  return -1;
    80004bb2:	557d                	li	a0,-1
}
    80004bb4:	21813083          	ld	ra,536(sp)
    80004bb8:	21013403          	ld	s0,528(sp)
    80004bbc:	20813483          	ld	s1,520(sp)
    80004bc0:	20013903          	ld	s2,512(sp)
    80004bc4:	79fe                	ld	s3,504(sp)
    80004bc6:	7a5e                	ld	s4,496(sp)
    80004bc8:	7abe                	ld	s5,488(sp)
    80004bca:	7b1e                	ld	s6,480(sp)
    80004bcc:	6bfe                	ld	s7,472(sp)
    80004bce:	6c5e                	ld	s8,464(sp)
    80004bd0:	6cbe                	ld	s9,456(sp)
    80004bd2:	6d1e                	ld	s10,448(sp)
    80004bd4:	7dfa                	ld	s11,440(sp)
    80004bd6:	22010113          	addi	sp,sp,544
    80004bda:	8082                	ret
    end_op();
    80004bdc:	fffff097          	auipc	ra,0xfffff
    80004be0:	462080e7          	jalr	1122(ra) # 8000403e <end_op>
    return -1;
    80004be4:	557d                	li	a0,-1
    80004be6:	b7f9                	j	80004bb4 <exec+0x9c>
  if((pagetable = proc_pagetable(p)) == 0)
    80004be8:	8526                	mv	a0,s1
    80004bea:	ffffd097          	auipc	ra,0xffffd
    80004bee:	ea6080e7          	jalr	-346(ra) # 80001a90 <proc_pagetable>
    80004bf2:	8b2a                	mv	s6,a0
    80004bf4:	d555                	beqz	a0,80004ba0 <exec+0x88>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004bf6:	e6842783          	lw	a5,-408(s0)
    80004bfa:	e8045703          	lhu	a4,-384(s0)
    80004bfe:	c735                	beqz	a4,80004c6a <exec+0x152>
  uint64 argc, sz = 0, sp, ustack[MAXARG+1], stackbase;
    80004c00:	4481                	li	s1,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004c02:	e0043423          	sd	zero,-504(s0)
    if(ph.vaddr % PGSIZE != 0)
    80004c06:	6a05                	lui	s4,0x1
    80004c08:	fffa0713          	addi	a4,s4,-1 # fff <_entry-0x7ffff001>
    80004c0c:	dee43023          	sd	a4,-544(s0)
  uint64 pa;

  if((va % PGSIZE) != 0)
    panic("loadseg: va must be page aligned");

  for(i = 0; i < sz; i += PGSIZE){
    80004c10:	6d85                	lui	s11,0x1
    80004c12:	7d7d                	lui	s10,0xfffff
    80004c14:	ac1d                	j	80004e4a <exec+0x332>
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    80004c16:	00004517          	auipc	a0,0x4
    80004c1a:	aa250513          	addi	a0,a0,-1374 # 800086b8 <syscalls+0x290>
    80004c1e:	ffffc097          	auipc	ra,0xffffc
    80004c22:	928080e7          	jalr	-1752(ra) # 80000546 <panic>
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    80004c26:	874a                	mv	a4,s2
    80004c28:	009c86bb          	addw	a3,s9,s1
    80004c2c:	4581                	li	a1,0
    80004c2e:	8556                	mv	a0,s5
    80004c30:	fffff097          	auipc	ra,0xfffff
    80004c34:	c7e080e7          	jalr	-898(ra) # 800038ae <readi>
    80004c38:	2501                	sext.w	a0,a0
    80004c3a:	1aa91863          	bne	s2,a0,80004dea <exec+0x2d2>
  for(i = 0; i < sz; i += PGSIZE){
    80004c3e:	009d84bb          	addw	s1,s11,s1
    80004c42:	013d09bb          	addw	s3,s10,s3
    80004c46:	1f74f263          	bgeu	s1,s7,80004e2a <exec+0x312>
    pa = walkaddr(pagetable, va + i);
    80004c4a:	02049593          	slli	a1,s1,0x20
    80004c4e:	9181                	srli	a1,a1,0x20
    80004c50:	95e2                	add	a1,a1,s8
    80004c52:	855a                	mv	a0,s6
    80004c54:	ffffc097          	auipc	ra,0xffffc
    80004c58:	436080e7          	jalr	1078(ra) # 8000108a <walkaddr>
    80004c5c:	862a                	mv	a2,a0
    if(pa == 0)
    80004c5e:	dd45                	beqz	a0,80004c16 <exec+0xfe>
      n = PGSIZE;
    80004c60:	8952                	mv	s2,s4
    if(sz - i < PGSIZE)
    80004c62:	fd49f2e3          	bgeu	s3,s4,80004c26 <exec+0x10e>
      n = sz - i;
    80004c66:	894e                	mv	s2,s3
    80004c68:	bf7d                	j	80004c26 <exec+0x10e>
  uint64 argc, sz = 0, sp, ustack[MAXARG+1], stackbase;
    80004c6a:	4481                	li	s1,0
  iunlockput(ip);
    80004c6c:	8556                	mv	a0,s5
    80004c6e:	fffff097          	auipc	ra,0xfffff
    80004c72:	bee080e7          	jalr	-1042(ra) # 8000385c <iunlockput>
  end_op();
    80004c76:	fffff097          	auipc	ra,0xfffff
    80004c7a:	3c8080e7          	jalr	968(ra) # 8000403e <end_op>
  p = myproc();
    80004c7e:	ffffd097          	auipc	ra,0xffffd
    80004c82:	d4e080e7          	jalr	-690(ra) # 800019cc <myproc>
    80004c86:	8baa                	mv	s7,a0
  uint64 oldsz = p->sz;
    80004c88:	04853d03          	ld	s10,72(a0)
  sz = PGROUNDUP(sz);
    80004c8c:	6785                	lui	a5,0x1
    80004c8e:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80004c90:	97a6                	add	a5,a5,s1
    80004c92:	777d                	lui	a4,0xfffff
    80004c94:	8ff9                	and	a5,a5,a4
    80004c96:	def43c23          	sd	a5,-520(s0)
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    80004c9a:	6609                	lui	a2,0x2
    80004c9c:	963e                	add	a2,a2,a5
    80004c9e:	85be                	mv	a1,a5
    80004ca0:	855a                	mv	a0,s6
    80004ca2:	ffffc097          	auipc	ra,0xffffc
    80004ca6:	7cc080e7          	jalr	1996(ra) # 8000146e <uvmalloc>
    80004caa:	8c2a                	mv	s8,a0
  ip = 0;
    80004cac:	4a81                	li	s5,0
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    80004cae:	12050e63          	beqz	a0,80004dea <exec+0x2d2>
  uvmclear(pagetable, sz-2*PGSIZE);
    80004cb2:	75f9                	lui	a1,0xffffe
    80004cb4:	95aa                	add	a1,a1,a0
    80004cb6:	855a                	mv	a0,s6
    80004cb8:	ffffd097          	auipc	ra,0xffffd
    80004cbc:	9d8080e7          	jalr	-1576(ra) # 80001690 <uvmclear>
  stackbase = sp - PGSIZE;
    80004cc0:	7afd                	lui	s5,0xfffff
    80004cc2:	9ae2                	add	s5,s5,s8
  for(argc = 0; argv[argc]; argc++) {
    80004cc4:	df043783          	ld	a5,-528(s0)
    80004cc8:	6388                	ld	a0,0(a5)
    80004cca:	c925                	beqz	a0,80004d3a <exec+0x222>
    80004ccc:	e8840993          	addi	s3,s0,-376
    80004cd0:	f8840c93          	addi	s9,s0,-120
  sp = sz;
    80004cd4:	8962                	mv	s2,s8
  for(argc = 0; argv[argc]; argc++) {
    80004cd6:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    80004cd8:	ffffc097          	auipc	ra,0xffffc
    80004cdc:	1a8080e7          	jalr	424(ra) # 80000e80 <strlen>
    80004ce0:	0015079b          	addiw	a5,a0,1
    80004ce4:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    80004ce8:	ff07f913          	andi	s2,a5,-16
    if(sp < stackbase)
    80004cec:	13596363          	bltu	s2,s5,80004e12 <exec+0x2fa>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    80004cf0:	df043d83          	ld	s11,-528(s0)
    80004cf4:	000dba03          	ld	s4,0(s11) # 1000 <_entry-0x7ffff000>
    80004cf8:	8552                	mv	a0,s4
    80004cfa:	ffffc097          	auipc	ra,0xffffc
    80004cfe:	186080e7          	jalr	390(ra) # 80000e80 <strlen>
    80004d02:	0015069b          	addiw	a3,a0,1
    80004d06:	8652                	mv	a2,s4
    80004d08:	85ca                	mv	a1,s2
    80004d0a:	855a                	mv	a0,s6
    80004d0c:	ffffd097          	auipc	ra,0xffffd
    80004d10:	9b6080e7          	jalr	-1610(ra) # 800016c2 <copyout>
    80004d14:	10054363          	bltz	a0,80004e1a <exec+0x302>
    ustack[argc] = sp;
    80004d18:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    80004d1c:	0485                	addi	s1,s1,1
    80004d1e:	008d8793          	addi	a5,s11,8
    80004d22:	def43823          	sd	a5,-528(s0)
    80004d26:	008db503          	ld	a0,8(s11)
    80004d2a:	c911                	beqz	a0,80004d3e <exec+0x226>
    if(argc >= MAXARG)
    80004d2c:	09a1                	addi	s3,s3,8
    80004d2e:	fb3c95e3          	bne	s9,s3,80004cd8 <exec+0x1c0>
  sz = sz1;
    80004d32:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    80004d36:	4a81                	li	s5,0
    80004d38:	a84d                	j	80004dea <exec+0x2d2>
  sp = sz;
    80004d3a:	8962                	mv	s2,s8
  for(argc = 0; argv[argc]; argc++) {
    80004d3c:	4481                	li	s1,0
  ustack[argc] = 0;
    80004d3e:	00349793          	slli	a5,s1,0x3
    80004d42:	f9078793          	addi	a5,a5,-112
    80004d46:	97a2                	add	a5,a5,s0
    80004d48:	ee07bc23          	sd	zero,-264(a5)
  sp -= (argc+1) * sizeof(uint64);
    80004d4c:	00148693          	addi	a3,s1,1
    80004d50:	068e                	slli	a3,a3,0x3
    80004d52:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    80004d56:	ff097913          	andi	s2,s2,-16
  if(sp < stackbase)
    80004d5a:	01597663          	bgeu	s2,s5,80004d66 <exec+0x24e>
  sz = sz1;
    80004d5e:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    80004d62:	4a81                	li	s5,0
    80004d64:	a059                	j	80004dea <exec+0x2d2>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    80004d66:	e8840613          	addi	a2,s0,-376
    80004d6a:	85ca                	mv	a1,s2
    80004d6c:	855a                	mv	a0,s6
    80004d6e:	ffffd097          	auipc	ra,0xffffd
    80004d72:	954080e7          	jalr	-1708(ra) # 800016c2 <copyout>
    80004d76:	0a054663          	bltz	a0,80004e22 <exec+0x30a>
  p->trapframe->a1 = sp;
    80004d7a:	058bb783          	ld	a5,88(s7)
    80004d7e:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    80004d82:	de843783          	ld	a5,-536(s0)
    80004d86:	0007c703          	lbu	a4,0(a5)
    80004d8a:	cf11                	beqz	a4,80004da6 <exec+0x28e>
    80004d8c:	0785                	addi	a5,a5,1
    if(*s == '/')
    80004d8e:	02f00693          	li	a3,47
    80004d92:	a039                	j	80004da0 <exec+0x288>
      last = s+1;
    80004d94:	def43423          	sd	a5,-536(s0)
  for(last=s=path; *s; s++)
    80004d98:	0785                	addi	a5,a5,1
    80004d9a:	fff7c703          	lbu	a4,-1(a5)
    80004d9e:	c701                	beqz	a4,80004da6 <exec+0x28e>
    if(*s == '/')
    80004da0:	fed71ce3          	bne	a4,a3,80004d98 <exec+0x280>
    80004da4:	bfc5                	j	80004d94 <exec+0x27c>
  safestrcpy(p->name, last, sizeof(p->name));
    80004da6:	4641                	li	a2,16
    80004da8:	de843583          	ld	a1,-536(s0)
    80004dac:	158b8513          	addi	a0,s7,344
    80004db0:	ffffc097          	auipc	ra,0xffffc
    80004db4:	09e080e7          	jalr	158(ra) # 80000e4e <safestrcpy>
  oldpagetable = p->pagetable;
    80004db8:	050bb503          	ld	a0,80(s7)
  p->pagetable = pagetable;
    80004dbc:	056bb823          	sd	s6,80(s7)
  p->sz = sz;
    80004dc0:	058bb423          	sd	s8,72(s7)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    80004dc4:	058bb783          	ld	a5,88(s7)
    80004dc8:	e6043703          	ld	a4,-416(s0)
    80004dcc:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    80004dce:	058bb783          	ld	a5,88(s7)
    80004dd2:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    80004dd6:	85ea                	mv	a1,s10
    80004dd8:	ffffd097          	auipc	ra,0xffffd
    80004ddc:	d54080e7          	jalr	-684(ra) # 80001b2c <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    80004de0:	0004851b          	sext.w	a0,s1
    80004de4:	bbc1                	j	80004bb4 <exec+0x9c>
    80004de6:	de943c23          	sd	s1,-520(s0)
    proc_freepagetable(pagetable, sz);
    80004dea:	df843583          	ld	a1,-520(s0)
    80004dee:	855a                	mv	a0,s6
    80004df0:	ffffd097          	auipc	ra,0xffffd
    80004df4:	d3c080e7          	jalr	-708(ra) # 80001b2c <proc_freepagetable>
  if(ip){
    80004df8:	da0a94e3          	bnez	s5,80004ba0 <exec+0x88>
  return -1;
    80004dfc:	557d                	li	a0,-1
    80004dfe:	bb5d                	j	80004bb4 <exec+0x9c>
    80004e00:	de943c23          	sd	s1,-520(s0)
    80004e04:	b7dd                	j	80004dea <exec+0x2d2>
    80004e06:	de943c23          	sd	s1,-520(s0)
    80004e0a:	b7c5                	j	80004dea <exec+0x2d2>
    80004e0c:	de943c23          	sd	s1,-520(s0)
    80004e10:	bfe9                	j	80004dea <exec+0x2d2>
  sz = sz1;
    80004e12:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    80004e16:	4a81                	li	s5,0
    80004e18:	bfc9                	j	80004dea <exec+0x2d2>
  sz = sz1;
    80004e1a:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    80004e1e:	4a81                	li	s5,0
    80004e20:	b7e9                	j	80004dea <exec+0x2d2>
  sz = sz1;
    80004e22:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    80004e26:	4a81                	li	s5,0
    80004e28:	b7c9                	j	80004dea <exec+0x2d2>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    80004e2a:	df843483          	ld	s1,-520(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004e2e:	e0843783          	ld	a5,-504(s0)
    80004e32:	0017869b          	addiw	a3,a5,1
    80004e36:	e0d43423          	sd	a3,-504(s0)
    80004e3a:	e0043783          	ld	a5,-512(s0)
    80004e3e:	0387879b          	addiw	a5,a5,56
    80004e42:	e8045703          	lhu	a4,-384(s0)
    80004e46:	e2e6d3e3          	bge	a3,a4,80004c6c <exec+0x154>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80004e4a:	2781                	sext.w	a5,a5
    80004e4c:	e0f43023          	sd	a5,-512(s0)
    80004e50:	03800713          	li	a4,56
    80004e54:	86be                	mv	a3,a5
    80004e56:	e1040613          	addi	a2,s0,-496
    80004e5a:	4581                	li	a1,0
    80004e5c:	8556                	mv	a0,s5
    80004e5e:	fffff097          	auipc	ra,0xfffff
    80004e62:	a50080e7          	jalr	-1456(ra) # 800038ae <readi>
    80004e66:	03800793          	li	a5,56
    80004e6a:	f6f51ee3          	bne	a0,a5,80004de6 <exec+0x2ce>
    if(ph.type != ELF_PROG_LOAD)
    80004e6e:	e1042783          	lw	a5,-496(s0)
    80004e72:	4705                	li	a4,1
    80004e74:	fae79de3          	bne	a5,a4,80004e2e <exec+0x316>
    if(ph.memsz < ph.filesz)
    80004e78:	e3843603          	ld	a2,-456(s0)
    80004e7c:	e3043783          	ld	a5,-464(s0)
    80004e80:	f8f660e3          	bltu	a2,a5,80004e00 <exec+0x2e8>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    80004e84:	e2043783          	ld	a5,-480(s0)
    80004e88:	963e                	add	a2,a2,a5
    80004e8a:	f6f66ee3          	bltu	a2,a5,80004e06 <exec+0x2ee>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    80004e8e:	85a6                	mv	a1,s1
    80004e90:	855a                	mv	a0,s6
    80004e92:	ffffc097          	auipc	ra,0xffffc
    80004e96:	5dc080e7          	jalr	1500(ra) # 8000146e <uvmalloc>
    80004e9a:	dea43c23          	sd	a0,-520(s0)
    80004e9e:	d53d                	beqz	a0,80004e0c <exec+0x2f4>
    if(ph.vaddr % PGSIZE != 0)
    80004ea0:	e2043c03          	ld	s8,-480(s0)
    80004ea4:	de043783          	ld	a5,-544(s0)
    80004ea8:	00fc77b3          	and	a5,s8,a5
    80004eac:	ff9d                	bnez	a5,80004dea <exec+0x2d2>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80004eae:	e1842c83          	lw	s9,-488(s0)
    80004eb2:	e3042b83          	lw	s7,-464(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80004eb6:	f60b8ae3          	beqz	s7,80004e2a <exec+0x312>
    80004eba:	89de                	mv	s3,s7
    80004ebc:	4481                	li	s1,0
    80004ebe:	b371                	j	80004c4a <exec+0x132>

0000000080004ec0 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    80004ec0:	7179                	addi	sp,sp,-48
    80004ec2:	f406                	sd	ra,40(sp)
    80004ec4:	f022                	sd	s0,32(sp)
    80004ec6:	ec26                	sd	s1,24(sp)
    80004ec8:	e84a                	sd	s2,16(sp)
    80004eca:	1800                	addi	s0,sp,48
    80004ecc:	892e                	mv	s2,a1
    80004ece:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
    80004ed0:	fdc40593          	addi	a1,s0,-36
    80004ed4:	ffffe097          	auipc	ra,0xffffe
    80004ed8:	bb4080e7          	jalr	-1100(ra) # 80002a88 <argint>
    80004edc:	04054063          	bltz	a0,80004f1c <argfd+0x5c>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    80004ee0:	fdc42703          	lw	a4,-36(s0)
    80004ee4:	47bd                	li	a5,15
    80004ee6:	02e7ed63          	bltu	a5,a4,80004f20 <argfd+0x60>
    80004eea:	ffffd097          	auipc	ra,0xffffd
    80004eee:	ae2080e7          	jalr	-1310(ra) # 800019cc <myproc>
    80004ef2:	fdc42703          	lw	a4,-36(s0)
    80004ef6:	01a70793          	addi	a5,a4,26 # fffffffffffff01a <end+0xffffffff7ffd901a>
    80004efa:	078e                	slli	a5,a5,0x3
    80004efc:	953e                	add	a0,a0,a5
    80004efe:	611c                	ld	a5,0(a0)
    80004f00:	c395                	beqz	a5,80004f24 <argfd+0x64>
    return -1;
  if(pfd)
    80004f02:	00090463          	beqz	s2,80004f0a <argfd+0x4a>
    *pfd = fd;
    80004f06:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    80004f0a:	4501                	li	a0,0
  if(pf)
    80004f0c:	c091                	beqz	s1,80004f10 <argfd+0x50>
    *pf = f;
    80004f0e:	e09c                	sd	a5,0(s1)
}
    80004f10:	70a2                	ld	ra,40(sp)
    80004f12:	7402                	ld	s0,32(sp)
    80004f14:	64e2                	ld	s1,24(sp)
    80004f16:	6942                	ld	s2,16(sp)
    80004f18:	6145                	addi	sp,sp,48
    80004f1a:	8082                	ret
    return -1;
    80004f1c:	557d                	li	a0,-1
    80004f1e:	bfcd                	j	80004f10 <argfd+0x50>
    return -1;
    80004f20:	557d                	li	a0,-1
    80004f22:	b7fd                	j	80004f10 <argfd+0x50>
    80004f24:	557d                	li	a0,-1
    80004f26:	b7ed                	j	80004f10 <argfd+0x50>

0000000080004f28 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    80004f28:	1101                	addi	sp,sp,-32
    80004f2a:	ec06                	sd	ra,24(sp)
    80004f2c:	e822                	sd	s0,16(sp)
    80004f2e:	e426                	sd	s1,8(sp)
    80004f30:	1000                	addi	s0,sp,32
    80004f32:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    80004f34:	ffffd097          	auipc	ra,0xffffd
    80004f38:	a98080e7          	jalr	-1384(ra) # 800019cc <myproc>
    80004f3c:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    80004f3e:	0d050793          	addi	a5,a0,208
    80004f42:	4501                	li	a0,0
    80004f44:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    80004f46:	6398                	ld	a4,0(a5)
    80004f48:	cb19                	beqz	a4,80004f5e <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    80004f4a:	2505                	addiw	a0,a0,1
    80004f4c:	07a1                	addi	a5,a5,8
    80004f4e:	fed51ce3          	bne	a0,a3,80004f46 <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    80004f52:	557d                	li	a0,-1
}
    80004f54:	60e2                	ld	ra,24(sp)
    80004f56:	6442                	ld	s0,16(sp)
    80004f58:	64a2                	ld	s1,8(sp)
    80004f5a:	6105                	addi	sp,sp,32
    80004f5c:	8082                	ret
      p->ofile[fd] = f;
    80004f5e:	01a50793          	addi	a5,a0,26
    80004f62:	078e                	slli	a5,a5,0x3
    80004f64:	963e                	add	a2,a2,a5
    80004f66:	e204                	sd	s1,0(a2)
      return fd;
    80004f68:	b7f5                	j	80004f54 <fdalloc+0x2c>

0000000080004f6a <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    80004f6a:	715d                	addi	sp,sp,-80
    80004f6c:	e486                	sd	ra,72(sp)
    80004f6e:	e0a2                	sd	s0,64(sp)
    80004f70:	fc26                	sd	s1,56(sp)
    80004f72:	f84a                	sd	s2,48(sp)
    80004f74:	f44e                	sd	s3,40(sp)
    80004f76:	f052                	sd	s4,32(sp)
    80004f78:	ec56                	sd	s5,24(sp)
    80004f7a:	0880                	addi	s0,sp,80
    80004f7c:	89ae                	mv	s3,a1
    80004f7e:	8ab2                	mv	s5,a2
    80004f80:	8a36                	mv	s4,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    80004f82:	fb040593          	addi	a1,s0,-80
    80004f86:	fffff097          	auipc	ra,0xfffff
    80004f8a:	e48080e7          	jalr	-440(ra) # 80003dce <nameiparent>
    80004f8e:	892a                	mv	s2,a0
    80004f90:	12050e63          	beqz	a0,800050cc <create+0x162>
    return 0;

  ilock(dp);
    80004f94:	ffffe097          	auipc	ra,0xffffe
    80004f98:	666080e7          	jalr	1638(ra) # 800035fa <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    80004f9c:	4601                	li	a2,0
    80004f9e:	fb040593          	addi	a1,s0,-80
    80004fa2:	854a                	mv	a0,s2
    80004fa4:	fffff097          	auipc	ra,0xfffff
    80004fa8:	b34080e7          	jalr	-1228(ra) # 80003ad8 <dirlookup>
    80004fac:	84aa                	mv	s1,a0
    80004fae:	c921                	beqz	a0,80004ffe <create+0x94>
    iunlockput(dp);
    80004fb0:	854a                	mv	a0,s2
    80004fb2:	fffff097          	auipc	ra,0xfffff
    80004fb6:	8aa080e7          	jalr	-1878(ra) # 8000385c <iunlockput>
    ilock(ip);
    80004fba:	8526                	mv	a0,s1
    80004fbc:	ffffe097          	auipc	ra,0xffffe
    80004fc0:	63e080e7          	jalr	1598(ra) # 800035fa <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    80004fc4:	2981                	sext.w	s3,s3
    80004fc6:	4789                	li	a5,2
    80004fc8:	02f99463          	bne	s3,a5,80004ff0 <create+0x86>
    80004fcc:	0444d783          	lhu	a5,68(s1)
    80004fd0:	37f9                	addiw	a5,a5,-2
    80004fd2:	17c2                	slli	a5,a5,0x30
    80004fd4:	93c1                	srli	a5,a5,0x30
    80004fd6:	4705                	li	a4,1
    80004fd8:	00f76c63          	bltu	a4,a5,80004ff0 <create+0x86>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
    80004fdc:	8526                	mv	a0,s1
    80004fde:	60a6                	ld	ra,72(sp)
    80004fe0:	6406                	ld	s0,64(sp)
    80004fe2:	74e2                	ld	s1,56(sp)
    80004fe4:	7942                	ld	s2,48(sp)
    80004fe6:	79a2                	ld	s3,40(sp)
    80004fe8:	7a02                	ld	s4,32(sp)
    80004fea:	6ae2                	ld	s5,24(sp)
    80004fec:	6161                	addi	sp,sp,80
    80004fee:	8082                	ret
    iunlockput(ip);
    80004ff0:	8526                	mv	a0,s1
    80004ff2:	fffff097          	auipc	ra,0xfffff
    80004ff6:	86a080e7          	jalr	-1942(ra) # 8000385c <iunlockput>
    return 0;
    80004ffa:	4481                	li	s1,0
    80004ffc:	b7c5                	j	80004fdc <create+0x72>
  if((ip = ialloc(dp->dev, type)) == 0)
    80004ffe:	85ce                	mv	a1,s3
    80005000:	00092503          	lw	a0,0(s2)
    80005004:	ffffe097          	auipc	ra,0xffffe
    80005008:	45c080e7          	jalr	1116(ra) # 80003460 <ialloc>
    8000500c:	84aa                	mv	s1,a0
    8000500e:	c521                	beqz	a0,80005056 <create+0xec>
  ilock(ip);
    80005010:	ffffe097          	auipc	ra,0xffffe
    80005014:	5ea080e7          	jalr	1514(ra) # 800035fa <ilock>
  ip->major = major;
    80005018:	05549323          	sh	s5,70(s1)
  ip->minor = minor;
    8000501c:	05449423          	sh	s4,72(s1)
  ip->nlink = 1;
    80005020:	4a05                	li	s4,1
    80005022:	05449523          	sh	s4,74(s1)
  iupdate(ip);
    80005026:	8526                	mv	a0,s1
    80005028:	ffffe097          	auipc	ra,0xffffe
    8000502c:	506080e7          	jalr	1286(ra) # 8000352e <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    80005030:	2981                	sext.w	s3,s3
    80005032:	03498a63          	beq	s3,s4,80005066 <create+0xfc>
  if(dirlink(dp, name, ip->inum) < 0)
    80005036:	40d0                	lw	a2,4(s1)
    80005038:	fb040593          	addi	a1,s0,-80
    8000503c:	854a                	mv	a0,s2
    8000503e:	fffff097          	auipc	ra,0xfffff
    80005042:	cb0080e7          	jalr	-848(ra) # 80003cee <dirlink>
    80005046:	06054b63          	bltz	a0,800050bc <create+0x152>
  iunlockput(dp);
    8000504a:	854a                	mv	a0,s2
    8000504c:	fffff097          	auipc	ra,0xfffff
    80005050:	810080e7          	jalr	-2032(ra) # 8000385c <iunlockput>
  return ip;
    80005054:	b761                	j	80004fdc <create+0x72>
    panic("create: ialloc");
    80005056:	00003517          	auipc	a0,0x3
    8000505a:	68250513          	addi	a0,a0,1666 # 800086d8 <syscalls+0x2b0>
    8000505e:	ffffb097          	auipc	ra,0xffffb
    80005062:	4e8080e7          	jalr	1256(ra) # 80000546 <panic>
    dp->nlink++;  // for ".."
    80005066:	04a95783          	lhu	a5,74(s2)
    8000506a:	2785                	addiw	a5,a5,1
    8000506c:	04f91523          	sh	a5,74(s2)
    iupdate(dp);
    80005070:	854a                	mv	a0,s2
    80005072:	ffffe097          	auipc	ra,0xffffe
    80005076:	4bc080e7          	jalr	1212(ra) # 8000352e <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    8000507a:	40d0                	lw	a2,4(s1)
    8000507c:	00003597          	auipc	a1,0x3
    80005080:	66c58593          	addi	a1,a1,1644 # 800086e8 <syscalls+0x2c0>
    80005084:	8526                	mv	a0,s1
    80005086:	fffff097          	auipc	ra,0xfffff
    8000508a:	c68080e7          	jalr	-920(ra) # 80003cee <dirlink>
    8000508e:	00054f63          	bltz	a0,800050ac <create+0x142>
    80005092:	00492603          	lw	a2,4(s2)
    80005096:	00003597          	auipc	a1,0x3
    8000509a:	65a58593          	addi	a1,a1,1626 # 800086f0 <syscalls+0x2c8>
    8000509e:	8526                	mv	a0,s1
    800050a0:	fffff097          	auipc	ra,0xfffff
    800050a4:	c4e080e7          	jalr	-946(ra) # 80003cee <dirlink>
    800050a8:	f80557e3          	bgez	a0,80005036 <create+0xcc>
      panic("create dots");
    800050ac:	00003517          	auipc	a0,0x3
    800050b0:	64c50513          	addi	a0,a0,1612 # 800086f8 <syscalls+0x2d0>
    800050b4:	ffffb097          	auipc	ra,0xffffb
    800050b8:	492080e7          	jalr	1170(ra) # 80000546 <panic>
    panic("create: dirlink");
    800050bc:	00003517          	auipc	a0,0x3
    800050c0:	64c50513          	addi	a0,a0,1612 # 80008708 <syscalls+0x2e0>
    800050c4:	ffffb097          	auipc	ra,0xffffb
    800050c8:	482080e7          	jalr	1154(ra) # 80000546 <panic>
    return 0;
    800050cc:	84aa                	mv	s1,a0
    800050ce:	b739                	j	80004fdc <create+0x72>

00000000800050d0 <sys_dup>:
{
    800050d0:	7179                	addi	sp,sp,-48
    800050d2:	f406                	sd	ra,40(sp)
    800050d4:	f022                	sd	s0,32(sp)
    800050d6:	ec26                	sd	s1,24(sp)
    800050d8:	e84a                	sd	s2,16(sp)
    800050da:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    800050dc:	fd840613          	addi	a2,s0,-40
    800050e0:	4581                	li	a1,0
    800050e2:	4501                	li	a0,0
    800050e4:	00000097          	auipc	ra,0x0
    800050e8:	ddc080e7          	jalr	-548(ra) # 80004ec0 <argfd>
    return -1;
    800050ec:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    800050ee:	02054363          	bltz	a0,80005114 <sys_dup+0x44>
  if((fd=fdalloc(f)) < 0)
    800050f2:	fd843903          	ld	s2,-40(s0)
    800050f6:	854a                	mv	a0,s2
    800050f8:	00000097          	auipc	ra,0x0
    800050fc:	e30080e7          	jalr	-464(ra) # 80004f28 <fdalloc>
    80005100:	84aa                	mv	s1,a0
    return -1;
    80005102:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    80005104:	00054863          	bltz	a0,80005114 <sys_dup+0x44>
  filedup(f);
    80005108:	854a                	mv	a0,s2
    8000510a:	fffff097          	auipc	ra,0xfffff
    8000510e:	332080e7          	jalr	818(ra) # 8000443c <filedup>
  return fd;
    80005112:	87a6                	mv	a5,s1
}
    80005114:	853e                	mv	a0,a5
    80005116:	70a2                	ld	ra,40(sp)
    80005118:	7402                	ld	s0,32(sp)
    8000511a:	64e2                	ld	s1,24(sp)
    8000511c:	6942                	ld	s2,16(sp)
    8000511e:	6145                	addi	sp,sp,48
    80005120:	8082                	ret

0000000080005122 <sys_read>:
{
    80005122:	7179                	addi	sp,sp,-48
    80005124:	f406                	sd	ra,40(sp)
    80005126:	f022                	sd	s0,32(sp)
    80005128:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000512a:	fe840613          	addi	a2,s0,-24
    8000512e:	4581                	li	a1,0
    80005130:	4501                	li	a0,0
    80005132:	00000097          	auipc	ra,0x0
    80005136:	d8e080e7          	jalr	-626(ra) # 80004ec0 <argfd>
    return -1;
    8000513a:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000513c:	04054163          	bltz	a0,8000517e <sys_read+0x5c>
    80005140:	fe440593          	addi	a1,s0,-28
    80005144:	4509                	li	a0,2
    80005146:	ffffe097          	auipc	ra,0xffffe
    8000514a:	942080e7          	jalr	-1726(ra) # 80002a88 <argint>
    return -1;
    8000514e:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80005150:	02054763          	bltz	a0,8000517e <sys_read+0x5c>
    80005154:	fd840593          	addi	a1,s0,-40
    80005158:	4505                	li	a0,1
    8000515a:	ffffe097          	auipc	ra,0xffffe
    8000515e:	950080e7          	jalr	-1712(ra) # 80002aaa <argaddr>
    return -1;
    80005162:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80005164:	00054d63          	bltz	a0,8000517e <sys_read+0x5c>
  return fileread(f, p, n);
    80005168:	fe442603          	lw	a2,-28(s0)
    8000516c:	fd843583          	ld	a1,-40(s0)
    80005170:	fe843503          	ld	a0,-24(s0)
    80005174:	fffff097          	auipc	ra,0xfffff
    80005178:	454080e7          	jalr	1108(ra) # 800045c8 <fileread>
    8000517c:	87aa                	mv	a5,a0
}
    8000517e:	853e                	mv	a0,a5
    80005180:	70a2                	ld	ra,40(sp)
    80005182:	7402                	ld	s0,32(sp)
    80005184:	6145                	addi	sp,sp,48
    80005186:	8082                	ret

0000000080005188 <sys_write>:
{
    80005188:	7179                	addi	sp,sp,-48
    8000518a:	f406                	sd	ra,40(sp)
    8000518c:	f022                	sd	s0,32(sp)
    8000518e:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80005190:	fe840613          	addi	a2,s0,-24
    80005194:	4581                	li	a1,0
    80005196:	4501                	li	a0,0
    80005198:	00000097          	auipc	ra,0x0
    8000519c:	d28080e7          	jalr	-728(ra) # 80004ec0 <argfd>
    return -1;
    800051a0:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800051a2:	04054163          	bltz	a0,800051e4 <sys_write+0x5c>
    800051a6:	fe440593          	addi	a1,s0,-28
    800051aa:	4509                	li	a0,2
    800051ac:	ffffe097          	auipc	ra,0xffffe
    800051b0:	8dc080e7          	jalr	-1828(ra) # 80002a88 <argint>
    return -1;
    800051b4:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800051b6:	02054763          	bltz	a0,800051e4 <sys_write+0x5c>
    800051ba:	fd840593          	addi	a1,s0,-40
    800051be:	4505                	li	a0,1
    800051c0:	ffffe097          	auipc	ra,0xffffe
    800051c4:	8ea080e7          	jalr	-1814(ra) # 80002aaa <argaddr>
    return -1;
    800051c8:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800051ca:	00054d63          	bltz	a0,800051e4 <sys_write+0x5c>
  return filewrite(f, p, n);
    800051ce:	fe442603          	lw	a2,-28(s0)
    800051d2:	fd843583          	ld	a1,-40(s0)
    800051d6:	fe843503          	ld	a0,-24(s0)
    800051da:	fffff097          	auipc	ra,0xfffff
    800051de:	4b0080e7          	jalr	1200(ra) # 8000468a <filewrite>
    800051e2:	87aa                	mv	a5,a0
}
    800051e4:	853e                	mv	a0,a5
    800051e6:	70a2                	ld	ra,40(sp)
    800051e8:	7402                	ld	s0,32(sp)
    800051ea:	6145                	addi	sp,sp,48
    800051ec:	8082                	ret

00000000800051ee <sys_close>:
{
    800051ee:	1101                	addi	sp,sp,-32
    800051f0:	ec06                	sd	ra,24(sp)
    800051f2:	e822                	sd	s0,16(sp)
    800051f4:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    800051f6:	fe040613          	addi	a2,s0,-32
    800051fa:	fec40593          	addi	a1,s0,-20
    800051fe:	4501                	li	a0,0
    80005200:	00000097          	auipc	ra,0x0
    80005204:	cc0080e7          	jalr	-832(ra) # 80004ec0 <argfd>
    return -1;
    80005208:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    8000520a:	02054463          	bltz	a0,80005232 <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    8000520e:	ffffc097          	auipc	ra,0xffffc
    80005212:	7be080e7          	jalr	1982(ra) # 800019cc <myproc>
    80005216:	fec42783          	lw	a5,-20(s0)
    8000521a:	07e9                	addi	a5,a5,26
    8000521c:	078e                	slli	a5,a5,0x3
    8000521e:	953e                	add	a0,a0,a5
    80005220:	00053023          	sd	zero,0(a0)
  fileclose(f);
    80005224:	fe043503          	ld	a0,-32(s0)
    80005228:	fffff097          	auipc	ra,0xfffff
    8000522c:	266080e7          	jalr	614(ra) # 8000448e <fileclose>
  return 0;
    80005230:	4781                	li	a5,0
}
    80005232:	853e                	mv	a0,a5
    80005234:	60e2                	ld	ra,24(sp)
    80005236:	6442                	ld	s0,16(sp)
    80005238:	6105                	addi	sp,sp,32
    8000523a:	8082                	ret

000000008000523c <sys_fstat>:
{
    8000523c:	1101                	addi	sp,sp,-32
    8000523e:	ec06                	sd	ra,24(sp)
    80005240:	e822                	sd	s0,16(sp)
    80005242:	1000                	addi	s0,sp,32
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    80005244:	fe840613          	addi	a2,s0,-24
    80005248:	4581                	li	a1,0
    8000524a:	4501                	li	a0,0
    8000524c:	00000097          	auipc	ra,0x0
    80005250:	c74080e7          	jalr	-908(ra) # 80004ec0 <argfd>
    return -1;
    80005254:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    80005256:	02054563          	bltz	a0,80005280 <sys_fstat+0x44>
    8000525a:	fe040593          	addi	a1,s0,-32
    8000525e:	4505                	li	a0,1
    80005260:	ffffe097          	auipc	ra,0xffffe
    80005264:	84a080e7          	jalr	-1974(ra) # 80002aaa <argaddr>
    return -1;
    80005268:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    8000526a:	00054b63          	bltz	a0,80005280 <sys_fstat+0x44>
  return filestat(f, st);
    8000526e:	fe043583          	ld	a1,-32(s0)
    80005272:	fe843503          	ld	a0,-24(s0)
    80005276:	fffff097          	auipc	ra,0xfffff
    8000527a:	2e0080e7          	jalr	736(ra) # 80004556 <filestat>
    8000527e:	87aa                	mv	a5,a0
}
    80005280:	853e                	mv	a0,a5
    80005282:	60e2                	ld	ra,24(sp)
    80005284:	6442                	ld	s0,16(sp)
    80005286:	6105                	addi	sp,sp,32
    80005288:	8082                	ret

000000008000528a <sys_link>:
{
    8000528a:	7169                	addi	sp,sp,-304
    8000528c:	f606                	sd	ra,296(sp)
    8000528e:	f222                	sd	s0,288(sp)
    80005290:	ee26                	sd	s1,280(sp)
    80005292:	ea4a                	sd	s2,272(sp)
    80005294:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80005296:	08000613          	li	a2,128
    8000529a:	ed040593          	addi	a1,s0,-304
    8000529e:	4501                	li	a0,0
    800052a0:	ffffe097          	auipc	ra,0xffffe
    800052a4:	82c080e7          	jalr	-2004(ra) # 80002acc <argstr>
    return -1;
    800052a8:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800052aa:	10054e63          	bltz	a0,800053c6 <sys_link+0x13c>
    800052ae:	08000613          	li	a2,128
    800052b2:	f5040593          	addi	a1,s0,-176
    800052b6:	4505                	li	a0,1
    800052b8:	ffffe097          	auipc	ra,0xffffe
    800052bc:	814080e7          	jalr	-2028(ra) # 80002acc <argstr>
    return -1;
    800052c0:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800052c2:	10054263          	bltz	a0,800053c6 <sys_link+0x13c>
  begin_op();
    800052c6:	fffff097          	auipc	ra,0xfffff
    800052ca:	cfa080e7          	jalr	-774(ra) # 80003fc0 <begin_op>
  if((ip = namei(old)) == 0){
    800052ce:	ed040513          	addi	a0,s0,-304
    800052d2:	fffff097          	auipc	ra,0xfffff
    800052d6:	ade080e7          	jalr	-1314(ra) # 80003db0 <namei>
    800052da:	84aa                	mv	s1,a0
    800052dc:	c551                	beqz	a0,80005368 <sys_link+0xde>
  ilock(ip);
    800052de:	ffffe097          	auipc	ra,0xffffe
    800052e2:	31c080e7          	jalr	796(ra) # 800035fa <ilock>
  if(ip->type == T_DIR){
    800052e6:	04449703          	lh	a4,68(s1)
    800052ea:	4785                	li	a5,1
    800052ec:	08f70463          	beq	a4,a5,80005374 <sys_link+0xea>
  ip->nlink++;
    800052f0:	04a4d783          	lhu	a5,74(s1)
    800052f4:	2785                	addiw	a5,a5,1
    800052f6:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    800052fa:	8526                	mv	a0,s1
    800052fc:	ffffe097          	auipc	ra,0xffffe
    80005300:	232080e7          	jalr	562(ra) # 8000352e <iupdate>
  iunlock(ip);
    80005304:	8526                	mv	a0,s1
    80005306:	ffffe097          	auipc	ra,0xffffe
    8000530a:	3b6080e7          	jalr	950(ra) # 800036bc <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    8000530e:	fd040593          	addi	a1,s0,-48
    80005312:	f5040513          	addi	a0,s0,-176
    80005316:	fffff097          	auipc	ra,0xfffff
    8000531a:	ab8080e7          	jalr	-1352(ra) # 80003dce <nameiparent>
    8000531e:	892a                	mv	s2,a0
    80005320:	c935                	beqz	a0,80005394 <sys_link+0x10a>
  ilock(dp);
    80005322:	ffffe097          	auipc	ra,0xffffe
    80005326:	2d8080e7          	jalr	728(ra) # 800035fa <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    8000532a:	00092703          	lw	a4,0(s2)
    8000532e:	409c                	lw	a5,0(s1)
    80005330:	04f71d63          	bne	a4,a5,8000538a <sys_link+0x100>
    80005334:	40d0                	lw	a2,4(s1)
    80005336:	fd040593          	addi	a1,s0,-48
    8000533a:	854a                	mv	a0,s2
    8000533c:	fffff097          	auipc	ra,0xfffff
    80005340:	9b2080e7          	jalr	-1614(ra) # 80003cee <dirlink>
    80005344:	04054363          	bltz	a0,8000538a <sys_link+0x100>
  iunlockput(dp);
    80005348:	854a                	mv	a0,s2
    8000534a:	ffffe097          	auipc	ra,0xffffe
    8000534e:	512080e7          	jalr	1298(ra) # 8000385c <iunlockput>
  iput(ip);
    80005352:	8526                	mv	a0,s1
    80005354:	ffffe097          	auipc	ra,0xffffe
    80005358:	460080e7          	jalr	1120(ra) # 800037b4 <iput>
  end_op();
    8000535c:	fffff097          	auipc	ra,0xfffff
    80005360:	ce2080e7          	jalr	-798(ra) # 8000403e <end_op>
  return 0;
    80005364:	4781                	li	a5,0
    80005366:	a085                	j	800053c6 <sys_link+0x13c>
    end_op();
    80005368:	fffff097          	auipc	ra,0xfffff
    8000536c:	cd6080e7          	jalr	-810(ra) # 8000403e <end_op>
    return -1;
    80005370:	57fd                	li	a5,-1
    80005372:	a891                	j	800053c6 <sys_link+0x13c>
    iunlockput(ip);
    80005374:	8526                	mv	a0,s1
    80005376:	ffffe097          	auipc	ra,0xffffe
    8000537a:	4e6080e7          	jalr	1254(ra) # 8000385c <iunlockput>
    end_op();
    8000537e:	fffff097          	auipc	ra,0xfffff
    80005382:	cc0080e7          	jalr	-832(ra) # 8000403e <end_op>
    return -1;
    80005386:	57fd                	li	a5,-1
    80005388:	a83d                	j	800053c6 <sys_link+0x13c>
    iunlockput(dp);
    8000538a:	854a                	mv	a0,s2
    8000538c:	ffffe097          	auipc	ra,0xffffe
    80005390:	4d0080e7          	jalr	1232(ra) # 8000385c <iunlockput>
  ilock(ip);
    80005394:	8526                	mv	a0,s1
    80005396:	ffffe097          	auipc	ra,0xffffe
    8000539a:	264080e7          	jalr	612(ra) # 800035fa <ilock>
  ip->nlink--;
    8000539e:	04a4d783          	lhu	a5,74(s1)
    800053a2:	37fd                	addiw	a5,a5,-1
    800053a4:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    800053a8:	8526                	mv	a0,s1
    800053aa:	ffffe097          	auipc	ra,0xffffe
    800053ae:	184080e7          	jalr	388(ra) # 8000352e <iupdate>
  iunlockput(ip);
    800053b2:	8526                	mv	a0,s1
    800053b4:	ffffe097          	auipc	ra,0xffffe
    800053b8:	4a8080e7          	jalr	1192(ra) # 8000385c <iunlockput>
  end_op();
    800053bc:	fffff097          	auipc	ra,0xfffff
    800053c0:	c82080e7          	jalr	-894(ra) # 8000403e <end_op>
  return -1;
    800053c4:	57fd                	li	a5,-1
}
    800053c6:	853e                	mv	a0,a5
    800053c8:	70b2                	ld	ra,296(sp)
    800053ca:	7412                	ld	s0,288(sp)
    800053cc:	64f2                	ld	s1,280(sp)
    800053ce:	6952                	ld	s2,272(sp)
    800053d0:	6155                	addi	sp,sp,304
    800053d2:	8082                	ret

00000000800053d4 <sys_unlink>:
{
    800053d4:	7151                	addi	sp,sp,-240
    800053d6:	f586                	sd	ra,232(sp)
    800053d8:	f1a2                	sd	s0,224(sp)
    800053da:	eda6                	sd	s1,216(sp)
    800053dc:	e9ca                	sd	s2,208(sp)
    800053de:	e5ce                	sd	s3,200(sp)
    800053e0:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    800053e2:	08000613          	li	a2,128
    800053e6:	f3040593          	addi	a1,s0,-208
    800053ea:	4501                	li	a0,0
    800053ec:	ffffd097          	auipc	ra,0xffffd
    800053f0:	6e0080e7          	jalr	1760(ra) # 80002acc <argstr>
    800053f4:	18054163          	bltz	a0,80005576 <sys_unlink+0x1a2>
  begin_op();
    800053f8:	fffff097          	auipc	ra,0xfffff
    800053fc:	bc8080e7          	jalr	-1080(ra) # 80003fc0 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80005400:	fb040593          	addi	a1,s0,-80
    80005404:	f3040513          	addi	a0,s0,-208
    80005408:	fffff097          	auipc	ra,0xfffff
    8000540c:	9c6080e7          	jalr	-1594(ra) # 80003dce <nameiparent>
    80005410:	84aa                	mv	s1,a0
    80005412:	c979                	beqz	a0,800054e8 <sys_unlink+0x114>
  ilock(dp);
    80005414:	ffffe097          	auipc	ra,0xffffe
    80005418:	1e6080e7          	jalr	486(ra) # 800035fa <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    8000541c:	00003597          	auipc	a1,0x3
    80005420:	2cc58593          	addi	a1,a1,716 # 800086e8 <syscalls+0x2c0>
    80005424:	fb040513          	addi	a0,s0,-80
    80005428:	ffffe097          	auipc	ra,0xffffe
    8000542c:	696080e7          	jalr	1686(ra) # 80003abe <namecmp>
    80005430:	14050a63          	beqz	a0,80005584 <sys_unlink+0x1b0>
    80005434:	00003597          	auipc	a1,0x3
    80005438:	2bc58593          	addi	a1,a1,700 # 800086f0 <syscalls+0x2c8>
    8000543c:	fb040513          	addi	a0,s0,-80
    80005440:	ffffe097          	auipc	ra,0xffffe
    80005444:	67e080e7          	jalr	1662(ra) # 80003abe <namecmp>
    80005448:	12050e63          	beqz	a0,80005584 <sys_unlink+0x1b0>
  if((ip = dirlookup(dp, name, &off)) == 0)
    8000544c:	f2c40613          	addi	a2,s0,-212
    80005450:	fb040593          	addi	a1,s0,-80
    80005454:	8526                	mv	a0,s1
    80005456:	ffffe097          	auipc	ra,0xffffe
    8000545a:	682080e7          	jalr	1666(ra) # 80003ad8 <dirlookup>
    8000545e:	892a                	mv	s2,a0
    80005460:	12050263          	beqz	a0,80005584 <sys_unlink+0x1b0>
  ilock(ip);
    80005464:	ffffe097          	auipc	ra,0xffffe
    80005468:	196080e7          	jalr	406(ra) # 800035fa <ilock>
  if(ip->nlink < 1)
    8000546c:	04a91783          	lh	a5,74(s2)
    80005470:	08f05263          	blez	a5,800054f4 <sys_unlink+0x120>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80005474:	04491703          	lh	a4,68(s2)
    80005478:	4785                	li	a5,1
    8000547a:	08f70563          	beq	a4,a5,80005504 <sys_unlink+0x130>
  memset(&de, 0, sizeof(de));
    8000547e:	4641                	li	a2,16
    80005480:	4581                	li	a1,0
    80005482:	fc040513          	addi	a0,s0,-64
    80005486:	ffffc097          	auipc	ra,0xffffc
    8000548a:	876080e7          	jalr	-1930(ra) # 80000cfc <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000548e:	4741                	li	a4,16
    80005490:	f2c42683          	lw	a3,-212(s0)
    80005494:	fc040613          	addi	a2,s0,-64
    80005498:	4581                	li	a1,0
    8000549a:	8526                	mv	a0,s1
    8000549c:	ffffe097          	auipc	ra,0xffffe
    800054a0:	508080e7          	jalr	1288(ra) # 800039a4 <writei>
    800054a4:	47c1                	li	a5,16
    800054a6:	0af51563          	bne	a0,a5,80005550 <sys_unlink+0x17c>
  if(ip->type == T_DIR){
    800054aa:	04491703          	lh	a4,68(s2)
    800054ae:	4785                	li	a5,1
    800054b0:	0af70863          	beq	a4,a5,80005560 <sys_unlink+0x18c>
  iunlockput(dp);
    800054b4:	8526                	mv	a0,s1
    800054b6:	ffffe097          	auipc	ra,0xffffe
    800054ba:	3a6080e7          	jalr	934(ra) # 8000385c <iunlockput>
  ip->nlink--;
    800054be:	04a95783          	lhu	a5,74(s2)
    800054c2:	37fd                	addiw	a5,a5,-1
    800054c4:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    800054c8:	854a                	mv	a0,s2
    800054ca:	ffffe097          	auipc	ra,0xffffe
    800054ce:	064080e7          	jalr	100(ra) # 8000352e <iupdate>
  iunlockput(ip);
    800054d2:	854a                	mv	a0,s2
    800054d4:	ffffe097          	auipc	ra,0xffffe
    800054d8:	388080e7          	jalr	904(ra) # 8000385c <iunlockput>
  end_op();
    800054dc:	fffff097          	auipc	ra,0xfffff
    800054e0:	b62080e7          	jalr	-1182(ra) # 8000403e <end_op>
  return 0;
    800054e4:	4501                	li	a0,0
    800054e6:	a84d                	j	80005598 <sys_unlink+0x1c4>
    end_op();
    800054e8:	fffff097          	auipc	ra,0xfffff
    800054ec:	b56080e7          	jalr	-1194(ra) # 8000403e <end_op>
    return -1;
    800054f0:	557d                	li	a0,-1
    800054f2:	a05d                	j	80005598 <sys_unlink+0x1c4>
    panic("unlink: nlink < 1");
    800054f4:	00003517          	auipc	a0,0x3
    800054f8:	22450513          	addi	a0,a0,548 # 80008718 <syscalls+0x2f0>
    800054fc:	ffffb097          	auipc	ra,0xffffb
    80005500:	04a080e7          	jalr	74(ra) # 80000546 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80005504:	04c92703          	lw	a4,76(s2)
    80005508:	02000793          	li	a5,32
    8000550c:	f6e7f9e3          	bgeu	a5,a4,8000547e <sys_unlink+0xaa>
    80005510:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80005514:	4741                	li	a4,16
    80005516:	86ce                	mv	a3,s3
    80005518:	f1840613          	addi	a2,s0,-232
    8000551c:	4581                	li	a1,0
    8000551e:	854a                	mv	a0,s2
    80005520:	ffffe097          	auipc	ra,0xffffe
    80005524:	38e080e7          	jalr	910(ra) # 800038ae <readi>
    80005528:	47c1                	li	a5,16
    8000552a:	00f51b63          	bne	a0,a5,80005540 <sys_unlink+0x16c>
    if(de.inum != 0)
    8000552e:	f1845783          	lhu	a5,-232(s0)
    80005532:	e7a1                	bnez	a5,8000557a <sys_unlink+0x1a6>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80005534:	29c1                	addiw	s3,s3,16
    80005536:	04c92783          	lw	a5,76(s2)
    8000553a:	fcf9ede3          	bltu	s3,a5,80005514 <sys_unlink+0x140>
    8000553e:	b781                	j	8000547e <sys_unlink+0xaa>
      panic("isdirempty: readi");
    80005540:	00003517          	auipc	a0,0x3
    80005544:	1f050513          	addi	a0,a0,496 # 80008730 <syscalls+0x308>
    80005548:	ffffb097          	auipc	ra,0xffffb
    8000554c:	ffe080e7          	jalr	-2(ra) # 80000546 <panic>
    panic("unlink: writei");
    80005550:	00003517          	auipc	a0,0x3
    80005554:	1f850513          	addi	a0,a0,504 # 80008748 <syscalls+0x320>
    80005558:	ffffb097          	auipc	ra,0xffffb
    8000555c:	fee080e7          	jalr	-18(ra) # 80000546 <panic>
    dp->nlink--;
    80005560:	04a4d783          	lhu	a5,74(s1)
    80005564:	37fd                	addiw	a5,a5,-1
    80005566:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    8000556a:	8526                	mv	a0,s1
    8000556c:	ffffe097          	auipc	ra,0xffffe
    80005570:	fc2080e7          	jalr	-62(ra) # 8000352e <iupdate>
    80005574:	b781                	j	800054b4 <sys_unlink+0xe0>
    return -1;
    80005576:	557d                	li	a0,-1
    80005578:	a005                	j	80005598 <sys_unlink+0x1c4>
    iunlockput(ip);
    8000557a:	854a                	mv	a0,s2
    8000557c:	ffffe097          	auipc	ra,0xffffe
    80005580:	2e0080e7          	jalr	736(ra) # 8000385c <iunlockput>
  iunlockput(dp);
    80005584:	8526                	mv	a0,s1
    80005586:	ffffe097          	auipc	ra,0xffffe
    8000558a:	2d6080e7          	jalr	726(ra) # 8000385c <iunlockput>
  end_op();
    8000558e:	fffff097          	auipc	ra,0xfffff
    80005592:	ab0080e7          	jalr	-1360(ra) # 8000403e <end_op>
  return -1;
    80005596:	557d                	li	a0,-1
}
    80005598:	70ae                	ld	ra,232(sp)
    8000559a:	740e                	ld	s0,224(sp)
    8000559c:	64ee                	ld	s1,216(sp)
    8000559e:	694e                	ld	s2,208(sp)
    800055a0:	69ae                	ld	s3,200(sp)
    800055a2:	616d                	addi	sp,sp,240
    800055a4:	8082                	ret

00000000800055a6 <sys_open>:

uint64
sys_open(void)
{
    800055a6:	7131                	addi	sp,sp,-192
    800055a8:	fd06                	sd	ra,184(sp)
    800055aa:	f922                	sd	s0,176(sp)
    800055ac:	f526                	sd	s1,168(sp)
    800055ae:	f14a                	sd	s2,160(sp)
    800055b0:	ed4e                	sd	s3,152(sp)
    800055b2:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    800055b4:	08000613          	li	a2,128
    800055b8:	f5040593          	addi	a1,s0,-176
    800055bc:	4501                	li	a0,0
    800055be:	ffffd097          	auipc	ra,0xffffd
    800055c2:	50e080e7          	jalr	1294(ra) # 80002acc <argstr>
    return -1;
    800055c6:	54fd                	li	s1,-1
  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    800055c8:	0c054163          	bltz	a0,8000568a <sys_open+0xe4>
    800055cc:	f4c40593          	addi	a1,s0,-180
    800055d0:	4505                	li	a0,1
    800055d2:	ffffd097          	auipc	ra,0xffffd
    800055d6:	4b6080e7          	jalr	1206(ra) # 80002a88 <argint>
    800055da:	0a054863          	bltz	a0,8000568a <sys_open+0xe4>

  begin_op();
    800055de:	fffff097          	auipc	ra,0xfffff
    800055e2:	9e2080e7          	jalr	-1566(ra) # 80003fc0 <begin_op>

  if(omode & O_CREATE){
    800055e6:	f4c42783          	lw	a5,-180(s0)
    800055ea:	2007f793          	andi	a5,a5,512
    800055ee:	cbdd                	beqz	a5,800056a4 <sys_open+0xfe>
    ip = create(path, T_FILE, 0, 0);
    800055f0:	4681                	li	a3,0
    800055f2:	4601                	li	a2,0
    800055f4:	4589                	li	a1,2
    800055f6:	f5040513          	addi	a0,s0,-176
    800055fa:	00000097          	auipc	ra,0x0
    800055fe:	970080e7          	jalr	-1680(ra) # 80004f6a <create>
    80005602:	892a                	mv	s2,a0
    if(ip == 0){
    80005604:	c959                	beqz	a0,8000569a <sys_open+0xf4>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80005606:	04491703          	lh	a4,68(s2)
    8000560a:	478d                	li	a5,3
    8000560c:	00f71763          	bne	a4,a5,8000561a <sys_open+0x74>
    80005610:	04695703          	lhu	a4,70(s2)
    80005614:	47a5                	li	a5,9
    80005616:	0ce7ec63          	bltu	a5,a4,800056ee <sys_open+0x148>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    8000561a:	fffff097          	auipc	ra,0xfffff
    8000561e:	db8080e7          	jalr	-584(ra) # 800043d2 <filealloc>
    80005622:	89aa                	mv	s3,a0
    80005624:	10050263          	beqz	a0,80005728 <sys_open+0x182>
    80005628:	00000097          	auipc	ra,0x0
    8000562c:	900080e7          	jalr	-1792(ra) # 80004f28 <fdalloc>
    80005630:	84aa                	mv	s1,a0
    80005632:	0e054663          	bltz	a0,8000571e <sys_open+0x178>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80005636:	04491703          	lh	a4,68(s2)
    8000563a:	478d                	li	a5,3
    8000563c:	0cf70463          	beq	a4,a5,80005704 <sys_open+0x15e>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80005640:	4789                	li	a5,2
    80005642:	00f9a023          	sw	a5,0(s3)
    f->off = 0;
    80005646:	0209a023          	sw	zero,32(s3)
  }
  f->ip = ip;
    8000564a:	0129bc23          	sd	s2,24(s3)
  f->readable = !(omode & O_WRONLY);
    8000564e:	f4c42783          	lw	a5,-180(s0)
    80005652:	0017c713          	xori	a4,a5,1
    80005656:	8b05                	andi	a4,a4,1
    80005658:	00e98423          	sb	a4,8(s3)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    8000565c:	0037f713          	andi	a4,a5,3
    80005660:	00e03733          	snez	a4,a4
    80005664:	00e984a3          	sb	a4,9(s3)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80005668:	4007f793          	andi	a5,a5,1024
    8000566c:	c791                	beqz	a5,80005678 <sys_open+0xd2>
    8000566e:	04491703          	lh	a4,68(s2)
    80005672:	4789                	li	a5,2
    80005674:	08f70f63          	beq	a4,a5,80005712 <sys_open+0x16c>
    itrunc(ip);
  }

  iunlock(ip);
    80005678:	854a                	mv	a0,s2
    8000567a:	ffffe097          	auipc	ra,0xffffe
    8000567e:	042080e7          	jalr	66(ra) # 800036bc <iunlock>
  end_op();
    80005682:	fffff097          	auipc	ra,0xfffff
    80005686:	9bc080e7          	jalr	-1604(ra) # 8000403e <end_op>

  return fd;
}
    8000568a:	8526                	mv	a0,s1
    8000568c:	70ea                	ld	ra,184(sp)
    8000568e:	744a                	ld	s0,176(sp)
    80005690:	74aa                	ld	s1,168(sp)
    80005692:	790a                	ld	s2,160(sp)
    80005694:	69ea                	ld	s3,152(sp)
    80005696:	6129                	addi	sp,sp,192
    80005698:	8082                	ret
      end_op();
    8000569a:	fffff097          	auipc	ra,0xfffff
    8000569e:	9a4080e7          	jalr	-1628(ra) # 8000403e <end_op>
      return -1;
    800056a2:	b7e5                	j	8000568a <sys_open+0xe4>
    if((ip = namei(path)) == 0){
    800056a4:	f5040513          	addi	a0,s0,-176
    800056a8:	ffffe097          	auipc	ra,0xffffe
    800056ac:	708080e7          	jalr	1800(ra) # 80003db0 <namei>
    800056b0:	892a                	mv	s2,a0
    800056b2:	c905                	beqz	a0,800056e2 <sys_open+0x13c>
    ilock(ip);
    800056b4:	ffffe097          	auipc	ra,0xffffe
    800056b8:	f46080e7          	jalr	-186(ra) # 800035fa <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    800056bc:	04491703          	lh	a4,68(s2)
    800056c0:	4785                	li	a5,1
    800056c2:	f4f712e3          	bne	a4,a5,80005606 <sys_open+0x60>
    800056c6:	f4c42783          	lw	a5,-180(s0)
    800056ca:	dba1                	beqz	a5,8000561a <sys_open+0x74>
      iunlockput(ip);
    800056cc:	854a                	mv	a0,s2
    800056ce:	ffffe097          	auipc	ra,0xffffe
    800056d2:	18e080e7          	jalr	398(ra) # 8000385c <iunlockput>
      end_op();
    800056d6:	fffff097          	auipc	ra,0xfffff
    800056da:	968080e7          	jalr	-1688(ra) # 8000403e <end_op>
      return -1;
    800056de:	54fd                	li	s1,-1
    800056e0:	b76d                	j	8000568a <sys_open+0xe4>
      end_op();
    800056e2:	fffff097          	auipc	ra,0xfffff
    800056e6:	95c080e7          	jalr	-1700(ra) # 8000403e <end_op>
      return -1;
    800056ea:	54fd                	li	s1,-1
    800056ec:	bf79                	j	8000568a <sys_open+0xe4>
    iunlockput(ip);
    800056ee:	854a                	mv	a0,s2
    800056f0:	ffffe097          	auipc	ra,0xffffe
    800056f4:	16c080e7          	jalr	364(ra) # 8000385c <iunlockput>
    end_op();
    800056f8:	fffff097          	auipc	ra,0xfffff
    800056fc:	946080e7          	jalr	-1722(ra) # 8000403e <end_op>
    return -1;
    80005700:	54fd                	li	s1,-1
    80005702:	b761                	j	8000568a <sys_open+0xe4>
    f->type = FD_DEVICE;
    80005704:	00f9a023          	sw	a5,0(s3)
    f->major = ip->major;
    80005708:	04691783          	lh	a5,70(s2)
    8000570c:	02f99223          	sh	a5,36(s3)
    80005710:	bf2d                	j	8000564a <sys_open+0xa4>
    itrunc(ip);
    80005712:	854a                	mv	a0,s2
    80005714:	ffffe097          	auipc	ra,0xffffe
    80005718:	ff4080e7          	jalr	-12(ra) # 80003708 <itrunc>
    8000571c:	bfb1                	j	80005678 <sys_open+0xd2>
      fileclose(f);
    8000571e:	854e                	mv	a0,s3
    80005720:	fffff097          	auipc	ra,0xfffff
    80005724:	d6e080e7          	jalr	-658(ra) # 8000448e <fileclose>
    iunlockput(ip);
    80005728:	854a                	mv	a0,s2
    8000572a:	ffffe097          	auipc	ra,0xffffe
    8000572e:	132080e7          	jalr	306(ra) # 8000385c <iunlockput>
    end_op();
    80005732:	fffff097          	auipc	ra,0xfffff
    80005736:	90c080e7          	jalr	-1780(ra) # 8000403e <end_op>
    return -1;
    8000573a:	54fd                	li	s1,-1
    8000573c:	b7b9                	j	8000568a <sys_open+0xe4>

000000008000573e <sys_mkdir>:

uint64
sys_mkdir(void)
{
    8000573e:	7175                	addi	sp,sp,-144
    80005740:	e506                	sd	ra,136(sp)
    80005742:	e122                	sd	s0,128(sp)
    80005744:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80005746:	fffff097          	auipc	ra,0xfffff
    8000574a:	87a080e7          	jalr	-1926(ra) # 80003fc0 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    8000574e:	08000613          	li	a2,128
    80005752:	f7040593          	addi	a1,s0,-144
    80005756:	4501                	li	a0,0
    80005758:	ffffd097          	auipc	ra,0xffffd
    8000575c:	374080e7          	jalr	884(ra) # 80002acc <argstr>
    80005760:	02054963          	bltz	a0,80005792 <sys_mkdir+0x54>
    80005764:	4681                	li	a3,0
    80005766:	4601                	li	a2,0
    80005768:	4585                	li	a1,1
    8000576a:	f7040513          	addi	a0,s0,-144
    8000576e:	fffff097          	auipc	ra,0xfffff
    80005772:	7fc080e7          	jalr	2044(ra) # 80004f6a <create>
    80005776:	cd11                	beqz	a0,80005792 <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80005778:	ffffe097          	auipc	ra,0xffffe
    8000577c:	0e4080e7          	jalr	228(ra) # 8000385c <iunlockput>
  end_op();
    80005780:	fffff097          	auipc	ra,0xfffff
    80005784:	8be080e7          	jalr	-1858(ra) # 8000403e <end_op>
  return 0;
    80005788:	4501                	li	a0,0
}
    8000578a:	60aa                	ld	ra,136(sp)
    8000578c:	640a                	ld	s0,128(sp)
    8000578e:	6149                	addi	sp,sp,144
    80005790:	8082                	ret
    end_op();
    80005792:	fffff097          	auipc	ra,0xfffff
    80005796:	8ac080e7          	jalr	-1876(ra) # 8000403e <end_op>
    return -1;
    8000579a:	557d                	li	a0,-1
    8000579c:	b7fd                	j	8000578a <sys_mkdir+0x4c>

000000008000579e <sys_mknod>:

uint64
sys_mknod(void)
{
    8000579e:	7135                	addi	sp,sp,-160
    800057a0:	ed06                	sd	ra,152(sp)
    800057a2:	e922                	sd	s0,144(sp)
    800057a4:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    800057a6:	fffff097          	auipc	ra,0xfffff
    800057aa:	81a080e7          	jalr	-2022(ra) # 80003fc0 <begin_op>
  if((argstr(0, path, MAXPATH)) < 0 ||
    800057ae:	08000613          	li	a2,128
    800057b2:	f7040593          	addi	a1,s0,-144
    800057b6:	4501                	li	a0,0
    800057b8:	ffffd097          	auipc	ra,0xffffd
    800057bc:	314080e7          	jalr	788(ra) # 80002acc <argstr>
    800057c0:	04054a63          	bltz	a0,80005814 <sys_mknod+0x76>
     argint(1, &major) < 0 ||
    800057c4:	f6c40593          	addi	a1,s0,-148
    800057c8:	4505                	li	a0,1
    800057ca:	ffffd097          	auipc	ra,0xffffd
    800057ce:	2be080e7          	jalr	702(ra) # 80002a88 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    800057d2:	04054163          	bltz	a0,80005814 <sys_mknod+0x76>
     argint(2, &minor) < 0 ||
    800057d6:	f6840593          	addi	a1,s0,-152
    800057da:	4509                	li	a0,2
    800057dc:	ffffd097          	auipc	ra,0xffffd
    800057e0:	2ac080e7          	jalr	684(ra) # 80002a88 <argint>
     argint(1, &major) < 0 ||
    800057e4:	02054863          	bltz	a0,80005814 <sys_mknod+0x76>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    800057e8:	f6841683          	lh	a3,-152(s0)
    800057ec:	f6c41603          	lh	a2,-148(s0)
    800057f0:	458d                	li	a1,3
    800057f2:	f7040513          	addi	a0,s0,-144
    800057f6:	fffff097          	auipc	ra,0xfffff
    800057fa:	774080e7          	jalr	1908(ra) # 80004f6a <create>
     argint(2, &minor) < 0 ||
    800057fe:	c919                	beqz	a0,80005814 <sys_mknod+0x76>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80005800:	ffffe097          	auipc	ra,0xffffe
    80005804:	05c080e7          	jalr	92(ra) # 8000385c <iunlockput>
  end_op();
    80005808:	fffff097          	auipc	ra,0xfffff
    8000580c:	836080e7          	jalr	-1994(ra) # 8000403e <end_op>
  return 0;
    80005810:	4501                	li	a0,0
    80005812:	a031                	j	8000581e <sys_mknod+0x80>
    end_op();
    80005814:	fffff097          	auipc	ra,0xfffff
    80005818:	82a080e7          	jalr	-2006(ra) # 8000403e <end_op>
    return -1;
    8000581c:	557d                	li	a0,-1
}
    8000581e:	60ea                	ld	ra,152(sp)
    80005820:	644a                	ld	s0,144(sp)
    80005822:	610d                	addi	sp,sp,160
    80005824:	8082                	ret

0000000080005826 <sys_chdir>:

uint64
sys_chdir(void)
{
    80005826:	7135                	addi	sp,sp,-160
    80005828:	ed06                	sd	ra,152(sp)
    8000582a:	e922                	sd	s0,144(sp)
    8000582c:	e526                	sd	s1,136(sp)
    8000582e:	e14a                	sd	s2,128(sp)
    80005830:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80005832:	ffffc097          	auipc	ra,0xffffc
    80005836:	19a080e7          	jalr	410(ra) # 800019cc <myproc>
    8000583a:	892a                	mv	s2,a0
  
  begin_op();
    8000583c:	ffffe097          	auipc	ra,0xffffe
    80005840:	784080e7          	jalr	1924(ra) # 80003fc0 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80005844:	08000613          	li	a2,128
    80005848:	f6040593          	addi	a1,s0,-160
    8000584c:	4501                	li	a0,0
    8000584e:	ffffd097          	auipc	ra,0xffffd
    80005852:	27e080e7          	jalr	638(ra) # 80002acc <argstr>
    80005856:	04054b63          	bltz	a0,800058ac <sys_chdir+0x86>
    8000585a:	f6040513          	addi	a0,s0,-160
    8000585e:	ffffe097          	auipc	ra,0xffffe
    80005862:	552080e7          	jalr	1362(ra) # 80003db0 <namei>
    80005866:	84aa                	mv	s1,a0
    80005868:	c131                	beqz	a0,800058ac <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    8000586a:	ffffe097          	auipc	ra,0xffffe
    8000586e:	d90080e7          	jalr	-624(ra) # 800035fa <ilock>
  if(ip->type != T_DIR){
    80005872:	04449703          	lh	a4,68(s1)
    80005876:	4785                	li	a5,1
    80005878:	04f71063          	bne	a4,a5,800058b8 <sys_chdir+0x92>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    8000587c:	8526                	mv	a0,s1
    8000587e:	ffffe097          	auipc	ra,0xffffe
    80005882:	e3e080e7          	jalr	-450(ra) # 800036bc <iunlock>
  iput(p->cwd);
    80005886:	15093503          	ld	a0,336(s2)
    8000588a:	ffffe097          	auipc	ra,0xffffe
    8000588e:	f2a080e7          	jalr	-214(ra) # 800037b4 <iput>
  end_op();
    80005892:	ffffe097          	auipc	ra,0xffffe
    80005896:	7ac080e7          	jalr	1964(ra) # 8000403e <end_op>
  p->cwd = ip;
    8000589a:	14993823          	sd	s1,336(s2)
  return 0;
    8000589e:	4501                	li	a0,0
}
    800058a0:	60ea                	ld	ra,152(sp)
    800058a2:	644a                	ld	s0,144(sp)
    800058a4:	64aa                	ld	s1,136(sp)
    800058a6:	690a                	ld	s2,128(sp)
    800058a8:	610d                	addi	sp,sp,160
    800058aa:	8082                	ret
    end_op();
    800058ac:	ffffe097          	auipc	ra,0xffffe
    800058b0:	792080e7          	jalr	1938(ra) # 8000403e <end_op>
    return -1;
    800058b4:	557d                	li	a0,-1
    800058b6:	b7ed                	j	800058a0 <sys_chdir+0x7a>
    iunlockput(ip);
    800058b8:	8526                	mv	a0,s1
    800058ba:	ffffe097          	auipc	ra,0xffffe
    800058be:	fa2080e7          	jalr	-94(ra) # 8000385c <iunlockput>
    end_op();
    800058c2:	ffffe097          	auipc	ra,0xffffe
    800058c6:	77c080e7          	jalr	1916(ra) # 8000403e <end_op>
    return -1;
    800058ca:	557d                	li	a0,-1
    800058cc:	bfd1                	j	800058a0 <sys_chdir+0x7a>

00000000800058ce <sys_exec>:

uint64
sys_exec(void)
{
    800058ce:	7145                	addi	sp,sp,-464
    800058d0:	e786                	sd	ra,456(sp)
    800058d2:	e3a2                	sd	s0,448(sp)
    800058d4:	ff26                	sd	s1,440(sp)
    800058d6:	fb4a                	sd	s2,432(sp)
    800058d8:	f74e                	sd	s3,424(sp)
    800058da:	f352                	sd	s4,416(sp)
    800058dc:	ef56                	sd	s5,408(sp)
    800058de:	0b80                	addi	s0,sp,464
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    800058e0:	08000613          	li	a2,128
    800058e4:	f4040593          	addi	a1,s0,-192
    800058e8:	4501                	li	a0,0
    800058ea:	ffffd097          	auipc	ra,0xffffd
    800058ee:	1e2080e7          	jalr	482(ra) # 80002acc <argstr>
    return -1;
    800058f2:	597d                	li	s2,-1
  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    800058f4:	0c054b63          	bltz	a0,800059ca <sys_exec+0xfc>
    800058f8:	e3840593          	addi	a1,s0,-456
    800058fc:	4505                	li	a0,1
    800058fe:	ffffd097          	auipc	ra,0xffffd
    80005902:	1ac080e7          	jalr	428(ra) # 80002aaa <argaddr>
    80005906:	0c054263          	bltz	a0,800059ca <sys_exec+0xfc>
  }
  memset(argv, 0, sizeof(argv));
    8000590a:	10000613          	li	a2,256
    8000590e:	4581                	li	a1,0
    80005910:	e4040513          	addi	a0,s0,-448
    80005914:	ffffb097          	auipc	ra,0xffffb
    80005918:	3e8080e7          	jalr	1000(ra) # 80000cfc <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    8000591c:	e4040493          	addi	s1,s0,-448
  memset(argv, 0, sizeof(argv));
    80005920:	89a6                	mv	s3,s1
    80005922:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    80005924:	02000a13          	li	s4,32
    80005928:	00090a9b          	sext.w	s5,s2
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    8000592c:	00391513          	slli	a0,s2,0x3
    80005930:	e3040593          	addi	a1,s0,-464
    80005934:	e3843783          	ld	a5,-456(s0)
    80005938:	953e                	add	a0,a0,a5
    8000593a:	ffffd097          	auipc	ra,0xffffd
    8000593e:	0b4080e7          	jalr	180(ra) # 800029ee <fetchaddr>
    80005942:	02054a63          	bltz	a0,80005976 <sys_exec+0xa8>
      goto bad;
    }
    if(uarg == 0){
    80005946:	e3043783          	ld	a5,-464(s0)
    8000594a:	c3b9                	beqz	a5,80005990 <sys_exec+0xc2>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    8000594c:	ffffb097          	auipc	ra,0xffffb
    80005950:	1c4080e7          	jalr	452(ra) # 80000b10 <kalloc>
    80005954:	85aa                	mv	a1,a0
    80005956:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    8000595a:	cd11                	beqz	a0,80005976 <sys_exec+0xa8>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    8000595c:	6605                	lui	a2,0x1
    8000595e:	e3043503          	ld	a0,-464(s0)
    80005962:	ffffd097          	auipc	ra,0xffffd
    80005966:	0de080e7          	jalr	222(ra) # 80002a40 <fetchstr>
    8000596a:	00054663          	bltz	a0,80005976 <sys_exec+0xa8>
    if(i >= NELEM(argv)){
    8000596e:	0905                	addi	s2,s2,1
    80005970:	09a1                	addi	s3,s3,8
    80005972:	fb491be3          	bne	s2,s4,80005928 <sys_exec+0x5a>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005976:	f4040913          	addi	s2,s0,-192
    8000597a:	6088                	ld	a0,0(s1)
    8000597c:	c531                	beqz	a0,800059c8 <sys_exec+0xfa>
    kfree(argv[i]);
    8000597e:	ffffb097          	auipc	ra,0xffffb
    80005982:	094080e7          	jalr	148(ra) # 80000a12 <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005986:	04a1                	addi	s1,s1,8
    80005988:	ff2499e3          	bne	s1,s2,8000597a <sys_exec+0xac>
  return -1;
    8000598c:	597d                	li	s2,-1
    8000598e:	a835                	j	800059ca <sys_exec+0xfc>
      argv[i] = 0;
    80005990:	0a8e                	slli	s5,s5,0x3
    80005992:	fc0a8793          	addi	a5,s5,-64 # ffffffffffffefc0 <end+0xffffffff7ffd8fc0>
    80005996:	00878ab3          	add	s5,a5,s0
    8000599a:	e80ab023          	sd	zero,-384(s5)
  int ret = exec(path, argv);
    8000599e:	e4040593          	addi	a1,s0,-448
    800059a2:	f4040513          	addi	a0,s0,-192
    800059a6:	fffff097          	auipc	ra,0xfffff
    800059aa:	172080e7          	jalr	370(ra) # 80004b18 <exec>
    800059ae:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800059b0:	f4040993          	addi	s3,s0,-192
    800059b4:	6088                	ld	a0,0(s1)
    800059b6:	c911                	beqz	a0,800059ca <sys_exec+0xfc>
    kfree(argv[i]);
    800059b8:	ffffb097          	auipc	ra,0xffffb
    800059bc:	05a080e7          	jalr	90(ra) # 80000a12 <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800059c0:	04a1                	addi	s1,s1,8
    800059c2:	ff3499e3          	bne	s1,s3,800059b4 <sys_exec+0xe6>
    800059c6:	a011                	j	800059ca <sys_exec+0xfc>
  return -1;
    800059c8:	597d                	li	s2,-1
}
    800059ca:	854a                	mv	a0,s2
    800059cc:	60be                	ld	ra,456(sp)
    800059ce:	641e                	ld	s0,448(sp)
    800059d0:	74fa                	ld	s1,440(sp)
    800059d2:	795a                	ld	s2,432(sp)
    800059d4:	79ba                	ld	s3,424(sp)
    800059d6:	7a1a                	ld	s4,416(sp)
    800059d8:	6afa                	ld	s5,408(sp)
    800059da:	6179                	addi	sp,sp,464
    800059dc:	8082                	ret

00000000800059de <sys_pipe>:

uint64
sys_pipe(void)
{
    800059de:	7139                	addi	sp,sp,-64
    800059e0:	fc06                	sd	ra,56(sp)
    800059e2:	f822                	sd	s0,48(sp)
    800059e4:	f426                	sd	s1,40(sp)
    800059e6:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    800059e8:	ffffc097          	auipc	ra,0xffffc
    800059ec:	fe4080e7          	jalr	-28(ra) # 800019cc <myproc>
    800059f0:	84aa                	mv	s1,a0

  if(argaddr(0, &fdarray) < 0)
    800059f2:	fd840593          	addi	a1,s0,-40
    800059f6:	4501                	li	a0,0
    800059f8:	ffffd097          	auipc	ra,0xffffd
    800059fc:	0b2080e7          	jalr	178(ra) # 80002aaa <argaddr>
    return -1;
    80005a00:	57fd                	li	a5,-1
  if(argaddr(0, &fdarray) < 0)
    80005a02:	0e054063          	bltz	a0,80005ae2 <sys_pipe+0x104>
  if(pipealloc(&rf, &wf) < 0)
    80005a06:	fc840593          	addi	a1,s0,-56
    80005a0a:	fd040513          	addi	a0,s0,-48
    80005a0e:	fffff097          	auipc	ra,0xfffff
    80005a12:	dd6080e7          	jalr	-554(ra) # 800047e4 <pipealloc>
    return -1;
    80005a16:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    80005a18:	0c054563          	bltz	a0,80005ae2 <sys_pipe+0x104>
  fd0 = -1;
    80005a1c:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    80005a20:	fd043503          	ld	a0,-48(s0)
    80005a24:	fffff097          	auipc	ra,0xfffff
    80005a28:	504080e7          	jalr	1284(ra) # 80004f28 <fdalloc>
    80005a2c:	fca42223          	sw	a0,-60(s0)
    80005a30:	08054c63          	bltz	a0,80005ac8 <sys_pipe+0xea>
    80005a34:	fc843503          	ld	a0,-56(s0)
    80005a38:	fffff097          	auipc	ra,0xfffff
    80005a3c:	4f0080e7          	jalr	1264(ra) # 80004f28 <fdalloc>
    80005a40:	fca42023          	sw	a0,-64(s0)
    80005a44:	06054963          	bltz	a0,80005ab6 <sys_pipe+0xd8>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005a48:	4691                	li	a3,4
    80005a4a:	fc440613          	addi	a2,s0,-60
    80005a4e:	fd843583          	ld	a1,-40(s0)
    80005a52:	68a8                	ld	a0,80(s1)
    80005a54:	ffffc097          	auipc	ra,0xffffc
    80005a58:	c6e080e7          	jalr	-914(ra) # 800016c2 <copyout>
    80005a5c:	02054063          	bltz	a0,80005a7c <sys_pipe+0x9e>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    80005a60:	4691                	li	a3,4
    80005a62:	fc040613          	addi	a2,s0,-64
    80005a66:	fd843583          	ld	a1,-40(s0)
    80005a6a:	0591                	addi	a1,a1,4
    80005a6c:	68a8                	ld	a0,80(s1)
    80005a6e:	ffffc097          	auipc	ra,0xffffc
    80005a72:	c54080e7          	jalr	-940(ra) # 800016c2 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    80005a76:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005a78:	06055563          	bgez	a0,80005ae2 <sys_pipe+0x104>
    p->ofile[fd0] = 0;
    80005a7c:	fc442783          	lw	a5,-60(s0)
    80005a80:	07e9                	addi	a5,a5,26
    80005a82:	078e                	slli	a5,a5,0x3
    80005a84:	97a6                	add	a5,a5,s1
    80005a86:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    80005a8a:	fc042783          	lw	a5,-64(s0)
    80005a8e:	07e9                	addi	a5,a5,26
    80005a90:	078e                	slli	a5,a5,0x3
    80005a92:	00f48533          	add	a0,s1,a5
    80005a96:	00053023          	sd	zero,0(a0)
    fileclose(rf);
    80005a9a:	fd043503          	ld	a0,-48(s0)
    80005a9e:	fffff097          	auipc	ra,0xfffff
    80005aa2:	9f0080e7          	jalr	-1552(ra) # 8000448e <fileclose>
    fileclose(wf);
    80005aa6:	fc843503          	ld	a0,-56(s0)
    80005aaa:	fffff097          	auipc	ra,0xfffff
    80005aae:	9e4080e7          	jalr	-1564(ra) # 8000448e <fileclose>
    return -1;
    80005ab2:	57fd                	li	a5,-1
    80005ab4:	a03d                	j	80005ae2 <sys_pipe+0x104>
    if(fd0 >= 0)
    80005ab6:	fc442783          	lw	a5,-60(s0)
    80005aba:	0007c763          	bltz	a5,80005ac8 <sys_pipe+0xea>
      p->ofile[fd0] = 0;
    80005abe:	07e9                	addi	a5,a5,26
    80005ac0:	078e                	slli	a5,a5,0x3
    80005ac2:	97a6                	add	a5,a5,s1
    80005ac4:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    80005ac8:	fd043503          	ld	a0,-48(s0)
    80005acc:	fffff097          	auipc	ra,0xfffff
    80005ad0:	9c2080e7          	jalr	-1598(ra) # 8000448e <fileclose>
    fileclose(wf);
    80005ad4:	fc843503          	ld	a0,-56(s0)
    80005ad8:	fffff097          	auipc	ra,0xfffff
    80005adc:	9b6080e7          	jalr	-1610(ra) # 8000448e <fileclose>
    return -1;
    80005ae0:	57fd                	li	a5,-1
}
    80005ae2:	853e                	mv	a0,a5
    80005ae4:	70e2                	ld	ra,56(sp)
    80005ae6:	7442                	ld	s0,48(sp)
    80005ae8:	74a2                	ld	s1,40(sp)
    80005aea:	6121                	addi	sp,sp,64
    80005aec:	8082                	ret
	...

0000000080005af0 <kernelvec>:
    80005af0:	7111                	addi	sp,sp,-256
    80005af2:	e006                	sd	ra,0(sp)
    80005af4:	e40a                	sd	sp,8(sp)
    80005af6:	e80e                	sd	gp,16(sp)
    80005af8:	ec12                	sd	tp,24(sp)
    80005afa:	f016                	sd	t0,32(sp)
    80005afc:	f41a                	sd	t1,40(sp)
    80005afe:	f81e                	sd	t2,48(sp)
    80005b00:	fc22                	sd	s0,56(sp)
    80005b02:	e0a6                	sd	s1,64(sp)
    80005b04:	e4aa                	sd	a0,72(sp)
    80005b06:	e8ae                	sd	a1,80(sp)
    80005b08:	ecb2                	sd	a2,88(sp)
    80005b0a:	f0b6                	sd	a3,96(sp)
    80005b0c:	f4ba                	sd	a4,104(sp)
    80005b0e:	f8be                	sd	a5,112(sp)
    80005b10:	fcc2                	sd	a6,120(sp)
    80005b12:	e146                	sd	a7,128(sp)
    80005b14:	e54a                	sd	s2,136(sp)
    80005b16:	e94e                	sd	s3,144(sp)
    80005b18:	ed52                	sd	s4,152(sp)
    80005b1a:	f156                	sd	s5,160(sp)
    80005b1c:	f55a                	sd	s6,168(sp)
    80005b1e:	f95e                	sd	s7,176(sp)
    80005b20:	fd62                	sd	s8,184(sp)
    80005b22:	e1e6                	sd	s9,192(sp)
    80005b24:	e5ea                	sd	s10,200(sp)
    80005b26:	e9ee                	sd	s11,208(sp)
    80005b28:	edf2                	sd	t3,216(sp)
    80005b2a:	f1f6                	sd	t4,224(sp)
    80005b2c:	f5fa                	sd	t5,232(sp)
    80005b2e:	f9fe                	sd	t6,240(sp)
    80005b30:	d8bfc0ef          	jal	ra,800028ba <kerneltrap>
    80005b34:	6082                	ld	ra,0(sp)
    80005b36:	6122                	ld	sp,8(sp)
    80005b38:	61c2                	ld	gp,16(sp)
    80005b3a:	7282                	ld	t0,32(sp)
    80005b3c:	7322                	ld	t1,40(sp)
    80005b3e:	73c2                	ld	t2,48(sp)
    80005b40:	7462                	ld	s0,56(sp)
    80005b42:	6486                	ld	s1,64(sp)
    80005b44:	6526                	ld	a0,72(sp)
    80005b46:	65c6                	ld	a1,80(sp)
    80005b48:	6666                	ld	a2,88(sp)
    80005b4a:	7686                	ld	a3,96(sp)
    80005b4c:	7726                	ld	a4,104(sp)
    80005b4e:	77c6                	ld	a5,112(sp)
    80005b50:	7866                	ld	a6,120(sp)
    80005b52:	688a                	ld	a7,128(sp)
    80005b54:	692a                	ld	s2,136(sp)
    80005b56:	69ca                	ld	s3,144(sp)
    80005b58:	6a6a                	ld	s4,152(sp)
    80005b5a:	7a8a                	ld	s5,160(sp)
    80005b5c:	7b2a                	ld	s6,168(sp)
    80005b5e:	7bca                	ld	s7,176(sp)
    80005b60:	7c6a                	ld	s8,184(sp)
    80005b62:	6c8e                	ld	s9,192(sp)
    80005b64:	6d2e                	ld	s10,200(sp)
    80005b66:	6dce                	ld	s11,208(sp)
    80005b68:	6e6e                	ld	t3,216(sp)
    80005b6a:	7e8e                	ld	t4,224(sp)
    80005b6c:	7f2e                	ld	t5,232(sp)
    80005b6e:	7fce                	ld	t6,240(sp)
    80005b70:	6111                	addi	sp,sp,256
    80005b72:	10200073          	sret
    80005b76:	00000013          	nop
    80005b7a:	00000013          	nop
    80005b7e:	0001                	nop

0000000080005b80 <timervec>:
    80005b80:	34051573          	csrrw	a0,mscratch,a0
    80005b84:	e10c                	sd	a1,0(a0)
    80005b86:	e510                	sd	a2,8(a0)
    80005b88:	e914                	sd	a3,16(a0)
    80005b8a:	710c                	ld	a1,32(a0)
    80005b8c:	7510                	ld	a2,40(a0)
    80005b8e:	6194                	ld	a3,0(a1)
    80005b90:	96b2                	add	a3,a3,a2
    80005b92:	e194                	sd	a3,0(a1)
    80005b94:	4589                	li	a1,2
    80005b96:	14459073          	csrw	sip,a1
    80005b9a:	6914                	ld	a3,16(a0)
    80005b9c:	6510                	ld	a2,8(a0)
    80005b9e:	610c                	ld	a1,0(a0)
    80005ba0:	34051573          	csrrw	a0,mscratch,a0
    80005ba4:	30200073          	mret
	...

0000000080005baa <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    80005baa:	1141                	addi	sp,sp,-16
    80005bac:	e422                	sd	s0,8(sp)
    80005bae:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80005bb0:	0c0007b7          	lui	a5,0xc000
    80005bb4:	4705                	li	a4,1
    80005bb6:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    80005bb8:	c3d8                	sw	a4,4(a5)
}
    80005bba:	6422                	ld	s0,8(sp)
    80005bbc:	0141                	addi	sp,sp,16
    80005bbe:	8082                	ret

0000000080005bc0 <plicinithart>:

void
plicinithart(void)
{
    80005bc0:	1141                	addi	sp,sp,-16
    80005bc2:	e406                	sd	ra,8(sp)
    80005bc4:	e022                	sd	s0,0(sp)
    80005bc6:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005bc8:	ffffc097          	auipc	ra,0xffffc
    80005bcc:	dd8080e7          	jalr	-552(ra) # 800019a0 <cpuid>
  
  // set uart's enable bit for this hart's S-mode. 
  *(uint32*)PLIC_SENABLE(hart)= (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80005bd0:	0085171b          	slliw	a4,a0,0x8
    80005bd4:	0c0027b7          	lui	a5,0xc002
    80005bd8:	97ba                	add	a5,a5,a4
    80005bda:	40200713          	li	a4,1026
    80005bde:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80005be2:	00d5151b          	slliw	a0,a0,0xd
    80005be6:	0c2017b7          	lui	a5,0xc201
    80005bea:	97aa                	add	a5,a5,a0
    80005bec:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    80005bf0:	60a2                	ld	ra,8(sp)
    80005bf2:	6402                	ld	s0,0(sp)
    80005bf4:	0141                	addi	sp,sp,16
    80005bf6:	8082                	ret

0000000080005bf8 <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    80005bf8:	1141                	addi	sp,sp,-16
    80005bfa:	e406                	sd	ra,8(sp)
    80005bfc:	e022                	sd	s0,0(sp)
    80005bfe:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005c00:	ffffc097          	auipc	ra,0xffffc
    80005c04:	da0080e7          	jalr	-608(ra) # 800019a0 <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    80005c08:	00d5151b          	slliw	a0,a0,0xd
    80005c0c:	0c2017b7          	lui	a5,0xc201
    80005c10:	97aa                	add	a5,a5,a0
  return irq;
}
    80005c12:	43c8                	lw	a0,4(a5)
    80005c14:	60a2                	ld	ra,8(sp)
    80005c16:	6402                	ld	s0,0(sp)
    80005c18:	0141                	addi	sp,sp,16
    80005c1a:	8082                	ret

0000000080005c1c <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    80005c1c:	1101                	addi	sp,sp,-32
    80005c1e:	ec06                	sd	ra,24(sp)
    80005c20:	e822                	sd	s0,16(sp)
    80005c22:	e426                	sd	s1,8(sp)
    80005c24:	1000                	addi	s0,sp,32
    80005c26:	84aa                	mv	s1,a0
  int hart = cpuid();
    80005c28:	ffffc097          	auipc	ra,0xffffc
    80005c2c:	d78080e7          	jalr	-648(ra) # 800019a0 <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    80005c30:	00d5151b          	slliw	a0,a0,0xd
    80005c34:	0c2017b7          	lui	a5,0xc201
    80005c38:	97aa                	add	a5,a5,a0
    80005c3a:	c3c4                	sw	s1,4(a5)
}
    80005c3c:	60e2                	ld	ra,24(sp)
    80005c3e:	6442                	ld	s0,16(sp)
    80005c40:	64a2                	ld	s1,8(sp)
    80005c42:	6105                	addi	sp,sp,32
    80005c44:	8082                	ret

0000000080005c46 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    80005c46:	1141                	addi	sp,sp,-16
    80005c48:	e406                	sd	ra,8(sp)
    80005c4a:	e022                	sd	s0,0(sp)
    80005c4c:	0800                	addi	s0,sp,16
  if(i >= NUM)
    80005c4e:	479d                	li	a5,7
    80005c50:	04a7cb63          	blt	a5,a0,80005ca6 <free_desc+0x60>
    panic("virtio_disk_intr 1");
  if(disk.free[i])
    80005c54:	0001d717          	auipc	a4,0x1d
    80005c58:	3ac70713          	addi	a4,a4,940 # 80023000 <disk>
    80005c5c:	972a                	add	a4,a4,a0
    80005c5e:	6789                	lui	a5,0x2
    80005c60:	97ba                	add	a5,a5,a4
    80005c62:	0187c783          	lbu	a5,24(a5) # 2018 <_entry-0x7fffdfe8>
    80005c66:	eba1                	bnez	a5,80005cb6 <free_desc+0x70>
    panic("virtio_disk_intr 2");
  disk.desc[i].addr = 0;
    80005c68:	00451713          	slli	a4,a0,0x4
    80005c6c:	0001f797          	auipc	a5,0x1f
    80005c70:	3947b783          	ld	a5,916(a5) # 80025000 <disk+0x2000>
    80005c74:	97ba                	add	a5,a5,a4
    80005c76:	0007b023          	sd	zero,0(a5)
  disk.free[i] = 1;
    80005c7a:	0001d717          	auipc	a4,0x1d
    80005c7e:	38670713          	addi	a4,a4,902 # 80023000 <disk>
    80005c82:	972a                	add	a4,a4,a0
    80005c84:	6789                	lui	a5,0x2
    80005c86:	97ba                	add	a5,a5,a4
    80005c88:	4705                	li	a4,1
    80005c8a:	00e78c23          	sb	a4,24(a5) # 2018 <_entry-0x7fffdfe8>
  wakeup(&disk.free[0]);
    80005c8e:	0001f517          	auipc	a0,0x1f
    80005c92:	38a50513          	addi	a0,a0,906 # 80025018 <disk+0x2018>
    80005c96:	ffffc097          	auipc	ra,0xffffc
    80005c9a:	6ca080e7          	jalr	1738(ra) # 80002360 <wakeup>
}
    80005c9e:	60a2                	ld	ra,8(sp)
    80005ca0:	6402                	ld	s0,0(sp)
    80005ca2:	0141                	addi	sp,sp,16
    80005ca4:	8082                	ret
    panic("virtio_disk_intr 1");
    80005ca6:	00003517          	auipc	a0,0x3
    80005caa:	ab250513          	addi	a0,a0,-1358 # 80008758 <syscalls+0x330>
    80005cae:	ffffb097          	auipc	ra,0xffffb
    80005cb2:	898080e7          	jalr	-1896(ra) # 80000546 <panic>
    panic("virtio_disk_intr 2");
    80005cb6:	00003517          	auipc	a0,0x3
    80005cba:	aba50513          	addi	a0,a0,-1350 # 80008770 <syscalls+0x348>
    80005cbe:	ffffb097          	auipc	ra,0xffffb
    80005cc2:	888080e7          	jalr	-1912(ra) # 80000546 <panic>

0000000080005cc6 <virtio_disk_init>:
{
    80005cc6:	1101                	addi	sp,sp,-32
    80005cc8:	ec06                	sd	ra,24(sp)
    80005cca:	e822                	sd	s0,16(sp)
    80005ccc:	e426                	sd	s1,8(sp)
    80005cce:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    80005cd0:	00003597          	auipc	a1,0x3
    80005cd4:	ab858593          	addi	a1,a1,-1352 # 80008788 <syscalls+0x360>
    80005cd8:	0001f517          	auipc	a0,0x1f
    80005cdc:	3d050513          	addi	a0,a0,976 # 800250a8 <disk+0x20a8>
    80005ce0:	ffffb097          	auipc	ra,0xffffb
    80005ce4:	e90080e7          	jalr	-368(ra) # 80000b70 <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005ce8:	100017b7          	lui	a5,0x10001
    80005cec:	4398                	lw	a4,0(a5)
    80005cee:	2701                	sext.w	a4,a4
    80005cf0:	747277b7          	lui	a5,0x74727
    80005cf4:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    80005cf8:	0ef71063          	bne	a4,a5,80005dd8 <virtio_disk_init+0x112>
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    80005cfc:	100017b7          	lui	a5,0x10001
    80005d00:	43dc                	lw	a5,4(a5)
    80005d02:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005d04:	4705                	li	a4,1
    80005d06:	0ce79963          	bne	a5,a4,80005dd8 <virtio_disk_init+0x112>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80005d0a:	100017b7          	lui	a5,0x10001
    80005d0e:	479c                	lw	a5,8(a5)
    80005d10:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    80005d12:	4709                	li	a4,2
    80005d14:	0ce79263          	bne	a5,a4,80005dd8 <virtio_disk_init+0x112>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    80005d18:	100017b7          	lui	a5,0x10001
    80005d1c:	47d8                	lw	a4,12(a5)
    80005d1e:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80005d20:	554d47b7          	lui	a5,0x554d4
    80005d24:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    80005d28:	0af71863          	bne	a4,a5,80005dd8 <virtio_disk_init+0x112>
  *R(VIRTIO_MMIO_STATUS) = status;
    80005d2c:	100017b7          	lui	a5,0x10001
    80005d30:	4705                	li	a4,1
    80005d32:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005d34:	470d                	li	a4,3
    80005d36:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    80005d38:	4b98                	lw	a4,16(a5)
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80005d3a:	c7ffe6b7          	lui	a3,0xc7ffe
    80005d3e:	75f68693          	addi	a3,a3,1887 # ffffffffc7ffe75f <end+0xffffffff47fd875f>
    80005d42:	8f75                	and	a4,a4,a3
    80005d44:	d398                	sw	a4,32(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005d46:	472d                	li	a4,11
    80005d48:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005d4a:	473d                	li	a4,15
    80005d4c:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_GUEST_PAGE_SIZE) = PGSIZE;
    80005d4e:	6705                	lui	a4,0x1
    80005d50:	d798                	sw	a4,40(a5)
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    80005d52:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    80005d56:	5bdc                	lw	a5,52(a5)
    80005d58:	2781                	sext.w	a5,a5
  if(max == 0)
    80005d5a:	c7d9                	beqz	a5,80005de8 <virtio_disk_init+0x122>
  if(max < NUM)
    80005d5c:	471d                	li	a4,7
    80005d5e:	08f77d63          	bgeu	a4,a5,80005df8 <virtio_disk_init+0x132>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    80005d62:	100014b7          	lui	s1,0x10001
    80005d66:	47a1                	li	a5,8
    80005d68:	dc9c                	sw	a5,56(s1)
  memset(disk.pages, 0, sizeof(disk.pages));
    80005d6a:	6609                	lui	a2,0x2
    80005d6c:	4581                	li	a1,0
    80005d6e:	0001d517          	auipc	a0,0x1d
    80005d72:	29250513          	addi	a0,a0,658 # 80023000 <disk>
    80005d76:	ffffb097          	auipc	ra,0xffffb
    80005d7a:	f86080e7          	jalr	-122(ra) # 80000cfc <memset>
  *R(VIRTIO_MMIO_QUEUE_PFN) = ((uint64)disk.pages) >> PGSHIFT;
    80005d7e:	0001d717          	auipc	a4,0x1d
    80005d82:	28270713          	addi	a4,a4,642 # 80023000 <disk>
    80005d86:	00c75793          	srli	a5,a4,0xc
    80005d8a:	2781                	sext.w	a5,a5
    80005d8c:	c0bc                	sw	a5,64(s1)
  disk.desc = (struct VRingDesc *) disk.pages;
    80005d8e:	0001f797          	auipc	a5,0x1f
    80005d92:	27278793          	addi	a5,a5,626 # 80025000 <disk+0x2000>
    80005d96:	e398                	sd	a4,0(a5)
  disk.avail = (uint16*)(((char*)disk.desc) + NUM*sizeof(struct VRingDesc));
    80005d98:	0001d717          	auipc	a4,0x1d
    80005d9c:	2e870713          	addi	a4,a4,744 # 80023080 <disk+0x80>
    80005da0:	e798                	sd	a4,8(a5)
  disk.used = (struct UsedArea *) (disk.pages + PGSIZE);
    80005da2:	0001e717          	auipc	a4,0x1e
    80005da6:	25e70713          	addi	a4,a4,606 # 80024000 <disk+0x1000>
    80005daa:	eb98                	sd	a4,16(a5)
    disk.free[i] = 1;
    80005dac:	4705                	li	a4,1
    80005dae:	00e78c23          	sb	a4,24(a5)
    80005db2:	00e78ca3          	sb	a4,25(a5)
    80005db6:	00e78d23          	sb	a4,26(a5)
    80005dba:	00e78da3          	sb	a4,27(a5)
    80005dbe:	00e78e23          	sb	a4,28(a5)
    80005dc2:	00e78ea3          	sb	a4,29(a5)
    80005dc6:	00e78f23          	sb	a4,30(a5)
    80005dca:	00e78fa3          	sb	a4,31(a5)
}
    80005dce:	60e2                	ld	ra,24(sp)
    80005dd0:	6442                	ld	s0,16(sp)
    80005dd2:	64a2                	ld	s1,8(sp)
    80005dd4:	6105                	addi	sp,sp,32
    80005dd6:	8082                	ret
    panic("could not find virtio disk");
    80005dd8:	00003517          	auipc	a0,0x3
    80005ddc:	9c050513          	addi	a0,a0,-1600 # 80008798 <syscalls+0x370>
    80005de0:	ffffa097          	auipc	ra,0xffffa
    80005de4:	766080e7          	jalr	1894(ra) # 80000546 <panic>
    panic("virtio disk has no queue 0");
    80005de8:	00003517          	auipc	a0,0x3
    80005dec:	9d050513          	addi	a0,a0,-1584 # 800087b8 <syscalls+0x390>
    80005df0:	ffffa097          	auipc	ra,0xffffa
    80005df4:	756080e7          	jalr	1878(ra) # 80000546 <panic>
    panic("virtio disk max queue too short");
    80005df8:	00003517          	auipc	a0,0x3
    80005dfc:	9e050513          	addi	a0,a0,-1568 # 800087d8 <syscalls+0x3b0>
    80005e00:	ffffa097          	auipc	ra,0xffffa
    80005e04:	746080e7          	jalr	1862(ra) # 80000546 <panic>

0000000080005e08 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80005e08:	7175                	addi	sp,sp,-144
    80005e0a:	e506                	sd	ra,136(sp)
    80005e0c:	e122                	sd	s0,128(sp)
    80005e0e:	fca6                	sd	s1,120(sp)
    80005e10:	f8ca                	sd	s2,112(sp)
    80005e12:	f4ce                	sd	s3,104(sp)
    80005e14:	f0d2                	sd	s4,96(sp)
    80005e16:	ecd6                	sd	s5,88(sp)
    80005e18:	e8da                	sd	s6,80(sp)
    80005e1a:	e4de                	sd	s7,72(sp)
    80005e1c:	e0e2                	sd	s8,64(sp)
    80005e1e:	fc66                	sd	s9,56(sp)
    80005e20:	f86a                	sd	s10,48(sp)
    80005e22:	f46e                	sd	s11,40(sp)
    80005e24:	0900                	addi	s0,sp,144
    80005e26:	8aaa                	mv	s5,a0
    80005e28:	8d2e                	mv	s10,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    80005e2a:	00c52c83          	lw	s9,12(a0)
    80005e2e:	001c9c9b          	slliw	s9,s9,0x1
    80005e32:	1c82                	slli	s9,s9,0x20
    80005e34:	020cdc93          	srli	s9,s9,0x20

  acquire(&disk.vdisk_lock);
    80005e38:	0001f517          	auipc	a0,0x1f
    80005e3c:	27050513          	addi	a0,a0,624 # 800250a8 <disk+0x20a8>
    80005e40:	ffffb097          	auipc	ra,0xffffb
    80005e44:	dc0080e7          	jalr	-576(ra) # 80000c00 <acquire>
  for(int i = 0; i < 3; i++){
    80005e48:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    80005e4a:	44a1                	li	s1,8
      disk.free[i] = 0;
    80005e4c:	0001dc17          	auipc	s8,0x1d
    80005e50:	1b4c0c13          	addi	s8,s8,436 # 80023000 <disk>
    80005e54:	6b89                	lui	s7,0x2
  for(int i = 0; i < 3; i++){
    80005e56:	4b0d                	li	s6,3
    80005e58:	a0ad                	j	80005ec2 <virtio_disk_rw+0xba>
      disk.free[i] = 0;
    80005e5a:	00fc0733          	add	a4,s8,a5
    80005e5e:	975e                	add	a4,a4,s7
    80005e60:	00070c23          	sb	zero,24(a4)
    idx[i] = alloc_desc();
    80005e64:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    80005e66:	0207c563          	bltz	a5,80005e90 <virtio_disk_rw+0x88>
  for(int i = 0; i < 3; i++){
    80005e6a:	2905                	addiw	s2,s2,1
    80005e6c:	0611                	addi	a2,a2,4 # 2004 <_entry-0x7fffdffc>
    80005e6e:	19690c63          	beq	s2,s6,80006006 <virtio_disk_rw+0x1fe>
    idx[i] = alloc_desc();
    80005e72:	85b2                	mv	a1,a2
  for(int i = 0; i < NUM; i++){
    80005e74:	0001f717          	auipc	a4,0x1f
    80005e78:	1a470713          	addi	a4,a4,420 # 80025018 <disk+0x2018>
    80005e7c:	87ce                	mv	a5,s3
    if(disk.free[i]){
    80005e7e:	00074683          	lbu	a3,0(a4)
    80005e82:	fee1                	bnez	a3,80005e5a <virtio_disk_rw+0x52>
  for(int i = 0; i < NUM; i++){
    80005e84:	2785                	addiw	a5,a5,1
    80005e86:	0705                	addi	a4,a4,1
    80005e88:	fe979be3          	bne	a5,s1,80005e7e <virtio_disk_rw+0x76>
    idx[i] = alloc_desc();
    80005e8c:	57fd                	li	a5,-1
    80005e8e:	c19c                	sw	a5,0(a1)
      for(int j = 0; j < i; j++)
    80005e90:	01205d63          	blez	s2,80005eaa <virtio_disk_rw+0xa2>
    80005e94:	8dce                	mv	s11,s3
        free_desc(idx[j]);
    80005e96:	000a2503          	lw	a0,0(s4)
    80005e9a:	00000097          	auipc	ra,0x0
    80005e9e:	dac080e7          	jalr	-596(ra) # 80005c46 <free_desc>
      for(int j = 0; j < i; j++)
    80005ea2:	2d85                	addiw	s11,s11,1
    80005ea4:	0a11                	addi	s4,s4,4
    80005ea6:	ff2d98e3          	bne	s11,s2,80005e96 <virtio_disk_rw+0x8e>
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80005eaa:	0001f597          	auipc	a1,0x1f
    80005eae:	1fe58593          	addi	a1,a1,510 # 800250a8 <disk+0x20a8>
    80005eb2:	0001f517          	auipc	a0,0x1f
    80005eb6:	16650513          	addi	a0,a0,358 # 80025018 <disk+0x2018>
    80005eba:	ffffc097          	auipc	ra,0xffffc
    80005ebe:	326080e7          	jalr	806(ra) # 800021e0 <sleep>
  for(int i = 0; i < 3; i++){
    80005ec2:	f8040a13          	addi	s4,s0,-128
{
    80005ec6:	8652                	mv	a2,s4
  for(int i = 0; i < 3; i++){
    80005ec8:	894e                	mv	s2,s3
    80005eca:	b765                	j	80005e72 <virtio_disk_rw+0x6a>
  disk.desc[idx[0]].next = idx[1];

  disk.desc[idx[1]].addr = (uint64) b->data;
  disk.desc[idx[1]].len = BSIZE;
  if(write)
    disk.desc[idx[1]].flags = 0; // device reads b->data
    80005ecc:	0001f717          	auipc	a4,0x1f
    80005ed0:	13473703          	ld	a4,308(a4) # 80025000 <disk+0x2000>
    80005ed4:	973e                	add	a4,a4,a5
    80005ed6:	00071623          	sh	zero,12(a4)
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    80005eda:	0001d517          	auipc	a0,0x1d
    80005ede:	12650513          	addi	a0,a0,294 # 80023000 <disk>
    80005ee2:	0001f717          	auipc	a4,0x1f
    80005ee6:	11e70713          	addi	a4,a4,286 # 80025000 <disk+0x2000>
    80005eea:	6314                	ld	a3,0(a4)
    80005eec:	96be                	add	a3,a3,a5
    80005eee:	00c6d603          	lhu	a2,12(a3)
    80005ef2:	00166613          	ori	a2,a2,1
    80005ef6:	00c69623          	sh	a2,12(a3)
  disk.desc[idx[1]].next = idx[2];
    80005efa:	f8842683          	lw	a3,-120(s0)
    80005efe:	6310                	ld	a2,0(a4)
    80005f00:	97b2                	add	a5,a5,a2
    80005f02:	00d79723          	sh	a3,14(a5)

  disk.info[idx[0]].status = 0;
    80005f06:	20048613          	addi	a2,s1,512 # 10001200 <_entry-0x6fffee00>
    80005f0a:	0612                	slli	a2,a2,0x4
    80005f0c:	962a                	add	a2,a2,a0
    80005f0e:	02060823          	sb	zero,48(a2)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    80005f12:	00469793          	slli	a5,a3,0x4
    80005f16:	630c                	ld	a1,0(a4)
    80005f18:	95be                	add	a1,a1,a5
    80005f1a:	6689                	lui	a3,0x2
    80005f1c:	03068693          	addi	a3,a3,48 # 2030 <_entry-0x7fffdfd0>
    80005f20:	96ca                	add	a3,a3,s2
    80005f22:	96aa                	add	a3,a3,a0
    80005f24:	e194                	sd	a3,0(a1)
  disk.desc[idx[2]].len = 1;
    80005f26:	6314                	ld	a3,0(a4)
    80005f28:	96be                	add	a3,a3,a5
    80005f2a:	4585                	li	a1,1
    80005f2c:	c68c                	sw	a1,8(a3)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    80005f2e:	6314                	ld	a3,0(a4)
    80005f30:	96be                	add	a3,a3,a5
    80005f32:	4509                	li	a0,2
    80005f34:	00a69623          	sh	a0,12(a3)
  disk.desc[idx[2]].next = 0;
    80005f38:	6314                	ld	a3,0(a4)
    80005f3a:	97b6                	add	a5,a5,a3
    80005f3c:	00079723          	sh	zero,14(a5)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    80005f40:	00baa223          	sw	a1,4(s5)
  disk.info[idx[0]].b = b;
    80005f44:	03563423          	sd	s5,40(a2)

  // avail[0] is flags
  // avail[1] tells the device how far to look in avail[2...].
  // avail[2...] are desc[] indices the device should process.
  // we only tell device the first index in our chain of descriptors.
  disk.avail[2 + (disk.avail[1] % NUM)] = idx[0];
    80005f48:	6714                	ld	a3,8(a4)
    80005f4a:	0026d783          	lhu	a5,2(a3)
    80005f4e:	8b9d                	andi	a5,a5,7
    80005f50:	0789                	addi	a5,a5,2
    80005f52:	0786                	slli	a5,a5,0x1
    80005f54:	96be                	add	a3,a3,a5
    80005f56:	00969023          	sh	s1,0(a3)
  __sync_synchronize();
    80005f5a:	0ff0000f          	fence
  disk.avail[1] = disk.avail[1] + 1;
    80005f5e:	6718                	ld	a4,8(a4)
    80005f60:	00275783          	lhu	a5,2(a4)
    80005f64:	2785                	addiw	a5,a5,1
    80005f66:	00f71123          	sh	a5,2(a4)

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    80005f6a:	100017b7          	lui	a5,0x10001
    80005f6e:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    80005f72:	004aa783          	lw	a5,4(s5)
    80005f76:	02b79163          	bne	a5,a1,80005f98 <virtio_disk_rw+0x190>
    sleep(b, &disk.vdisk_lock);
    80005f7a:	0001f917          	auipc	s2,0x1f
    80005f7e:	12e90913          	addi	s2,s2,302 # 800250a8 <disk+0x20a8>
  while(b->disk == 1) {
    80005f82:	4485                	li	s1,1
    sleep(b, &disk.vdisk_lock);
    80005f84:	85ca                	mv	a1,s2
    80005f86:	8556                	mv	a0,s5
    80005f88:	ffffc097          	auipc	ra,0xffffc
    80005f8c:	258080e7          	jalr	600(ra) # 800021e0 <sleep>
  while(b->disk == 1) {
    80005f90:	004aa783          	lw	a5,4(s5)
    80005f94:	fe9788e3          	beq	a5,s1,80005f84 <virtio_disk_rw+0x17c>
  }

  disk.info[idx[0]].b = 0;
    80005f98:	f8042483          	lw	s1,-128(s0)
    80005f9c:	20048713          	addi	a4,s1,512
    80005fa0:	0712                	slli	a4,a4,0x4
    80005fa2:	0001d797          	auipc	a5,0x1d
    80005fa6:	05e78793          	addi	a5,a5,94 # 80023000 <disk>
    80005faa:	97ba                	add	a5,a5,a4
    80005fac:	0207b423          	sd	zero,40(a5)
    if(disk.desc[i].flags & VRING_DESC_F_NEXT)
    80005fb0:	0001f917          	auipc	s2,0x1f
    80005fb4:	05090913          	addi	s2,s2,80 # 80025000 <disk+0x2000>
    80005fb8:	a019                	j	80005fbe <virtio_disk_rw+0x1b6>
      i = disk.desc[i].next;
    80005fba:	00e7d483          	lhu	s1,14(a5)
    free_desc(i);
    80005fbe:	8526                	mv	a0,s1
    80005fc0:	00000097          	auipc	ra,0x0
    80005fc4:	c86080e7          	jalr	-890(ra) # 80005c46 <free_desc>
    if(disk.desc[i].flags & VRING_DESC_F_NEXT)
    80005fc8:	0492                	slli	s1,s1,0x4
    80005fca:	00093783          	ld	a5,0(s2)
    80005fce:	97a6                	add	a5,a5,s1
    80005fd0:	00c7d703          	lhu	a4,12(a5)
    80005fd4:	8b05                	andi	a4,a4,1
    80005fd6:	f375                	bnez	a4,80005fba <virtio_disk_rw+0x1b2>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    80005fd8:	0001f517          	auipc	a0,0x1f
    80005fdc:	0d050513          	addi	a0,a0,208 # 800250a8 <disk+0x20a8>
    80005fe0:	ffffb097          	auipc	ra,0xffffb
    80005fe4:	cd4080e7          	jalr	-812(ra) # 80000cb4 <release>
}
    80005fe8:	60aa                	ld	ra,136(sp)
    80005fea:	640a                	ld	s0,128(sp)
    80005fec:	74e6                	ld	s1,120(sp)
    80005fee:	7946                	ld	s2,112(sp)
    80005ff0:	79a6                	ld	s3,104(sp)
    80005ff2:	7a06                	ld	s4,96(sp)
    80005ff4:	6ae6                	ld	s5,88(sp)
    80005ff6:	6b46                	ld	s6,80(sp)
    80005ff8:	6ba6                	ld	s7,72(sp)
    80005ffa:	6c06                	ld	s8,64(sp)
    80005ffc:	7ce2                	ld	s9,56(sp)
    80005ffe:	7d42                	ld	s10,48(sp)
    80006000:	7da2                	ld	s11,40(sp)
    80006002:	6149                	addi	sp,sp,144
    80006004:	8082                	ret
  if(write)
    80006006:	01a037b3          	snez	a5,s10
    8000600a:	f6f42823          	sw	a5,-144(s0)
  buf0.reserved = 0;
    8000600e:	f6042a23          	sw	zero,-140(s0)
  buf0.sector = sector;
    80006012:	f7943c23          	sd	s9,-136(s0)
  disk.desc[idx[0]].addr = (uint64) kvmpa((uint64) &buf0);
    80006016:	f8042483          	lw	s1,-128(s0)
    8000601a:	00449913          	slli	s2,s1,0x4
    8000601e:	0001f997          	auipc	s3,0x1f
    80006022:	fe298993          	addi	s3,s3,-30 # 80025000 <disk+0x2000>
    80006026:	0009ba03          	ld	s4,0(s3)
    8000602a:	9a4a                	add	s4,s4,s2
    8000602c:	f7040513          	addi	a0,s0,-144
    80006030:	ffffb097          	auipc	ra,0xffffb
    80006034:	09c080e7          	jalr	156(ra) # 800010cc <kvmpa>
    80006038:	00aa3023          	sd	a0,0(s4)
  disk.desc[idx[0]].len = sizeof(buf0);
    8000603c:	0009b783          	ld	a5,0(s3)
    80006040:	97ca                	add	a5,a5,s2
    80006042:	4741                	li	a4,16
    80006044:	c798                	sw	a4,8(a5)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    80006046:	0009b783          	ld	a5,0(s3)
    8000604a:	97ca                	add	a5,a5,s2
    8000604c:	4705                	li	a4,1
    8000604e:	00e79623          	sh	a4,12(a5)
  disk.desc[idx[0]].next = idx[1];
    80006052:	f8442783          	lw	a5,-124(s0)
    80006056:	0009b703          	ld	a4,0(s3)
    8000605a:	974a                	add	a4,a4,s2
    8000605c:	00f71723          	sh	a5,14(a4)
  disk.desc[idx[1]].addr = (uint64) b->data;
    80006060:	0792                	slli	a5,a5,0x4
    80006062:	0009b703          	ld	a4,0(s3)
    80006066:	973e                	add	a4,a4,a5
    80006068:	058a8693          	addi	a3,s5,88
    8000606c:	e314                	sd	a3,0(a4)
  disk.desc[idx[1]].len = BSIZE;
    8000606e:	0009b703          	ld	a4,0(s3)
    80006072:	973e                	add	a4,a4,a5
    80006074:	40000693          	li	a3,1024
    80006078:	c714                	sw	a3,8(a4)
  if(write)
    8000607a:	e40d19e3          	bnez	s10,80005ecc <virtio_disk_rw+0xc4>
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
    8000607e:	0001f717          	auipc	a4,0x1f
    80006082:	f8273703          	ld	a4,-126(a4) # 80025000 <disk+0x2000>
    80006086:	973e                	add	a4,a4,a5
    80006088:	4689                	li	a3,2
    8000608a:	00d71623          	sh	a3,12(a4)
    8000608e:	b5b1                	j	80005eda <virtio_disk_rw+0xd2>

0000000080006090 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    80006090:	1101                	addi	sp,sp,-32
    80006092:	ec06                	sd	ra,24(sp)
    80006094:	e822                	sd	s0,16(sp)
    80006096:	e426                	sd	s1,8(sp)
    80006098:	e04a                	sd	s2,0(sp)
    8000609a:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    8000609c:	0001f517          	auipc	a0,0x1f
    800060a0:	00c50513          	addi	a0,a0,12 # 800250a8 <disk+0x20a8>
    800060a4:	ffffb097          	auipc	ra,0xffffb
    800060a8:	b5c080e7          	jalr	-1188(ra) # 80000c00 <acquire>

  while((disk.used_idx % NUM) != (disk.used->id % NUM)){
    800060ac:	0001f717          	auipc	a4,0x1f
    800060b0:	f5470713          	addi	a4,a4,-172 # 80025000 <disk+0x2000>
    800060b4:	02075783          	lhu	a5,32(a4)
    800060b8:	6b18                	ld	a4,16(a4)
    800060ba:	00275683          	lhu	a3,2(a4)
    800060be:	8ebd                	xor	a3,a3,a5
    800060c0:	8a9d                	andi	a3,a3,7
    800060c2:	cab9                	beqz	a3,80006118 <virtio_disk_intr+0x88>
    int id = disk.used->elems[disk.used_idx].id;

    if(disk.info[id].status != 0)
    800060c4:	0001d917          	auipc	s2,0x1d
    800060c8:	f3c90913          	addi	s2,s2,-196 # 80023000 <disk>
      panic("virtio_disk_intr status");
    
    disk.info[id].b->disk = 0;   // disk is done with buf
    wakeup(disk.info[id].b);

    disk.used_idx = (disk.used_idx + 1) % NUM;
    800060cc:	0001f497          	auipc	s1,0x1f
    800060d0:	f3448493          	addi	s1,s1,-204 # 80025000 <disk+0x2000>
    int id = disk.used->elems[disk.used_idx].id;
    800060d4:	078e                	slli	a5,a5,0x3
    800060d6:	973e                	add	a4,a4,a5
    800060d8:	435c                	lw	a5,4(a4)
    if(disk.info[id].status != 0)
    800060da:	20078713          	addi	a4,a5,512
    800060de:	0712                	slli	a4,a4,0x4
    800060e0:	974a                	add	a4,a4,s2
    800060e2:	03074703          	lbu	a4,48(a4)
    800060e6:	ef21                	bnez	a4,8000613e <virtio_disk_intr+0xae>
    disk.info[id].b->disk = 0;   // disk is done with buf
    800060e8:	20078793          	addi	a5,a5,512
    800060ec:	0792                	slli	a5,a5,0x4
    800060ee:	97ca                	add	a5,a5,s2
    800060f0:	7798                	ld	a4,40(a5)
    800060f2:	00072223          	sw	zero,4(a4)
    wakeup(disk.info[id].b);
    800060f6:	7788                	ld	a0,40(a5)
    800060f8:	ffffc097          	auipc	ra,0xffffc
    800060fc:	268080e7          	jalr	616(ra) # 80002360 <wakeup>
    disk.used_idx = (disk.used_idx + 1) % NUM;
    80006100:	0204d783          	lhu	a5,32(s1)
    80006104:	2785                	addiw	a5,a5,1
    80006106:	8b9d                	andi	a5,a5,7
    80006108:	02f49023          	sh	a5,32(s1)
  while((disk.used_idx % NUM) != (disk.used->id % NUM)){
    8000610c:	6898                	ld	a4,16(s1)
    8000610e:	00275683          	lhu	a3,2(a4)
    80006112:	8a9d                	andi	a3,a3,7
    80006114:	fcf690e3          	bne	a3,a5,800060d4 <virtio_disk_intr+0x44>
  }
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    80006118:	10001737          	lui	a4,0x10001
    8000611c:	533c                	lw	a5,96(a4)
    8000611e:	8b8d                	andi	a5,a5,3
    80006120:	d37c                	sw	a5,100(a4)

  release(&disk.vdisk_lock);
    80006122:	0001f517          	auipc	a0,0x1f
    80006126:	f8650513          	addi	a0,a0,-122 # 800250a8 <disk+0x20a8>
    8000612a:	ffffb097          	auipc	ra,0xffffb
    8000612e:	b8a080e7          	jalr	-1142(ra) # 80000cb4 <release>
}
    80006132:	60e2                	ld	ra,24(sp)
    80006134:	6442                	ld	s0,16(sp)
    80006136:	64a2                	ld	s1,8(sp)
    80006138:	6902                	ld	s2,0(sp)
    8000613a:	6105                	addi	sp,sp,32
    8000613c:	8082                	ret
      panic("virtio_disk_intr status");
    8000613e:	00002517          	auipc	a0,0x2
    80006142:	6ba50513          	addi	a0,a0,1722 # 800087f8 <syscalls+0x3d0>
    80006146:	ffffa097          	auipc	ra,0xffffa
    8000614a:	400080e7          	jalr	1024(ra) # 80000546 <panic>
	...

0000000080007000 <_trampoline>:
    80007000:	14051573          	csrrw	a0,sscratch,a0
    80007004:	02153423          	sd	ra,40(a0)
    80007008:	02253823          	sd	sp,48(a0)
    8000700c:	02353c23          	sd	gp,56(a0)
    80007010:	04453023          	sd	tp,64(a0)
    80007014:	04553423          	sd	t0,72(a0)
    80007018:	04653823          	sd	t1,80(a0)
    8000701c:	04753c23          	sd	t2,88(a0)
    80007020:	f120                	sd	s0,96(a0)
    80007022:	f524                	sd	s1,104(a0)
    80007024:	fd2c                	sd	a1,120(a0)
    80007026:	e150                	sd	a2,128(a0)
    80007028:	e554                	sd	a3,136(a0)
    8000702a:	e958                	sd	a4,144(a0)
    8000702c:	ed5c                	sd	a5,152(a0)
    8000702e:	0b053023          	sd	a6,160(a0)
    80007032:	0b153423          	sd	a7,168(a0)
    80007036:	0b253823          	sd	s2,176(a0)
    8000703a:	0b353c23          	sd	s3,184(a0)
    8000703e:	0d453023          	sd	s4,192(a0)
    80007042:	0d553423          	sd	s5,200(a0)
    80007046:	0d653823          	sd	s6,208(a0)
    8000704a:	0d753c23          	sd	s7,216(a0)
    8000704e:	0f853023          	sd	s8,224(a0)
    80007052:	0f953423          	sd	s9,232(a0)
    80007056:	0fa53823          	sd	s10,240(a0)
    8000705a:	0fb53c23          	sd	s11,248(a0)
    8000705e:	11c53023          	sd	t3,256(a0)
    80007062:	11d53423          	sd	t4,264(a0)
    80007066:	11e53823          	sd	t5,272(a0)
    8000706a:	11f53c23          	sd	t6,280(a0)
    8000706e:	140022f3          	csrr	t0,sscratch
    80007072:	06553823          	sd	t0,112(a0)
    80007076:	00853103          	ld	sp,8(a0)
    8000707a:	02053203          	ld	tp,32(a0)
    8000707e:	01053283          	ld	t0,16(a0)
    80007082:	00053303          	ld	t1,0(a0)
    80007086:	18031073          	csrw	satp,t1
    8000708a:	12000073          	sfence.vma
    8000708e:	8282                	jr	t0

0000000080007090 <userret>:
    80007090:	18059073          	csrw	satp,a1
    80007094:	12000073          	sfence.vma
    80007098:	07053283          	ld	t0,112(a0)
    8000709c:	14029073          	csrw	sscratch,t0
    800070a0:	02853083          	ld	ra,40(a0)
    800070a4:	03053103          	ld	sp,48(a0)
    800070a8:	03853183          	ld	gp,56(a0)
    800070ac:	04053203          	ld	tp,64(a0)
    800070b0:	04853283          	ld	t0,72(a0)
    800070b4:	05053303          	ld	t1,80(a0)
    800070b8:	05853383          	ld	t2,88(a0)
    800070bc:	7120                	ld	s0,96(a0)
    800070be:	7524                	ld	s1,104(a0)
    800070c0:	7d2c                	ld	a1,120(a0)
    800070c2:	6150                	ld	a2,128(a0)
    800070c4:	6554                	ld	a3,136(a0)
    800070c6:	6958                	ld	a4,144(a0)
    800070c8:	6d5c                	ld	a5,152(a0)
    800070ca:	0a053803          	ld	a6,160(a0)
    800070ce:	0a853883          	ld	a7,168(a0)
    800070d2:	0b053903          	ld	s2,176(a0)
    800070d6:	0b853983          	ld	s3,184(a0)
    800070da:	0c053a03          	ld	s4,192(a0)
    800070de:	0c853a83          	ld	s5,200(a0)
    800070e2:	0d053b03          	ld	s6,208(a0)
    800070e6:	0d853b83          	ld	s7,216(a0)
    800070ea:	0e053c03          	ld	s8,224(a0)
    800070ee:	0e853c83          	ld	s9,232(a0)
    800070f2:	0f053d03          	ld	s10,240(a0)
    800070f6:	0f853d83          	ld	s11,248(a0)
    800070fa:	10053e03          	ld	t3,256(a0)
    800070fe:	10853e83          	ld	t4,264(a0)
    80007102:	11053f03          	ld	t5,272(a0)
    80007106:	11853f83          	ld	t6,280(a0)
    8000710a:	14051573          	csrrw	a0,sscratch,a0
    8000710e:	10200073          	sret
	...
