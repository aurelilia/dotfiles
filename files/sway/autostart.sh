#!/bin/sh

# Environment
~/.config/sway/scripts/wallpaper.sh &
sway-audio-idle-inhibit &
autotiling-rs &
~/.config/eww/init.sh
ydotoold &
dunst -conf ~/.config/dunstrc

# Apps
thunderbird &