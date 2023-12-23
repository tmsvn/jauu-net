---
title: "On the Generating of IP Fragments"
date: 2010-06-14T20:31:14+02:00
draft: false
---

If the IP packet size exceed the link layer maximum transmission unit (MTU,
1500 byte for Ethernet v2) a packet must be fragmented. Yesterday Changli Gao
submited a patch that optimize the reassembling process in the kernel. Changli
assumption was that fragments arrived in accureate ascending order. He
optimized the processing behavior by optimizing the list processing of
inet\_frag\_queue for IPv4 and IPv6 by introducing an additional pointer, called
fragments\_tail that points to the end of the list. So nothing sophisticated
here.


The main point against his patch was the following argument: Linux generates
since more then 10 years fragments in descending, in other words reverse order
- starting with fragment @n, n - 1, n - 2, ...@. So for Linux this is a noop.
But Linux isn't the only OS on the earth and as stated by Changli all other
major operating systems generate fragments in ascending order.


I don't want to write about the Path MTU discovery (PMTUD) mechanism, but to manually
probe for a path MTU it is quite comfortable to use ping or ping6, simple
specify a packet size and set the DF bit in the case of IPv4: @ping -c 1 -M do -s 1464 google.com@.
1506 bytes on wire, 14 byte Ethernet header, 20 byte IPv4 header, 8 byte ICMP
header, 1464 byte payload; this is a PPP limitation, Ethernet v2 can transport
1514 bytes on wire and if you do local PMTUD you can discover this limit.


