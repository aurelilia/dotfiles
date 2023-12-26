#!/bin/sh

ssh-copy-id root@$2
scp hosts/$1/disko.nix root@$2:/tmp/disko.nix

ssh root@$2 'sudo nix --experimental-features "nix-command flakes" run github:nix-community/disko -- --mode disko /tmp/disko.nix'
ssh root@$2 'mkdir -p /mnt/etc/nixos && ssh-keygen -t ed25519 -N "" -f /mnt/etc/nixos/ssh_host_ed25519_key'
./utils/remote-install.sh $2 /mnt
ssh root@$2 'umount /mnt && reboot'
