{ config, lib, pkgs, ... }: {
  imports = [
    ./backup.nix
    ./hardware.nix

    ./containers/caddy.nix
    ./modules/dvb-firmware.nix

    ../../fleet/modules/zfs.nix
  ];

  networking.hostId = "42df1e05";
}