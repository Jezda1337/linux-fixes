#! /bin/bash

declare -a DISTRIBUTIONS=("debian" "arch" "fedora")

main() {
  local DISTRIBUTION=""
  while getopts "d:" OPTION; do
    case "$OPTION" in
      d)
        DISTRIBUTION="${OPTARG,,}";;
      ?)
        helpMessage;;
    esac
  done
  
  #checking for imwheel is it installed already or not
  if [ "$DISTRIBUTION" != "" ]; then
    installImwheel "$DISTRIBUTION"
  else
    echo "you have to use -d flag. -d stands for distribution. use -d to pass your base distribution"
    echo "example: ./install.sh -d debian"
    exit 1
  fi

  imwheelConfigFile "$DISTRIBUTION"

  if [ "$DISTRIBUTION" == "debian" ]; then
    autoStartFile "imwheel" "imwheel -k -b '4 5'" "Imwheel" "Auto start Imwheel."
  elif [ "$DISTRIBUTION" == "arch" ]; then
    autoStartFile "imwheel" "imwheel -k -b '45'" "Imwheel" "Auto start Imwheel."
  else
    autoStartFile "imwheel" "imwheel -k -b '45'" "Imwheel" "Auto start Imwheel."
  fi
}

installImwheel() {
  if [ ! -x "$(command -v imwheel)" ]; then
    if printf '%s\0' "${DISTRIBUTIONS[@]}" | grep -Fxqz -- "$1"; then
      if [ "$1" == "arch" ]; then
        sudo pacman -S imwheel -y
      elif [ "$1" == "debian" ]; then
        sudo apt install imwheel -y
      else
        sudo dnf install imwheel -y
      fi
    fi
  else
    echo "Imwheel is already installed."
  fi

  capsDelay
}


imwheelConfigFile() {
  if [ ! -f ~/.imwheelrc ]; then
    cat >~/.imwheelrc<<EOF
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

  if [ "$NEW_VALUE" == "" ];
    then exit 0
  fi

  sed -i "s/\($TARGET_KEY *Button4, *\).*/\1$NEW_VALUE/" ~/.imwheelrc # find the string Button4, and write new value.
  sed -i "s/\($TARGET_KEY *Button5, *\).*/\1$NEW_VALUE/" ~/.imwheelrc # find the string Button5, and write new value.

  cat ~/.imwheelrc

  if [ "$1" == "debian" ]; then
    imwheel -k -b "4 5"
  elif [ "$1" == "fedora" ]; then
    imwheel -k -b "45"
  else
    imwheel -k -b "45" #NEED TO TEST THIS ONE ON ARCH BASED DISTORS!!
  fi
}

########################################################
# Caps Lock Delay
########################################################

capsDelay() {
  if [ ! -d "$HOME/scripts" ]; then
    mkdir "$HOME/scripts"
  fi

  if [ -d "$HOME/scripts" ]; then
        cat >"$HOME/scripts"/CapsLockDelayFixer.sh<<EOF
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
    autoStartFile "CapsLockDelayFixer2" "bash -c sleep 10 && '$HOME/scripts/CapsLockDelayFixer.sh'" "CapsLockDelayFixer" "Caps Lock Delay Fixer"
  fi

}

# reusable function for creating autostart files!
autoStartFile() {
  local AUTOSTART_DIR="$HOME/.config/autostart/"
  [ ! -d "$AUTOSTART_DIR" ] && mkdir "$AUTOSTART_DIR"

  if [ -d "$AUTOSTART_DIR" ]; then
    cat >"$AUTOSTART_DIR/$1.desktop"<<EOF
      [Desktop Entry]
      Type=Application
      Exec=$2
      Name=$3
      Comment=$4
EOF
  fi
}

main "$@"
