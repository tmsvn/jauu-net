---
title: "Once Again - Encryption and Authentication"
date: 2012-09-06T21:57:42+02:00
draft: false
---

For a new MANET protocol I started to verify the security concept. Not
from a security point of view, rather from a protocol feasibility point of
view. The security concept is based on existing security protocols. I just
removed dynamic components like key exchange and the like (to be correct:
dynamic aspects are done by special messages and not that tight linked
with the protocol). The result should be a very lean TLV, containing only
required security data without padding issues are "reserved" bits. The
default encryption algorithm is still AES128 and authentication (HMAC) is
done via SHA-512 (if used separately). So nothing special here. By the way: it
is a UDP based MANET protocol, IPSec and OpenSSL are not suitable - DTLS is
also not suitable.


At the time I started to implement the security relevant bits I was a
little bit annoyed about OpenSSL. OpenSSL has a usable API and the
provided functionality is large. But that is the problem: OpenSSL is just
a big monster of code and functionality. If you have a stripped demand of
functionality like en(de)cryption and checksumming you even have to link
the whole OpenSSL library into your program (library).


Some days ago I stumbled across [NaCl](http://nacl.cace-project.eu/index.html)
(pronounced "salt") a lightweight encryption/decryption/checksumming library.
Focus: speed and security. I like the API and started to use NaCL for the
project. Another nice argument: there are packages for Debian and Ubuntu
available in the official repository!


The next listing show the API and how to use a combination of [Salsa20](http://en.wikipedia.org/wiki/Salsa20)
(encryption) and [Poly1305-AES](http://en.wikipedia.org/wiki/Poly1305) (authentication).



```
#include "crypto\_secretbox.h"

const unsigned char k[crypto\_secretbox\_KEYBYTES];
const unsigned char n[crypto\_secretbox\_NONCEBYTES];
const unsigned char m[...]; unsigned long long mlen;
unsigned char c[...]; unsigned long long clen;

crypto\_secretbox(c, m, mlen, n, k);

```

