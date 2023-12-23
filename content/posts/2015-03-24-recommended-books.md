---
date: 2015-03-24T12:39:22+02:00
title: "Book Recommendations"
draft: false
tags: [linux, programming]
---


From time to time students ask me for book recommendations. Subsequently my
personal top five(+/-) lists for each category (a little bit Linux (kernel) and
C biased). I believe these are the books you should read when you are
interested in one particular topic:

#### Computer Architecture ####
- **Processor Microarchitecture: An Implementation Perspective**; *Antonio
	Gonzalez and Fernando Latorre and Grigorios Magklis*; The title says it all!
	A book you should probably read after you read all other books in this
	section. [Alexei Starovoitov](https://twitter.com/alexei_ast) suggested this
	book lately and after reading it I must say it is worth every penny.
- **Inside the Machine**; *Jon Stokes*; For readers not yet familiar with
	registers, pipelining or superscalar architectures. If you want to
	understand how modern CPUs are designed you should start with this book.
	Furthermore: easy to read!
- **Is Parallel Programming Hard, And, If So, What Can You Do About It?**; *Paul
	McKenney*; What about this book? It is written from Paul - this should be
	enough. Everyone not knowing Paul: he is just the brilliant guy contributing
	the most advanced locking mechanism for the Linux Kernel since a long time.
	Paul collected all his synchronization knowledge in one 500 page book:
	locking, RCU, memory barriers, atomic operations, transactional memory and
	many more.  If you read this book and able to answer all "Quick Quizzes" you
	can call youself a master of synchronization or Paul2! ;-) And, Paul publish
	his knowledge for free:
	[perfbook](https://www.kernel.org/pub/linux/kernel/people/paulmck/perfbook/perfbook.html)
- **UNIX Systems for Modern Architectures: Symmetric Multiprocessing and
	Caching for Kernel Programmers**, *Curt Schimmel*, A book about SMP systems
	with focus on cache strategies: cache lines, physical and virtual addressed
	cache lines, memory models, ...
- **What Every Programmer Should Know About Memory**, *Ulrich Drepper*, Ulrich
	wrote this freely available PDF in 2007 but it is still one of the
	best publication about memory and caches from a programmers perspective. I
	mirrored the [PDF locally](../../../../talks/data/cpumemory.pdf) cause it
	seems the paper "start to disappear from the Internet".
- **Intel 64 and IA-32 Architectures Software Developer's Manuals**, *Intel*,
	Let's say it in this way: if your knowledge is below a specific threshold
	this manual seems complicated and only a few sections are understandable. But
	the higher your knowledge is the more you will look in this manual. The last
	open questions you have may be answered there!
- **The Unabridged Pentium 4: IA32 Processor Genealogy**, *Tom Shanley*, A huge
	book about all bits and peaces of a Pentium 4 - a compendium. Anyway, if your
	budget is limited you can skip this one.


#### C Programming under Linux/Unix ####
- **The Linux Programming Interface**; *Michael Kerrisk*; Treated as the "new
	Stevens", yes this is what I heard. If your are a fresh Linux System
	programmer or an old-timer: this book provides up-to-date and detailed
	information about Linux Programming Interface. The book is written by Michael
	Kerrisk, the person who maintains the Linux man pages. In other words: if
	there is one guy out there knowing all syscalls and how to use them correctly - then
	it is probably Michael!
- **Advanced Programming in the UNIX Environment**, W. Richard Stevens and Stephen A. Rago
- **Hackers Delight**, Henry S. Warren
- **Optimizing Compilers for Modern Architectures**, Randy Allen und John R. Allen

#### Network Programming ####
- **Unix Network Programming: The Sockets Networking API**,  W. Richard Stevens and Bill Fenner and Andrew M. Rudoff 
- **Network Programming with Perl**, Lincoln D. Stein

#### Network Protocols ####
- **TCP/IP Illustrated - Volume 1 and 2**, Richard Stevens
- **Network Algorithmics: An Interdisciplinary Approach to Designing Fast Networked Devices**, George Varghese
- **Network Routing: Algorithms, Protocols, and Architectures**, Deepankar Medhi
- **BGP: Building Reliable Networks with the Border Gateway Protocol**, Iljitsch van Beijnum

#### Linux Kernel and Userspace Programming ####
- **Linux Kernel in a Nutshell**, Greg Kroah-Hartman
- **Linux Device Drivers (3rd Edition) Jonathan Corbet**, Alessandro Rubini and Greg Kroah-Hartman
- **Understanding the Linux Kernel**, Daniel P. Bovet and Marco Cesati
- **Linux Kernel Development**, Robert Love
- **The Design and Implementation of the FreeBSD Operating System**, Marshall Kirk McKusick and George V. Neville-Neil (*FreeBSD but worth to read it - Tip!*)

![Linksys 1900 AC Photo](/posts-data/processor-book-photo.jpg)


  <div class="bs-callout bs-callout-warning">
<h4>Amazon and ePUB's, don't do that!</h4>
<p>
Please, do yourself a favor and do **not** buy your ebooks on Amazon. You don't
get them out of their DRM jail. Usually I use O'Reilly: you can download the
epub, pdf and other formats without any DRM hassle.
</p>
  </div>
