#!/usr/bin/env zsh

# This repo's absolute path
DOTFILES_ABSOLUTE_PATH="$(
  cd -- "$(dirname "$0")" >/dev/null 2>&1 || exit
  realpath $(pwd -P)/../..
)"

# Creates a symlink ${1} -> ${@:2} (glob pattern)
function symlink() {

    # `set +x` without it being printed
    # https://stackoverflow.com/a/19226038
    { set +x; } 2>/dev/null

    # For all `ln` target files (glob patterns get expanded)
    for file in "${@:2}"; do

        # If file to be symlinked is not a directory and doesn't exist
        [ ! -d "${1}/${2##*/}" ] && [ ! -f "${1}/${2##*/}" ] && {
            echo "File ${1}/${2##*/} does not exist. Terminating..."
            exit 1
        }

        # If `ln` target file is not a directory and doesn't exist
        [ ! -d "${1}/${2##*/}" ] && [ ! -f "${file}" ] && {

            # Create the `ln` target file
            echo "${file} does not exist, creating..."
            mkdir -p $(dirname "${file}") || exit
            touch "${file}" || exit
        }

        ln -nfs "${1}/${file##*/}" "${file}"
    done
}
