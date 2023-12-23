---
title: "GCC versus LLVM"
date: 2011-09-07T19:11:52+02:00
draft: false
---

Today is one of these wacky days where nothing works (problems with kvm-tool, problems with RAM backed block device driver and kvm interaction and so on. But today was also the day of another Round of Vladimir Makarov gcc-versus-llvm round (gcc mailing list). To summary the highlights:


* LLVM is not faster as GCC (this is a often repeated lie): If you need the same generated code quality and compilation speed as LLVM -O2/-O3 you should use GCC with -O
* If you want 10%-40% faster generated code, you should use GCC with -O2/-O3 and you need 20%-40% more time for compilation (150%-200% if you use GCC LTO)
* Vladimir believe that LLVM code performance is far away from GCC because it is sufficiently easy to get first percents of code improvement, it becomes much harder to get subsequent percents


Vladimir used this year -Ofast -flto -fwhole-program instead of -O3 for GCC
and -O3 -ffast-math for LLVM. To see the full report follow the link:


<http://vmakarov.fedorapeople.org/spec>


