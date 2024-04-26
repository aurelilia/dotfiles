{ ... }:
{
  imports = [
    ./backup.nix
    ./hardware.nix
    ./containers/mastodon.nix
    ./containers/matrix.nix

    ./services/ddclient.nix
    ./services/nfs.nix
    ./services/redirs.nix
    ./services/tvheadend.nix
    ./services/vivi.nix
    # ./services/zomboid.nix
  ];
  elia.systemType = "server";
}
