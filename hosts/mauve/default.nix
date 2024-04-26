{ ... }:
{
  imports = [
    ./backup.nix
    ./hardware.nix
  ];
  feline.archetype = "mobile";

  # Separate Swap partition
  boot.zfs = {
    allowHibernation = true;
    forceImportRoot = false;
  };
}
