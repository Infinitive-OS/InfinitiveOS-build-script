#!/bin/bash

# We don't allow scrollback buffer
# Adapted from AOSPA-L
echo -e '\0033\0143'
clear

# ALL HAIL GREEN
tput setaf 2 

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


function IO_MAINSPLASH () {
	tput bold
	tput setaf 2 
	echo -e "   .___        _____.__       .__  __  .__             ________    _________"
	echo -e "   |   | _____/ ____\__| ____ |__|/  |_|__|__  __ ____ \_____  \  /   _____/"
	echo -e "   |   |/    \   __\|  |/    \|  \   __\  \  \/ // __ \ /   |   \ \_____  \ "
	echo -e "   |   |   |  \  |  |  |   |  \  ||  | |  |\   /\  ___//    |    \/        \ "
	echo -e "   |___|___|  /__|  |__|___|  /__||__| |__| \_/  \___  >_______  /_______  /"
	echo -e "           \/              \/                       \/        \/          \/"
	echo -e "                                                             Mode:  $mode "
	tput sgr0
	tput setaf 2
}

function CURRENT_CONFIG () {
	echo -e " "
	echo -e "  NOTE : We are using Binary inputs"
	echo -e "  1 for Yes "
	echo -e "  0 for No "
	tput bold 
	tput setaf 6
	echo -e "============================================================"
	echo -e " SHELL_IN_TARGET_DIR = $SHELL_IN_TARGET_DIR"
	echo -e ""
	echo -e " BUILD_ENV_SETUP = $BUILD_ENV_SETUP"
	echo -e ""
	echo -e " MAKE_CLEAN = $MAKE_CLEAN"
	echo -e " MAKE_CLOBBER = $MAKE_CLOBBER"
	echo -e " MAKE_INSTALLCLEAN = $MAKE_INSTALLCLEAN"
	echo -e " REPO_SYNC_BEFORE_BUILD = $REPO_SYNC_BEFORE_BUILD"
	echo -e ""
	echo -e " CHERRYPICK = $CHERRYPICK"
	echo -e "============================================================"
	tput sgr0
	tput setaf 2
	if [[ $MAKE_CLEAN != "1" || $MAKE_CLOBBER != "0" || $MAKE_INSTALLCLEAN != "0"  || $REPO_SYNC_BEFORE_BUILD != "1" || $BUILD_ENV_SETUP != "0" || $CHERRYPICK != "0" ]]; then
		echo -e "  DEFCONFIG changed."
		echo -e "  Switched to custom mode. \n"
		mode=Default
	else			
		mode=Custom
	fi
}

function displayMainMenu() {
	if [[ -n $TARGET_PRODUCT ]]; then
		echo -e "  *************************************"
		echo -e "	  TARGET_PRODUCT: $TARGET_PRODUCT   "
		echo -e "  *************************************"
	fi
	CURRENT_CONFIG
	echo -e "  1. Sync InfinitiveOS Repo"
	echo -e "  2. Configure Build parameters"
	echo -e "  2a. Reset All configurations"
	if [[ $SHELL_IN_TARGET_DIR -eq 1 ]]; then
		echo -e "  3. Set-up current Target device"
		echo -e "  4. Configure Cherry-pick script"
		echo -e "  5. Build InfinitiveOS for $device"
	fi
	echo -e "  6. Exit"
	echo -e ""
	if [[ $SHELL_IN_TARGET_DIR -eq 0 ]]; then
		echo -e " NOTE:  SHELL_IN_TARGET_DIR is set to False. "
		echo -e " 	if the shell is in same directory as the InfinitiveOS ROM sources. Press 12"
		echo -e " 	Else press 1 to sync InfinitiveOS ROM sources"
		echo -e ""
	fi
	echo -e "  Enter choice : \c"
	read mainMenuChoice
	PROCESS_MENU $mainMenuChoice
}

function PROCESS_MENU() {
	case $mainMenuChoice in
		1) REPO_SYNC ;;
		2) CONFIGURE_BUILD_OPTIONS ;;
		2a) DEFCONFIG ;;
		3) DeviceTarget;;
		4) CHERRYPICK;;
		5) BUILD ;;
		6) exit ;;
		7) export BUILD_ENV_SETUP=0 ;;
		8) export BUILD_ENV_SETUP=1 ;;
		12) export SHELL_IN_TARGET_DIR=1 ;;
		99) DEFCONFIG ;; #Reset to default settings
		*) echo "  Invalid Option! ERROR!" ;;
	esac
	echo -e " Press any key to continue..."
	read blank
	clear
}

