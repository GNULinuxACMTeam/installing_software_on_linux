#!/bin/bash/ -x
mkdir ~/Applications

#photo editing
apt-get -y install gimp
#media player
apt-get -y install VLC
#music player
apt-get -y install totem 

#for general programming usage
apt-get -y install git

#IDEs
mkdir pycharm
wget http://download.jetbrains.com/python/pycharm-community-4.0.2.tar.gz -O pycharm.tar.gz
tar xfz pycharm-*.tar.gz
cp -rf pycharm-community-4.0.2 ~/Applications/pycharm
rm -rf pycharm-community-4.0.2
#to save disc space
rm -rf pycharm.tar.gz

apt-get -y install brackets
apt-get -y install Octave
apt-get -y install netbeans
apt-get -y install codeblocks

#compilers
apt-get -y install jdk
apt-get -y install ruby
apt-get -y install python

#security
apt-get -y install wireshark
apt-get -y install metasploit
apt-get -y install aircrack-ng
apt-get -y install nmap
apt-get -y install hydra
apt-get -y install iptables
#medusa is similar to hydra.
apt-get -y install medusa
#/Burpsuite
mkdir ~/Applications/burpsuite
wget http://portswigger.net/burp/burpsuite_free_v1.6.jar
cp -rf burpsuite_free_v1.6.jar ~/Applications/burpsuite
#/John_The_Ripper
mkdir ~/Applications/John_The_Ripper
sudo -sH
wget http://www.openwall.com/john/j/john-1.8.0.tar.gz
tar -xvzf john-1.8.0.tar.gz
cp -rf "john-1.8.0" ~/Applications/John_The_Ripper
rm -rf "john-1.8.0"
rm -rf "john-1.8.0.tar.gz"
cd ~/Applications/John_The_Ripper/John-1.8.0/src
make clean linux-x86-64
#make clean linux-x86-sse2   for 32-bit system 
#to return to the working directory
cd

#web services
apt-get -y install Skype
#/mail service
apt-get -y install Thunderbird
#/dropbox
wget https://linux.dropbox.com/packages/ubuntu/dropbox_1.6.2_amd64.deb
sudo dpkg -i dropbox_1.6.2_amd64.deb
#/browsers
add-apt-repository ppa:ubuntu-mozilla-daily/firefox-aurora
apt-get -y update
apt-get -y install firefox
apt-get -y install tor

#text editors
apt-get -y install vim

wget http://c758482.r82.cf2.rackcdn.com/Sublime%20Text%202.0.2%20x64.tar.bz2
tar -xvf "Sublime Text 2.0.2 x64.tar.bz2"
cp -rf "Sublime Text 2" ~/Applications
rm -rf  "Sublime Text 2"
ln -s ~/Applications/Sublime\ Text\ 2/sublime_text /usr/bin/sublime
touch /usr/share/applications/sublime.desktop
echo -e "[Desktop Entry]\nVersion=1.0\nName=Sublime Text 2\n# Only KDE 4 seems to use GenericName, so we reuse the KDE strings.\n# From Ubuntu's language-pack-kde-XX-base packages, version 9.04-20090413.\nGenericName=Text Editor\nExec=sublime\nTerminal=false\nIcon=/opt/Sublime Text 2/Icon/48x48/sublime_text.png\nType=Application\nCategories=TextEditor;IDE;Development\nX-Ayatana-Desktop-Shortcuts=NewWindow\n[NewWindow Shortcut Group]\nName=New Window\nExec=sublime -n\nTargetEnvironment=Unity">> "/usr/share/applications/sublime.desktop"
apt-get -y install sublime-text
sed -i "s/gedit/sublime/g" "default.desktop"

#LAMP
apt-get -y install apache2
# -y missing in order to avoid unwanted configuration of mysql
apt-get install mysql-server
apt-get -y install php5 libapache2-mod-php5
/etc/init.d/apache2 restart
#check php
php -r 'echo "\n\nYour PHP installation is working fine.\n\n\n";'
echo "End of installation_mpoiitis.sh"
