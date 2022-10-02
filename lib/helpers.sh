#! /bin/bash



# reusable function for creating autostart files!
autoStartFile() {
  local AUTOSTART_DIR="$HOME/.config/autostart/"
  [ ! -d "$AUTOSTART_DIR" ] && mkdir "$AUTOSTART_DIR"

  if [ -d "$AUTOSTART_DIR" ]; then
    cat > "$AUTOSTART_DIR/$1.desktop" << EOF
    [Desktop Entry]
    Type=Application
    Exec=$2
    Name=$3
    Comment=$4
EOF
  fi
}
