---
title: "2am and still bug fixing"
date: 2008-07-15T19:47:43+02:00
draft: false
---

today in the evening I received the following bug report for libhashish
(especially the bloom filter implementation):



```
[...]
../include/libhashish.h:116: syntax error before "pthread\_rwlock\_t"
../include/libhashish.h:116: warning: no semicolon at end of struct or union
[...]

```

Looks pretty forward, but hold on! One line above in the spotted code are
some tricky compiler forward declarations so we checked this first with some
older GCC versions - no success. After that we focused on glibc and their
threading support for older versions and voilà: some today really outdated glibc
versions (especially the linuxthread ones, the NPTL predecessor) require to define a additional constant.


At the end: thank you for spotting the bug and why for god's sake use CISCO premature software?


