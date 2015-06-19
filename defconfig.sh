#!/bin/bash

echo -e "Settings defaults.."
echo -e ""

#Option values
MakeClean=1
MakeClobber=1
MakeInstallClean=1
RepoSyncBeforeBuild=1
MakeApp=0

if [ $MakeClean = 1 ]; then
	echo "make clean will be done before the build."
fi

if [ $MakeClobber = 1 ]; then
        echo "make clobber will be done before the build."
fi

if [ $MakeInstallClean = 1 ]; then
        echo "make installclean will be done before the build."
fi

if [ $RepoSyncBeforeBuild = 1 ]; then
        echo "Repo sync will be done before the build."
fi

if [ $RepoSyncBeforeBuild = 1 ]; then
        echo "Repo sync will be done before the build."
fi

return
