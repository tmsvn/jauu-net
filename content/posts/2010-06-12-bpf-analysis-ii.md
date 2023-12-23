---
title: "BPF Analysis II"
date: 2010-06-12T23:27:41+02:00
draft: false
---






| Filter Rule | Processing Time |
| --- |
| no filter | 469.231535129662 us |
| "icmp" | 524.893505343705 us |
| "icmp and host 127.0.0.1" | 367.231761850006 us |
| "icmp and host 127.0.0.1 and 'ip[6] = 64'" | 598.401917125821 us |
| "icmp and host 127.0.0.1 and 'ip[6] = 64' and 'ip[2:2] > 1'" | 649.767235335359 us |


Processing delay sampling (needs smoothing, of course):


![images/bpf-sampling.png](images/bpf-sampling.png)
The generated OPCODES:



icmp
----



```
(000) ldh      [12]
(001) jeq      #0x800           jt 2  jf 5
(002) ldb      [23]
(003) jeq      #0x1             jt 4  jf 5
(004) ret      #65535
(005) ret      #0

```



icmp and host 127.0.0.1
-----------------------



```
(000) ldh      [12]
(001) jeq      #0x800           jt 2  jf 9
(002) ldb      [23]
(003) jeq      #0x1             jt 4  jf 9
(004) ld       [26]
(005) jeq      #0x7f000001      jt 8  jf 6
(006) ld       [30]
(007) jeq      #0x7f000001      jt 8  jf 9
(008) ret      #65535
(009) ret      #0

```



icmp and host 127.0.0.1 and 'ip[6] = 64'
----------------------------------------



```
(000) ldh      [12]
(001) jeq      #0x800           jt 2  jf 11
(002) ldb      [23]
(003) jeq      #0x1             jt 4  jf 11
(004) ld       [26]
(005) jeq      #0x7f000001      jt 8  jf 6
(006) ld       [30]
(007) jeq      #0x7f000001      jt 8  jf 11
(008) ldb      [20]
(009) jeq      #0x40            jt 10 jf 11
(010) ret      #65535
(011) ret      #0

```



icmp and host 127.0.0.1 and 'ip[6] = 64' and 'ip[2:2] > 1'
----------------------------------------------------------



```
(000) ldh      [12]
(001) jeq      #0x800           jt 2  jf 13
(002) ldb      [23]
(003) jeq      #0x1             jt 4  jf 13
(004) ld       [26]
(005) jeq      #0x7f000001      jt 8  jf 6
(006) ld       [30]
(007) jeq      #0x7f000001      jt 8  jf 13
(008) ldb      [20]
(009) jeq      #0x40            jt 10 jf 13
(010) ldh      [16]
(011) jgt      #0x1             jt 12 jf 13
(012) ret      #65535
(013) ret      #0

```


