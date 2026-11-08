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
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

print_title "Dotfiles"

delete_symlinks() {
	local links=(
		"$HOME/.curlrc"
		"$HOME/.gitconfig"
		"$HOME/.vimrc"
		"$HOME/.zprofile"
		"$HOME/.zshrc"
		"$HOME/.config/bat"
		"$HOME/.config/ghostty"
		"$HOME/.config/mise"
		"$HOME/.ssh/allowed_signers"
		"$HOME/.ssh/config"
		"$HOME/Library/Application Support/VSCodium/User/settings.json"
		"$HOME/Library/Application Support/VSCodium/User/keybindings.json"
	)

	local link
	for link in "${links[@]}"; do
		rm -f "${link}"
	done
}
print_step_ln "Deleting symlinks"
delete_symlinks

print_title "macOS"
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

print_title "Oh-My-Zsh"
print_step_ln "Deleting $HOME/.oh-my-zsh"
rm -rf "$HOME/.oh-my-zsh"

print_info "Finished."
