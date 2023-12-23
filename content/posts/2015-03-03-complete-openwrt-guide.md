---
title: "My complete OpenWrt Setup Guide"
date: 2015-03-03T12:39:22+02:00
draft: false
tags: [linux, open-wrt]
---

# Introduction

First off all: this guide is no replacement for the great [OpenWrt
documentation](http://wiki.openwrt.org/start). Rather this
guide show what software I use and how I configure the system. Sure, some
software components smells fishy, the hardware could be better and so on. But
this setup is great and fullfills my requirements and at least do not use any
proprietary components like FritzBox (who want's closed source in the private
network? Do they backport all kernel bugfixes? … to many questions - not an
option for me).

![Linksys 1900 AC Photo](/posts-data/linksys-photo.jpg)


For critics, comments, tips you can contact me via twitter:
[hgnize](https://twitter.com/hgnize) or write an email: hagen@jauu.net (GnuPG
ID: 98350C22, Fingerprint: 490F 557B 6C48 6D7E 5706 2EA2 4A22 8D45 9835 0C22)

This howto is gradually extended, from time to time I will uncover new
sections - stay tuned. Last but not least: I use Linksys WRT 1900 AC router
here. So all WiFi specific configrations are a little bit aligned on this
devices and may not work on other hardware. But the difference should marginal
and should be limited to some wireless performance tweaks.


# <a name="general">General OpenWRT Setup</a>

First thing to do is to flash the original firmware with OpenWRT. I don’t want
to go into the details because they differ from router to router. At the end
you should have an installed and working OpenWRT. I do not install LuCI to
manage the router via web interface. Just ssh’ing into the box is fine.

After installing is done you login via Telnet:

```bash
telnet 192.168.1.1
```

set a new root password relogin via ssh:

```bash
passwd
exit
ssh root@192.168.1.1
```

Telnet should now automatically be disabled if the password is set. Try it and
proof it!
Then you should change hostname and timezone in ```/etc/config/system```. Because I
name all devices like galaxies, cluster and superclusters this system is named
[laniakea](https://en.wikipedia.org/wiki/Laniakea_Supercluster). The LEDs on
the front can be changed as well. For example the WPS LED is unused, why should
the LED not blink and serve as a heartbeat? Install kmod-ledtrig-heartbeat and
at three additional lines to the config. The most useful™ module is probably
the netfilter module: you can define netfilter rules and when triggered the LED
will blink. So for example you can match for incoming SSH traffic, when IPv6
traffic is seen and so on. We do not edit anything else in  ```/etc/config/system```
yet, NTP configuration do we edit separately.

{{< highlight bash >}}
@OpenWrt:~ $ head -n 4 /etc/config/system 
config system
	option hostname 'laniakea'
	option timezone 'Europe/Berlin'
[..]
config 'led'
        option 'sysfs'          'mamba:white:wps'
        option 'trigger'        'heartbeat'
{{< /highlight >}}

Before we go on we just check what the hardware provides, starting with the filesystem:

{{< highlight bash >}}
@OpenWrt:~ $ df -h
Filesystem                Size      Used Available Use% Mounted on
rootfs                   26.5M     40.0K     25.1M   0% /
/dev/root                 2.3M      2.3M         0 100% /rom
tmpfs                   124.7M     64.0K    124.6M   0% /tmp
/dev/ubi0_1              26.5M     40.0K     25.1M   0% /overlay
overlayfs:/overlay       26.5M     40.0K     25.1M   0% /
ubi1:syscfg              30.8M    248.0K     28.9M   1% /tmp/syscfg
tmpfs                   512.0K         0    512.0K   0% /dev
{{< /highlight >}}


Now we look at the major configuration files for an OpenWrt router, starting
with the network configuration, followed by the wireless configuration. You see
that for the WAN side DHCP is already activated. We do not edit anything here -
just for now.

{{< highlight bash >}}
root@OpenWrt:~# cat /etc/config/network
config interface 'loopback'
        option ifname 'lo'
        option proto 'static'
        option ipaddr '127.0.0.1'
        option netmask '255.0.0.0'

config globals 'globals'
        option ula_prefix 'fd37:3416:2352::/48'

config interface 'lan'
        option ifname 'eth0'
        option force_link '1'
        option type 'bridge'
        option proto 'static'
        option ipaddr '192.168.1.1'
        option netmask '255.255.255.0'
        option ip6assign '60'

config interface 'wan'
        option ifname 'eth1'
        option proto 'dhcp'

config interface 'wan6'
        option ifname 'eth1'
        option proto 'dhcpv6'

config switch
        option name 'switch0'
        option reset '1'
        option enable_vlan '1'

config switch_vlan
        option device 'switch0'
        option vlan '1'
        option ports '0 1 2 3 5'

config switch_vlan
        option device 'switch0'
        option vlan '2'
        option ports '4 6'
{{< /highlight >}}

Now we take a look at a (slightly modified) wireless configuration. Per default
the WiFi interfaces are disabled and must be enabled explicitly. 

{{< highlight bash >}}
root@OpenWrt:~# cat /etc/config/wireless
config wifi-device 'radio0'
        option type 'mac80211'
        option channel '4'
        option hwmode '11ng'
        option path 'soc/soc:pcie-controller/pci0000:00/0000:00:02.0/0000:02:00.0'
        option htmode 'HT20'

config wifi-iface
        option device 'radio0'
        option network 'lan'
        option mode 'ap'
        option ssid ''ssid2''
        option encryption 'psk2'
        option key 'pass'

config wifi-device 'radio1'
        option type 'mac80211'
        option channel '36'   
        option hwmode '11a'   
        option path 'soc/soc:pcie-controller/pci0000:00/0000:00:03.0/0000:03:00.0'
        option htmode 'VHT80'

config wifi-iface          
        option device 'radio1'
        option network 'lan'  
        option mode 'ap'      
        option ssid 'ssid5'
        option encryption 'psk2'              
        option key 'pass'
{{< /highlight >}}


After a correct cabling, e.g. WLAN toward cable modem, LAN toward host and
probably a network restart or reboot IPv4 and IPv6 addresses will be assigned.

{{< highlight bash >}}
root@OpenWrt:~# ifconfig
br-lan    Link encap:Ethernet  HWaddr B4:75:0E:FA:01:CB  
          inet addr:192.168.1.1  Bcast:192.168.1.255  Mask:255.255.255.0
          inet6 addr: fe80::b675:eff:fefa:1cb/64 Scope:Link
          inet6 addr: fd37:3416:2352::1/60 Scope:Global
          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
          RX packets:24445 errors:0 dropped:0 overruns:0 frame:0
          TX packets:23770 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:0 
          RX bytes:2133646 (2.0 MiB)  TX bytes:76167420 (72.6 MiB)

eth0      Link encap:Ethernet  HWaddr B4:75:0E:FA:01:CB  
          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
          RX packets:23840 errors:0 dropped:21 overruns:0 frame:0
          TX packets:23134 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:532 
          RX bytes:2347290 (2.2 MiB)  TX bytes:75920959 (72.4 MiB)
          Interrupt:27 

eth1      Link encap:Ethernet  HWaddr B6:75:0E:FA:01:CB  
          inet addr:188.193.123.84  Bcast:188.193.123.255  Mask:255.255.255.0
          inet6 addr: fe80::b475:eff:fefa:1cb/64 Scope:Link
          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
          RX packets:64150 errors:0 dropped:0 overruns:0 frame:0
          TX packets:24644 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:532 
          RX bytes:79302285 (75.6 MiB)  TX bytes:2487245 (2.3 MiB)
          Interrupt:28 

lo        Link encap:Local Loopback  
          inet addr:127.0.0.1  Mask:255.0.0.0
          inet6 addr: ::1/128 Scope:Host
          UP LOOPBACK RUNNING  MTU:65536  Metric:1
          RX packets:83 errors:0 dropped:0 overruns:0 frame:0
          TX packets:83 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:0 
          RX bytes:6332 (6.1 KiB)  TX bytes:6332 (6.1 KiB)
{{< /highlight >}}

We do not see any wlan interfaces because they are disabled per default. Lets
see what the Wifi chipset provides:

{{< highlight bash >}}
OpenWrt# iw phy0 info
Wiphy phy0
	max # scan SSIDs: 4
	max scan IEs length: 2242 bytes
	Retry short limit: 7
	Retry long limit: 4
	Coverage class: 0 (up to 0m)
	Available Antennas: TX 0 RX 0
	Supported interface modes:
		 * managed
		 * AP
		 * AP/VLAN
		 * monitor
	Band 1:
		Capabilities: 0x6f
			RX LDPC
			HT20/HT40
			SM Power Save disabled
			RX HT20 SGI
			RX HT40 SGI
			No RX STBC
			Max AMSDU length: 3839 bytes
			No DSSS/CCK HT40
		Maximum RX AMPDU length 65535 bytes (exponent: 0x003)
		Minimum RX AMPDU time spacing: 4 usec (0x05)
		HT TX/RX MCS rate indexes supported: 0-23, 32
		VHT Capabilities (0x33981932):
			Max MPDU length: 11454
			Supported Channel Width: neither 160 nor 80+80
			RX LDPC
			short GI (80 MHz)
			SU Beamformer
			SU Beamformee
			MU Beamformer
			MU Beamformee
			RX antenna pattern consistency
			TX antenna pattern consistency
		VHT RX MCS set:
			1 streams: MCS 0-9
			2 streams: MCS 0-9
			3 streams: MCS 0-9
			4 streams: not supported
			5 streams: not supported
			6 streams: not supported
			7 streams: not supported
			8 streams: not supported
		VHT RX highest supported: 0 Mbps
		VHT TX MCS set:
			1 streams: MCS 0-9
			2 streams: MCS 0-9
			3 streams: MCS 0-9
			4 streams: not supported
			5 streams: not supported
			6 streams: not supported
			7 streams: not supported
			8 streams: not supported
		VHT TX highest supported: 0 Mbps
		Frequencies:
			* 2412 MHz [1] (20.0 dBm)
			* 2417 MHz [2] (20.0 dBm)
			* 2422 MHz [3] (20.0 dBm)
			* 2427 MHz [4] (20.0 dBm)
			* 2432 MHz [5] (20.0 dBm)
			* 2437 MHz [6] (20.0 dBm)
			* 2442 MHz [7] (20.0 dBm)
			* 2447 MHz [8] (20.0 dBm)
			* 2452 MHz [9] (20.0 dBm)
			* 2457 MHz [10] (20.0 dBm)
			* 2462 MHz [11] (20.0 dBm)
			* 2467 MHz [12] (20.0 dBm) (no IR)
			* 2472 MHz [13] (20.0 dBm) (no IR)
			* 2484 MHz [14] (20.0 dBm) (no IR)
	Band 2:
		Capabilities: 0x6f
			RX LDPC
			HT20/HT40
			SM Power Save disabled
			RX HT20 SGI
			RX HT40 SGI
			No RX STBC
			Max AMSDU length: 3839 bytes
			No DSSS/CCK HT40
		Maximum RX AMPDU length 65535 bytes (exponent: 0x003)
		Minimum RX AMPDU time spacing: 4 usec (0x05)
		HT TX/RX MCS rate indexes supported: 0-23, 32
		VHT Capabilities (0x33981932):
			Max MPDU length: 11454
			Supported Channel Width: neither 160 nor 80+80
			RX LDPC
			short GI (80 MHz)
			SU Beamformer
			SU Beamformee
			MU Beamformer
			MU Beamformee
			RX antenna pattern consistency
			TX antenna pattern consistency
		VHT RX MCS set:
			1 streams: MCS 0-9
			2 streams: MCS 0-9
			3 streams: MCS 0-9
			4 streams: not supported
			5 streams: not supported
			6 streams: not supported
			7 streams: not supported
			8 streams: not supported
		VHT RX highest supported: 0 Mbps
		VHT TX MCS set:
			1 streams: MCS 0-9
			2 streams: MCS 0-9
			3 streams: MCS 0-9
			4 streams: not supported
			5 streams: not supported
			6 streams: not supported
			7 streams: not supported
			8 streams: not supported
		VHT TX highest supported: 0 Mbps
		Frequencies:
			* 5180 MHz [36] (20.0 dBm)
			* 5200 MHz [40] (20.0 dBm)
			* 5220 MHz [44] (20.0 dBm)
			* 5240 MHz [48] (20.0 dBm)
			* 5260 MHz [52] (20.0 dBm) (no IR, radar detection)
			  DFS state: usable (for 78498 sec)
			  DFS CAC time: 60000 ms
			* 5280 MHz [56] (20.0 dBm) (no IR, radar detection)
			  DFS state: usable (for 78498 sec)
			  DFS CAC time: 60000 ms
			* 5300 MHz [60] (20.0 dBm) (no IR, radar detection)
			  DFS state: usable (for 78498 sec)
			  DFS CAC time: 60000 ms
			* 5320 MHz [64] (20.0 dBm) (no IR, radar detection)
			  DFS state: usable (for 78498 sec)
			  DFS CAC time: 60000 ms
			* 5500 MHz [100] (20.0 dBm) (no IR, radar detection)
			  DFS state: usable (for 78498 sec)
			  DFS CAC time: 60000 ms
			* 5520 MHz [104] (20.0 dBm) (no IR, radar detection)
			  DFS state: usable (for 78498 sec)
			  DFS CAC time: 60000 ms
			* 5540 MHz [108] (20.0 dBm) (no IR, radar detection)
			  DFS state: usable (for 78498 sec)
			  DFS CAC time: 60000 ms
			* 5560 MHz [112] (20.0 dBm) (no IR, radar detection)
			  DFS state: usable (for 78498 sec)
			  DFS CAC time: 60000 ms
			* 5580 MHz [116] (20.0 dBm) (no IR, radar detection)
			  DFS state: usable (for 78498 sec)
			  DFS CAC time: 60000 ms
			* 5600 MHz [120] (20.0 dBm) (no IR, radar detection)
			  DFS state: usable (for 78498 sec)
			  DFS CAC time: 60000 ms
			* 5620 MHz [124] (20.0 dBm) (no IR, radar detection)
			  DFS state: usable (for 78498 sec)
			  DFS CAC time: 60000 ms
			* 5640 MHz [128] (20.0 dBm) (no IR, radar detection)
			  DFS state: usable (for 78498 sec)
			  DFS CAC time: 60000 ms
			* 5660 MHz [132] (20.0 dBm) (no IR, radar detection)
			  DFS state: usable (for 78498 sec)
			  DFS CAC time: 60000 ms
			* 5680 MHz [136] (20.0 dBm) (no IR, radar detection)
			  DFS state: usable (for 78498 sec)
			  DFS CAC time: 60000 ms
			* 5700 MHz [140] (20.0 dBm) (no IR, radar detection)
			  DFS state: usable (for 78498 sec)
			  DFS CAC time: 60000 ms
			* 5720 MHz [144] (20.0 dBm) (no IR, radar detection)
			  DFS state: usable (for 78498 sec)
			  DFS CAC time: 60000 ms
			* 5745 MHz [149] (20.0 dBm) (no IR)
			* 5765 MHz [153] (20.0 dBm) (no IR)
			* 5785 MHz [157] (20.0 dBm) (no IR)
			* 5805 MHz [161] (20.0 dBm) (no IR)
	valid interface combinations:
		 * #{ AP } <= 8, #{ managed } <= 1,
		   total <= 8, #channels <= 1
	HT Capability overrides:
		 * MCS: ff ff ff ff ff ff ff ff ff ff
		 * maximum A-MSDU length
		 * supported channel width
		 * short GI for 40 MHz
		 * max A-MPDU length exponent
		 * min MPDU start spacing
{{< /highlight >}}

If we also obtain the output for phy1 the data is nearly identical, the only
difference are DFS states (a truncated ```diff -Nuar```):

{{< highlight bash >}}
[...]
-			  DFS state: usable (for 78869 sec)
+			  DFS state: usable (for 78868 sec)
[...]
{{< /highlight >}}

Dynamic Frequency Selection (DFS) is mandatory in US, EU, and Japan to detect
interferences with radar systems. Especially weather radar systems. If a
collision is detected the WiFi (AP) is enforced to instantly change the
frequency band. Not sure what the values actually mean, probably wait every
~21h and then listen for 1 minute and search for radar pulses.



#### Common Router Software

No matter on what Linux device I work, some software is mandatory

{{< highlight bash >}}
opkg update
opkg install screen zsh tcpdump
{{< /highlight >}}

Edit passwd and point root’s sheel to /bin/zsh

{{< highlight bash >}}
vim /etc/passwd
{{< /highlight >}}

In subsequent sections we will install additional software. We don’t do it now
because they are optional and every reader should decide for himself which
software is required and why. If you want you can already capture traffic on
all interfaces, including the wireless link.

{{< highlight bash >}}
tcpdump -i wlan1 -vvv -ttt -p -U
{{< /highlight >}}


# <a name="optimizations">WiFi Performance Optimizations</a>


#### Tuning the Default WiFi Configuration

The default WLAN configuration provides a stable starting point, not a tuned
one. If something goes wrong it is always possible to go back to this one.

Before starting with modifications it is necessary to measure the current
performance. To get this right some things should be considered.

Both end host, source and sink should be able to transmit and receive at a
given rate. For example Google Nexus 7 Tablet is limited to 60MBit/s (PHY rate,
including PHY "overhead") as it support only a single spatial stream. The
antennas of cell phones, tablets and laptop partly differes enormously. So make
sure the server and client hardware is generally in the ability to make such
measurements.

Then source and sink can be software limited. If using TCP the kernel parameter
may not adequate to get maximum performance although the WIFi hardware limit is
not reached. Downloading files direcly can be artificially limited by low
performance NAND (eMMC), thus performance measurement tools should be used -
not a wget.

To test the surrounding components it is a good idea to install the measurement
software and plug source and sink directly to the gigabit ports of the router
and do the test via wire first.

The best network measurement tool for Linux is netperf. It has more expert
features than iperf. Netperf is extensively used by the kernel network stack
guys and the author Rick “Netperf” Jones is an active member of netdev. If a
new feature makes sense it is added by Rick. Though netperf a expert tool the
drawback is that the distribution of the tool is not that high compared to
iperf (where Windows ports and nice GUIs frontends are available). Iperf is
available as an Android app and as a OpenWRT package. To keep things simple and
because the only goal it to get vanilla down- and upload values we will use
iperf now.

Thirst we start with a simple test: two hosts connected via a HP Gigabit
switch - no router hardware in between. With this test we make sure both
computer are able to communicate with each other at a requested rate (you can
call it the Linux Kernel Configuration and CPU check if you want).

```bash
@coma:~ $ iperf -c virgo.local -t20 -i2 -w64k  
------------------------------------------------------------
Client connecting to 192.168.1.163, TCP port 5001
TCP window size:  128 KByte (WARNING: requested 64.0 KByte)
------------------------------------------------------------
[  3] local 192.168.1.140 port 41111 connected with virgo.local port 5001
[ ID] Interval       Transfer     Bandwidth
[  3]  0.0- 2.0 sec   224 MBytes   942 Mbits/sec
[  3]  2.0- 4.0 sec   224 MBytes   941 Mbits/sec
[  3]  4.0- 6.0 sec   224 MBytes   941 Mbits/sec
[  3]  6.0- 8.0 sec   224 MBytes   941 Mbits/sec
[  3]  8.0-10.0 sec   224 MBytes   941 Mbits/sec
[  3] 10.0-12.0 sec   224 MBytes   941 Mbits/sec
[  3] 12.0-14.0 sec   224 MBytes   941 Mbits/sec
[  3] 14.0-16.0 sec   224 MBytes   941 Mbits/sec
[  3] 16.0-18.0 sec   224 MBytes   941 Mbits/sec
[  3] 18.0-20.0 sec   224 MBytes   941 Mbits/sec
[  3]  0.0-20.0 sec  2.19 GBytes   941 Mbits/sec
```

This is near the practical maximum throughput of 802.3. The theoretical maximum
of 802.3 is 100MBit/s. The difference between theoretical and practical maximum
throughput is not large for 802.3 because of protocl efficiency and other
factors. For 802.11 the difference is partly enormous.

So the logical next step is to transmit data directly over Wifi. We start with
the 2.4 band:

{{< highlight bash >}}
@coma:~ $ iperf -c 192.168.1.163 -t20 -i2 -w256k
------------------------------------------------------------
Client connecting to 192.168.1.163, TCP port 5001
TCP window size:  416 KByte (WARNING: requested  256 KByte)
------------------------------------------------------------
[  3] local 192.168.1.135 port 45242 connected with 192.168.1.163 port 5001
[ ID] Interval       Transfer     Bandwidth
[  3]  0.0- 2.0 sec  18.8 MBytes  78.6 Mbits/sec
[  3]  2.0- 4.0 sec  18.9 MBytes  79.2 Mbits/sec
[  3]  4.0- 6.0 sec  19.1 MBytes  80.2 Mbits/sec
[  3]  6.0- 8.0 sec  18.8 MBytes  78.6 Mbits/sec
[  3]  8.0-10.0 sec  18.8 MBytes  78.6 Mbits/sec
[  3] 10.0-12.0 sec  18.2 MBytes  76.5 Mbits/sec
[  3] 12.0-14.0 sec  19.0 MBytes  79.7 Mbits/sec
[  3] 14.0-16.0 sec  18.8 MBytes  78.6 Mbits/sec
[  3] 16.0-18.0 sec  18.8 MBytes  78.6 Mbits/sec
[  3] 18.0-20.0 sec  18.1 MBytes  76.0 Mbits/sec
[  3]  0.0-20.0 sec   187 MBytes  78.5 Mbits/sec
{{< /highlight >}}

Not too bad, now adjust/tune the wireless device config a little bit:

{{< highlight bash >}}
config wifi-device 'radio0'
        option type 'mac80211'
        option channel '4'
        option hwmode '11ng'
        option path 'soc/soc:pcie-controller/pci0000:00/0000:00:02.0/0000:02:00.0'
        option htmode 'HT40+'
        option country '00'
        option bursting '1'
        option ff '1'
        option compression '1'
        option noscan '1'
{{< /highlight >}}

{{< highlight bash >}}
@coma:~ $ iperf -c 192.168.1.163 -t20 -i2 -w512k
------------------------------------------------------------
Client connecting to 192.168.1.163, TCP port 5001
TCP window size:  416 KByte (WARNING: requested  512 KByte)
------------------------------------------------------------
[  3] local 192.168.1.135 port 45629 connected with 192.168.1.163 port 5001
[ ID] Interval       Transfer     Bandwidth
[  3]  0.0- 2.0 sec  29.2 MBytes   123 Mbits/sec
[  3]  2.0- 4.0 sec  30.2 MBytes   127 Mbits/sec
[  3]  4.0- 6.0 sec  29.0 MBytes   122 Mbits/sec
[  3]  6.0- 8.0 sec  27.4 MBytes   115 Mbits/sec
[  3]  8.0-10.0 sec  29.9 MBytes   125 Mbits/sec
[  3] 10.0-12.0 sec  27.8 MBytes   116 Mbits/sec
[  3] 12.0-14.0 sec  28.2 MBytes   118 Mbits/sec
[  3] 14.0-16.0 sec  29.5 MBytes   124 Mbits/sec
[  3] 16.0-18.0 sec  28.8 MBytes   121 Mbits/sec
[  3] 18.0-20.0 sec  26.6 MBytes   112 Mbits/sec
[  3]  0.0-20.0 sec   287 MBytes   120 Mbits/sec
{{< /highlight >}}

![Tuned WiFi Configuration](../../../../images/tuned-wifi-conf.png)

So we see a performance increase of ~50% for 802.11n. Last but not least you
can try the following options to increase the throughtput even more. But be
aware that it is possible that some configuration knobs lead to malfunctions,
so be carefully.

{{< highlight bash >}}
list 'ht_capab' 'SHORT-GI-40'
list 'ht_capab' 'TX-STBC'
list 'ht_capab' 'RX-STBC1'
list 'ht_capab' 'DSSS_CCK-40'
{{< /highlight >}}

For the 5.0 Ghz band and with vanilla wireless configuration (without
modification) I get the following throughput results:

{{< highlight bash >}}
@coma:~ $ iperf -c 192.168.1.163 -t50 -i5 -w512k                  
------------------------------------------------------------
client connecting to 192.168.1.163, tcp port 5001
tcp window size:  416 kbyte (warning: requested  512 kbyte)
------------------------------------------------------------
[  3] local 192.168.1.135 port 46823 connected with 192.168.1.163 port 5001
[ id] interval       transfer     bandwidth
[  3]  0.0- 5.0 sec   122 mbytes   205 mbits/sec
[  3]  5.0-10.0 sec   129 mbytes   217 mbits/sec
[  3] 10.0-15.0 sec   128 mbytes   215 mbits/sec
[  3] 15.0-20.0 sec   129 mbytes   217 mbits/sec
[  3] 20.0-25.0 sec   130 mbytes   217 mbits/sec
[  3] 25.0-30.0 sec   123 mbytes   206 mbits/sec
[  3] 30.0-35.0 sec   131 mbytes   219 mbits/sec
[  3] 35.0-40.0 sec   126 mbytes   212 mbits/sec
[  3] 40.0-45.0 sec   126 mbytes   211 mbits/sec
[  3] 45.0-50.0 sec   131 mbytes   220 mbits/sec
[  3]  0.0-50.0 sec  1.24 gbytes   214 mbits/sec
{{< /highlight >}}

If I run the iperf application at Googles’s Nexus 9 I get in average 310
MBits/sec. Seems the WiFi chipset and/or antennas (2x2 MIMO antenna) are better
than in Dell’s XPS 13. On Nexus 5 I get on average 210 MBit/sec. Sufficient for
me - no further optimization required.

#### A Crowded Frequency Spectrum

As you see in the configuration the configured channel is 4 in 2.4 mode (2427
MHz). This is the frequency band where the fewest devices operates in my
direct neighborhood.

![WiFi Spectrum](../../../../images/openwrt-channel-4.png)

#### Router Placement and Positioning

A not too underrated topic is the placement of the router. A well positioned
router may perform magnitudes better than placed somewhere where shielding &
reflection is common. Sure, everyone has limitations in the form of power
supply, Internet upstream connectivity or wife's visions how the accommodation
should look like. At the end the possibilities are limited, nonetheless some
flexibility is usually available and should be used.

But how to know what is the superior router position? Measurements must be
done. Place your router, take a WiFi device, start iperf and walk around your
flat. If you encounter areas with low coverage try to re-positioning the
router. One last words: do the measurements at times where you plan to use the
router. Working hours, non-working hours, ... Because channels saturation
change over the day.


# <a name="addressing">IPv4, IPv6 and Tunneling</a>

Kabel Deutschland (a larger ISP in Germany) provides Internet connectivity
through cable modems on standard cable television infrastructure. Thus a cable
modem is provided by the provider. Without configuration change the DOCSIS-3
modem use DHCPv4 to provide IPv4 addresses (RFC 1918 addresses, NATed) and IPv6
SLAAC to hand out a /64 prefix. The later is the minimum which is required to
fulfills the requirements. It do no allow me to group the network into routing
areas (subnetting) - which is bad.

Kabel Deutschland provides a mode to switch the modem - and the infrastructure
behind - into a so called bridge mode. The result is that a public IPv4 is
replied for an DHCPv4 request but if you try DHCPv6 prefix delegation (DHCP-PD)
I get an error that no IPv6 addresses are available. Reading forums I realized
quickly that Kabel Deutschland do not provide any IPv6 connectivity if the
router is switched in bridge mode. To sum up KDs default modem setup:

* NATed RFC1918 IPv4 address via DHCP
* IPv6 address via SLAAC

This is not ideal because you will do NAT at least two time: in the OpenWrt box
and in the cable modem. Because KD do DS-Lite with Carrier-Grade-NAT we increase
the NAT madness from two to three times - yes. And because they do Carrier
Grade NAT: port forwarding is not dead simple. The other solution is to use the
bridge mode and use the provided (public) IPv4 address and setup a IPv6 tunnel.
Sixxs provides by the way /48 prefixes if you collect enough points, called IP
SixXS Kredit (ISK). The biggest advantage of this solution is probably a
working port forwarding without headache and IPv6 addresses and IPv6
subnetting. So the following setup using KD bridge mode.


#### IPv6 Tunnel Setup with Sixxs

Install aiccu and the required dependencies:

{{< highlight bash >}}
@OpenWrt:~ $ opkg install aiccu
[...]
Configuring ip.
Configuring kmod-tun.
Configuring kmod-iptunnel.
Configuring kmod-iptunnel4.
Configuring kmod-sit.
Configuring aiccu.
{{< /highlight >}}

In the wan6 section of /etc/config/network you should enter your Sixxs data:
username, password, tunnelid and the prefix.

{{< highlight bash >}}
config interface 'wan6'
        option proto 'aiccu' 
        option username 'XXX-SIXXS/T2XXXXX'
        option password 'XXXXXX'       
        option tunnelid 'T2XXXX'    
        option ip6prefix '2a01:XXXX::1/48'
        option requiretls '1'              
        option heartbeat '1'
{{< /highlight >}}

Then ```/etc/init.d/network reload``` or reboot - sometimes the modifications are not
detected or the scripts have some problems - I don't know. So the reboot is
probably what you should do from time to time if you change several files. Just
to make sure that a configuration bug is not hidden. Now check the connection
after reconfiguration, ping a IPv6 host:

{{< highlight bash >}}
@laniakea:~ $ ping6 -c 3 sixxs.net
PING sixxs.net (2001:XXXX::2): 56 data bytes
64 bytes from 2001:XXXX::2: seq=0 ttl=56 time=36.842 ms
64 bytes from 2001:XXXX::2: seq=1 ttl=56 time=24.736 ms
64 bytes from 2001:XXXX::2: seq=2 ttl=56 time=35.086 ms
{{< /highlight >}}

If things work you can enable SLAAC to anounce the prefix in your network. Note
that radvd is not used since Barrier Breaker, For more IPv6 related
configuration you should check the
[wiki](http://wiki.openwrt.org/doc/uci/network6). To enable SLAAC just make
sure the following configuration lines are added 

{{< highlight bash >}}
config interface 'lan'
[...]
        option proto 'static'
        option ip6assign '64'
{{< /highlight >}}

Remeber that some lines above in ```/etc/config/network``` the default configuration
additionally defines a ULA - this will also be advertised via SLAAC.

{%highlight bash>}}
config globals 'globals'
        option ula_prefix 'fd37:daed:beef::/64'
{%endhighlight>}}

Maybe it is time to reboot now. To get a fresh network configuration on your
client system you can remove all IP addresses via sudo ip a
flush dev DEV. Now wait until the router rebooted and all IP addresses are
assigned. Lets check the IP addresses on the client system:

{{< highlight bash >}}
@virgo:~ $ ip a ls dev eth1  
2: eth1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
    link/ether 68:05:ca:03:ab:31 brd ff:ff:ff:ff:ff:ff
    inet 192.168.1.163/24 brd 192.168.1.255 scope global eth1
       valid_lft forever preferred_lft forever
    inet6 2a01:XXX:XXX:0:6a05:caff:fe03:ab31/64 scope global mngtmpaddr dynamic 
       valid_lft 7155sec preferred_lft 1755sec
    inet6 fd37:daed:beef:0:6a05:caff:fe03:ab31/64 scope global mngtmpaddr dynamic 
       valid_lft 7155sec preferred_lft 1755sec
{{< /highlight >}}

Fine! We get the IPv4 address via DHCP, the Sixxs tunnel address and the ULA
via SLAAC.  To make sure every works you can now ping from any computer in the
network a IPv6 host somewhere in the world:

{{< highlight bash >}}
@virgo:~ $ ping6 -c 3 -n jauu.net  
PING jauu.net(2001:4860:4802:32::15) 56 data bytes
64 bytes from 2001:4860:4802:32::15: icmp_seq=1 ttl=55 time=35.9 ms
64 bytes from 2001:4860:4802:32::15: icmp_seq=2 ttl=55 time=35.6 ms
64 bytes from 2001:4860:4802:32::15: icmp_seq=3 ttl=55 time=36.6 m
{{< /highlight >}}

One concern about IPv6 tunnel are increased delay and reduced throughput. I
measured the delay for a while and only see a slight increase of round trip
time compared to "native" bandwidth. The following image illustrates the
measured ping RTT from a client in my network to heise.de. If you want you
test your IPv4/IPv6 RTT performance you can use my ready to use [ping gnuplot
inkscape script](https://gist.github.com/hgn/e1f1ab9a3d03f8088624) to visualize
your RTT: 

![WiFi Spectrum](../../../../images/ipv4-ipv6-ping-rtt.png)

# <a name="dns">Dynamic DNS</a>

As a requirement for IPSec, VPN or other home network related operations like
file hosting at home you need to know the actual IP address of your router.

My network addressing for IPv4 is dynamic: my provider will renew the public
IPv4 address from time to time, at least if I reboot the router. Because I use
Sixxs for IPv6 connectivity the IPv6 addresses will not change - static if you
like. Thus I can directly communicate via IPv6 with my router if required. To
communicate via IPv6 to any host in my home network I am forced to
assigned a static IPv6 address to the host(s). This contradicts efforts to use
privacy generated (pseudo random)IPv6 addresses. I will show how you can
configure a hybrid IPv6 addressing scheme: permanent addressing for internet →
intranet communication and privacy addresses for everything else.

But an addressing mechanism limited to IPv6 has some problems. The two relevant
problems are:

* Often you don't have IPv6 connectivity, especially abroad or on vacations. Resulting in times where you just cannot connect to your home network.
* Secondly, IPv6 addresses are hard to remeber and typing 2001:DB8:daed:affe::1 every time is annoying.

To bypass this situation we will use a Dynamic DNS service to get a comfortable
pronounceable names for both: IPv6 and IPv4.


  <div class="bs-callout bs-callout-warning">
<h4>Dynamic Updates in the Domain Name System - DNS Update</h4>
<p>
Though, Dynamic DNS as specified in RFC 2136
(https://tools.ietf.org/html/rfc2136) is not directly what is used by the broad
providers of custom DNS updates. Today they often provide a HTTP REST like
interface to push credentials, updated domain name and IP addresses. The
provider then update the corresponding DNS entries. The "real" Dynamic DNS
update mechanism works by providing an inband mechanism to update the DNS
database by using a special DNS record. The mechanism is more complex, required
DNS tooling and most important a cryptographic secured infrastructure. It”s
somehow understandable that DynDNS providers bypass this and use some lighter
mechanism to update the database.
</p>
  </div>

There are many providers in the market offers DynDNS services. Probably you
already have one. I use [Hurricane Electric](https://www.he.net/) since several
years (not only as DNS Update service) and feeling quite fine. The guys from
Hurricane Electric (HE) are professional, know what the crowd wants and do a
perfect job! The next paragraphs describes the setup procedure for HE and
assumes you already have a domain name and want to use them by simple
delegating a sub domain to HE.

Imagine your
[registrar](https://www.icann.org/registrar-reports/accredited-list.html) is
named FooBar and you already registered example.com there. Example domain is
you primary and only domain: you operate HTTP, SMTP, IMAP and other servers by
this host. But you want to use this domain also to access your home network.
The way to go is to add another subdomain and change the DNS responsibilities
for this subdomain. Let's name the subdomain 'home', resulting in a FQDN
```home.example.com```. Next, transfer the nameserver authority for this domain to
HE. In DNS speech: add a NS record for ```home.example.com``` and point it to HE.
This is normally done in a web based administration panel from your registrar
(FooBar). After the change you should see the modifications in the DNS
database:

{{< highlight bash >}}
dig @8.8.8.8 +short home.example.com NS
ns4.he.net.
ns3.he.net.
ns1.he.net.
ns2.he.net.
ns5.he.net.
{{< /highlight >}}

Next step is to let HE know that the sub-domain is now managed by HE. The HE
DNS administration desk provides all knobs to do that. I don’t want to go into
the details because the configuration is quite simple. You can add new
subdomains like router (FQDM: ```router.home.example.com```) and choose between a
static mapping or a dynamic one for IPv4 (A record) and IPv6 (AAAA record).
Because I have a permanent IPv6 address I add the IPv6 address directly here.
No need to change this dynamically via DNS update. For IPv4 you need to
generate a dynamic DNS key. This key is later used to change the IPv4 address
and prevent other bad guys to change the address and point to some other hosts.
For now, just remember your username and the newly created password. 

Now install the required OpenWrt software:

{{< highlight bash >}}
opkg update
opkg install ddns-scripts
{{< /highlight >}}

Now we overwrite the default configuration in ```/etc/config/ddns``` with your new
data.

{{< highlight bash >}}
config service "he_ipv4"
        option enabled          "1"
        option service_name     "he.net"
        option domain           "router.home.example.com"
        option username         "USERNAME"
        option password         "PASSWORD"
        option interface        "wan"
        option ip_source        "network"
        option ip_network       "wan"
{{< /highlight >}}

Simple start the local DDNS service, enable the service permanently and to make
sure everything is working you should trigger a interface up signal with the
reason that the DDNS service detects the current IP address. Alternatively,
Windows style: you can reboot your router.

{{< highlight bash >}}
/etc/init.d/ddns start
/etc/init.d/ddns enable
ACTION=ifup INTERFACE=wan /sbin/hotplug-call iface
{{< /highlight >}}

Now check that everything is working. Query the AAAA and A record for your
domain. For IPv6 you should see the static address and for IPv4 you should see
the ISP provided IPv4 address. Afterwards you can use a online ping service to
verify connectivity. OpenWrt’s default firewall rules let ICMPv4 and ICMPv6 in
(with some rate limiting restrictions).

{{< highlight bash >}}
dig @8.8.8.8 router.home.example.com AAAA
dig @8.8.8.8 router.home.example.com A
{{< /highlight >}}

# <a name="missing">Missing Parts</a>

#### Guest WiFi and Freifunk

Many OpenWrt configurations show how to setup a Guest WiFi. Normally a
reduced feature set WiFi, e.g. firewalled with exception of HTTP and HTTPS.
The guest WiFi is often VLAN tagged to make sure that unsecure and secure data
do not use the same network.

I don"t provide an guest network and I do not restrict guest. Rather I host a
[Freifunk](http://freifunk-muenchen.de/) node for the neighborhood which can be
used by guests too. The additional Freifunk router (costs 20 euro) use his own
firmware (right, a own modified Openwrt version with BATMAN routing, Fastd,
etc. pp). All traffic from this router is tunneled via VPN to a another router
in Munich. So I can't even see what the guests do! The only limition for guests
is a slight up- and downlink shapping. Just to make sure that guests do not
saturate my ISP link - thats all.

If you want to participate you can join the monthly [Freifunk
meeting](http://freifunk-muenchen.de/mitmachen/) here in Munich or in your
town. Meet great people, talk about OpenWrt and allow people to download their
favorite cat images.

[![Freifunk Logo](../../../../images/muc-freifunk-map.jpg)](http://freifunk-muenchen.de/knotenkarte/)
