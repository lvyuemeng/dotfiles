#!/bin/bash

# Determine if Nix is already installed
if command -v nix >/dev/null 2>&1; then
  echo "Nix is already installed. Skipping installation."
else
  echo "Nix not found. Installing Determinate Nix..."

  # Run the Determinate Systems installer
  # --no-confirm makes it non-interactive (perfect for scripts)
  curl -fsSL https://install.determinate.systems/nix | sh -s -- install

  # Load Nix into the current shell session so subsequent scripts can use it
  if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
    . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
  fi
fi
