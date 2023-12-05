#!/bin/sh

# doas
cp files/doas.conf /etc/doas.conf

# lightdm
cp -r lightdm/ /etc

# sanoid
cp files/sanoid /etc/cron.d/
mkdir -p /etc/sanoid
cp files/sanoid.conf /etc/sanoid/

# keymap. cheating
cp .config/home-manager/misc/files/us $(fd us /nix/store | rg symbols/us)

# some packages i want
pacman -S fish opendoas
