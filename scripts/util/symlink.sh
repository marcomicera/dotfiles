#!/usr/bin/env zsh

# helper that retries with sudo on failure
_try() {
  "$@" && return 0
  # only escalate if not already root
  [ "${EUID:-$(id -u)}" -ne 0 ] && sudo "$@"
}

# Creates symlinks: ${1}/${basename(target)} -> each path in ${@:2}
function symlink() {
    { set +x; } 2>/dev/null
    local base_dir="${1}"
    shift
    for target in "$@"; do
        local name="${target##*/}"
        local source="${base_dir}/${name}"
        _try mkdir -p "$(dirname "${source}")" || exit
        _try mkdir -p "$(dirname "${target}")" || exit
        local source_abs target_abs
        source_abs="$(cd "$(dirname "${source}")" && pwd)/${name}"
        target_abs="$(cd "$(dirname "${target}")" && pwd)/${name}"
        if [ "${source_abs}" = "${target_abs}" ]; then
            echo "Source and target are the same (${source_abs}). Skipping."
            continue
        fi
        # Migrate existing real file at target into repo (don't clobber with empty touch)
        if [ ! -e "${source}" ] && [ -f "${target}" ] && [ ! -L "${target}" ]; then
            echo "Migrating ${target} -> ${source}"
            _try cp -p "${target}" "${source}" || exit
        elif [ ! -e "${source}" ]; then
            echo "${source} does not exist, creating empty file..."
            _try touch "${source}" || exit
        fi
        # Skip if already correct symlink
        if [ -L "${target}" ] && [ "$(readlink "${target}")" = "${source_abs}" ]; then
            echo "${target} already links to ${source_abs}. Skipping."
            continue
        fi
        set -x
        _try ln -nfs "${source_abs}" "${target}" || exit
        { set +x; } 2>/dev/null
    done
}
