---
title: "mlockall versus Latency"
date: 2008-05-04T20:53:34+02:00
draft: false
tags: [realtime, latency, mlockall]
---

New measurements for the mentioned, increased latency if you lock pages
physically. As you can see, the violet line (without memory locking) reflect a
superior latency behavior (lesser is better).


On the other side, there is one negative peek with mlockall() - but it
shouldn't. After all: mlockall() prevent worst case scenario - the principal
task for real-time application. On the other hand, it introduces a small
overhead - but why? More kernel studies needed!


![images/mlockall-versus-Latency.png](images/mlockall-versus-Latency.png)
