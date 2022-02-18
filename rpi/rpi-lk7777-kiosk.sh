# Playing video streams from Lenkeng HDMI over IP devices (version 4) on Raspberry Pi.

# Tested on Raspberry Pi Zero 2 W, should work on other models too...

# https://github.com/goncalomb/lk-tools

# install Raspberry Pi OS Lite (32-bit)
# configure network
# compile ffmpeg with lk7777 support (see repository)
# copy it to /home/pi/ffmpeg (make it executable)
# copy the contents of this script to /etc/rc.local (change KEY=, see documentation on how to find it)
# change dtoverlay on /boot/config.txt to dtoverlay=vc4-fkms-v3d
# done
# the video stream should start playing automatically on boot (after automatically installing dependencies)

LK_FFMPEG="/home/pi/ffmpeg"
LK_ADDRESS="udp://@239.255.42.42:7777"
LK_KEY="00112233445566778899aabbccddeeff"

# ./ffmpeg -demuxers 2>/dev/null | grep lk7777 >/dev/null
echo "lk7777-kiosk: will start" >&2
( (
    set -e

    sleep 8
    echo ; echo ; echo

    echo "lk7777-kiosk: waiting for network" >&2
    # dhcpcd -w -q
    while [ -z "$(hostname -I)" ]; do sleep 2; done

    echo "lk7777-kiosk: addresses: $(hostname -I)" >&2
    sleep 2

    if ! command -v cvlc >/dev/null; then
        echo "lk7777-kiosk: installing vlc, this might take a while" >&2
        apt -y update
        apt -y install vlc-bin vlc-plugin-base
    fi

    echo "lk7777-kiosk: starting" >&2
    sudo -u pi bash <<EOF
"$LK_FFMPEG" -key "$LK_KEY" -i "$LK_ADDRESS" -vcodec copy -acodec copy -f mpegts - | cvlc -V mmal_vout -
EOF
)&)

exit 0
