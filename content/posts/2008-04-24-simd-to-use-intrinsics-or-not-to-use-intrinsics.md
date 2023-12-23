---
title: "SIMD To Use Intrinsics Or Not To Use Intrinsics"
date: 2008-04-24T22:07:49+02:00
draft: false
tags: [optimization, simd]
---

At a high level, intrinsics is something like a different syntax for vanilla
SIMD asm. For example to add two 128 bit width vectors you can use \_mm\_add\_ps()
(thats leads to a SSE instructions).


The advantage of using intrinsic is that both, gcc and icc understand them. No
need to #ifdef \_\_GCC\_\_ and other compile-time hacks. On the other side, i386
intrinsics are limited. For every SIMD extension (mmx, sse, ...) you must
implement a own specialized version via



```
#ifdef \_\_SSE2\_\_
[...]
#else
# error Programmed Error
#endif

```

If you use it with gcc, gcc will instantly expand them to \_\_builtin\_ia32\_addps
- a gcc built-in (search the gcc header search path for xmmintrin.h - type gcc
-print-search-dirs if you doesn't know the current search paths).


The other opinion is to let the compiler optimize your code. But often the code
is to complex that the compiler isn't able to do this task!


At the end: if you MUST use SIMD extension you SHOULD use intrinsics. They are
more portable, more readable compared to asm and the introduced loss of
control, also compared to vanilla asm is evanescent humble.


