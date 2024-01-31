{ pkgs, lib, ... }:
{
  services.tvheadend.enable = true;
  users.users.tvheadend.home = lib.mkForce "/persist/data/tvheadend";
  networking.firewall.allowedTCPPorts = [
    9981
    9982
  ];

  # Janky DVB card
  environment.systemPackages = [ pkgs.libreelec-dvb-firmware ];
  hardware.firmware = [ pkgs.libreelec-dvb-firmware ];
}
