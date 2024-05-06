{ config, lib, ... }:
{
  config = lib.mkIf config.feline.power-management.enable {
    services.logind = {
      powerKey = "ignore";
      lidSwitch = "suspend-then-hibernate";
      lidSwitchExternalPower = "ignore";
    };
    systemd.sleep.extraConfig = "HibernateDelaySec=1200";
    services.upower.enable = true;
    services.auto-cpufreq.enable = true;

    # Persist upower data
    feline.persist."upower".path = "/var/lib/upower";
  };

  options.feline.power-management.enable = lib.mkEnableOption "Power management";
}
