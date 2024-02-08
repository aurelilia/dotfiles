{ ... }:
{
  imports = [
    ./backup.nix
    ./hardware.nix
    ./containers/actual.nix
    ./containers/authentik.nix
    ./containers/bookstack.nix
    ./containers/drone.nix
    ./containers/ffsync.nix
    ./containers/homeassistant.nix
    ./containers/joplin.nix
    ./containers/mastodon.nix
    ./containers/matrix.nix
    ./containers/matrix-louane.nix
    ./containers/metube.nix
    ./containers/nextcloud.nix

    ./services/ddclient.nix
    ./services/navidrome.nix
    ./services/nfs.nix
    ./services/tvheadend.nix
    ./services/vivi.nix
    ./services/paperless.nix
    ./services/vaultwarden.nix
  ];
  elia.systemType = "server";
}
