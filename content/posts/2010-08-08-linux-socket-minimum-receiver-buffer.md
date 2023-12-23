---
title: "Linux Socket Minimum Receiver Buffer"
date: 2010-08-08T17:44:36+02:00
draft: false
---

Via setsockopt(socket, SOL\_SOCKET, SO\_RCVBUF, n, 4) it is possible to
increase/decrease the socket receive buffer where n is the number of byte.
Internally the specified number is doubled to cover bookkeeping overhead.
The minimum value is defined as SOCK\_MIN\_RCVBUF (256 byte). It is not
possible to specify any smaler value. Even if the user specified something
smaller the actual buffer is silently increased to SOCK\_MIN\_RCVBUF (the
man page is a little bit outdated and stated that setsockopt will return
with a failure - this is not correct).



```
if ((val \* 2) < SOCK\_MIN\_RCVBUF)
        sk->sk\_rcvbuf = SOCK\_MIN\_RCVBUF;

```

The default value for the socket receiver buffer is specified in
/proc/sys/net/core/rmem\_default, the maximum value is specified by
/proc/sys/net/core/rmem\_max. sysctl\_rmem\_default is initialized as to:



```
\_\_u32 sysctl\_rmem\_default \_\_read\_mostly = (sizeof(struct sk\_buff) + 256) \* 256;

```

The size of struct sk\_buff is not constant a


tcp\_select\_initial\_window() determine a initial window to offer and the
corresponding window scale factor. This function is a little bit


include/net/tcp.h:tcp\_full\_space()


sysctl\_tcp\_adv\_win\_scale is initialized to 2.


SOCK\_MIN\_RCVBUF 256


Finally, the man page entry is not correct: if the user specified a too small
value the setsockopt call will return with no error but silently set the buffer
to the smallest legal value:


