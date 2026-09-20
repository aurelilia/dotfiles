{ pkgs, ... }:
let
  nodes = (import ../../meta.nix).nodes;
in
{
  imports = [
    ./backup.nix
    ./disko.nix
    ./hardware.nix

    ./containers/actual.nix
    ./containers/authentik.nix
    ./containers/immich.nix
    ./containers/joplin.nix
    ./containers/nextcloud.nix
    ./containers/octo-fiesta.nix

    ./services/caddy.nix
    ./services/forgejo.nix
    ./services/headscale.nix
    ./services/homepage.nix
    ./services/mollysocket.nix
    ./services/navidrome.nix
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

  # Use rclone to get access to larger storage on haze
  environment.systemPackages = [
    pkgs.rclone
  ];
  fileSystems."/media" = {
    device = "haze:/media";
    fsType = "rclone";
    options = [
      "nodev"
      "nofail"
      "allow_other"
      "args2env"
      "config=/persist/rclone.conf"
      "cache-dir=/cache"
      "vfs-cache-mode=full"
      "vfs-cache-max-age=365d"
      "vfs-cache-min-free-space=20G"
      "vfs-fast-fingerprint"
      "vfs-read-ahead=2M"
    ];
  };
}
