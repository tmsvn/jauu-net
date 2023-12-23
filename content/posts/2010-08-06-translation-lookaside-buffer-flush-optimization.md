---
title: "Translation Lookaside Buffer Flush Optimization"
date: 2010-08-06T22:49:59+02:00
draft: false
tags: [optimization, tlb, tlb-flush]
---

The Translation Lookaside Buffer is a small associative memory that caches
virtual to physical page table addresses. When page tables have been updated,
such as after a page fault, the processor may need to update the TLB for that
virtual address mapping. May, because some processor architectures implement
this in hardware logic some other architectures need support by the operating
system. Flushing TLB is a really expensive operation - depending on the
architecture (e.g. PowerPC) - and should be avoided if possible in any way.
Linux for example does not invalidate the TLB if a context switch occurs, Linux
rather tries to partial invalidate the TLB. Kernel threads for example access
only the kernel space and do not require an invalidation of the user space TLB
cache, Linux does not invalidate the cache in that case.


Today I played with some TLB optimization. Current kernel code can flush
one page cache for a given page
or all pages. Although the kernel API provides the possibilities to
invalidate a range of pages. If a range is
requested for invalidation, all pages are invalidated and not a limited
range of addresses.


flush\_tlb\_range(vma, start, end) for a given mm context from start till
end all pages are declared as invalidate via this method. Partial
invalidation can happend if a memory region has moved or permissions are
changed (via mprotect()). munmap() or mprotect\_fixup() for example use
this function.


flush\_tlb\_all() on the other hand invalidates the TLB on all processors
running in the system. flush\_tlb\_mm() flushes the TLB for a given
userspace context, always below PAGE\_OFFSET. fork() is a user of this
function.


Some words about the invalidation procedure on x86: the INTEL manual
stated that all non-global TLB entries are flushed after writing to CR3 .
The CR3 is used to translate the virtual addresses into physical addresses
by pointing to the page directory and page tables of the current task.
Read and re-write the CR3 register was the only way to flush the TLB
after a page table update. Newer CPU have TLB flush instructions to
partial flush a given address, i386 and i486 CPU's didn't have these
instruction; via @invlpg@ it is on x86 >i486 possible to flush a given
memory address.



```
static inline void invalid\_tlb\_old(void)
{
    unsigned long val;
    asm volatile("mov %%cr3,%0\n\t" : "=r" (val), "=m" (\_\_force\_order));
    asm volatile("mov %0,%%cr3": : "r" (val), "m" (\_\_force\_order));
}

```


```
static inline void invalid\_tlb\_addr(unsigned long addr)
{
    asm volatile("invlpg (%0)" ::"r" (addr) : "memory");
}

```

*UPDATE:* I decided to stop digging into this optimization. After a while of
analyzing the callees I realized that the effort is much higher as the
potential benefit.


