#!/bin/bash

# --- CONFIG ---
THEME_NAME="one"  # Options: github, gruvbox, catppuccin, tokyo_night
GTK_LIGHT="Adwaita"
GTK_DARK="Adwaita-dark"

# --- PATHS ---
THEME_DIR="$HOME/.config/alacritty/themes/themes"
ALACRITTY_CONFIG="$HOME/.config/alacritty/alacritty.toml"

# --- TIME ---
MORNING=7
EVENING=17
current_hour=$(date +%H)

set_light() {
    echo " -> Light Mode ($THEME_NAME)..."
    gsettings set org.gnome.desktop.interface gtk-theme "$GTK_LIGHT"
    gsettings set org.gnome.desktop.interface color-scheme 'prefer-light'

    # Alacritty: Replace the import line (at the top of file)
    sed -i "s|^import = .*|import = [ \"$THEME_DIR/${THEME_NAME}_light.toml\" ]|" "$ALACRITTY_CONFIG"
    
    
    # Fuzzel
    [ -f ~/.config/fuzzel/fuzzel-light.ini ] && cp ~/.config/fuzzel/fuzzel-light.ini ~/.config/fuzzel/fuzzel.ini
}

set_dark() {
    echo " -> Dark Mode ($THEME_NAME)..."
    gsettings set org.gnome.desktop.interface gtk-theme "$GTK_DARK"
    gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'

    # Alacritty
    sed -i "s|^import = .*|import = [ \"$THEME_DIR/${THEME_NAME}_dark.toml\" ]|" "$ALACRITTY_CONFIG"

    
    # Fuzzel
    [ -f ~/.config/fuzzel/fuzzel-dark.ini ] && cp ~/.config/fuzzel/fuzzel-dark.ini ~/.config/fuzzel/fuzzel.ini
}

if [ "$current_hour" -ge "$MORNING" ] && [ "$current_hour" -lt "$EVENING" ]; then
    set_light
else
    set_dark
fi
