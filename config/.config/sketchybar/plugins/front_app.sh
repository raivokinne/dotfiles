#!/bin/sh
# Get the app name of the first window on the focused workspace.
# (FOCUSED_WORKSPACE is assumed to be set by AeroSpace callbacks)
FRONTAPP=$(aerospace list-windows --workspace "$FOCUSED_WORKSPACE" | awk -F '\\| *' '{print $2}' | head -n 1)
ICON=""

case "$FRONTAPP" in
  "Safari")   ICON="󰀹" ;;
  "Chrome")   ICON="󰊯" ;;
  "Firefox")  ICON="󰈹" ;;
  "Terminal") ICON="󰆍" ;;
  "iTerm2")   ICON="󰆍" ;;
  "kitty")    ICON="󰆍" ;;
  "Code")     ICON="󰨞" ;;
  "Xcode")    ICON="󰙅" ;;
  "Finder")   ICON="󰀶" ;;
  "Mail")     ICON="󰇮" ;;
  "Slack")    ICON="󰒱" ;;
  "Discord")  ICON="󰙯" ;;
  "Spotify")  ICON="󰓇" ;;
  "Music")    ICON="󰎄" ;;
  "Calendar") ICON="󰃭" ;;
  "Preview")  ICON="󰋲" ;;
  "Keynote")  ICON="󰐨" ;;
  "Pages")    ICON="󱔗" ;;
  "Numbers")  ICON="󰄄" ;;
  *)          ICON="󰣆" ;;
esac

sketchybar --set "$NAME" icon="$ICON" label="$FRONTAPP"

