{ ... }:
{
  imports = [
    ./backup.nix
    ./hardware.nix

    ./containers/actual.nix
    ./containers/authentik.nix
    ./containers/drone.nix
    ./containers/ffsync.nix
    ./containers/immich.nix
    ./containers/jellyfin.nix
    ./containers/joplin.nix
    ./containers/mastodon.nix
    ./containers/matrix-garden.nix
    ./containers/matrix-louane.nix
    ./containers/matrix-tessa.nix
    ./containers/nextcloud.nix
    ./containers/scrutiny.nix

    ./services/adguard.nix
    ./services/bupstash.nix
    ./services/ddclient.nix
    ./services/homeassistant.nix
    ./services/navidrome.nix
    ./services/nfs.nix
    ./services/paperless.nix
    ./services/redirs.nix
    ./services/vaultwarden.nix
    ./services/vikunja.nix

    ./vms/cauldron.nix
    # ./vms/swarm.nix
  ];
  feline.archetype = "server";

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
}
