#!/bin/bash

# --- CONFIGURATION ---
# 1. Path to your wallpapers folder
WALLPAPER_DIR="$HOME/.local/share/wallpapers"

# 2. Path to your Sway config
SWAY_CONFIG="$HOME/.config/sway/config"

# 3. Path to the theme updater we made earlier
THEME_UPDATER="$HOME/.local/bin/update_colors.sh"

# --- LOGIC ---

# Check directories exist
if [ ! -d "$WALLPAPER_DIR" ]; then
    echo "Error: Directory $WALLPAPER_DIR does not exist."
    exit 1
fi

# 1. Select a random file (jpg, png, jpeg)
# 'shuf -n 1' picks one random line from the list
RANDOM_BG=$(find "$WALLPAPER_DIR" -type f \( -name "*.jpg" -o -name "*.png" -o -name "*.jpeg" \) | shuf -n 1)

if [ -z "$RANDOM_BG" ]; then
    echo "Error: No images found in $WALLPAPER_DIR"
    exit 1
fi

echo "Selected Wallpaper: $RANDOM_BG"

# 2. Update Sway Config (Persistence)
# This finds the 'output * bg ... fill' line and replaces the image path.
# We use | as a delimiter because file paths contain /.
sed -i "s|\(output .* bg \).*\( fill\)|\1$RANDOM_BG\2|" "$SWAY_CONFIG"

# 3. Apply Wallpaper Instantly (Sway)
# We use swaymsg so we don't have to reload the whole window manager
swaymsg output "*" bg "$RANDOM_BG" fill

# 4. Update Colors (Waybar/SwayNC)
# We call the previous script because it handles the Pywal generation and color sanitizing
if [ -x "$THEME_UPDATER" ]; then
    echo "Triggering theme update..."
    "$THEME_UPDATER"
else
    echo "Warning: $THEME_UPDATER not found. Colors not updated."
fi
