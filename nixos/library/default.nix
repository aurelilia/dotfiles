{ ... }:
{
  imports = [
    # ./auto-deploy.nix
    ./borg.nix
    ./caddy.nix
    ./docker.nix
    ./docker-compose.nix
    ./gui.nix
    ./mobile-device.nix
    ./network.nix
    ./nspawn.nix
    ./packages.nix
    ./persist.nix
    ./ssh.nix
    ./users.nix
    ./zfs.nix
  ];
}
