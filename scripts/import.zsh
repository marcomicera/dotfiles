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

green "Importing files into ${CWD}"

# Ruby
magenta "Ruby"
(
  set -x
  gem list --no-versions --no-verbose > "${CWD}"/gems
)

# asdf
magenta "asdf"
(
  set -x
  asdf plugin list >"${CWD}"/asdf/list.txt
)

# brew
magenta "brew"
(
  set -x
  brew list --casks -1 >"${CWD}"/brew/casks.txt
  brew leaves --installed-on-request >"${CWD}"/brew/formulae.txt
)

# SmartGit
magenta "SmartGit"
(
  SMARTGIT_VERSION=21.2
  SMARTGIT_BASE_CONFIG_DIR=~/Library/Preferences/SmartGit
  SMARTGIT_VERSION_SPECIFIC_DIR=${SMARTGIT_BASE_CONFIG_DIR}/${SMARTGIT_VERSION}
  if [ -d "${CWD}"/git/smartgit/${SMARTGIT_VERSION} ]; then
    printf "Using existing SmartGit version: ${SMARTGIT_VERSION}\n"
  else
    printf "Using new SmartGit version: ${SMARTGIT_VERSION}\nCreating folder...\n"
    mkdir -p "${CWD}"/git/smartgit/${SMARTGIT_VERSION}
  fi
  set -x
  cp ${SMARTGIT_BASE_CONFIG_DIR}/smartgit.vmoptions "${CWD}"/git/smartgit
  cp ${SMARTGIT_VERSION_SPECIFIC_DIR}/preferences.yml "${CWD}"/git/smartgit/${SMARTGIT_VERSION}
  cp ${SMARTGIT_VERSION_SPECIFIC_DIR}/tools.yml "${CWD}"/git/smartgit/${SMARTGIT_VERSION}
  cp ${SMARTGIT_VERSION_SPECIFIC_DIR}/ui-config.yml "${CWD}"/git/smartgit/${SMARTGIT_VERSION}
)

# Visual Studio Code (VSCode)
magenta "Visual Studio Code"
(
  set -x
  code --list-extensions > "${CWD}"/code/extensions.txt # Extensions list (installation: https://stackoverflow.com/a/49398449)
)

# # git status
# green "git status"
# (
#   set -x
#   git -C "${CWD}" status
# )

# # git diff
# green "git diff"
# (
#   set -x
#   git -C "${CWD}" --no-pager diff
# )

printf "\n"
