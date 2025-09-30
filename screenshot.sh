#!/usr/bin/env bash

dir="$HOME/Pictures/Screenshots"
mkdir -p "$dir"

choice=$(printf " Full Screen\n Active Window\n Selection" | \
  wofi --dmenu --cache-file /dev/null --prompt "Screenshot")

timestamp=$(date +%Y-%m-%d_%H-%M-%S)

case "$choice" in
  " Full Screen")
    grim "$dir/screenshot_$timestamp.png"
    ;;
  " Active Window")
    swaymsg -t get_tree | jq -r '.. | select(.focused?) | .rect | "\(.x),\(.y) \(.width)x\(.height)"' \
      | xargs grim -g "$dir/screenshot_$timestamp.png"
    ;;
  " Selection")
    slurp | xargs grim -g "$dir/screenshot_$timestamp.png"
    ;;
esac

notify-send "Screenshot saved to $dir"

