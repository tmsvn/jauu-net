---
title: "TCP Window Scaling and SYN Cookies"
date: 2010-06-24T23:34:23+02:00
draft: false
---

During some off-line discussion with Florian - one of the main developers of
TCP SYN cookies - I was a little bit skeptic about the mechanism and the
interplay with the TCP window scaling option.


First I will describe these two mechanism; later on I will discuss their
relationship and interplay. At the end I will discuss the regression and
possible solutions. I shifted this off-line discussion to the kernel
ml because it is not that trivial as it sounds.



TCP Window Scaling
------------------


This TCP extension was introduced by RFC 1323 (TCP Extensions for High
Performance) and expands the 16 bit window to an effective 32 bit window.
This option specify a logarithmic scale factor which is applied to the received and
transmitted window. Receive and send window scale factor are established
separately in each direction. This factor is fixed at the three way
handshake (in the SYN and SYN/ACK packet ) and cannot be changed during
the TCP session. The scale factor and therefore the maximum receive window
is determined by the maximum receive buffer space. Linux for example
check the maximum possible receive memory in bytes and level the window
scale factor based on this value (sysctl\_rmem\_max and sysctl\_tcp\_rmem).


The actual window size is calculated each time a TCP packet is transmitted via
@tcp\_output.c:tcp\_select\_window()@ and advertise the amount of free space in
the receive buffer (under consideration of RFC1323 scaling is applied). The
algorithm never shrink the offered window - conforming to the RFC 793. This
buffer is sticked to exactly one socket. Expanding the window is more
complicated, RFC 1122 says:



```
the suggested [SWS] avoidance algorithm for the receiver is to keep RECV.NEXT +
RCV.WIN fixed until: RCV.BUFF - RCV.USER - RCV.WINDOW >= min(1/2 RCV.BUFF, MSS)

```

Means that the window is never raised on the right side until at least memory
is available to increase it at least MSS bytes. This RFC statement is a little
bit unlovely because it breaks the header prediction algorithm but this is
another topic. ;)


Last but not least the actual window calculation is not purely based on actual
available and advanced allocated memory, it is also based on window clamping.
Which is roughly 3/4 the size of the receive buffer minus the size of the
application buffer minus the maximum segment size. In the presence of dynamic
window sizing the window clamping is a little bit more complicated because the
memory control is more dynamic and so on ...




SYN Cookies
-----------


SYN cookies are one answer to reduce the "effective area" of an network stack
socket listening in the wild. Back in 1990 TCP SYN flood attacks where the new
black and form a not irrelevant problem for network serves. The attack is extreme simple: craft a
lot of SYN packets, sent it to a open listening socket - leave the socket in
the half-open state - and wait until the server resources are exhausted. The
problem is that the initial SYN packet signals the network stack to initiate a
connection which requires a lot of resources. This normally includes all
received TCP socket options, transmitted (in the SYN/ACK packet) socket options
and a lot of other bookkeeping stuff. Under Linux @struct tcp\_sock@ is nearly
2000 byte big! It is imaginable that 200k SYN packets can exhaust the whole
memory pool of the server (we are talking about kernel memory which is bound to
1GB at 32 bit architectures without EMT64 support) and no other legitimate
connection can established.


"D. J. Bernstein":<http://cr.yp.to/> come to the conclusion that holding the
initial state is the problem and his solution was to hold *no* state at the
server side until the third packet in the three way handshake is exchanged. The
idea was to encode the important data received in the initial SYN packet in the
TCP timestamp option in the second (SYN/ACK) packet. The peer is engaged to piggy back
this timestamp in the third packet (the ACK packet) where the server can
reconstruct the information. Assumption: the peer supports the TCP timestamp
option, but this is standard today and was more or less standard back in the
90's.


But encode all information in the timestamp option is not trivial because RFC
1323 requires that the clock increases, a dump replacement is not sufficient.
So the values are encoded in the following manner: top 5 bits encodes the timer
counter, followed by 3 bits which encodes the MSS of the client side and
finally a 24 bit server-selected secret function of the client IP address and
port number. This is required because it must be prevented that the client can
control the network stack by sending crafted timestamp options, therefore some
"cryptography" must be employed. It is obvious that in few bits not the whole
information can be encoded - this is a shortcoming of the mechanism.


This was the original idea of Dan. But ideas involve and nowadays the situation
is more well-thought-out: Linux per default uses mini sockets (@struct tcp\_request\_sock@;
~100 byte) to hold the minimal initial state after SYN
packet. This provides the whole feature set but requires only a few bytes. The
cookie mechanism - if enabled - is inactive if the network stack don't
experience any memory pressure. If the network stack suffers from memory the
cookie mechanism becomes active. Some final word: Linux nowadays encodes
additional values in the SYN cookie: window scaling, selective acknowledgements
and so on.


BTW: if you are not trained you will not even realize that SYN cookies are active:



```
13:51:04.582464 IP 127.0.0.1.57985 > 127.0.0.1.4050: S 1061746051:1061746051(0) win 32792 <mss 16396,sackOK,timestamp 0xfffea013 0,nop,wscale 6>
13:51:04.582478 IP 127.0.0.1.4050 > 127.0.0.1.57985: S 2800702917:2800702917(0) ack 1061746052 win 32768 <mss 16396,sackOK,timestamp 0xfffe9f66 0xfffea013,nop,wscale 6>
13:51:04.582480 IP 127.0.0.1.57985 > 127.0.0.1.4050: . ack 1 win 513 <nop,nop,timestamp 0xfffea013 0xfffe9466>

13:59:19.047306 IP 127.0.0.1.45979 > 127.0.0.1.4050: S 218483035:218483035(0) win 32792 <mss 16396,sackOK,timestamp 0x0001bed4 0,nop,wscale 6>
13:59:19.047320 IP 127.0.0.1.4050 > 127.0.0.1.45979: S 1141094138:1141094138(0) ack 218483036 win 32768 <mss 16396,sackOK,timestamp 0x0001bd66 0x0001bed4,nop,wscale 6>
13:59:19.047322 IP 127.0.0.1.45979 > 127.0.0.1.4050: . ack 1 win 513 <nop,nop,timestamp 0x0001bed4 0x0001bd66>

```

Do you realize the "conspicuousness" in the lower nine bits of the timestamp in
thesecond SYN/ACK packet? ;-)




Network Stack Regression
------------------------


The detected regression in the current network stack arise from the
circumstance that that their is a race between the SYN/ACK where we initial
force a particular window scale and the next time where we recalculate the
window via tcp\_select\_initial\_window().


If the user change net.core.rmem\_max or net.ipv4.tcp\_rmem in between this
time, the recalculated window scale (rcv\_wscale) can be smaller. But the
receiver still operates with the initial window scale and can overshot the
granted window - and bang.


There are several solutions:


* encode rcv\_wscale into the SYN cookie and don't recalculate the scaling factor via tcp\_select\_initial\_window() or
* disable window scaling and don't transmit any scaling option when SYN cookies are active. The later option is not that defective as it sounds. Even if the server suffers from memory the window scaling becomes insignificant.



