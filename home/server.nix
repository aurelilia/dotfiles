{ config, lib, pkgs, ... }:
{
  imports = [ ./home.nix ];

  config = {
    home.username = "root";
    home.homeDirectory = "/root";
  };
}
