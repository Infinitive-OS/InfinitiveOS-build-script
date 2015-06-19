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
	echo -e "	    Target Device:" $device
	echo -e "  *************************************"
	currentConfig
	echo -e "  1. Sync InfinitiveOS Repo"
	echo -e "  2. Configure Build parameters"
	echo -e "  3. Build InfinitiveOS for $device"
	echo -e "  "
	echo -e "  4. Exit"
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
	echo -e "  buildEnvSetup       :     $buildEnvSetup"
	echo -e ""
	echo -e " Make options:"
	echo -e "  makeClean           :     $makeClean"
	echo -e "  makeClobber         :     $makeClobber"
	echo -e "  makeInstallClean    :     $makeInstallClean"
	echo -e "  repoSyncBeforeBuild :     $repoSyncBeforeBuild"
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
	echo -e "  Is you Build enviornment set up? : buildEnvSetup :  \c" && read buildEnvSetup
	if [[ "$buildEnvSetup" == "0" || "$buildEnvSetup" == "1" ]]; then
		echo -e ""
	else
	echo -e " ERROR! Wrong parameters passed. Reconfigure"
	configureBuild
	fi

	echo -e "  make clean before starting the build? : MakeClean :  \c" && read makeClean
	if [[ "$makeClean" == 0 || "$makeClean" == 1 ]]; then
		echo -e ""
	else
	echo -e " ERROR! Wrong parameters passed. Reconfigure"
	configureBuild
	fi

	echo -e "  make clobber before starting the build? : MakeClobber :  \c" && read makeClobber
	if [[ $makeClobber == 0 || $makeClobber == 1 ]]; then
		echo -e ""
	else
	echo -e " ERROR! Wrong parameters passed. Reconfigure"
	configureBuild
	fi

	echo -e "  make InstallClean before starting the build? : MakeInstallClean :  \c" && read makeInstallClean
	if [[ $makeInstallClean == 0 || $makeInstallClean == 1 ]]; then
		echo -e ""
	else
	echo -e " ERROR! Wrong parameters passed. Reconfigure"
	configureBuild
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

	#Restore Green
	tput sgr0
	tput setaf 2
	return
}

function processMenu() {
	case $mainMenuChoice in
		1) syncRepo ;;
		2) configureBuild ;;
		3) build ;;
		4) exit ;;
		5) export buildEnvSetup=0 ;;
		6) export buildEnvSetup=1 ;;
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
