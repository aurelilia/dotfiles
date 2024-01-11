{ config, lib, pkgs, ... }: {
  imports = [
    ./backup.nix
    ./hardware.nix

    ./containers/caddy.nix
    ./containers/element.nix
    ./containers/forgejo.nix
    ./containers/kuma.nix
    ./containers/mail.nix
    ./containers/piped.nix
    ./services/coturn.nix

    ../../fleet/modules/borg.nix
  ];

  # SSH
  # Port 22 is taken by Forgejo
  services.openssh.ports = [ 9022 ];

  # NAT
  # Haze is behind NAT.
  networking.nat = {
    enable = true;
    externalInterface = "ens3";
    internalInterfaces = [ "wg0" ];
    internalIPs = [ "10.45.0.0/24" ];
    forwardPorts = [{
      destination = "haze-wg:22";
      proto = "tcp";
      sourcePort = 10293;
    }];
  };
}
