---
title: "Link Equilibrium and Oversized Router Buffer"
date: 2011-01-20T15:46:21+02:00
draft: false
---

Jim Gettys wrote an blog entry where he describe problems with a oversized
router buffer - he called the problem bufferbloat.
Buffer in network equipment exist to catch temporary load peaks and allow
proper internal packet exchange from one linecard
to another linecard in coexist with the max. bandwidth.


In the case where buffers are overestimated the effect get worse during
periods of network congestion. Overestimated buffer will shift the problem
in time, or in other words: TCP will overestimate the available capacity
and normal congestion avoidance mechanisms do not timely take effect.
Overestimated buffers concrete shift the congestion avoidance mechanisms
in time - packets are dropped to late and the packet drop is not aligned
with the link capacity but rather with the buffer space. The problem with
the artificial delayed congestion avoidance is that the congestion
avoidance mechanism will overestimate the available bandwidth therefore.
User impact is a high latency and jitter. For a proper functioning the
mechanism must take promptly and should reflect the link capacity.


