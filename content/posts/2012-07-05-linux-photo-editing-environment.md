---
title: "Linux Photo Editing Environment"
date: 2012-07-05T19:08:08+02:00
draft: false
---

I shoot all my photos in RAW, so my post-processing chain is a little bit more
complicated as shooting in JPEG. Raw photo editing tools under Linux are
nowadays more functional and usable as several years ago. But handling RAW
images is more time consuming as stripped JPEG images. These are the costs
of an increased flexibility. To simplify processing I tried nearly all
professional tools under Linux (this includes scripts based automations). So
here is the list of tools I suggest under Linux. Well, to work with Darktable
you need some training. If you are familiar with Adobe Lightroom you should
feel comfortable with it. If you still save your images as JPEG's you should
consider to ask Google or try the following link: [RAW vs JPEG](http://michaelmistretta.com/2008/raw-vs-jpeg/).


Used Tools:


* Darktable
* Qiv/feh
* Archiving via unison
* Gimp (rarely)
* Luminancehdr (rarely)


Darktable HEAD has now support to convert photos on the command-line, without
invoking the GUI at all:



```
$ darktable-cli <input> <xmp> <output>

```

