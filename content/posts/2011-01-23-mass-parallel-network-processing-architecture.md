---
title: "Mass Parallel Network Processing Architecture"
date: 2011-01-23T14:01:46+02:00
draft: false
tags: [optimization, epoll]
---

Yesterday and today I wrote an ANSI C program to demonstrate how a non-blocking,
threaded network server for current SMP/CMP systems may be structured. The
design of the server is constructed in a way that all CPU may stressed and load
is fair balanced. All thread local clients are multiplexed via a event loop
management wrapper (epoll() or select()).


The program demonstrate the most effective architecture for current CMP/SMP
server systems. One or more passive server sockets is shared by all threads.
These file-descriptors are put into \_all\_ thread local event loop and monitored
for EV\_READ. Each a new client connect() the server will trigger a EV\_READ
in one till probably all threads! The actual number of awaken threads depends
on the Kernel internal handling. Anyway, next step for all threads is to call
accept(), but only one thread will return with a new file-descriptor. The
other threads will return -1 and errno is set to EWOULDBLOCK. If this happens
the thread knows that another thread was a little bit faster.


![images/thread-arch.png](images/thread-arch.png)
The next step for the lucky thread is to process the client request and put the
new client descriptor in the local event management loop. Voila, the next
events are handled by this thread.


This time the program is not programmed in a portable way. On the contrary the
program is really Linux centric to gain the maximum performance and use Linux
specific hooks. With some modifications the program should be ported to \*BSD
too.


What the current design not support is active load-balancing of work. But as more
unfair a CPU is penalized the more likely is that new connections are handled
by the idle CPU and therefore after a while a equilibration is reached.



```
ps ax -L -o pid,tid,psr,pcpu,comm | grep -r parallel -
17020 17020   0  0.0 parallel-net
17020 17021   0  0.0 parallel-net
17020 17022   1  0.0 parallel-net
17020 17023   2  0.0 parallel-net
17020 17024   3  0.0 parallel-net
17020 17025   4  0.0 parallel-net
17020 17026   5  0.0 parallel-net

```

In the next couple of days I will publish the git repository and give a short
notice here in the blog.


