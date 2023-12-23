---
title: "Urgent Pointer Standard and Real World Implementation"
date: 2010-06-12T22:12:33+02:00
draft: false
---

Stumbling over the Urgent Pointer code in @tcp\_recvmsg()@ and reading some
specs. Urgent data allows the sender to signal the receiver that "urgent
data" of some form has been placed into the packet. The receiver on the other
hand must deal with this condition and is forced by himself to handle this
condition. If not handled the data is silently ignored. Therefore, it must be
negotiated at a higher level that urgent data is transmitted and properly
handled at the receiver side.


The urgent bit in the TCP header is set and the Urgent pointer is set to the
relevant data. The urgent pointer is a 16 bit value. I wrote "pointer is set to
the relevant data", and here comes the fun into the game! First: the urgent
field is an offset that points to the last byte of urgent data. It is up to the
receiving application where the urgent data starts. A real world problem is the
terminus "points to the last byte of urgent data". RFC 1011: "The urgent
pointer points to the last octet of urgent data (not to the first octet of
non-urgent data)". At data before can be threated as urgent - but this is
application level specific.


The problem is the following: the definition of the Urgent Pointer was declared
in the RFC 793 - the original TCP standard. Due to some contradictions RFC 1122
updates and correct the behavior (problem was where the urgent pointer points
to, the last byte of the urgent data or the byte after the last urgent data).
But: all TCP implementations in the wild implement the behavior as specific in
RFC 793. The "advice":<http://tools.ietf.org/html/draft-ietf-tcpm-urgent-data-05>
by Gont and Yourtchenko is that new applications employing TCP should not use
the urgent mechanism at all.


