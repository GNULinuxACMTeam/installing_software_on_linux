#! /bin/bash -x

#Script for installing on Ubuntu the following programms
	#Tools: Wget, Git, Flash, Dropbox, Y PPA Manager, Ubuntu Make, Ubuntu restricted
	#Text Editors: Vim, Bluefish, Atom, Sublime
	#Multimedia Vlc, Gimp, Spotify, Libavcodec
	#Browsers: Firefox for developers, Chromium, Chrome
	#Mail Clients / IM: Thunderbird, Skype
	#Security: Iptables, Wireshark, Hydra, Nmap, Aircrack-ng, Medusa, Metasploit, Burpsuite
	#Compilers: Python, Oracle's jdk 8, Ruby, G++, GCC
	#IDEs: IntelliJ IDEA, Android Studio, Eclipse, Pycharm

export logDir="/var/log/installation_script"
export logFile="$logDir/installation_script_ubuntu.log"
export architecture=$(uname -m)
export tempDir=$(mktemp -d /tmp/tempdir.XXXXXXXX) # Create temp directory


# Check for root privilages
function check_root_privilages(){
 if [[ $EUID -ne 0 ]]; then
   echo "This script needs root privilages"
   exit 1
  fi
  }

# Check the internet connection
function check_conection(){
  if ![ "$(ping -c 1 google.com)" ];then
    echo "Please check your internet connection and execute the script again"
    exit 2
  fi
}

# Create log directory
function create_log_directory()
    {
    	if [ ! -d $logDir ];then
    		mkdir $logDir
    		chown $USER:$USER $logDir
    	fi
    	if [ -e $logFile ];then
    		mv $logFile $logFile$(date +%Y%m%d).log
    		touch $logFile
    	fi
    }

# Write log file
function write_log(){
  #TO DO
  if [ -z "$2" ];then
    echo "$1 : Parameter error" >> $logFile
  else
    case $2 in
      0)
        echo "$1 : successfully installed" >> $logFile
        ;;
      $alreadyInstalledCode)
        echo "$1 : already installed" >> $logFile
        ;;
      *)
        echo "$1 : installation failed (error code = $2)" >> $logFile
        displayLog=true
        ;;
      esac
    fi
}

# Install applications from reposittories
function install_repo_apps(){
  name=$1[@]
  arrayName=("${!name}")
  for i in "${arrayName[@]}"; do
    if ! appLocation="$(type -p "$i")" || [ -z "$appLocation" ]; then # Check if the application isn't installed
      apt-get install -y $i
      exitLog=$?
      write_log $i $exitLog
    else
      write_log $i $alreadyInstalledCode
    fi
  done
}

# Add repositories
function add_repositories(){
	add-apt-repository -y ppa:libreoffice/ppa #Libreoffice oficial repo
	add-apt-repository -y  ppa:ubuntu-mozilla-daily/firefox-aurora  #Firefox for developers
	add-apt-repository -y  ppa:otto-kesselgulasch/gimp  #Gimp latest stable version
	add-apt-repository -y  ppa:videolan/stable-daily  #Vlc latest stable version
	apt-add-repository "deb http://repository.spotify.com stable non-free"  #Spotify
	apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 94558F59 #Spotify public key
	add-apt-repository -y  ppa:webupd8team/java  #Oracle java
	add-apt-repository -y  ppa:webupd8team/atom  #Atom text editor
	wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - #Add key for Chrome
	sh -c 'echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list'  #Set repo for Chrome
	apt-key adv --keyserver pgp.mit.edu --recv-keys 5044912E #Add key for Dropbox
	add-apt-repository -y  "deb http://linux.dropbox.com/ubuntu $(lsb_release -sc) main"  #Add repo for Dropbox
	add-apt-repository -y  ppa:webupd8team/y-ppa-manager  #Y ppa manager
	add-apt-repository -y  ppa:ubuntu-desktop/ubuntu-make  #Ubuntu Make
	apt-get update
}

function install_sublime_text_2(){
  cd $tempDir
		if [ $architecture == "x86_64" ];	then
		  	wget http://c758482.r82.cf2.rackcdn.com/Sublime%20Text%202.0.2%20x64.tar.bz2
		else
		  	wget http://c758482.r82.cf2.rackcdn.com/Sublime%20Text%202.0.2.tar.bz2
		fi
		tar -xvf Sub*.bz2
		cp -rv Sublime\ Text\ 2 /opt
		ln -s /opt/Sublime\ Text\ 2/sublime_text /usr/bin/sublime-text
		echo -e "[Desktop Entry]\nVersion=1.0\nName=Sublime Text 2\nGenericName=Text Editor\nExec=sublime\nTerminal=false\nIcon=/opt/Sublime Text 2/Icon/48x48/sublime_text.png\nType=Application\nCategories=TextEditor;IDE;Development\nX-Ayatana-Desktop-Shortcuts=NewWindow\n\n[NewWindow Shortcut Group]\nName=New Window\nExec=sublime -n\nTargetEnvironment=Unity" >> "/usr/share/applications/sublime.desktop"
}

declare -a tools=(wget curl git tmux zsh nautilus-dropbox y-ppa-manager ubuntu-make ubuntu-restricted-extras) #Tools
declare -a textEditor=(vim bluefish atom) #Text Editors
declare -a multimedia=(vlc gimp gimp-data gimp-data-extras gimp-plugin-registry spotify-client libavcodec-extra) #Multimedia
declare -a browsers=(firefox chromium-browser google-chrome-stable) #Browsers
declare -a mailClient=(thunderbird skype) #Mail Client / IM
declare -a security=(iptables wireshark hydra nmap aircrack-ng medusa) #Security
declare -a compilers=(ruby g++ gcc oracle-java8-installer oracle-java8-set-default ) #Compilers

echo "Start"

check_conection
check_root_privilages
add_repositories
create_log_directory

apt-get -y purge openjdk* #delete openjdk
echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections # Accepts oracl's license


# Install all the programms
install_repo_apps tools
install_repo_apps textEditor
install_repo_apps multimedia
install_repo_apps browsers
install_repo_apps mailClient
install_repo_apps compilers
install_repo_apps security
install_sublime_text_2

# Install IDEs
	echo "a" | umake android /opt/android-Studio # Auto accept android-studio license
	umake ide idea /opt/idea
	umake ide eclipse /opt/eclipse
	umake ide pycharm /opt/pycharm

# Make user able to run wireshark without root privilages, changes take efect after log out and log in
		addgroup -system wireshark
		chown root:wireshark /usr/bin/dumpcap
		setcap cap_net_raw,cap_net_admin=eip /usr/bin/dumpcap
		usermod -a -G wireshark $USER

  sed -i 's/gedit.desktop/atom/g' /etc/gnome/defaults.list # Set Atom as default text editor

# Stop Ubuntu from violating your privacy, more about the script here: https://fixubuntu.com/
  wget -q -O - https://fixubuntu.com/fixubuntu.sh | bash

#Cleaning up
  rm -f $tempDir
	apt-get check
	apt-get -f install
	apt-get -y autoremove
	apt-get -y autoclean

echo "Done"