function REPO_SYNC () {

	REPO_SYNC_QUESTIONNAIRE
	REPO_SYNCMENU
}

function REPO_SYNC_QUESTIONNAIRE {
	PACKAGES="git gnupg ccache lzop libglapi-mesa-lts-utopic:i386 libgl1-mesa-dri-lts-utopic:i386 flex bison gperf build-essential zip curl zlib1g-dev zlib1g-dev:i386 libc6-dev lib32bz2-1.0 lib32ncurses5-dev x11proto-core-dev libx11-dev:i386 libreadline6-dev:i386 lib32z1-dev libgl1-mesa-glx-lts-utopic:i386 libgl1-mesa-dev-lts-utopic g++-multilib mingw32 tofrodos python-markdown libxml2-utils xsltproc libreadline6-dev lib32readline-gplv2-dev libncurses5-dev bzip2 libbz2-dev libbz2-1.0 libghc-bzlib-dev lib32bz2-dev squashfs-tools pngcrush schedtool dpkg-dev"
 	echo -e " Checking for required packages for building InfinitiveOS..."
	sleep 1.5
	for program in $PACKAGES ; do
	 	program_status=`which $program`
 		if [[ -n $program_status ]]; then
 			echo "$program_status is NOT installed"
			sudo apt-get install $program 
		else
			echo -e "$program is installed"
 		fi
 	done

 	sleep 1

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
 	fi

 	echo -e "Do you want to initialize and sync InfinitiveOS?"
 	echo -e "		This involes, init-ing the repo and syncing all from scratch. This might take a large amount of bandwidth."
 	echo -e "1 for Yes, and 0 for no : \c"
 	read INIT_AND_SYNC
 	echo "$INIT_AND_SYNC"

	if [[ $SHELL_IN_TARGET_DIR -ne 1 ]]; then
	 	if [[ $INIT_AND_SYNC -eq 1 ]]; then
	 		echo "Beginning to initialize and Sync InfinitiveOS...."
	 		echo " This may take a while.."
	 		mkdir ./InfinitiveOS
	 		cd ./InfinitiveOS
	 		repo init -u https://github.com/InfinitiveOS/platform_manifest -b io-1.0
	 		repo sync
 		fi
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
		if (test $REPO_SYNC_BEFORE_BUILD = "1"); then 
			if [[ $SHELL_IN_TARGET_DIR -eq 1 ]]; then
				cd .repo/local_manifests 
				if [ -f "roomservice.xml" ]; then
				rm -f roomservice.xml
				fi
				cd ..
				cd ..
			fi
		echo -e ""
		fi
	else
	echo -e "ERROR! Wrong parameters passed. Reconfigure"
	CONFIGURE_BUILD_OPTIONS
	fi
	
	if (test $device = "generic"); then 
	echo -e "Skipping CHERRYPICK parameter because the target device is generic" 	
	else 	
		if [ -f "cherry_$device.sh" ]; then 
		echo -e "Use cherry-pick script before starting the build for the $device device? : CHERRYPICK :  \c" && read CHERRYPICK
			if [[ $CHERRYPICK == 0 || $CHERRYPICK == 1 ]]; then
			echo -e ""
			else
			echo -e " ERROR! Wrong parameters passed. Reconfigure"
			CONFIGURE_BUILD_OPTIONS
			fi
		else 
		echo -e "Sorry but no cherry_$device.sh was found, try maybe to reconfigure the cherry script and come back here after"
		fi
	fi

}

