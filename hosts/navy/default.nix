{ ... }:
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
    ./services/ntfy.nix
    ./services/proxy.nix
  ];
  elia.systemType = "server";

  # VPS, no SMART available.
  elia.smartd.enable = false;

  # SSH
  # Port 22 is taken by Forgejo
  services.openssh.ports = [ 9022 ];

  # nspawn NAT
  elia.natExternal = "ens3";
}
