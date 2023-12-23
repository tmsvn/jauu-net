---
title: "IO Scheduling Classes and Compiling Larger Projects"
date: 2010-06-19T13:22:04+02:00
draft: false
tags: [linux, ionice]
---

Occasionally I am forced to build larger parts of kernel, not only the "hot area". This is mainly
caused trough modified header files at a prominent position (e.g. tcp.h) or through some
updates where the timestamps are updated. Depending on the current workload I
restrict the CPU usage by not provide the full SMP load via -j N.


But this is one kind of load - the other is IO/disk load. So as I said sometimes I
want restrict IO usage too. Via ionice it is possible to set the program IO
scheduling class:


* *Idle*, get only get disk time when no other program has asked for disk IO
* *Best effort* (aka none class), standard IO class for a program. A feature of this class is that an IO priority can be assigned. Range from 0 (highest) to 7 (lowest). Within the same priority IO is scheduled in a round robin fashion. Without any modification the standard IO priority is derived from the CPU nice level: (cpu nice level + 20) / 5
* *Real time*, behaves similar to the realtime CPU class and can starve the IO
subsystem. I have no use case and therefore never used it.


If I want to reduce the IO impact of the compile process I type the following
command to set the IO scheduling class of the shell to idle. All derived
processes (via fork()/exec()) will inherit the scheduling class.



```
ionice -c3 -p$$

```

PS: it works only with the completely fair queueing IO scheduler (cat /sys/block/\*/queue/scheduler)


