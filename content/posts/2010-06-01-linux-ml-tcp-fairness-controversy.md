---
title: "Linux ML TCP Fairness Controversy"
date: 2010-06-01T23:12:19+02:00
draft: false
tags: [networking, tcp]
---

TCP fairness discussions are quite frequent for the Linux network
maillingslist (netdev). This time Tom Herbert from google posted a patch where the
TCP Congestion Window (CWND) can be modified through setsockopt(3). It is not easy to
explain the impact of this change because it requires a lot of background
information about how TCP works. To shorten the story: this option can - if
employed to aggressive - lead to serious performance problems of the Internet.
Network components these days are forced to behave good natured. If network
components ignore the feedback or information from the network the Internet can
collapse. This knowledge is not new at all - in contrast - the Internet was
collapsed in the 80s because no congestion control mechanism was integrated.
Since this time the cooperative behavior is a basic requirement for the
functioning of the Internet.


Over time people tend to neglect the obvious and current network stack
implementation soften the requirements. Some months ago another discussion
about the plugable congestion control algorithms where similar. Some congestion
control algorithms are unfair by default (e.g. BIC in environment with small
RTT). I posted a patch to restrict the unfair behavior to root and provide only
superuser the capabilities and freedom to do what he want. This patch effective
disabled any changes by any other user. Stephen Hemminger negate and pushed
another patch. Now the situation is that user who can compile and replace the
kernel can enforce a strict or less-strict behavior. Less strict means that
every user can select a congestion controll algorithm via setsockopt() his own
congestion control algorithm, strict means that the user is forced to use the
default congestion control algorithm (e.g. NewReno, Westwood). By the way:
congestion control algorithms aren't the only place where unfair protocol
behavior is possible.


But back to the current debate: Tom Herbert patch where declined and some
fundamental Internet philosophies where discussed. The most impressive post for
me was from Denys Fedorysychenko:


In Lebanon i have around 30k users behind few IP addresses(around 6, for web).
Because backbone here $1200/Mbit, and satellites mostly(rtt 400+ ms)... so TCP
accelerators and caching proxy a must. Tproxy doesn't work well yet to use full
set of ip's.


The whole debate can is archived here: "comments.gmane.org":<http://comments.gmane.org/gmane.linux.network/162103>


