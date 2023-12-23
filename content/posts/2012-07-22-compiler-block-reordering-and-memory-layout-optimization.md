---
title: "Compiler Block Reordering and Memory Layout Optimization"
date: 2012-07-22T21:05:08+02:00
draft: false
tags: [gcc, optimization]
---

GCC as enabled with -freorder-blocks and a optimization level
larger 1 will reorder instructions at a block level. This optimization is
mainly to compress correlated code to provide a optimized cache aware memory
layout. Because of some Linux kernel hacking I forced to get the details when
and where GCC's optimizations kicks in. The most effective way for userland
programs without branch-taken-knowledge is through profile guided optimization
nowadays. But this is not possible in every setup (lack of realistic input
data, ...). Another way are GCC's builtin expect statement - but this required
exact knowledge of data paths and realistic input data. The next two snippets
show how GCC reorder a simple if-else statement (just for demonstration):



```
4004c0: 83 ff 01              cmp    $0x1,%edi
4004c3: 7f 04                 jg     4004c9 <process+0x9>
4004c5: 8d 47 01              lea    0x1(%rdi),%eax
4004c8: c3                    retq
4004c9: 8d 47 02              lea    0x2(%rdi),%eax
4004cc: c3                    retq

```


```
4004c0: 83 ff 01              cmp    $0x1,%edi
4004c3: 7e 04                 jle    4004c9 <process+0x9>
4004c5: 8d 47 02              lea    0x2(%rdi),%eax
4004c8: c3                    retq
4004c9: 8d 47 01              lea    0x1(%rdi),%eax
4004cc: c3                    retq

```

The fascinating question is what are the limits of this optimization. What are
the influences of nested statements? Are there any thresholds not to reorder
blocks? I just prepared some code generation script to analyze this
characteristic. But now do some tests and write an analyzer script too.


