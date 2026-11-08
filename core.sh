#!/bin/bash

if [ -t 1 ]; then
    COLOR_TITLE=$'\033[1;33m'
    COLOR_EXTRA=$'\033[1;30m'
    COLOR_INFO=$'\033[1;34m'
    COLOR_RESET=$'\033[0m'
    COLOR_FAIL=$'\033[0;31m'
    COLOR_SUCCESS=$'\033[0;32m'
    
    TEXT_BOLD="$(tput bold 2>/dev/null || true)"
    TEXT_NORMAL="$(tput sgr0 2>/dev/null || true)"
else
    COLOR_TITLE=''
    COLOR_EXTRA=''
    COLOR_INFO=''
    COLOR_RESET=''
    COLOR_FAIL=''
    COLOR_SUCCESS=''
    
    TEXT_BOLD=''
    TEXT_NORMAL=''
fi

function print_title() {
    printf "\n[%s%s%s]\n" "$COLOR_TITLE" "$1" "$COLOR_RESET"
}

function print_step() {
    printf "%s>%s %s... " "$COLOR_EXTRA" "$COLOR_RESET" "$1"
}

function print_step_ln() {
    print_step "$1"
    printf "\n"
}

function success() {
    local text="$1"

    if [ -z "${text// }" ]; then
        text="OK!"
    fi
    
    printf "%s%s%s\n" "$COLOR_SUCCESS" "$text" "$COLOR_RESET"
}

function fail() {
    local text="$1"

    if [ -z "${text// }" ]; then
        text="Failed!"
    fi
    
    printf "%s%s%s\n" "$COLOR_FAIL" "$text" "$COLOR_RESET"
}

function print_info() {
    printf "[%sINFO%s] %s\n" "$COLOR_INFO" "$COLOR_RESET" "$1"
}

function print_error() {
    printf "[%sERROR%s] %s\n" "$COLOR_FAIL" "$COLOR_RESET" "$1"
}
