{ lib, ... }:
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

  # Steam
  nixpkgs.config.allowUnfreePredicate = pkg: (lib.hasPrefix "steam" (lib.getName pkg));
  programs.steam.enable = true;

  # Niri config
  feline.gui = {
    autoSuspend = true;
    extraNiri = ''
      output "eDP-1" {
          mode "2560x1440"
          scale 1.25
          position x=3840 y=0
      }
      output "Samsung Electric Company LU28R55 HNMW602400" {
          mode "3840x2160"
          scale 1.5
          position x=0 y=0
      }
    '';
  };
}
