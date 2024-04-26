{ ... }:
{
  imports = [
    ./backup.nix
    ./hardware.nix
    ./containers/authentik.nix
    ./containers/mastodon.nix
    ./containers/matrix.nix
    ./containers/matrix-louane.nix

    ./services/ddclient.nix
    ./services/nfs.nix
    ./services/redirs.nix
    ./services/tvheadend.nix
    ./services/vivi.nix
    # ./services/zomboid.nix
  ];
  elia.systemType = "server";
}
