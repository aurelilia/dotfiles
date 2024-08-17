#!/bin/sh

DIRECTORY="/ethereal/pins"
FILES=$(fd -e vpx --base-directory "$DIRECTORY" | rev | cut -c5- | rev)
if [ -z "$FILES" ]; then
  exit 1
fi

export SELECTED_FILE=$(echo "$FILES" | rofi -dmenu -p "Pinball")
if [ -z "$SELECTED_FILE" ]; then
  exit 1
fi

alacritty -e /home/leela/.vpinball/run-db.sh "/ethereal/pins/$SELECTED_FILE.vpx"
