---
title: "Mencoder Video Editing"
date: 2010-07-29T18:12:02+02:00
draft: false
---

Today it was a lazy evening: no productive hacking, no deeper technical
discussions, no email answer sessions, no peer reviews, nothing -- just passive reading
and ... command-line video editing -- vacation for the brain.


Sometimes I am to cushy to use my
camcorder or my "EOS 7D":<http://www.dpreview.com/previews/canoneos7d/>
to make a film. Instead I use my handy "Canon IXUS":<http://www.canon.co.uk/for_home/product_finder/cameras/digital_camera/ixus/digital_ixus_100_is/index.asp>
and shoot some pictures, one after another. Later on at home I use "mencoder":<http://www.mplayerhq.hu/> to
stick these single frames together, add some music and voilà.


"Mencoder":<http://www.mplayerhq.hu/> is a command line tool and I use the following options to generate the
movie. After same experience with "vimeo":<http://www.vimeo.com/> I think these settings are suitable.
But hey, I am no multimedia guru ... ;-)


<pre>
opt="vbitrate=2160000:mbd=2:keyint=132:vqblur=1.0:cmp=2:subcmp=2:dia=2:mv0:last\_pred=3"
mencoder mf://\*.JPG -mf w=1920:h=1440:fps=1.5:type=jpg -ovc lavc -lavcopts vcodec=msmpeg4v2:vpass=1:$opt -oac copy -o /dev/null
mencoder mf://\*.JPG -mf w=1920:h=1440:fps=1.5:type=jpg -ovc lavc -lavcopts vcodec=msmpeg4v2:vpass=2:$opt -oac copy -o output.avi


# add an mp3
mencoder output.avi -o out.avi -ovc copy -oac copy -audiofile ~/travel.mp3


# generate index, this enables the possibility to play the video without waiting
# until the video is fully loaded - vimeo requires this
mencoder -idx out.avi -ovc copy -oac copy -o final.avi
</pre>


The created video can be found on vimeo: "Thailand Climbing Trip - 2010":<http://vimeo.com/13719644>


It is already 3am, time to go to bed.


