#!/bin/sh
killall switch_workspace_sleep.sh
swaymsg workspace $@
sh ~/.config/eww/scripts/workspaces.sh

SCR=$(sh ~/.config/eww/scripts/screen.sh)
eww open --arg monitor="$SCR" workspace-popup
~/.config/sway/scripts/switch_workspace_sleep.sh
eww close workspace-popup
