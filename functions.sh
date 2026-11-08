#!/bin/bash

# Helper functions

function create_symlink() {
    local src="$1"
    local dest="$2"
    local filename
    filename=$(basename "$dest")

    print_step "Creating symlink for: $filename"

    mkdir -p "$(dirname "$dest")"

    ln -Ffs "$src" "$dest" > /dev/null

    if [[ -L "$dest" ]]; then
        success
    else
        fail
        exit 1
    fi
}

function copy_file() {
    local src="$1"
    local dest="$2"
    local filename
    filename=$(basename "$dest")

    print_step "Copying file: $filename"

    mkdir -p "$(dirname "$dest")"

    if [ -d "$src" ]; then
        mkdir -p "$dest"
        cp -RPp "$src"/* "$dest"/ 2>/dev/null || true
    else
        cp -p "$src" "$dest"
    fi

    if [ $? -eq 0 ]; then
        success
    else
        fail
        exit 1
    fi
}

function is_xcode_tools_installed() {
    [[ -n "$(xcode-select -p 2>/dev/null)" ]]
}

function is_homebrew_installed() {
    command -v brew &> /dev/null
}

function is_zsh_default() {
    local zshPath
    zshPath=$(which zsh)
    [[ "$SHELL" == "$zshPath" ]]
}

function is_ohmyzsh_installed() {
    [[ -d "$HOME/.oh-my-zsh" ]]
}

function homebrew_install() {
    print_step_ln "Installing Homebrew"
        
    CI=1 NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" &> /dev/null

    if [[ -x /opt/homebrew/bin/brew ]]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
    elif [[ -x /usr/local/bin/brew ]]; then
        eval "$(/usr/local/bin/brew shellenv)"
    fi
}

function homebrew_restore_brewfile() {
    print_step_ln "Restoring Brewfile... please be aware that the password may be requested for installing certain formulae or casks"

    brew bundle --file "$BASE_PATH/homebrew/Brewfile"

    if [ $? -ne 0 ]; then
        exit 1
    fi
}

function macos_defaults() {
    print_step "Running ${TEXT_BOLD}$BASE_PATH/macos/defaults.sh${TEXT_NORMAL}"
    
    source "$BASE_PATH/macos/defaults.sh" > /dev/null

    if [ $? -eq 0 ]; then
        success
    else
        fail
        exit 1
    fi
}

function zsh_set_default() {
    local zshPath
    zshPath=$(which zsh)
    
    print_step "Changing default shell to Zsh"

    chsh -s "$zshPath" > /dev/null

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

    local custom_dir="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

    if [ ! -d "$custom_dir/plugins/fast-syntax-highlighting" ]; then
        git clone --quiet https://github.com/zdharma-continuum/fast-syntax-highlighting.git \
        "$custom_dir/plugins/fast-syntax-highlighting" > /dev/null
    fi

    if [ ! -d "$custom_dir/plugins/zsh-shift-select" ]; then
        git clone --quiet https://github.com/jirutka/zsh-shift-select.git \
        "$custom_dir/plugins/zsh-shift-select" > /dev/null
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
        print_step "Running %sbrew update%s" "$TEXT_BOLD" "$TEXT_NORMAL"
        
        /bin/bash -c "brew update --quiet" > /dev/null
        
        success
    fi

    homebrew_restore_brewfile
}

function setup_mise() {
    create_symlink "$BASE_PATH/mise" "$HOME/.config/mise"
}

function setup_ghostty() {
    create_symlink "$BASE_PATH/ghostty" "$HOME/.config/ghostty"
}

function setup_macos() {
    print_step_ln "Setting up macOS based on custom defaults"
    
    macos_defaults

    printf "\n"
    print_info "Done. Note that some of these changes require a logout/restart to take effect."
}

function setup_ssh() {
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
    create_symlink "$BASE_PATH/bat" "$HOME/.config/bat"
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

function setup_vscodium() {
    print_step_ln "Linking User settings"
    create_symlink "$BASE_PATH/vscodium/settings.json" "$HOME/Library/Application Support/VSCodium/User/settings.json"

    print_step_ln "Linking User keybindings"
    create_symlink "$BASE_PATH/vscodium/keybindings.json" "$HOME/Library/Application Support/VSCodium/User/keybindings.json"
}

function setup_intellij_idea() {
    print_step_ln "Creating configuration folder"
    mkdir -p ~/.config/intellij-idea

    print_step_ln "Linking color schemes"
    create_symlink "$BASE_PATH/intellij-idea/color-schemes" "$HOME/.config/intellij-idea/colors"

    print_step_ln "Linking keymaps"
    create_symlink "$BASE_PATH/intellij-idea/keymaps" "$HOME/.config/intellij-idea/keymaps"

    print_step_ln "Linking code styles"
    create_symlink "$BASE_PATH/intellij-idea/codestyles" "$HOME/.config/intellij-idea/codestyles"
}
