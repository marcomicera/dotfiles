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

    echo "Installing these dotfiles into home directory"

    rsync --exclude ".git/" \
        --exclude ".gitignore" \
        --exclude "README.md" \
        --exclude "bootstrap.sh" \
        --filter=':- .gitignore' \
        -avh --no-perms . ~;
}

doImport() {
    info "Importing"
    rsync -avh --no-perms ~/.screenrc ~/.profile .
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
            ---import)
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
