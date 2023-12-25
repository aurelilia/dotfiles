{ name, nodes, config, lib, pkgs, ... }: {
  imports = [ ./modules/docker.nix ];

  nix.settings.allowed-users = [ "root" ];
  home-manager.users.root = import ../home/server.nix;
}
