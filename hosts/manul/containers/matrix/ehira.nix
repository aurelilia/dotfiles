{ ... }:
let
  path = "/persist/data/matrix/ehira";
  url = "matrix.ehir.art";
  port = 51001;
in
{
  feline.containers.synapse-ehira = {
    image = "matrixdotorg/synapse:latest";
    ports = [ "127.0.0.1:${toString port}:8008" ];
    volumes = [
      "${path}/data:/data"
      "${path}/media:/media"
    ];
  };

  feline.caddy.routes."${url}".port = port;
  feline.postgres.users = [ "synapse_ehira" ];
}