function DeviceTarget() {
	
	clear
	tput sgr0
	tput setaf 4
	echo -e "Checking if the build environment is initialized.."
	if (test $BUILD_ENV_SETUP = "1"); then
	echo -e "Build environment already initialized skipping..."
	else 
	BUILD_ENV_SETUP=1
	source build/./envsetup.sh
	fi
	clear
	echo -e "Official Devices"
	echo -e ""
	echo -e ""
	echo -e "Samsung Galaxy S+ (ariesve)"
	echo -e "Samsung Galaxy Grand Duos (I9082)"
	echo -e "Samsung Galaxy S5 Mini (kmini3g)"
	echo -e "Samsung Galaxy S3 Neo (s3ve3g)"
	echo -e "Motorola Moto G 2014 (titan)"
	echo -e "Motorola Moto G (falcon)"
	echo -e "Motorola Moto E (condor)"
	echo -e "Sony Xperia L (taoshan)"
	echo -e "Sony Xperia Z (yuga)"
	echo -e "Sony Xperia Z2 (honami)"
	echo -e "Sony Xperia Z3 (leo)"
	echo -e "Xiaomi Redmi 1S (armani)"
	echo -e "Xiaomi Mi3 (cancro)"
	echo -e "Yu Yureka (tomato)"
	echo -e ""
	echo -e ""
	sleep 1
	tput setaf 2
	echo -e "Is your device in one of the listed ones?"
	echo -e "Insert 1 or 0"
	read devicetargetchoice
	if [[ $devicetargetchoice == 0 || $devicetargetchoice == 1 ]]; then
	echo -e ""
	else
	echo -e " ERROR! Wrong parameters passed. Reconfigure"
	DeviceTarget
	fi
	if (test $devicetargetchoice = "1"); then
	echo -e "Insert the codename of the device which you will gonna build for:"
	read device
	echo -e "Going to make Breakfast for the $device device"
	breakfast $device
	else
	echo -e "Going to build for an unofficial device, and you already set-up your device tree?"
	read undevice
	if [[ $undevice == 0 || $undevice == 1 ]]; then
	echo -e ""
	else
	echo -e " ERROR! Wrong parameters passed. Reconfigure"
	DeviceTarget
	fi
		if (test $undevice = "1"); then
		echo -e "Insert your device codename then, in order to make it as current target"
		read device
		breakfast $device
	else	
	echo -e "If your device is not listed you will gonna need to insert the repos to fetch in the local manifest"
	sleep 2
	cd .repo
	mkdir -p local_manifests
	cd local_manifests 
	nano local_manifest.xml
	cd ..
	cd ..
	echo -e "Press enter when you finished editing the local_manifest"
	read blank
	echo -e "Going to repo sync now, in order to include the repo from the local_manifest"
	repo sync
	clear
	echo -e "Now, you just have to type the codename of your device :)"
	read device
	breakfast $device
	clear
	echo -e "Breakfast completed, ROM build is set now for the $device device"
	fi 
	fi
	
	tput sgr0
}
	

function CHERRYPICK() {
	
	clear
	tput setaf bold
	tput setaf 3
	
	echo -e "In order to proceed with this operation we need to check if you already choosed a target device"
	if (test $device != generic); then
	echo -e "Ok we can proceed..."
	sleep 2
	echo -e "Basically this script will be made separately for each device"
	echo -e "And this script will be used for the developers who need to cherry pick some propietary stuff for the device to compile the ROM"
	echo -e "And to don't repeat this every time, it's better to do a script from this and run it every time you make a new build for the device"
	echo -e "I think you already know how cherry-pick works so i won't stay here explain to you how to do that :)"
	echo -e "You are currently building for $device"
	
	echo -e "Press enter when you are ready"
	read blank
	
	nano cherry_$device.sh

	else 

	echo -e "You need to choose a target device first!"
	sleep 1
	DeviceTarget

	fi 
}    

function BUILD () {
	echo -e " *holds tiki torch and dances*"
}

function DEFCONFIG {
	# Red
	tput setaf 1
	tput bold

	echo -e "  Loading defaults..\n"

	mode=Default

	tput sgr0
	tput setaf 1

	#Option values
	MAKE_CLEAN=1
	MAKE_CLOBBER=0
	MAKE_INSTALLCLEAN=0
	REPO_SYNC_BEFORE_BUILD=1
	makeApp=0
	BUILD_ENV_SETUP=0
	CHERRYPICK=0
	SHELL_IN_TARGET_DIR=0

	#Restore Green
	tput sgr0
	tput setaf 2
	return
}

#Load default configurations
DEFCONFIG

while [[ true ]]; do
	IO_MAINSPLASH
	displayMainMenu
done

$normal

