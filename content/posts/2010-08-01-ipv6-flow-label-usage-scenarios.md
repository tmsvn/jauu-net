---
title: "IPv6 Flow Label Usage Scenarios"
date: 2010-08-01T23:00:45+02:00
draft: false
tags: [ipv6]
---

The 20 bit wide Flow Label field in the IPv6 header is a integral part of
the protocol specification, standardized in "RFC 2460":<http://tools.ietf.org/html/rfc2460>
The field may be used to mark sequences of packets for which the sender
request special handling at intermediate routers. The standard explicitly does
not define the *what*, it exemplary provides two examples (real-time and
non-default quality of service routing) and that's all. At the specification
time nobody was in the ability to specify how this field may be used in the
future or may not used for. As so often the time should breed possible use
cases. Good designs are often - not always - characterized by a unseen
potential which is discovered later on. One famous example is the C++ template
system - the powerful scope was identified after the language was already released:
"Modern C++ Design: Generic Programming and Design Patterns Applied":<http://www.amazon.com/exec/obidos/ASIN/0201704315/modecdesi-20>


Time goes by and the use cases are still rare for Flow Label. This may be
founded in the low diffusion of IPv6 at the time of writing or because larger
carriers already use Multiprotocol Label Switching (MPLS) beside the common 5-tuple
used to classify a packet flow (later on is a rare exception in the core). The
5-tupel has it own problems such as fragmentation or next header parsing due to
the fact that the port information is at the transport layer. Anyway, use case
questions accumulate over time and an I-D address some possible use cases of
this 3-tuple {source address, destination address, flow label}:
"Survey of proposed use cases for the IPv6 flow label":<http://tools.ietf.org/html/draft-hu-flow-label-cases-00>
The I-D is worth reading!


