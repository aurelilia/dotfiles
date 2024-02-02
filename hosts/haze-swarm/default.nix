{ ... }:
{
  imports = [
    ./hardware.nix
    ./disko.nix
  ];
  elia.systemType = "server";
}
