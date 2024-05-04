{ ... }:
{
  imports = [
    ./backup.nix
    ./disko.nix
    ./hardware.nix
  ];
  feline.archetype = "mobile";

  # Separate Swap partition
  boot.zfs = {
    allowHibernation = true;
    forceImportRoot = false;
  };
}
