---
title: "Linux Network Emulator Extensions"
date: 2012-01-05T18:00:05+02:00
draft: false
---

Seems that the merge window for the upcomming 3.2 close. In davem's net-next
for 3.3 there are a couple of network emulator improvements: *rate extension
allows to shape the traffic to n bytes/second*


Currently netem is not in the ability to emulate channel bandwidth. Only static
delay (and optional random jitter) can be configured. To emulate the channel
rate the token bucket filter (sch\_tbf) can be used. But TBF has some major
emulation flaws. The buffer (token bucket depth/rate) cannot be 0. Also the
idea behind TBF is that the credit (token in buckets) fills if no packet is
transmitted. So that there is always a "positive" credit for new packets. In
real life this behavior contradicts the law of nature where nothing can travel
faster as speed of light. E.g.: on an emulated 1000 byte/s link a small
IPv4/TCP SYN packet with ~50 byte require ~0.05 seconds - not 0 seconds.


Netem is an excellent place to implement a rate limiting feature: static delay
is already implemented, tfifo already has time information and the user can
skip TBF configuration completely. This patch implement rate feature which can
be configured via tc. e.g:



```
tc qdisc add dev eth0 root netem rate 10kbit

```

To emulate a link of 5000byte/s and add an additional static delay of 10ms:



```
tc qdisc add dev eth0 root netem delay 10ms rate 5KBps

```

Note: similar to TBF the rate extension is bounded to the kernel timing
system. Depending on the architecture timer granularity, higher rates (e.g.
10mbit/s and higher) tend to transmission bursts. Also note: further queues
living in network adaptors; see ethtool(8).


Second patch was the cell concept extension. This extension can be used to
simulate special link layer characteristics. Simulate because packet data is
not modified, only the calculation base is changed to delay a packet based on
the original packet size and artificial cell information.


packet\_overhead can be used to simulate a link layer header compression
scheme (e.g. set packet\_overhead to -20) or with a positive
packet\_overhead value an additional MAC header can be simulated. It is
also possible to "replace" the 14 byte Ethernet header with something
else.


cell\_size and cell\_overhead can be used to simulate link layer schemes,
based on cells, like some TDMA schemes. Another application area are MAC
schemes using a link layer fragmentation with a (small) header each.
Cell size is the maximum amount of data bytes within one cell. Cell
overhead is an additional variable to change the per-cell-overhead
(e.g. 5 byte header per fragment).


Example (5 kbit/s, 20 byte per packet overhead, cell-size 100 byte, per
cell overhead 5 byte):



```
tc qdisc add dev eth0 root netem rate 5kbit 20 100 5

```

Eric also fixed classful handling of netem. Some month back someone removed the
feature and netem was only able to act as a leave module. With Erics patch it
is again now possible to add SFQ to netem. Sure this feature is more
sophisticated but at least I will have a use case for this.


A couple of fixes and Stephen added userspace support for iproute to use the
new loss model (markov-chain based). So a lot of changes for netem in this
merge window. Last but not least I have another larger patch for the next merge
window ... ;-)


