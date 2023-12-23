---
title: "MSG_WAITALL and recv"
date: 2008-05-02T20:53:13+02:00
draft: false
---

The recv() function has a really rare argument: MSG\_WAITALL. It tells that the
syscall should not return before length bytes are read. The problem is that
normally nobody knows how much data is send by the peer node. So if you rely on
a particular amount of data and the data isn't send, this call blocks infinity!
On the other hand, a programmer must also handle this kind of failure, because
a simple read() of a socket can also block forever. A timeout handler is always
needed (alarm() as the simplest solution).


The background is that recv() normally return after length bytes or if a
threshold values is raised. sock\_rcvlowat() is the function who look if the
user want to wait until length bytes are ready or returns earlier. sk\_rcvlowat
is the socket specific variable which determine the break out szenario.



```
return (waitall ? len : min\_t(int, sk->sk\_rcvlowat, len)) ? : 1;

```

sk\_rcvlowat can be set on a socket basis via setsockopt(). Normally sk\_rcvlowat
is initialized with 1. Therefore a recv() call does block minimum for 1 byte.
If you increase sk\_rcvlowat beyond the recv() length parameter then
min(sk\_rcvlowat, length) -> length is taken - of course!


recv() will also return if OOB data is received, an error occured or an signal
arrived us.


