{ config, lib, pkgs, ... }: {
  imports = [
    ./hardware.nix
    ./containers/caddy.nix
    ./containers/element.nix
    ./containers/gitea.nix
    ./containers/mail.nix
  ];

  # SSH
  services.openssh.ports = [ 9022 ];
}