#!/usr/bin/env bash

DOTFILES=$(pwd -P)

info() {
    printf "\033[00;34m$@\033[0m\n"
}

doPull() {
    echo "Updating dotfiles repo..."
    git pull origin master;
}

doPrograms() {
    PROGRAMS_TO_INSTALL=(
        git
    )

    echo "Installing essential programs like ${PROGRAMS_TO_INSTALL[@]}..."
    for PROGRAM_TO_INSTALL in ${PROGRAMS_TO_INSTALL[@]}; do
        echo "Installing $PROGRAM_TO_INSTALL..."
        sudo apt install -y $PROGRAM_TO_INSTALL
        echo "...$PROGRAM_TO_INSTALL installed."
    done
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
    rsync -azvhP .config/smartgit/* ~/.config/smartgit

    echo "Setting GRUB's timeout to zero..."
    sudo sed -i 's/GRUB_TIMEOUT=.*/GRUB_TIMEOUT=0/' /etc/default/grub
}

doImport() {
    echo "Importing base dotfiles..."
    rsync -azvhP --no-perms ~/.screenrc ~/.profile .

    echo "Importing SmartGit preferences..."
    rsync -azvhP --no-perms ~/.config/smartgit/19.1/repository-grouping.yml .config/smartgit
    rsync -azvhP --no-perms ~/.config/smartgit/19.1/ui-* .config/smartgit
}

doMonitors() {
    echo "Adjusting LVDS1..."
    xrandr --output LVDS1 --pos 0x435

    echo "Adjusting HDMI1..."
    xrandr --output HDMI1 --pos 3286x68
}

doHelp() {
    echo "Usage: $(basename "$0") [options]" >&2
    echo
    echo "  --pull                Updates this repo (git pull)"
    echo "  --import              Imports home directory's dotfiles"
    echo "  --install             Installs these dotfiles to home directory"
    echo "  --programs            Installs essential programs I cannot live without"
    echo "  --monitors            Adjusts monitors position"
    echo
    exit 1
}

if [ $# -eq 0 ]; then
    doHelp
else
    for i in "$@"
    do
        case $i in
            --pull)
                doPull
                shift
                ;;
            --install)
                doPull
                doInstall
                shift
                ;;
            --import)
                doImport
                shift
                ;;
            --programs)
                doPrograms
                shift
                ;;
            --monitors)
                doMonitors
                shift
                ;;
            *)
                doHelp
                shift
                ;;
        esac
    done
fi
