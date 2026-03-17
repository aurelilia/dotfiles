#!/bin/sh
export NIXOS_OZONE_WL=1

# Environment
# Apply user
if [ -e ~/.config/environment.d/ ]; then . ~/.config/environment.d/*; fi

# Misc env apps
noctalia-shell &
pywalfox install &
systemctl --user restart swayidle

# Apps
thunderbird &
keepassxc &

# Portal
systemctl --user restart xdg-desktop-portal-gtk
systemctl --user restart xdg-desktop-portal-gnome
sleep 0.2
