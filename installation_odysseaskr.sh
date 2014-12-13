#!/bin/bash

# Script to setup necessary programs and tools
# Edited to work on LXDE (tested on Lubuntu 14.04.1 LTS x86_64)

echo "Start"
# Add needed repositories
add-apt-repository -y ppa:ubuntu-mozilla-daily/firefox-aurora
apt-get -y update

#=======================================================================

# Text Editors
apt-get -y install vim
# Sublime text 2
# Download
wget "http://c758482.r82.cf2.rackcdn.com/Sublime Text 2.0.2 x64.tar.bz2"
# Extract
tar -xvf "Sublime Text 2.0.2 x64.tar.bz2"
# Move folder
cp -rf Sublime\ Text\ 2 ~/Applications
rm -rf "Sublime Text 2"
# Create 
ln -s ~/Applications/Sublime\ Text\ 2/sublime_text /usr/bin/sublime
# Create menu item
touch /usr/share/applications/sublime.desktop
sudo echo -e "[Desktop Entry]
Version=1.0
Name=Sublime Text 2
# Only KDE 4 seems to use GenericName, so we reuse the KDE strings.
# From Ubuntu's language-pack-kde-XX-base packages, version 9.04-20090413.
GenericName=Text Editor

Exec=sublime
Terminal=false
Icon=/home/odysseas/Applications/Sublime Text 2/Icon/16x16/sublime_text.png
Type=Application
Categories=TextEditor;IDE;Development
X-Ayatana-Desktop-Shortcuts=NewWindow

[NewWindow Shortcut Group]
Name=New Window
Exec=sublime -n
TargetEnvironment=LXDE" >> sudo "/usr/share/applications/sublime.desktop"

# Set Sublime Text as default text editor
sed -i 's/sublime/gedit/' /usr/share/applications/defaults.list
sed -i 's/sublime/leafpad/' /usr/share/applications/defaults.list

#=======================================================================

# Multimedia 
apt-get -y install vlc
apt-get -y install gimp

#=======================================================================

# Browsers
apt-get -y install chromium-browser
apt-get -y install firefox

#=======================================================================

# Programming Languages
apt-get -y install ruby
# JDK 8 u25
wget --no-check-certificate --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn-pub/java/jdk/8u25-b17/jdk-8u25-linux-x64.tar.gz
tar zxvf jdk-8u25-linux-x64.tar.gz
cp -rf jdk1.8.0_25 ~/Applications
rm -rf jdk1.8.0_25
rm -rf jdk-8u25-linux-x64.tar.gz

#=======================================================================

# Other programming tools
apt-get -y install git
# pip
wget "https://bootstrap.pypa.io/get-pip.py"
python get-pip.py
pip install -U pip
rm -rf get-pip.py

#=======================================================================

# LAMP
# No -y to prevent autoconfiguring mysql
apt-get install lamp-server^

#=======================================================================

# IDEs
apt-get -y install codeblocks
apt-get -y install octave
#PyCharm
wget http://download.jetbrains.com/python/pycharm-community-4.0.2.tar.gz -O pycharm.tar.gz
tar -xzf pycharm.tar.gz
cp -rf pycharm-community-4.0.2 ~/Applications
rm -rf pycharm-community-4.0.2
rm -rf pycharm.tar.gz
cd ~/Applications/pycharm-community-4.0.2/bin/
./pycharm.sh
#Brackets
wget https://github.com/adobe/brackets/releases/download/release-1.0%2Beb4/Brackets.1.0.Extract.64-bit.deb -O brackets.deb
gdebi brackets.deb
rm -rf brackets.deb

#=======================================================================

# Mail client
apt-get -y install thunderbird

#=======================================================================

# File storage
apt-get -y install filezilla
# Dropbox
wget https://www.dropbox.com/download?dl=packages/ubuntu/dropbox_1.6.2_amd64.deb -O dropbox.deb
gdebi dropbox.deb
rm -rf dropbox.deb

#=======================================================================

# Office
apt-get -y install libreoffice

#=======================================================================

# Security
apt-get -y install wireshark
apt-get -y install aircrack-ng
apt-get -y install hydra
apt-get -y install nmap

#=======================================================================

# Remove unwanted Lubuntu programs
apt-get -y remove leafpad
apt-get -y remove abiword
apt-get -y remove gnumeric

echo "Done"