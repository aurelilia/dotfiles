{ ... }:
{
  imports = [
    ./auto-deploy.nix
    ./borg.nix
    ./caddy.nix
    ./docker.nix
    ./docker-compose.nix
    ./gui.nix
    ./mobile-device.nix
    ./network.nix
    ./notify.nix
    ./nspawn.nix
    ./packages.nix
    ./persist.nix
    ./qemu.nix
    ./smart-metrics.nix
    ./ssh.nix
    ./steamcmd.nix
    ./users.nix
    ./zfs.nix
  ];
}
