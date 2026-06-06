{ ... }:
{
  imports = [
    ./backup.nix
    ./hardware.nix

    ./containers/actual.nix
    ./containers/ffsync.nix
    ./containers/immich.nix
    ./containers/nextcloud.nix

    ./services/adguard.nix
    ./services/bupstash.nix
    ./services/ddclient.nix
    ./services/homeassistant.nix
    ./services/jellyfin.nix
    ./services/navidrome.nix
    ./services/nfs.nix
    ./services/paperless.nix
  ];

  # Initrd networking kernel drivers
  boot.kernelModules = [ "igb" ];
  boot.initrd.kernelModules = [ "igb" ];

  # QEMU
  networking.bridges.vmbr0.interfaces = [ "eno1" ];
  networking.firewall.trustedInterfaces = [
    "eno1"
    "vmbr0"
  ];

  # Syncthing
  feline.syncthing = {
    enable = true;
    user = "syncthing";
    dataDir = "/media/media/syncthing";
  };

  # Needs DNS
  feline.caddy.routes."mc.catin.eu".redir = "catin.eu";
}
