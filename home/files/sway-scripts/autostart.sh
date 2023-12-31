#!/bin/sh

# Environment
# Apply user
if [ -e ~/.config/environment.d/ ]; then . ~/.config/environment.d/*; fi
# Misc env apps
~/.config/sway/scripts/wallpaper.sh &
swayidle &
sway-audio-idle-inhibit &
autotiling-rs &
ydotoold &
dunst -conf ~/.config/dunstrc &

# Apps
thunderbird &
ulauncher &

# Eww needs a moment, otherwise SWWW ends up on top...
sleep 1
~/.config/eww/init.sh
