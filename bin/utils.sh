#!/bin/bash

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

function is_zsh_default() {
	zshPath=$(which zsh)

	if [ $SHELL == $zshPath ]; then
		true
	else
		false
	fi
}

function is_ohmyzsh_installed() {
	ohMyZshPath="$HOME/.oh-my-zsh"
	
	if [ $(ls -A $ohMyZshPath | wc -l) -ne 0 ]; then
		true
	else
		false
	fi
}
