{ lib, ... }:
{
  imports = [
    ./backup.nix
    ./hardware.nix
  ];

  # Separate Swap partition
  boot.zfs = {
    allowHibernation = true;
    forceImportRoot = false;
  };

  # Suspend and hibernate is broken
  services.logind = {
    hibernateKey = lib.mkForce "ignore";
    suspendKey = lib.mkForce "ignore";
    suspendKeyLongPress = lib.mkForce "ignore";
    lidSwitch = lib.mkForce "ignore";
  };
}
