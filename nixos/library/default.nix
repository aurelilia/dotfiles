{ ... }:
{
  imports = [
    ./config/containers.nix
    ./config/grub.nix
    ./config/keymap.nix
    ./config/lix.nix
    ./config/memory.nix
    ./config/network.nix
    ./config/power-management.nix
    ./config/theme.nix
    ./config/users.nix
    ./config/zfs.nix
    ./config/wireless.nix

    ./modules/dns.nix
    ./modules/notify.nix
    ./modules/persist.nix
    ./modules/steamcmd.nix

    ./services/auto-deploy.nix
    ./services/borg.nix
    ./services/caddy.nix
    ./services/docker.nix
    ./services/docker-compose.nix
    ./services/gui.nix
    ./services/postgres.nix
    ./services/smart-metrics.nix
    ./services/ssh.nix
    ./services/syncthing.nix
    ./services/tailscale.nix
    ./services/tang.nix
    ./services/znapzend.nix
  ];
}
