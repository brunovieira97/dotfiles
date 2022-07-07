#!/bin/bash

# Helper functions

function homebrew_install() {
	print_step_ln "Installing Homebrew"
		
	NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" > /dev/null

	eval "$(/opt/homebrew/bin/brew shellenv)"
}

function homebrew_restore_brewfile() {
	print_step_ln "Restoring Brewfile"

	brew bundle --file $BASE_PATH/homebrew/Brewfile

	if [ $? -ne 0 ]; then
		exit 1
	fi
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

	sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" > /dev/null

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
	
	source "$BASE_PATH/macos/defaults.sh"

	if [ $? -eq 0 ]; then
		success
	else
		fail
		exit 1
	fi

	printf "\n"
	print_info "Done. Note that some of these changes require a logout/restart to take effect."
}

function setup_gnupg() {
	create_symlink "$BASE_PATH/gnupg/gpg-agent.conf" "$HOME/.gnupg/gpg-agent.conf"
}

function setup_ssh() {
	mkdir -p ~/.1password
	
	create_symlink "$HOME/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock" "$HOME/.1password/agent.sock"
}

function setup_git() {
	create_symlink "$BASE_PATH/git/.gitconfig" "$HOME/.gitconfig"
}

function setup_vim() {
	create_symlink "$BASE_PATH/vim/.vimrc" "$HOME/.vimrc"
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
