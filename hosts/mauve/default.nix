args@{ config, lib, pkgs, ... }: {
  imports = [
    ./backup.nix
    ./hardware.nix

    ../../fleet/modules/borg.nix
    ../../fleet/modules/zfs.nix
  ];

  # Separate Swap partition
  boot.zfs.allowHibernation = true;
  boot.zfs.forceImportRoot = false;
}
