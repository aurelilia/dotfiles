{ ... }:
let
  nodes = (import ../../meta.nix).nodes;
in
{
  imports = [
    ./backup.nix
    ./disko.nix
    ./hardware.nix

    ./containers/authentik.nix
    ./containers/mastodon.nix
    ./containers/matrix/ehira.nix
    ./containers/matrix/garden.nix
    ./containers/mealie.nix

    ./services/caddy.nix
    ./services/coturn.nix
    ./services/forgejo.nix
    ./services/headscale.nix
    ./services/kuma.nix
    ./services/matrix/client.nix
    ./services/matrix/tessa.nix
    ./services/ntfy.nix
    ./services/postfix.nix
    ./services/send.nix
  ];

  # DNS: Direct records
  feline.dns.baseRecord = {
    a.data = nodes.manul.ipv4;
    aaaa.data = nodes.manul.ipv6;
  };

  # SSH - Server is publically reachable, make it slightly less bad
  services.openssh.ports = [ 9022 ];
}
