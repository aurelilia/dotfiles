{ name, nodes, config, lib, pkgs, ... }: {
  imports = [
    ./modules/docker.nix
  ];

  home-manager.users.root = import ../home/server.nix;
}
