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

