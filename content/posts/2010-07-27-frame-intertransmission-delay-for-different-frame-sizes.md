---
title: "Frame Intertransmission Delay for Different Frame Sizes"
date: 2010-07-27T13:20:08+02:00
draft: false
---

For some analysis I plotted the inter-frame delay in microseconds within
the transmitter must send a frame to archive the desired transmission rate. For
a 10Gbit network adapter and a 10 byte frame the time between subsequent
transmission must be 0.008 microseconds (or 8 nanoseconds or 8e^-09^ seconds)
The illustration with a logarithmic y scale:


![images/intertrans.png](images/intertrans.png)
Not really thrilling or exciting, I generated the images to illustrate the
difficulties to generate a bandwidth exact bytestream where the operating
system as well as hardware components are working at the edge.


