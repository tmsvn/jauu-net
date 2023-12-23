---
title: "CRC 16 CCITT Performance"
date: 2010-07-12T23:49:49+02:00
draft: false
---

The CRC-16-CCITT is a cyclic redundancy check - one among many - defined and
derived from polynomial *x^16^ + x^12^ + x^5^ + 1*. It is used by X.25, HDLC,
XMODEM, bluetooth, phy header verification and many others. During some
analysis I stumbled across the following implementation:



```
unsigned char ser\_data;
static unsigned int crc;

crc  = (unsigned char)(crc >> 8) | (crc << 8);
crc ^= ser\_data;
crc ^= (unsigned char)(crc & 0xff) >> 4;
crc ^= (crc << 8) << 4;
crc ^= ((crc & 0xff) << 4) << 1;

```

The expression @(crc << 8) << 4@ quizzicaled me a little bit because @crc<<12@
seems more efficient and is mainly equivalent. The advice on the
"site":<http://www.eagleairaust.com.au/code/crc16.htm> is to implement the above
algorithm with the two shift operation because the latter generates much more
code and executes slower! I compiled the above code fragment, disabled any
optimization and voila:



```
[...]
shrb  $4, %al
movzbl  %al, %eax
xorw  %ax, -2(%rbp)
movzwl  -2(%rbp), %eax
sall  $12, %eax
movl  %eax, %edx
movzwl  -2(%rbp), %eax
xorl  %edx, %eax
movw  %ax, -2(%rbp)
movzwl  -2(%rbp), %eax
andl  $255, %eax
sall  $5, %eax
[...]

```

Independent of the compiler optimization level (@-O0 .. -O7@) the compiler
always generates a 12 bit shift. It is even not possible to instruct the
compiler not to do so. But why does the compiler does not optimize the
construct more aggressively? It does, if the user tell him to do so. ;-) But
these optimization are more cosmetic and restricted to reduce the instruction
set size.



```
shrb  $4, %dl
movzbl  %dl, %edx
xorl  %eax, %edx
movl  %edx, %eax
sall  $12, %eax
xorl  %edx, %eax
movzbl  %al, %edx
sall  $5, %edx
[...]

```

In average the processing time on my @x86\_64@ take @2.06076e^-05^ us@ per byte:


![images/crc.png](images/crc.png)
