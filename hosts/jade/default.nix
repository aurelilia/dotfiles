{ ... }:
{
  imports = [
    ./backup.nix
    ./hardware.nix
    ./containers/authentik.nix
    ./containers/bookstack.nix
    ./containers/drone.nix
    ./containers/ffsync.nix
    ./containers/joplin.nix
    ./containers/mastodon.nix
    ./containers/matrix.nix
    ./containers/matrix-louane.nix
    ./containers/metube.nix
    ./containers/nextcloud.nix
    ./containers/scrutiny.nix

    ./services/ddclient.nix
    ./services/navidrome.nix
    ./services/nfs.nix
    ./services/tvheadend.nix
    ./services/vivi.nix
    ./services/zomboid.nix
  ];
  elia.systemType = "server";
}
