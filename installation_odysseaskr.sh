#!/bin/bash

# Script to setup necessary programs and tools
# Edited to work on LXDE (tested on Lubuntu 14.04.1 LTS x86_64)

echo "Start"
# Add needed repositories
add-apt-repository -y ppa:ubuntu-mozilla-daily/firefox-aurora
add-apt-repository -y ppa:webupd8team/sublime-text-2
apt-get -y update

# Prepare the Application folder
mkdir ~/Applications

# Get gdebi to install .deb
apt-get -y install gdebi

#=======================================================================

# Text Editors
apt-get -y install vim
apt-get -y install sublime-text

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

# Compilers
apt-get -y install ruby
apt-get -y install openjdk-7-jdk
apt-get -y install g++

#=======================================================================

# Other programming tools
apt-get -y install git
# pip
wget "https://bootstrap.pypa.io/get-pip.py"
python get-pip.py
pip install -U pip
rm -rf get-pip.py

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
ln -s ~/Applications/pycharm-community-*/bin/pycharm.sh /usr/bin/pycharm
#Brackets
wget https://github.com/adobe/brackets/releases/download/release-1.0%2Beb4/Brackets.1.0.Extract.64-bit.deb -O brackets.deb
gdebi brackets.deb
rm -rf brackets.deb
# IntelliJ
wget http://download.jetbrains.com/idea/ideaIC-14.0.2.tar.gz -O intelliJ.tar.gz
tar -xzf intelliJ.tar.gz
cp -rf idea-IC-139.659.2 ~/Applications
rm -rf idea-IC-139.659.2
rm -rf intelliJ.tar.gz
ln -s ~/Applications/idea-IC-*/bin/idea.sh /usr/bin/intellij

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
apt-get -y install iptables
cd ~/Applications
wget http://portswigger.net/burp/burpsuite_free_v1.6.jar

#=======================================================================

# LAMP
apt-get -y install lamp-server^

#=======================================================================

# Remove unwanted Lubuntu programs
apt-get -y remove leafpad
apt-get -y remove abiword
apt-get -y remove gnumeric

echo "Done"