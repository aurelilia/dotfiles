#!/bin/sh

ssh root@$1 'mkdir -p /mnt/etc/nixos && ssh-keygen -t ed25519 -N "" -f /mnt/etc/nixos/ssh_host_ed25519_key'
./utils/remote-install.sh $1 /mnt
ssh root@$1 'umount -R /mnt && reboot'
