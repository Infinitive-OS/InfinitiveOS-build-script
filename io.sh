#!/bin/bash

# We don't allow scrollback buffer
# Adapted from AOSPA-L
echo -e '\0033\0143'
clear

# Our Rainbow
red='tput setaf 1'              # red
green='tput setaf 2'            # green
yellow='tput setaf 3'           # yellow
blue='tput setaf 4'             # blue
violet='tput setaf 5'           # violet
cyan='tput setaf 6'             # cyan
white='tput setaf 7'            # white
txtbld=$(tput bold)             # Bold
bldred=${txtbld}$(tput setaf 1) # Bold red
bldgrn=${txtbld}$(tput setaf 2) # Bold green
bldblu=${txtbld}$(tput setaf 4) # Bold blue
bldcya=${txtbld}$(tput setaf 6) # Bold cyan
normal='tput sgr0'

# ALL HAIL GREEN
tput setaf 2 

function IO_MAINSPLASH () {
	tput bold
	tput setaf 2 
	echo " "
	echo " "
	echo "				        #                     #         "
	echo "				         #                  ##          "
	echo "	I			          ###################           "
	echo "	N			        #######################         "
	echo "	F			      ###########################       "
	echo "	I			    ###############################     "
	echo "	N			   #################################    "
	echo "	I			  ##################################i   "
	echo "	T			  #######################      ######   "
	echo "	E			 #####f     ###########         ;####   "
	echo "				 #####        ########           #####  "
	echo "	O			 ####E         ######            #####  "
	echo "	S			 #####       #########           #####  "
	echo "				  #####     ###########         #####   "
	echo "				  ###############  ######      ######   "
	echo "				   ############     ################    "
	echo "				      ######          ############      "
	echo "				                        i#######        "
	tput sgr0
	tput setaf 2
}

function CURRENT_CONFIG () {
	tput bold 
	tput setaf 6
	echo -e "============================================================"
	echo -e " BUILD_ENV_SETUP = $BUILD_ENV_SETUP"
	echo -e ""
	echo -e " MAKE_CLEAN = $MAKE_CLEAN"
	echo -e " MAKE_CLOBBER = $MAKE_CLOBBER"
	echo -e " RESET_HARD = $RESET_HARD"
	echo -e " REPO_SYNC_BEFORE_BUILD = $REPO_SYNC_BEFORE_BUILD"
	echo -e ""
	echo -e " CHERRYPICK = $CHERRYPICK"
	echo -e " EXPORT_PACKAGE = $EXPORT_PACKAGE"
	echo -e "============================================================"
	tput sgr0
	tput setaf 2
}

function displayMainMenu() {
	echo -e ""
	if [[ -n $PRODUCT ]]; then
		echo -e "	  PRODUCT: $PRODUCT   "
	fi
	echo -e ""
	echo -e "  0. Enter Target product"
	echo -e "  1. Setup android Build environment & Initialize and Sync InfinitiveOS "
	echo -e "  2. Update configurations, Configure Build parameters"
	echo -e "  	 2a. Reset All configurations"
	echo -e "  3a. Export current config"
	echo -e "  3b. Restore current config"
	echo -e "  4. Build InfinitiveOS $PRODUCT"
	echo -e "  99. Exit"
	echo -e ""
	echo -e "  Enter choice : \c"
	read mainMenuChoice
	PROCESS_MENU $mainMenuChoice
}

function PROCESS_MENU() {
	case $mainMenuChoice in
		0) echo "Enter PRODUCT " && read PRODUCT ;;
		1) REPO_SYNC ;;
		2) CONFIGURE_BUILD_OPTIONS ;;
		2a) DEFCONFIG ;;
		3a) export_DEFCONFIG ;;
		3b) restore_IOConfig ;;
		4) export_DEFCONFIG
		   CURRENT_CONFIG
		   sleep 3
		   ./rom-build.sh $PRODUCT ;;
		99) exit ;;
		*) echo "  Invalid Option! ERROR!" ;;
	esac
	echo -e " Press any key to continue..."
	read blank
	clear
}

