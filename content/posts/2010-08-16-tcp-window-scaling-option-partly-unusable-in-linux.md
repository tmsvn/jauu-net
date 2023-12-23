---
title: "TCP Window Scaling Option partly unusable in Linux"
date: 2010-08-16T14:21:57+02:00
draft: false
---

TCP's window scale factor is determined at the connection start-up. Among other
things local memory constraints are checked and used as the basis to calculate
the window scale shift factor. The exact procedure is complex and not of interest
here. Currently the Linux network stack does not consider a reduced rcv buffer
which can be reduced via setsockopt(). Today I sent a patch which fix this
with some lines of code:



```
if (sk->sk\_userlocks & SOCK\_RCVBUF\_LOCK &&
        (req->window\_clamp > tcp\_full\_space(sk) || req->window\_clamp == 0))
    req->window\_clamp = tcp\_full\_space(sk);

```

I waive explaining text in the patch why I fixed the bug in this way and not
modified the main function (tcp\_select\_initial\_window()) and hope that Dave
and Ilpo trust me ... ;-)


