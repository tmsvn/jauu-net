---
title: "Head Of Line Blocking"
date: 2011-08-23T20:04:34+02:00
draft: false
---

The last two days I programmed an system with n input channels and n
output channels. The system multiplex the input packet to the actual
output channel, depending on packet IP destination address (and do some
packet mangling, but this does not matter here). But the output channel
can block (the socket returns EAGAIN, e.g. if TCP peer close the window).
Each received packet is enqueued in the input queue. If the output channel
is blocked then the input queue is stalled, no new packet can be
transmitted, although the packet is indent for another output queue - this
is bad.


The problem is also typical for switches: multiple input, multiple output
and sometime the destination is the same output, thus buffering is
required. The following image illustrate the layout of a [Cisco Catalyst
6500](http://www.cisco.com/en/US/prod/collateral/switches/ps5718/ps708/prod_white_paper0900aecd80673385.pdf).
Catalyst do NOT suffer from HOL blocking because buffering is handled in
egress queues - which is superior solution if the multiplex process is
fast enough and do not consume to much cycles.


![images/cisco-hol.png](images/cisco-hol.png)
The idea to use a input queue was performance driven. At line rate - when
CPU processing is at 100% load - I don't wanted to spend the cycles in
packet processing if later on the packet is dropped with a high
probability. So from a performance point of view I don't want to drop the
design. But the performance issues that arise from the HOL blocking are
much more relevant. So I started to look for workaraounds. The following
papers look quit interesting:


[RFIFO: Retreat FIFOs for the Head-of-Line Blocking
problem](http://www.comp.brad.ac.uk/het-net/HET-NETs04/CameraPapers/P6.pdf)


[Head of Line blocking prevention technique based on multiple input queues
per priority](http://www.cni.co.th/download/cni_co_th/kb_dc_head%20of%20line%20blocking%20prevention.pdf)


