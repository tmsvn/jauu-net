---
title: "Nothing Absorbing, Just Hacking"
date: 2010-06-28T22:09:27+02:00
draft: false
---

Nothing really interesting these evening - just the usual hacking session.
Linus is back from vacation and pent-up patches should be soaked up the next
days. Eric submitted one patch after the other and the comment of Davem take
the biscuit: "Slow down Eric, you're on fire :-)".


Mathieu Lacage - let's call him the ns-3 main developer ;-) - posted a patch
where he fixed a uninitialized memory access, spotted by valgrind.


By the way: you cannot use valgrind directly to spot failures in the network
stack/kernel. Mathieu use the Network Simulation Cradle (NSC) to execute the Linux
Network Stack on top of ns-3. With this combination it is possible to use
valgrind to spot some errors. Florian already spotted some errors triggered by
valgrind ~2 years ago where he ported nsc to ns-3.


The posted patch was not really perfect because tcp\_check\_req() calls
tcp\_parse\_options() only to update the timestamp indication (@saw\_tstamp@). The
valdgrind message is triggered by a uninitialized @opt\_rx->user\_mss@ which is
not used here. Eric's patch tried to fix it and Davem replied:



```
> -     struct tcp_options_received tmp_opt;
> +     struct tcp_options_received tmp_opt = {0};
>       u8 *hash_location;
>       struct sock *child;

That's a 28 byte memset() in the connect fast-path.  We shouldn't eat this
just to placate a valgrind miscue. :-)

```

:-)


