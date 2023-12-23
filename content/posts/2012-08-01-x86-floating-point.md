---
title: "x86 Floating Point"
date: 2012-08-01T15:16:05+02:00
draft: false
---

x86 Floating Point was and still is a source of problems. First of all the FPU
(floating point coprocessor, x87) has 8 registers. Via gdb and info
all-register you can display the floating point register. These registers are all
80 bit wide. And here the problems start: standardized are floating point math
with 32 or 64 bit (float or double). If you compile the next construct with
-m32 on a 32bit and a 64bit arch the results will differ:



```
double val = 52.30582;
double d = 3600.0 \* 1000.0 \* val;
long l = long( d );
long l2 = long( ( 3600.0 \* 1000.0 \* val ) );
long l3 = (long)( 3600.0 \* 1000.0 \* val );
long l4 = long( 3600.0 \* 1000.0 \* val );

cout.precision( 20 );
cout << "Original value : " << val << endl;
cout << "Double with mult : " << d << endl;
cout << "Casted to long v1 : " << l << endl;
cout << "Casted to long v2 : " << l2 << endl;
cout << "Casted to long v3 : " << l3 << endl;
cout << "Casted to long v4 : " << l4 << endl;

```

So as I said that on both archs the results will differ! If you enable GCC
optimization (e.g. -O3) results may not differ! Huh? The problem here is that
as I wrote in the first paragraph that the floating point unit will use a 80
bit wide register. If you enable optimization GCC will (can) use the MMX/SSE
unit which in turn will use 64 bit wide register. That is a known problem,
especially in numeric sensitive environments. Which often disable x87 floating
point unit. You can enforce x86 arithmetic with -fexcess-precision=std /
-ffloat-store. Or even better (because faster): -mfpmath=sse -msse2.


The background why 80bit register are introduced by Intel can be read in <http://en.wikipedia.org/wiki/Extended_precision>


