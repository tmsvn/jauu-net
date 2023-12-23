---
title: "Network Stack Hash Table Memory Consumption"
date: 2010-06-08T21:06:10+02:00
draft: false
---

I stumbled across the default hash size for the different hash tables used in
the network subsystem. Hash tables are used as a efficient container for
different network subsystems - compared to let say list containers. The optimal
complexity of a hash table is O(1), this means access in constant time, no
matter how many entries are in the container. The optimum is a theoretical
value and requires a hash bucket fill level from maximum ~60 percent as well as
good hashing algorithms. Higher workloads tends to collisions, this again
shift the complexity of the container from O(1) to O(n). Linux provides the
Jenkins Hash function as one of the best hashing algorithm. Some network
components use their own hash function because they can do it better because of
a good key knowledge.


The fact the the fill level should not be higher they ~60 percent is a little
bit problematic. Some major hash table implementation dynamically extend or
shrink the hash table size depending on the current workload to guarantee this
fill level. Within the Linux kernel this is not as easy as it requires a
clever locking mechanism and some other difficult quirks, therefore no dynamic
approach is applied. As a consequence the default hash table size is sized for
worst case workloads (e.g. server systems, ...).


If I sum up all network related hash tables nearly 0.5 percent of the main
memory are use for containers:



```
TCP established hash table: 4194304 bytes
TCP bind hash table:        1048576 bytes
IP route cache hash table:   524288 bytes
UDP hash table:               32768 bytes
UDP-Lite hash table:          32768 byte

```

The .text segment of my current kernel consumes only 6241407 bytes! Free memory
is bad memory -- sure, but wasted memory is bad memory too.


