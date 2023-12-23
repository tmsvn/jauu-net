---
title: "A, AAAA and MX Records Changed"
date: 2012-07-04T14:52:40+02:00
draft: false
---

Due to a server move some IP addresses as well as certificates changed. In the
next week I will publish the server certificates too. If you detect some broken
links please drop me an email. This includes links to git repositories too.



```
$ dig +retry=0 +qr jauu.net A | egrep '.*jauu\.net.*[[:digit:]]' -
jauu.net.   1242  IN  A 80.244.247.6
$ dig +retry=0 +qr jauu.net AAAA | egrep '.*jauu\.net.*[[:digit:]]' -
jauu.net.   1233  IN  AAAA  2001:4d88:1ffa:82:880:aa0:9009:f00d
$ dig +retry=0 +qr jauu.net MX | egrep '.*jauu\.net.*[[:digit:]]' -
jauu.net.   3600  IN  MX  100 jauu.net.

```

I further modified this blog. A homemade static site generator was used to
build this blog since day 0. But I had no pagiation support so I decided to
switch to Pelican. A clean and simple static site generator programmed in
Python. I am no designer/web-developer but I hope that the design is acceptable?!
The background image was taken 2010 in New York at a short trip with a
colleague: Patrick Rehm.


