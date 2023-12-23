---
title: "CPU Cycles versus Cacheline Miss"
date: 2010-06-14T13:18:14+02:00
draft: false
---

Optimization changed over time - optimization today does not address CPU
cycle/instruction, rather reduced memory transaction are the key to success.
Keep the code small and keep the code in the cacheline and reduce memory loads.
A cache miss is equivalent to 100 instructions during a CPU stall. Therefore
keeping the @.text@ footprint small can boost your application more then some
sophisticated CPU tweaks. Pahole provides a feeling how the @.data@ segment is
constructed, how structs are aligned in memory, it provides information if
holes in structs exists and how the linker align the data at boundaries. This
scratches the surface of optimization techniques and the kernel uses highly
sophisticated techniques to optimize for memory transactions: false sharing of
elements which are used mainly readonly (put it in another @.data@ section),
align data on different cachelines to avoid false sharing, UNinline functions
to reduce the memory footprint and so on.


One of the best books to understand this kind of optimization is called "UNIX
Systems for Modern Architectures - Symmetric Multiprocessing and Caching for
Kernel Programmers" from Curt Schimmel. This is by far the best book in this
area. Beside this the optimization manuals from AMD and INTEL are worth to read
it too, because they provide a in deep understanding about the actual processor
specific tweaks.


