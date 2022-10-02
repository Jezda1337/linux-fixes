#! /bin/bash

##################################################
# Author: Radoje
# Github: github.com/Jezda1337
# Version: v1.0.0
# Date: 16.09.2022
# Description: This script solves the problem of slow scroll on chromium based applications and caps lock delay.
# Usage: The script only support base distros like debian, arch and fedora
#       example: ./install.sh -d debian
# Flags: -d stands for distribution, the three most used distros are debian, arch and fedora
##################################################

# Main func
main() {
	local DISTRIBUTION=""
	local FIX=""
	while [ $# -gt 0 ]; do
		if [[ $1 == *"-"* ]]; then
			param="${1/-/}"
			if [ "$param" == "f" ]; then
				FIX=$2
			elif [ "$param" == "d" ]; then
				DISTRIBUTION="$2"
			fi
		fi
		shift
	done

	if [ "$FIX" == "1" ]; then
		./lib/mouse.sh "$DISTRIBUTION"
		exit 1
	elif [ "$FIX" == "2" ]; then
		./lib/caps.sh
		exit 1
	else
		./lib/mouse.sh "$DISTRIBUTION"
		./lib/caps.sh
		echo "Slow scroll and CApsLOck delay are fixed, please reboot your system."
	fi
	exit 0
}

main "$@"
