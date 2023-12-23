---
title: "Implicit Type Conversions and Bitwise Shift Operators"
date: 2010-12-02T23:43:01+02:00
draft: false
---

A error source for ANSI C ([ISO/IEC 9899:TC2; 6.3 Conversions](http://www.open-std.org/jtc1/sc22/wg14/www/docs/n1124.pdf)) is the
implicit type conversion mechanism. The following code fragment
illustrates a bogus usage of the shift operation in realtion with the type
of the operands:



```
void bit\_mark(unsigned long \*seq\_bits, int32\_t n)
{
  int32\_t word\_offset, word\_num;

  word\_num    = n / sizeof(unsigned long) \* 8;
  word\_offset = n % sizeof(unsigned long) \* 8;

  seq\_bits[word\_num] |= 1 << word\_offset;
}

```

The error source is the type of "1" which is implicit casted to an
integer (Section: 6.3.1.1. "If an int can represent all values of the
original type the value is converted to an int; [..] These are called the
integer promotions.All other types are unchanged by the integer
promotions.). seq\_bits on the other hand is a array of unsigned long
types. On 32 bit architectures this may work, but on 64 architectures like
x86\_64 where int is 32 bit wide and unsigned long is 64 bit wide the
upper 32 bit are left out! The solution is to define 1 as 1UL to promote
this type as the general processing type. Another sidenote: character
types are inplicit converted to a integer type, this includes both operand
to the shift statement. The formal ANSI C definition can be found under:
6.5.7 Bitwise shift operators:


The integer promotions are performed on each of the operands. The type of the
result is that of the promoted left operand. If the value of the right operand
is negative or is greater than or equal to the wide of the promoted left
operand, the behavior is undefined.


