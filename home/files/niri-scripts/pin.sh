#!/bin/sh

DIRECTORY="/ethereal/Games/VPX/pins"
FILES=$(fd -e vpx --base-directory "$DIRECTORY" | rev | cut -c5- | rev)
if [ -z "$FILES" ]; then
  exit 1
fi

export SELECTED_FILE=$(echo "$FILES" | rofi -dmenu -i -l 50 -no-custom -matching fuzzy -p "Pinball")
if [ -z "$SELECTED_FILE" ]; then
  exit 1
fi

alacritty -e /home/leela/.vpinball/run-db.sh "/ethereal/Games/VPX/pins/$SELECTED_FILE.vpx"
