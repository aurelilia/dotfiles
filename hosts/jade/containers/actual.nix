{ config, ... }:
let web-port = "50041";
in {
  virtualisation.oci-containers.containers.actual = {
    image = "actualbudget/actual-server:latest-alpine";
    autoStart = true;
    ports = [ "${web-port}:5006" ];
    volumes = [ "/containers/actual:/data" ];
  };

  elia.caddy.routes."actual.elia.garden" = {
    mode = "sso";
    host = "localhost:${web-port}";
  };
}
