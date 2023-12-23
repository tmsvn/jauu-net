---
title: "Epoll and Select Overhead"
date: 2011-01-23T22:45:54+02:00
draft: false
---

I benchmarked epoll() and select() one more time, this time restricted to
\_one\_ FD which becomes readable. This benchmark reflect therefore the most crucial
possible performance measurement. And which came as no surprise, select()
perform worse. A possible poll() graph should be equal to the select()
graph. But as I said before: I am not interested in poll().


![images/epoll-overhead.png](images/epoll-overhead.png)
