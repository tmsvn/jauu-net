---
title: "Epoll versus Select"
date: 2011-01-19T15:06:25+02:00
draft: false
---

I finished the select() backend for [libeve](http://libeve.dev.jauu.net/) Thus
libeve can be compiled under nearly every operating system in this solar system
(I didn't even tried it, but the functional components are ready). Primary
focus was and is Linux, I am not necessarily interested in other systems. Under
Linux epoll/timer\_fd is the best what you can do if you want to do. Under {Free, Net, Open, ...}BSD
kqueue should be the most performant implementation, but doe to lack of time
and interest it isn't implemented and select() should be fine too.


Some analysis draw another picture on the wall:


![images/epoll.png](images/epoll.png)
The good value for select() are a little bit misleading: epoll \_will\_ outperform select and poll if a sub-set of descriptors are ready. The presented test here make \_all\_ descriptors in the set readable. So the negative performance impact is caused due to massive context switched (e.g. each context switch for epoll() to get information, where the select() set is already set with one system call). Increasing the EVE\_EPOLL\_ARRAY\_SIZE should relax the context switch overhead (currently 64).


