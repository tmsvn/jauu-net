---
title: "MD5 Options Support"
date: 2008-07-15T21:23:09+02:00
draft: false
---

Netsend supports now the MD5 socket option (TCP\_MD5SIG) for TCP based sockets.
This options was introduced to protect long running TCP sessions like BGP RFC
2385. The exchanged digest are introduced to hold a shared secret and prevent
spoofing attacks. Only several applications utilize this option - netsend
nowadays do also! ;)


