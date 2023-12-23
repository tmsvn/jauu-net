---
title: "Point Of Interest"
date: 2008-06-07T23:17:08+02:00
draft: false
tags: [optimization, hamming-distance]
---

Through some additional performance measurements I realize some interesting
plateau. Two points are of interest, first at ~200 byte and the seconds at 600
byte (the x scale is denoted as DWORD size (uint32\_t)


![images/hamming.png](images/hamming.png)
Also quit interesting: the long duration to "warm" the cache, tlb, etc ..
(BTW: we talk about microseconds)


