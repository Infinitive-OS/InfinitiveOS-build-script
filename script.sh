#!/bin/bash

sleep 0.25
echo -e " .___        _____.__       .__  __  .__             ________    _________ "  
sleep 0.25                              
echo -e " |   | _____/ ____\__| ____ |__|/  |_|__|__  __ ____ \_____  \  /   _____/ " 
sleep 0.25                              
echo -e " |   |/    \   __\|  |/    \|  \   __\  \  \/ // __ \ /   |   \ \_____  \  "
sleep 0.25                               
echo -e " |   |   |  \  |  |  |   |  \  ||  | |  |\   /\  ___//    |    \/        \ "
sleep 0.25                               
echo -e " |___|___|  /__|  |__|___|  /__||__| |__| \_/  \___  >_______  /_______  / "
sleep 0.25                                
echo -e "         \/              \/                       \/        \/             " \/                                                                                   
sleep 0.25                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              
echo -e " ___________           .__                                            __      _________       __               "
sleep 0.25
echo -e " \_   _____/ _______  _|__|______  ____   ____   _____   ____   _____/  |_   /   _____/ _____/  |_ __ ________ "  
sleep 0.25
echo -e " |    __)_ /    \  \/ /  \_  __ \/  _ \ /    \ /     \_/ __ \ /    \   __\  \_____  \_/ __ \   __\  |  \____ \ "
sleep 0.25
echo -e " |        \   |  \   /|  ||  | \(  <_> )   |  \  Y Y  \  ___/|   |  \  |    /        \  ___/|  | |  |  /  |_> > "
sleep 0.25
echo -e "/_______  /___|  /\_/ |__||__|   \____/|___|  /__|_|  /\___  >___|  /__|   /_______  /\___  >__| |____/|   __/  "
sleep 0.25
echo -e "        \/     \/                           \/      \/     \/     \/               \/     \/           |__|   "
sleep 0.25
echo -e "                                                                                                              "
sleep 0.25

echo -e "Checking if there are updates for the dependencies..."
sleep 2

x-terminal-emulator -e /home/nilac8991/Desktop/dependencies.sh 

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


#MENU

sleep 0.25
echo -e " .___        _____.__       .__  __  .__             ________    _________ "  
sleep 0.25                              
echo -e " |   | _____/ ____\__| ____ |__|/  |_|__|__  __ ____ \_____  \  /   _____/ " 
sleep 0.25                              
echo -e " |   |/    \   __\|  |/    \|  \   __\  \  \/ // __ \ /   |   \ \_____  \  "
sleep 0.25                               
echo -e " |   |   |  \  |  |  |   |  \  ||  | |  |\   /\  ___//    |    \/        \ "
sleep 0.25                               
echo -e " |___|___|  /__|  |__|___|  /__||__| |__| \_/  \___  >_______  /_______  / "
sleep 0.25                                
echo -e "         \/              \/                       \/        \/             " \/                                                                                   
sleep 0.25                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              
echo -e " ___________           .__                                            __      _________       __               "
sleep 0.25
echo -e " \_   _____/ _______  _|__|______  ____   ____   _____   ____   _____/  |_   /   _____/ _____/  |_ __ ________ "  
sleep 0.25
echo -e " |    __)_ /    \  \/ /  \_  __ \/  _ \ /    \ /     \_/ __ \ /    \   __\  \_____  \_/ __ \   __\  |  \____ \ "
sleep 0.25
echo -e " |        \   |  \   /|  ||  | \(  <_> )   |  \  Y Y  \  ___/|   |  \  |    /        \  ___/|  | |  |  /  |_> > "
sleep 0.25
echo -e "/_______  /___|  /\_/ |__||__|   \____/|___|  /__|_|  /\___  >___|  /__|   /_______  /\___  >__| |____/|   __/  "
sleep 0.25
echo -e "        \/     \/                           \/      \/     \/     \/               \/     \/           |__|   "
sleep 0.25
echo -e "                                                                                                              "
sleep 0.25

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
