{ ... }:
{
  imports = [
    ./backup.nix
    ./hardware.nix

    ./containers/actual.nix
    ./containers/authentik.nix
    ./containers/ffsync.nix
    ./containers/immich.nix
    ./containers/mastodon.nix
    ./containers/matrix-garden.nix
    ./containers/matrix-ehira.nix
    ./containers/nextcloud.nix

    ./services/adguard.nix
    ./services/bupstash.nix
    ./services/ddclient.nix
    ./services/grafana.nix
    ./services/homeassistant.nix
    ./services/jellyfin.nix
    ./services/matrix-tessa.nix
    # ./services/mealie.nix
    ./services/navidrome.nix
    ./services/nfs.nix
    ./services/ntfy.nix
    ./services/paperless.nix
    ./services/prometheus.nix
    ./services/redirs.nix
    ./services/scrutiny.nix

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
  services.syncthing.settings.folders = {
    # Photo inbox from my phone
    camera-inbox = {
      path = "/media/photo-inbox/camera-inbox";
      devices = [ "munchkin" ];
    };

    # Windows VM for scans
    scan-inbox = {
      path = "/media/photo-inbox/scan-inbox";
      devices = [ "hazyboi-windows" ];
    };
  };

  # Tang
  feline.tang.enable = true;

  # Needs DNS
  feline.caddy.routes."mc.catin.eu".redir = "catin.eu";
}