function REPO_SYNC {

 	echo -e ""
 	echo -e "Checking for java version"
 	JAVA_VER=$(java -version 2>&1 | sed 's/java version "\(.*\)\.\(.*\)\..*"/\1\2/; 1q')
 	if [[ $JAVA_VER -ge 17 ]]; then
 		echo -e "Found java version 1.7 or newer."
 	else
 		sudo -u ${USERNAME} apt-get purge openjdk-\* icedtea-\* icedtea6-\*
		sudo -u ${USERNAME} apt-get update && sudo apt-get install openjdk-7-jdk
 	fi

 	echo -e ""
 	echo -e "Is your build environment setup for building android?"
 	echo -e "if you dont know what it means, its better to say 0 (no)"
 	echo -e "1 for Yes, and 0 for no : \c"
 	read BUILD_ENV_SETUP

	
 	if [[ $BUILD_ENV_SETUP -ne 1 ]]; then
 		echo -e "Settings up repo.."
		sudo -u ${USERNAME} ln -s /usr/lib/i386-linux-gnu/mesa/libGL.so.1 /usr/lib/i386-linux-gnu/libGL.so
		mkdir ~/bin && curl http://commondatastorage.googleapis.com/git-repo-downloads/repo > ~/bin/repo && chmod a+x ~/bin/repo
		echo 'export PATH=~/bin:$PATH' | sudo tee --append ~/.bashrc
		source ~/.bashrc
		echo -e "Please enter your email id for Git config : \c"
		read uemail
		git config --global user.email "$uemail"
		echo -e "Please enter your name for Git config : \c"
		read uname
		git config --global user.name "$uname"
		PACKAGES=(git gnupg ccache lzop libglapi-mesa-lts-utopic:i386 libgl1-mesa-dri-lts-utopic:i386 flex bison gperf build-essential zip curl zlib1g-dev zlib1g-dev:i386 libc6-dev lib32bz2-1.0 lib32ncurses5-dev x11proto-core-dev libx11-dev:i386 libreadline6-dev:i386 lib32z1-dev libgl1-mesa-glx-lts-utopic:i386 libgl1-mesa-dev-lts-utopic g++-multilib mingw32 tofrodos python-markdown libxml2-utils xsltproc libreadline6-dev lib32readline-gplv2-dev libncurses5-dev bzip2 libbz2-dev libbz2-1.0 libghc-bzlib-dev lib32bz2-dev squashfs-tools pngcrush schedtool dpkg-dev)
	 	echo -e " Checking for required packages for building InfinitiveOS..."
		sleep 1.5
		for program in ${PACKAGES[@]} ; do
		 	program_status=`which $program`
	 		if [[ -n $program_status ]]; then
	 			echo "$program_status is NOT installed"
				sudo apt-get install $program 
			else
				echo -e "$program is installed"
	 		fi
	 	done
 	fi

 	echo -e "Do you want to initialize the repo?"
 	echo -e "1 for Yes, and 0 for no : \c"
 	read INIT

 	echo -e "Do you want to sync InfinitiveOS?"
 	echo -e "1 for Yes, and 0 for no : \c"
 	read SYNC

 	if [[ $INIT -eq 1 ]]; then
 		echo "Beginning to initialize and Sync InfinitiveOS...."
 		echo " This may take a while.."
 		repo init -u https://github.com/InfinitiveOS/platform_manifest -b io-1.0
 	fi

	if [[ $SYNC -eq 1 ]]; then
		echo -e "Does your device has a local_manifest?"
		echo -e "1 for Yes, and 0 for no : \c"	 		
		read $HAS_LOCAL_MANIFEST
 		if [[ $HAS_LOCAL_MANIFEST -eq 1 ]]; then
 			mkdir .repo/local_manifest
 			echo "Paste your local manifest in the file that will now open"
 			echo "After pasting, press ctrl+o followed by ctrl+x , to save and exit the file."
 			echo "Make sure you have all your Remotes and revisions set according else sync might fail. ; \c"
 			echo "Press any key to continue : \c"
 			read blank
 			nano .repo/local_manifest/local.xml
 		fi
 		if [[ -n $LAST_SYNC ]]; then
 			echo -e " Repo was last synced:"$LAST_SYNC
 		fi
 		repo sync
 		LAST_SYNC=`date +"%Y-%m-%d_%H-%M-%S`
 	fi
}

