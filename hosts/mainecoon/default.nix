{ lib, ... }:
{
  imports = [
    ./disko.nix
    ./hardware.nix
  ];

  # Some stuff disabled
  services.mullvad-vpn.enable = lib.mkForce false;
  feline = {
    borg.persist.enable = lib.mkForce false;
    zfs.znap.enable = lib.mkForce false;
    syncthing.enable = lib.mkForce false;
    tang.enable = lib.mkForce false;
    tailscale.enable = lib.mkForce false;
    borg.media.enable = lib.mkForce false;
    smartd.enable = lib.mkForce false;

    dotfiles = {
      full = lib.mkForce false;
      full-slim = true;
    };
  };

  # Separate Swap partition
  boot.zfs = {
    allowHibernation = true;
    forceImportRoot = false;
  };

  # Sway config
  feline.gui.autoSuspend = true;
}
