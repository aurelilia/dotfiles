{ pkgs, lib, ... }:
{
  imports = [
    ./backup.nix
    ./hardware.nix
  ];
  elia.systemType = "workstation";

  virtualisation.libvirtd.enable = true;

  hardware.sane.enable = true;
  hardware.sane.extraBackends = [ pkgs.epkowa ];
  users.users.leela.extraGroups = [ "scanner" ];
  environment.systemPackages = [ pkgs.skanlite ];
  nixpkgs.config.allowUnfreePredicate = pkg: lib.hasPrefix "iscan" (lib.getName pkg);
}
