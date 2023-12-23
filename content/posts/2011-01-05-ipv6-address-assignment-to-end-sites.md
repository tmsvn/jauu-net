---
title: "IPv6 Address Assignment to End Sites"
date: 2011-01-05T23:13:38+02:00
draft: false
---

IAB/IESG Recommendations on IPv6 Address Allocations to Sites ("RFC 3177":<http://tools.ietf.org/html/rfc3177>)
provides recommendations that for end sites a @/48@ block should be provided in normal case. A @/64@ block when it is
absolutely sure that only one subnet is needed and @/128@ for the case that
only one device is connected. The requirements for IPv6 in 1993 included
the plan that the next IP version should address approximately 2^40^
networks and 2^50^ hosts. Therefore the currently IPv6 address can be
loosely splitted in a 64 bit network number (including subneting) and
64 bit host number (including flat EUI-64 host part and randomly self
autoconfigured host number) -> 2^40^ & 2^50^ goal accomplished.


@/48@ provides end sites the ability to subnet 2^16^ subnet numbers for
internal routing infrastructure each with theoretical max. 2^64^ unique
hosts. Most enterprises should be happy with this. Very large enterprises
should be provided with a @/47@ or with multiple@/48@. "RFC 3177":<http://tools.ietf.org/html/rfc3177> constitute a more or less hard
default setting and Regional Internet Registries (RIRs) should bear on
that. The idea of the IAB/IESG recommendation was that a hard structure
will reduce among other things maintainership (e.g. address restructuring, see paragraph
3 for more information).


"IPv6 Address Assignment to End Sites":<http://tools.ietf.org/html/draft-ietf-v6ops-3177bis-end-sites-01>
started now to obsolete "RFC 3177":<http://tools.ietf.org/html/rfc3177>.
Thomas Narten et. al. stated that the RIRs originally started with @/48@
but began to switch to other policies in 2005. Namely APNIC, APNIC and
RIPE encourage the assignment of smaller (e.g. @/56@) blocks to end sites.
One concern is that the hard suggestion can lead to a classfull routing
where CIDR continues to apply to all bits of the routing prefixes. Another
aspect is that RIRs may have other policies which fit better in their model.


