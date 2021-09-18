#!/usr/bin/env zsh

# This repo's absolute path
CWD="$(
  cd -- "$(dirname "$0")" >/dev/null 2>&1 || exit
  pwd -P
)"

# Including utils
source "${CWD}"/util/*.sh

green "Dotfiles absolute path: ${CWD}"

# zsh
yellow "zsh"
(
  set -x
  cp ~/.zshrc "${CWD}"/zsh
  cp ~/.p10k.zsh "${CWD}"/zsh
)

# asdf
yellow "asdf"
(
  set -x
  asdf plugin list >"${CWD}"/asdf/list.txt
)

# brew
yellow "brew"
(
  set -x
  brew list --casks -1 >"${CWD}"/brew/casks.txt
  brew leaves --installed-on-request >"${CWD}"/brew/formulae.txt
)

# git
yellow "git"
(
  set -x
  cp ~/.gitconfig "${CWD}"/git
  cp ~/.gitignore_global "${CWD}"/git
)

# nano
yellow "nano"
(
  set -x
  cp ~/.nanorc "${CWD}"
)

# Visual Studio Code
yellow "Visual Studio Code"
(
  set -x
  cp ~/Library/Application\ Support/Code/User/settings.json "${CWD}"/code
  cp ~/Library/Application\ Support/Code/User/keybindings.json "${CWD}"/code
)

# Printing the git status & diff
green "git status & diff"
(
  set -x
  git -C "${CWD}" status
  git -C "${CWD}" --no-pager diff
)
