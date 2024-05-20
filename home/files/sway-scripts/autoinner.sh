#!/bin/sh
export NIXOS_OZONE_WL=1

# Environment
# Apply user
if [ -e ~/.config/environment.d/ ]; then . ~/.config/environment.d/*; fi
# Misc env apps
~/.config/sway/scripts/wallpaper.sh &
swayidle &
sway-audio-idle-inhibit &
autotiling-rs &
dunst -conf ~/.config/dunstrc &
waybar &

# Apps
ulauncher &
thunderbird &
keepassxc &
