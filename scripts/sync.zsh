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
  symlink "${CWD}"/zsh/.aliases ~/.aliases
  symlink "${CWD}"/zsh/.functions ~/.functions
  symlink "${CWD}"/zsh/.zshrc ~/.zshrc
  symlink "${CWD}"/zsh/.p10k.zsh ~/.p10k.zsh
  symlink "${CWD}"/zsh/.hushlogin ~/.hushlogin # disabled "last login" prompt
  symlink "${CWD}"/zsh/com.googlecode.iterm2.plist ~/.config/iterm2/settings/com.googlecode.iterm2.plist  # iTerm2 settings
  symlink "${CWD}"/zsh/.iterm2_shell_integration.zsh ~/.iterm2_shell_integration.zsh # https://iterm2.com/documentation-shell-integration.html
  symlink "${CWD}"/zsh/.fzf.zsh ~/.fzf.zsh 
  symlink "${CWD}"/.config/bat/config ~/.config/bat/config 
)

# JetBrains IDEs
magenta "JetBrains IDEs"
(
  set -x
  symlink "${CWD}"/idea /usr/local/bin/idea
  symlink "${CWD}"/storm /usr/local/bin/storm
  symlink "${CWD}"/charm /usr/local/bin/charm
)

# # Oh My Zsh
# magenta "Oh My Zsh"
# (
#   set -x
# TODO How to symlink using a glob pattern?
#   cp ~/.oh-my-zsh/completions/*.zsh "${CWD}"/.oh-my-zsh/completions
# )

# asdf
magenta "asdf"
(
  set -x
  symlink "${CWD}"/asdf/.tool-versions ~/.tool-versions
)

# # brew
# magenta "brew"
# (
#   set -x
#   brew list --casks -1 >"${CWD}"/brew/casks.txt
#   brew leaves --installed-on-request >"${CWD}"/brew/formulae.txt
# )

# # git
# magenta "git"
# (
#   set -x
#   cp ~/.gitconfig "${CWD}"/git
#   cp ~/.config/git/ignore "${CWD}"/.config/git
#   cp ~/.gnupg/gpg*.conf "${CWD}"/.gnupg
# )

# # SmartGit
# magenta "SmartGit"
# (
#   SMARTGIT_VERSION=21.2
#   SMARTGIT_BASE_CONFIG_DIR=~/Library/Preferences/SmartGit
#   SMARTGIT_VERSION_SPECIFIC_DIR=${SMARTGIT_BASE_CONFIG_DIR}/${SMARTGIT_VERSION}
#   if [ -d "${CWD}"/git/smartgit/${SMARTGIT_VERSION} ]; then
#     printf "Using existing SmartGit version: ${SMARTGIT_VERSION}\n"
#   else
#     printf "Using new SmartGit version: ${SMARTGIT_VERSION}\nCreating folder...\n"
#     mkdir -p "${CWD}"/git/smartgit/${SMARTGIT_VERSION}
#   fi
#   set -x
#   cp ${SMARTGIT_BASE_CONFIG_DIR}/smartgit.vmoptions "${CWD}"/git/smartgit
#   cp ${SMARTGIT_VERSION_SPECIFIC_DIR}/preferences.yml "${CWD}"/git/smartgit/${SMARTGIT_VERSION}
#   cp ${SMARTGIT_VERSION_SPECIFIC_DIR}/tools.yml "${CWD}"/git/smartgit/${SMARTGIT_VERSION}
#   cp ${SMARTGIT_VERSION_SPECIFIC_DIR}/ui-config.yml "${CWD}"/git/smartgit/${SMARTGIT_VERSION}
#   cp /usr/local/bin/sm "${CWD}"
# )

# # nano
# magenta "nano"
# (
#   set -x
#   cp ~/.nanorc "${CWD}"
# )

# # Spotify TUI
# magenta "Spotify TUI"
# (
#   set -x
#   cp ~/.config/spotify-tui/config.yml "${CWD}/spotify-tui"
# )

# # vim
# magenta "vim"
# (
#   VIM_RUNTIME=~/.vim_runtime
#   VIM_RUNTIME_CONFIGS="${VIM_RUNTIME}"/my_configs.vim
#   if [ ! -f "${VIM_RUNTIME_CONFIGS}" ]; then
#     red "Custom vim config file at ${VIM_RUNTIME_CONFIGS} not found."
#     printf "Install github.com/amix/vimrc with:\n"
#     printf "\t git clone --depth=1 https://github.com/amix/vimrc.git ~/.vim_runtime\n"
#     printf "\t sh ~/.vim_runtime/install_awesome_vimrc.sh\n"
#     printf "\t vim ${VIM_RUNTIME_CONFIGS}\n\n"
#     exit 1
#   else
#     set -x

#     # Config
#     cp "${VIM_RUNTIME_CONFIGS}" "${CWD}/vim"

#     # Plugins
#     VIM_RUNTIME_PLUGINS="${VIM_RUNTIME}"/my_plugins
#     cp -R "${VIM_RUNTIME_PLUGINS}"/ "${CWD}/vim/my_plugins" 2>/dev/null || : # https://serverfault.com/a/153893
#   fi
# )

# # Visual Studio Code (VSCode)
# magenta "Visual Studio Code"
# (
#   set -x
#   cp ~/Library/Application\ Support/Code/User/settings.json "${CWD}"/code
#   cp ~/Library/Application\ Support/Code/User/keybindings.json "${CWD}"/code
#   code --list-extensions > "${CWD}"/code/extensions.txt # Extensions list (installation: https://stackoverflow.com/a/49398449)
# )

# # k9s
# if [ -n ${XDG_CONFIG_HOME} ]; then 
#   magenta "k9s"
#   (
#     set -x
#     cp ${XDG_CONFIG_HOME}/k9s/plugin.yml "${CWD}"/.config/k9s
#   )
# fi

# # Rectangle
# # https://github.com/rxhanson/Rectangle
# magenta "Rectangle"
# (
#   set -x
#   cp ~/Library/Application\ Support/Rectangle/RectangleConfig.json "${CWD}"/.config/rectangle
# )

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
