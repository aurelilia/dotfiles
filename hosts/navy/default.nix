{ config, lib, pkgs, ... }: {
  imports = [
    ./hardware.nix
  ];

  # Network
  networking.firewall = {
    allowedTCPPorts = [
      # Web
      80 443 8448
      # Gitea/SSH
      22 9022
      # Mail
      25 143 465 587 993
    ];
    allowedUDPPorts = [ 
      # Mail
      25 143 465 587 993
    ];
  };

  # SSH
  services.openssh.ports = [ 9022 ];
}