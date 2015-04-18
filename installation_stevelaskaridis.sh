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
    function install_from_repo()
    {
      CURRENT=$1
      if ! APP_LOCATION="$(type -p "$CURRENT")" || [ -z "$APP_LOCATION" ]; then
        sudo apt-get install -y $CURRENT
        EXIT_CODE=$?
        write_log $CURRENT $EXIT_CODE
      else
        write_log $CURRENT $ALREADY_INSTALLED_CODE
      fi
    }

    create_log_directory
    add_new_ppas
    # Tools
    install_from_repo 'unity-tweak-tool'
    install_from_repo 'wget'

    # Text Editors
    install_from_repo 'vim'

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
    install_from_repo 'gcc'
    install_from_repo 'g++'
    install_from_repo 'openjdk-7'
    install_from_repo 'python3'
    install_from_repo 'git'

    CURRENT='rvm'
    if ! APPLOCATION="$(type -p "$CURRENT")" || [ -z "$APPLOCATION" ]; then
      gpg --keyserver hkp://keys.gnupg.net --recv-keys D39DC0E3
      \curl -sSL https://get.rvm.io | bash -s stable --ruby
      EXIT_CODE=$?
      write_log $CURRENT $EXIT_CODE
    else
      write_log $CURRENT $ALREADY_INSTALLED_CODE
    fi

    # IDEs
    install_from_repo 'codeblocks'

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
    install_from_repo 'firefox'
    install_from_repo 'thunderbird'
    install_from_repo 'chromium'
    install_from_repo 'apache2'

    # Multimedia
    install_from_repo 'gimp'
    install_from_repo 'VLC'
    install_from_repo 'spotify'

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
        -u|--user)
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
