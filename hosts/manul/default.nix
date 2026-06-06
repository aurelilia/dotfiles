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
    ./containers/joplin.nix
    ./containers/mastodon.nix

    ./services/caddy.nix
    ./services/forgejo.nix
    ./services/headscale.nix
    ./services/homepage.nix
    ./services/mollysocket.nix
    ./services/ntfy.nix
    ./services/postfix.nix
  ];

  # DNS: Direct records
  feline.dns.baseRecord = {
    a.data = nodes.manul.ipv4;
    aaaa.data = nodes.manul.ipv6;
  };

  # SSH - Server is publically reachable, make it slightly less bad
  services.openssh.ports = [ 9022 ];
}
