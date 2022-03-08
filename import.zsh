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
  cp ~/.aliases "${CWD}"/zsh
  cp ~/.functions "${CWD}"/zsh
  cp ~/.zshrc "${CWD}"/zsh
  cp ~/.p10k.zsh "${CWD}"/zsh
  cp ~/.hushlogin "${CWD}"/zsh # disabled "last login" prompt
  cp ~/.config/iterm2/settings/com.googlecode.iterm2.plist "${CWD}"/zsh # iTerm2 settings
  cp ~/.iterm2_shell_integration.zsh "${CWD}"/zsh # https://iterm2.com/documentation-shell-integration.html
)

# Ruby
magenta "Ruby"
(
  set -x
  gem list --no-versions --no-verbose > "${CWD}"/gems
)

# IntelliJ IDEA (Community Edition)
magenta "IntelliJ IDEA (Community Edition)"
(
  set -x
  cp /usr/local/bin/idea "${CWD}"
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
  cp ~/.config/git/ignore "${CWD}"/.config/git
  cp ~/.gnupg/gpg.conf "${CWD}"/git/.gnupg
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

# nano
magenta "nano"
(
  set -x
  cp ~/.nanorc "${CWD}"
)

# vim
magenta "vim"
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
    cp ${XDG_CONFIG_HOME}/k9s/plugin.yml "${CWD}"/.config/k9s
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
