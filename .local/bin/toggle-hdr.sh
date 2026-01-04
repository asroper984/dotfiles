#!/bin/bash

# 1. Get the name of the currently focused output
OUTPUT=$(swaymsg -t get_outputs | jq -r '.[] | select(.focused) | .name')

if [ -z "$OUTPUT" ]; then
    notify-send "HDR Toggle" "No focused output found."
    exit 1
fi

# 2. Define a state file in /tmp (clears on reboot)
STATE_FILE="/tmp/sway_hdr_${OUTPUT}.state"

# 3. Check state and toggle
if [ -f "$STATE_FILE" ]; then
    # State file exists implies HDR is ON -> Turn it OFF
    swaymsg output "$OUTPUT" hdr off
    rm "$STATE_FILE"
    notify-send -u low -t 2000 "HDR Disabled" "Output: $OUTPUT"
else
    # State file missing implies HDR is OFF -> Turn it ON
    swaymsg output "$OUTPUT" hdr on
    touch "$STATE_FILE"
    notify-send -u low -t 2000 "HDR Enabled" "Output: $OUTPUT"
fi
