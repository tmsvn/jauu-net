---
title: "Netsend TCP Options"
date: 2008-10-02T12:27:46+02:00
draft: false
tags: [networking, netsend]
---

Because of massive flaming I reintroduced the TCP Option to netsend again.
But this time not via the normal commandline options (this SHOULD be implemented as well), in opposite I introduced
a new option "-O ". The "O" option (like Output) is introduced to replace the current machine parseable output.


The advantages are clear: the current machine output use a fixed standard format that cannot be reordered or shrinked because of backward compatibility. The new O option let the user the ability to output only requested values.
The output is more easy to parse for gnuplot (e.g.) and also to replace the human output because the user can focus
on the really interesting values. Examples? NULL problemo:



```
while true; do ./netsend tcp rec;done &
  ./netsend -O "%n bytes transmitted/received in %t seconds\n" tcp t file localhost
  ./netsend -O "ECN: %Te SACK: %Ts" tcp t /etc/Muttrc localhost

```

