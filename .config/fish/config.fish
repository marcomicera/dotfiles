# Binary dirs
if test -d $HOME/bin
    set --global --export --append PATH $HOME/bin
end
if test -d $HOME/.local/bin
    set --global --export --append PATH $HOME/.local/bin
end

# esp-idf
if test -d $HOME/esp/esp-idf/
    bass source $HOME/esp/esp-idf/export.sh
end

set --global --export GPG_TTY (tty)

# OneDrive client
# systemctl --user enable onedrive
# systemctl --user start onedrive

# Java
set --global --export JAVA_HOME (readlink -f /usr/bin/java | sed "s:jre/bin/java::")

# Tomcat
if test -d /opt/apache-tomcat-8.5.20
    set --global --export CATALINA_HOME /opt/apache-tomcat-8.5.20
end

# Minimize running window on click
gsettings set org.gnome.shell.extensions.dash-to-dock click-action 'minimize'

# Golang
if begin test -d /usr/local/go/bin; and type -q go; end
    set --global --export --append PATH /usr/local/go/bin
    set --global --export GOPATH (go env GOPATH)
    set --global --export --append PATH $GOPATH/bin
end

# Prevent Gnome-shell's Alt+Tab from grouping windows from similar apps
dconf write /org/gnome/desktop/wm/keybindings/switch-windows "['<Alt>Tab']"
dconf write /org/gnome/desktop/wm/keybindings/switch-windows-backward "['<Shift><Alt>Tab', '<Alt>Above_Tab']"

# Gnome-restarter function
function gnome-shell-restart
  killall -9 gnome-shell
  exit
end

# Reset snap Spotify window position when stuck to full-screen
function fix-spotify
  sed -i '/app.window.position.saved=true/d' ~/snap/spotify/current/.config/spotify/prefs
end

# Swagger codegen
alias swagger-codegen='java -jar ~/.local/bin/swagger-codegen-cli.jar'

# Adjusts monitors position
function _get_display_name
  xrandr | grep connected | grep $argv[1] | awk '{print $1}'
end
function monitor
    echo "Adjusting notebook's display..."
    set notebook_display (_get_display_name LVDS)
    # xrandr --output $notebook_display --pos 0x435 # black stand
    xrandr --output $notebook_display --pos 0x170 # white stand
end
function monitors-no-base
    monitor

    echo "Adjusting HDMI display..."
    set hdmi_display (_get_display_name HDMI)
    xrandr --output $hdmi_display --pos 3286x68
end
function monitors
    monitor

    echo "Adjusting HDMI display..."
    set hdmi_display (_get_display_name HDMI)
    xrandr --output $hdmi_display --pos 3286x70
end

alias t="tail -n 25"
alias wt="watch -n 1 tail -n 25"

# Golang `go get` private repos
set --global --export GOPRIVATE github.com/marcomicera/*
