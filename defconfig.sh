#!/bin/bash

# Red
tput setaf 1
tput bold

echo -e "  Settings defaults..\n"

tput sgr0
tput setaf 1

#Option values
MakeClean=1
MakeClobber=1
MakeInstallClean=1
RepoSyncBeforeBuild=1
MakeApp=0

if [ $MakeClean = 1 ]; then
	echo "  make clean will be done before the build."
fi

if [ $MakeClobber = 1 ]; then
        echo "  make clobber will be done before the build."
fi

if [ $MakeInstallClean = 1 ]; then
        echo "  make installclean will be done before the build."
fi

if [ $RepoSyncBeforeBuild = 1 ]; then
        echo "  Repo sync will be done before the build."
fi

sleep 2
clear

#Restore Green
tput sgr0
tput setaf 2
return
