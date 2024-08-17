{ lib, config, ... }:
{
  config.services.prometheus.exporters = lib.mkIf config.feline.prometheus.enable {
    node = {
      enable = true;
      enabledCollectors = [ "systemd" ];
      port = 59421;
    };
  };

  options.feline.prometheus.enable = lib.mkEnableOption "Prometheus exporter";
}
