{ config, ... }:
let
  url = "dash.monitor.catin.eu";
in
{
  services.grafana = {
    enable = true;
    dataDir = "/persist/data/grafana";
    settings = {
      security.admin_user = "leela";
      server = {
        domain = url;
        http_addr = "127.0.0.1";
        http_port = 2342;
      };
    };
  };

  feline.caddy.routes.${url}.port = config.services.grafana.settings.server.http_port;
}
