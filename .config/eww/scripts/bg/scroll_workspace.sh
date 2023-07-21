#!/bin/sh
if [ "$1" = "up" ]; then
    ~/.config/sway/scripts/switch_workspace.sh next &
else
    ~/.config/sway/scripts/switch_workspace.sh prev &
fi
