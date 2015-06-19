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

function displayMenu() {
	echo -e "  *************************************************"
	echo -e "	    Target Device:" $device
	echo -e "  *************************************************"
	echo -e ""
	echo -e "  1. Sync InfinitiveOS Repo"
	echo -e "  2. Configure Build parameters"
	echo -e "  3. Build InfinitiveOS for $device"
	echo -e "  "
	echo -e "  4. Exit"
	echo -e ""
	echo -e "  Enter choice : \c"
	read menuChoice
	processMenu $menuChoice
}

function processMenu() {
	case $menuChoice in
		1) echo SyncRepo ;;
		2) echo ConfigureBuild ;;
		3) echo "three" ;;
		4) exit ;;
		*) echo "  Invalid Option! ERROR!" ;;
	esac
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
echo -e "  Press any key to continue after the upgrade is completed \c"
echo -e ""
read blank

#Load default configurations
source defconfig.sh

while [[ true ]]; do
	io_main_splash
	displayMenu	
done