{ name, nodes, config, lib, pkgs, ... }: {
  imports = [
    ./modules/docker.nix
    ./modules/network.nix
    ./modules/ssh.nix
  ];

  home-manager.users.root = import ../home/server.nix;
}
