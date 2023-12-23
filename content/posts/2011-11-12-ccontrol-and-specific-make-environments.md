---
title: "Ccontrol and Specific Make Environments"
date: 2011-11-12T17:03:26+02:00
draft: false
---

Davem wrote that he sometimes accidentally type make -j 128 on his Intel
platform (btw: davem is Sparc maintainer). Rusty wrote that this was the main
purpose to write ccontrol. A wrapper to control distcc, ccache and make.


Via ccontrol you can configure the current setup for the local machine.
After that you use ccontrol instead of make and ccontrol will use the
configured setting for this environment. A standard configuration, generated
via ccontrol-init on a Dual Core Processor looks like the following
(~/.ccontrol/default):



```
[*]
  cc = /usr/bin
  c++ = /usr/bin
  ld = /usr/bin
  make = /usr/bin
  cpus = 2
  ccache = /usr/bin

```

A envorinment with several distcc hosts may have two additional lines:



```
distcc = /usr/bin/distcc
distcc-hosts = hostname1 hostname2

```

On Debian ccontrol is available as a package: aptitude install ccontrol


