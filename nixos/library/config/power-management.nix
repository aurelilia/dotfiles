{ config, lib, ... }:
{
  config = lib.mkIf config.feline.power-management.enable {
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
    feline.persist."upower".path = "/var/lib/upower";
  };

  options.feline.power-management.enable = lib.mkEnableOption "Power management";
}
