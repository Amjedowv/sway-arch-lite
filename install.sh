#!/bin/bash

set -euo pipefail

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

log() { echo -e "${GREEN}[INFO]${NC} $1"; }
warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
error() { echo -e "${RED}[ERROR]${NC} $1" >&2; exit 1; }

# Must NOT run as root
[[ $EUID -eq 0 ]] && error "Do not run as root. Run as your regular user."

# Ensure we're in the dotfiles repo
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"
if [[ ! -f "$SCRIPT_DIR/sway/config" ]]; then
    error "Run this script from the root of the cloned 'dotfiles-sway' repo."
fi

log "Starting full dotfiles deployment with backup..."

# =============
# 1. Install dependencies (pacman + AUR)
# =============
log "Installing system dependencies..."

# Official packages
PACMAN_PKGS=(
    base-devel git sway waybar swaybg swaylock swayidle wl-clipboard
    xdg-utils xdg-desktop-portal xdg-desktop-portal-wlr alacritty firefox
    thunar thunar-archive-plugin thunar-media-tags-plugin tumbler gvfs
    polkit polkit-gnome dmenu rofi feh playerctl pavucontrol bluez
    bluez-utils blueman network-manager-applet nm-connection-editor
    light brightnessctl mako grim slurp xorg-xwayland noto-fonts
    noto-fonts-emoji ttf-font-awesome ttf-dejavu ttf-liberation
    unzip zip rsync htop neofetch jq bat fzf ripgrep
)

sudo pacman -Syu --noconfirm --needed "${PACMAN_PKGS[@]}" || error "Pacman install failed."

# Install yay if missing
if ! command -v yay &>/dev/null; then
    log "Installing yay (AUR helper)..."
    cd /tmp
    git clone --depth=1 https://aur.archlinux.org/yay-bin.git
    cd yay-bin
    makepkg -si --noconfirm || error "Failed to install yay."
    cd "$SCRIPT_DIR"
fi

# AUR packages
AUR_PKGS=(
    wlogout
    sway-notification-center
    ttf-twemoji
    nerd-fonts-fira-code
)
yay -S --noconfirm --needed "${AUR_PKGS[@]}" || error "AUR install failed."

# =============
# 2. Backup & Deploy ALL repo contents
# =============
log "Backing up and deploying dotfiles..."

# Function to safely symlink with backup
safe_link() {
    local source="$1"
    local target="$2"
    local timestamp
    timestamp="$(date +%s)"

    # If target exists and is not our symlink
    if [[ -e "$target" || -L "$target" ]]; then
        # Check if it's already our symlink
        if [[ -L "$target" ]] && [[ "$(readlink "$target")" == "$source" ]]; then
            return 0  # Already correct
        fi
        # Backup existing
        mv "$target" "$target.bak.$timestamp"
        log "Backed up existing $target → $target.bak.$timestamp"
    fi

    # Create parent dir if needed
    mkdir -p "$(dirname "$target")"
    # Create symlink
    ln -sf "$source" "$target"
}

# Deploy ~/.config/* directories
CONFIG_SRC="$SCRIPT_DIR"
CONFIG_DST="$HOME/.config"

# List of config dirs to link (must exist in repo)
CONFIG_DIRS=("sway" "waybar" "alacritty" "rofi" "mako" "swaylock" "swayidle")

for dir in "${CONFIG_DIRS[@]}"; do
    if [[ -d "$CONFIG_SRC/$dir" ]]; then
        safe_link "$CONFIG_SRC/$dir" "$CONFIG_DST/$dir"
    else
        warn "Config dir not found in repo: $dir"
    fi
done

# Deploy top-level dotfiles (hidden files)
DOTFILES=(".bashrc" ".profile" ".xprofile")

for file in "${DOTFILES[@]}"; do
    if [[ -f "$SCRIPT_DIR/$file" ]]; then
        safe_link "$SCRIPT_DIR/$file" "$HOME/$file"
    else
        warn "Dotfile not found in repo: $file"
    fi
done

# =============
# 3. System setup
# =============
log "Enabling systemd user services..."
systemctl --user enable --now sway-session.target &>/dev/null || true

# Backlight permissions (optional but useful)
if [[ -d /sys/class/backlight ]]; then
    log "Setting up backlight group permissions..."
    sudo groupadd -f backlight
    sudo usermod -aG backlight "$USER"
    sudo tee /etc/udev/rules.d/backlight.rules >/dev/null <<'EOF'
ACTION=="add", SUBSYSTEM=="backlight", KERNEL=="*", RUN+="/bin/chgrp backlight /sys/class/backlight/%k/brightness"
ACTION=="add", SUBSYSTEM=="backlight", KERNEL=="*", RUN+="/bin/chmod g+w /sys/class/backlight/%k/brightness"
EOF
    warn "Reboot may be required for backlight control to work."
fi

# =============
# Done
# =============
log "✅ Installation complete!"
echo
echo -e "${GREEN}Next steps:${NC}"
echo "• Log out and select 'Sway' from your login manager (or run 'sway' from TTY)."
echo "• If no display manager: add 'exec sway' to ~/.xinitrc and use 'startx'."
echo "• Your old configs (if any) are backed up with .bak.<timestamp> suffix."
echo "• Enjoy your new Sway setup!"
