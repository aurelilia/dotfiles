{ ... }:
let
  path = "/persist/data/matrix/ehira-dendrite";
  url = "matrix.ehir.art";
  port = 51001;
in
{
  feline.compose.matrix-louane.services = {
    dendrite = {
      image = "matrixdotorg/dendrite-monolith:latest";
      ports = [ "127.0.0.1:${toString port}:8008" ];
      volumes = [
        "${path}/config:/etc/dendrite"
        "${path}/media:/var/dendrite/media"
      ];
    };
    dendrite-postgres = {
      image = "postgres:14-alpine";
      env_file = [ "${path}/env" ];
      environment = {
        POSTGRES_USER = "dendrite";
        POSTGRES_DB = "dendrite";
      };
      volumes = [
        "${path}/postgres_create_db.sh:/docker-entrypoint-initdb.d/20-create_db.sh"
        "${path}/postgres:/var/lib/postgresql/data"
      ];
    };
  };

  feline.caddy.routes."${url}".port = port;
}
