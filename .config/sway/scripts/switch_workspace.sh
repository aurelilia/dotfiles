#!/bin/sh
killall switch_workspace_sleep.sh
swaymsg workspace $@
eww update workspaces="$(swaymsg -t get_workspaces -r | jq --compact-output)"
eww open workspace-popup
~/.config/sway/scripts/switch_workspace_sleep.sh
eww close workspace-popup
