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
    ./services/redirs.nix
  ];
  feline = {
    archetype = "server";
    # VPS, no SMART available.
    smartd.enable = false;
  };

  # SSH
  # Port 22 is taken by Forgejo
  services.openssh.ports = [ 9022 ];

  # nspawn NAT
  feline.natExternal = "ens3";
}
