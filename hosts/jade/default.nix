{ config, lib, pkgs, ... }: {
  imports = [
    ./backup.nix
    ./hardware.nix

    # ./containers/caddy.nix

    ../../fleet/modules/borg.nix
    ../../fleet/modules/zfs.nix
  ];

  # Janky DVB card
  environment.systemPackages = [ pkgs.libreelec-dvb-firmware ];
  hardware.firmware = [ pkgs.libreelec-dvb-firmware ];

  # Caddy, for now, until it's migrated into a NixOS container
  networking.firewall.allowedTCPPorts = [ 80 443 8448 ];
}
