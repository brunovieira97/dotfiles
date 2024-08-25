#!/bin/bash

# Helper functions

function create_symlink() {
	filename=$(basename $2)

	print_step "Creating symlink for: $filename"

	ln -Ffs "$1" "$2" > /dev/null

	if [[ -f "$2" ]]; then
		success
	else
		fail
		exit 1
	fi
}

function is_1password_installed() {
	if [ ! -d "$HOME/Library/Group Containers/2BUA8C4S2C.com.1password" ]; then
		false
	else
		true
	fi
}

function is_xcode_tools_installed() {
	if [[ $(xcode-select -p) == "" ]]; then
		false
	else
		true
	fi
}

function is_homebrew_installed() {
	if [[ $(command -v brew) == "" ]]; then
		false
	else
		true
	fi
}

function is_asdf_installed() {
	if [[ $(command -v asdf) == "" ]]; then
		false
	else
		true
	fi
}

function is_zsh_default() {
	zshPath=$(which zsh)

	if [ $SHELL == $zshPath ]; then
		true
	else
		false
	fi
}

function is_ohmyzsh_installed() {
	if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
		false
	else
		true
	fi
}

function homebrew_install() {
	print_step_ln "Installing Homebrew"
		
	CI=1 NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" &> /dev/null

	eval "$(/opt/homebrew/bin/brew shellenv)"
}

function homebrew_restore_brewfile() {
	print_step_ln "Restoring Brewfile"

	brew bundle --file $BASE_PATH/homebrew/Brewfile

	if [ $? -ne 0 ]; then
		exit 1
	fi
}

function asdf_add_plugins() {
	while read line; do
		print_step_ln "Adding plugins"

		asdf plugin add $line > /dev/null
	done < $BASE_PATH/asdf/plugins
}

function zsh_set_default() {
	print_step "Changing default shell to Zsh"

	chsh -s $zshPath > /dev/null

	if is_zsh_default; then
		success
	else
		fail
		exit 1
	fi
}

function zsh_install_ohmyzsh() {
	print_step "Installing Oh-My-Zsh"

	sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended &> /dev/null

	if is_ohmyzsh_installed; then
		success
	else
		fail
		exit 1
	fi
}

function zsh_clone_plugins() {
	print_step "Cloning plugins"

	if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/fast-syntax-highlighting" ]; then
		git clone --quiet https://github.com/zdharma-continuum/fast-syntax-highlighting.git \
		${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/fast-syntax-highlighting > /dev/null
	fi

	if [ $? -ne 0 ]; then
		fail
		exit 1
	fi

	success
}

# Main functions

function setup_xcode_tools() {
	print_step "Checking if XCode Command Line Tools are installed"

	if ! is_xcode_tools_installed; then
		fail "Not found!"
		print_step "Installing XCode Command Line Tools"

		xcode-select --install > /dev/null

		if is_xcode_tools_installed; then
			success "Done."
		else
			fail
			exit 1
		fi
	else
		success "Found!"
	fi
}

function setup_homebrew() {
	print_step "Checking if Homebrew is installed"

	if ! is_homebrew_installed; then
		fail "Not installed."
		
		homebrew_install
	else
		success "Already installed."
		print_step "Running ${TEXT_BOLD}brew update${TEXT_NORMAL}"
		
		/bin/bash -c "brew update --quiet" > /dev/null
		
		success
	fi

	homebrew_restore_brewfile
}

function setup_asdf() {
	print_step "Checking if asdf is installed"

	if is_asdf_installed; then
		success "Already installed."
		create_symlink "$BASE_PATH/asdf/.asdfrc" "$HOME/.asdfrc"
		asdf_add_plugins
	else
		fail "Not installed. Skipping plugins setup."
	fi
}

function setup_iterm2() {
	print_step "Installing shell integrations"

	/bin/bash -c "$(curl -fsSL https://iterm2.com/shell_integration/install_shell_integration.sh)" > /dev/null

	if [ $? -eq 0 ]; then
		success
	else
		fail
		exit 1
	fi
	
	printf "\n"
	print_info "Finish iTerm2 setup by importing ${BASE_PATH}/iterm2/Default.json"
}

function setup_macos() {
	print_step "Running ${TEXT_BOLD}$BASE_PATH/macos/defaults.sh${TEXT_NORMAL} for applying settings"
	
	source "$BASE_PATH/macos/defaults.sh" > /dev/null

	if [ $? -eq 0 ]; then
		success
	else
		fail
		exit 1
	fi

	printf "\n"
	print_info "Done. Note that some of these changes require a logout/restart to take effect."
}

function setup_ssh() {
	mkdir -p ~/.1password
	mkdir -p ~/.ssh
	
	if [ ! -d "$HOME/Library/Group\ Containers/2BUA8C4S2C.com.1password" ]; then
		print_info "1Password is not installed, skipping agent.sock symlink creation."
	else
		create_symlink "$HOME/Library/Group\ Containers/2BUA8C4S2C.com.1password/t/agent.sock" "$HOME/.1password/agent.sock"
	fi

	create_symlink "$BASE_PATH/ssh/allowed_signers" "$HOME/.ssh/allowed_signers"
	create_symlink "$BASE_PATH/ssh/config" "$HOME/.ssh/config"
}

function setup_git() {
	create_symlink "$BASE_PATH/git/.gitconfig" "$HOME/.gitconfig"
}

function setup_vim() {
	create_symlink "$BASE_PATH/vim/.vimrc" "$HOME/.vimrc"
}

function setup_bat() {
	mkdir -p ~/.config/bat

	create_symlink "$BASE_PATH/bat/config" "$HOME/.config/bat/config"
}

function setup_curl() {
	create_symlink "$BASE_PATH/curl/.curlrc" "$HOME/.curlrc"
}

function setup_zsh() {
	print_step "Checking if Zsh is the default shell"

	if is_zsh_default; then
		success "Already default."
	else
		fail "Not the default!"

		zsh_set_default
	fi

	print_step "Checking if Oh-My-Zsh is installed"

	if is_ohmyzsh_installed; then
		success "Installed!"
	else
		fail "Not installed!"

		zsh_install_ohmyzsh
	fi

	zsh_clone_plugins

	create_symlink "$BASE_PATH/zsh/.zprofile" "$HOME/.zprofile"
	create_symlink "$BASE_PATH/zsh/.zshrc" "$HOME/.zshrc"
}
