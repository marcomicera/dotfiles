#!/usr/bin/env zsh

# This repo's absolute path
DOTFILES_ABSOLUTE_PATH="$(
  cd -- "$(dirname "$0")" >/dev/null 2>&1 || exit
  realpath $(pwd -P)/../..
)"

function symlink() {
    { set +x; } 2>/dev/null # https://stackoverflow.com/a/19226038
    [ ! -f "${1}" ] && {
        echo "File ${1} does not exist. Terminating..."
        exit 1
    }
    [ ! -f "${2}" ] && {
        echo "${2} does not exist, creating..."
        mkdir -p $(dirname "${2}") || exit
        touch "${2}" || exit
    }
    ln -nfs "${1}" "${2}"
}
