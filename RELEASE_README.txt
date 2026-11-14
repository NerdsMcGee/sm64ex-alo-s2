sm64ex-alo for Nintendo Switch 2 (libounce)
===========================================

This is an NRO built from https://github.com/AloUltraExt/sm64ex-alo for the
Nintendo Switch 2. Source and build notes (SWITCH2.md) are in the repository
this release came from.

The NRO does NOT contain the game's textures or sound. You must make them from
your own legally obtained US ROM. No ROM or game assets are included here.

Install
-------
1. Copy sm64ex-alo.nro to /switch/sm64ex-alo/ on the SD card.
2. Make base.zip from your own US ROM (see below).
3. Copy base.zip to /switch/sm64ex-alo/sm64ex_res/base.zip
4. Launch it from the homebrew menu.

Making base.zip
---------------
On a computer with the Switch 2 SDK installed (see SWITCH2.md in the source):
1. Clone the source repository and check out the switch2-libounce branch.
2. Save your US ROM in the repository folder as baserom.us.z64
3. Run ./make_basepack.sh
4. The file is build/us_nx/sm64ex_res/base.zip

Verify the download with SHA256SUMS.
Built with: ounce-devkit 20261114. Requires a Switch 2.
