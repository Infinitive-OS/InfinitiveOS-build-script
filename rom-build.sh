#!/bin/bash

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

if [[ -f "./io.config" ]]; then
	echo " "
	echo "Found io.config.."
	echo " "
	vars=(MAKE_CLEAN MAKE_CLOBBER REPO_SYNC_BEFORE_BUILD CHERRYPICK EXPORT_PACKAGE RESET_HARD LAST_SYNC)
	for i in ${vars[@]}; do
		while IFS='' read -r line || [[ -n $line ]]; do
			export ${i}=`grep "${i}" "io.config" | cut -d'=' -f2`
		done < "io.config"
	done
else
	echo " "
	echo "io.config not found... bailing out.."
	echo " "
fi


if [[ $REPO_SYNC_BEFORE_BUILD -eq 1 ]]; then
	if [[ $RESET_HARD -eq 1 ]]; then
		echo "Resetting all repos before syncing"
		repo forall -vc "git reset --hard"
	fi
	if [[ -n $LAST_SYNC ]]; then
		echo "Repo was last synced on "$LAST_SYNC
	fi
	repo sync
fi

# Get start time
res1=$(date +%s.%N)

PRODUCT=$1

if [[ -n $PRODUCT ]]; then
	source build/envsetup.sh
	lunch io_$PRODUCT-userdebug

	if [[ -n $PRODUCT ]]; then
		OFFICIAL_DEVICES=(ariesve I9082 kmini3g s3ve3g titan falcon condor taoshan yuga honami togari leo armani cancro tomato hammerhead)
		for OFFICIAL_DEVICE in ${OFFICIAL_DEVICES[@]}; do
			if [[ ${PRODUCT} == ${OFFICIAL_DEVICE} ]]; then
				export IO_BUILDTYPE=OFFICIAL
				echo -e "${bldcya}$PRODUCT is an OFFICIAL InfinitiveOS device"
				echo -e "${bldcya}Building as official"
				tput sgr0
			fi
		done
	fi

	if [[ $MAKE_CLEAN -eq 1 ]]; then
		echo "Making clean.."
		make clean
	elif [[ $MAKE_INSTALLCLEAN -eq 1 ]]; then
		echo "making installclean..."
		make installclean
	fi

	export USE_PREBUILT_CHROMIUM=true
	echo "USE_PREBUILT_CHROMIUM=true"

	#build
	clear
	echo -e "Starting Compilation..."
	echo -e "Building InfinitiveOS for ${bldcya}"${PRODUCT}
	tput sgr0
	mka bacon

	if [[ $EXPORT_PACKAGE -eq 1 ]]; then
		dir=`pwd`
		cd $dir/out/target/product/$PRODUCT
		PACKAGE=`ls *.zip | grep 'InfinitiveOS'`
		echo "Copying "$PACKAGE" to "$dir"/"$PACKAGE
		cp $PACKAGE $dir/$PACKAGE	
	fi

	#Branding
	tput bold
	tput setaf 2 
	echo " "
	echo " "
	echo "				        #                     #         "
	echo "				         #                  ##          "
	echo "	I			          ###################           "
	echo "	N			        #######################         "
	echo "	F			      ###########################       "
	echo "	I			    ###############################     "
	echo "	N			   #################################    "
	echo "	I			  ##################################i   "
	echo "	T			  #######################      ######   "
	echo "	E			 #####f     ###########         ;####   "
	echo "				 #####        ########           #####  "
	echo "	O			 ####E         ######            #####  "
	echo "	S			 #####       #########           #####  "
	echo "				  #####     ###########         #####   "
	echo "				  ###############  ######      ######   "
	echo "				   ############     ################    "
	echo "				      ######          ############      "
	echo "				                        i#######        "
	echo " "
	echo " "
	tput sgr0
else
	echo "Error : Product not defined."
	echo "USAGE: "
	echo "	${bldred}./rom-build.sh <device>"
	tput sgr0
	echo ""
	echo "device name not specified... bailing out.. "
fi


# Get elapsed time
res2=$(date +%s.%N)
echo -e "${bldgrn}Total time elapsed: ${txtrst}${grn}$(echo "($res2 - $res1) / 60"|bc ) minutes ($(echo "$res2 - $res1"|bc ) seconds)${txtrst}"