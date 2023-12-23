---
title: "Tracing and Time Measurements"
date: 2010-07-07T22:56:09+02:00
draft: false
tags: [linux, tracing]
---

In user-space the answer is often simple: use @gettimeofday@ if microseconds
resolution is sufficing. Another often used mechanism is to use the time stamp
counter - but as mentioned in another blog-post in the lion share of all use
cases the advice is often too narrow because of clock variances in SMP/CMP
systems and hibernation issues.



```
#define rdtscll(val) \
 \_\_asm\_\_ \_\_volatile\_\_("rdtsc" : "=A" (val))

```

In kernel-space the timing capabilities are a little bit more complex and
several functions are provided. Three new kinds functions are available, both
with different scalability and precision:


* *trace\_clock* -- this clock is good compromise of the other clocks. The clock
is not completely serialized but try to level CPU boundaries.
* *trace\_clock\_local* -- complete un-serialized, lowest latency.
* *trace\_clock\_global* -- use clock at core with id 0, highest latency.


All three clocks provide u64 nanoseconds granularity (but not precision ;).
At the end it is often more crucial to get exact timings as a precise
timestamping mechanism with a small latency but variances of several
magnitudes due to SMP/CMP issues.


