#!/usr/bin/env zsh

# This repo's absolute path
CWD="$(
  cd -- "$(dirname "$0")" >/dev/null 2>&1 || exit
  pwd -P
)"
echo "Dotfiles absolute path: ${CWD}"

# Printing
set -x

# zsh
cp ~/.zshrc "${CWD}"/zsh
cp ~/.p10k.zsh "${CWD}"/zsh

# asdf
asdf plugin list >"${CWD}"/asdf/list.txt

# brew
brew list --casks -1 >"${CWD}"/brew/casks.txt
brew leaves --installed-on-request >"${CWD}"/brew/formulae.txt

# git
cp ~/.gitconfig "${CWD}"/git
cp ~/.gitignore_global "${CWD}"/git

# nano
cp ~/.nanorc "${CWD}"

# Visual Studio Code
cp ~/Library/Application\ Support/Code/User/settings.json "${CWD}"/code
cp ~/Library/Application\ Support/Code/User/keybindings.json "${CWD}"/code
