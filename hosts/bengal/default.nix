{ ... }:
{
  imports = [
    ./backup.nix
    ./disko.nix
    ./hardware.nix
  ];

  # Separate Swap partition
  boot.zfs = {
    allowHibernation = true;
    forceImportRoot = false;
  };

  # Sway screen config
  feline.gui.extraSway.output."eDP-1" = {
    resolution = "2560x1440";
    scale = "1.25";
  };
}
