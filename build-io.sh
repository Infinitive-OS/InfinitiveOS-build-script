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
	echo -e ""
	echo -e ""
	echo -e "  .___        _____.__       .__  __  .__             ________    _________ "  
	echo -e "  |   | _____/ ____\__| ____ |__|/  |_|__|__  __ ____ \_____  \  /   _____/ " 
	echo -e "  |   |/    \   __\|  |/    \|  \   __\  \  \/ // __ \ /   |   \ \_____  \  "
	echo -e "  |   |   |  \  |  |  |   |  \  ||  | |  |\   /\  ___//    |    \/        \ "
	echo -e "  |___|___|  /__|  |__|___|  /__||__| |__| \_/  \___  >_______  /_______  / "
	echo -e "          \/              \/                       \/        \/          \/"
	echo -e "   ___________           .__                                            __      _________       __               "
	echo -e "   \_   _____/ _______  _|__|______  ____   ____   _____   ____   _____/  |_   /   _____/ _____/  |_ __ ________ "  
	echo -e "   |    __)_ /    \  \/ /  \_  __ \/  _ \ /    \ /     \_/ __ \ /    \   __\  \_____  \_/ __ \   __\  |  \____ \ "
	echo -e "   |        \   |  \   /|  ||  | \(  <_> )   |  \  Y Y  \  ___/|   |  \  |    /        \  ___/|  | |  |  /  |_> > "
	echo -e "  /_______  /___|  /\_/ |__||__|   \____/|___|  /__|_|  /\___  >___|  /__|   /_______  /\___  >__| |____/|   __/  "
	echo -e "         \/     \/                           \/      \/     \/     \/               \/     \/           |__|   "
	echo -e "                                                                                                               "
	echo -e " "
	echo -e " "
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
	echo -e "  buildEnvSetup    :        $buildEnvSetup"
	echo -e ""
	echo -e " Make options:"
	echo -e "  MakeClean           :     $MakeClean"
	echo -e "  MakeClobber         :     $MakeClobber"
	echo -e "  MakeInstallClean    :     $MakeInstallClean"
	echo -e "  RepoSyncBeforeBuild :     $RepoSyncBeforeBuild"
	echo -e ""
	tput sgr0
	tput setaf 2
}

function syncRepoMenu () {
	currentConfig
}

function syncRepo () {
	echo -e ""
	echo -e " Lets sync something here ( get set to shed your gbs ;) )"
	echo -e ""

	clear

	syncRepoMenu
}

function ConfigureBuild() {
	echo -e " Lets Configure the build options -_-" 
	echo -e " Because you are dont agree wth my defaults -_-"
}

function build () {
	echo -e " *holds tiki torch*"
}

function processMenu() {
	case $mainMenuChoice in
		1) syncRepo ;;
		2) ConfigureBuild ;;
		3) build ;;
		4) exit ;;
		*) echo "  Invalid Option! ERROR!" ;;
	esac
	read blank
	echo -e " Press any key to continue..."
	clear
}

io_main_splash

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

#Load default configurations
source defconfig.sh

while [[ true ]]; do
	io_main_splash
	displayMainMenu	
done

$normal