---
title: "BPF Optimizer"
date: 2010-06-10T15:34:59+02:00
draft: false
tags: [optimization, bpf]
---

I started to analyse the BPF optimizer. Several options helped me: "-d" to dump
the generated instructions and "-O" to disable the packet-matching code
optimizer (normally only useful if you suspect a bug in the optimizer).


So my modified kernel (I will post the kernel patch after I reworked the
tracing ring buffer implementation) and the tcpdump possibilities we are now in
the ability to analyse exactly how the optimizer works.


So here we go


A null filter is a plain ret instruction evaluated into



```
(000) ret      #65535

```

"ip" is translated into (no difference with w/o or w/ optimization):



```
(000) ldh      [12]
(001) jeq      #0x800           jt 2  jf 3
(002) ret      #65535
(003) ret      #0

```

A "tcp" filter is encoded into the following instructions:



```
(000) ldh      [12]
(001) jeq      #0x86dd          jt 2  jf 4
(002) ldb      [20]
(003) jeq      #0x6             jt 7  jf 8
(004) jeq      #0x800           jt 5  jf 8
(005) ldb      [23]
(006) jeq      #0x6             jt 7  jf 8
(007) ret      #65535
(008) ret      #0

```

A "tcp" filter unoptimized is encoded into this:



```
(000) ldh      [12]
(001) jeq      #0x86dd          jt 2  jf 4
(002) ldb      [20]
(003) jeq      #0x6             jt 8  jf 4
(004) ldh      [12]
(005) jeq      #0x800           jt 6  jf 9
(006) ldb      [23]
(007) jeq      #0x6             jt 8  jf 9
(008) ret      #65535
(009) ret      #0

```

