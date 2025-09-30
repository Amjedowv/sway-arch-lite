#!/usr/bin/env bash

set -e

echo "[*] Updating system..."
sudo pacman -Syu --noconfirm

echo "[*] Installing base dependencies..."
sudo pacman -S --noconfirm \
    sway \
    waybar \
    wofi \
    alacritty \
    swaylock-effects \
    kanshi \
    grim \
    slurp \
    jq \
    playerctl \
    wl-clipboard \
    mako \
    polkit-gnome \
    network-manager-applet \
    bluez bluez-utils \
    pavucontrol \
    pipewire pipewire-pulse wireplumber \
    brightnessctl \
    noto-fonts noto-fonts-emoji ttf-jetbrains-mono-nerd \
    unzip git

echo "[*] Enabling services..."
sudo systemctl enable --now NetworkManager
sudo systemctl enable --now bluetooth

echo "[*] Setting up configuration..."
CONFIG_DIR="$HOME/.config"
mkdir -p $CONFIG_DIR

# Copy repo configs
cp -r .config/* "$CONFIG_DIR/"
cp powermenu.sh screenshot.sh "$HOME/.local/bin/"

# Make scripts executable
chmod +x "$HOME/.local/bin/powermenu.sh"
chmod +x "$HOME/.local/bin/screenshot.sh"

echo "[*] Install complete!"
echo "Log out and choose 'sway' from TTY to start."
