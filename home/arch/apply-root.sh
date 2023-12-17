#!/bin/sh

# doas
echo "permit persist keepenv :wheel" >> /etc/doas.conf

# keymap
cp files/us /usr/local/share/keymap-us
cp files/keymap.hook /usr/share/libalpm/hooks/
cp files/copy-keymap /usr/local/bin/ 

# tuigreet
cp -r files/greetd /etc/greetd

# services
systemctl enable greetd
