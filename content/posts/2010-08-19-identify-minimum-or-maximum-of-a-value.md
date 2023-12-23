---
title: "Identify Minimum or Maximum of a Value"
date: 2010-08-19T21:58:08+02:00
draft: false
---

To identify the minimum or maximum of two values often a simple if else
construct is used:



```
if (a < b) min = a; else min = b;

```

or more compact using the ternary operator:



```
min = (a < b) ? a : b;

```

The generated instructions for the first if/else construct and the ternary
operator does not differs. At least if the compiler is instructed to optimize
the code. If the code is not optimized the compiler generates a little bit
awkward code with a branch for the former example. The later use a branch free
@cmovle@ instruction on a @x86\_64@ architecture:



```
[...]
movl  %edi, -20(%rbp)
movl  %esi, -24(%rbp)
movl  -20(%rbp), %eax
cmpl  %eax, -24(%rbp)
cmovle  -24(%rbp), %eax
movl  %eax, -4(%rbp)
movl  -4(%rbp), %eax
leave

```

The kernel provided macros for @min/max@ extend this by execute an apparently
unnecessary pointer comparison via:



```
(void) (&\_max1 == &\_max2);

```

This check was introduced to enable strict type-checking to make sure that both
arguments are of the same type. I build a patch to extend the current two
operand limited macro and enable the use for three operands too. This will save
some bytes on the stack as well as some processing cycles:



```
#define min3(x, y, z) ({ \
 typeof(x) \_min1 = (x); \
 typeof(y) \_min2 = (y); \
 typeof(z) \_min3 = (z); \
 (void) (&\_min1 == &\_min2 == &\_min3); \
 \_min1 < \_min2 ? (\_min1 < \_min3 ? \_min1 : \_min3) : \
 (\_min2 < \_min3 ? \_min2 : \_min3); })

```

