#!/bin/sh

# Environment
# Apply user
if [ -e ~/.config/environment.d/ ]; then . ~/.config/environment.d/*; fi
# Misc env apps
~/.config/sway/scripts/wallpaper.sh &
sway-audio-idle-inhibit &
autotiling-rs &
~/.config/eww/init.sh
ydotoold &
dunst -conf ~/.config/dunstrc &

# Apps
thunderbird &
ulauncher &
