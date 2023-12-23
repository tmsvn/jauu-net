---
title: "rdtscll cleanup netsend"
date: 2008-06-12T16:54:32+02:00
draft: false
tags: [optimization, rdtscll]
---

We removed the rdtscll instruction support in netsend:


* userland header files doesn't define the macro anymore (sanitized header files)
* functional aspect is limited (ACPI modes and the increased time/cycle time)
* nobody used it ;-)


