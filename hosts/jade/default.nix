{ ... }:
{
  imports = [
    ./backup.nix
    ./hardware.nix

    ./services/ddclient.nix
    ./services/nfs.nix
    ./services/redirs.nix
    ./services/tvheadend.nix
    ./services/vivi.nix
    # ./services/zomboid.nix
  ];
  feline.archetype = "server";
}
