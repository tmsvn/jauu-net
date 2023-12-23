---
title: "KVM QEMU Kernel Debugging"
date: 2010-12-04T17:08:06+02:00
draft: false
tags: [optimization, kvm, qemu]
---

Sometimes it is unavoidable to single step through the kernel because the code
flow is complicated and *systemtap* and other tools are not helpful. This comes
true when a lot of code must be conditionally analysed, without any prior
knowledge. KVM and GDB provides a nice combination for this. I use my standard
qemu setup with two additional qemu flags: *-s* and *-S*. Both flags instrument
qemu to start a qemu gdb server and to break at the beginning. On the other
side, the debugger side the following gdb commands are required to bring the
environment in a suitable state:


<pre>
gdb /usr/src/linux/vmlinux
target remote localhost:1234
c
bt
set architecture i386:x86-64:intel
</pre>


*set architecture i386:x86-64:intel* fix a bug where gdb cannot detect that the
target is *x86\_64* one (adjust this for your needs). After this the common
commands like setting breakpoints can be applied.


