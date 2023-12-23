---
title: "Finally BPF Optimization Is On The Run"
date: 2010-06-21T14:23:49+02:00
draft: false
tags: [optimization, gcc, bpf]
---

Yesterday I submitted all patches, one for linux-kernel and one for netdev.
Normally git send-email saves me and automatically cc all stakeholders (if you
construct you patch correctly) but this time I missed the whole kvm
maillingslist and all involved stakeholders - shit happens. ;-) I furthermore
asked davem how about to use of a special, but proprietary gcc extension. As I
think we can gain some performance gains if we permit this extension - let's
wait and see ...


![images/bpf-run.png](images/bpf-run.png)
