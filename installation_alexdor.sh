#! /bin/bash -x

#Script for installing on Ubuntu the following programms 
	#Tools: Wget, Git, Flash, Dropbox, Y PPA Manager, Ubuntu Make, Ubuntu restricted 
	#Text Editors: Vim, Bluefish, Atom, Sublime, Light Table
	#Multimedia Vlc, Gimp, Spotify, Libavcodec
	#Browsers: Firefox for developers, Chromium, Chrome
	#Mail Clients / IM: Thunderbird, Skype
	#Security: Iptables, Wireshark, Hydra, Nmap, Aircrack-ng, Medusa, Metasploit, Burpsuite
	#Compilers: Python, Oracle's jdk 8, Ruby, G++
	#IDEs: Octave, Codeblocks, Brackets, IntelliJ IDEA, Android Studio, Eclipse, Pycharm

#Check if the script has root privileges 
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 
   exit 1
fi

echo "Start"

#Add necessary repositories 
	add-apt-repository -y ppa:libreoffice/ppa #libreoffice oficial repo
	add-apt-repository -y  ppa:ubuntu-mozilla-daily/firefox-aurora  #firefox for developers
	add-apt-repository -y  ppa:otto-kesselgulasch/gimp  #gimp latest stable version
	add-apt-repository -y  ppa:videolan/stable-daily  #vlc latest stable version
	apt-add-repository "deb http://repository.spotify.com stable non-free"  #spotify
	apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 94558F59 #spotify public key
	add-apt-repository -y  ppa:webupd8team/java  #oracle java
	add-apt-repository -y  ppa:webupd8team/atom  #atom text editor
	add-apt-repository -y  ppa:webupd8team/brackets  #brackets
	wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - #Add key for Chrome
	sh -c 'echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list'  #set repo for Chrome
	apt-key adv --keyserver pgp.mit.edu --recv-keys 5044912E # Add key for Dropbox
	add-apt-repository -y  "deb http://linux.dropbox.com/ubuntu $(lsb_release -sc) main"  # Add repo for Dropbox
	add-apt-repository -y  ppa:webupd8team/y-ppa-manager  # y ppa manager
	add-apt-repository -y  ppa:ubuntu-desktop/ubuntu-make  #Ubuntu Make
	apt-get update
	cd

#Tools
	apt-get -y install wget 
	apt-get -y install git  
	apt-get -y install flashplugin-installer 
	apt-get -y install nautilus-dropbox 
	apt-get -y install y-ppa-manager 
	apt-get -y install ubuntu-make 
	apt-get -y install ubuntu-restricted-extras  


#Text Editors
	apt-get -y install vim 
	apt-get -y install bluefish 
	apt-get -y install atom 
	apt-get -y install sublime-text 
	#Light Table
		if [ $(getconf LONG_BIT) == "64" ];	then
		  	wget https://d35ac8ww5dfjyg.cloudfront.net/playground/bins/0.7.2/LightTableLinux64.tar.gz
		else
		  	wget https://d35ac8ww5dfjyg.cloudfront.net/playground/bins/0.7.2/LightTableLinux.tar.gz
		fi
		tar -xzf LightTable*.tar.gz -C /opt
		rm LightTable*.tar.gz
		echo -e "[Desktop Entry]\nVersion=1.0\nName=Light Table\nGenericName=Text Editor\nExec=/opt/LightTable/LightTable\nTerminal=false\nIcon=/opt/LightTable/core/img/lticon.png\nType=Application\nCategories=GTK;Utility;TextEditor;Application;IDE;Development;" >> "/usr/share/applications/light-table.desktop"
		chmod +x /usr/share/applications/light-table.desktop
		ln -s /opt/LightTable/LightTable /usr/local/bin/light-table
	
	#Sublime text 2
		if [ $(getconf LONG_BIT) == "64" ];	then
		  	wget http://c758482.r82.cf2.rackcdn.com/Sublime%20Text%202.0.2%20x64.tar.bz2
		else
		  	wget http://c758482.r82.cf2.rackcdn.com/Sublime%20Text%202.0.2.tar.bz2
		fi
		tar -xvf Sub*.bz2
		cp -rv Sublime\ Text\ 2 /opt
		rm -rf Sublime\ Text\ 2
		rm -rf Sub*.br2
		ln -s /opt/Sublime\ Text\ 2/sublime_text /usr/bin/sublime-text
		echo -e "[Desktop Entry]\nVersion=1.0\nName=Sublime Text 2\nGenericName=Text Editor\nExec=sublime\nTerminal=false\nIcon=/opt/Sublime Text 2/Icon/48x48/sublime_text.png\nType=Application\nCategories=TextEditor;IDE;Development\nX-Ayatana-Desktop-Shortcuts=NewWindow\n\n[NewWindow Shortcut Group]\nName=New Window\nExec=sublime -n\nTargetEnvironment=Unity" >> "/usr/share/applications/sublime.desktop"
		sed -i 's/gedit.desktop/Sublime-Text-2.desktop/g' /etc/gnome/defaults.list # Set Sublime Text as default text editor

#Multimedia
	apt-get -y install vlc 
	apt-get -y install gimp 
	apt-get -y install gimp-data 
	apt-get -y install gimp-plugin-registry 
	apt-get -y install gimp-data-extras 
	apt-get -y install spotify-client 
	apt-get -y install libavcodec-extra 

#Browsers
	apt-get -y install firefox 
	apt-get -y install chromium-browser 
	apt-get -y install google-chrome-stable 

#Mail Client / IM
	apt-get -y install thunderbird 
	apt-get -y install skype 

#Security
	apt-get -y install iptables 
	apt-get -y install wireshark 
	apt-get -y install hydra 
	apt-get -y install nmap 
	apt-get -y install aircrack-ng 
	apt-get -y install medusa 
	wget -P ~/Desktop http://portswigger.net/burp/burpsuite_free_v1.6.jar
	chmod +x ~/Desktop/burpsuite_free_v1.6.jar
	#Making user able to run wireshark without root privilages
	#You have to log out and log in again in order for the changes to take place
		addgroup -system wireshark 
		chown root:wireshark /usr/bin/dumpcap 
		setcap cap_net_raw,cap_net_admin=eip /usr/bin/dumpcap
		usermod -a -G wireshark $USER

# Compilers
	apt-get -y install ruby 
	apt-get -y install g++ 
	apt-get -y install python 
	apt-get -y purge openjdk* 
	echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections #accepts oracl's license
	apt-get -y install oracle-java8-installer 
	apt-get -y install oracle-java8-set-default  #Set Java environment variables
	#for open jdk: apt-get -y install openjdk-7-jdk 

#IDE
	apt-get -y install octave 
	apt-get -y install codeblocks 
	apt-get -y install brackets 
	umake android tools/android/android-studio
	umake ide idea tools/ide/idea
	umake ide eclipse tools/ide/eclipse
	umake ide pycharm tools/ide/pycharm

#Metasploit
if [ $(getconf LONG_BIT) == "64" ];	then
  	wget -O metasploit http://downloads.metasploit.com/data/releases/metasploit-latest-linux-x64-installer.run
else
  	wget -O metasploit http://downloads.metasploit.com/data/releases/metasploit-latest-linux-installer.run
fi
	chmod +x metasploit.run
	./metasploit.run
	rm -rf metasploit.run
	msfupdate #updates metasploit

#Cleaning up
	apt-get check
	apt-get -f install
	apt-get -y autoremove 
	apt-get -y autoclean 

echo "Done"

