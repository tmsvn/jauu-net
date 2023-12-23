---
title: "How to Cc in Patches"
date: 2010-06-19T21:43:39+02:00
draft: false
---

Nearly 99 percent of all kernel patches touch someones code.
Someone is often the maintainer of the subsystem or another developer who is
responsible for special tweaks. So the patch should not limited to some
maillinglist but should also be addressed directly to the stakeholders of the
code. If you are familiar with the current subsystem you know how is the
stakeholder and it easy to Cc the right people. On the other hand if you are
working within complete unfamiliar code it is not that easy.


The most simple strategy is to look at source code and annotate the lines.
Beside that it is of interest who contributes the lion shares. The following git
command displays the top 3 contributors since kernel version 2.6.12 for the KVM
directory:



```
git shortlog --email v2.6.12.. -sn arch/x86/kvm/ | cat -n | head -n 3

```

The kernel version as well as the restriction of the source code files must be
adjusted for the personal needs - of course.


