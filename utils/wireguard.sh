umask 077
wg genkey > /tmp/wireguard-private
wg pubkey < /tmp/wireguard-private > /tmp/wireguard-public
scp /tmp/wireguard-private /tmp/wireguard-public root@$1:/etc/nixos/
cat /tmp/wireguard-public
rm /tmp/wireguard-private /tmp/wireguard-public
