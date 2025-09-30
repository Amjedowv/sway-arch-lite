#!/usr/bin/env bash
set -e

echo ">>> Updating system..."
sudo pacman -Syu --noconfirm

# -----------------------------------------------------------
# 1. Install an AUR helper (yay) if missing
# -----------------------------------------------------------
if ! command -v yay &> /dev/null && ! command -v paru &> /dev/null; then
    echo ">>> No AUR helper found. Installing yay..."
    sudo pacman -S --needed --noconfirm base-devel git
    git clone https://aur.archlinux.org/yay.git /tmp/yay
    cd /tmp/yay
    makepkg -si --noconfirm
    cd -
fi

# Pick yay or paru
AUR_HELPER=$(command -v yay || command -v paru)

echo ">>> Using AUR helper: $AUR_HELPER"

# -----------------------------------------------------------
# 2. Install packages
# -----------------------------------------------------------
echo ">>> Installing official packages..."
sudo pacman -S --needed --noconfirm \
    sway waybar wofi alacritty kanshi \
    grim slurp jq playerctl wl-clipboard mako \
    polkit-gnome network-manager-applet \
    bluez bluez-utils \
    pavucontrol pipewire pipewire-pulse wireplumber \
    brightnessctl \
    noto-fonts noto-fonts-emoji unzip git

echo ">>> Installing AUR packages..."
$AUR_HELPER -S --needed --noconfirm \
    swaylock-effects \
    ttf-jetbrains-mono-nerd

# -----------------------------------------------------------
# 3. Enable essential services
# -----------------------------------------------------------
echo ">>> Enabling services..."
sudo systemctl enable --now NetworkManager
sudo systemctl enable --now bluetooth

# -----------------------------------------------------------
# 4. Deploy configs and scripts
# -----------------------------------------------------------
CONFIG_DIR="$HOME/.config"
BIN_DIR="$HOME/.local/bin"

mkdir -p "$CONFIG_DIR"
mkdir -p "$BIN_DIR"

echo ">>> Copying configs..."
cp -r .config/* "$CONFIG_DIR/"

echo ">>> Copying scripts..."
cp powermenu.sh screenshot.sh "$BIN_DIR/"
chmod +x "$BIN_DIR/powermenu.sh" "$BIN_DIR/screenshot.sh"

# -----------------------------------------------------------
# 5. Done!
# -----------------------------------------------------------
echo ">>> Installation complete!"
echo "Log out, then run 'sway' from TTY to start."
