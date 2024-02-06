{
  config,
  lib,
  pkgs,
  ...
}:
{
  config = lib.mkIf config.elia.mobile {
    environment.systemPackages = [ pkgs.brightnessctl ];

    # Power management
    services.logind = {
      powerKey = "ignore";
      hibernateKey = "ignore";
      suspendKey = "ignore";
      suspendKeyLongPress = "ignore";
      lidSwitch = "ignore";
      lidSwitchExternalPower = "ignore";
    };
    services.upower.enable = true;
    services.auto-cpufreq.enable = true;

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

    # Persist IWD/BT files and upower data
    elia.persist = {
      "bluetooth" = {
        path = "/var/lib/bluetooth";
        kind = "config";
      };
      "iwd" = {
        path = "/var/lib/iwd";
        kind = "config";
      };
      "upower".path = "/var/lib/upower";
    };
  };
}
