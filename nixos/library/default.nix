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
    ./notify.nix
    ./nspawn.nix
    ./packages.nix
    ./persist.nix
    ./ssh.nix
    ./qemu.nix
    ./users.nix
    ./zfs.nix
  ];
}
