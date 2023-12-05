#!/bin/sh

# doas
cp files/doas.conf /etc/doas.conf

# sanoid
cp files/sanoid /etc/cron.d/
mkdir -p /etc/sanoid
cp files/sanoid.conf /etc/sanoid/

# keymap. cheating
cp .config/home-manager/misc/files/us $(fd us /nix/store | rg symbols/us)

# some packages i want / need
pacman -S alsa-utils catppuccin-gtk-theme-mocha fish flatpak nfs-utils \
          ntfs-3g opendoas pipewire-alsa pipewire-pulse pipewire wireplumber \
          xdg-desktop-portal-wlr xf86-video-amdgpu
