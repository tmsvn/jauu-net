---
title: "new blog software"
date: 2010-06-03T14:10:21+02:00
draft: false
---

Yesterday as well as today I worked meticulously to build a own blog software.
This post is the first post on a self-hosting basis. In the next couple of days
I will publish the software via git as usual. The technique is simple: blog
posts are written with your editor of choice (e.g. vim), after that the file is
checked into the git repository (database and versioning is done via git) and
after that a simple ruby script generates all html pages (via git post hooks).
Simple, lightweight and functional.


One tiny extension is image recognition. Each blog post have impact on two
pages: the post specific page and the index.html. To link management for image
links is done by textile - path substitution is required.


Anyway, the big blocks are already implemented: html file generation, category
archive, year archive and last but not least RSS feed (xml 2.0) generator.


