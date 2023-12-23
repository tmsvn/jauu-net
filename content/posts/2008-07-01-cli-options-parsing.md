---
title: "CLI options parsing"
date: 2008-07-01T20:01:28+02:00
draft: false
---

I reworked the netsend commandline parsing code. It now support a more network
specific user input. See the following screenshot for netsend help:



```
Usage: netsend [OPTIONS] PROTOCOL MODE { COMMAND | HELP }
OPTIONS := { -T FORMAT | -6 | -4 | -n | -d | -r RTTPROBE | -P SCHED-POLICY | -N level
-m MEM-ADVISORY | -V[version] | -v[erbose] LEVEL | -h[elp] | -a[ll-options] }
PROTOCOL := { tcp | udp | dccp | tipc | sctp | udplite }
MODE := { receive | transmit }
FORMAT := { human | machine }
RTTPROBE := { 10n,10d,10m,10f }
MEM-ADVISORY := { normal | sequential | random | willneed | dontneed | noreuse }
SCHED-POLICY := { sched_rr | sched_fifo | sched_batch | sched_other } priority
LEVEL := { quitscent | gentle | loudish | stressful }

```

