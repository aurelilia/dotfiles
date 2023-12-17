args@{ config, lib, pkgs, ... }: {
  imports = [
    ./backup.nix
    ./hardware.nix

    ../../fleet/modules/zfs.nix
  ];

  networking.hostId = "42df1e0d";
}