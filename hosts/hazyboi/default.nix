{ pkgs, lib, ... }:
{
  imports = [
    ./backup.nix
    ./hardware.nix
  ];
  feline.archetype = "desktop";

  # Libvirt
  virtualisation.libvirtd = {
    enable = true;
    parallelShutdown = 5;
    qemu.runAsRoot = false;
  };

  # Scanner / SANE
  hardware.sane = {
    enable = true;
    extraBackends = [ pkgs.epkowa ];
  };
  users.users.leela.extraGroups = [ "scanner" ];
  environment.systemPackages = [ pkgs.skanlite ];
  nixpkgs.config.allowUnfreePredicate = pkg: lib.hasPrefix "iscan" (lib.getName pkg);

  # Sway configuration
  feline.gui.extraSway = {
    output = {
      HDMI-A-1 = {
        resolution = "2560x1440";
        position = "0 0";
        transform = "90";
      };
      DP-3 = {
        resolution = "3840x2160";
        position = "1440 780";
        scale = "1.5";
      };
    };

    workspaceOutputAssign = [
      {
        output = "DP-3";
        workspace = "1";
      }
      {
        output = "HDMI-A-1";
        workspace = "2";
      }
      {
        output = "DP-3";
        workspace = "3";
      }
      {
        output = "DP-3";
        workspace = "10";
      }
    ];
  };
}
