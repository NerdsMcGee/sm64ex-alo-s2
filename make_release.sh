#!/usr/bin/env bash
# Builds the release package: an NRO WITHOUT textures or sound (EXTERNAL_DATA=1).
# base.zip is never included. Output: release/sm64ex-alo-s2-<devkit version>.zip
cd "$(dirname "$0")" || exit 1
./build_switch2.sh EXTERNAL_DATA=1 || exit 1
DEVKITPRO="${DEVKITPRO:-/opt/devkitpro}"
V=$(head -1 "$DEVKITPRO"/ounce-devkit-version.txt | awk '{print $2}')
NAME=sm64ex-alo-s2-$V
rm -rf release/$NAME release/$NAME.zip
mkdir -p release/$NAME
cp build/us_nx/sm64.us.f3dex2e.nro release/$NAME/sm64ex-alo.nro
cp RELEASE_README.txt release/$NAME/README.txt
(cd release/$NAME && shasum -a 256 sm64ex-alo.nro > SHA256SUMS)
(cd release && zip -qr $NAME.zip $NAME)
echo "Built release/$NAME.zip"
