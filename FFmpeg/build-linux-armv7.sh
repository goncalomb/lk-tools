#!/bin/sh

set -e
cd -- "$(dirname -- "$0")"

./build.sh linux-armv7:20220202-6ab5c5e
