{ lib, config, ... }:
{
  imports = [
    # ./auto-deploy.nix
    ./borg.nix
    ./caddy.nix
    ./docker-compose.nix
    ./network.nix
    ./nspawn.nix
    ./packages.nix
    ./ssh.nix
    ./zfs.nix
  ];

  # Random misc things.
  config = lib.mkMerge [
    (lib.mkIf (config.services.tailscale.enable) {
      environment.shellAliases."headscale-connect" = "tailscale up --login-server https://headscale.elia.garden";
    })
  ];
}
