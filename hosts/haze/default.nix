{ config, lib, pkgs, ... }: {
  imports = [
    ./backup.nix
    ./hardware.nix

    ../../fleet/modules/borg.nix
    ../../fleet/modules/libvirt.nix
    ../../fleet/modules/zfs.nix
  ];

  # Initrd networking kernel drivers
  boot.kernelModules = [ "igb" ];
  boot.initrd.kernelModules = [ "igb" ];

  # Libvirt
  networking.bridges.vmbr0.interfaces = [ "eno1" ];
  networking.firewall.enable = false;
}
