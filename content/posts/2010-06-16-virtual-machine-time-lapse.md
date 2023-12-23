---
title: "Virtual Machine Time Lapse"
date: 2010-06-16T21:46:20+02:00
draft: false
tags: [linux, kvm, hypervisor]
---

Today I had the idea of accelerate respective decelerate the time for virtual guest
machines. The idea comes into mind with time discrete simulators where
the wall clock behavior is not required or rather cumbersome. Linux sophisticated
kernel virtualization infrastructure is kvm (Kernel-based Virtual Machine,
where Intels VT-x or AMD-V native virtualization technique is used).


Several timing systems are supported by QEMU and the kernel side:


* PIT, an emulation of @Intels i8254@ Programmable Interval Timer, normally with three 16 bit counters, modern back in @i8086@ CPUs days
* RTC, the real time clock with a interval of 32768 ticks per second to advance the time system reported by interrupt number 8. A really comprehensive documentation can be found at Documentation/rtc.txt
* TSC, a 64 bit wide counter (time step counter) and present on all x86 processors. Based on the famous @rdtsc@ instruction, but as usual the disadvantages of @rdtsc@ also employees for kernel side clock keeping: not CPU hibernation aware, core migration problems and so on. The Kernel on the other hand will do everything to analyze the behavior of the RTC. If the analyze results in a inaccurate behavior the RTC clock is not used. Some days ago Thomas Gleixner talked about the problems of TSC and why he dissuade user space applications from using it.
* HPET, the high precision event timer is the new kind on the block and take over the RTC. HPET has a ~10MHz 64 bit wide counter and 3 independent 64-bit comparators as well as 29 additional 32-bit comparators for random interrupt generation. My hardware HPET announce itself as @hpet0: 4 comparators, 32-bit 14.318180 MHz counter@ (see @x86/kernel/hpet.c@)


My KVM environment provides no stable RTC clock source so it switch from RTC to
HPET emulation mode.


VMWare provides a good overview about timekeeping and virtualization:
"vmware\_timekeeping.pdf":<http://www.vmware.com/pdf/vmware_timekeeping.pdf>


So currently I am working at the mentioned feature but high resultion timer
implementation as well as the clock diversity zoo make life not easy. The code
lacks of documentation too, so often only reverse engineering provides the
required information and this decelerate the flow ...


