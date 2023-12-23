---
title: "Cscope and Code Navigation"
date: 2012-07-12T13:57:50+02:00
draft: false
---

Cscope is a crucial part in my development tool zoo. Not for small projects but
for larger projects like Linux Kernel development I use cscope really often.
But as usually: I only use a small subset of all cscope features. This normally
boils down to Ctrl-] to jump to the declaration of the function and later
Ctrl-t to jump back. With Cscope the acts like gD (goto declaration) with don't
stop at file boundaries.


But Cscope has more features! Cscope supports several programming languages
and can find all calls to a function or functions called by this function under
cursor. So here is a list of all features copied from the cscope vim plugin.
You can call call any function by typing: CTRL-followed by one of the
following the character.



```
's'   symbol: find all references to the token under cursor
'g'   global: find global definition(s) of the token under cursor
'c'   calls:  find all calls to the function name under cursor
't'   text:   find all instances of the text under cursor
'e'   egrep:  egrep search for the word under cursor
'f'   file:   open the filename under cursor
'i'   includes: find files that include the filename under cursor
'd'   called: find functions that function under cursor calls

```

