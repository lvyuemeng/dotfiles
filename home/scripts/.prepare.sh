#!/bin/bash

detect_distro() {
  [ -f "/etc/os-release" ] && . /etc/os-release
  echo "${ID:-unknown}"
}

DISTRO=$(detect_distro)

command_exists() {
  command -v "$1" &>/dev/null
}

install_homebrew() {
  if command_exists brew; then
    echo "homebrew installed."
    return 0
  fi

  export HOMEBREW_BREW_GIT_REMOTE="https://mirrors.ustc.edu.cn/brew.git"
  export HOMEBREW_CORE_GIT_REMOTE="https://mirrors.ustc.edu.cn/homebrew-core.git"
  export HOMEBREW_BOTTLE_DOMAIN="https://mirrors.ustc.edu.cn/homebrew-bottles"
  export HOMEBREW_API_DOMAIN="https://mirrors.ustc.edu.cn/homebrew-bottles/api"

  /bin/bash -c "$(curl -fsSL https://mirrors.ustc.edu.cn/misc/brew-install.sh)"

  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
  echo "eval \"\$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)\"" >> ~/.bash_profile
  return 0
}

install_package() {
  local package_name="$1"
  local use_homebrew="${2:-false}"

  echo "Install '$package_name'..."
  
  if [[ "$use_homebrew" == "true" ]]; then
    if ! command_exists brew ; then
      echo "install homebrew..."
      install_homebrew || {
        echo "Homebrew setup failed."
        return 1
      }
    fi
    brew install "$package_name"
    return 0
  fi

  case "$DISTRO" in
  ubuntu | debian)
    sudo apt update && sudo apt install -y "$package_name"
    ;;
  fedora | centos | rhel | almalinux | rocky)
    sudo dnf install -y "$package_name"
    ;;
  arch | manjaro)
    sudo pacman -Sy --noconfirm "$package_name"
    ;;
  opensuse-leap | opensuse-tumbleweed)
    sudo zypper install -y "$package_name"
    ;;
  *)
    echo "Unsupported distribution for install: $DISTRO." >&2
    return 1
    ;;
  esac
  return 0
}

if command_exists rage; then
    echo "rage installed."
else
    install_package "rage" true
fi