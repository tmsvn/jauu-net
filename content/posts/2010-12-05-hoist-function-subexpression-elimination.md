---
title: "Hoist Function Subexpression Elimination"
date: 2010-12-05T21:25:16+02:00
draft: false
---

Function calls embedded in loop constructs are a area of optimization. As
a general statement: it is clever to hoist any method calls from loop
statments like for, while and the like where the result is constant
(eliminating redundant computation is a standard optimization mechanism). For
example, often you will see constructs like for (i = 0; i < strlen(str); i++) { whatever }.
strlen() is evaluated every time, although str does
never change. A optimized way would be for(i = 0, max\_str = strlen(str); i  < max\_str, i++) { whatever }
so that strlen() is called once.


Modern compilers on the other hand implement strlen() as a build-in
function, the glibc function is not called. GCC provides
his own replacement. The compiler is therefore in the ability to detect that
strlen() exhibit no side-effects (e.g. change no global memory). The compiler can
now hoist this function like the handcrated version. Via -fno-builtin all
build-in functions can be disabled and the compiler cannot optimize this
construct. But wait! Gcc provides a possibility to mark functions to state that
they have any side-effects: the pure attribute (gcc since version 2.96
supports the pure attribute). Gcc can now optimize (hoist) unknown
functions just as builtin functions:



```
/\* naiv strlen implementation - just demonstration of pure \*/
static size\_t \_\_attribute\_\_ ((pure)) strlen(const char \*str)
{
  const char \*s;
  for (s = str; \*s; ++s) ;
  return s - str;
}

```

To mark the argument with the ANSI const keyword is not enough, on the one side
it provides gcc the hint that this function does not modify the argument. It
does not provide the compiler enough information that the function body is free
of side effects.


From the GCC manual:



```
Many functions have no effects except the return value and their
return value depends only on the parameters and/or global
variables.  Such a function can be subject to common subexpression
elimination and loop optimization just as an arithmetic operator
would be.

```

Another similar technique is known as constant folding. But constant
folding provides another area: it evaluates expressions at compile time
where the result is calculateable at compile time. One example is htonl()
where the argument is a constant (e.g. htonl(0xbeef)).


