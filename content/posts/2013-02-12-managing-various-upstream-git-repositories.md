---
title: "Managing various upstream Git Repositories"
date: 2013-02-12T13:34:07+02:00
draft: false
tags: [git]
---

I track some Linux kernel development subsystems: Linus, perf, network
(davem's) net-next and lkvm. Additionally I add two historic Linux
repositories: Thomas post 2.4 tree and davej's pre 2.4 branch. In the earlier
git days I referenced cloned locally. Later I started to add remotes within one
repository. To setup this environment the following commands may be helpful:



```
# create a vanilla git container
mkdir linux; cd linux
git init

# add remotes
git remote add --track torvalds git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
git remote add --track net-next git://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git
git remote add --track mingo git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git
git remote add --track kvm-tool git://github.com/penberg/linux-kvm.git
# historic branches desired?
# git remote add --track post-2.4 git://git.kernel.org/pub/scm/linux/kernel/git/tglx/history.git
# git remote add --track pre-2.4 git://git.kernel.org/pub/scm/linux/kernel/git/davej/history.git

# update all remotes
git remote update

git checkout --track -b origin-torvalds-master remotes/torvalds/master
git checkout --track -b origin-mingo-perf-core remotes/mingo/perf/core
git checkout --track -b origin-net-next-master remotes/net-next/master
git checkout --track -b origin-kvm-tool-master remotes/kvm-tool/master

```

See the branch naming of the remotes: all starts with origin. This is my common
prefix to handle remote tracking branches and local branches. Furthermore, I
also have two (git.jauu.net as primary git master and github as a backup) under
control. To differentiate these both I prefix these branches with github and
jauu.


The master branch is empty. This is ok, the one and only problem is that gitweb
and friends will always start to present the master tree.


It is also possible to connect the historic branches into one coherent whole.
See the following command. But note: if you never or seldom use the historic
archive you may prefer a seperate referenced cloned repository! With historic
roots the repository is really large - which slows down day to day development.
A seperate repository, cloned via reference is a optimal compromiss. Git
operations are fast in the normal repository and because the referenced clone
do not comsume additional memory (at least not that much) because hard links
are used.



```
cat .git/info/grafts
1da177e4c3f41524e886b7f1b8a0c1fc7321cac2 e7e173af42dbf37b1d946f9ee00219cb3b2bea6a
7a2deb32924142696b8174cdf9b38cd72a11fc96 379a6be1eedb84ae0d476afbc4b4070383681178
$

```

The following two aliases are really helpful to cope with remote branches:



```
lu = log ..@{upstream}
ft = merge --ff-only @{upstream}

```

You start by calling git remote update to update all remotes. Then git lu will
show you all changes made upstream and git ft finally will integrate this
tracking branch if a fast forwarding is possible.


If you're not sure about the current status of your branches and what they are
tracking, simply use git branch -vv


Add own remotes where other can pull and as a backup service. Push local
branches to github are easily done by: git push github torvalds-epoll-exclusive



```
git remote add github git@github.com:hgn/linux.git

```

If your are behind a proxy you can add proxy setting:



```
export http_proxy='http://username:password@proxy.local:80'

```

