{ ... }:
{
  imports = [ ./optional/docker.nix ];

  nix.settings.allowed-users = [ "root" ];
  home-manager.users.root = import ../home/server.nix;
}
