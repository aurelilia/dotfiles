{ ... }:
let
  port = 50041;
in
{
  virtualisation.oci-containers.containers.actual = {
    image = "actualbudget/actual-server:latest-alpine";
    autoStart = true;
    ports = [ "${toString port}:5006" ];
    volumes = [ "/persist/data/actual:/data" ];
  };

  feline.caddy.routes."budget.feline.works" = {
    mode = "sso";
    inherit port;
  };
}
