{ ... }:
let
  nodes = (import ../../meta.nix).nodes;
in
{
  imports = [
    ./backup.nix
    ./disko.nix
    ./hardware.nix

    ./services/caddy.nix
    ./services/coturn.nix
    ./services/forgejo.nix
    ./services/headscale.nix
    ./services/kuma.nix
    ./services/matrix-client.nix
    ./services/postfix.nix
    ./services/send.nix
  ];

  feline = {
    # DNS: Direct records
    dns.baseRecord = {
      a.data = nodes.manul.ipv4;
      aaaa.data = nodes.manul.ipv6;
    };
  };

  # SSH - Server is publically reachable, make it slightly less bad
  services.openssh.ports = [ 9022 ];
}
