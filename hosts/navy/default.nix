{ config, lib, pkgs, ... }: {
  imports = [
    ./backup.nix
    ./hardware.nix
    ./containers/caddy.nix
    ./containers/element.nix
    ./containers/forgejo.nix
    ./containers/mail.nix
  ];

  # SSH
  services.openssh.ports = [ 9022 ];
}