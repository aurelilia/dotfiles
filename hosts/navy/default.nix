{ config, lib, pkgs, ... }: {
  imports = [
    ./backup.nix
    ./hardware.nix

    # ./containers/atuin.nix
    ./containers/caddy.nix
    ./containers/element.nix
    ./containers/forgejo.nix
    ./containers/kuma.nix
    ./containers/mail.nix
    ./containers/piped.nix
    ./services/coturn.nix
    ./services/nat.nix

    ../../fleet/modules/borg.nix
    ../../fleet/modules/nspawn.nix
  ];

  # SSH
  # Port 22 is taken by Forgejo
  services.openssh.ports = [ 9022 ];

  lib.containers.test = {
    c1 = {
      config = { ... }: {};
    };
    c2 = {
      config = { ... }: {};
    };
  };
  lib.containers.test2 = {
    c1 = {
      config = { ... }: {};
    };
    c2 = {
      config = { ... }: {};
    };
  };
}
