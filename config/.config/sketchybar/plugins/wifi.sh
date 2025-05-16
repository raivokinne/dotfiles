#!/bin/bash

# Retrieve the current Wi-Fi SSID
WIFI=$(networksetup -getairportnetwork en0 | awk -F': ' '{print $2}')

# Define icons for Wi-Fi status
CONNECTED_ICON="📶"
DISCONNECTED_ICON="🚫"

# Determine icon and label based on Wi-Fi connection status
if [ -z "$WIFI" ] || [ "$WIFI" = "You are not associated with an AirPort network." ]; then
  ICON=$DISCONNECTED_ICON
  LABEL="Disconnected"
else
  ICON=$CONNECTED_ICON
  LABEL="$WIFI"
fi

# Update SketchyBar item
sketchybar --set $NAME icon="$ICON" label="$LABEL"

