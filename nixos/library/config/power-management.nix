{ config, lib, ... }:
{
  config = lib.mkIf config.feline.power-management.enable {
    services.logind.settings.Login = {
      HandlePowerKey = "ignore";
      HandleLidSwitch = "suspend-then-hibernate";
      HandleLidSwitchExternalPower = "ignore";
    };
    systemd.sleep.settings.Sleep = {
      HibernateDelaySec = "12h";
      HibernateOnACPower = false;
    };
    services.upower.enable = true;
    services.auto-cpufreq.enable = true;

    # Persist upower data
    feline.persist."upower".path = "/var/lib/upower";
  };

  options.feline.power-management.enable = lib.mkEnableOption "Power management";
}
