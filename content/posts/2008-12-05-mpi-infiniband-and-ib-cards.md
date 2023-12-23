---
title: "MPI, Infiniband and IB cards"
date: 2008-12-05T21:38:02+02:00
draft: false
---

Normally you should interconnect cluster nodes via links with a short delay
characteristic. For this purpose protocols like infiniband or IB cards are
invented. OpenMPI's default assumption is that nodes are connected in this
manner. Therefore, if someone use other link interconnects (like GigE or local
CMP/SMP work mode) the openmpi warns about that circumstance.


If you want to shut up mpi messages call your program with "--mca btl
^udapl,openib" as an argument to mpirun:



```
mpirun --np 4 --mca btl \^udapl,openib build/debug/examples/adhoc-olsr

```

