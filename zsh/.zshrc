# zmodload zsh/zprof

# Powerlevel10k
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
    source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# My binaries
export PATH="${HOME}/bin:${PATH}"

# asdf
fPATH+=:$HOMEBREW_PREFIX/share/zsh/site-functions
source $(brew --prefix asdf)/libexec/asdf.sh
export ASDF_DIR="${HOME}/.asdf"
export PATH="${ASDF_DIR}:${PATH}"

plugins=(
	asdf
	docker
    iterm2
    # gcloud
    gh
    kubectl
    kubectx
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

if [ "$TERM_PROGRAM" = "WarpTerminal" ]; then
    autoload -U +X compinit && compinit -i
fi
# autoload -U +X bashcompinit && bashcompinit

export SSH_AUTH_SOCK="/Users/micera/Library/Containers/com.bitwarden.desktop/Data/.bitwarden-ssh-agent.sock"

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

# Completions
source ~/.completions

# Work-related
# source ~/.work

# nnn
PATH+=:~/.nnn
export NNN_BMS="g:$HOME/git,h:$HOME"

##############
# START      #
# Kubernetes #
##############

# Default editor
export KUBE_EDITOR="code -w"

# kubecolor
compdef kubecolor=kubectl

# Krew (plugins)
PATH+=:"${KREW_ROOT:-$HOME/.krew}/bin"

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
complete -o nospace -C $(asdf which terraform) terraform

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
