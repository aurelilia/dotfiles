# TODO: Move to NixOS module with 24.05
{ ... }:
let
  path = "/persist/data/scrutiny";
  port = 53042;
in
{
  feline.compose.scrutiny.services = {
    influx = {
      image = "influxdb:2.2";
      container_name = "scrutiny-influx";
      volumes = [ "${path}/influx:/var/lib/influxdb2" ];
    };

    scrutiny = {
      image = "ghcr.io/analogj/scrutiny:master-web";
      container_name = "scrutiny-web";
      ports = [ "${toString port}:8080" ];
      volumes = [ "${path}/scrutiny:/opt/scrutiny/config" ];
    };
  };

  networking.firewall.allowedTCPPorts = [ port ];
  feline.caddy.routes."smart.theria.nl" = {
    inherit port;
    mode = "local";
  };
}
