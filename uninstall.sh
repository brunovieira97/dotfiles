#!/bin/bash

BASE_PATH="$(cd "$(dirname "$0")" && pwd)"

PRODUCT_NAME=$(sw_vers -productName)
PRODUCT_VERSION=$(sw_vers -productVersion)

# Dependencies
source "$BASE_PATH/core.sh"
source "$BASE_PATH/functions.sh"

# Ask for the administrator password upfront
sudo -v

printf "\n💻 Dotfiles uninstaller\n\n"
print_info "Running on ${PRODUCT_NAME} ${PRODUCT_VERSION}"

# Keep-alive: update existing `sudo` timestamp until script has finished
while true; do sudo -n true; sleep 20; kill -0 "$$" || exit; done &> /dev/null &
SUDO_KEEPALIVE_PID=$!

print_title "Dotfiles"
print_step_ln "Deleting symlinks"
rm -f "$HOME/.curlrc" &> /dev/null
rm -f "$HOME/.gitconfig" &> /dev/null
rm -f "$HOME/.vimrc" &> /dev/null
rm -f "$HOME/.zprofile" &> /dev/null
rm -f "$HOME/.zshrc" &> /dev/null
rm -f "$HOME/.config/bat" &> /dev/null
rm -f "$HOME/.config/ghostty" &> /dev/null
rm -f "$HOME/.config/mise" &> /dev/null
rm -f "$HOME/.ssh/allowed_signers" &> /dev/null
rm -f "$HOME/.ssh/config" &> /dev/null
rm -f "$HOME/Library/Application Support/VSCodium/User/settings.json" &> /dev/null
rm -f "$HOME/Library/Application Support/VSCodium/User/keybindings.json" &> /dev/null

print_title "macOS Defaults"
macos_defaults_delete

print_title "Homebrew"
print_step_ln "Running Homebrew official uninstaller"
if command -v brew &> /dev/null; then
    CI=1 NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/uninstall.sh)" -- --force --zap &> /dev/null
else
    if [[ -d "/opt/homebrew" ]]; then
        sudo rm -rf "/opt/homebrew" &> /dev/null
    fi
fi

print_title "OhMyZsh"
print_step_ln "Deleting $HOME/.oh-my-zsh"
rm -rf "$HOME/.oh-my-zsh" &> /dev/null

kill "$SUDO_KEEPALIVE_PID" &> /dev/null

print_info "Finished."