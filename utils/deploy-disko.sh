#!/bin/sh

ssh-copy-id root@$2
scp hosts/$1/disko.nix root@$2:/tmp/disko.nix

ssh root@$2 'sudo nix --experimental-features "nix-command flakes" run github:nix-community/disko -- --mode disko /tmp/disko.nix'
ssh root@$2 'mkdir -p /mnt/persist/secrets/ssh && ssh-keygen -t ed25519 -N "" -f /mnt/persist/secrets/ssh/ssh_host_ed25519_key && cat /mnt/persist/secrets/ssh/ssh_host_ed25519_key.pub'
read -p "Add key to secrets and press enter to continue" </dev/tty

./utils/remote-install.sh $2 /mnt
ssh root@$2 'umount /mnt && reboot'
