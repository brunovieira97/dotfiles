#!/bin/bash

BASE_PATH="$(cd "$(dirname "$0")" && pwd)"

PRODUCT_NAME=$(sw_vers -productName)
PRODUCT_VERSION=$(sw_vers -productVersion)

# Dependencies
source "$BASE_PATH/core.sh"
source "$BASE_PATH/functions.sh"

# Ask for the administrator password upfront
sudo -v

printf "\n💻 Dotfiles setup\n\n"
print_info "Running on ${PRODUCT_NAME} ${PRODUCT_VERSION}"

# Keep-alive: update existing `sudo` timestamp until script has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

# Persists keep-alive loop PID for killing it later
SUDO_KEEPALIVE_PID=$!

touch "$HOME/.hushlogin" &> /dev/null

print_title "Xcode Tools"
setup_xcode_tools

print_title "Homebrew"
setup_homebrew

print_title "Zsh + Oh-My-Zsh"
setup_zsh

print_title "Mise-en-place"
setup_mise

print_title "MacOS"
setup_macos

print_title "SSH"
setup_ssh

print_title "Git"
setup_git

print_title "Vim"
setup_vim

print_title "Bat"
setup_bat

print_title "cURL"
setup_curl

print_title "Ghostty"
setup_ghostty

print_title "VSCodium"
setup_vscodium

print_title "IntelliJ IDEA"
setup_intellij_idea

kill "$SUDO_KEEPALIVE_PID" 2>/dev/null

printf "Setup finished. It is advised to reboot now.\n"
read -p "Do you want to reboot? [y/N] " -n 1 -r
printf "\n"

if [[ $REPLY =~ ^[Yy]$ ]]
then
    sudo reboot
else
    exit 0
fi
