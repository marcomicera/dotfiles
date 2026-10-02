# zmodload zsh/zprof
# zsh_start_epoch=$EPOCHREALTIME

# --- Faster zsh startup (see zprof) ---
# Skip compaudit on every shell (~20ms). Only set if you trust your fpath.
export ZSH_DISABLE_COMPFIX=true
# Skip Oh-My-Zsh upgrade check (~6–12ms)
export DISABLE_AUTO_UPDATE=true

# Homebrew prefix. `brew shellenv` exports this from ~/.zprofile, which only runs
# for login shells; the fallback covers the rest. Used instead of `brew --prefix`
# below, which costs ~85 ms per call.
export HOMEBREW_PREFIX="${HOMEBREW_PREFIX:-/opt/homebrew}"

# Powerlevel10k
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
    source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
source "${HOMEBREW_PREFIX}"/opt/powerlevel10k/share/powerlevel10k/powerlevel10k.zsh-theme

# My binaries
export PATH="${HOME}/bin:${PATH}"

fPATH+=:$HOMEBREW_PREFIX/share/zsh/site-functions

plugins=(
	docker
    iterm2
    # gcloud
    gh
    # git
    kubectl
    fzf-tab
    zsh-autosuggestions
    zsh-syntax-highlighting
	zsh-fzf-history-search
)

# LS_COLORS for tree (and anything else that reads it): Tokyo Night Moon
# Matches Neovim / Ghostty / bat / fzf. Regenerated with:
#   vivid generate tokyonight-moon > ~/.config/vivid/tokyonight-moon.ls_colors
_ls_colors_file="${XDG_CONFIG_HOME:-$HOME/.config}/vivid/tokyonight-moon.ls_colors"
[[ -r $_ls_colors_file ]] && export LS_COLORS="$(<$_ls_colors_file)"
unset _ls_colors_file

export ZSH="${HOME}/.oh-my-zsh"
export ZSH_CUSTOM=$ZSH/custom
ZSH_THEME="" # theme loaded from Homebrew above
source $ZSH/oh-my-zsh.sh
source ~/.iterm2_shell_integration.zsh

export VISUAL='nvim'
export EDITOR='nvim'
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# export SSH_AUTH_SOCK="/Users/micera/Library/Containers/com.bitwarden.desktop/Data/.bitwarden-ssh-agent.sock"

# Mise (lazy: activate on first prompt, saves ~26ms at shell open)
export MISE_OVERRIDE_TOOL_VERSIONS_FILENAMES=none
# Do not compile missing tools during activate/hook-env (stdout is eval'd).
export MISE_AUTO_INSTALL=false
_mise_lazy_init() {
  eval "$(mise activate zsh)"
  precmd_functions=(${precmd_functions:#_mise_lazy_init})
}
precmd_functions+=(_mise_lazy_init)

# Ruby
export PATH="${HOMEBREW_PREFIX}/opt/ruby/bin:$PATH"
# Gem.user_dir is Ruby-version-specific (.../ruby/4.0.0), so it is cached rather
# than hardcoded -- spawning ruby costs ~63 ms. The cache is rebuilt when the ruby
# binary is newer than it, i.e. after a Homebrew upgrade. $(<file) does not fork.
_gem_home_cache="${XDG_CACHE_HOME:-$HOME/.cache}/zsh/gem-home"
if [[ ! -s $_gem_home_cache || ${HOMEBREW_PREFIX}/opt/ruby/bin/ruby -nt $_gem_home_cache ]]; then
  mkdir -p "${_gem_home_cache:h}"
  ruby -e 'puts Gem.user_dir' >| "$_gem_home_cache" 2>/dev/null
fi
if [[ -s $_gem_home_cache ]]; then
  export GEM_HOME="$(<$_gem_home_cache)"
  export PATH="$PATH:$GEM_HOME/bin"
fi
unset _gem_home_cache

# Golang. $HOME/go is Go's built-in GOPATH default (no ~/.config/go/env override
# here) and GOROOT follows the Homebrew layout, so neither needs a subprocess:
# `go env GOPATH` cost ~39 ms and `brew --prefix go` ~85 ms.
export GOPATH="${GOPATH:-$HOME/go}"
export GOBIN="${GOPATH}/bin"
export PATH="${PATH}:${GOBIN}"
export GOROOT="${HOMEBREW_PREFIX}/opt/go/libexec"
export PATH="$PATH:$GOROOT/bin"

# Functions
source ~/.functions

# Krew (plugins)
# Needs to be before completions
PATH+=:"${KREW_ROOT:-$HOME/.krew}/bin"

# Work-related
source ~/.work

# Cursor
PATH+=:$HOME/.local/bin

# Docker
PATH+=:$HOME/.docker/bin

# TeX (basictex)
# /etc/paths.d/TeX covers login shells via path_helper; this covers the rest
[[ ":$PATH:" == *":/Library/TeX/texbin:"* ]] || PATH+=:/Library/TeX/texbin

# Use bat for man pages
export MANPAGER="sh -c 'col -bx | bat -l man -p --paging=always'"
export MANROFFOPT='-c'

##############
# START      #
# Kubernetes #
##############

# Default editor
export KUBE_EDITOR="codium --wait"

# k9s
export XDG_CONFIG_HOME=~/.config

##############
# END        #
# Kubernetes #
##############

# Python
# PATH+=:~/Library/Python/2.7/bin # pip for pre-installed Python on macOS

# jEnv
# export PATH=$PATH:~/.jenv/bin
# jenv init - | eval

# Java & Maven
# export JAVA_HOME=/Library/Java/JavaVirtualMachines/openjdk-11.0.2.jdk/Contents/Home
# MAVEN_BIN=~/opt/apache-maven-3.6.3/bin
# export PATH=$PATH:$MAVEN_BIN

# Terraform
export TF_PLUGIN_CACHE_DIR="$HOME/.terraform.d/plugin-cache"

# fuck
# eval $(thefuck --alias)

# glow (custom tokyo-night style; must be absolute — see glow.yml)
export GLOW_STYLE="${XDG_CONFIG_HOME:-$HOME/.config}/glow/tokyo-night.json"

# fzf
export FZF_DEFAULT_OPTS_FILE="${XDG_CONFIG_HOME:-$HOME/.config}/fzf/config"
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Completions (after fzf so fzf-tab can reclaim Tab)
source ~/.completions

# Rust
export PATH="${HOMEBREW_PREFIX}/opt/rustup/bin:$PATH"

# Aliases
source ~/.aliases
source ~/.untracked-aliases

##########
# START  #
# gcloud #
##########

# PATH+=:~/google-cloud-sdk/bin

# The next line updates PATH for the Google Cloud SDK.
# if [ -f '/Users/micera/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/micera/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
# if [ -f '/Users/micera/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/micera/google-cloud-sdk/completion.zsh.inc'; fi

##########
# END    #
# gcloud #
##########

# zprof
# [[ -n "$zsh_start_epoch" ]] && echo "zsh init: $(( (EPOCHREALTIME - zsh_start_epoch) * 1000 )) ms"
# source ~/.safe-chain/scripts/init-posix.sh # Safe-chain Zsh initialization script
# export PATH="/opt/homebrew/opt/openjdk/bin:$PATH"

# zoxide
eval "$(zoxide init --cmd cd zsh)" # completion

# >>> agterm agent-status >>>
source '/Users/marco.micera/.config/agterm/agent-status/shell/integration.sh'
# <<< agterm agent-status <<<
