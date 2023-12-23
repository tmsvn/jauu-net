---
title: "Main Memory Corrupt"
date: 2010-08-17T21:23:05+02:00
draft: false
---

Since several days strange things happen:


<pre>
Delta compression using up to 2 threads.
Compressing objects: 100% (8/8), done.
error: inflate: data stream error (incorrect header check)
error: corrupt loose object 'ebcab349c392aadd151101e6b2651ed451ff4bf7'
fatal: object ebcab349c392aadd151101e6b2651ed451ff4bf7 is corrupted
error: pack-objects died with strange error
</pre>


as well as mysterious compile errors and stuff like that. One similarity is a
raised memory access pattern, ... starting memtest to verify my assumption.


