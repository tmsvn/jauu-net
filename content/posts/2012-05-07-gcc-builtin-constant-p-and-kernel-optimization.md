---
title: "GCC Builtin Constant P and Kernel Optimization"
date: 2012-05-07T12:23:29+02:00
draft: false
tags: [perf, gcc]
---

Yesterday a discussion on LKML raised the question if it is possible to
*disable* optimization for kernel build. Sometimes you want to debug the kernel
and the required function is optimized out. You are free to disassembly the
source code at this place and set the break point manually. But this procedure
is time consuming and error prone. I raised another use case: perf probes.
Dynamic probepoints placed in the Kernel at runtime. For example you can check
if a function is probeable via:



```
perf probe -k /usr/src/build-net-next/vmlinux -s /usr/src/linux --line tcp_rcv_established

```

But then if you place a probepoint you will eventually realize that this
particular code is optimized out. Sometimes I used probepoint in kernel to
understand time-critical intrinsic behavior.
So there are use cases where the hard optimization is not required or even
wanted! The reader may now note to disable kernel optimization and voilà. But
there are some obstacles. The Linux Kernel per default is build with O2 or
if OPTIMIZE\_FOR\_SIZE is selected with 0s. Both include a lot of gcc
switches to optmize code. Among other flags -finline-small-functions,
-fpartial-inlining and -findirect-inlining. Hypothetical: if build with
no optimization at all, some function are always enabled because some of the
Linux code is annotated with always inline attribute.


<http://www.delorie.com/gnu/docs/gcc/gcc_81.html>


A last warning: unoptimized builds are not tested (or at least only a few
people have ever tested such a kernel)! So please do not use this kernel where
sensitive data is stored!


