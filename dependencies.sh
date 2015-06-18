#!/bin/bash

echo "Installing Post-Dependencies for the build environment"
echo "This step is automatically skipped if there already installed"

	echo "Insert your password:"

		sudo apt-get update 
		sudo apt-get install openjdk-7-jdk -y
		sudo apt-get install git-core gnupg flex bison gperf libsdl1.2-dev libesd0-dev libwxgtk2.8-dev squashfs-tools build-essential zip curl libncurses5-dev zlib1g-dev openjdk-6-jre openjdk-6-jdk pngcrush schedtool libxml2 libxml2-utils xsltproc lzop libc6-dev schedtool g++-multilib lib32z1-dev lib32ncurses5-dev lib32readline-gplv2-dev gcc-multilib -y
		
echo "Making a quick upgrate for system files"

sudo apt-get upgrade

echo "****************************************"
echo "Going back now to the main script widnow"
echo "****************************************"

exit