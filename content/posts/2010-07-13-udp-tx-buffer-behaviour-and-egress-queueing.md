---
title: "UDP TX Buffer Behaviour and Egress Queueing"
date: 2010-07-13T17:29:12+02:00
draft: false
tags: [networking, udp]
---

UDP sockets - if corking is disabled - always push packets directly to the
lower layers. In the case of IPv4, @ip\_output()@ will forward the packet to
Netfilter where the firewall rules are applied. @ip\_finish\_output()@ calls
@ip\_finish\_output2()@ which on his part calls neigh\_hh\_output() which put the
cached layer 2 Ethernet header in front of skb and finally call
@dev\_queue\_xmit()@.


@dev\_queue\_xmit()@ queues the packet in the local egress queue - default
is a FIFO queue (@pfifo\_fast@) but sophisticated queuing strategies are available and often selected.
Before the actual packet is enqueued the function dev\_queue\_xmit()
linearize the skb if necessary, do checksumming if necessary, and
finally calls @enqueue()@ which places the packet into the queue. This
function fails if the queue is (temporarily) deactivated or a overflow
happens. In the common cases the function returns NET\_XMIT\_SUCCESS. Note
that the standard queue has a short cut: if the queue length is 0 - no
packet is queued - the packet is directly scheduled via @sch\_direct\_xmit()@.
If something goes wrong (somewhere in the driver), the packet is
pushed several times to the NIC put on the wire via qdisc\_restart() until the
NIC accepts the new packet. If this fails the one element queue is saved
and a SOFTIRQ is raised on the local CPU. In the hope that next time the
SOFTIRQ is executed the NIC is in the ability to accept the packet.


If the queue supports no short cut or the queue contains at least one
element the packet must be enqueued via qdisc\_enqueue\_root(). This enqueue
function is scheduler specific. For FIFO queueing the packet is added at
the end of the list, more complicated queues implement a more sophisticated queueing.



```
dev\_queue\_xmit() {
    netif\_needs\_gso();
    skb\_needs\_linearize();
    if (q->enqueue) {
        if (TCQ\_F\_CAN\_BYPASS && qdisc\_qlen(q) == 0) {
            if (sch\_direct\_xmit())
                \_\_qdisc\_run(q);
            return NET\_XMIT\_SUCCESS;
        } else {
            ret = qdisc\_enqueue\_root()
            qdisc\_run(q);
            return ret;
        }
    }
}

```


```
\_\_qdisc\_run() {
    while (qdisc\_restart()) {
        if (need\_resched() || to\_often\_restarted) {
            raise\_softirq\_irqoff(NET\_TX\_SOFTIRQ);
        }
    }
}

```

@qdisc\_restart()@ try to call @dev\_hard\_start\_xmit()@ instantly to put the
packet on the NIC TX descriptor ring - if possible. @\_\_qdisc\_run()@ enabled
the SOFTIRQ - if not already enabled.


Finally note that the return code of @dev\_queue\_xmit()@ make no statement if
the packet can be transmitted. Subsequent congestion or the queue policy can
decide to drop the packet. A positive return code only signals that the
enqueuing was successful.


IPv6 is similar except that neighbor resolution is done by IPv6 neighbor
discovery mechanism (ND).


Last but not least some network devices have no associated queues. The
loopback device and all kind of pseudo tunnel devices are common examples.
These devices have no queues and instead of placing the packet in a queue the
function @dev\_hard\_start\_xmit()@ is called directly.


