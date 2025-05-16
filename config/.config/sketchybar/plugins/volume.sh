#!/bin/bash
VOL=$(osascript -e "output volume of (get volume settings)")
MUTED=$(osascript -e "output muted of (get volume settings)")

if [[ $MUTED == "true" ]]; then
  ICON="󰝟"
  sketchybar --set "$NAME" icon="$ICON" label="Muted"
else
  case $VOL in
    100) ICON="󰕾" ;;
    9[0-9]) ICON="󰕾" ;;
    8[0-9]) ICON="󰕾" ;;
    7[0-9]) ICON="󰕾" ;;
    6[0-9]) ICON="󰖀" ;;
    5[0-9]) ICON="󰖀" ;;
    4[0-9]) ICON="󰖀" ;;
    3[0-9]) ICON="󰕿" ;;
    2[0-9]) ICON="󰕿" ;;
    1[0-9]) ICON="󰕿" ;;
    *) ICON="󰝟" ;;
  esac
  sketchybar --set "$NAME" icon="$ICON" label="${VOL}%"
fi

