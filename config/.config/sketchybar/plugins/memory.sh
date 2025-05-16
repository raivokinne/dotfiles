#!/bin/bash
MEMORY=$(memory_pressure | grep "System-wide memory free percentage:" | cut -d " " -f6)
USED=$(echo "100 - $MEMORY" | bc)
sketchybar --set "$NAME" label="${USED}%"

