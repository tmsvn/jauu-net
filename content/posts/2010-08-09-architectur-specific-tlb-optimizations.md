---
title: "Architectur specific TLB Optimizations"
date: 2010-08-09T20:57:39+02:00
draft: false
---

I thought about how I would design the Translation
Lookaside Buffer of the Memory Management Unit (MMU) if I was the CTO of Intel,
respective AMD. ;-) In one of my last postings I talked about an potential
optimization for @x86/x64\_64@ but at the end I decided that the effort of
implementing and testing compared with the benefit is to high so I skipped
this. But as said this I thought about how would I design the TLB regardless
of any existing implementations ...


As I [already wrote](http://blog.jauu.net/2010/08/06/Translation-Lookaside-Buffer-Flush-Optimization)
the TLB is a fully associative cache because most programs exhibit so called
"locality of reference". This means that the working set will be used many
times. The most recently used page mappings will be stored. The TLB cache
virtual addresses to physical addresses on a page basis (e.g. 4096 byte). With
a few page entries a full program can be mapped: @.text@, @.data@, @heap@, ...


Fully associative caches are costly because entries must be searched in
parallel. Any address can be stored everywhere in the cache and no hashing or
indexing is applied. n-way set associative caches on the other hand use a
index.


So far so good! From my last posting we know that the TLB logic is not entirely
spilled into silicon. At least some processor architectures swap some logic to
the kernel. This is the point where we start!


When a TLB hit occurs the cache returns the physical address. If a miss
occur two things depending on the architecture can happen:


* the processor start looking up the page table by himself - called page walk - until he find the physical address and replace the TLB by himself
* the processor generates a trap and shift the task to the operating system. The kernel must now walk over the page table, check the page permission and finally replace the TLB entry with the right physical address.


The former approach is implemented by @x86@, @SPARC@ and some others. The later
is implemented by the MIPS family.


But that's not all, there are some subtle differences. As I wrote in the other
[postings](http://blog.jauu.net/2010/08/06/Translation-Lookaside-Buffer-Flush-Optimization/)
Linux does not flush the TLB if a Kernel thread is scheduled because a kernel
thread does not touch user pages and kernel pages are unique. But if the kernel
scheduled another user space process the virtual to physical mappings become
obsolete. Each new page walk is a costly operation and should be avoided. Some
architectures extend the concept of a plain address space by (re)introduce a
key - surprise! ;-) This key is bound to the task and only if the task differs
the TLB entry is flushed. One example is the TI-SPARC where a context switch
does not require a TLB flush.


!http://blog.jauu.net/2010/08/09/Architectur-specific-TLB-Optimizations/mmu-thumb.png!


I just started to understand how the context switch works for the SPARC is
implemented. But it is hard to read SPARC assembler code (not as hard as ia64
asm ;-):


arch/sparc/kernel/tsb.S:



```
  /* At this point we have:
   * %g1 -- TSB entry address
   * %g3 -- FAULT_CODE_{D,I}TLB
   * %g5 -- valid PTE
   * %g6 -- TAG TARGET (vaddr >> 22)
   */
tsb_reload:
  TSB_LOCK_TAG(%g1, %g2, %g7)
  TSB_WRITE(%g1, %g5, %g6)

  /* Finally, load TLB and return from trap.  */
tsb_tlb_reload:
  cmp %g3, FAULT_CODE_DTLB
  bne,pn %xcc, tsb_itlb_load
  nop

```

Especially the label tsb\_miss\_page\_table\_walk\_sun4v\_fastpath: is of
interesst. Also the division between instruction and data.


