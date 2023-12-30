#!/bin/sh
killall switch_workspace_sleep.sh
swaymsg workspace $@
sh ~/.config/eww/scripts/workspaces.sh

# Work around Electron being broken
# TODO: Remove once Electron supports Wayland properly
# https://github.com/electron/electron/issues/39449
WS=$(swaymsg -t get_workspaces -r | jq ".[] | select(.focused) | .num")
if [ "$WS" = "3" ]; then
    swaymsg output DP-3 scale 1.0
else
    swaymsg output DP-3 scale 1.5
fi

SCR=$(sh ~/.config/eww/scripts/screen.sh)
eww open --arg monitor="$SCR" workspace-popup
~/.config/sway/scripts/switch_workspace_sleep.sh
eww close workspace-popup
