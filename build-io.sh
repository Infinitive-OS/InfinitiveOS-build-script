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

# Default Device
device=generic

function io_main_splash () {
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

function displayMainMenu() {
	echo -e "  *************************************"
	echo -e "	  Target Device: io_$device     "
	echo -e "  *************************************"
	currentConfig
	echo -e "  1. Sync InfinitiveOS Repo"
	echo -e "  2. Configure Build parameters"
	echo -e "  3. Set-up current Target device"
	echo -e "  4. Configure Cherry-pick script"
	if( test $device != "generic"); then 
	echo -e "  5. Build InfinitiveOS for $device"
	fi
	echo -e "  6. Exit"
	echo -e ""
	echo -e "  Enter choice : \c"
	read mainMenuChoice
	processMenu $mainMenuChoice
}

function currentConfig () {
	echo -e " "
	echo -e "  NOTE : We are using Binary inputs"
	echo -e "  1 for Yes "
	echo -e "  0 for No "
	echo -e ""
	tput bold 
	tput setaf 6
	echo -e " Enviornment options: "
	echo -e " buildEnvSetup       :     $buildEnvSetup"
	echo -e ""
	echo -e " Make options:"
	echo -e " makeClean           :     $makeClean"
	echo -e " makeClobber         :     $makeClobber"
	echo -e " makeInstallClean    :     $makeInstallClean"
	echo -e " repoSyncBeforeBuild :     $repoSyncBeforeBuild"
	echo -e " cherrypick          :     $cherrypick"
	echo -e ""
	tput sgr0
	tput setaf 2

	#if [[ $MakeClean != 1 || $MakeClobber != 0 || $MakeInstallClean != 1 || $RepoSyncBeforeBuild != 1 || $buildEnvSetup != 1 ]]; then
	#	mode=Custom
	#	echo -e "  Defconfig changed. \n"
	#	echo -e "  Switched to custom mode."
	#fi
}

function syncRepoMenu () {
	echo -e "config menu for sync"
}

function syncRepo () {
	echo -e ""
	echo -e " Lets sync something here ( get set to shed your gbs ;) )"
	echo -e ""
	echo -e "${bldcya}>>   Would you like us to upgrade and check for dependencies to avoid errors while building? \n"
	echo -e "${bldcya}    (yes/no) \c"
	tput sgr0
	tput setaf 2
	read askDependencies
	if [[ $askDependencies = "yes" || $askDependencies = "Yes" || $askDependencies = "YES" ]]; then
		echo -e ""
		echo -e "   > Running the dependencies script"
		echo -e ""
		x-terminal-emulator -e ./dependencies.sh 
	fi
		cd .. 
		cd .repo/local_manifests 
		if [ -f "roomservice.xml" ]; then
		rm -f roomservice.xml
		fi
		cd ..
		cd ..
		cd io_build
	echo -e ""
	echo -e "  Press any key to continue after the upgrade is completed "
	echo -e ""
	read blank

	syncRepoMenu
}

function configureBuild() {
	echo -e "begining to edit the default build options."
	echo -e "      "
	echo -e "     | Submit values in binary bits"
	echo -e "     | 1 for Yes, and 0 for No"
	echo -e ""
	echo -e "Is you Build enviornment set up? : buildEnvSetup :  \c" && read buildEnvSetup
	if [[ "$buildEnvSetup" == "0" || "$buildEnvSetup" == "1" ]]; then
		echo -e ""
	else
	echo -e "ERROR! Wrong parameters passed. Reconfigure"
	configureBuild
	fi

	echo -e "Make clean before starting the build? : MakeClean :  \c" && read makeClean
	if [[ "$makeClean" == 0 || "$makeClean" == 1 ]]; then
		echo -e ""
	else
	echo -e "ERROR! Wrong parameters passed. Reconfigure"
	configureBuild
	fi

	echo -e "Make clobber before starting the build? : MakeClobber :  \c" && read makeClobber
	if [[ $makeClobber == 0 || $makeClobber == 1 ]]; then
		echo -e ""
	else
	echo -e "ERROR! Wrong parameters passed. Reconfigure"
	configureBuild
	fi

	echo -e "Make InstallClean before starting the build? : MakeInstallClean :  \c" && read makeInstallClean
	if [[ $makeInstallClean == 0 || $makeInstallClean == 1 ]]; then
		echo -e ""
	else
	echo -e "ERROR! Wrong parameters passed. Reconfigure"
	configureBuild
	fi

	echo -e "Repo sync before starting the build? : repoSyncBeforeBuild :  \c" && read repoSyncBeforeBuild
	if [[ $repoSyncBeforeBuild == 0 || $repoSyncBeforeBuild == 1 ]]; then
		if (test $repoSyncBeforeBuild = "1"); then 
		cd .. 
		cd .repo/local_manifests 
		if [ -f "roomservice.xml" ]; then
		rm -f roomservice.xml
		fi
		cd ..
		cd ..
		cd io_build 
		echo -e ""
		fi
	else
	echo -e "ERROR! Wrong parameters passed. Reconfigure"
	configureBuild
	fi
	
	if (test $device = "generic"); then 
	echo -e "Skipping cherrypick parameter because the target device is generic" 	
	else 	
		if [ -f "cherry_$device.sh" ]; then 
		echo -e "Use cherry-pick script before starting the build for the $device device? : cherrypick :  \c" && read cherrypick
			if [[ $cherrypick == 0 || $cherrypick == 1 ]]; then
			echo -e ""
			else
			echo -e " ERROR! Wrong parameters passed. Reconfigure"
			configureBuild
			fi
		else 
		echo -e "Sorry but no cherry_$device.sh was found, try maybe to reconfigure the cherry script and come back here after"
		fi
	fi

}

function DeviceTarget() {
	
	tput sgr0
	tput setaf 4
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
	if (test $devicetargetchoice = "1"); then
	echo -e "Checking if the build environment is initialized.."
		if (test $buildEnvSetup = "1"); then
		echo -e "Build environment already initialized skipping..."
		else 
		$buildEnvSetup=1
		fi
	echo -e "Insert the codename of the device which you will gonna build to:"
	read device
	cd ..
	source build/./envsetup.sh
	cd io_build
	echo -e "Going to make Breakfast for the $device device"
	
	breakfast $device
	else
	echo -e "Going to build for an unofficial device, and you already set-up your device tree?"
	read undevice
		if(test $undevice = "1"); then
		echo -e "Insert your device codename then, in order to make it as current target"
		read device
		cd ..
		source build/./envsetup.sh
		cd io_build
		breakfast $device
	else	
	echo -e "If your device is not listed you will gonna need to insert the repos to fetch in the local manifest"
	sleep 2
	cd ..	
	cd .repo
	mkdir local_manifests
	cd local_manifests 
	nano local_manifest.xml
	cd ..
	cd ..
	cd io_build
	echo -e "Press enter when you finished editing the local_manifest"
	read blank
	echo -e "Going to repo sync now, in order to include the repo from the local_manifest"
	repo sync
	clear
	echo -e "Now, you just have to type the codename of your device :)"
	read device
	cd ..
	source build/./envsetup.sh
	cd io_build
	breakfast $device
	clear
	echo -e "Breakfast completed, ROM build is set now for the $device device"
	fi 
	fi
	
	tput sgr0
}
	

function cherrypick() {
	
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

function build () {
	echo -e " *holds tiki torch and dances*"
}

function defconfig {
	# Red
	tput setaf 1
	tput bold

	echo -e "  Loading defaults..\n"

	mode=default

	tput sgr0
	tput setaf 1

	#Option values
	makeClean=1
	makeClobber=0
	makeInstallClean=0
	repoSyncBeforeBuild=1
	makeApp=0
	buildEnvSetup=1
	cherrypick=0

	#Restore Green
	tput sgr0
	tput setaf 2
	return
}

function processMenu() {
	case $mainMenuChoice in
		1) syncRepo ;;
		2) configureBuild ;;
		3) DeviceTarget;;
		4) cherrypick;;
		5) build ;;
		6) exit ;;
		7) export buildEnvSetup=0 ;;
		8) export buildEnvSetup=1 ;;
		99) defconfig ;; #Reset to default settings
		*) echo "  Invalid Option! ERROR!" ;;
	esac
	echo -e " Press any key to continue..."
	read blank
	clear
}

#Load default configurations
defconfig

while [[ true ]]; do
	io_main_splash
	displayMainMenu
done

$normal

