# zmodload zsh/zprof

# --- Faster zsh startup (see zprof) ---
# Skip compaudit on every shell (~20ms). Only set if you trust your fpath.
export ZSH_DISABLE_COMPFIX=true
# Skip Oh-My-Zsh upgrade check (~6–12ms)
export DISABLE_AUTO_UPDATE=true

# Powerlevel10k
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
    source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
source "$(brew --prefix powerlevel10k)"/share/powerlevel10k/powerlevel10k.zsh-theme

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
    zsh-autosuggestions
    zsh-syntax-highlighting
	zsh-fzf-history-search
)
export ZSH="${HOME}/.oh-my-zsh"
export ZSH_CUSTOM=$ZSH/custom
ZSH_THEME="powerlevel10k/powerlevel10k"
source $ZSH/oh-my-zsh.sh
source ~/.iterm2_shell_integration.zsh

export VISUAL='vim'
export EDITOR='vim'
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

export SSH_AUTH_SOCK="/Users/micera/Library/Containers/com.bitwarden.desktop/Data/.bitwarden-ssh-agent.sock"

# Mise (lazy: activate on first prompt, saves ~26ms at shell open)
export MISE_OVERRIDE_TOOL_VERSIONS_FILENAMES=none
_mise_lazy_init() {
  eval "$(mise activate zsh)"
  precmd_functions=(${precmd_functions:#_mise_lazy_init})
}
precmd_functions+=(_mise_lazy_init)

# Ruby
export PATH="/opt/homebrew/opt/ruby/bin:$PATH"
export GEM_HOME="$(ruby -e 'puts Gem.user_dir')"
export PATH="$PATH:$GEM_HOME/bin"

# Golang
export GOPATH="$(go env GOPATH)"
export GOBIN="${GOPATH}/bin"
export PATH="${PATH}:${GOBIN}"
export GOROOT="$(brew --prefix go)/libexec"
export PATH="$PATH:$GOROOT/bin"

# Functions
source ~/.functions

# Krew (plugins)
# Needs to be before completions
PATH+=:"${KREW_ROOT:-$HOME/.krew}/bin"

# Completions
source ~/.completions

# Work-related
# source ~/.work

# nnn
PATH+=:~/.nnn
export NNN_BMS="g:$HOME/git,h:$HOME"

# Cursor
PATH+=:$HOME/.local/bin

# Docker
PATH+=:$HOME/.docker/bin

##############
# START      #
# Kubernetes #
##############

# Default editor
export KUBE_EDITOR="code -w"

# kubecolor
compdef kubecolor=kubectl

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

# fzf
# [ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Aliases
source ~/.aliases

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
