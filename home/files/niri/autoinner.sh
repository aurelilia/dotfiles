#!/bin/sh
export NIXOS_OZONE_WL=1

# Environment
# Apply user
if [ -e ~/.config/environment.d/ ]; then . ~/.config/environment.d/*; fi
# Misc env apps
~/.config/niri/wallpaper.sh &
dunst -conf ~/.config/dunst/dunstrc &
waybar &
systemctl --user restart swayidle

# Apps
thunderbird &
keepassxc &
