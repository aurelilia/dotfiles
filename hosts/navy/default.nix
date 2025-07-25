{ ... }:
let
  nodes = (import ../../meta.nix).nodes;
in
{
  imports = [
    ./backup.nix
    ./hardware.nix

    ./services/caddy.nix
    ./services/coturn.nix
    ./services/forgejo.nix
    ./services/headscale.nix
    ./services/kuma.nix
    ./services/matrix-client.nix
    ./services/postfix.nix
    ./services/redirs.nix
    ./services/send.nix
  ];
  feline = {
    # Persist is not a separate mountpoint
    mountPersistAtBoot = false;
    # DNS: Direct records
    dns.baseRecord = {
      a.data = nodes.navy.ipv4;
      aaaa.data = nodes.navy.ipv6;
    };
  };

  # SSH - Server is publically reachable, make it slightly less bad
  services.openssh.ports = [ 9022 ];
}
