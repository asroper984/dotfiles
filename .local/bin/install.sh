#!/bin/bash

# Configuration
PKG_FILE="packages.txt"

# Colors for formatting
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # No Color

log() {
    echo -e "${BLUE}[SETUP]${NC} $1"
}

error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

# 1. Pre-flight Checks
if [ "$EUID" -eq 0 ]; then
    error "Please do not run this script as root."
    echo "Yay and makepkg should be run as a normal user with sudo privileges."
    exit 1
fi

if [ ! -f "$PKG_FILE" ]; then
    error "Could not find $PKG_FILE."
    echo "Please create a file named '$PKG_FILE' with your list of packages."
    exit 1
fi

# 2. Update System and Install Base Dependencies
log "Updating system and installing base-devel/git..."
sudo pacman -Syu --needed --noconfirm base-devel git

# 3. Check for and Install Yay
if command -v yay &> /dev/null; then
    success "Yay is already installed."
else
    log "Yay not found. Installing Yay..."
    
    # Create a temporary directory for building
    BUILD_DIR=$(mktemp -d)
    git clone https://aur.archlinux.org/yay.git "$BUILD_DIR/yay"
    
    cd "$BUILD_DIR/yay" || exit
    makepkg -si --noconfirm
    
    # Cleanup
    cd ~ || exit
    rm -rf "$BUILD_DIR"
    
    if command -v yay &> /dev/null; then
        success "Yay installed successfully."
    else
        error "Yay installation failed."
        exit 1
    fi
fi

# 4. Read Packages from File
log "Reading packages from $PKG_FILE..."

# Read file, ignore comments (#) and empty lines
packages=()
while IFS= read -r line || [[ -n "$line" ]]; do
    # Remove leading/trailing whitespace
    line=$(echo "$line" | xargs)
    
    # Skip comments and empty lines
    if [[ "$line" =~ ^#.* ]] || [[ -z "$line" ]]; then
        continue
    fi
    
    packages+=("$line")
done < "$PKG_FILE"

if [ ${#packages[@]} -eq 0 ]; then
    log "No packages found in $PKG_FILE to install."
    exit 0
fi

# 5. Install Packages
log "Installing ${#packages[@]} packages..."
echo "Targets: ${packages[*]}"

# Use yay to install (handles both Repo and AUR)
yay -S --needed --noconfirm "${packages[@]}"

success "Installation complete!"
