{ lib, ... }:
{
  imports = [
    ./backup.nix
    ./disko.nix
    ./hardware.nix
  ];

  # Separate Swap partition
  boot.zfs = {
    unsafeAllowHibernation = true;
    forceImportRoot = false;
  };

  # Steam
  nixpkgs.config.allowUnfreePredicate = pkg: (lib.hasPrefix "steam" (lib.getName pkg));
  programs.steam.enable = true;

  # Niri config
  feline.gui = {
    autoSuspend = true;
    extraNiri = ''
      output "eDP-1" {
          mode "2560x1440"
          scale 1.25
          position x=3840 y=0
      }
      output "Samsung Electric Company LU28R55 HNMW602400" {
          mode "3840x2160"
          scale 1.5
          position x=0 y=0
      }
    '';
  };

  # Bluetooth stutter stuff
  boot.extraModprobeConfig = ''
    # Keep Bluetooth coexistence disabled for better BT audio stability
    options iwlwifi bt_coex_active=0

    # Enable software crypto (helps BT coexistence sometimes)
    options iwlwifi swcrypto=1

    # Disable power saving on Wi-Fi module to reduce radio state changes that might disrupt BT
    options iwlwifi power_save=0

    # Disable Unscheduled Automatic Power Save Delivery (U-APSD) to improve BT audio stability
    options iwlwifi uapsd_disable=1

    # Disable D0i3 power state to avoid problematic power transitions
    options iwlwifi d0i3_disable=1

    # Set power scheme for performance (iwlmvm)
    options iwlmvm power_scheme=1
  '';
  hardware.bluetooth.settings = {
    General = {
      ControllerMode = "bredr"; # Fix frequent Bluetooth audio dropouts
      Experimental = true;
      FastConnectable = true;
    };
    Policy.AutoEnable = true;
  };
}
