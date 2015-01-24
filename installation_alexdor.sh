#! /bin/bash -x

#Script for installing on Ubuntu the following programms 
#Tools: Wget, Git, Flash, Dropbox, Y PPA Manager, Ubuntu Make, Ubuntu restricted 
#Text Editors: Vim, Bluefish, Atom, Sublime
#Multimedia Vlc, Gimp, Spotify, Libavcodec
#Browsers: Firefox for developers, Chromium, Chrome
#Mail Clients / IM: Thunderbird, Skype
#Security: Iptables, Wireshark, Hydra, Nmap, Aircrack-ng, Medusa, Metasploit, Burpsuite
#Compilers: Python, Oracle's jdk 8, Ruby, G++
#IDEs: Octave, Codeblocks, Brackets, IntelliJ IDEA, Android Studio, Eclipse, Pycharm

echo "Start"

#Add necessary repositories 
add-apt-repository ppa:ubuntu-mozilla-daily/firefox-aurora -y #firefox for developers
add-apt-repository ppa:otto-kesselgulasch/gimp -y #gimp latest stable version
add-apt-repository ppa:videolan/stable-daily -y #vlc latest stable version
apt-add-repository "deb http://repository.spotify.com stable non-free" -y #spotify
apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 94558F59 #spotify public key
add-apt-repository ppa:webupd8team/java -y #oracle java
add-apt-repository ppa:webupd8team/sublime-text-2 -y #sublime text 2
add-apt-repository ppa:webupd8team/atom -y #atom text editor
add-apt-repository ppa:webupd8team/brackets -y #brackets
wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add - #Add key for Chrome
sh -c 'echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list' -y #set repo for Chrome
apt-key adv --keyserver pgp.mit.edu --recv-keys 5044912E # Add key for Dropbox
add-apt-repository "deb http://linux.dropbox.com/ubuntu $(lsb_release -sc) main" -y # Add repo for Dropbox
add-apt-repository ppa:webupd8team/y-ppa-manager -y # y ppa manager
add-apt-repository ppa:ubuntu-desktop/ubuntu-make -y #Ubuntu Make
apt-get update
cd

#Tools
apt-get install wget -y
apt-get install git -y 
apt-get install flashplugin-installer -y
apt-get install nautilus-dropbox -y
apt-get install y-ppa-manager -y
apt-get install ubuntu-make -y
apt-get install ubuntu-restricted-extras -y 


#Text Editors
apt-get install vim -y
apt-get install bluefish -y
apt-get install atom -y
apt-get install sublime-text -y
sed -i 's/sublime-text/gedit/' /usr/share/applications/defaults.list # Set Sublime Text as default text editor

#Sublime text 2 manually:
#for 32-bit: wget http://c758482.r82.cf2.rackcdn.com/Sublime%20Text%202.0.2.tar.bz2
#for 64-bit: wget http://c758482.r82.cf2.rackcdn.com/Sublime%20Text%202.0.2%20x64.tar.bz2
#tar -xvf Sub*.bz2
#cp -rv Sublime\ Text\ 2 /opt
#rm -rf Sublime\ Text\ 2
#rm -rf Sub*.br2
#ln -s /opt/Sublime\ Text\ 2/sublime_text /usr/bin/sublime
#echo -e "[Desktop Entry]\n Version=1.0 \n Name=Sublime Text 2 \n GenericName=Text Editor \n \n Exec=sublime \n Terminal=false \n Icon=/opt/Sublime Text 2/Icon/48x48/sublime_text.png \n Type=Application \n Categories=TextEditor;IDE;Development \n X-Ayatana-Desktop-Shortcuts=NewWindow \n \n [NewWindow Shortcut Group] \n Name=New Window \n Exec=sublime -n \n TargetEnvironment=Unity" >> "/usr/share/applications/sublime.desktop"
#sed -i  "s/gedit/sublime/g" "/usr/share/applications/defaults.list"

#Multimedia
apt-get install vlc -y
apt-get install gimp -y
apt-get install gimp-data -y
apt-get install gimp-plugin-registry -y
apt-get install gimp-data-extras -y
apt-get install spotify-client -y
apt-get install libavcodec-extra -y

#Browsers
apt-get install firefox -y
apt-get install chromium-browser -y
apt-get install google-chrome-stable -y

#Mail Client / IM
apt-get install thunderbird -y
apt-get install skype -y

#Security
apt-get install iptables -y
apt-get install wireshark -y
apt-get install hydra -y
apt-get install nmap -y
apt-get install aircrack-ng -y
apt-get install medusa -y
wget -P ~/Desktop http://portswigger.net/burp/burpsuite_free_v1.6.jar
chmod +x ~/Desktop/burpsuite_free_v1.6.jar
#Making user able to run wireshark without root privilages
#You have to log out and log in again in order for the changes to take place
addgroup -system wireshark 
chown root:wireshark /usr/bin/dumpcap 
setcap cap_net_raw,cap_net_admin=eip /usr/bin/dumpcap
usermod -a -G wireshark $USER

# Compilers
apt-get install ruby -y
apt-get install g++ -y
apt-get install python -y
apt-get purge openjdk* -y
echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | sudo /usr/bin/debconf-set-selections #accepts oracl's license
apt-get install oracle-java8-installer -y
apt-get install oracle-java8-set-default -y #Set Java environment variables
#for open jdk: apt-get install openjdk-7-jdk -y

#IDE
apt-get install octave -y
apt-get install codeblocks -y
apt-get install brackets -y
umake android tools/android/android-studio
umake ide idea tools/ide/idea
umake ide eclipse tools/ide/eclipse
umake ide pycharm tools/ide/pycharm

#Metasploit
wget http://downloads.metasploit.com/data/releases/metasploit-latest-linux-x64-installer.run
# for 32-bit: wget http://downloads.metasploit.com/data/releases/metasploit-latest-linux-installer.run
chmod +x metasploit-latest-linux-*.run
./metasploit-latest-linux-*.run
rm -rf metasploit*.run
msfupdate #updates metasploit

sublime-text #the first time you have to open sublime as root

#Cleaning up
apt-get check
apt-get -f install
apt-get autoremove -y
apt-get autoclean -y

echo "Done"

