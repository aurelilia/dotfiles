#!/bin/sh

# ethereal
mkdir -p /ethereal/cache/{cache,rustup,gradle,cargo}
ln -s /ethereal/cache/cache ~/.cache

# install nix
sh <(curl -L https://nixos.org/nix/install) --daemon
nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
nix-channel --update
nix-channel --add https://github.com/guibou/nixGL/archive/main.tar.gz nixgl && nix-channel --update
nix-env -iA nixgl.nixGLIntel
nix-shell '<home-manager>' -A install

# firefox profile
cp -r firefox/* ~/.mozilla/firefox/*.*/
# ulauncher
cp -r ../files/ulauncher ~/.config/

# some packages i want / need
paru -S alsa-utils catppuccin-gtk-theme-mocha fish nfs-utils \
          ntfs-3g opendoas pipewire-alsa pipewire-pulse pipewire wireplumber \
          xdg-desktop-portal-wlr firefox thunderbird feishin-bin xorg-xwayland
