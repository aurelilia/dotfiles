#!/bin/sh
killall switch_workspace_sleep.sh

SCR=$(sh ~/.config/eww/scripts/screen.sh)
eww open workspace-popup-$SCR
~/.config/sway/scripts/switch_workspace_sleep.sh
eww close workspace-popup-$SCR
