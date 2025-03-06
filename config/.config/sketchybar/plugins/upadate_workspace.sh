#!/bin/zsh

# Get the focused workspace from the event
FOCUSED_WORKSPACE="$AEROSPACE_FOCUSED_WORKSPACE"

# Loop through workspaces and update their style dynamically
for i in {1..10}; do
  if [[ "$i" -eq "$FOCUSED_WORKSPACE" ]]; then
    # Neon glow effect on active workspace
    sketchybar --set space.$i icon="" icon.color=0xff00ffff \
               background.color=0xff101010 background.corner_radius=12
  else
    # Dim inactive workspaces
    sketchybar --set space.$i icon="" icon.color=0x60ffffff \
               background.color=0x60304040 background.corner_radius=8
  fi
done

