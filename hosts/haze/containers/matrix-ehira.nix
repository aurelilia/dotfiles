{ ... }:
let
  path = "/persist/data/matrix/ehira-dendrite";
  url = "matrix.ehir.art";
  port = 51001;
in
{
  feline.containers.dendrite = {
    image = "matrixdotorg/dendrite-monolith:latest";
    ports = [ "127.0.0.1:${toString port}:8008" ];
    volumes = [
      "${path}/config:/etc/dendrite"
      "${path}/media:/var/dendrite/media"
    ];
  };

  feline.caddy.routes."${url}".port = port;
  feline.postgres.databases = [ "dendrite" ];
}
