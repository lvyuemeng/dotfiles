#!/bin/bash

# Install Nerd Fonts
# Downloads fonts directly from GitHub releases

set -euo pipefail

# Configuration
FONT_DIR="${HOME}/.local/share/fonts"
FONTS=("0xProto")

echo "Installing Nerd Fonts..."

# Check if already installed
if [ -d "$FONT_DIR" ]; then
    all_installed=true
    for font in "${FONTS[@]}"; do
        if ! find "$FONT_DIR" -name "*${font}*.ttf" -o -name "*${font}*.otf" 2>/dev/null | grep -q .; then
            all_installed=false
            break
        fi
    done
    
    if [ "$all_installed" = true ]; then
        echo "All fonts already installed"
        exit 0
    fi
fi

# Create font directory if needed
mkdir -p "$FONT_DIR"

# Install each font
for font in "${FONTS[@]}"; do
    echo "Installing $font..."
    
    # Create temp directory
    temp_dir=$(mktemp -d)
    
    # Download and extract
    if curl -fsSL "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/${font}.tar.xz" -o "${temp_dir}/${font}.tar.xz"; then
        tar -xf "${temp_dir}/${font}.tar.xz" -C "$temp_dir"
        find "$temp_dir" -type f \( -name "*.ttf" -o -name "*.otf" \) -exec cp -n {} "$FONT_DIR/" \;
        echo "  ✓ $font installed"
    else
        echo "  ✗ Failed to download $font" >&2
    fi
    
    # Cleanup
    rm -rf "$temp_dir"
done

# Update font cache if available
if command -v fc-cache &>/dev/null; then
    fc-cache -f "$FONT_DIR" >/dev/null
    echo "Font cache updated"
fi

echo "Font installation complete."