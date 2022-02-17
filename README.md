# lk-tools

My tools and scripts to work with Lenkeng devices.

https://www.lenkeng.com/products/55/type/type1#type1

For now, this only relates to HDMI over IP extenders, version 4.

* LKV373A-4.0
* LKV383-4.0

I own the LKV383-4.0, both TX and RX.

## Protocol on UDP port 7777

New devices (version 4) use a proprietary streaming format to encode (and encrypt) the video and audio streams.

Some websites call the new format HDbitT. But public official technical information is non-existent. The [official site](http://www.hdbitt.org/what-is-hdbitt.html) points to HDbitT being used on other transports/transmission mediums.

These new devices (version 4) that "extend" HDMI over IP use this format over Multicast UDP port 7777.

For all intents and purposes, I'm calling this format (over UDP) **lk7777**.

Usage of this format over other transports is unknown ATM.

## Tools & Scripts

* [ffmpeg with lk7777 support](FFmpeg/)

## Community & Other Work

Original interest:

* https://blog.danman.eu/reverse-engineering-lenkeng-hdmi-over-ip-extender/
* https://blog.danman.eu/new-version-of-lenkeng-hdmi-over-ip-extender-lkv373a/

Other tools, scripts and information:

* https://github.com/v3l0c1r4pt0r/lkv-wiki
* https://github.com/kittennbfive/373-v4-tools
* https://github.com/danielkucera/lkv373a-v4
* https://github.com/danielkucera/golkv373

Chat on freenode #lkv373a:

* https://freenode.logbot.info/lkv373a
