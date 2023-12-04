#!/bin/sh
killall switch_workspace_sleep.sh
eww open workspace-popup
~/.config/sway/scripts/switch_workspace_sleep.sh
eww close workspace-popup
