{ ... }:
let
  nodes = (import ../../meta.nix).nodes;
in
{
  imports = [
    ./backup.nix
    ./disko.nix
    ./hardware.nix

    ./services/forgejo.nix
    ./services/kuma.nix
    ./services/matrix-client.nix
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
