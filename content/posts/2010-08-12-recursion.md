---
title: "Recursion"
date: 2010-08-12T14:52:19+02:00
draft: false
---

Since several days I started to verify the Silly Window Syndrome (SWS)
avoidance algorithms and mechanism. To trigger one peculiarity (receiver side
SWS) it is more or less unavoidable to shift the network stack into a special
state. One requirement is that the socket buffer should be as small as possible
to reduce the initial analysis delay. Via setsockopt() it is possible to tune
the receiver buffer. But during some analysis I spotted an error in the current
network stack, the bug is hidden in the TCP window scale option and the dynamic
memory management component. This bug isn't a trivial bug and a lot effort is
required to validate my patch.


The validation requires a exact knowledge of the network socket state. During
the development I use a more or less a hacky KVM/QEMU setup. But this time it is
necessary to verify the patch in a real-world-system too. Why? Because the
behaviour in a full memory loaded system differs from my 192 MB KVM setup.
There are some other constraints that prefer a life system.


Anyway, to instrument my kernel I use
[systemtap](http://sourceware.org/systemtap/) the Linux pendant to Solaris
dtrace. During kernel instrumentation I spotted a weak point:



```
probe kernel.function("tcp\_select\_initial\_window").return {
         printf ("return %s(%s) %u\n", probefunc(), execname(), $rcv\_wnd[0]);
}

```

The TCP receive window should 5840 byte (4 \* maximum segment size), but stap
return always 0 - but 0 is definitely not returned! Maybe I make a failure in using stap(1), not sure but the IRC #systemtap crowd is also not sure ...
BTW: it is possible to dereference the arguments of the function but this is
only possible in the call path (not in return path) via kernel\_int(ulong\_arg(3)) ...


![images/escher.jpg](images/escher.jpg)
UPDATE: the guys at freenodes #systemtap are quite helpful! In the return
path and with systemtap >= 1.3 the following works:
kernel\_int(@entry($rcv\_wnd)) ...


<pre>
<fe> please let us know if you get some interesting results with or despite the tool :)
</pre>


