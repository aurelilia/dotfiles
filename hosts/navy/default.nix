{ config, lib, pkgs, ... }: {
  imports = [
    ./backup.nix
    ./hardware.nix

    ./containers/atuin.nix
    ./containers/caddy.nix
    ./containers/element.nix
    ./containers/forgejo.nix
    ./containers/kuma.nix
    ./containers/mail.nix
    ./containers/piped.nix
    ./services/coturn.nix
    ./services/nat.nix
  ];

  # SSH
  # Port 22 is taken by Forgejo
  services.openssh.ports = [ 9022 ];
}
