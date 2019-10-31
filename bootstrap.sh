#!/usr/bin/env bash

DOTFILES=$(pwd -P)

info() {
    printf "\033[00;34m$@\033[0m\n"
}

doUpdate() {
    echo "Updating dotfiles repo..."
    git pull origin master;
}

doInstall() {
    echo "Installing these dotfiles into home directory..."
    rsync --exclude ".git/" \
        --exclude ".gitignore" \
        --exclude "README.md" \
        --exclude "bootstrap.sh" \
        --filter=':- .gitignore' \
        -azvhP --no-perms ./.* ~;

    echo "Installing SmartGit preferences..."
    rsync -azvhP .config/smartgit/* /home/marcomicera/.config/smartgit

    echo "Setting GRUB's timeout to zero..."
    sudo sed -i 's/GRUB_TIMEOUT=.*/GRUB_TIMEOUT=0/' /etc/default/grub
}

doImport() {
    echo "Importing base dotfiles..."
    rsync -azvhP --no-perms ~/.screenrc ~/.profile .

    echo "Importing SmartGit preferences..."
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
