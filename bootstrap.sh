#!/usr/bin/env bash

DOTFILES=$(pwd -P)

info() {
    printf "\033[00;34m$@\033[0m\n"
}

doUpdate() {
    info "Updating dotfiles repo"
    git pull origin master;
}

doInstall() {
    info "Installs dotfiles"

    echo "Installing these dotfiles into home directory..."
    rsync --exclude ".git/" \
        --exclude ".gitignore" \
        --exclude "README.md" \
        --exclude "bootstrap.sh" \
        --filter=':- .gitignore' \
        -azvhP --no-perms ./.* ~;

    echo "Installing SmartGit preferences..."
    rsync -azvhP .config/smartgit/* /home/marcomicera/.config/smartgit
}

doImport() {
    info "Importing base dotfiles"
    rsync -azvhP --no-perms ~/.screenrc ~/.profile .

    info "Importing SmartGit preferences"
    rsync -azvhP --no-perms ~/.config/smartgit/19.1/repositor* .config/smartgit
    rsync -azvhP --no-perms ~/.config/smartgit/19.1/ui-* .config/smartgit
}

doHelp() {
    echo "Usage: $(basename "$0") [options]" >&2
    echo
    echo "  --update              Updates this repo"
    echo "  --import              Imports home directory's dotfiles"
    echo "  --install             Installs these dotfiles to home directory"
    echo
    exit 1
}

if [ $# -eq 0 ]; then
    doHelp
else
    for i in "$@"
    do
        case $i in
            --update)
                doUpdate
                shift
                ;;
            --install)
                doUpdate
                doInstall
                shift
                ;;
            --import)
                doImport
                shift
		            ;;
            *)
                doHelp
                shift
                ;;
        esac
    done
fi
