---
title: "UDP TX and RX Delays"
date: 2010-07-20T14:15:37+02:00
draft: false
---

The following image illustrates the accumulated delays during the transmission
of UDP packets. Starting with a 1 second sleep with theoretical no delay, but
practical delay of ~200 microseconds on a un-busy box till due to timer
granularity and concurrent processes (not in this scenario), till transmission
delays via intermediate routers, NIC interrupt moderation and finally RX side
scheduler latency.


!http://blog.jauu.net/2010/07/20/UDP-TX-and-RX-Delays/udp-rx-tx-delay-thumb.png!


