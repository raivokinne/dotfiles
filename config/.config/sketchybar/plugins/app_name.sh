#!/bin/bash

# Retrieve the name of the frontmost application
APP_NAME=$(osascript -e 'tell application "System Events" to get name of first application process whose frontmost is true')

# If APP_NAME is empty, default to "Desktop"
if [ -z "$APP_NAME" ]; then
  APP_NAME="Desktop"
fi

# Update SketchyBar with the application name
sketchybar --set "$NAME" label="$APP_NAME"

