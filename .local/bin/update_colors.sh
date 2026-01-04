#!/bin/bash

# --- CONFIG ---
SWAY_CONFIG="$HOME/.config/sway/config"
CACHE_FILE="$HOME/.cache/wal/colors-waybar.css"

# 1. FIND WALLPAPER
WALLPAPER=$(grep -E '^\s*output.*bg\s+\S+\s+fill' "$SWAY_CONFIG" | head -n 1 | sed -E 's/^\s*output.*bg\s+(\S+)\s+fill.*/\1/')
WALLPAPER="${WALLPAPER/#\~/$HOME}"

if [ -z "$WALLPAPER" ] || [ ! -f "$WALLPAPER" ]; then
    echo "Error: Wallpaper not found."
    exit 1
fi

# 2. GENERATE COLORS (Terminal Safe Mode)
# -n: Don't set wallpaper (Sway does it)
# -s: SKIP terminal color changes (Keeps your Alacritty/Terminal theme intact)
# -t: SKIP tty color changes
# -q: Quiet
# --saturate 0.7: High saturation for the UI elements
wal -i "$WALLPAPER" -n -s -t -q --saturate 0.7

# 3. SANITIZE COLORS (No Pure White / No Pure Black)
if [ -f "$CACHE_FILE" ]; then
    # Replace #ffffff (Pure White) with #e1e1e6 (Soft White)
    sed -i 's/#ffffff/#e1e1e6/Ig' "$CACHE_FILE"
    # Replace #000000 (Pure Black) with #151515 (Dark Grey)
    sed -i 's/#000000/#151515/Ig' "$CACHE_FILE"
fi

# 4. RELOAD BARS
if pgrep -x "waybar" > /dev/null; then killall -SIGUSR2 waybar; fi
if pgrep -x "swaync" > /dev/null; then swaync-client -rs; fi

echo "Theme updated (UI Only): $WALLPAPER"
