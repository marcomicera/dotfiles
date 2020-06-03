#!/usr/bin/env bash

DOTFILES=$(pwd -P)

_pull() {
    echo "Updating dotfiles repo..."
    git pull origin master
}

_install_programs() {
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
    echo "Installing swagger-codegen..."
    wget https://repo1.maven.org/maven2/io/swagger/codegen/v3/swagger-codegen-cli/3.0.19/swagger-codegen-cli-3.0.19.jar \
        -O ~/.local/bin/swagger-codegen-cli.jar
    echo "...swagger-codegen installed."

    # fish shell
    echo "Installing fish shell..."
    sudo apt-add-repository ppa:fish-shell/release-3 && sudo apt update && sudo apt install -y fish
    echo "...fish shell installed."

    # OhMyFish
    echo "Installing OhMyFish..."
    curl -L https://get.oh-my.fish | fish
    fish -c "omf doctor"
    fish -c "omf install bobthefish"
    echo "...OhMyFish installed."
}

_import_dotfiles() {
    echo "Importing sh/bash dotfiles..."
    rsync -azvhP --no-perms ~/.bashrc ~/.profile .

    echo "Importing screen dotfiles..."
    rsync -azvhP --no-perms ~/.screenrc .

    echo "Importing fish dotfiles..."
    rsync -azvhP --no-perms ~/.config/fish/config.fish .config/fish

    # echo "Importing SmartGit preferences..."
    # rsync -azvhP --no-perms ~/.config/smartgit/20.1/repository-grouping.yml .config/smartgit
    # rsync -azvhP --no-perms ~/.config/smartgit/20.1/ui-* .config/smartgit

    echo "Importing Visual Studio Code LaTeX-Workshop settings..."
    rsync -azvhP --no-perms ~/.config/Code/User/settings.json .config/Code/User
}

_install_dotfiles() {
    echo "Installing sh/bash dotfiles..."
    rsync -azvhP --no-perms .bashrc .profile ~
    
    echo "Installing screen dotfiles..."
    rsync -azvhP --no-perms .screenrc ~

    echo "Installing fish dotfiles..."
    rsync -azvhP --no-perms .config/fish/config.fish ~/.config/fish

    # echo "Installing SmartGit preferences..."
    # rsync -azvhP .config/smartgit/* ~/.config/smartgit

    echo "Setting GRUB's timeout to zero..."
    sudo sed -i 's/GRUB_TIMEOUT=.*/GRUB_TIMEOUT=0/' /etc/default/grub

    echo "Installing Visual Studio Code LaTeX-Workshop settings..."
    rsync -azvhP .config/Code/User/settings.json ~/.config/Code/User/
}

_print_help() {
    echo "Usage: $(basename "$0") [options]" >&2
    echo
    echo "  --help                Shows this help message"
    echo "  --pull                Updates this repo (git pull)"
    echo "  --import              Imports home directory's dotfiles"
    echo "  --install             Installs these dotfiles to home directory"
    echo "  --programs            Installs essential programs I cannot live without"
    echo
    exit 1
}

if [ $# -eq 0 ]; then
    _print_help
else
    for i in "$@"
    do
        case $i in
            --pull)
                _pull
                shift
                ;;
            --install)
                _pull
                _install_dotfiles
                shift
                ;;
            --import)
                _import_dotfiles
                shift
                ;;
            --programs)
                _install_programs
                shift
                ;;
            --help|*)
                _print_help
                shift
                ;;
        esac
    done
fi
