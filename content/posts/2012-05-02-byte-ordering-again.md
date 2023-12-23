---
title: "Byte Ordering - Again"
date: 2012-05-02T21:03:43+02:00
draft: false
---

One practical alternative to #ifdef BIG\_ENDIAN bar #else foo #endif clutter
in your code are the following two functions. They can always be used, no
matter on what architecture the code runs. It always return the correct
byte order.



```
uint32\_t le\_pick(char \*data)
{
        return (data[3]<<0) | (data[2]<<8) | (data[1]<<16) | (data[0]<<24);
}

uint32\_t be\_pick(char \*data)
{
        return (data[0]<<0) | (data[1]<<8) | (data[2]<<16) | (data[3]<<24);
}

```

The idea is based on a blog entry from [Rob Pike](http://commandcenter.blogspot.de/2012/04/byte-order-fallacy.html). The code
is a little bit slower compared to the native encoded version (used directly with
typical ifdef clutter). But there are more advanages to use this code:


* no separete (unit) testing is required for little and big endian machines - especially for productive code where it is hard to test endian effects this is major point.
* because char addressing is used no aligment requirements are raised (natural alignment requirements)
* it is more clear and no seperated code through #ifdef code
* it is fast anyway


Two months back Davem talked about his SPARC strlen() assembler
optimization. Linus hijacked the discussion and said something really clever.
He compared little and big endian and in the end you realized that big endian
is a mass. Normally it doesn't matter what byte order is used on a machine.
There are two main areas where it matters: if you do some bit operation and b)
network operation. For case a) you want to enumerate the bytes on a bit basis.
E.g. for BIT 0 is on byte 0, bit 31 is on byte 3 - this is consequent and
fullfilled with little endian adressing. Big endian machines are switched and
you have to switch the bytes manually - which consume additional CPU cycles.
You have no possibility to optimize this code (see Davems strlen()
implementation). For case b) (network operation): this is a design issue. You
can consider this as a historic failure and a handmade problem! Not nice but we
must live with that.


BTW: gcc is able to generate really lean code for both functions:



```
0000000000000000 <le\_pick>:
   0: 0f be 47 02           movsbl 0x2(%rdi),%eax
   4: 0f be 57 01           movsbl 0x1(%rdi),%edx
   8: c1 e0 08              shl    $0x8,%eax
   b: c1 e2 10              shl    $0x10,%edx
   e: 09 d0                 or     %edx,%eax
  10: 0f be 57 03           movsbl 0x3(%rdi),%edx
  14: 09 d0                 or     %edx,%eax
  16: 0f be 17              movsbl (%rdi),%edx
  19: c1 e2 18              shl    $0x18,%edx
  1c: 09 d0                 or     %edx,%eax
  1e: c3                    retq
  1f: 90                    nop

0000000000000020 <be\_pick>:
  20: 0f be 47 01           movsbl 0x1(%rdi),%eax
  24: 0f be 57 02           movsbl 0x2(%rdi),%edx
  28: c1 e0 08              shl    $0x8,%eax
  2b: c1 e2 10              shl    $0x10,%edx
  2e: 09 d0                 or     %edx,%eax
  30: 0f be 17              movsbl (%rdi),%edx
  33: 09 d0                 or     %edx,%eax
  35: 0f be 57 03           movsbl 0x3(%rdi),%edx
  39: c1 e2 18              shl    $0x18,%edx
  3c: 09 d0                 or     %edx,%eax
  3e: c3                    retq

```

