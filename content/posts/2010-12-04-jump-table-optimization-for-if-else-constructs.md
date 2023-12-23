---
title: "Jump Table Optimization For If Else Constructs"
date: 2010-12-04T19:43:46+02:00
draft: false
tags: [optimization, gcc]
---

This blog post is not about micro-optimization nor about what you have to use.
Neither, it is about how compilers can optimize two common flow constructs. The
knowledge may provide enough background information to sharpen the view and
provides enough insights what construct to use for which usage.


The following if-else statement is compiled on x86\_64 with -O6 into the following ASM sequence:



```
int main(int ac, char \*\*av) {
  if (a == 0) foo();
  else if (a == 1) bar();
  else if (a == 2) shu();
}

```


```
[...]
 main:
 .LFB35:
   .cfi_startproc
   subq  $8, %rsp
   .cfi_def_cfa_offset 16
   cmpl  $0, %edi
   je  .L19
   cmpl  $1, %edi
   je  .L20
   cmpl  $2, %edi
   je  .L21
   .p2align 4,,5
   jne .L13
[...]

```

The if-else statement is translated into a conditional sequence of cmp and
conditional jump instruction.


A identical switch/case construct can be optimized because the compiler
can generate a jump table of complexity(1) compared to a complexity of
O(n) where the compiler generate a ordinary conditional construct. So if
you had to branch into multiple targets and the argument is a integer a
switch/case statement is superior. Requirement is that labels are dense. If not
the fallback is to use the conditional jump chain.



```
switch (ac) {
case 1: foo(ac); break;
case 2: bar(ac); break;
case 3: sho(ac); break;
}

```

L18 is the label where the jump tables is saved. The *jmp* instruction will
jump to the right label:



```
main:
.LFB35:
  .cfi_startproc
  subq  $8, %rsp
  .cfi_def_cfa_offset 16
  cmpl  $5, %edi
  ja  .L12
  mov %edi, %edi
  jmp *.L18(,%rdi,8)
  .section  .rodata
  .align 8
  .align 4
.L18:
  .quad .L12
  .quad .L13
  .quad .L14
  .text
  .p2align 4,,10
  .p2align 3

```

If you have \_some\_ items the if-else statement is sufficient fast and no
differences are measurable. But for many entries you should definitely use a
switch/case statement. And by the way: a switch/case statement is often more
eye pleasant to understand and can be considered as a list of coequal options.
But anyway it is a micro-optimizations and does not affect your code
(exceptions are omitted). If you write code often and you are free to
choose the right construct why not to pick up the more efficient one? But as
always in programming: readability and maintainability are of higher interest.


Another tip: sometimes I see code something like this:



```
if (!strcmp(arg, "foo")) foo();
else if (!strcmp(arg, "bar")) bar();
else if (!strcmp(arg, "shu")) shu();
[...]

```

The delicate issue of this construct is that the key (here arg) is compared
multiple time in the program - not in one place but several times *arg* must be
considered. The key is constant and do never change and strcmp() isn't the
lightweight function. The more intelligent approach is to map the key to a
enum/int type at program start and use a switch/case construct afterwards:



```
int map(const char \*arg) {
if (!strcmp(arg, "foo")) return TYPE\_FOO;
else if (!strcmp(arg, "bar")) return TYPE\_BAR;
else if (!strcmp(arg, "shu")) retrn TYPE\_SHU;
}

int main(int ac, char \*\*av) {
  const int type = map(av[0]);
  switch (type) {
    case TYPE\_FOO: return foo();
    case TYPE\_BAR: return bar();
    case TYPE\_SHU: return shu();
  }
}

```

A last sidenote: if you are mainly interested on the function call than another
superior construct is a function pointer array where the type is the index into
the array. But this is more specific but on the other hand the most efficient
usage for this scenario.


