{ ... }:
{
  imports = [
    ./backup.nix
    ./hardware.nix
  ];
  elia.systemType = "workstation";

  virtualisation.libvirtd.enable = true;
}
