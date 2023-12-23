---
title: "Hypervisor Time Machine Call Graph"
date: 2010-06-17T13:49:54+02:00
draft: false
tags: [linux, hypervisor]
---

Finally: a dream comes true. Doubling or even increase tenfold the clock
frequency of your CPU without costs by modifying some variables. Drawback it
just works under use of a hypervisor; a virtual environments under kvm. ;-)


Just kidding, but as explained yesterday in a blog posting my idea was to
introduce a decoupled behavior of the virtual clock. Actually I had no notion
to explain the implementation in detail. Just some aspects: the mechanism does
not use a utilize a virtual interrupt, on the contrary a memory page is mapped
into the guest. The patch modifies some places, in the hypervisor as well as in
the guest implementation. Currently a multiplier (called @time\_machine\_mult@)
control the clock rate but there are some improvements possible, especially if
several guest instances are run in parallel. Network test setups for example
connected via VDE with a unify time source requirements will need a more
synchronized environments.


After some beautyfications I will push the patch upstream.


![images/hyper.png](images/hyper.png)
