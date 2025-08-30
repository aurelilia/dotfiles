{ pkgs, ... }:
let
  path = "/persist/data/immich";
in
{
  feline.compose.immich.services = {
    redis = {
      image = "redis:6.2-alpine";
      container_name = "immich-redis";
      volumes = [ "${path}/redis:/data" ];
    };

    immich-server = {
      image = "ghcr.io/immich-app/immich-server:release";
      depends_on = [
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

  feline.caddy.routes."photos.catin.eu".port = 2283;

  feline.postgres.databases = [ "immich" ];
  services.postgresql = {
    extensions = [
      pkgs.postgresql16Packages.pgvecto-rs
      pkgs-unstable.postgresql16Packages.vectorchord
    ];
    settings = {
      shared_preload_libraries = "vectors.so, vchord.so";
    };
  };
}
