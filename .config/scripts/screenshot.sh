#!/bin/bash

dir="$HOME/pic/Screenshots"
mkdir -p "$dir"
file="$dir/$(date +%Y-%m-%d_%H-%M-%S).png"

capture() {
  [ -n "$1" ] || exit 0

  if command -v satty >/dev/null 2>&1; then
    grim -g "$1" -t png - | tee >(wl-copy -t image/png) | satty -f -
  else
    grim -g "$1" -t png - | tee "$file" | wl-copy -t image/png
    notify-send "Screenshot saved & copied" "$file"
  fi
}

geometry() {
  if [ -n "$HYPRLAND_INSTANCE_SIGNATURE" ] && command -v hyprctl >/dev/null 2>&1; then
    hyprctl activewindow -j | jq -r '"\(.at[0]),\(.at[1]) \(.size[0])x\(.size[1])"'
  else
    swaymsg -t get_tree 2>/dev/null | jq -r '.. | select(.focused?) | .rect | "\(.x),\(.y) \(.width)x\(.height)"'
  fi
}

select_region() {
  slurp -b '#2E2A1E55' -c '#fb751bff'
}

case "$1" in
  area)
    capture "$(select_region)"
    ;;
  full)
    grim -t png - | tee "$file" | wl-copy -t image/png
    notify-send "Screenshot saved & copied" "$file"
    ;;
  window)
    capture "$(geometry)"
    ;;
  *)
    capture "$(select_region)"
    ;;
esac
