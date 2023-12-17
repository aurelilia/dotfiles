#!/bin/sh

# install nix
sh <(curl -L https://nixos.org/nix/install) --daemon

# some packages i want / need
paru -S alsa-utils fish nfs-utils \
          ntfs-3g opendoas pipewire-alsa pipewire-pulse pipewire wireplumber \
          xdg-desktop-portal-wlr feishin-bin xorg-xwayland greetd-tuigreet
