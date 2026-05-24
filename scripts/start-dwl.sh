#!/bin/sh
log="$HOME/.dwl.$(date +%s).log"
exec dwl > "$log" 2>&1
