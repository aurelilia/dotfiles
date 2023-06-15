#!/bin/sh

# ethereal
mkdir -p /ethereal/screenshots
ln -s /ethereal/screenshots ~/screenshots
mkdir -p /ethereal/cache/{cache,rustup,gradle,cargo}
ln -s /ethereal/cache/cache ~/.cache

# install packages, soon
echo hi im totally apk

# shell
mkdir -p ~/.local/share/zinit
git clone https://github.com/zdharma-continuum/zinit.git ~/.local/share/zinit/bin
chsh -s /bin/zsh

# firefox profile
cp -r firefox/* ~/.mozilla/firefox/*.*/

# bat
bat cache --build
