#!/bin/bash

# 1. Get the list of sinks (outputs) with their ID and Description
# We parse 'pactl' output to look nice in Fuzzel
sinks=$(pactl list sinks | grep -E 'Sink #|Description:' | sed 's/Sink #//' | sed 's/Description: //')

# 2. Format it into pairs (ID matches Description)
# This loop pairs the ID line with the Description line
list=""
current_id=""
while IFS= read -r line; do
    if [[ "$line" =~ ^[0-9]+$ ]]; then
        current_id="$line"
    else
        list="$list$current_id: $line\n"
    fi
done <<< "$sinks"

# 3. Show the menu in Fuzzel
# -d: dmenu mode (text input)
# -w 40: width
# -l 5: shows 5 lines
selected=$(echo -e "$list" | fuzzel -d -w 40 -l 5 -p "Audio Out: ")

# 4. Set the default sink
if [ -n "$selected" ]; then
    # Extract the ID (the number before the colon)
    target_id=$(echo "$selected" | cut -d: -f1)
    
    # Set as default
    pactl set-default-sink "$target_id"
    
    # (Optional) Move all currently playing audio to the new device immediately
    inputs=$(pactl list short sink-inputs | cut -f1)
    for input in $inputs; do
        pactl move-sink-input "$input" "$target_id"
    done
fi
