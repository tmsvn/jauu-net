---
title: "TCP Fairness"
date: 2011-08-01T22:01:22+02:00
draft: false
---

Last time as I posted about TCP fairness aspects of TCP I don’t touched
the topic in great detail. But TCP fairness and protocol fairness in general is
a important requirement in the whole IP communication zoo. In this blog
posting I will write some sentences about the fairness aspects of a network
layer protocol and particular TCP.



UDP and Datagram based Protocols
--------------------------------


To start with UDP - as a unreliable, unordered lightweight datagram based
service - provides no fairness mechanisms at all. If the ratio UDP versus TCP would
shifts to UDP the whole Internet structure would break at a certain point. This
is a factum. The Internet protocol suite is designed in a manner that a correct operational
requires well behaved middle boxes, end systems the protocol interplay. UDP
does not fulfil this requirement because UDP provides no mechanism to react of
network condition. Even worse, UDP provides no mechanism to even receive
any network feedback. Actual[1] analysis shows that the ratio UDP to TCP lies
somewhere between 5% and 20%.


Current application often seems to prefer UDP over TCP. This includes media
streaming applications like VoIP or Video applications, all kind of tunnel
applications (IPSec, OpenVPN, GRE, IPv6 and so on) and gaming application
(gaming application employ often TCP because of NAT problems, but this is
another topic). But we known that UDP cannot displace TCP from his prominent
position. The IETF started several years ago a initiative to develop a protocol
that can fill the gap. It is called Datagram Congestion Control Protocol (DCCP) and
can be described as a bidirectional, congestion-controlled, unreliable unicast
connection protocol. The main protocol is described in [RFC 4340](http://www.read.cs.ucla.edu/dccp/rfc4340.txt)
some protocol extension are described in [RFC 4341](http://www.read.cs.ucla.edu/dccp/rfc4341.txt)
and [RFC 4342](http://www.read.cs.ucla.edu/dccp/rfc4342.txt) .


Some years ago I wrote an article for a German magazine about DCCP. This article is
now freely available: [IX DCCP Article](http://www.heise.de/netze/artikel/Ausweichmanoever-221605.html)


![images/dumb-bell.png](images/dumb-bell.png)
At the time of writing the usage of DCCP is quite low. I know some application which are
prepared but the employment suffers from the chicken-egg problem. Furthermore,
decision makers act with caution because some middle-box (black-box)
problems are to be expected. The employment of IPv6 will relax this problem a
little bit. I will re-read this article in some years and update it. ;)




Congestion Collapse and Van Jacobson
------------------------------------


The previously mentioned congestion collapse is not a theoretical consideration. No, back
in 1988 TCP also did not include any congestion control mechanism! In April a
massive collapse was noticeable – caused by the lack of functionality. Van
Jacobson




TCP and Streaming Protocols
---------------------------


But let us come back and discuss the actual topic: TCP fairness.


TCP analyse the current network congestion status: it treats lost segments
as an indicator of congestion, it can treat packet receive variations as
an congestion indicator. Beside these passive recognition techniques TCP
employs several active mechanisms to prevent the congestion collapse.
Mechanism include the famous slow start to probe the available bandwidth,
congestion avoidance to converge carefully to the bandwidth if TCP detects
that the pipe is nearly at the capacity limit.


[1] <http://www.cs.auckland.ac.nz/~brian/udptcp-ratio-TechReport.pdf>



