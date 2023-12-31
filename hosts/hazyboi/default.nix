args@{ config, lib, pkgs, ... }: {
  imports = [
    ./backup.nix
    ./hardware.nix

    ../../fleet/modules/borg.nix
    ../../fleet/modules/zfs.nix
  ];

  # Scanner
  hardware.sane.enable = true;
  hardware.sane.extraBackends = [ pkgs.epkowa ];
  users.users.leela.extraGroups = [ "scanner" ];
  environment.systemPackages = [ pkgs.libsForQt5.skanlite ];
}
