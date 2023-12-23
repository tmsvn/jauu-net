---
title: "Initial Perf Loop Detection"
date: 2012-05-01T13:03:27+02:00
draft: false
tags: [perf, linux]
---

Arnaldo started to implement initial loop detection in the perf annotate
browser. The idea is (was) that backward jumps are mode visible. Currently
forward jumps are displayed with some UNICODE character (libslang?):



```
 0,00 │        test   %eax,%eax
 0,00 │      ↓ je     bc
 0,00 │        cmpl   $0x0,0x4ca034(%rip)        # ffffffff81aacb80 <debug\_locks\_silent>
 0,00 │      ↓ jne    bc
 0,00 │        mov    $0xbf4,%esi
 0,00 │        mov    $0xffffffff818039ac,%rdi
 0,00 │        callq  warn\_slowpath\_null
 0,00 │      ↓ jmp    bc
12,90 │   53:  mov    %gs:0xb760,%rax
 4,15 │        add    %ebx,-0x1fbc(%rax)
 0,00 │        test   %edx,%edx
 0,00 │      ↓ jne    92
 3,69 │        cmpb   $0xf4,-0x1fbc(%rax)
 0,00 │      ↓ jbe    92
 0,00 │        callq  debug\_locks\_off
 0,00 │        test   %eax,%eax
 0,00 │      ↓ je     92
 0,00 │        cmpl   $0x0,0x4c9ff3(%rip)        # ffffffff81aacb80 <debug\_locks\_silent>
 0,00 │      ↓ jne    92
 0,00 │        mov    $0xbfd,%esi
 0,00 │        mov    $0xffffffff818039ac,%rdi
 0,00 │        callq  warn\_slowpath\_null

```

The currently algorithm illustrated in the image use a simple heuritic to show
jumps that points to before the cursor. The idea was to extend this by try to
guess loop constructs. To detect loops, you may want to look for a compare
followed by a backwards conditional jump for example. But this may not be true
at all! A backwards jump does not necessary implies a loop. Backward jumps can
be the reverse of loops.


![images/perf-loop-detection.png](images/perf-loop-detection.png)
For example it can be somethink like this:



```
        while (23) {
                if (!(ac += 1)) goto out1;
                if (!(ac + 1)) goto out2;
                if (ac) ac += 1;
                if (ac + 1) break;
        }

      return 0;
out1: return 23;
out2: return 34;

```


```
4004a2: 83 45 fc 01           addl   $0x1,-0x4(%rbp)
4004a6: 83 7d fc 00           cmpl   $0x0,-0x4(%rbp)
4004aa: 74 1e                 je     4004ca <main+0x36>
4004ac: 83 7d fc ff           cmpl   $0xffffffff,-0x4(%rbp)
4004b0: 74 20                 je     4004d2 <main+0x3e>
4004b2: 83 7d fc 00           cmpl   $0x0,-0x4(%rbp)
4004b6: 74 04                 je     4004bc <main+0x28>
4004b8: 83 45 fc 01           addl   $0x1,-0x4(%rbp)
4004bc: 83 7d fc ff           cmpl   $0xffffffff,-0x4(%rbp)
4004c0: 74 df                 je     4004a1 <main+0xd>
4004c2: 90                    nop
4004c3: b8 00 00 00 00        mov    $0x0,%eax
4004c8: eb 0e                 jmp    4004d8 <main+0x44>
4004ca: 90                    nop
4004cb: b8 17 00 00 00        mov    $0x17,%eax
4004d0: eb 06                 jmp    4004d8 <main+0x44>
4004d2: 90                    nop
4004d3: b8 22 00 00 00        mov    $0x22,%eax
4004d8: 5d                    pop    %rbp
4004d9: c3                    retq

```

So because it is not that simple to detect loops Arnaldo currently skips loop
detection algorithm. But who knows ... To use the new features you must clone from Arnaldos tree:



```
$ git remote add acme git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux
$ git checkout -b perf/annotate acme/perf/annotate
$ mkdir /tmp/perf
$ make O=/tmp/perf -C tools/perf install
$ /tmp/perf/perf top

```

