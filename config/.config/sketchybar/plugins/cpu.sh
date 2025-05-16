#!/bin/bash
CPU=$(top -l 1 | grep -E "^CPU" | grep -Eo '[0-9\.]+% idle' | cut -d% -f1)
CPU_USAGE=$(echo "100 - $CPU" | bc)
sketchybar --set "$NAME" label="${CPU_USAGE}%"

