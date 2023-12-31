args@{ config, lib, pkgs, ... }: {
  imports = [
    ./backup.nix
    ./hardware.nix

    ../../fleet/modules/borg.nix
    ../../fleet/modules/zfs.nix
  ];

  hardware.sane.enable = true;
  hardware.sane.extraBackends = [ pkgs.epkowa ];
  users.users.leela.extraGroups = [ "scanner" "lp" ];
  environment.systemPackages = [ pkgs.gnome.simple-scan ];
}
