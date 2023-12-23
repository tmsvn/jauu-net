---
title: "Staging WTF"
date: 2011-03-06T21:07:00+02:00
draft: false
---


```
[...]
        len = dwrq->length;
        ext = \_malloc(len);
-       if (!\_malloc(len))
+       if (!ext)
                return -ENOMEM;
        if (copy\_from\_user(ext, dwrq->pointer, len)) {
                kfree(ext);
[...]

```

