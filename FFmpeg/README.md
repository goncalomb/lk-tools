# ffmpeg with lk7777 support

I'm working on a demuxer that allows ffmpeg to decode lk7777. It works! But there is still some work to be done. And the format is not fully known yet.

This is heavily based on the findings by kitten_nb_five...

* https://freenode.logbot.info/lkv373a/20210220
* https://github.com/kittennbfive/373-v4-tools
* https://github.com/kittennbfive/373-v4-tools/blob/main/Protocol.txt

Sending this to be merged with ffmpeg in the future is a possibility. But I need to make sure it's up to ffmpeg's coding requirements.

https://ffmpeg.org/developer.html#Contributing

## Code

The ffmpeg fork (lk7777 branch): https://github.com/goncalomb/FFmpeg/tree/lk7777

This is the main demuxer file: https://github.com/goncalomb/FFmpeg/blob/lk7777/libavformat/lk7777.c

All the changes: https://github.com/FFmpeg/FFmpeg/compare/master...goncalomb:lk7777

## Building ffmpeg (with lk7777 support)

    git clone --recursive --shallow-submodules --depth=1 https://github.com/goncalomb/lk-tools.git
    cd lk-tools/FFmpeg/FFmpeg
    ./configure
    make -j 16

### Cross Compiling for armv7, e.g. Raspberry Pi (Docker required)

    git clone --recursive --shallow-submodules --depth=1 https://github.com/goncalomb/lk-tools.git
    cd lk-tools/FFmpeg
    ./build-linux-armv7.sh

## Usage and Examples

### Decryption Key

You need the AES-128 decryption key for the device (replace 00112233445566778899aabbccddeeff).

The key can be obtained by issuing the `get_session_key` command on the telnet server of the TX device (user: admin, password: 123456).

```
$ telnet 192.168.1.210
Trying 192.168.1.210...
Connected to 192.168.1.210.
Escape character is '^]'.
================================
=========IPTV TX Server=========
================================
user name>admin
User name is OK.
password>*******
Password is OK.
input>list
set_group_id        get_group_id        set_dhcp            get_dhcp
set_uart_baudrate   get_uart_baudrate   set_static_ip       get_static_ip
set_mac_address     get_mac_address     get_lan_status      get_video_lock
get_ip_config       get_session_key     set_session_key     set_device_name
get_device_name     set_video_bitrate   get_video_bitrate   set_downscale_mode
get_downscale_mode  set_video_out_mode  get_video_out_mode  set_streaming_mode
get_streaming_mode  set_low_delay_mode  get_low_delay_mode  set_multicast_mode
get_multicast_mode  get_fw_version      get_company_id      factory_reset
reboot              list                save                exit
input>get_session_key
00112233445566778899aabbccddeeff
input>exit
Good Bye!!!
Connection closed by foreign host.
```

Use the `-key` argument on ffmpeg to set the key.

### First Test

    ./ffmpeg -key 00112233445566778899aabbccddeeff -i udp://@239.255.42.42:7777

If the key is correct you should get some description of the streams:

```
Input #0, lk7777, from 'udp://@239.255.42.42:7777':
  Duration: N/A, start: 30030.800000, bitrate: N/A
  Stream #0:0: Video: h264 (Constrained Baseline), yuvj420p(pc, progressive), 1280x720, 50 fps, 50 tbr, 1k tbn, 120 tbc
  Stream #0:1: Audio: mp2, 48000 Hz, stereo, s16p, 192 kb/s
At least one output file must be specified
```

### Examples

    # pipe directly into vlc
    ./ffmpeg -key 00112233445566778899aabbccddeeff -i udp://@239.255.42.42:7777 -vcodec copy -acodec copy -f mpegts - | vlc -

    # save to file
    ./ffmpeg -key 00112233445566778899aabbccddeeff -i udp://@239.255.42.42:7777 -vcodec copy -acodec copy -f mpegts out.ts
    ./ffmpeg -key 00112233445566778899aabbccddeeff -i udp://@239.255.42.42:7777 -vcodec copy -acodec copy -f matroska out.mkv

    # stream using mpegts (open udp://@127.0.0.1:7778 on vlc)
    ./ffmpeg -key 00112233445566778899aabbccddeeff -i udp://@239.255.42.42:7777 -vcodec copy -acodec copy -f mpegts udp://127.0.0.1:7778

    # ffmpeg with trace output (for debugging the demuxer)
    ./ffmpeg -key 00112233445566778899aabbccddeeff -i udp://@239.255.42.42:7777 -vcodec copy -acodec copy -f mpegts -loglevel trace - | vlc -
