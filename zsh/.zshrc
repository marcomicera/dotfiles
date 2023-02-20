# zmodload zsh/zprof

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# If you come from bash you might have to change your $PATH.  
# export PATH=$HOME/bin:/usr/local/bin:$PATH # Path to your oh-my-zsh installation.
export ZSH="${HOME}/.oh-my-zsh"
# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
# ZSH_THEME="agnoster"
export ZSH_CUSTOM=$ZSH/custom

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
  # git
  # docker
  # docker-compose
  
  # ruby
  
  # kubectx
  # kube-ps1

  # gcloud
  asdf
  # helm
  # kubectl
  zsh-autosuggestions
  # zsh-interactive-cd
  zsh-syntax-highlighting
  # zsh-vim-mode
)

DISABLE_AUTO_UPDATE=true source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
export VISUAL='vim'
export EDITOR='vim'
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
# prompt_context(){}

# Right prompt
# RPROMPT="%D{%-I.%M.%S %p, %d.%m.%Y}"
# RPROMPT=""

# Functions
source ~/.functions

# Work-related
source ~/.work

# Ruby
export PATH=$PATH:~/.gem/ruby/2.6.0/bin

# nnn
export PATH=$PATH:~/.nnn
export NNN_BMS="g:$HOME/git,h:$HOME"


##############
# START      #
# Kubernetes #
##############

# Default editor
export KUBE_EDITOR="code -w"

# kubectl autocompletion
# source <(kubectl completion zsh) # done by the plugin

# kubecolor
# command -v kubecolor >/dev/null 2>&1 && alias kubectl="kubecolor"

# kubecolor autocompletion
# autoload -U +X bashcompinit && bashcompinit
# complete -o nospace -C /usr/local/bin/kubecolor kubecolor

# Krew (plugins)
export PATH="${PATH}:${HOME}/.krew/bin"

# kustomize
source <(kustomize completion zsh)

# k9s
source <(k9s completion zsh)
export XDG_CONFIG_HOME=~/.config

# stern
source <(stern --completion zsh)

##############
# END        #
# Kubernetes #
##############

# skaffold
source <(skaffold completion zsh)

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

# Terraform
complete -o nospace -C $(which terraform) terraform
export TF_PLUGIN_CACHE_DIR="$HOME/.terraform.d/plugin-cache"

# fuck
eval $(thefuck --alias)

# aws
complete -C '$(which aws_completer)' aws

# fzf
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Aliases
source ~/.aliases

# Powerlevel10k
POWERLEVEL9K_DISABLE_CONFIGURATION_WIZARD=true
source $(brew --prefix)/opt/powerlevel10k/powerlevel10k.zsh-theme
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh # To customize prompt, run `p10k configure` or edit ~/.p10k.zsh
test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh" || true

# zprof
