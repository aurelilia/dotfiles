{ ... }:
let
  port = 50041;
in
{
  feline.containers.actual = {
    image = "actualbudget/actual-server:latest-alpine";
    ports = [ "127.0.0.1:${toString port}:5006" ];
    volumes = [ "/persist/data/actual:/data" ];
  };

  feline.caddy.routes."budget.catin.eu" = {
    mode = "sso";
    inherit port;
  };
}
