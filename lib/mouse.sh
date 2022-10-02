#! /bin/bash

. ./lib/helpers.sh

########################################################
# Imwheel configuration
########################################################

declare -a DISTRIBUTIONS=("debian" "arch" "fedora")
declare DISTRIBUTION=$1

main() {
	#checking for imwheel is it installed already or not
	if [ "$DISTRIBUTION" != "" ]; then
		installImwheel "$DISTRIBUTION"
	else
		echo "you have to use -d flag. -d stands for distribution. use -d to pass your base distribution"
		echo "example: ./install.sh -d debian"
		exit 1
	fi

	if [ -x "$(command -v imwheel)" ]; then
		imwheelConfigFile "$DISTRIBUTION"
	else
		exit 1
	fi

	if [ "$DISTRIBUTION" == "debian" ]; then
		autoStartFile "imwheel" "imwheel -k -b '4 5'" "Imwheel" "Auto start Imwheel."
	elif [ "$DISTRIBUTION" == "arch" ]; then
		autoStartFile "imwheel" "imwheel -k -b '45'" "Imwheel" "Auto start Imwheel."
	else
		autoStartFile "imwheel" "imwheel -k -b '45'" "Imwheel" "Auto start Imwheel."
	fi

	exit 0
}

installImwheel() {
	if [ ! -x "$(command -v imwheel)" ]; then
		if printf '%s\0' "${DISTRIBUTIONS[@]}" | grep -Fxqz -- "$1"; then
			if [ "$1" == "arch" ]; then
				sudo pacman -S imwheel -y
				return
			elif [ "$1" == "debian" ]; then
				sudo apt install imwheel -y
				return
			else
				sudo dnf install imwheel -y
				return
			fi
		fi
	else
		echo "Imwheel is already installed."
	fi
}

# function for configure imwheel
imwheelConfigFile() {
	if [ ! -f ~/.imwheelrc ]; then
		cat >~/.imwheelrc <<EOF
    ".*"
    None,      Up,   Button4, 1
    None,      Down, Button5, 1
    Control_L, Up,   Control_L|Button4
    Control_L, Down, Control_L|Button5
    Shift_L,   Up,   Shift_L|Button4
    Shift_L,   Down, Shift_L|Button5
EOF
	fi

	CURRENT_VALUE=$(awk -F 'Button4,' '{print $2}' ~/.imwheelrc)

	NEW_VALUE=$(zenity --scale --window-icon=info --ok-label=Apply --title="Wheelies" --text "Mouse wheel speed:" --min-value=1 --max-value=100 --value="$CURRENT_VALUE" --step 1)

	if [ "$NEW_VALUE" == "" ]; then
		exit 0
	fi

	sed -i "s/\($TARGET_KEY *Button4, *\).*/\1$NEW_VALUE/" ~/.imwheelrc # find the string Button4, and write new value.
	sed -i "s/\($TARGET_KEY *Button5, *\).*/\1$NEW_VALUE/" ~/.imwheelrc # find the string Button5, and write new value.

	cat ~/.imwheelrc

	if [ "$1" == "debian" ]; then
		imwheel -k -b "4 5"
	elif [ "$1" == "fedora" ]; then
		imwheel -k -b "45"
	else
		imwheel -k -b "45"
	fi
}

main "$@"
