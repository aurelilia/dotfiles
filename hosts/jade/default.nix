{ config, lib, pkgs, ... }: {
  imports = [
    ./backup.nix
    ./hardware.nix

    # ./containers/caddy.nix

    ../../fleet/modules/zfs.nix
  ];

  # Janky DVB card
  environment.systemPackages = [ pkgs.libreelec-dvb-firmware ];
  hardware.firmware = [ pkgs.libreelec-dvb-firmware ];
}
