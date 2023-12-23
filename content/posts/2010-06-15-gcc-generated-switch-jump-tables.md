---
title: "GCC generated Switch Jump Tables"
date: 2010-06-15T15:01:35+02:00
draft: false
---

The disassembled output of filter.o looks not cache-line friendly, with the
current generated code two cache-lines must be hit -- at least. A switch
statement with two case statements is translated into a sequence of conditional
branches like this (arch: @x86\_64@):



```
4b8: 8b 06                 mov    (%rsi),%eax
4ba: 66 83 f8 35           cmp    $0x35,%ax
4be: 0f 84 d8 02 00 00     je     79c <sk_run_filter+0x325>
4c4: 0f 87 07 01 00 00     ja     5d1 <sk_run_filter+0x15a>
4ca: 66 83 f8 15           cmp    $0x15,%ax
4ce: 0f 84 cd 02 00 00     je     7a1 <sk_run_filter+0x32a>
4d4: 77 73                 ja     549 <sk_run_filter+0xd2>
4d6: 66 83 f8 04           cmp    $0x4,%ax
4da: 0f 84 1f 02 00 00     je     6ff <sk_run_filter+0x288>
4e0: 77 29                 ja     50b <sk_run_filter+0x94>

```

The whole switch/case jump construct in @run\_filter()@ eat exactly *567 byte .text memory*! But
why does gcc not generate a jump table (also known as branch table)?


The basic gcc algorithm for switch constructs is simple: less then 5 case
statements forces gcc to generate code as explained above. More then 5 case
statements command gcc to use a jump table - if the labels are in some degree
stick together(dense). A heuristic will calculate if the degree is sufficient.
And this kicks in here, the labels are exposed and filling the gaps with
defaults is to costly. So keep the labels close to each other to make this
optimization possible for gcc! gcc generates a small data section where the
addresses of all labels are stored and the finally switch construct leads to a
simple jump (I simplified the code):



```
cmpl $4, %eax
ja   .L8
jmp *.JUMPTABLE(,%eax,4)

```

The advantage is a reduced complexity from O(n) to O(1). The threshold is 5
cases if less then 5 a binary search is applied, more then 5 leads to the jump
table.


The alternative is illustrated in the first listing where each label is a
sequence of compare and jump instructions. The labels are GCC internally
encoded as a binary tree data structure which results in the end in a ordered
tree. Finally, small switch statements can generate a series of bit
instructions and branches.


gcc permits to disable jump table generation via @-fno-jump-tables@. For
example if you do branch analysis or program other code analyzers the jump
table trick is not easy to parse.


See @gcc/stmt.c@, especially @expand\_case()@ is quite interesting. A simple
jump table optimization by subtracting the minimal label value is only applied
when optimization for speed is enabled -- strange!


