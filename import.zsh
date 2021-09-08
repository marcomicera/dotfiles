#!/usr/bin/env zsh

# Printing
set -x

# zsh
cp ~/.zshrc .

# asdf
asdf plugin list > asdf/list.txt

# brew
brew list --casks -1 > brew/casks.txt
brew leaves --installed-on-request > brew/formulae.txt

# git
cp ~/.gitconfig git
cp ~/.gitignore_global git

# nano
cp ~/.nanorc .

# Visual Studio Code
cp ~/Library/Application\ Support/Code/User/settings.json code
