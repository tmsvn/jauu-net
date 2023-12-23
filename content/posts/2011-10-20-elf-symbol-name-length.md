---
title: "ELF Symbol Name Length"
date: 2011-10-20T16:32:26+02:00
draft: false
tags: [elf]
---

Category: unlimited. The ELF spec has no real (artificial) symbol name
limitation. It only restricts offsets in string table by 4 bytes. And gcc/gdb
are consequent: they also introduce no artificial limitation.


Of course, resolving dynamic linked object requires hashing and strcmp'ing
these symbol names. Especially larger projects with lots of symbols will suffer
from this (you may notice this for C++ symbols because of namespace bloat).


