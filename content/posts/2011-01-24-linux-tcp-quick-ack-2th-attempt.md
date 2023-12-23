---
title: "Linux TCP Quick ACK 2th Attempt"
date: 2011-01-24T17:49:11+02:00
draft: false
tags: [tcp, ietf, linux]
---

Back in August I submitted a
"patch":<http://kerneltrap.org/mailarchive/linux-netdev/2010/8/23/6283640>
to enable/disable the TCP Quick ACK behavior. Linux default Quick ACK
behavior is in many cases counterproductive and increase the packet count.
Especially short-lived interactive protocols like HTTP will suffer of TCP
Quick ACK. For example a interactive HTTP flow of 16 data packets will
send one additional but unnecessary Quick ACK packet - 1/16. Accumulated
this is not to underestimated! Not sure why big HTTPD users like facebook or
$BIGCOMPANY do not tune their stack - do they not question their @tcpdump@
traces?


At that time where I submitted the patch Davem rejected the @sysctl@ based
approach with the suggestion to use a per-route approach to reduce sysctl
pollution. The big disadvantage is that it is now a little bit tricky to
enable/disable Quick ACK's, because each route must be addressed separately --
I am not happy with the idea to ban nearly all new @sysctl@ extensions.
Anyway, I modified the patch, I will tests the patch a couple of days and
afterwards it should goes into net-next, hopefully.


