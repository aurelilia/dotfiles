{ config, lib, pkgs, ... }: {
  imports = [
    ./backup.nix
    ./hardware.nix

    # ./containers/caddy.nix

    ../../fleet/modules/zfs.nix
  ];

  # ZFS
  networking.hostId = "00000000";
  virtualisation.docker.storageDriver = "zfs";

  # Janky DVB card
  environment.systemPackages = [ pkgs.libreelec-dvb-firmware ];
  hardware.firmware = [ pkgs.libreelec-dvb-firmware ];
}
