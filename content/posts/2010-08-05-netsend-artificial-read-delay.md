---
title: "Netsend Artificial Read Delay"
date: 2010-08-05T17:17:23+02:00
draft: false
---

Today I invest my time in adding a new option for
"netsend":<http://netsend.berlios.de> to introduce an artificial @read()@ delay
in the receiver path. The new option can be enabled via:


<pre>
netsend -v loudish -B 10,1 -b 250 -s SO\_RCVBUF 1 tcp receive
</pre>


The options states that the receiver should initial block for 10 seconds and
then read 250 byte chunks with a delay of one second: @-B 10,1@. If you waive
the initial delay you can also skip the coma separated list and hand over only
one argument, e.g. @-b 1@. This will delay the @read()@ operation with a one
second delay.


