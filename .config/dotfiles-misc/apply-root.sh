#!/bin/sh

# doas
cp doas.conf /etc/doas.conf

# lightdm
cp -r lightdm/ /etc

# sanoid
cp sanoid /etc/cron.d/
mkdir -p /etc/sanoid
cp sanoid.conf /etc/sanoid/

# services
dinitctl enable cronie
dinitctl enable lightdm

# keymap
cp us /usr/share/X11/xkb/symbols/
