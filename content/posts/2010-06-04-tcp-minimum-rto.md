---
title: "TCP Minimum RTO"
date: 2010-06-04T19:48:47+02:00
draft: false
tags: [networking, tcp, tcp-rto]
---

Actually $user posted a regression that he measured a RTO of less then 200ms
via tcpdump. Normally this is not possible because Linux bounds the minimum to
200ms. So lets see what the actual trace offers.


"RFC 2988":<http://tools.ietf.org/html/rfc2988> specifies that the minimum TCP
Retransmission Timeout (RTO) SHOULD be 1 second. The relative large value was
selected to keep TCP conservative and avoid spurious retransmissions. The
RFC was written back in 2000 and things changed. The timer and clock granularity of
current operating systems is more accurate and allow a more fine grained minimum.
Furthermore, analysis had demonstrated that a RTO of 1 second badly breaks
throughput in environments faster then 33kB with minor packet loss rate (e.g.
1%).


Therefore current Operating Systems use a RTO smaller then 1 second. Linux
defaults to 200ms and FreeBSD to even 30ms. At least Linux implement a
algorithm called Forward RTO Recovery to detect spurious timeouts. This also
permits the use of a reduced RTO and make the 1 second suggestion superfluous.


Also of impact is the interplay with Delayed ACKs: "The TCP Minimum RTO Revisited":<http://utopia.duth.gr/~ipsaras/minrto-networking07-psaras.pdf>


*UPDATE:* $user emailed the tcpdump traces and no spurious timeout triggered packet is identifiable:



```
000027 IP 1.46799 > 2.47500: 168809236:168812132(2896) ack 1 win 46 <nop,nop,timestamp 1375977402 2077240628>
000024 IP 1.46799 > 2.47500: 168812132:168815028(2896) ack 1 win 46 <nop,nop,timestamp 1375977402 2077240628>
000029 IP 1.46799 > 2.47500: 168815028:168817924(2896) ack 1 win 46 <nop,nop,timestamp 1375977402 2077240628>
000077 IP 2.47500 > 1.46799: ack 168786068 win 16200 <nop,nop,timestamp 2077240629 1375977402>
000006 IP 2.47500 > 1.46799: ack 168787516 win 16200 <nop,nop,timestamp 2077240629 1375977402,nop,nop,sack 1 {168801996:168804892}>
000002 IP 2.47500 > 1.46799: ack 168787516 win 16200 <nop,nop,timestamp 2077240629 1375977402,nop,nop,sack 1 {168801996:168806340}>
000001 IP 2.47500 > 1.46799: ack 168787516 win 16200 <nop,nop,timestamp 2077240629 1375977402,nop,nop,sack 1 {168801996:168809236}>
000002 IP 2.47500 > 1.46799: ack 168787516 win 16200 <nop,nop,timestamp 2077240629 1375977402,nop,nop,sack 1 {168801996:168812132}>
000003 IP 2.47500 > 1.46799: ack 168787516 win 16200 <nop,nop,timestamp 2077240629 1375977402,nop,nop,sack 1 {168801996:168815028}>
000001 IP 2.47500 > 1.46799: ack 168787516 win 16200 <nop,nop,timestamp 2077240629 1375977402,nop,nop,sack 1 {168801996:168817924}>
000203 IP 1.46799 > 2.47500: 168817924:168819372(1448) ack 1 win 46 <nop,nop,timestamp 1375977403 2077240629>
000028 IP 1.46799 > 2.47500: 168819372:168822268(2896) ack 1 win 46 <nop,nop,timestamp 1375977403 2077240629>
000025 IP 1.46799 > 2.47500: 168822268:168825164(2896) ack 1 win 46 <nop,nop,timestamp 1375977403 2077240629>
000024 IP 1.46799 > 2.47500: 168825164:168826612(1448) ack 1 win 46 <nop,nop,timestamp 1375977403 2077240629>

```

*UPDATE II:* so after a more exact analysis the posted regression looks like false alarm - so ignore this post.


