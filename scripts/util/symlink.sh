#!/usr/bin/env zsh

# This repo's absolute path
DOTFILES_ABSOLUTE_PATH="$(
  cd -- "$(dirname "$0")" >/dev/null 2>&1 || exit
  realpath $(pwd -P)/../..
)"

function symlink() {
    { set +x; } 2>/dev/null # https://stackoverflow.com/a/19226038
    for file in "${@:2}"; do
        [ ! -f "${1}/${2##*/}" ] && {
            echo "File ${1}/${2##*/} does not exist. Terminating..."
            exit 1
        }
        [ ! -f "${file}" ] && {
            echo "${file} does not exist, creating..."
            mkdir -p $(dirname "${file}") || exit
            touch "${file}" || exit
        }
        ln -nfs "${1}/${file##*/}" "${file}"
    done
}
