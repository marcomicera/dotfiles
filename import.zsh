#!/usr/bin/env zsh

set -e

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

# vim
magenta "vim"
(
  VIM_RUNTIME_CONFIGS=~/.vim_runtime/my_configs.vim
  if [ ! -f "${VIM_RUNTIME_CONFIGS}" ]; then
    red "Custom vim config file at ${VIM_RUNTIME_CONFIGS} not found."
    printf "Install github.com/amix/vimrc with:\n"
    printf "\t git clone --depth=1 https://github.com/amix/vimrc.git ~/.vim_runtime\n"
    printf "\t sh ~/.vim_runtime/install_awesome_vimrc.sh\n"
    printf "\t vim ${VIM_RUNTIME_CONFIGS}\n\n"
    exit 1
  else
    set -x
    cp "${VIM_RUNTIME_CONFIGS}" "${CWD}/vim"
  fi
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
