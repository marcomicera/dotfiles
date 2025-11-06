#!/usr/bin/env zsh

# helper that retries with sudo on failure
_try() {
  "$@" && return 0
  # only escalate if not already root
  [ "${EUID:-$(id -u)}" -ne 0 ] && sudo "$@"
}

# Creates a symlink ${1} -> ${@:2} (glob pattern)
function symlink() {

    # `set +x` without it being printed
    # https://stackoverflow.com/a/19226038
    { set +x; } 2>/dev/null

    # For all `ln` target files (glob patterns get expanded)
    for file in "${@:2}"; do

        # If file to be symlinked is not a directory and doesn't exist
		[ ! -d "${1}/${file##*/}" ] && [ ! -f "${1}/${file##*/}" ] && {
			echo "File ${1}/${file##*/} does not exist. Terminating..."
			exit 1
	    }

        # If `ln` target file is not a directory and doesn't exist
        [ ! -d "${1}/${file##*/}" ] && [ ! -f "${file}" ] && {

            # Create the `ln` target file
            echo "${file} does not exist, creating..."
			_try mkdir -p "$(dirname "${file}")" || exit
			_try touch "${file}" || exit
        }

        set -x
	    _try ln -nfs "${1}/${file##*/}" "${file}" || exit
        { set +x; } 2>/dev/null # https://stackoverflow.com/a/19226038
    done
}
