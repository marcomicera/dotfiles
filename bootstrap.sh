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
    echo "Running apt update..."
    sudo apt update

    PROGRAMS_TO_INSTALL=(
        # Utilities
        curl
        dconf-editor
        tldr
		vim
		htop
        # Dev
        openjdk-8-jdk-headless
        openjdk-11-jdk-headless
        scala
        python3
        python3-pip
        # LaTeX
        texlive-latex-base
        texlive-xetex
		texlive-luatex
		texlive-fonts-extra
    )

    echo "Installing essential programs like ${PROGRAMS_TO_INSTALL[@]}..."
    for PROGRAM_TO_INSTALL in ${PROGRAMS_TO_INSTALL[@]}; do
        echo "Installing $PROGRAM_TO_INSTALL..."
        sudo apt install -y $PROGRAM_TO_INSTALL
        echo "...$PROGRAM_TO_INSTALL installed."
    done

    # sbt
    echo "Installing sbt..."
    echo "deb https://dl.bintray.com/sbt/debian /" | sudo tee -a /etc/apt/sources.list.d/sbt.list
    curl -sL "https://keyserver.ubuntu.com/pks/lookup?op=get&search=0x2EE0EA64E40A89B84B2DF73499E82A75642AC823" | sudo apt-key add
    sudo apt update
    sudo apt install -y sbt
    echo "...sbt installed."

    # swagger-codegen
    wget https://repo1.maven.org/maven2/io/swagger/codegen/v3/swagger-codegen-cli/3.0.19/swagger-codegen-cli-3.0.19.jar \
        -O ~/.local/bin/swagger-codegen-cli.jar
}

doInstall() {
    echo "Installing these dotfiles into home directory..."
    rsync --exclude ".git/" \
        --exclude ".gitignore" \
        --exclude "README.md" \
        --exclude "LICENSE" \
        --exclude "bootstrap.sh" \
        --filter=':- .gitignore' \
        -azvhP --no-perms ./.* ~;

    # echo "Installing SmartGit preferences..."
    # rsync -azvhP .config/smartgit/* ~/.config/smartgit

    echo "Setting GRUB's timeout to zero..."
    sudo sed -i 's/GRUB_TIMEOUT=.*/GRUB_TIMEOUT=0/' /etc/default/grub

    echo "Installing Visual Studio Code LaTeX-Workshop settings..."
    rsync -azvhP .config/Code/User/settings.json ~/.config/Code/User/
}

doImport() {
    echo "Importing base dotfiles..."
    rsync -azvhP --no-perms ~/.bashrc ~/.screenrc ~/.profile .

    # echo "Importing SmartGit preferences..."
    # rsync -azvhP --no-perms ~/.config/smartgit/20.1/repository-grouping.yml .config/smartgit
    # rsync -azvhP --no-perms ~/.config/smartgit/20.1/ui-* .config/smartgit

    echo "Importing Visual Studio Code LaTeX-Workshop settings..."
    rsync -azvhP --no-perms ~/.config/Code/User/settings.json .config/Code/User
}

doHelp() {
    echo "Usage: $(basename "$0") [options]" >&2
    echo
    echo "  --pull                Updates this repo (git pull)"
    echo "  --import              Imports home directory's dotfiles"
    echo "  --install             Installs these dotfiles to home directory"
    echo "  --programs            Installs essential programs I cannot live without"
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
            *)
                doHelp
                shift
                ;;
        esac
    done
fi
