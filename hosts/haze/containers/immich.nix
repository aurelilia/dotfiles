{ ... }:
let
  path = "/persist/data/immich";
in
{
  elia.compose.immich.services = {
    database = {
      image = "registry.hub.docker.com/tensorchord/pgvecto-rs:pg14-v0.2.0";
      container_name = "immich-postgres";
      env_file = [ "${path}/env" ];
      volumes = [ "${path}/postgres:/var/lib/postgresql/data" ];
    };
    redis = {
      image = "redis:6.2-alpine";
      container_name = "immich-redis";
      volumes = [ "${path}/redis:/data" ];
    };

    immich-server = {
      image = "ghcr.io/immich-app/immich-server:release";
      command = [
        "start.sh"
        "immich"
      ];
      depends_on = [
        "database"
        "redis"
      ];
      env_file = [ "${path}/env" ];
      ports = [ "2283:3001" ];
      volumes = [
        "/media/personal/immich:/usr/src/app/upload"
        "/etc/localtime:/etc/localtime:ro"
      ];
    };
    immich-microservices = {
      image = "ghcr.io/immich-app/immich-server:release";
      command = [
        "start.sh"
        "microservices"
      ];
      depends_on = [
        "database"
        "redis"
      ];
      env_file = [ "${path}/env" ];
      volumes = [
        "/media/personal/immich:/usr/src/app/upload"
        "/etc/localtime:/etc/localtime:ro"
      ];
    };
    immich-machine-learning = {
      image = "ghcr.io/immich-app/immich-machine-learning:release";
      env_file = [ "${path}/env" ];
      volumes = [ "/var/lib/immich-cache:/cache" ];
    };
  };

  elia.caddy.routes."photos.kitten.works" = {
    no-robots = true;
    port = 2283;
  };
}
