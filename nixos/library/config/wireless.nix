{ config, lib, ... }:
{
  config = lib.mkIf config.feline.wireless.enable {
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
    feline.persist = {
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

  options.feline.wireless.enable = lib.mkEnableOption "WiFi and Bluetooth";
}
