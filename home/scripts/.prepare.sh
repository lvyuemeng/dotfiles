#!/usr/bin/env bash
# Script to install rage for chezmoi init preparation

if command -v rage &>/dev/null; then
    echo "rage is already installed!"
    exit 0
fi

# Define brew prefix based on OS
if [[ $(uname) == "Darwin" ]]; then
    BREW_PREFIX="/usr/local"
else 
    BREW_PREFIX="/home/linuxbrew/.linuxbrew"
fi

# Install rage via brew if it exists
if command -v brew &>/dev/null; then
    echo "brew is already installed, installing rage..."
    brew install rage
    exit 0
fi

# Setup brew environment if brew needs to be installed
echo "Setting up environment for brew installation..."
{
    echo 'export HOMEBREW_BREW_GIT_REMOTE="https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/brew.git"'
    echo 'export HOMEBREW_CORE_GIT_REMOTE="https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/homebrew-core.git"'
    echo 'export HOMEBREW_INSTALL_FROM_API=1'
} >> ~/.bashrc

if [[ ! -d "${BREW_PREFIX}/bin" ]]; then
    echo "Installing brew..."
    git clone --depth=1 https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/install.git brew-install
    /bin/bash brew-install/install.sh
    rm -rf brew-install
fi

echo "Configuring brew in shell environment..."
# Handle different potential brew locations
if [[ -d ~/.linuxbrew ]]; then
    eval "$(~/.linuxbrew/bin/brew shellenv)"
elif [[ -d /home/linuxbrew/.linuxbrew ]]; then
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi

# Add brew to shell profile files if they exist
for profile in ~/.bash_profile ~/.profile ~/.zprofile; do
    if [[ -r $profile ]]; then
        echo "eval \"\$($(brew --prefix)/bin/brew shellenv)\"" >> "$profile"
    fi
done

echo "brew installation complete, installing rage..."

echo "Installing rage..."
brew install rage
echo "rage installation complete!"