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
    ./containers/mastodon.nix
    ./containers/matrix-garden.nix
    ./containers/matrix-louane.nix
    ./containers/minecraft.nix
    ./containers/nextcloud.nix

    ./services/adguard.nix
    ./services/bupstash.nix
    ./services/ddclient.nix
    ./services/homeassistant.nix
    ./services/matrix-ehira.nix
    ./services/matrix-tessa.nix
    ./services/navidrome.nix
    ./services/nfs.nix
    ./services/paperless.nix
    ./services/redirs.nix
    ./services/scrutiny.nix
    ./services/vikunja.nix

    # ./vms/cauldron.nix
    # ./vms/swarm.nix
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
  # Also sync photo inbox from my phone.
  services.syncthing.settings.folders.camera-inbox = {
    path = "/media/photo-inbox/camera-inbox";
    devices = [ "murray" ];
  };

  # Tang
  feline.tang.enable = true;
}
