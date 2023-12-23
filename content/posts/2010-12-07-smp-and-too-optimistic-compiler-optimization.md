---
title: "SMP and too Optimistic Compiler Optimization"
date: 2010-12-07T22:18:29+02:00
draft: false
tags: [optimization, smp, gcc]
---

In a nowadays common SMP/CMP environment with more then one CPU it is necessary
to protect global/shared data in the kernel. One prominent example are
*sysctl\_* variables. Sysctl variables are protected via a spin lock
(sysctl\_lock). This look protect the /proc/sysctl interface path, the look
itself does not protect the usage path itself. Consider the following example:



```
int global\_val;
int foo(void) {
  if (global\_val != 0) {
    int res = bar();
    return res / global\_val;
  }
  return -1;
}

```

Here global\_val is a global accessible variable. If you are fit in spotting
errors and remember that we are in a SMP/CMP environment you will notice that
global\_val is not protected. Thus during the execution of bar(), global\_val
may might be change, in a worst case to zero.


One solution might be the following code fragment:



```
int global\_val;
int foo(void) {
  int tmp\_cpy = global\_val;
  if (tmp\_cpy != 0) {
    int res = bar();
    return res / tmp\_cpy;
  }
  return -1;

```

This may looks fine, but as you can imagine there is another flaw in the code!
The problem is that the compiler may eliminate tmp\_cpy and read the
global\_val twice! The correct code may look like this:



```
int global\_val;
int foo(void) {
  int tmp\_cpy = \*(volatile int \*) &(global\_val);
  if (tmp\_cpy != 0) {
    int res = bar();
    return res / tmp\_cpy;
  }
  return -1;

```

This guard prevents the compiler from merging or refetching accesses - no more,
no less.


The bottom line is either you protect every piece of shared data costly or you
know how your compiler act and you can rely on you tests (regardless if
automated or you crowd source your testing ;-).


