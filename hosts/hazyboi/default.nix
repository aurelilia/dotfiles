{ pkgs, lib, ... }:
{
  imports = [
    ./backup.nix
    ./hardware.nix
  ];
  feline.archetype = "desktop";

  virtualisation.libvirtd = {
    enable = true;
    parallelShutdown = 5;
    qemu.runAsRoot = false;
  };

  hardware.sane = {
    enable = true;
    extraBackends = [ pkgs.epkowa ];
  };
  users.users.leela.extraGroups = [ "scanner" ];
  environment.systemPackages = [ pkgs.skanlite ];
  nixpkgs.config.allowUnfreePredicate = pkg: lib.hasPrefix "iscan" (lib.getName pkg);
}
