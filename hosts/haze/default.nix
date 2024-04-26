{ ... }:
{
  imports = [
    ./backup.nix
    ./hardware.nix

    ./containers/actual.nix
    ./containers/drone.nix
    ./containers/ffsync.nix
    ./containers/immich.nix
    ./containers/jellyfin.nix
    ./containers/joplin.nix
    ./containers/nextcloud.nix
    ./containers/scrutiny.nix

    ./services/adguard.nix
    ./services/ddclient.nix
    ./services/homeassistant.nix
    ./services/navidrome.nix
    ./services/nfs.nix
    ./services/paperless.nix
    ./services/vaultwarden.nix
    ./services/vikunja.nix

    ./vms/cauldron.nix
    # ./vms/swarm.nix
  ];
  elia.systemType = "server";

  # Initrd networking kernel drivers
  boot.kernelModules = [ "igb" ];
  boot.initrd.kernelModules = [ "igb" ];

  # QEMU
  networking.bridges.vmbr0.interfaces = [ "eno1" ];
  networking.firewall.enable = false; # uhhh? TODO
}
