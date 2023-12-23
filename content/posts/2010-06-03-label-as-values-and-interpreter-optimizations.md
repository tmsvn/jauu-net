---
title: "Label as Values and Interpreter Optimizations"
date: 2010-06-03T14:10:44+02:00
draft: false
---

The GNU Compiler supports since several releases a unofficial C feature called
"Label as Values":<http://gcc.gnu.org/onlinedocs/gcc/Labels-as-Values.html>.
This feature offers the ability to retrieve the address of a label and
use it in a unconditional branch construct. foo, bar and hack are labels:



```
static void \*array[] = { &&foo, &&bar, &&hack };
[...]
goto \*array[i];

```

The saved condition comes with its one costs: this form is not simple to read
compared to simple switch/case statements, especially in real world examples.
Anyway this feature offers the ability to get rid of some CPU cycles by
substitute the conditional branch. A really nice employment for Label as Values
are interpreters, the following code fragment illustrate this:



```
static int interpret(Opcodes opcodes) {
  static const void \*codetable[] =
      { &&RETURN, &&INCREMENT, &&DECREMENT, &&DOUBLE };
  int result = 0;

  goto \*codetable[\*(opcodes++)];

  RETURN:
   return result;

  INCREMENT:
   result++;
   goto \*codetable[\*(opcodes++)];

  DECREMENT:
   result--;
   goto \*codetable[\*(opcodes++)];

  SWAPWORD:
   result = (result << 16) | (result >> 16);
   goto \*codetable[\*(opcodes++)];
}

```

I found this example on the bugzilla site for llvm (<http://llvm.org/bugs/show_bug.cgi?id=3120>).


llvm support this language feature since some time but internally implemented it
using a switch table. So no performance gains are expected for LLVM. Sidenote,
LLVM internal generated switch tables where often superior to the hand crafted
switch/case counterpart. This changes over time and llvm now supports full
Label as Values support, current values depending on the architecture are
quite impressive. To sum up: interpreted switch is almost always faster on
all workloads - exception: llvm on x86\_64. The duel between GCC and llvm are
quit variable, depending on the architecture, if switched or threaded and so
on.


I looked at the Berkely Packet Filter
(<http://lxr.linux.no/#linux+v2.6.34/net/core/filter.c>) implementation at the
Linux kernel but the current structure allows no straight forward modification
of the code. Labels are currently compile time calculated bit expressions.


