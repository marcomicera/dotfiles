# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022

# if running bash
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
	. "$HOME/.bashrc"
    fi
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi

# esp-idf
if [ -d "$HOME/esp/esp-idf/" ] ; then
    . $HOME/esp/esp-idf/export.sh
fi

export GPG_TTY=$(tty)

# OneDrive client
# systemctl --user enable onedrive
# systemctl --user start onedrive

# Java
export JAVA_HOME=$(readlink -f /usr/bin/java | sed "s:jre/bin/java::")

# Tomcat
if [ -d "/opt/apache-tomcat-8.5.20" ] ; then
    export CATALINA_HOME=/opt/apache-tomcat-8.5.20
fi

# Minimize running window on click
gsettings set org.gnome.shell.extensions.dash-to-dock click-action 'minimize'

# Golang
export PATH=$PATH:/usr/local/go/bin
export GOPATH=$(go env GOPATH)
