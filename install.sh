#!/bin/bash

BASE_PATH="$(cd "$(dirname "$0")" && pwd)"

PRODUCT_NAME=$(sw_vers -productName)
PRODUCT_VERSION=$(sw_vers -productVersion)

# Dependencies
source "$BASE_PATH/bin/core.sh"
source "$BASE_PATH/bin/utils.sh"
source "$BASE_PATH/bin/functions.sh"

# Ask for the administrator password upfront
sudo -v

printf "\n💻 Dotfiles setup\n\n"
print_info "Running on ${PRODUCT_NAME} ${PRODUCT_VERSION}"

# Keep-alive: update existing `sudo` timestamp until script has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

touch $HOME/.hushlogin > /dev/null

print_title "1. XCode"
setup_xcode_tools

print_title "2. Homebrew"
setup_homebrew

print_title "3. ASDF"
setup_asdf

print_title "4. iTerm"
setup_iterm2

print_title "5. MacOS"
setup_macos

print_title "6. SSH"
setup_ssh

print_title "7. Git"
setup_git

print_title "8. Vim"
setup_vim

print_title "9. Bat"
setup_bat

print_title "10. Zsh + Oh-My-Zsh"
setup_zsh

printf "Setup finished. It is advised to reboot now.\n"
read -p "Do you want to reboot? [y/N] " -n 1 -r

if [[ $REPLY =~ ^[Yy]$ ]]
then
    sudo reboot
else
	exit 0
fi
