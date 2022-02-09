#!/bin/sh

set -e
cd -- "$(dirname -- "$0")"

if [ -z "$DEFAULT_DOCKCROSS_IMAGE" ]; then
    # not running on docker, build image and run container
    [ -z "$1" ] && echo "no dockcross image provided" && exit 1
    docker build . -t lk-tools-ffmpeg-build --build-arg "DC_IMAGE=$1"
    docker run --rm -it -v "$(pwd)/..:/work/host" lk-tools-ffmpeg-build:latest
    exit
fi

git clone -b lk7777 ./host/FFmpeg FFmpeg-clone

cd FFmpeg-clone

export LDFLAGS="-static"
./configure \
    --enable-cross-compile --cross-prefix=${CROSS_COMPILE} --arch=armel --target-os=linux \
    --disable-shared --enable-static \
    --disable-ffplay --disable-ffprobe --disable-doc
make -j 8

rm -f ../host/FFmpeg-build/ffmpeg
cp ffmpeg ../host/FFmpeg-build/

file ffmpeg
