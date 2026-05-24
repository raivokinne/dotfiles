#!/bin/bash

case "$1" in
  area)
    grim -g "$(slurp -b '#2E2A1E55' -c '#fb751bff')" -t ppm - | satty -f -
    ;;
  full)
    grim -t png ~/Pictures/Screenshots/$(date +%Y-%m-%d_%H-%M-%S).png
    notify-send "Screenshot saved" "~/med/pictures/"
    ;;
  window)
    grim -g "$(swaymsg -t get_tree 2>/dev/null | jq -r '.. | select(.focused?) | .rect | "\(.x),\(.y) \(.width)x\(.height)"')" -t ppm - | satty -f -
    ;;
  *)
    grim -g "$(slurp -b '#2E2A1E55' -c '#fb751bff')" -t ppm - | satty -f -
    ;;
esac
