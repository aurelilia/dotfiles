#!/bin/bash

# Environment
dunst -conf ~/.config/dunstrc &
swaybg -i $(shuf -e -n1 ~/wallpapers/*) &
waybar &
swayidle &

# Pipewire
pipewire &
pipewire-pulse &
wireplumber &

# Apps
syncthing &
thunderbird &
fcitx -d &

# XDG Portal
killall xdg-desktop-portal-hyprland
killall xdg-desktop-portal-wlr
killall xdg-desktop-portal
/usr/lib/xdg-desktop-portal-hyprland &
sleep 2
/usr/lib/xdg-desktop-portal &