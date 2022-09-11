#!/bin/bash

# [x] 1. Porveriti da li je instaliran program imwheel, ako nije instalirati ga.
# [x] 2. Ako je program instaliran preskociti instalacijoni korak.
# [x] 3. Odabrati zeljenu brzinu skrola nakon pop-up-a.
# [x] 4. Nakon odabira brzine, potrebno je proveriti da li postoji autostart folder unutar .config foldera.
# [x] 5. Ako ne postoji kreirati ga, ako postoji nastaviti dalje sa kreiranjem configuracije.
# [x] 6. Kreirati novi fajl pod imenom imwheel.desktop i unutar njega ubaciti svu potrebnu konfiguraciju.
# [x] 7. Nakon kreiranja konfiguracije napraviti jos jedan fajl u istom folderu koji ce da sadrzi konfiguraciju za CapsLock Delay.
# [x] 8. Sacuvati CapsLock Delay skriptu unutar putanje: ~/scripts/CapsLockDelayFixer.sh

FILE=imwheel
# checking for imwheel on the system
if [ ! -x "$(command -v $FILE)" ]; then
  sudo dnf install imwheel -y
fi
# checking for .imwheelrc config file
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
imwheel -k -b '45' # '45' means to use side buttons next/prev

AUTOSTART_DIR=~/.config/autostart/
# checking does $AUTOSTART_DIR dir exist, if not create one
if [ ! -d $AUTOSTART_DIR ]; then
  mkdir ~/.config/autostart
fi

if [ -d $AUTOSTART_DIR ]; then
  cat >$AUTOSTART_DIR/imwheel.desktop<<EOF
  [Desktop Entry]
  Type=Application
  Exec=imwheel -k -b '45'
  Name=imwheel
  Comment=Run imwheel on startup with enabled side buttons next/prev
EOF
fi

###########################################################################
# This part is for CapsLock Delay
###########################################################################
SCRIPTS_DIR=~/scripts
if [ ! -d $SCRIPTS_DIR ]; then
  mkdir $SCRIPTS_DIR
fi

if [ -d $SCRIPTS_DIR ]; then
  cat >$SCRIPTS_DIR/CapsLockDelayFixer.sh<<EOF
xkbcomp -xkb "$DISPLAY" - | sed 's#key <CAPS>.*#key <CAPS> {\
    repeat=no,\
    type[group1]="ALPHABETIC",\
    symbols[group1]=[ Caps_Lock, Caps_Lock],\
    actions[group1]=[ LockMods(modifiers=Lock),\
    Private(type=3,data[0]=1,data[1]=3,data[2]=3)]\
};\
#' | xkbcomp -w 0 - "$DISPLAY"
EOF

chmod +x $SCRIPTS_DIR/CapsLockDelayFixer.sh

fi

if [ -f $SCRIPTS_DIR/CapsLockDelayFixer.sh ]; then
  cat>$AUTOSTART_DIR/CapsLockDelayFixer.desktop<<EOF
  [Desktop Entry]
  Type=Application
  Exec=bash -c 'sleep 10 && $SCRIPTS_DIR/CapsLockDelayFixer.sh'
  Name=CapsLockDelayFixer
  Comment=Caps Lock Delay Fixer
EOF
fi

echo 'Done! Please reboot the computer!'
