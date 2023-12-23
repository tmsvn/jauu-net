---
title: "'IETF: TCP Authentication Option'"
date: 2010-06-22T13:18:37+02:00
draft: false
---

Just now, two new Request for Comments are now online available:


* "RFC 5925":<http://www.rfc-editor.org/rfc/rfc5925.txt> - The TCP Authentication Option
* "RFC 5926":<http://www.rfc-editor.org/rfc/rfc5926.txt> - Cryptographic Algorithms for the TCP Authentication Option (TCP-AO)


These two standards (and probably upcomming enhancements in several years ;)
are the replacement for TCP MD5 Option (RFC 2385). TCP-AO specifies
stronger Message Authentication Codes to protect against replay attacks for
long lived connections like BGP sessions. It is a generic contaier where other
authentication codes can be used. Several other aspects are adjusted too like
an extended sequence number mechanism (imaginable as shadow registers) and IPv6 support.


Florian Westphal and I held a presentation where we mentioned TCP-AO at that time upcoming
standard: "Trends und Neuerungen bei der Protokollentwicklung":<http://jauu.net/data/pdf/protokollentwicklung.pdf>


The Internet is now a more safer place ... ;)


