{ ... }:
let
  path = "/containers/matrix-dendrite";
  url = "matrix.louane.xyz";
  port = 51001;
in
{
  elia.compose.matrix-louane.services = {
    dendrite = {
      image = "matrixdotorg/dendrite-monolith:latest";
      ports = [ "${toString port}:8008" ];
      volumes = [
        "${path}/config:/etc/dendrite"
        "${path}/media:/var/dendrite/media"
      ];
    };
    dendrite-postgres = {
      image = "postgres:14-alpine";
      environment.POSTGRES_USER = "dendrite";
      volumes = [
        "${path}/postgres_create_db.sh:/docker-entrypoint-initdb.d/20-create_db.sh"
        "${path}/postgres:/var/lib/postgresql/data"
      ];
    };
  };

  elia.caddy.routes."${url}".port = port;
}
