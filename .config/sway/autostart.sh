#!/bin/sh

# Environment
dunst -conf ~/.config/dunstrc &
~/.config/sway/scripts/wallpaper.sh &
waybar &
swayidle &
sway-audio-idle-inhibit &
autotiling-rs &
~/.config/eww/init.sh
ydotoold &

# Pipewire
pipewire &
pipewire-pulse &
wireplumber &

# Apps
syncthing serve --no-browser &
thunderbird &

# XDG Portal
killall xdg-desktop-portal-wlr
killall xdg-desktop-portal
/usr/lib/xdg-desktop-portal-wlr &
sleep 2
/usr/lib/xdg-desktop-portal &

# GTK being an ass
gsettings set org.gnome.desktop.interface gtk-theme 'Catppuccin-Mocha-Standard-Red-Dark'
gsettings set org.gnome.desktop.interface icon-theme 'Papirus-dark'
gsettings set org.gnome.desktop.interface cursor-theme 'Catppuccin-Mocha-Mauve-Cursors'
