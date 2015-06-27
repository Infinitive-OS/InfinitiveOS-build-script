#!/bin/bash

function restore_IOConfig {
	if [[ -f "./io.config" ]]; then
		vars=(MAKE_CLEAN MAKE_CLOBBER MAKE_INSTALLCLEAN REPO_SYNC_BEFORE_BUILD BUILD_ENV_SETUP CHERRYPICK)
		for i in ${vars[@]}; do
			while IFS='' read -r line || [[ -n $line ]]; do
				export ${i}=`grep "${i}" "io.config" | cut -d'=' -f2`
			done < "io.config"
		done
	fi
}

function SETUP_BUILD () {
	if [[ -n $TARGET_PRODUCT ]]; then
		echo -e "checking if official or not"
		OFFICIAL_DEVICES=(ariesve I9082 kmini3g s3ve3g titan falcon condor taoshan yuga honami togari leo armani cancro tomato)
		for OFFICIAL_DEVICE in ${OFFICIAL_DEVICES[@]}; do
			if [[ ${TARGET_PRODUCT} == ${OFFICIAL_DEVICE} ]]; then
				export IO_BUILDTYPE=OFFICIAL
				echo -e "$TARGET_PRODUCT is an OFFICIAL InfinitiveOS device"
				echo -e "Building as official"
			fi
		done
	fi
}