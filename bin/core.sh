#!/bin/bash

COLOR_TITLE='\033[1;33m'
COLOR_EXTRA='\033[1;30m'
COLOR_INFO='\033[1;34m'
COLOR_RESET='\033[0m'
COLOR_FAIL='\033[0;31m'
COLOR_SUCCESS='\033[0;32m'

TEXT_BOLD=$(tput bold)
TEXT_NORMAL=$(tput sgr0)

function print_title() {
	printf "\n${COLOR_TITLE}$1${COLOR_RESET}\n"
}

function print_step() {
	printf "  ${COLOR_EXTRA}>${COLOR_RESET} $1... "
}

function print_step_ln() {
	print_step "$1"
	printf "\n"
}

function success() {
	text=$1

	if [ -z "${text// }" ]; then
		text="OK!"
	fi
	
	text="${COLOR_SUCCESS}$text${COLOR_RESET}"
	printf "$text\n"
}

function fail() {
	text=$1

	if [ -z "${text// }" ]; then
		text="Failed!"
	fi
	
	text="${COLOR_FAIL}$text${COLOR_RESET}"
	printf "$text\n"
}

function print_info() {
	printf "[${COLOR_INFO}INFO${COLOR_RESET}] $1\n"
}
