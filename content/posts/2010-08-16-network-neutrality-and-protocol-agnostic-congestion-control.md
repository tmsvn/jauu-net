---
title: "Network Neutrality and Protocol Agnostic Congestion Control"
date: 2010-08-16T23:00:38+02:00
draft: false
---

Two apparently not related terms, but wait. Network neutrality can be
described as a principle that no restriction by internet service providers
and governments on content is applied. Restrictions can be limited network
resources: Google News experience a higher Quality of Service as my Blog
or even worse: you cannot connect to YouTube with your standard ISP
contract. In other words: ISP's start to consider network traffic based on
their content. This is not really new, ISP's for example restrict the
usage of peer-to-peer protocols by injecting TCP RST packets to throttle
the connection. GSM/UMTS operators on the other hand often prohibit any
VoIP application.


The rational behind can be split into two big aspects: a) economic, ISP's
want to participate, they stopped to recognize themself as a pure ISP.
ISP's start to realize that the content is the key to economic success.
Think about Youtube and all the shiny upcoming services. And b) resource
hungry applications like peer-to-peer congest the network and requires
even higher and higher link capacities. Restrict the usage can contribute
to reduce their equipment cost greatly.


But where is the interaction between Network Neutrality and Protocol
Agnostic Congestion Control? Well, Comcast, one of the biggest ISP in the
U.S. enrolled this new congestion control - a large scale congestion
management system - in response to dissatisfaction of customers "as well
as complaints to the U.S. Federal Communications Commission (FCC)
regarding Comcast's old system, which targeted specific peer-to-peer (P2P)
applications". Comcast customers share their up- and downstream bandwidth
with their neighbors. If a individual using most of the bandwidth at times
where the network experience congestion then this individual is penalized.
A high level overview how the mechanism works is outlined in [1] (section
7, "Implementation and Configuration" provides an detailed description):


* Software installed in the Comcast network continuously examines aggregate traffic usage data for individual segments of Comcast's HSI network. If overall upstream or downstream usage on a particular segment of Comcast's HSI network reaches a pre- determined level, the software moves on to step two.
* At step two, the software examines bandwidth usage data for subscribers in the affected network segment to determine which subscribers are using a disproportionate share of the bandwidth. If the software determines that a particular subscriber or subscribers have been the source of high volumes of network traffic during a recent period of minutes, traffic originating from that subscriber or those subscribers temporarily will be assigned a lower priority status.
* During the time that a subscriber's traffic is assigned the lower priority status, their packets will not be delayed or dropped so long as the network segment is not actually congested. If, however, the network segment becomes congested, their packets could be intermittently delayed or dropped.
* The subscriber's traffic returns to normal priority status once his or her bandwidth usage drops below a set threshold over a particular time interval.


At the end: for challenge b) there are technical solutions to counteract
the problem. There is no excuse why an ISP harm network neutrality because
of network bandwidth problems. But we are living in a commercialized world
and ISP realize that a lot of money can be earned with content, so a) will
be the driver to violate network neutrality.


[1] "<http://tools.ietf.org/html/draft-livingood-woundy-congestion-mgmt-07>":<http://tools.ietf.org/html/draft-livingood-woundy-congestion-mgmt-07>


