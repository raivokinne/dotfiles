#!/bin/bash
DISK=$(df -h / | grep / | awk '{print $5}')
sketchybar --set "$NAME" label="$DISK"

