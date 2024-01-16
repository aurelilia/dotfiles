#!/bin/sh
if [ "$1" = "up" ]; then
    ~/.config/sway/scripts/switch_workspace.nu next_on_output &
else
    ~/.config/sway/scripts/switch_workspace.nu prev_on_output &
fi
