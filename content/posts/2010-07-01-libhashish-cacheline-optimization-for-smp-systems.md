---
title: "Libhashish Cacheline Optimization for SMP Systems"
date: 2010-07-01T17:06:51+02:00
draft: false
tags: [optimization, cache, smp]
---

Today I spoted some cacheline misses triggered due to some false sharings in
[libhashish](http://libhashish.sf.net)


My CPU model (athlon 64 X2 dual-core) has the following cache and memory structure:
instruction cache, data cache, instruction TLB, data TLB, L2 data TLB, L2
instruction TLB and a unified L2 cache, each core (no shared L3-Cache):



```
L1-DTLB: 4K byte pages, fully associative 32 entries (2M/4M pages: 8 entries)
L1-ITLB: 4K byte pages, fully associative 32 entries (2M/4M pages: 8 entries)

L2 DTLB: 4K byte pages, 4-way associative. 512 entries
L2 ITLB: 4K byte pages, 4-way associative. 512 entries

L2 cache: 512Kb, 16-way associative, 64 byte line size, unified

```

If I illustrate the memory architecture especially the cache structure they
would look like this:


![images/memory-architecture.png](images/memory-architecture.png)
But let us come back to the optimization. If you allocate memory via @malloc()@
your memory allocator guarantee suitably aligned for any kind of data. 8/16 byte
alignment is common value these days. "Any kind of data" is related to
natural data types like int, long double, long long and so on. But this is no
requirement that this must be 8 or even 16. On my x86 based platform an 8 alignment is
also fine: double and long long only requires a 8 alignment. But be warned: SSE,
MMX and the whole SIMD instruction set often require a 16 byte alignment!
@posix\_memalign()@ will help you if your application requires a more
sophisticated alignment. Alignment issues are depends highly on the
architecture. x86 architectures for example can handle unaligned accesses in
hardware, PowerPC not and will raise a SIGBUS. But: it has been shown that
unaligned DMA accesses can be expensive on some architectures like INTEL
Nehalem - it is always good to align these on the natural alignment. I fly off
on a tangent again! ;-)


The main reason I started to write about alignment was to get the correlation
between data type placement and data type placement mapped into the cacheline.
A common technique to optimize cache performance - especially in hot paths in
the kernel - is to align data structures at cache line boundaries in memory.


Main intention is to arrange program code that frequently fetch data structures
to fit nicely within a cache line and not anywhere in the cachline. As an
example consider the following structure (derived from
include/net/inet\_hashtables.h, not the best example because here the alignment
is forced to avoid SMP/CMP false sharing but I hope the example make the basic
mechanism clearer):



```
#define INET\_LHTABLE\_SIZE 32
struct inet\_hashinfo {
  struct inet\_ehash\_bucket \*ehash;
  spinlock\_t \*ehash\_locks;
  unsigned int ehash\_mask;
  unsigned int ehash\_locks\_mask;
  struct inet\_bind\_hashbucket \*bhash;
  unsigned int bhash\_size;
  /\* 4 bytes hole on 64 bit \*/
  struct kmem\_cache \*bind\_bucket\_cachep;
  struct inet\_listen\_hashbucket listening\_hash[INET\_LHTABLE\_SIZE]
    \_\_\_\_cacheline\_aligned;
  atomic\_t bsockets;

```

In include/linux/cache.h and some other architecture specific header files
the following macros are defined:



```
/\* CONFIG\_X86\_L1\_CACHE\_SHIFT=6 -> 64 byte alignment for my configuration \*/
define L1\_CACHE\_SHIFT  (CONFIG\_X86\_L1\_CACHE\_SHIFT)
define L1\_CACHE\_BYTES  (1 << L1\_CACHE\_SHIFT)
#define \_\_\_\_cacheline\_aligned \_\_attribute\_\_((\_\_aligned\_\_(SMP\_CACHE\_BYTES)))

```

So listening\_hash is alignment at a 64 byte boundary, each element! Now we
will consider struct inet\_listen\_hashbucket more deeply:



```
struct inet\_listen\_hashbucket {
   spinlock\_t              lock;
   struct hlist\_nulls\_head head;
};

```

Now just imagine that @struct inet\_listen\_hashbucket@ has some more values, like int's,
double's and so on. Think about a program and the access pattern. The typical
flow will be a index into the listening\_hash array, get the structure (via lea
instruction) and read/write the elements of @inet\_listen\_hashbucket@. The
following image illustrates the memory layout of these structure with and
without alignment:


![images/alignment.png](images/alignment.png)
The above illustration show an unaligned alignment. It is easy spotable that if
Struct 1 is accesses is is possible that two memory loads are necessary.
Especially if the first memory load access the data elements in the beginning
there another access tries to get data from the end of the structure.


The lower illustration show the aligned data structure. Each structure fits in
their own cacheline and no additional L2 or even main memory load is required!
An important aspect is also spotable: you will eventually waste valuable cache
if you align each structure and this can be worse! Think about the size of the
structure and the 64 byte cacheline. If the structure is a multiple of 64
byte you are a lucky guy, but everything else will punch big holes into your
cache.


As smaller the data structure is this optimization becomes nonsense. Because the
probability that everything is already in the cacheline (cause through the
first read/write) is high. Furthermore, if the structure is really big, it is
often superior to restructure the elements so that often accesses variables are
close together where not so often touched variables are at the end of the
structure. To separate read-only variables from write-often variables is also a
nice optimization, especially on SMP/CMP systems. Nowadays alignment and cache
issues hurt performance especially for SMP/CMP systems - but this topic is for
an additional posting.


I reticent the fact that each structure has is own alignment too. So it is also
highly unlikely that the structure is aligned as illustrated in the above
image. Normally their will be wholes between the structures, but at maximum 7
byte wholes nowadays.


BTW: is cache line one word? I mixed it in this posting to reduce the error count! ;-)


UPDATE: lstopo(1) from the hwloc package provides a way to visualize the cache and memory
hierarchy. It parses sys/devices/system/cpu/cpu1/cache/\* and
sys/devices/system/cpu/cpu0/topology/\*. Another useful utility is x86info(1).


