mkdir -p /persist/secrets/ssh/initrd
mkdir -p /persist/secrets/wireguard
mkdir -p /persist/config
mkdir -p /persist/data

cp -a /etc/nixos/ssh_host* /persist/secrets/ssh/initrd
cp -a /etc/ssh/ssh_host* /persist/secrets/ssh
cp -a /etc/nixos/wireguard* /persist/secrets/wireguard
cp -a /var/lib/iwd /persist/config
cp -a /var/lib/bluetooth /persist/config
cp -a /var/lib/upower /persist/data

chmod 700 /persist/secrets
