#!/bin/bash

#LAMP
yum -y install httpd
yum -y install php php-mysql
yum -y install mysql mysql-server

#Thunderbird
yum -y install thunderbird

#Skype
wget -O skype.rpm http://www.skype.com/go/getskype-linux-beta-fc10
yum -y install libXv.i686 libXScrnSaver.i686 qt.i686 qt-x11.i686 pulseaudio-libs.i686 pulseaudio-libs-glib2.i686 alsa-plugins-pulseaudio.i686
yum -y install skype.rpm

#Chrome
wget https://dl.google.com/linux/direct/google-chrome-stable_current_x86_64.rpm
yum -y install google-chrome-stable_current_x86_64.rpm

#Adobe Flash
yum -y install flash-plugin.x86_64 

#Octave
yum -y install octave

#C,C++ compilers, openjdk
yum -y install gcc
yum -y install gcc-c++
yum -y install java-1.8.0-openjdk-devel.x86_64

#Atom text editor
wget -O atom.rpm https://atom.io/download/rpm
yum -y install atom.rpm

#nmap
yum -y install nmap

#git
yum -y install git

#Codeblocks, NetBeans
yum -y install codeblocks

wget http://download.netbeans.org/netbeans/8.0.2/final/bundles/netbeans-8.0.2-linux.sh
chmod +x netbeans-8.0.2-linux.sh
./netbeans-8.0.2-linux.sh

#Metasploit
wget http://downloads.metasploit.com/data/releases/metasploit-latest-linux-installer.run
chmod +x metasploit*.run
./metasploit.run
