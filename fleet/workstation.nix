{ name, nodes, config, lib, pkgs, ... }: {
  imports = [
  ];

  home-manager.users.leela = import ../home/workstation.nix;
}
