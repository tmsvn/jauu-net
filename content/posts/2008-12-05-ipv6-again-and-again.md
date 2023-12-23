---
title: "IPv6 Again and Again"
date: 2008-12-05T12:19:54+02:00
draft: false
---

Because I see it again and again (to highlight it: I mean in NEW software):


* you MUST use sockaddr, sockaddr\_in and sockaddr\_in6 since the beginning.Don't use uint32\_t or even worse unsigned long for IPv4 storage. But as you realize this is not protocol independent: sockaddr\_in and sockaddr\_in6 are container for IPv4(IP Version 4) and IPv6(IP Version 6). You will end up in switch/case statements to distinguish between both protocols. The superior solution is to use struct sockaddr\_storage (big enough to also handle UNIX sockets). Currently there is nearly no excuse to use the protocol dependent containers. There are a few exceptions where (e.g. where sockaddr\_storage will eat up to much memory) but this is really, really rare.
* gethostbyname() and gethostbyaddr() must be replaced (and also getipnodebyname and getipnodebyaddr)
* MUST also be replaced inet\_ntop(), inet\_pton() and inet\_aton() (e.g. they they do not support scoped IPv6 address)
* in6\_addr isn't guaranteed sufficient to identify a node. The scope information (the interface information) is missing
* Name resolution? use getaddrinfo() and getnameinfo()!


and last but not least: do not hardcode AF\_INET or AF\_INET6!


