---
title: "Increasing TCPs Initial Congestion Window"
date: 2010-07-15T22:34:48+02:00
draft: false
---

Noting really special today, ... except that it is time for another debate about
the increase of the initial CWND from currently max. 4 to N. Where N differs
from month to month and vendor to vendor. Currently standard TCP is not
seasoned to meet the new network environments. There are still networks
with a BDP from 1980 - MANET, Sensor Networks and so on are typical examples.
Google press ahead the thematic mainly because a increased initial CWND
instantly enhance the user experience for a typical web session. Web sessions
are a prominent example where the slow start algorithms start to increase the
CWND while after ~3 iterations the slow start is interrupted because
every byte is transmitted. So our HTTP biased world suffers from the initial
CWND - no doubt. Google congestion control and CWND analysis on the other hand
does not address topics beyond the scope of HTTP.


There is a lot of additional research required to adjust these TCP intrinsic
values and tcpm already began to address this topic.


The discussion at lkml is a little bit more specific but it is also quite late
(01:34:00 AM) in the night so I interrupted the lkml discussion as well as this
blog post ... ;-)


