#!/bin/sh

# doas
cp files/doas.conf /etc/doas.conf

# sanoid
cp files/sanoid /etc/cron.d/
mkdir -p /etc/sanoid
cp files/sanoid.conf /etc/sanoid/

# keymap
cp files/us /usr/local/share/keymap-us
cp files/keymap.hook /usr/share/libalpm/hooks/
cp files/copy-keymap /usr/local/bin/ 