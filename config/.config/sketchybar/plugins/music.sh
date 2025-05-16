#!/bin/bash
NAME="music"

SPOTIFY_RUNNING=$(osascript -e 'tell application "System Events" to (name of processes) contains "Spotify"')

if [[ "$SPOTIFY_RUNNING" == "true" ]]; then
  PLAYER="Spotify"
elif osascript -e 'tell application "System Events" to (name of processes) contains "Music"' | grep -q "true"; then
  PLAYER="Music"
else
  sketchybar --set "$NAME" icon="󰓛" label="Not Playing"
  exit 0
fi

PLAYING=$(osascript -e "tell application \"$PLAYER\" to player state" 2>/dev/null)

if [[ "$PLAYING" == "playing" ]]; then
  TRACK=$(osascript -e "tell application \"$PLAYER\" to get name of current track" 2>/dev/null)
  ARTIST=$(osascript -e "tell application \"$PLAYER\" to get artist of current track" 2>/dev/null)

  if [[ -n "$TRACK" && -n "$ARTIST" ]]; then
    sketchybar --set "$NAME" icon="󰎄" label="$TRACK - $ARTIST"
  else
    sketchybar --set "$NAME" icon="󰎄" label="Now Playing"
  fi
else
  sketchybar --set "$NAME" icon="󰓛" label="Not Playing"
fi

