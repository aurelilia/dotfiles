{ ... }:
{
  imports = [
    ./backup.nix
    ./hardware.nix
    ./services/nfs.nix
    ./services/tvheadend.nix
  ];
}
