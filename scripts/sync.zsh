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
  symlink "${CWD}"/zsh ~/.completions
  symlink "${CWD}"/zsh ~/.functions
  symlink "${CWD}"/zsh ~/.zshrc
  symlink "${CWD}"/zsh ~/.p10k.zsh
  symlink "${CWD}"/zsh ~/.hushlogin # disabled "last login" prompt
  symlink "${CWD}"/zsh ~/.iterm2_shell_integration.zsh # https://iterm2.com/documentation-shell-integration.html
  # symlink "${CWD}"/zsh ~/.fzf.zsh 
  symlink "${CWD}"/.config/bat ~/.config/bat/config 
)

# JetBrains IDEs
# magenta "JetBrains IDEs"
# (
#   set -x
#   symlink "${CWD}"/bin /usr/local/bin/idea
#   symlink "${CWD}"/bin /usr/local/bin/storm
#   symlink "${CWD}"/bin /usr/local/bin/charm
# )

# Oh My Zsh
magenta "Oh My Zsh"
(
  # Where is the completions directory locally
  completions_dir="${HOME}/.oh-my-zsh/completions"
  
  set -x

  # Create the completoions dir if it doesn't exist
  [ ! -d "${completions_dir}" ] && mkdir -p "${completions_dir}"

  # For all completion files
  for file in "${CWD}/.oh-my-zsh/completions/"*.zsh; do

    # If the completion file doesn't exist
    if [ ! -e "${completions_dir}/${file##*/}" ]; then
      cp "$file" "${completions_dir}"
    fi
  done

  symlink "${CWD}"/.oh-my-zsh/completions ~/.oh-my-zsh/completions/*.zsh
)

# mise
magenta "mise"
(
  set -x
  symlink "${CWD}"/mise ~/.config/mise/config.toml
)

# git
magenta "git"
(
  set -x
  symlink "${CWD}"/git ~/.gitconfig
  symlink "${CWD}"/git ~/.config/git/ignore
#   symlink "${CWD}"/.gnupg ~/.gnupg/gpg*.conf 
)

# SmartGit
magenta "SmartGit"
(
  symlink "${CWD}"/bin /usr/local/bin/sm
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
  fi
)

# neovim (LazyVim)
magenta "neovim"
(
  NVIM_CONFIG="${HOME}/.config/nvim"
  NVIM_REPO="${CWD}/nvim"

  if [ -L "${NVIM_CONFIG}" ] && [ "$(readlink "${NVIM_CONFIG}")" = "${NVIM_REPO}" ]; then
    echo "${NVIM_CONFIG} already links to ${NVIM_REPO}. Skipping."
  else
    if [ -e "${NVIM_CONFIG}" ] && [ ! -L "${NVIM_CONFIG}" ]; then
      if [ ! -f "${NVIM_REPO}/init.lua" ]; then
        echo "Migrating ${NVIM_CONFIG} -> ${NVIM_REPO}"
        mkdir -p "${NVIM_REPO}"
        cp -R "${NVIM_CONFIG}/." "${NVIM_REPO}/"
      fi
      echo "Backing up ${NVIM_CONFIG} -> ${NVIM_CONFIG}.bak"
      mv "${NVIM_CONFIG}" "${NVIM_CONFIG}.bak"
    elif [ -L "${NVIM_CONFIG}" ]; then
      rm "${NVIM_CONFIG}"
    fi
    set -x
    mkdir -p "$(dirname "${NVIM_CONFIG}")"
    ln -nfs "${NVIM_REPO}" "${NVIM_CONFIG}"
  fi
)

# VSCodium
magenta "VSCodium"
(
  set -x
  symlink "${CWD}"/codium ~/Library/Application\ Support/VSCodium/User/settings.json
  symlink "${CWD}"/codium ~/Library/Application\ Support/VSCodium/User/keybindings.json
)

# Cursor
magenta "Cursor"
(
  set -x
  symlink "${CWD}"/codium ~/Library/Application\ Support/Cursor/User/settings.json
  symlink "${CWD}"/codium ~/Library/Application\ Support/Cursor/User/keybindings.json
)

# Ghossty
magenta "Ghossty"
(
  set -x
  symlink "${CWD}"/ghostty ~/Library/Application\ Support/com.mitchellh.ghostty/config.ghostty
  # xterm-ghostty terminfo for TUIs (lazygit, etc.)
  if [[ -d "/Applications/Ghostty.app/Contents/Resources/terminfo" ]]; then
    mkdir -p "${HOME}/.terminfo"
    TERMINFO="/Applications/Ghostty.app/Contents/Resources/terminfo" \
      infocmp -x xterm-ghostty 2>/dev/null | tic -x -o "${HOME}/.terminfo" - 2>/dev/null || true
  fi
)

# lazygit
magenta "lazygit"
(
  set -x
  if [[ -n ${XDG_CONFIG_HOME} ]]; then
    symlink "${CWD}"/.config/lazygit "${XDG_CONFIG_HOME}/lazygit/config.yml"
  fi
)

# # k9s
if [ -n ${XDG_CONFIG_HOME} ]; then 
  magenta "k9s"
  (
    set -x
    symlink "${CWD}"/.config/k9s ${XDG_CONFIG_HOME}/k9s/plugins.yaml
    symlink "${CWD}"/.config/k9s ${XDG_CONFIG_HOME}/k9s/config.yaml
  )
fi

printf "\n"
