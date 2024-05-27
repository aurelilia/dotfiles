{ ... }:
{
  imports = [
    ./backup.nix
    ./hardware.nix
    ./services/nfs.nix
    ./services/tvheadend.nix
  ];
  feline.archetype = "server";

  # Not used
  feline.docker.enable = false;
}
