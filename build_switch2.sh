#!/usr/bin/env bash
# Builds sm64ex-alo for Switch 2 (libounce). Extra arguments are passed to make.
export DEVKITPRO="${DEVKITPRO:-/opt/devkitpro}"
export DEVKITA64=$DEVKITPRO/devkitA64
export PATH=$DEVKITPRO/tools/bin:$DEVKITA64/bin:$PATH
cd "$(dirname "$0")" || exit 1
make TARGET_SWITCH=1 BETTERCAMERA=1 NODRAWINGDISTANCE=1 TEXTURE_FIX=1 HIGH_FPS_PC=1 -j8 "$@"
