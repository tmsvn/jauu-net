---
title: "Hash Library Locked Now Thread Clean"
date: 2008-07-12T17:31:45+02:00
draft: false
---

Libhashish is a hash library for UNIX witch support nearly all functionality
seen in other hash table implementations. Furthermore, libhashish implement a
lot of different ideas beside the normal hash list chaining strategy. It
implement array chaining, list and array chaining with reordering functionality
(most often referred elements first) and double key hashing (to lower O(n)
complexity in the hash key compare function (normally strcmp()).


Yesterday I added mutex lock support so that the library is now thread clean!


