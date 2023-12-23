---
title: "Netsend Improvements"
date: 2008-04-01T16:37:55+02:00
draft: false
tags: [linux, networking]
---

due a productive weekend we implement three additional protocols for netsend


* DCCP ( RFC 4340 )
* SCTP ( RFC 2960 )
* UDP-LITE ( RFC 3828 )


So nowadays there are seven supported protocols (if you consider ip and
transport layer protocols). TCP, IPv4, IPv6, TIPC and UDP.


Some minor bugs are fixed and code rearanged - the daily work ...


