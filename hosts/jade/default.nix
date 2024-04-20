{ ... }:
{
  imports = [
    ./backup.nix
    ./hardware.nix
    ./containers/authentik.nix
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
    ./services/nfs.nix
    ./services/tvheadend.nix
    ./services/vivi.nix
    # ./services/zomboid.nix
  ];
  elia.systemType = "server";

  # New domain and server for these.
  elia.caddy.routes = {
    "music.elia.garden".redir = "music.kitten.works";
  };
}
