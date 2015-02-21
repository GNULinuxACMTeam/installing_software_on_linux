#!/bin/bash -x

# Installing Software

#################################################################
#
# System Info:
#   OS: Ubuntu 14.04 Trusty Tahr 64-bit
#   Implementation: VMware VM running on VMware Fusion 7 and
#                   VMware Workstation 10
#
#
#
##################################################################

# Extensions:
#   Check what's installed and what's not


export M_USER=$USER
export LOG_DIR='/var/log/installation-script'
export LOG_FILE="$LOG_DIR/log_installation_script"
export ALREADY_INSTALLED_CODE=1
export PARAM_ERROR=200

function install_new_software()
{
    cd /tmp;dir=`mktemp -d` && cd $dir
    
    function add_new_ppas()
    {
        sudo add-apt-repository -y ppa:ubuntu-mozilla-daily/firefox-aurora
        sudo add-apt-repository -y "deb http://repository.spotify.com stable non-free" && apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 94558F59
        sudo apt-get update
    }

    function create_log_directory()
    {
    	if [ ! -d $LOG_DIR ];then
    		sudo mkdir $LOG_DIR
    		sudo chown $USER:$USER $LOG_DIR
    	fi
    	if [ -e $LOG_FILE ];then
    		sudo mv $LOG_FILE "$LOG_FILE.`date`"
    		sudo touch %LOG_FILE
    	fi
    }

    function write_log()
    {
        if [ -z "$2" ];then
            return $PARAM_ERROR
        else
		    if [ $2 -eq 0 ];then
	            echo "$1 ... installed" >> $LOG_FILE
	        elif [ $2 -eq $ALREADY_INSTALLED_CODE ];then
	        	echo "$1 ... already installed" >> $LOG_FILE
	        else
                echo "$1 ... failed" >> $LOG_FILE
            fi
        fi
    }
    
    function make_installation()
    {
        if [ ! -d /home/$M_USER/Applications ];then
            mkdir /home/$M_USER/Applications
        fi
        cp "$1" home/$M_USER/Applications
        sudo ln -s "/home/$M_USER/Applications/$1/$2" /usr/local/bin/$3
        return $?
    }

    create_log_directory
    add_new_ppas
    # Tools
    CURRENT='unity-tweak-tool'
    sudo apt-get install -y $CURRENT
    EXIT_CODE=$?
    write_log $CURRENT $EXIT_CODE 

    CURRENT='wget'
    sudo apt-get install -y wget
    EXIT_CODE=$?
    write_log $CURRENT $EXIT_CODE
    
    # Text Editors
    CURRENT='vim'
    sudo apt-get install -y vim
    EXIT_CODE=$?
    write_log $CURRENT $EXIT_CODE

    CURRENT='sublime'
    if [ ! -e /usr/bin/subl ];then
	    wget http://c758482.r82.cf2.rackcdn.com/sublime-text_build-3065_amd64.deb
	    sudo dpkg -i sublime-text_build-3065_amd64.deb
	    EXIT_CODE=$?
	    write_log $CURRENT $EXIT_CODE 
	else
		write_log $CURRENT $ALREADY_INSTALLED_CODE
	fi

    CURRENT='atom'
    if [ ! -e /usr/bin/atom ];then
        wget https://atom.io/download/deb
        sudo dpkg -i deb
        EXIT_CODE=$?
    	write_log $CURRENT $EXIT_CODE
		sudo apt-get -f install
	else
		write_log $CURRENT $ALREADY_INSTALLED_CODE
    fi
    # change defaults
    sudo sed -i 's/gedit/sublime/g' /usr/share/applications/defaults.list
    
    # Programming tools
    CURRENT='gcc'
    sudo apt-get install -y gcc
    EXIT_CODE=$?
    write_log $CURRENT $EXIT_CODE 

    CURRENT='g++'
    sudo apt-get install -y g++
    EXIT_CODE=$?
    write_log $CURRENT $EXIT_CODE 

    CURRENT='openjdk-7'
    sudo apt-get install -y openjdk-7-jdk
    EXIT_CODE=$?
    write_log $CURRENT $EXIT_CODE 

    CURRENT='python3'
    sudo apt-get install -y python3
    EXIT_CODE=$?
    write_log $CURRENT $EXIT_CODE 

    CURRENT='rvm'
    gpg --keyserver hkp://keys.gnupg.net --recv-keys D39DC0E3
    \curl -sSL https://get.rvm.io | bash -s stable --ruby
    EXIT_CODE=$?
    write_log $CURRENT $EXIT_CODE 
    
    CURRENT='git'
    sudo apt-get install -y git
    EXIT_CODE=$?
    write_log $CURRENT $EXIT_CODE 

    # IDEs
    CURRENT='codeblocks'
    sudo apt-get install -y codeblocks
    EXIT_CODE=$?
    write_log $CURRENT $EXIT_CODE 
   

 	CURRENT='eclipse'
    if [ ! -h /usr/local/bin/eclipse ];then
        wget http://ftp.ntua.gr/eclipse/technology/epp/downloads/release/luna/SR1/eclipse-java-luna-SR1-linux-gtk-x86_64.tar.gz
        tar -xzf eclipse-java-luna-SR1-linux-gtk-x86_64.tar.gz; make_installation "eclipse" "eclipse" "eclipse"
        EXIT_CODE=$?
    	write_log $CURRENT $EXIT_CODE
    else
    	write_log $CURRENT $ALREADY_INSTALLED_CODE
    fi


    CURRENT='pycharm'
    if [ ! -h /usr/local/bin/pycharm ];then
        wget http://download.jetbrains.com/python/pycharm-community-4.0.3.tar.gz
        tar -xzf pycharm-community-4.0.3.tar.gz; make_installation "pycharm-community-4.0.3" "bin/pycharm.sh" "pycharm"
        EXIT_CODE=$?
    	write_log $CURRENT $EXIT_CODE
    else
    	write_log $CURRENT $ALREADY_INSTALLED_CODE
    fi
   

   CURRENT='rubymine'
    if [ ! -h /usr/local/bin/rubymine ];then 
        wget http://download.jetbrains.com/ruby/RubyMine-7.0.2.tar.gz
        tar -xzf RubyMine-7.0.2.tar.gz; make_installation "RubyMine-7.0.2" "bin/rubymine.sh" "rubymine"
        EXIT_CODE=$?
    	write_log $CURRENT $EXIT_CODE
    else
    	write_log $CURRENT $ALREADY_INSTALLED_CODE
    fi
    
    # Internet
    CURRENT='firefox'
    sudo apt-get install -y firefox
    EXIT_CODE=$?
    write_log $CURRENT $EXIT_CODE 

    CURRENT='thunderbird'
    sudo apt-get install -y thunderbird
    EXIT_CODE=$?
    write_log $CURRENT $EXIT_CODE 

    CURRENT='chromium'
    sudo apt-get install -y chromium-browser
    EXIT_CODE=$?
    write_log $CURRENT $EXIT_CODE 

    CURRENT='apache2'
    sudo apt-get install -y apache2
    EXIT_CODE=$?
    write_log $CURRENT $EXIT_CODE 
    
    # Multimedia
    CURRENT='gimp'
    sudo apt-get install -y gimp
    EXIT_CODE=$?
    write_log $CURRENT $EXIT_CODE 

    CURRENT='VLC'
    sudo apt-get install -y vlc
    EXIT_CODE=$?
    write_log $CURRENT $EXIT_CODE 

    CURRENT='spotify'
    sudo apt-get install -y --force-yes spotify-client
    EXIT_CODE=$?
    write_log $CURRENT $EXIT_CODE 

    # Cleanup
    rm -rf "/tmp/$dir"
}

function show_info()
{
    cat /proc/cpuinfo # cpu info
    cat /proc/meminfo # memory info
    cat /proc/version # kernel info
    cat /proc/partitions # partitions info   
}


# parse parameters
while [[ $# > 0 ]];do
    key="$1"
    shift    
    case $key in
        -i|--info)
            show_info
        shift
        ;;
        --u|--user)
            $M_USER="$1"
        shift
        ;;
        --install)
            install_new_software
        shift
        ;;
        *)
            echo -e "Wrong parameter: $key\n"
        ;;
    esac
done
