#!/usr/bin/env zsh

set +x

# Colors
RED="\u001b[41;1m"
GREEN="\u001b[42;1m"
YELLOW="\u001b[43;1m"
NOCOLOR="\u001b[0m"

function title() {
    printf "\n${1}"
    printf '*%.0s' {1..$(expr ${#2} + 4)}
    printf "${NOCOLOR}\n${1}* ${2} *${NOCOLOR}\n${1}"
    printf '*%.0s' {1..$(expr ${#2} + 4)}
    printf "${NOCOLOR}\n\n"
}

function red() {
    title "${RED}" "${1}"
}

function green() {
    title "${GREEN}" "${1}"
}

function yellow() {
    title "${YELLOW}" "${1}"
}
