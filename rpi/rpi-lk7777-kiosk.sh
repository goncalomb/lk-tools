#!/usr/bin/env bash

# Playing video streams from Lenkeng HDMI over IP devices (version 4) on Raspberry Pi.

# tested on a
#   Raspberry Pi Zero 2 W Rev 1.0
# with
#   Raspberry Pi OS Lite (32-bit)
# version
#   Raspbian GNU/Linux 12 (bookworm)

# https://github.com/goncalomb/lk-tools

# compile ffmpeg with lk7777 support (see repository)
# install Raspberry Pi OS Lite (32-bit)
# configure network
# copy ffmpeg to '/home/pi/ffmpeg'
# copy this script to '/etc/rc.local' (change LK_KEY=, see repository on how to find it)
# make it executable: sudo chmod +x /etc/rc.local
# disable tty1 (optional): sudo systemctl disable getty@tty1
# reboot
# the first boot should take a while as it will install the required dependencies
# the video stream should start playing automatically

set -euo pipefail

: "${LK_FFMPEG:="/home/pi/ffmpeg"}"
: "${LK_ADDRESS:="udp://@239.255.42.42:7777"}"
: "${LK_KEY:="00112233445566778899aabbccddeeff"}"
: "${LK_USER:="pi"}"
: "${LK_RETRY:=1}"

echo "waiting for network" >&2
while [ -z "$(hostname -I)" ]; do sleep 2; done

echo "$(hostname -I)" >&2

if ! command -v cvlc >/dev/null; then
    echo "installing vlc, this might take a while" >&2
    apt -y update
    apt -y install vlc-bin vlc-plugin-base
fi

echo "starting" >&2
sudo -u "$LK_USER" bash <<EOF
set -euo pipefail
chmod +x "$LK_FFMPEG" || true
while true; do
    "$LK_FFMPEG" -timeout 1 -key "$LK_KEY" -i "$LK_ADDRESS" -codec copy -f mpegts - | cvlc --play-and-exit --no-osd - || [ "$LK_RETRY" == "1" ]
    echo "player died, starting again" >&2
    sleep 2
done;
EOF
