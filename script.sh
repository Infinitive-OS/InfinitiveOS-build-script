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

function io_main_splash () {
	tput bold
	tput setaf 2 
	echo -e ""
	echo -e ""
	echo -e " .___        _____.__       .__  __  .__             ________    _________ "  
	echo -e " |   | _____/ ____\__| ____ |__|/  |_|__|__  __ ____ \_____  \  /   _____/ " 
	echo -e " |   |/    \   __\|  |/    \|  \   __\  \  \/ // __ \ /   |   \ \_____  \  "
	echo -e " |   |   |  \  |  |  |   |  \  ||  | |  |\   /\  ___//    |    \/        \ "
	echo -e " |___|___|  /__|  |__|___|  /__||__| |__| \_/  \___  >_______  /_______  / "
	echo -e "         \/              \/                       \/        \/          \/"
	echo -e " ___________           .__                                            __      _________       __               "
	echo -e " \_   _____/ _______  _|__|______  ____   ____   _____   ____   _____/  |_   /   _____/ _____/  |_ __ ________ "  
	echo -e " |    __)_ /    \  \/ /  \_  __ \/  _ \ /    \ /     \_/ __ \ /    \   __\  \_____  \_/ __ \   __\  |  \____ \ "
	echo -e " |        \   |  \   /|  ||  | \(  <_> )   |  \  Y Y  \  ___/|   |  \  |    /        \  ___/|  | |  |  /  |_> > "
	echo -e "/_______  /___|  /\_/ |__||__|   \____/|___|  /__|_|  /\___  >___|  /__|   /_______  /\___  >__| |____/|   __/  "
	echo -e "        \/     \/                           \/      \/     \/     \/               \/     \/           |__|   "
	echo -e "                                                                                                              "
	echo -e ""
	echo -e ""
	tput sgr0
	tput setaf 2
}

echo -e "Checking if there are updates for the dependencies..."
sleep 2

x-terminal-emulator -e ./dependencies.sh 

echo -e "Press any key to continue after the upgrade is completed"

read enterproceed
echo -e "Going to start in a few seconds ----------------------->"
sleep 1
echo -e "Script created by Calin Neamtu aka nilac8991 for InfinitiveOS"
sleep 1
echo -e "The script is licensed under Apache license so everyone can re-use it but with propper credits"
sleep 1
echo -e "Loading the menu..."
sleep 4 

#Menu loop part 

endscript="true"
devicebuild="Not defined"

while ("$endscript" == "true" && "$endscript" != "false")
do
clear

source defconfig.sh

#MENU

io_main_splash

echo -e "*********************************************************************************************************"
echo -e "*********************************************************************************************************"
echo -e "	Target Device:" $devicebuild                                                                            
echo -e "*********************************************************************************************************"
echo -e "*********************************************************************************************************"
echo -e ""
echo -e ""
echo -e ""
echo -e "	1- Repo sync the Repo sources " 
echo -e "	2- Choose the target device "
echo -e "        3- Exit "
read menuchoose
if (test "$menuchoose" = "1"); then
clear
repo sync
fi
if (test "$menuchoose" = "2"); then
echo -e "AHAHAh SBAM!"
fi  
if (test "$menuchoose" = "3"); then
endscript="false"
fi
done 
