---
title: "Genetic Algorithm Search Algorithm for Complex Problems"
date: 2010-10-14T21:19:26+02:00
draft: false
---

Several month ago I spend some months to analyse the behaviour of Genetic
Algorithms. The research focused on mutation, selection and crossover
algorithms and their behaviour. Genetic Algorithms are probabilistic search
heuristics that emulate the process of evolution. Problem domains for
genetic algorithms are complex scheduling problems (e.g. flight scheduling
at the airport), Protein structure prediction or academic problems like
traveling salesman problem. Genetic algorithms are useful where other
search algorithms collapse through an almost infinite solution space.


![images/ga-sequence.png](images/ga-sequence.png)
People not familiar with complex search problems of this kind should
imagine a graph where the task is to find the minimum of the function. The
naive approach to scan the graph from start till end and remember the
smallest value will result in a solution - no doubt. At the end of the
process the result is the minimum of the function. Now imagine that the
graph is not two dimensional (x and y), but rather a three or even
n-dimensional problem. The naive approach to scan each section is simple
far too much. Genetic algorithms will spread his probe-points, check if a
pre-defined minimum is found and if not the probe-points are new-adjusted.
Adjusted through mutation, selection and crossover with other
probe-points. One major characteristic is that superior probe-points are
favored (superior probe-points in our example will have the smaller value
- because we are searching for the minimum in a n-dimension solution
space) in the process of crossover. The idea is that mutation from a
good and a good parent probe-point will finally result in the
superior solution - hopefully.


[genetic-algorithm.pdf](http://blog.jauu.net/2010/10/14/Genetic-Algorithm---Search-Algorithm-for-Complex-Problems/genetic-algorithm-summary.pdf) present focus on the Recombination and Mutation alternatives. Whose impact on the algorithm and some other often
underrated conditions.


All used and cited code is licenced under the GPLv2, see [git.jauu.net](http://git.jauu.net)


