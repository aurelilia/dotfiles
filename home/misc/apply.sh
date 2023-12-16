#!/bin/sh

# ethereal
mkdir -p /ethereal/cache/{cache,rustup,gradle,cargo}
ln -s /ethereal/cache/cache ~/.cache

# install nix
sh <(curl -L https://nixos.org/nix/install) --daemon

# firefox profile
cp -r firefox/* ~/.mozilla/firefox/*.*/
# ulauncher
cp -r ../files/ulauncher ~/.config/

# some packages i want / need
paru -S alsa-utils catppuccin-gtk-theme-mocha fish nfs-utils \
          ntfs-3g opendoas pipewire-alsa pipewire-pulse pipewire wireplumber \
          xdg-desktop-portal-wlr firefox thunderbird feishin-bin xorg-xwayland \
          greetd-tuigreet
