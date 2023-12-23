---
title: "IPSec and Quagga Automating"
date: 2010-06-14T15:13:30+02:00
draft: false
---

A tiny drawback of quagga is a missing feature to signal the host environment when
routes change. So it is not simple to start/stop scripts if routes are added or
deleted. For example: if you want to add or delete a security association if a
route changes then it is not directly possible via quagga. But Linux and other
operating systems provides a monitor mode where all relevant network events can
be caught by the user space. Linux uses netlink sockets for network related
communication between user-space and kernel-space. ip, the command, can be
forced to print all network related messages to STDOUT via @ip monitor all@
(under BSD @route -n monitor@ will do the same).


