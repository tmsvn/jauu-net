---
title: "Its Fairness Stupid"
date: 2011-08-09T16:51:40+02:00
draft: false
tags: [ietf, tcp]
---

Some thoughts about recent activity here at TCPM and some other places.


Since several years vendors and web companies try to address web performance
problems by adjusting TCP. Congestion control, slow start (IW10), timeouts and
the like are addressed like a function of time: IW10 seems adequate for 2011,
IW15 for 2013, IW20 for 2016 and so on. Timeouts are adjusted to current
“consumer” networks. But the actual network characteristic is hardly a function
of date, it is a function of the effective link characteristic between two
endpoints in a packet switched networks with no a priori bandwidth guarantee.
X.25, multi-hop sensor networks and low bandwidth radio links are *still employed*.
Links with just a BDP of a few thousands byte per second, links cope
a few packets in flight and with a large intrinsic jitter.


IW10, IW14, IWx are proposed to speed things up. Don't get me wrong: I am
generally ok with IW10 - I believe that the (potential) negative impact is
manageable, overshooting the link is unlikely. I believe that this window is in
a lower range of noise so that a flow - and all other flows - reach a stable
equilibrium. But I am concerned about larger IW values. Last but not least: I
cherish the work of Jerry, Joe, Michael, Mark, Ilpo, Matt, Nandita at al.


The argument that modern web browsers - or FTP client’s - actually open several
parallel connections to speed up the process is no valid argument. It \_make\_
things worse, because it de-facto disable congestion control. I.e. in extreme
to transfer 1Gbyte, a client *can* spawn 10000 TCP connections in parallel, but
with each connection you make the global congestion control mechanism less
effective. To forecast something: I don't believe that Chrome and Co disable
the "parallel connection attempt" if IW10 is approved and becomes a standard
track. In the end we will see several parallel connection attempts AND IW10.
Simultaneously open n connections and shortly after the three way handshake
receive n\*10 packets in one flush. Because clients can spawn several connection
in parallel does not mean that they should or is fair regarding Jain's fairness
index.


Larger vendors should not try to modify TCP in their horizon - TCP is for
everyone. To gain milliseconds on "their" side probably mean loss of several
seconds on the "other" side. Modify TCP is a short term solution. The long
term solution is somewhere else. HTTP for example could cache more information:
nearly 95% of all web-pages on my daily basis are identical: images, logos,
web-page text fragments, java script files and so on are identical. I download
them over and over again. But it is easier for vendors to tune TCP. But tuning
TCP will not scale infinitely, you have a limited bandwidth and with a packet
switch network you have the probe the available bandwidth – that’s a fact.


This is a plea to keep the spirit of a conservative TCP in the standardization
body.


Justitia, a little bit uncommon without a pair of balances. Somewhere in Brazil:


![images/justitia.jpg](images/justitia.jpg)
