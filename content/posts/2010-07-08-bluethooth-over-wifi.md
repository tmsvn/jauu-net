---
title: "Bluethooth Over WiFi"
date: 2010-07-08T15:45:24+02:00
draft: false
---

Bluetooth (IEEE 802.15.1) is a clean wireless industry standard using the ISM
band (between 2,402 GHz and 2,480 GHz). Version 2.0 + EDR (Enhanced Data Rate)
provides a practical data transfer rate up to 2.1 megabits per second. This
sounds huge compared to Version 1.0 but practical is can be really awkward if
you want to transfer large files.


Version 3 of the core specification add a clever extension to increase the data
rate: it enables the possibility to use the (hopefully available) WiFi link to
transfer data. Bluetooth is still used for device discovery, connection
setting (negotiating, channel establishment) and profile configuration.


As usual for Bluetooth many components are implemented in hardware and the
software core is more or less lightweight. But several v3.0 software details
are required, especially the WiFi interaction. Therefore the Linux Kernel
Bluetooth development is now located under the Wifi components. Of course, this
affect the source code management at first glance. The main development is
still done on netdev.


