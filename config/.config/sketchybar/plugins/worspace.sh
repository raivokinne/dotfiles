#!/bin/sh
# This script outputs the currently focused workspace.
# Adjust the command below according to your AeroSpace setup.
# For example, if AeroSpace updates FOCUSED_WORKSPACE or if you can query it:
if [ -z "$FOCUSED_WORKSPACE" ]; then
  FOCUSED_WORKSPACE=$(aerospace list-workspaces --all | head -n 1)
fi

echo "$FOCUSED_WORKSPACE"

