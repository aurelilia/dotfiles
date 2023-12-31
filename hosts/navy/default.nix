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

    ../../fleet/modules/borg.nix
  ];

  # SSH
  # Port 22 is taken by Forgejo
  services.openssh.ports = [ 9022 ];
}
