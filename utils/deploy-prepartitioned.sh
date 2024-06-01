#!/bin/sh

ssh root@$1 'mkdir -p /mnt/persist/secrets/ssh && ssh-keygen -t ed25519 -N "" -f /mnt/persist/secrets/ssh/ssh_host_ed25519_key && cat /mnt/persist/secrets/ssh/ssh_host_ed25519_key.pub'
read -p "Add key to secrets and press enter to continue" </dev/tty
./utils/remote-install.sh $1 /mnt
