---
title: "BPF Opcode Analysis"
date: 2010-06-08T18:24:51+02:00
draft: false
---

The following paragraphs explain the correlation between filter rules provided
by any PCAP based filter program, the resulting intermediate OPCODE
representation and the kernel side interpretation. The most brilliant logic
within PCAP is not the sniffing functionality nor the dump file format, it is
rather the optimization logic. To eliminate useless calculations, to generate
efficient instruction, to skip possible IPv4 options, jump over IPv6
extension headers and so on. At the same time the optimizer must be able to
eliminate useless/duplicate expressions like "IP AND IP" (this is the most
trivial example, but it can be quite complex).


Processing Sequence for some common filter expressions



No Expression
-------------


A stub filter return immediately by processing BPF\_RET|BPF\_K and returning
fentry->k Where fentry->k is the requested packet length in bytes. You will
see this expression in nearly all subsequent filter.




IP Expression
-------------


* taken (ICMP generator)
	+ BPF\_LD|BPF\_H|BPF\_ABS
	+ BPF\_JMP|BPF\_JEQ|BPF\_K
	+ BPF\_RET|BPF\_K




ICMP Expression
---------------


* taken (ICMP generator)
	+ BPF\_LD|BPF\_H|BPF\_ABS
	+ BPF\_JMP|BPF\_JEQ|BPF\_K
	+ BPF\_LD|BPF\_B|BPF\_ABS
	+ BPF\_JMP|BPF\_JEQ|BPF\_K
	+ BPF\_RET|BPF\_K
* not taken (IPv6/ICMP generator)
	+ BPF\_LD|BPF\_H|BPF\_ABS
	+ BPF\_JMP|BPF\_JEQ|BPF\_K
	+ BPF\_RET|BPF\_K




TCP Expression
--------------


* taken (TCP generator)
	+ BPF\_LD|BPF\_H|BPF\_ABS
	+ BPF\_JMP|BPF\_JEQ|BPF\_K
	+ BPF\_JMP|BPF\_JEQ|BPF\_K
	+ BPF\_LD|BPF\_B|BPF\_ABS
	+ BPF\_JMP|BPF\_JEQ|BPF\_K
	+ BPF\_RET|BPF\_K
* not taken (ICMP generator)
	+ BPF\_LD|BPF\_H|BPF\_ABS
	+ BPF\_JMP|BPF\_JEQ|BPF\_K
	+ BPF\_JMP|BPF\_JEQ|BPF\_K
	+ BPF\_LD|BPF\_B|BPF\_ABS
	+ BPF\_JMP|BPF\_JEQ|BPF\_K
	+ BPF\_RET|BPF\_K




UDP Expression
--------------


* not taken (ICMP generator)
	+ BPF\_LD|BPF\_H|BPF\_ABS
	+ BPF\_JMP|BPF\_JEQ|BPF\_K
	+ BPF\_JMP|BPF\_JEQ|BPF\_K
	+ BPF\_LD|BPF\_B|BPF\_ABS
	+ BPF\_JMP|BPF\_JEQ|BPF\_K
	+ BPF\_RET|BPF\_K




Conclusions
-----------


There are several possibilities to optimize the generated BPF filter especially
in coherence with the kernel interpreter. Next step is to analyse the cache
line behavior and try to align the structure for the common case and reduce
memory loads.



