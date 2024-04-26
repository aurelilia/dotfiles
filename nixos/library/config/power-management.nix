{
  config,
  lib,
  ...
}:
{
  config = lib.mkIf config.elia.mobile {
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

    # Persist upower data
    elia.persist."upower".path = "/var/lib/upower";
  };

  options.kit.power-management = lib.mkOption {
    type = lib.types.bool;
    description = "If this device has a battery and power management should be enabled.";
    default = false;
  };
}
