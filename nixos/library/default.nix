{ ... }:
{
  imports = [
    ./config/grub.nix
    ./config/keymap.nix
    ./config/power-management.nix
    ./config/network.nix
    ./config/lix.nix
    ./config/users.nix
    ./config/zfs.nix
    ./config/wireless.nix

    ./modules/dns.nix
    ./modules/notify.nix
    ./modules/nspawn.nix
    ./modules/persist.nix
    ./modules/qemu.nix
    ./modules/steamcmd.nix

    ./services/auto-deploy.nix
    ./services/borg.nix
    ./services/caddy.nix
    ./services/docker.nix
    ./services/docker-compose.nix
    ./services/gui.nix
    ./services/smart-metrics.nix
    ./services/ssh.nix
    ./services/syncthing.nix
    ./services/tailscale.nix
    ./services/znapzend.nix
  ];
}
