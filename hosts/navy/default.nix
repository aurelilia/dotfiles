{ ... }:
let
  nodes = (import ../../meta.nix).nodes;
in
{
  imports = [
    ./backup.nix
    ./hardware.nix

    ./containers/forgejo.nix
    ./containers/piped.nix

    ./services/caddy.nix
    ./services/coturn.nix
    ./services/element-web.nix
    ./services/headscale.nix
    ./services/kuma.nix
    ./services/redirs.nix
  ];
  feline = {
    archetype = "server";
    # VPS, no SMART available.
    smartd.enable = false;
    # Persist is not a separate mountpoint
    mountPersistAtBoot = false;
    # DNS: Direct records
    dns.baseRecord = {
      a.data = nodes.navy.ipv4;
      aaaa.data = nodes.navy.ipv6;
    };
  };

  # SSH
  # Port 22 is taken by Forgejo
  services.openssh.ports = [ 9022 ];

  # nspawn NAT
  feline.natExternal = "ens3";
}
