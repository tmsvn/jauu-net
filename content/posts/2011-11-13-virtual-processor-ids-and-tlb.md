---
title: "Virtual Processor IDs and TLB"
date: 2011-11-13T20:26:02+02:00
draft: false
tags: [tlb]
---

The translation lookaside buffer is a high-speed memory page cache for virtual
to physical address translation. It follows the local principle to avoid time
consuming lookups for recently used pages. But what happened in a virtual
environment (e.g. kvm, xen, vmware)? Host mappings are not coherent to the guest
and vice versa. Each guest has it's own address space, the mapping table cannot
be re-used in another guest (or host). Therefore first generation VMs like
Intel Core 2 (VMX) flush the TLB on each vm-enter (resume) and vm-exit. But
flushing the TLB is a show-stopper, it is one of the most critical components
in a modern CPU. The relevant code for Linux is located under
arch/x86/kvm/x86.c:vcpu\_enter\_guest().


But Intel engineers started to think about that. Intel Nehalem TLB entries have
changed by introducing a Virtual Processor ID. So each TLB entry is tagged with
this ID. VPID's are not specified by the CPU, they are allocated by the
hypervisor whereas the host VPID is 0. Starting with Intel Nehalem the TLB
must not be flushed. When a process tries to access a mapping where the actual
VPID does not match with the TLB entry VPID a standard TLB miss occur. Some
Intel numbers show that the latency performance gain is 40% for a VM round trip
transition compared to Meron, a Intel Core 2.


Current Kernel (at least e56c57d0d3fdb from net-next) provides no VIDS for
nested VM's. This is no limitation of Intel's concept
(arch/x86/kvm/vmx.c:prepare\_vmcs02()). It is rather a proof that nested VMs
are not in wide-use and nobody seems to miss that behavior.


