#!/bin/bash
WIFI=$(networksetup -getairportpower en0 | grep "On")
IP=$(ipconfig getifaddr en0 2>/dev/null || echo "No IP")

if [[ -n $WIFI ]]; then
  SSID=$(networksetup -getairportnetwork en0 | cut -d: -f2 | xargs)
  sketchybar --set "$NAME" icon="󰖩" label="$SSID"
else
  sketchybar --set "$NAME" icon="󰖪" label="Offline"
fi

