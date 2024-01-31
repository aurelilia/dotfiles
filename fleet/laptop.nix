{
  name,
  nodes,
  config,
  lib,
  pkgs,
  ...
}:
{
  imports = [ ./workstation.nix ];
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
  systemd.tmpfiles.rules = [
    "L /var/lib/bluetooth - - - - /persist/config/bluetooth"
    "L /var/lib/iwd - - - - /persist/config/iwd"
    "L /var/lib/upower - - - - /persist/data/upower"
  ];
}
