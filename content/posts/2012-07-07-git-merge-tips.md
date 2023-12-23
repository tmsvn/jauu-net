---
title: "Git Merge Tips"
date: 2012-07-07T19:35:17+02:00
draft: false
---

I use git nearly since the beginning as BitKeeper was replaced by Linus. This
was in 2005. In the early days git was hard and cumberstone to use. The
low-plumbing-level made it really hard and unintuitive. Wrapper tools like
cogito provide the essential usability. E.g. back in the days instead of git pull
you have to type git fetch and git merge and the like. It was hard to
remember all the commands to get versioning done.


But said that: I still learn and improve my git skills. So here are some
(maintainer) tips:



```
# after pulling a branch from someone
git shortlog ORIG_HEAD..
# or
git diff --stat --summary ORIG_HEAD..
# will show what goes in. Or even more verbose:
git log -p --reverse ORIG_HEAD..

# if the pull was crap, simple type
git reset --hard ORIG_HEAD

# if you have local changes, and you
# dont want to lose these:
git reset --keep ORIG_HEAD

# if you merge a lot maybe the next command
# is helpful:
gitk HEAD...MERGE_HEAD <path>
# Similar to: gitk --merge  <path>
# This provides history of the path on bath branches
# It helps to see what happens in one path if there
# was a name change and a bug fix on the other branch

```

