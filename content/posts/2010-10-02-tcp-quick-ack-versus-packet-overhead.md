---
title: "TCP Quick ACK versus Packet Overhead"
date: 2010-10-02T20:59:46+02:00
draft: false
tags: [ietf, tcp]
---

Since several weeks I deal with TCP Quick ACK mechanism. TCP Quick ACK where
introduced to bypass the disadvantages of delayed ACKs. If a flow is not
interactive and send fully Maximum Segment Sized (MSS) packets from one
endpoint to the other there is no real need to artificially delay any packets.
In this situation the receiving host will never send any data and the TCP
instance can instantly trigger an ACK packet. This allows the other hand to
even increase the congestion window (CWND) faster compared to TCP instances
where the ACK is always delayed.


But there are some challenges with this mechanism. First, the TCP instance does
not instantly know if a local TCP application will piggy back some data or not.
The TCP does not know if a application behaves interactive like HTTP or like a
FTP bulk application. The TCP stack must first analyze the connection pattern.
Quick ACK can be employed in two ways:


* a new vanilla connection can start with QUICK ACK enabled and deactivate the mechanism if interactive characteristic is detected
* a new vanilla connection is started with Quick ACK disabled and if the connection is not interactive the QUICK ACK is enabled.


Currently under Linux the former mechanism is employed: TCP Quick ACK is enabled per default and only if the heuristic detects that the connection is interactive (e.g. HTTP) the QUICK ACK is disabled!


The drawback is not negligible: the first ACK packet is \_always\_ generated and transmitted, although the server may have instantly some data. The prominent example is HTTP! Here the client ask for a file (via HTTP GET) and the server will hand-out the required file. But because of QUICK ACK the TCP instance will generate an ACK first and shortly afterwards will generate a additional DATA packet.


The additional ACK is solely generated the first time till the heuristic detects DATA from the server to the client. But especially short-lived-flows like HTTP will suffer from this. The typical HTTP flow includes only 10 till 20 data packets. One additional ACK packet is not to underrated!


The last two packets in the image illustrates this characteristic.


!http://blog.jauu.net/2010/10/02/TCP-Quick-ACK-versus-Packet-Overhead/tcp-rto-1-thumb.png!:<http://blog.jauu.net/2010/10/02/TCP-Quick-ACK-versus-Packet-Overhead/tcp-rto-1.png>


