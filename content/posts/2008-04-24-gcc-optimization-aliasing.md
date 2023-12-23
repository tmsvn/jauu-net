---
title: "GCC Optimization Aliasing"
date: 2008-04-24T22:47:27+02:00
draft: false
---

In talks I often noted that in the a big part, pointer casts are dump and
futile. The C Standard stated out that a cast to another type raise an
"undefined behavior":



```
float a = 23.f; uint32\_t b = \*(uint32\_t \*)&a;

```

Depending on the current gcc version this leads to different results in b.
Sometimes a is interpreted as a uint32\_t type (that what you want - probably) -
sometimes the result is 0;


The interesting part come now into play: why 0, why should a compiler catch
that user failure and invest CPU cycles here? Why not interpret an values of
type x as type y?


The answer is: it is not a service for the user, it is an compiler optimization
technique called aliasing.


The root of many optimization challenges in C are pointers. Often it is
impossible to predict a values, because a pointer had always the change to
modify a memory location. Nor does somebody know how many pointers, points to a
particular value. This circumstance prevent the compiler from a lot of
optimization.


The optimization is, that the C standard document stated out, that a pointer
cannot point to a locations of different type (with the exception of char \*)
and gcc utilize this circumstance! The compiler can therefor optimize code
because he can ensure that they doesn't interfere.


If you really need transparent access and interpret a value as a values of
another types take a union type:



```
union conv {
  float f;
  uint32\_t ui32;
};

```

