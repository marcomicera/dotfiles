#!/usr/bin/env zsh

set -e

# This repo's absolute path
CWD="$(
  cd -- "$(dirname "$0")" >/dev/null 2>&1 || exit
  realpath $(pwd -P)/..
)"

# This folder absolute path
SCRIPTS="$(
  cd -- "$(dirname "$0")" >/dev/null 2>&1 || exit
  pwd -P
)"

# Including utils
UTILS_DIR="${SCRIPTS}"/util
if [ -d "${UTILS_DIR}" ]; then
  for utility_file in "${UTILS_DIR}"/*.sh
    do
       test -x "${utility_file}" && source "${utility_file}"
    done
else
  echo "Utility folder ${UTILS_DIR} does not exist. Terminating..."
  exit 1
fi

# Asking the user again
echo -n "Installing files: do you want to continue? [y/N]: "
read answer
if [[ "$answer" != [yY] ]]; then
  echo "Aborting script."
  exit 1
fi

# Ruby
magenta "Ruby"
(
  while read -r gem
  do
    # Install the gem using the gem install command
    (
      set -x
      gem install --user-install "${gem}" || echo "Failed to install gem: $gem"
    )
  done < "${CWD}"/gems
)

# asdf
magenta "asdf"
(
  # Plugins
  while read -r plugin; do
    asdf plugin-add "${plugin}" || true
  done < "${CWD}"/asdf/list.txt

  # Global binaries
  popd "${CWD}"/asdf && asdf install
)
