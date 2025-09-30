#!/usr/bin/env bash

choice=$(printf " Lock\n󰍃 Logout\n Reboot\n Shutdown" | \
  wofi --dmenu --cache-file /dev/null --prompt "Power")

case "$choice" in
  " Lock") swaylock ;;
  "󰍃 Logout") swaymsg exit ;;
  " Reboot") systemctl reboot ;;
  " Shutdown") systemctl poweroff ;;
esac

