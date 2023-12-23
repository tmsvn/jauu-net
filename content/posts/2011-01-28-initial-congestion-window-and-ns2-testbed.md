---
title: "Initial Congestion Window and NS2 Testbed"
date: 2011-01-28T23:03:30+02:00
draft: false
tags: [ns2, gsoc, tcp]
---

The increase of the Initial Congestion Window (IW) throughout the land:
netdev ML ((Linux Network Development mailing list), TCPM (TCP Modification WG) ML,
ICCRP (Congestion Control Research Group WG) ML, TMRG (Traffic Modeling
Research Group) ML are a few, undoubtedly the most significant bodies
related to TCP all have one thing in common: they all discuss about the
(initial) Google proposal to increase IW to 10 or even 16.


I think my position is to this topic is more or less known, this time I want to
sum up arguments of other folks. At the end it is a long process to shift the
IW to whatever value seems adequate and a lot of research is required to
prove/back up the modified IW in the wild.


IW10/IW16 has only verified in the Google (especially Jerry Chu) and
[Ilpo Jarvinen](http://www.cs.helsinki.fi/u/ijjarvin/) testlab with SACK enabled
sender. There are no analysis how the behavior shifts if SACK is disabled or
not available, due to a receiver lack of SACK. But this is only one point of
critique. To back up (or revise) my assumption I started today to setup a ns-2
testbed to analyze other corner cases. Especially multihop networks (e.g.
MANET) with a bandwidth of a few kbits are of interest. The current simulation
provides a OLSR based multihop infrastructure. Now I will start digin into
patching the Initial Congestion Window of the network stack as well as think
about useful analysis scripts.


And because it is Friday: a Internet [LOL-Cat](http://en.wikipedia.org/wiki/Lolcat)
[Meme](http://en.wikipedia.org/wiki/Meme)


![images/cat.jpg](images/cat.jpg)
