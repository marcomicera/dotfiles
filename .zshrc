# If you come from bash you might have to change your $PATH.  
# export PATH=$HOME/bin:/usr/local/bin:$PATH # Path to your oh-my-zsh installation.
export ZSH="/Users/marcomicera/.oh-my-zsh" 
# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="agnoster"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to automatically update without prompting.
# DISABLE_UPDATE_PROMPT="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
    git
    docker
    docker-compose
    gcloud
    asdf
)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
export VISUAL='nano' # ewrap
export EDITOR='nano'
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# Hiding "user@hostname" when logged as myself on my local machine
prompt_context(){}

# Right prompt
RPROMPT="%D{%-I.%M.%S %p, %d.%m.%Y}"
# RPROMPT=""

# compdef
autoload -Uz compinit
compinit

# General aliases
alias ll='ls -lah'
alias n='nano'
alias nzsh='n ~/.zshrc'
alias nzshr='n ~/.zshrc'
alias nzshrc='n ~/.zshrc'
alias src="source ~/.zshrc"
alias srczsh="source ~/.zshrc"
alias srczshr="source ~/.zshrc"
alias srczshrc="source ~/.zshrc"
alias nkc='n ~/.kube/config'
alias t="tree"

# nnn
alias nn='nnn -deH'
alias nnn='nnn -deH'
export PATH=$PATH:~/.nnn
export NNN_BMS="g:$HOME/git,h:$HOME"

# Typos
alias cd..="cd .."
alias sl="ls"
alias l="ll"
alias lll="ll"
alias pdw="pwd"
alias clar="clear"
alias cler="clear"
alias clera="clear"
alias claer="clear"
alias celar="clear"
alias lcear="clear"
alias clea="clear"
alias lcaer="clear"

# tree colors
alias tree="tree -C"

# docker-compose
alias c="docker-compose"
alias cup="docker-compose up"
alias cupd="docker-compose up -d"

# kubectl
source <(kubectl completion zsh)
alias k="kubectl"
complete -F __start_kubectl k

# kustomize
source <(kustomize completion zsh)
alias ku="kustomize"
alias kub="kustomize build"

# kompose
source <(kompose completion zsh)
alias ko="kompose"

# skaffold
source <(skaffold completion zsh)
alias s="skaffold"
alias ss="/Users/marcomicera/git/skaffold/out/skaffold"

# KubeMQ
alias kmq="kubemqctl"

# Dropping all data in DGraph
function drop_dgraph() {
    curl -X POST localhost:8080/alter -d '{"drop_op": "DATA"}'
}

# Terraform
alias tf="terraform"

# gcloud
if [ -f ~/opt/google-cloud-sdk/path.zsh.inc ]; then
    source ~/opt/google-cloud-sdk/path.zsh.inc;
fi
if [ -f ~/opt/google-cloud-sdk/completion.zsh.inc ]; then
    source ~/opt/google-cloud-sdk/completion.zsh.inc;
fi

# Kerberos
# export PATH="/usr/local/opt/krb5/bin:$PATH"
# export PATH="/usr/local/opt/krb5/sbin:$PATH"

# Golang
export GOPATH=~/go
export PATH=$PATH:$GOPATH/bin

# Python
export PATH=$PATH:~/Library/Python/2.7/bin # pip for pre-installed Python on macOS

# jEnv
# export PATH=$PATH:~/.jenv/bin
# jenv init - | eval

# Java & Maven
# export JAVA_HOME=/Library/Java/JavaVirtualMachines/openjdk-11.0.2.jdk/Contents/Home
# MAVEN_BIN=~/opt/apache-maven-3.6.3/bin
# export PATH=$PATH:$MAVEN_BIN

# Helm
# source <(helm completion zsh)
# alias h="helm"

# Istio
# export PATH=$PATH:~/opt/istio-1.7.4/bin

# Terraform
# autoload -U +X bashcompinit && bashcompinit
# complete -o nospace -C /usr/local/bin/terraform terraform

# fuck
eval $(thefuck --alias)

# remake
alias m="remake --trace"
alias ma="remake --trace --dry-run"
alias maybe="remake --trace --dry-run"

# asdf
. /usr/local/opt/asdf/asdf.sh