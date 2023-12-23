---
title: "mlock and SCHED_FIFO"
date: 2008-05-04T18:26:54+02:00
draft: false
tags: [realtime, sched-fifo, mlock]
---

mlock() allows to lock the (current or further used) address space to physical
memory. It therefor disables paging for the selected memory (or all for
mlockall()). Real-time programs often uses the ability to fix their memory to
avoid unpredictable situations. Think about a welding- or laser robot with
out-swapped memory ...


mlockall() is the big brother of mlock(): you specify that all currently
(MCL\_CURRENT) or future touched (MCL\_FUTURE) pages are locked. This includes
code (text segment), data and stack, shared libraries, user space kernel data,
shared memory and memory-mapped areas.


Occasional I utilize mlockall() for performance measurements to ensure test
reliability. Bundled with SCHED\_FIFO (a realtime scheduling policy) you obtain
a much cleaner measurement ( exclude IO operations completely (writes to disks,
network, whatever)). If you follow this tips you will get clean measurements -
but that's another topic).


But one surprising fact appear by deeper analyses of an algorithm (it was a
fast, SIMD enriched Hamming distance calculation - but this doesn't matter
here): the mlock() free version of the program achieve better results then the
mlock() version.


w/o mlock():


![images/mlock-fifo-1.png](images/mlock-fifo-1.png)
w mlock():


![images/mlock-fifo-2.png](images/mlock-fifo-2.png)
See the irregular area in the lower figure? The peaks are all higher (and
therefore disadvantages for the algorithm).


