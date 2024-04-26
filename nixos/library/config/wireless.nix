{
  config,
  lib,
  ...
}:
{
  config = lib.mkIf config.kit.wireless {
    # WiFi + Bluetooth
    networking.wireless.iwd.enable = true;
    hardware.bluetooth = {
      enable = true;
      powerOnBoot = true;
    };
    environment.etc = {
      "wireplumber/bluetooth.lua.d/51-bluez-config.lua".text = ''
        bluez_monitor.properties = {
          ["bluez5.enable-sbc-xq"] = true,
          ["bluez5.enable-msbc"] = true,
          ["bluez5.enable-hw-volume"] = true,
          ["bluez5.headset-roles"] = "[ hsp_hs hsp_ag hfp_hf hfp_ag ]"
        }
      '';
    };

    # Persist IWD/BT files
    elia.persist = {
      "bluetooth" = {
        path = "/var/lib/bluetooth";
        kind = "config";
      };
      "iwd" = {
        path = "/var/lib/iwd";
        kind = "config";
      };
    };
  };

  options.kit.wireless = lib.mkOption {
      type = lib.types.bool;
      description = "If this device supports WiFi and Bluetooth.";
      default = false;
    };
}
