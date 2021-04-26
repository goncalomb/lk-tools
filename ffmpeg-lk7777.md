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

    git clone --depth=1 -b lk7777 https://github.com/goncalomb/FFmpeg.git
    cd FFmpeg
    ./configure
    make -j 16

## Examples

You need the AES-128 decryption key for the device (replace 00112233445566778899aabbccddeeff).

The default key may or may not have been posted on freenode #lkv373a https://freenode.logbot.info/lkv373a and cannot be found by searching for 'key='.

Sanity check:

    ./ffmpeg -key 00112233445566778899aabbccddeeff -i udp://@239.255.42.42:7777

If the key is correct you should get some description of the streams:

```
Input #0, lk7777, from 'udp://@239.255.42.42:7777':
  Duration: N/A, start: 30030.800000, bitrate: N/A
  Stream #0:0: Video: h264 (Constrained Baseline), yuvj420p(pc, progressive), 1280x720, 50 fps, 50 tbr, 1k tbn, 120 tbc
  Stream #0:1: Audio: mp2, 48000 Hz, stereo, s16p, 192 kb/s
At least one output file must be specified
```

Other examples:

    # pipe directly into vlc
    ./ffmpeg -key 00112233445566778899aabbccddeeff -i udp://@239.255.42.42:7777 -vcodec copy -acodec copy -f mpegts - | vlc -

    # save to file
    ./ffmpeg -key 00112233445566778899aabbccddeeff -i udp://@239.255.42.42:7777 -vcodec copy -acodec copy -f mpegts out.ts
    ./ffmpeg -key 00112233445566778899aabbccddeeff -i udp://@239.255.42.42:7777 -vcodec copy -acodec copy -f matroska out.mkv

    # steam using mpegts (open udp://@127.0.0.1:7778 on vlc)
    ./ffmpeg -key 00112233445566778899aabbccddeeff -i udp://@239.255.42.42:7777 -vcodec copy -acodec copy -f mpegts udp://127.0.0.1:7778

    # ffmpeg with trace output (for debugging the demuxer)
    ./ffmpeg -key 00112233445566778899aabbccddeeff -i udp://@239.255.42.42:7777 -vcodec copy -acodec copy -f mpegts -loglevel trace - | vlc -
