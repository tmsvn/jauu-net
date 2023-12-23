---
title: "When the CRC and TCP Checksum Disagree"
date: 2010-07-11T21:14:04+02:00
draft: false
tags: [networking, tcp]
---

This post recycles the title of a famous paper from
"Craig Partridge and Jonathan Stone":<http://www.cc.gatech.edu/classes/AY2002/cs8803d_spring/papers/checksum.pdf>
from 2000. Traces shows that between 1 packet in 1100 and 1 packet in
32000 fails the TCP checksum - even thought a link layer CRC was used. The
TCP/UDP checksum is also ineffective at detecting bus specific errors since
these errors with simple summations tend to be self canceling. The paper is
worth to read it: it talk about the sources of errors, how TCP react and how to
reduce the error rate.


But what about the Ehternet CRC? The weakness of the CRC becomes acute in
network environments with a MTU larger then 1500 bytes - data center, research
networks, cluster systems and so on. Until 1500 byte the CRC is strong.
Currently a MTU of 9k is possible without special NICs - almost all current
gigabit network adapters support jumbo frames. Some older gigabit NICs from
Realtek failed because the CRC routine failed. Intel's e1000/e1000e adapter can
even transmit and receive frames up to 16128 bytes.


Corruption could occur at the source in software, in the network interface
card, out on the link, on intermediate routers or at the destination network
interface card or node. Maybe I forgot some sources. The actual assumption is
that one packet in 10 billion will have an error that goes undetected for
Ethernet MTU frames.


Ethernet uses a 32 bit CRC that loses its effectiveness above about 11455 bytes
- after this limit the CRC-32 the probability of undetected errors per frame
increase. A white paper with the title "Extended Frame Sized for Next
Generation Ethernets":<http://staff.psc.edu/mathis/MTU/AlteonExtendedFrames_W0601.pdf>
discuss further issues why a frame size should not exceed
9000 byte.


Beside the standard Ethernet CRC the Castagnoli CRC (CRCNc) is worth to mention
it. Standard Ethernet CRC was selected because of his performance. CRC32c - the
Castagnoli counterpart to CRC32 used by iSCSI or SCTP -


CRC-32-IEEE 802.3 Polynom:


*x^32^ + x^26^ + x^23^ + x^22^ + x^16^ + x^12^ + x^11^ + x^10^ + x^8^ + x^7^ + x^5^ + x^4^ + x^2^ + x + 1*


Castagnoli CRC 32C Polynom:


*x^32^ + x^28^ + x^27^ + x^26^ + x^25^ + x^23^ + x^22^ + x^20^ + x^19^ + x^18^ + x^14^ + x^13^ + x^11^ + x^10^ + x^9^ + x^8^ + x^6^ + 1*


"crctool":<http://www.easics.com/webtools/crctool> is a online tool is available
which generates VHDL code for a wide number of CRC algorithms.
"Support for Stronger Error Detection Codes in TCP for Jumbo Frames":<https://tools.ietf.org/html/draft-anumita-tcpm-stronger-checksum-00>
provides some text about this topic.


!http://blog.jauu.net/2010/07/11/When-the-CRC-and-TCP-Checksum-Disagree/love.jpg!


Last but not least Intel core i7 processors have the CRC32c function contained
within their new SSE4 math coprocessor.


