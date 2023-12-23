---
title: "L7 Filter IRC"
date: 2010-06-18T17:27:58+02:00
draft: false
---


```
(17:17) < fw> pakete kriegt das ding via libnetfilter_queue, was prinzipiell schon richtig ist
(17:18) < fw> Typische loesung ist, nur "noch-nicht-klassifiziert" pakete zu queuen, und nach sagen wir 4k aufhoeren
(17:18) <hgn> das wird eine baumstruktur
(17:19) < fw> so sollte es sein
(17:19) <hgn> genau
(17:19) < fw> aber fuer l7filter sind alle pakete gleich, und alle pattern auch
(17:19) < fw> und das ist schlecht[tm]
(17:19) <hgn> ok
(17:19) <hgn> das ist wirklich schlecht
(17:19) < fw> und es ist c++ ;)

```

