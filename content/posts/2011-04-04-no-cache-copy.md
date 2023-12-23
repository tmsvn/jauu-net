---
title: "No Cache Copy"
date: 2011-04-04T18:24:10+02:00
draft: false
---

Tom posted these days a patch called "Allow no-cache copy from user on
transmit". The idea behind is the following: in net/ipv4/tcp.c:tcp\_sendmsg()
will copy date from user buffer to sk\_buff via copy\_from\_user() or
csum\_and\_copy\_from\_user() (which does what the name implies: copy the data
and calculate a (partial) checksum). Tom realized that when data is copied
data caches are touched which are often not used afterwards.


The feature is enabled if the device signals that he is doing some kind of
checksum offloading. So that the driver must not touch any data - calculate the
checksum. In other words: this feature is disabled if software checksumming is
required. There some other interplay (e.g. with loopback interface) but these
are covered. The feature is also configurable via ethtool.


Some measurements (200 instances of netperf TCP\_RR):



```
No-cache copy enabled:
   702113 tps, 96.16% utilization,
   50/90/99% latency 238.56 467.56 956.955

Using 14000 byte request and response sizes demonstrate the
effects more dramatically:

No-cache copy disabled:
   79571 tps, 34.34 %utlization
   50/90/95% latency 1584.46 2319.59 5001.76

No-cache copy enabled:
   83856 tps, 34.81% utilization
   50/90/95% latency 2508.42 2622.62 2735.8

```

The patch seems fine but Davem take them out because of some coding issues.