function CONFIGURE_BUILD_OPTIONS() {
	echo -e "begining to edit the default build options."
	echo -e "      "
	echo -e "     | Submit values in binary bits"
	echo -e "     | 1 for Yes, and 0 for No"
	echo -e ""
	echo -e "Is you Build enviornment set up? : BUILD_ENV_SETUP :  \c" && read BUILD_ENV_SETUP
	if [[ "$BUILD_ENV_SETUP" == "0" || "$BUILD_ENV_SETUP" == "1" ]]; then
		echo -e ""
	else
	echo -e "ERROR! Wrong parameters passed. Reconfigure"
	CONFIGURE_BUILD_OPTIONS
	fi

	echo -e "Make clean before starting the build? : MAKE_CLEAN :  \c" && read MAKE_CLEAN
	if [[ "$MAKE_CLEAN" == 0 || "$MAKE_CLEAN" == 1 ]]; then
		echo -e ""
	else
	echo -e "ERROR! Wrong parameters passed. Reconfigure"
	CONFIGURE_BUILD_OPTIONS
	fi

	echo -e "Make clobber before starting the build? : MAKE_CLOBBER :  \c" && read MAKE_CLOBBER
	if [[ $MAKE_CLOBBER == 0 || $MAKE_CLOBBER == 1 ]]; then
		echo -e ""
	else
	echo -e "ERROR! Wrong parameters passed. Reconfigure"
	CONFIGURE_BUILD_OPTIONS
	fi

	echo -e "Make InstallClean before starting the build? : MAKE_INSTALLCLEAN :  \c" && read MAKE_INSTALLCLEAN
	if [[ $MAKE_INSTALLCLEAN == 0 || $MAKE_INSTALLCLEAN == 1 ]]; then
		echo -e ""
	else
	echo -e "ERROR! Wrong parameters passed. Reconfigure"
	CONFIGURE_BUILD_OPTIONS
	fi

	echo -e "Repo sync before starting the build? : REPO_SYNC_BEFORE_BUILD :  \c" && read REPO_SYNC_BEFORE_BUILD
	if [[ $REPO_SYNC_BEFORE_BUILD == 0 || $REPO_SYNC_BEFORE_BUILD == 1 ]]; then
		echo -e ""
	else
	echo -e "ERROR! Wrong parameters passed. Reconfigure"
	CONFIGURE_BUILD_OPTIONS
	fi

	echo -e "repo forall -vc "git reset --hard" before syncing : RESET_HARD \c" && read REPO_SYNC_BEFORE_BUILD
	if [[ $RESET_HARD == 0 || $RESET_HARD == 1 ]]; then
		echo -e ""
	else
	echo -e "ERROR! Wrong parameters passed. Reconfigure"
	CONFIGURE_BUILD_OPTIONS
	fi

	echo -e "Export package after build completes? :EXPORT_PACKAGE  \c" && read REPO_SYNC_BEFORE_BUILD
	if [[ $EXPORT_PACKAGE == 0 || $EXPORT_PACKAGE == 1 ]]; then
		echo -e ""
	else
	echo -e "ERROR! Wrong parameters passed. Reconfigure"
	CONFIGURE_BUILD_OPTIONS
	fi

	export_DEFCONFIG
}

function DEFCONFIG {
	# Red
	tput setaf 1
	tput bold

	echo -e "  Loading defaults..\n"

	mode=Default

	#Option values
	export MAKE_CLEAN=1
	export MAKE_CLOBBER=0
	export MAKE_INSTALLCLEAN=0
	export REPO_SYNC_BEFORE_BUILD=1
	export BUILD_ENV_SETUP=0
	export CHERRYPICK=0
	export EXPORT_PACKAGE=1
	export RESET_HARD=0

	#Restore Green
	tput sgr0
	tput setaf 2

	export_DEFCONFIG

	return
}

function export_DEFCONFIG {
	echo -e " "
	echo -e "  Writing current configuration to io.config..."
	FIRST=1
	vars=(MAKE_CLEAN MAKE_CLOBBER REPO_SYNC_BEFORE_BUILD BUILD_ENV_SETUP CHERRYPICK EXPORT_PACKAGE RESET_HARD LAST_SYNC)
	for i in ${vars[@]}; do
		if [[ $FIRST -eq 1 ]]; then
			echo ${i}=$[$i] > io.config
			FIRST=0
		else
		echo ${i}=$[$i] >> io.config
        fi
	done
}

function restore_IOConfig {
	if [[ -f "./io.config" ]]; then
		vars=(MAKE_CLEAN MAKE_CLOBBER REPO_SYNC_BEFORE_BUILD BUILD_ENV_SETUP CHERRYPICK EXPORT_PACKAGE RESET_HARD LAST_SYNC)
		for i in ${vars[@]}; do
			while IFS='' read -r line || [[ -n $line ]]; do
				export ${i}=`grep "${i}" "io.config" | cut -d'=' -f2`
			done < "io.config"
		done
	fi
}

IO_MAINSPLASH

#Load default configurations
DEFCONFIG
echo -e " "
echo -e "  NOTE : We are using Binary inputs"
echo -e "  1 for Yes "
echo -e "  0 for No "

export_DEFCONFIG

sleep 2
clear

while [[ true ]]; do
	displayMainMenu
done

$normal