{ config, ... }:
let web-port = "50051";
in {
  virtualisation.oci-containers.containers.metube = {
    image = "ghcr.io/alexta69/metube";
    autoStart = true;
    ports = [ "${web-port}:8081" ];
    volumes = [ "/media/.parent/music:/downloads" ];
  };

  elia.caddy.routes."tube.elia.garden" = {
    mode = "local";
    host = "localhost:${web-port}";
  };
}
