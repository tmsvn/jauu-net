---
title: "Cisco ASA and DNS Security"
date: 2011-11-14T22:56:25+02:00
draft: false
tags: [dns, networking]
---

I started to inform how Cisco ASA, Cisco PIX and Cisco FWSM firewall appliance
secure their domain from DNS traffic. What is possible, what can I transport
over DNS without increased drop probability. I question myself what DNS flags
can be touched without any flaw.


I must admit that I'm no Cisco expert - not at all. If I look at the
[configuration possibilities](http://www.cisco.com/web/about/security/intelligence/dns-bcp.html) I have to say "wow":



```
class-map inspection_default
     match default-inspection-traffic
policy-map type inspect dns preset_dns_map
     parameters
dns-guard
id-randomization
message-length maximum 512
id-mismatch count 10 duration 2 action log
        exit
match header-flag RD
        drop
policy-map global_policy
      class inspection_default
              inspect dns preset_dns_map
service-policy global_policy global

```

What administrator knows DNS at this level? I mean that are no default values
(I think so), that are the recommendation of the official Cisco webpage. Let me
pick the message-length option: this means that no DNS request/reply larger
as 512 byte can be received! Today in a world of EDNS0, DNSSEC and several
AAAA answers in one packet this limit can trigger erroneous function.
Especially because the "configuration error" will show up rarely.


