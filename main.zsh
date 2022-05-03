#!/usr/bin/env zsh

set -e

USAGE="Usage: ${0} {--import|--install}"
function _usage() {
  echo "${USAGE}"
  exit 1
}

# This repo's absolute path
CWD="$(
  cd -- "$(dirname "$0")" >/dev/null 2>&1 || exit
  pwd -P
)"

# Including utils
source "${CWD}"/util/print.sh

# If true, import dotfiles; otherwise, install them
IMPORT_DOTFILES=true

# Checking arguments
if [ $# -ge 2 ]; then
  _usage;
fi
case $1 in
  --import)
    IMPORT_DOTFILES=true
    green "Importing dotfiles from ${CWD}"
    ;;
  --install)
    IMPORT_DOTFILES=false
    green "Installing dotfiles"
    ;;
  *)
    _usage
    ;;
esac

# zsh
magenta "zsh"
if [ $IMPORT_DOTFILES = true ]; then
  (
    set -x
    cp ~/.aliases "${CWD}"/zsh
    cp ~/.functions "${CWD}"/zsh
    cp ~/.zshrc "${CWD}"/zsh
    cp ~/.p10k.zsh "${CWD}"/zsh
    cp ~/.hushlogin "${CWD}"/zsh # disabled "last login" prompt
    cp ~/.config/iterm2/settings/com.googlecode.iterm2.plist "${CWD}"/zsh # iTerm2 settings
    cp ~/.iterm2_shell_integration.zsh "${CWD}"/zsh # https://iterm2.com/documentation-shell-integration.html
    cp ~/.fzf.zsh "${CWD}/zsh"
    cp ~/.config/bat/config "${CWD}"/.config/bat
  )
fi

# Ruby
magenta "Ruby"
if [ $IMPORT_DOTFILES = true ]; then
  (
    set -x
    gem list --no-versions --no-verbose > "${CWD}"/gems
  )
fi

# JetBrains IDEs
magenta "JetBrains IDEs"
if [ $IMPORT_DOTFILES = true ]; then
  (
    set -x
    cp /usr/local/bin/idea "${CWD}"
    cp /usr/local/bin/storm "${CWD}"
    cp /usr/local/bin/charm "${CWD}"
  )
fi

# Oh My Zsh
magenta "Oh My Zsh"
if [ $IMPORT_DOTFILES = true ]; then
  (
    set -x
    cp ~/.oh-my-zsh/completions/*.zsh "${CWD}"/.oh-my-zsh/completions
  )
fi

# asdf
magenta "asdf"
if [ $IMPORT_DOTFILES = true ]; then
  (
    set -x
    asdf plugin list >"${CWD}"/asdf/list.txt
    cp ~/.tool-versions "${CWD}"/asdf
  )
fi

# brew
magenta "brew"
if [ $IMPORT_DOTFILES = true ]; then
  (
    set -x
    brew list --casks -1 >"${CWD}"/brew/casks.txt
    brew leaves --installed-on-request >"${CWD}"/brew/formulae.txt
  )
fi

# git
magenta "git"
if [ $IMPORT_DOTFILES = true ]; then
  (
    set -x
    cp ~/.gitconfig "${CWD}"/git
    cp ~/.config/git/ignore "${CWD}"/.config/git
    cp ~/.gnupg/gpg*.conf "${CWD}"/.gnupg
  )
fi

# SmartGit
magenta "SmartGit"
if [ $IMPORT_DOTFILES = true ]; then
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
    cp /usr/local/bin/sm "${CWD}"
  )
fi

# nano
magenta "nano"
if [ $IMPORT_DOTFILES = true ]; then
  (
    set -x
    cp ~/.nanorc "${CWD}"
  )
fi

# vim
magenta "vim"
if [ $IMPORT_DOTFILES = true ]; then
  (
    VIM_RUNTIME=~/.vim_runtime
    VIM_RUNTIME_CONFIGS="${VIM_RUNTIME}"/my_configs.vim
    if [ ! -f "${VIM_RUNTIME_CONFIGS}" ]; then
      red "Custom vim config file at ${VIM_RUNTIME_CONFIGS} not found."
      printf "Install github.com/amix/vimrc with:\n"
      printf "\t git clone --depth=1 https://github.com/amix/vimrc.git ~/.vim_runtime\n"
      printf "\t sh ~/.vim_runtime/install_awesome_vimrc.sh\n"
      printf "\t vim ${VIM_RUNTIME_CONFIGS}\n\n"
      exit 1
    else
      set -x

      # Config
      cp "${VIM_RUNTIME_CONFIGS}" "${CWD}/vim"

      # Plugins
      VIM_RUNTIME_PLUGINS="${VIM_RUNTIME}"/my_plugins
      cp -R "${VIM_RUNTIME_PLUGINS}"/ "${CWD}/vim/my_plugins" 2>/dev/null || : # https://serverfault.com/a/153893
    fi
  )
fi

# Visual Studio Code
magenta "Visual Studio Code"
if [ $IMPORT_DOTFILES = true ]; then
  (
    set -x
    cp ~/Library/Application\ Support/Code/User/settings.json "${CWD}"/code
    cp ~/Library/Application\ Support/Code/User/keybindings.json "${CWD}"/code
    code --list-extensions > "${CWD}"/code/extensions.txt # Extensions list (installation: https://stackoverflow.com/a/49398449)
  )
fi

# k9s
if [ $IMPORT_DOTFILES = true ]; then
  if [ -n ${XDG_CONFIG_HOME} ]; then
    magenta "k9s"
    (
      set -x
      cp ${XDG_CONFIG_HOME}/k9s/plugin.yml "${CWD}"/.config/k9s
    )
  fi
fi

# git status
if [ $IMPORT_DOTFILES = true ]; then
  green "git status"
  (
    set -x
    git -C "${CWD}" status
  )
fi

# git diff
if [ $IMPORT_DOTFILES = true ]; then
  green "git diff"
  (
    set -x
    git -C "${CWD}" --no-pager diff
  )
fi
