---
title: "SIMD++, SSE4 and SIMD16"
date: 2008-04-26T16:00:27+02:00
draft: false
---

The SSE4 programming reference is out - a opportunity to study the
improvements.


Besides 47 (plus 7 additional for the nehalem microarchitecture) new
instructions which mainly focus on multimedia acceleration. MPSADBW (Sum of
Absolute Differences), PHMINPOSUW Minimum Search (find minimum uint16\_t from
eight elements) (if you invite the source you had an fast max() ;-), ROUND
(round floating point types) and other instructions too.


Dot product matrix calculation, load hint instruction (MOVNTDQA) to store
aligned data in a small data-set, packed integer format conversions (convert in
wider data types), IEEE 754 Compliance operations.


A nice giveaway are also the string instructions:


* max 16byte
* explicit length declaration or NULL termination
* string compare function support PCMPxSTRx)
* strlen()


The nehalem microarchitecture also support:


* CRC32
* POPCNT - for searching bit pattern


Recently I read a paper about the increased register width of 512bit for SIMD
instructions (called SIMD16). More direct addressable register are also
planned. Intel will introduce themin Larrabee.


