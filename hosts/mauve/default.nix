{ ... }:
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
    hibernateKey = "ignore";
    suspendKey = "ignore";
    suspendKeyLongPress = "ignore";
    lidSwitch = "ignore";
  };
}
