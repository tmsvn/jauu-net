---
title: "recv return constraints"
date: 2008-05-04T17:35:37+02:00
draft: false
---

If you call recv() to fetch data, the syscall will block if nothing happens.
But what are the constraints for tcp\_recvmsg() to return? This posting focus on
the major factors (other aspects like OOB data, signals, non-blocking IO is
ignored in this posting):


* Timeout
* Amount of data


tcp\_recvmsg() first calculate the timeout for this function via
sock\_rcvtimeo(). This refers to return noblock ? 0 : sk->sk\_rcvtimeo - in the
common therefore sk->sk\_rcvtimeo. This is initialized as MAX\_SCHEDULE\_TIMEOUT
(LONG\_MAX).


On the other hand sock\_rcvlowat() calculate the minimum amount of data. If the
user specify MSG\_WAITALL then the minimum is the length argument. In all other
cases sock\_rcvlowat() uses sk\_rcvlowat. That values is standard 1, but can be
changes via setsockopts(SO\_RCVLOWAT). After all the minimum amount refers to 1
byte!


tcp\_recvmsg() will now peek the skbuffs until the amount the data is >= 1. If
there is no data available (no one send something) the process sleep until some
data is send. Naturally the code doesn't read explicit 1 byte. skb\_peek() is
greedy! Normally you recvmsg() will return with all data which is instantly
available.


After all: tcp\_recvmsg() will block forever until one byte of data is
available!


