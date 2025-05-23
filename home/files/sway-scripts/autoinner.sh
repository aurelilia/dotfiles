#!/bin/sh
export NIXOS_OZONE_WL=1

# Environment
# Apply user
if [ -e ~/.config/environment.d/ ]; then . ~/.config/environment.d/*; fi
# Misc env apps
~/.config/sway/scripts/wallpaper.sh &
autotiling-rs &
dunst -conf ~/.config/dunst/dunstrc &
waybar &
systemctl --user restart swayidle

# Apps
thunderbird &
keepassxc &
