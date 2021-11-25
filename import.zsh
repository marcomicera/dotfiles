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
magenta "zsh"
(
  set -x
  cp ~/.zshrc "${CWD}"/zsh
  cp ~/.p10k.zsh "${CWD}"/zsh
)

# Oh My Zsh
magenta "Oh My Zsh"
(
  set -x
  cp ~/.oh-my-zsh/completions/*.zsh "${CWD}"/.oh-my-zsh/completions
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

# git
magenta "git"
(
  set -x
  cp ~/.gitconfig "${CWD}"/git
  cp ~/.gitignore_global "${CWD}"/git
)

# nano
magenta "nano"
(
  set -x
  cp ~/.nanorc "${CWD}"
)

# Visual Studio Code
magenta "Visual Studio Code"
(
  set -x
  cp ~/Library/Application\ Support/Code/User/settings.json "${CWD}"/code
  cp ~/Library/Application\ Support/Code/User/keybindings.json "${CWD}"/code
  code --list-extensions > "${CWD}"/code/extensions.txt # Extensions list (installation: https://stackoverflow.com/a/49398449)
)

# k9s
if [ -n ${XDG_CONFIG_HOME} ]; then 
  magenta "k9s"
  (
    set -x
    cp ${XDG_CONFIG_HOME}/k9s/plugin.yml "${CWD}"/.config/k9s/plugin.yml
  )
fi

# git status
green "git status"
(
  set -x
  git -C "${CWD}" status
)

# git diff
green "git diff"
(
  set -x
  git -C "${CWD}" --no-pager diff
)
