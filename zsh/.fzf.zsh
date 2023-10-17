# Setup fzf
# ---------
if [[ ! "$PATH" == */Users/micera/.asdf/installs/fzf/0.43.0/bin* ]]; then
  PATH="${PATH:+${PATH}:}/Users/micera/.asdf/installs/fzf/0.43.0/bin"
fi

# Auto-completion
# ---------------
source "/Users/micera/.asdf/installs/fzf/0.43.0/shell/completion.zsh"

# Key bindings
# ------------
source "/Users/micera/.asdf/installs/fzf/0.43.0/shell/key-bindings.zsh"
