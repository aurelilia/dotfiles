#!/bin/sh

# Environment
dunst -conf ~/.config/dunstrc &
~/.config/hypr/scripts/wallpaper.sh &
waybar &
swayidle &
sway-audio-idle-inhibit &

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

# GTK being an ass
gsettings set org.gnome.desktop.interface gtk-theme 'Catppuccin-Mocha-Standard-Red-Dark'
gsettings set org.gnome.desktop.interface icon-theme 'Papirus-dark'
gsettings set org.gnome.desktop.interface cursor-theme 'Catppuccin-Mocha-Mauve-Cursors'
