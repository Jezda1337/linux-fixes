#! /bin/bash

main() {
	# unisntall imwheel binaries
	if [ -x "$(command -v dnf)" ]; then
		sudo dnf remove imwheel -y
	elif [ -x "$(command -v apt)" ]; then
		sudo apt purge imwheel* -y
	else
		sudo pacman -R imwheel -y
	fi
	# remove .imwheelrc configuration
	sudo rm -r ~/.imwheelrc

	# remove autostart files for both
	sudo rm -r ~/.config/autostart/imwheel.desktop
	sudo rm -r ~/.config/autostart/CapsLockDelayFixer.desktop

	# remove CapsLockDelay.sh from ~/scripts/ folder
	sudo rm -r ~/scripts/CapsLockDelayFixer.sh

	echo "All files and programs are uninstalled from your sytem, reboot your system or logout."
	exit 1
}

main
