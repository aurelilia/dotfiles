args@{ config, lib, pkgs, ... }: {
  imports = [
    ./backup.nix
    ./hardware.nix

    ../../fleet/modules/zfs.nix
  ];

  networking.hostId = "42df1e0d";

  services.logind = {
    powerKey = "ignore";
    hibernateKey = "ignore";
    suspendKey = "ignore";
    suspendKeyLongPress = "ignore";
    lidSwitch = "suspend";
    lidSwitchExternalPower = "ignore";
  };
  services.upower.enable = true;
}
