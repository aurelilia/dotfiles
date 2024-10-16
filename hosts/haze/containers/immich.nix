{ ... }:
let
  path = "/persist/data/immich";
in
{
  feline.compose.immich.services = {
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
      depends_on = [
        "database"
        "redis"
      ];
      env_file = [ "${path}/env" ];
      ports = [ "127.0.0.1:2283:2283" ];
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

  feline.caddy.routes."photos.kitten.works".port = 2283;
}
