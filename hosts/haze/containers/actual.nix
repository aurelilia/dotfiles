{ ... }:
let
  port = 50041;
in
{
  virtualisation.oci-containers.containers.actual = {
    image = "actualbudget/actual-server:latest-alpine";
    autoStart = true;
    ports = [ "127.0.0.1:${toString port}:5006" ];
    volumes = [ "/persist/data/actual:/data" ];
  };

  feline.caddy.routes."budget.catin.eu" = {
    mode = "sso";
    inherit port;
  };
}
