---
title: "BPF Filter Complexity versus Execution Time"
date: 2010-06-10T12:49:29+02:00
draft: false
---

Today after some time-killing IETF debates I started to analyze the in-kernel BPF filter
execution time for different BDP filters. Starting with no filter, which is
translated into a simple @BPF\_RET|BPF\_K@ OPCODE till some more complex
instructions. The average execution time lies somewhere at 300ns for no filter
and somewhere above 350ns for a simple ICMP filter with 17 CPU instructions on
my x86\_64 (excluding call overhead).


The next image illustrates this (statistically sampled data):


![images/bpf-complex.png](images/bpf-complex.png)
