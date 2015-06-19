#!/bin/bash

# Red
tput setaf 1
tput bold

echo -e "  Settings defaults..\n"

tput sgr0
tput setaf 1

#Option values
MakeClean=1
MakeClobber=0
MakeInstallClean=0
RepoSyncBeforeBuild=1
MakeApp=0
buildEnvSetup=1

sleep 2
clear

#Restore Green
tput sgr0
tput setaf 2
return
