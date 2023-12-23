---
title: "PCI Express Network Adapter Performance"
date: 2011-08-02T12:59:54+02:00
draft: false
tags: [nic, pci]
---

Today I spent quite some hours in spotting some packet drops at Gigabit line
rate. Stress-testing the hardware at line-rate reveal a lot of noise and
disagreements: it is difficult to determine \_what\_ really is the source of
packet drops. Due to some netperf and perf analysis and some new tracepoints
the eyes focus on PCI express bus.


Quite a lot of analysis until that, first I interpreted the raw values as a CPU
limitation. E.g. the CPU may not fast enough to keep @sk\_buff@'s to the
adapter. Adjusting the interrupt rate or adjusting the RX/TX ring buffer size
are adequate actions, but as I indicated, the CPU was not the limiting
factor in the end.


I started to adjust the e1000e driver with some PCI driver modification to set the
maximum read request size. I hope I can provide some graphs tomorrow for 1 byte
packets and Ethernet Jumbo Frames.


