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

green "Creating symlinks from files in ${CWD}"

# zsh
magenta "zsh"
(
  set -x
  symlink "${CWD}"/zsh ~/.aliases
  symlink "${CWD}"/zsh ~/.functions
  symlink "${CWD}"/zsh ~/.zshrc
  symlink "${CWD}"/zsh ~/.p10k.zsh
  symlink "${CWD}"/zsh ~/.hushlogin # disabled "last login" prompt
  symlink "${CWD}"/zsh ~/.config/iterm2/settings/com.googlecode.iterm2.plist  # iTerm2 settings
  symlink "${CWD}"/zsh ~/.iterm2_shell_integration.zsh # https://iterm2.com/documentation-shell-integration.html
  symlink "${CWD}"/zsh ~/.fzf.zsh 
  symlink "${CWD}"/.config/bat ~/.config/bat/config 
)

# JetBrains IDEs
magenta "JetBrains IDEs"
(
  set -x
  symlink "${CWD}" /usr/local/bin/idea
  symlink "${CWD}" /usr/local/bin/storm
  symlink "${CWD}" /usr/local/bin/charm
)

# Oh My Zsh
magenta "Oh My Zsh"
(
  set -x
  symlink "${CWD}"/.oh-my-zsh/completions ~/.oh-my-zsh/completions/*.zsh
)

# asdf
magenta "asdf"
(
  set -x
  symlink "${CWD}"/asdf ~/.tool-versions
)

# git
magenta "git"
(
  set -x
  symlink "${CWD}"/git ~/.gitconfig
  symlink "${CWD}"/.config/git ~/.config/git/ignore
  # TODO How to symlink using a glob pattern?
  # cp ~/.gnupg/gpg*.conf "${CWD}"/.gnupg
)

# SmartGit
magenta "SmartGit"
(
  symlink "${CWD}" /usr/local/bin/sm
)

# nano
magenta "nano"
(
  set -x
  symlink "${CWD}" ~/.nanorc
)

# Spotify TUI
magenta "Spotify TUI"
(
  set -x
  symlink "${CWD}"/spotify-tui ~/.config/spotify-tui/config.yml
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
    symlink "${CWD}"/vim/ "${VIM_RUNTIME_CONFIGS}"

    # Plugins
    # TODO How to symlink a folder?
    # VIM_RUNTIME_PLUGINS="${VIM_RUNTIME}"/my_plugins
    # cp -R "${VIM_RUNTIME_PLUGINS}"/ "${CWD}/vim/my_plugins" 2>/dev/null || : # https://serverfault.com/a/153893
  fi
)

# Visual Studio Code (VSCode)
magenta "Visual Studio Code"
(
  set -x
  symlink "${CWD}"/code ~/Library/Application\ Support/Code/User/settings.json
  symlink "${CWD}"/code ~/Library/Application\ Support/Code/User/keybindings.json
)

# k9s
if [ -n ${XDG_CONFIG_HOME} ]; then 
  magenta "k9s"
  (
    set -x
    symlink "${CWD}"/.config/k9s ${XDG_CONFIG_HOME}/k9s/plugin.yml
  )
fi

# Rectangle
# https://github.com/rxhanson/Rectangle
magenta "Rectangle"
(
  set -x
  symlink "${CWD}"/.config/rectangle ~/Library/Application\ Support/Rectangle/RectangleConfig.json
)

printf "\n"
