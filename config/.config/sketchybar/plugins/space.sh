#!/bin/bash
SPACE_ID=$(echo "$NAME" | sed 's/space\.//')
SELECTED=$(yabai -m query --spaces --space | jq -r '.index')

if [[ $SELECTED == $SPACE_ID ]]; then
  sketchybar --set "$NAME" background.color=0xffffffff icon.color=0xff000000
else
  sketchybar --set "$NAME" background.color=$TRANSPARENT icon.color=0xffffffff
fi

# Show indicator for windows in this space
WINDOWS=$(yabai -m query --spaces --space "$SPACE_ID" | jq -r '.windows | length')
if [[ $WINDOWS -gt 0 ]]; then
  sketchybar --set "$NAME" icon.background.color=0x40ffffff
else
  sketchybar --set "$NAME" icon.background.color=0x00000000
fi

