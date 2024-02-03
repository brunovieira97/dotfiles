#!/bin/bash

BASE_PATH="$(cd "$(dirname "$0")" && pwd)"

PRODUCT_NAME=$(sw_vers -productName)
PRODUCT_VERSION=$(sw_vers -productVersion)

# Dependencies
source "$BASE_PATH/bin/core.sh"
source "$BASE_PATH/bin/functions.sh"

# Ask for the administrator password upfront
sudo -v

printf "\n💻 Dotfiles uninstaller\n\n"
print_info "Running on ${PRODUCT_NAME} ${PRODUCT_VERSION}"

# Keep-alive: update existing `sudo` timestamp until script has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

print_title "Dotfiles"
print_step_ln "Deleting symlinks"
rm -f "$HOME/.asdfrc"
rm -f "$HOME/.gitconfig"
rm -f "$HOME/.vimrc"
rm -f "$HOME/.zprofile"
rm -f "$HOME/.zshrc"
rm -f "$HOME/.config/bat"
rm -f "$HOME/.ssh/allowed_signers"
rm -f "$HOME/.ssh/config"

print_title "Homebrew"
print_step_ln "Deleting /opt/homebrew"
sudo rm -rf "/opt/homebrew"
print_step_ln "Removing fonts installed as casks"
sudo rm -f $HOME/Library/Fonts/*.ttf

print_title "OhMyZsh"
print_step_ln "Deleting $HOME/.oh-my-zsh"
rm -rf "$HOME/.oh-my-zsh"

print_info "Finished."