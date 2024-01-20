args@{ config, lib, pkgs, ... }: {
  imports = [ ./backup.nix ./hardware.nix ];

  # Separate Swap partition
  boot.zfs.allowHibernation = true;
  boot.zfs.forceImportRoot = false;
}
