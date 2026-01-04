#!/bin/bash

# Check if autotiling is running
if pgrep -f "autotiling" > /dev/null
then
    # If running, kill it
    pkill -f "autotiling"
    notify-send "Autotiling" "OFF"
else
    # If not running, start it in the background
    autotiling &
    notify-send "Autotiling" "ON"
fi
