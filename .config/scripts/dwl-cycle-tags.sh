#!/bin/sh

dir="$1"  # "left" or "right"

output=$(dwlmsg -g 2>/dev/null | grep " tags " | head -1)
[ -z "$output" ] && exit 1

set -- $output
seltags=$4

[ -z "$seltags" ] && exit 1

# seltags is a bitmask, find the current tag index
i=0
tag=-1
while [ $i -lt 9 ]; do
  if [ $((seltags >> i & 1)) -eq 1 ]; then
    tag=$i
    break
  fi
  i=$((i + 1))
done

[ $tag -lt 0 ] && exit 1

if [ "$dir" = "left" ]; then
  newtag=$(( (tag + 8) % 9 ))
else
  newtag=$(( (tag + 1) % 9 ))
fi

dwlmsg -s -t "$newtag"
