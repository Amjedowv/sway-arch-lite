#!/usr/bin/env bash
set -e

echo "[1/6] Installing dependencies…"
sudo apt update
sudo apt install -y \
    build-essential meson ninja-build pkg-config \
    libwayland-dev libxkbcommon-dev libinput-dev \
    libpixman-1-dev libdrm-dev libgbm-dev \
    libegl-dev libgles-dev libglvnd-dev \
    libseat-dev libudev-dev wayland-protocols

echo "[2/6] Removing Debian wlroots…"
sudo apt remove -y wlroots-dev || true

echo "[3/6] Installing wlroots (SceneFX fork)…"
https://github.com/wlrfx/scenefx.git --depth=1
cd wlroots
git checkout scenefx-0.4.0
meson setup build --prefix=/usr
ninja -C build
sudo ninja -C build install
cd ..

echo "[4/6] Installing SceneFX…"
git clone https://github.com/wlrfx/scenefx.git --depth=1
cd scenefx
git checkout 0.4.1
meson setup build --prefix=/usr
ninja -C build
sudo ninja -C build install
cd ..

echo "[5/6] Installing MangoWC…"
git clone https://github.com/DreamMaoMao/mangowc.git --depth=1
cd mangowc
meson setup build --prefix=/usr
ninja -C build
sudo ninja -C build install
cd ..

echo "[6/6] DONE!"
echo "Run MangoWC with:  mango"
