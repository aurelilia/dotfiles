{ ... }:
let
  port = 53042;
in
{
  services.scrutiny = {
    enable = true;
    openFirewall = true;
    settings.web.listen.port = port;
  };

  feline = {
    persist = {
      scrutiny.path = "/var/lib/private/scrutiny";
      influxdb2.path = "/var/lib/influxdb2";
    };

    caddy.routes."smart.monitor.catin.eu" = {
      inherit port;
      mode = "local";
    };
  };
}
