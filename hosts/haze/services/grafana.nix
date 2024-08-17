{ config, ... }:
let
  url = "dash.feline.works";
in
{
  services.grafana = {
    enable = true;
    domain = url;
    addr = "127.0.0.1";
    dataDir = "/persist/data/grafana";
    settings = {
      security.admin_user = "leela";
      server.http_port = 2342;
    };
  };

  feline.caddy.routes.${url}.port = config.services.grafana.port;
}
