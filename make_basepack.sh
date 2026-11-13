#!/bin/zsh
# Builds base.zip (the textures and sound) from YOUR OWN US ROM.
# Put baserom.us.z64 in this folder first. Needs the same toolchain as build_switch2.sh.
cd "$(dirname "$0")"
[ -f baserom.us.z64 ] || { echo "Missing baserom.us.z64 in $(pwd)"; exit 1; }
./build_switch2.sh EXTERNAL_DATA=1 res || exit 1
echo
echo "Done. Copy this file to the SD card as /switch/sm64ex-alo/sm64ex_res/base.zip:"
echo "  $(pwd)/build/us_nx/sm64ex_res/base.zip"
