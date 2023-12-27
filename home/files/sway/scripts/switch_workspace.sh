#!/bin/sh
killall switch_workspace_sleep.sh
swaymsg workspace $@
sh ~/.config/eww/scripts/workspaces.sh

if [ $(sh ~/.config/eww/scripts/screencount.sh) -gt 1 ]; then
    eww open workspace-popup-0
    eww open workspace-popup-1
    ~/.config/sway/scripts/switch_workspace_sleep.sh
    eww close workspace-popup-0
    eww close workspace-popup-1
else 
    eww open workspace-popup-0
    ~/.config/sway/scripts/switch_workspace_sleep.sh
    eww close workspace-popup-0
fi
