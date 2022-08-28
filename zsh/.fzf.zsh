# Setup fzf
# ---------
if [[ ! "$PATH" == *${HOME}/.asdf/installs/fzf/0.29.0/bin* ]]; then
  export PATH="${PATH:+${PATH}:}/Users/marco.micera/.asdf/installs/fzf/0.29.0/bin"
fi

# Auto-completion
# ---------------
[[ $- == *i* ]] && source "${HOME}/.asdf/installs/fzf/0.29.0/shell/completion.zsh" 2> /dev/null

# Key bindings
# ------------
source "${HOME}/.asdf/installs/fzf/0.29.0/shell/key-bindings.zsh"
