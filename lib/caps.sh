#! /bin/bash

#import helpers functions
. ./lib/helpers.sh

########################################################
# Caps Lock Delay
########################################################

capsDelay() {
	if [ ! -d "$HOME/scripts" ]; then
		mkdir "$HOME/scripts"
	fi

	if [ -d "$HOME/scripts" ]; then
		cat >"$HOME/scripts"/CapsLockDelayFixer.sh <<EOF
    xkbcomp -xkb "$DISPLAY" - | sed 's#key <CAPS>.*#key <CAPS> {\
      repeat=no,\
      type[group1]="ALPHABETIC",\
      symbols[group1]=[ Caps_Lock, Caps_Lock],\
      actions[group1]=[ LockMods(modifiers=Lock),\
      Private(type=3,data[0]=1,data[1]=3,data[2]=3)]\
    };\
    #' | xkbcomp -w 0 - "$DISPLAY"
EOF
		chmod +x "$HOME/scripts/CapsLockDelayFixer.sh"
	fi

	if [ -f "$HOME/scripts/CapsLockDelayFixer.sh" ]; then
		autoStartFile "CapsLockDelayFixer" "bash -c 'sleep 10; $HOME/scripts/CapsLockDelayFixer.sh'" "CapsLockDelayFixer" "Caps Lock Delay Fixer"
	fi

	echo "CApsLOckDElay is fixed, please reboot you system."
}

capsDelay "$@"
