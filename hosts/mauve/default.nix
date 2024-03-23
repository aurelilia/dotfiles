{ pkgs, ... }:
{
  imports = [
    ./backup.nix
    ./hardware.nix
  ];
  elia = {
    systemType = "workstation";
    mobile = true;
  };

  # Separate Swap partition
  boot.zfs.allowHibernation = true;
  boot.zfs.forceImportRoot = false;

  # I want Mullvad & Lutris
  services.mullvad-vpn.enable = true;
  environment.systemPackages = [ pkgs.lutris-free ];
}
