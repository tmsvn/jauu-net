---
title: "IETF TCPM Historicize"
date: 2010-06-09T19:52:38+02:00
draft: false
tags: [ietf, tcp]
---

Lars Eggert posted today a Draft where RFC1106, RFC1110, RFC1145, RFC1146,
RFC1263, RFC1379, RFC1644 and RFC1693 are declared as historic documents. But RFC1146 -
TCP Alternate Checksum Options - was not superseded by a new standard nor is he
defective by any sense. These both arguments are normally the statement why a
RFC is declared as historic. In my eyes this is not true for this standard. In
the debate Lars argued that the already assigned code points do remain assigned.
This guarantee that implementations - not seen in the wild for RFC1146 - are not
touched or affected.


I mentioned that TCP can have a legal desire towards a more strong checksum and
as an example I mentioned interplanetary TCP. Lloyd Wood pointed out that TCP
isn't suitable for Interplanetary communication. The fact is known sure, but
I know several modifications of TCP where the RTO mechanism is adjusted just
because to meet interplanetary requirements!


Anantha Ramaiah pointed out a "Draft":<http://datatracker.ietf.org/doc/draft-anumita-tcpm-stronger-checksum/>
that address exactly the same shortcomings: enhancing TCP checksums mechanism.
Lars noticed that it Transport Layer Security (TLS/SSL) can be used to
guarantee the integrity of the data even more stronger then as with a plain
CRC.


The discussion with Lloyd slided away from the actual topic to some general
discussion about TCP and the interplay with RTO. His research background focus
on interplanetary communication and it is quite interesting to know about some real
world problems.


