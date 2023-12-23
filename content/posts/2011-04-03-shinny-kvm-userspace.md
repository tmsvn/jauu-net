---
title: "Shinny KVM Userspace"
date: 2011-04-03T16:58:44+02:00
draft: false
tags: [kvm, linux]
---

Wow, today Pekka Enberg announced a new KVM userland (e.g. a qemu pendant).
Techical it is really raw at the moment: no networking support, no graphic
support and so on. The list of missing things is long. The most prominent
change is another one: it is aligned with the Linux development, e.g. it is
placed under tools/kvm and because of it freshness it can mature into a more
powerful environment as todays qemu (e.g. SMP support).


To build the tool you can try this:



```
cd /usr/src/linux
git checkout -b kvm/tool
git pull git://github.com/penberg/linux-kvm.git

# Compile the tool
cd tools/kvm&&  make

# Download a raw userspace imag
wget http://wiki.qemu.org/download/linux-0.2.img.bz2
bunzip2 linux-0.2.img.bz2

# Build a kernel with
CONFIG_VIRTIO_BLK=y
CONFIG_SERIAL_8250_CONSOLE=y
CONFIG_EXT2_FS=y
CONFIG_EXT4_FS=y

# lunch the tool
./kvm --image=linux-0.2.img --kernel=../../arch/x86/boot/bzImage

```

