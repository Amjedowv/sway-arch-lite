````markdown
# 🌌 Sway  Arch Linux

A lightweight **Sway WM rice**
but built for **minimal Arch installs** and optimized for **low-RAM laptops (8GB or less)**.

---

## ✨ Features
- **Sway WM**: lightweight tiling window manager.
- **Waybar**: clean Gruvbox theme with transparency & rounded corners.
- **Wofi**: modern launcher styled like Rofi (no arrows, Gruvbox colors).
- **Alacritty**: GPU-accelerated terminal with Gruvbox Dark.
- **Swaylock**: simple blurred lockscreen.
- **Kanshi**: automatic monitor profile switching.
- **Laptop-friendly**: brightness keys, audio keys, battery monitor.

---

## 📦 Installation

Clone and install in **Arch minimal**:

```bash
git clone https://github.com/Amjedowv/sway-aether-lite
cd sway-aether-lite
chmod +x install.sh
./install.sh
````

Then start Sway:

```bash
sway
```

---

## 🔧 Dependencies

The `install.sh` script will automatically install:

* sway
* waybar
* wofi
* alacritty
* swaylock
* kanshi
* grim + slurp
* playerctl
* JetBrainsMono Nerd Font
* Papirus Icon Theme

---

## 🖼️ Screenshots

*(Add your screenshots here once installed!)*

---

## 🗂️ Repo Structure

sway-aether-lite/
│── install.sh
│── README.md
│── powermenu.sh
│── screenshot.sh       # NEW
│── .config/
│   ├── sway/config
│   ├── waybar/config.jsonc
│   ├── waybar/style.css
│   ├── wofi/style.css
│   ├── alacritty/alacritty.yml
│   ├── swaylock/config
│   └── kanshi/config

---

## 🎯 Goals

* Keep it **lightweight** and usable on budget laptops.
* Match the **look and feel of AetherOS** without the heavy overhead.
* Easy to **clone and install** in one command.

---

## 📜 License

MIT — free to use and modify.

```
```
