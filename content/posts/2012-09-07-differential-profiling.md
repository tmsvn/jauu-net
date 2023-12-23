---
title: "Differential Profiling"
date: 2012-09-07T17:33:18+02:00
draft: false
tags: [perf]
---

Just for the statistical guys reading my blog: Jiri Olsa posted a patch today to extend perf diff to show differential profiling. Perf diff now support three diff computations:


* delta: the current default one
* ratio: ratio differential profile
* wdiff: weighted differential profile


The idea goes back to Paul E. McKenney and his paper [Differential Profiling](http://www2.rdrop.com/users/paulmck/scalability/paper/profiling.2002.06.04.pdf). Nice reading!


