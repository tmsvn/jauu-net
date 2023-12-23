---
title: "Migration to Cloudflare & Hugo"
date: 2023-05-16T15:21:21+02:00
draft: false
toc: false
# description: "Description"
editPost:
    URL: "https://github.com/hgn/jauu-net/content"
    Text: "Suggest Changes" # edit text
    appendFilePath: true # to append file path to Edit link
hideSummary: false
ShowRssButtonInSectionTermList: true
---

After some years of non-maintenance I had to modernize the web stack to some
degree. Some scripts doesn't work anymore and so on. This is precisely why I
have decided to fundamentally modernise my web hosting. I'm saying goodbye to
Jekyll and Google Hosting and welcoming Hugo in conjunction with Cloudflare.

I realised the need for this change when I realised that my website, although
up-to-date and relevant in terms of content, was lagging behind
technologically. A key concern was the implementation of TLS (HTTPS) to ensure
a secure and encrypted connection for visitors to my website. In our
increasingly security-conscious digital landscape, this is no longer an option,
but a necessity.

I used to build the website data locally and transfer it to the server via scp.
This process was cumbersome and inefficient. My goal was to simplify updating
the website so that a simple Git push triggers all the necessary steps -
cloudflare is great here.

The decision was made in favour of Cloudflare, which now supports QUIC for
websites. This switch provided the perfect opportunity not only to change
hosting, but also to update the website generator. Hugo, known for its speed
and multilingualism, was the ideal choice. Multilingualism is a feature I
didn't want to do without.

However, the switch to Hugo was not technically easy and it was not possible to
migrate all the older pages. However, most of the content is available in the
Internet archive and accessible to interested parties.

By combining Hugo and Cloudflare, I now benefit from low latency, fast content
delivery through HTTP/3 (QUIC), HTTP/2 (TCP) and comprehensive IPv4 and IPv6
support. This ensures that my website is not only secure and up-to-date, but
also quickly and reliably accessible to visitors worldwide.

Modernising my web hosting is a step towards keeping up with technological
developments and providing a high quality, secure and fast online presence.
It's an exciting new chapter and I'm looking forward to seeing how it develops.
