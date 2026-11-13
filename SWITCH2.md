# Building sm64ex-alo for Nintendo Switch 2 (libounce)

This branch builds [sm64ex-alo](https://github.com/AloUltraExt/sm64ex-alo) for the
Switch 2 against **libounce**, a libnx-compatible library with OunceVK (Vulkan,
EGL, OpenGL ES), instead of libnx. The output is a homebrew `.nro`.

No ROM or game assets are in this repository. You must supply your own legally
obtained US ROM.

## Credits

The build instructions were adapted from the GBAtemp thread
[Building SM64 for Nintendo Switch from sm64ex-alo repository](https://gbatemp.net/threads/building-sm64-for-nintendo-switch-from-sm64ex-alo-repository.652092/).

## Requirements

- devkitPro at `/opt/devkitpro` with `DEVKITPRO` and `DEVKITA64` exported.
- The Switch 2 SDK (`ounce-devkit`, tested with 20261113f). It provides
  `$DEVKITPRO/libounce` and `$DEVKITPRO/portlibs/switch2`.
- The Switch 1 portlibs (SDL2, zlib and the rest):

  ```
  sudo dkp-pacman -S switch-sdl2 switch-libogg switch-libvorbis switch-libtheora switch-glad switch-zlib switch-pkg-config
  ```

  If `$DEVKITPRO/portlibs/switch` is empty after installing the Switch 2 SDK,
  run that command again.
- Python 3 (asset extraction) and a host C compiler (the tools in `tools/`).
- Your US ROM saved as `baserom.us.z64` in the repository root (SHA-1 in
  `sm64.us.sha1`). It is gitignored. Do not commit it.

## Build

```
./build_switch2.sh
```

The script sets `DEVKITPRO`, puts the devkitPro tools on `PATH`, and runs:

```
make TARGET_SWITCH=1 BETTERCAMERA=1 NODRAWINGDISTANCE=1 TEXTURE_FIX=1 HIGH_FPS_PC=1 -j8
```

Extra arguments are passed to make. To build without the extras, run `make`
yourself with `TARGET_SWITCH=1` and the devkitPro environment above.

Notes on the options:
- `BETTERCAMERA`, `NODRAWINGDISTANCE` and `HIGH_FPS_PC` are defined by this
  repository and take effect.
- `TEXTURE_FIX` is not used anywhere in this repository. It is harmless.

The first build extracts assets from the ROM into the working tree (all
gitignored) and builds the host tools.

Output: `build/us_nx/sm64.us.f3dex2e.nro`

The Makefile does not track every header dependency. Delete `build/` after
editing headers or changing make options.

## Install and run

Copy the `.nro` to `sdmc:/switch/sm64ex-alo/` and launch it from the homebrew
menu. The game writes its config and save file next to it.

## Changes from the upstream libnx Switch build (all in `Makefile`)

1. **libounce instead of libnx.** In the `TARGET_SWITCH` block:
   - `LIBNX := $(DEVKITPRO)/libounce`
   - `PORTLIBS_SWITCH2 := $(DEVKITPRO)/portlibs/switch2`, added to `PATH`
   - `NXARCH += -D__SWITCH2__`
   - `$(PORTLIBS_SWITCH2)/include` is added to `INCLUDE_DIRS` before the
     Switch 1 portlibs.
   - `-L$(PORTLIBS_SWITCH2)/lib -L$(LIBNX)/lib` is added to `LDFLAGS`, so
     `-lnx` is libounce and EGL and GLES come from OunceVK.
2. **GLES and EGL.** On Switch, `-lGLESv2` is replaced with
   `$(PKGCONFIG_NX) --libs glesv2 egl`, using the Switch 2 pkg-config
   (`$(PORTLIBS_SWITCH2)/bin/aarch64-none-elf-pkg-config`).
3. **No Mac-native toolchain for Switch builds.** The `Darwin` override block
   (Homebrew/MacPorts gcc) is skipped when `TARGET_SWITCH=1`, so the cross
   compiler is used.
4. **macOS make 3.81 compatibility** (the system make on macOS):
   - Every `DUMMY != cmd` became `DUMMY := $(shell cmd)`.
   - `define level_rules =` in `Makefile.split` became `define level_rules`.
   - The build directory is created before `Makefile.split` is included
     (`BUILD_DIR_INIT`), since `level_rules.mk` is generated into it.
   With GNU make 4 or newer these changes are harmless.

5. **Switch 2 CPU flags.** `NXARCH` uses `SWITCH2_CPU` (Cortex-A78C) from
   `$(LIBNX)/switch2_cpu.mk` instead of the Switch 1 flags. The resulting NRO
   does not run on a Switch 1.
6. **1080p window in handheld and docked.** In `src/pc/gfx/gfx_sdl2.c`, the
   Switch window is always 1920x1080. Upstream picks 1920x1080 docked and
   1280x720 handheld, but the Switch 2 screen is 1080p in both modes.

The frame limiter is the upstream one, with no changes. The upstream Switch
icon (`platform/switch/logo.jpg`) is used.

## Troubleshooting

- `SDL.h: No such file or directory`: the Switch 1 portlibs are empty; reinstall
  them as above.
- `Failed to open baserom.us.z64`: place your ROM in the repository root.
- `No suitable macOS toolchain found`: the Darwin override change (item 3) is
  missing.
- `build/us_nx/level_rules.mk: No such file or directory`: run
  `mkdir -p build/us_nx` once, or apply item 4.
- `Could not initialize EGL` on a second launch: relaunch hbmenu.
