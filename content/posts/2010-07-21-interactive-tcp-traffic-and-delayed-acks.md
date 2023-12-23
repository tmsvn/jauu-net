---
title: "Interactive TCP Traffic and Delayed ACKs"
date: 2010-07-21T16:26:45+02:00
draft: false
---

Interactive TCP traffic - like telnet - is often single byte character
interactions: a pressed key, encoded via a char data type, is
transmitted to the server, processed at the server side and echoed back
to the client. These days telnet can be considered as antiquated because
of security shortcomings and the Secure SHell step into telnets shoes.
The one byte transmission is expanded to a ~32 byte chunk because of
cryptography overhead. Anyway, the fundamental communication characteristics
remains identical. Within short time-slots each pressed character is
transmitted to the server, the server process the input and echo's back
the character. The interactive characteristic is unchanged.


The following sections provides a rudimentary analysis of the timing
behavior of a characteristic ssh session - larger breaks are not included.
The analysis rather focus on "microscopic" timing interaction and the TCP
delayed ACK mechanism.


Firstly some words about the delayed ACK timer. This timer is started at
receiver side with each incoming data packet and was introduced to avoid
the silly window syndrome. The suggested timeout is 500ms where no
specific time is standardized. The majority of network stacks use 200ms as
a compromise of additional delay and efficiency.


The next image illustrates the interplay between the echoed data and delayed ACK mechanism


![images/seq.png](images/seq.png)

```
00:00:00.045855 IP h1.47028 > h2.22:    Flags [P.], seq 684:720, ack 925, win 304, length 36
00:00:00.017156 IP h2.22    > h1.47028: Flags [P.], seq 925:961, ack 720, win 91, length 36
00:00:00.000048 IP h1.47028 > h2.22:    Flags [.],  ack 961, win 304, length 0
00:00:00.783306 IP h1.47028 > h2.22:    Flags [P.], seq 720:756, ack 961, win 304, length 36
00:00:00.017316 IP h2.22    > h1.47028: Flags [P.], seq 961:997, ack 756, win 91, length 36
00:00:00.000054 IP h1.47028 > h2.22:    Flags [.],  ack 997, win 304, length 0
00:00:00.178118 IP h1.47028 > h2.22:    Flags [P.], seq 756:792, ack 997, win 304, length 36
00:00:00.017426 IP h2.22    > h1.47028: Flags [P.], seq 997:1033, ack 792, win 91, length 36
00:00:00.000051 IP h1.47028 > h2.22:    Flags [.],  ack 1033, win 304, length 0
00:00:00.182521 IP h1.47028 > h2.22:    Flags [P.], seq 792:828, ack 1033, win 304, length 36
00:00:00.017470 IP h2.22    > h1.47028: Flags [P.], seq 1033:1069, ack 828, win 91, length 36
00:00:00.000044 IP h1.47028 > h2.22:    Flags [.],  ack 1069, win 304, length 0
00:00:00.170489 IP h1.47028 > h2.22:    Flags [P.], seq 828:864, ack 1069, win 304, length 36
00:00:00.017774 IP h2.22    > h1.47028: Flags [P.], seq 1069:1105, ack 864, win 91, length 36
00:00:00.000055 IP h1.47028 > h2.22:    Flags [.],  ack 1105, win 304, length 0

```

The maximum limit for the delayed ACK is still 200 ms, the minimum can be
smaller - depending on the current analysis of the TCP stream. Therefore
the TCP analysis the packet inter-arrival time and doubles this value. Note
that every other data packet is always immediately acked. The Linux Delayed
ACK is implemented in @tcp\_delack\_timer():net/ipv4/tcp\_timer.c@.


Drawbacks of the delayed ACK are a reduction of the transmission rate of
the sender.This is because the sender increases the congestion windows -
CWND - based on the rate of incoming ACK packets. TCP is still an ACK
clocked protocol. To increase the CWND even faster an instant ACK is
superior and actual Linux implement an algorithm, called Quick ACK, to ACK
packets in the start phase of TCP instantly, without any artificial delay.
To prevent the Silly Window Syndrom the transmitted quick ACK's from the
receiver is limited to n segments. Where n is defined as the half of the
number of segments to reach the receivers advertised window. Additionally,
if the network stack detects that the communication is bidirectional is
completely disabled. This is an optimization because the receiver knows
that he also transmit data and therefore should wait for local data. This
reduces the number of vanilla ACK packets.


If delayed ACK's are disabled the behavior is similar to this illustration. An
ACK segment is instantly generated and the echoed packet is transmitted
separately, as identifiable this generate a lot more traffic:


![images/seq-ack-delay.png](images/seq-ack-delay.png)
