#!/bin/sh
if [ "$1" = "up" ]; then
    ~/.config/sway/scripts/switch_workspace.sh next_on_output &
else
    ~/.config/sway/scripts/switch_workspace.sh prev_on_output &
fi
