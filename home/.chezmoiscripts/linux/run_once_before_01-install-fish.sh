#!/usr/bin/env bash
# Script to install fish shell and set it as default shell

set -eo pipefail

# Check if fish is already installed
if command -v fish &>/dev/null; then
    echo "✓ Fish shell is already installed!"
    exit 0
fi

echo "Installing fish shell..."

# Install fish based on OS
# We're assuming brew is already installed
case $(uname) in
    Linux|Darwin)
        brew install fish
        ;;
    *)
        echo "Unsupported operating system: $(uname)"
        exit 1
        ;;
esac

# Set fish as default shell if it's not already
if [[ "$SHELL" != *fish* ]]; then
    fish_path=$(command -v fish)
    
    # Check if fish is already in /etc/shells
    if ! grep -q "$fish_path" /etc/shells; then
        echo "Adding fish to /etc/shells..."
        echo "$fish_path" | sudo tee -a /etc/shells
    fi
    
    echo "Setting fish as default shell..."
    chsh -s "$fish_path"
    
    echo "✓ Default shell changed to fish. Changes will take effect after you log out and back in."
else
    echo "✓ Fish is already your default shell."
fi

echo "✓ Fish shell setup complete!"