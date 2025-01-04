{ ... }:
let
  path = "/persist/data/dawarich";
in
{
  feline.compose.dawarich.services = {
    dawarich_app = {
      command = [ "bin/dev" ];
      container_name = "dawarich_app";
      depends_on = [
        "dawarich_db"
        "dawarich_redis"
      ];
      entrypoint = "dev-entrypoint.sh";
      environment = {
        APPLICATION_HOST = "track.feline.works";
        APPLICATION_HOSTS = "track.feline.works,localhost";
        APPLICATION_PROTOCOL = "http";
        DATABASE_HOST = "dawarich_db";
        DATABASE_NAME = "dawarich_production";
        DATABASE_PASSWORD = "password";
        DATABASE_USERNAME = "postgres";
        DISTANCE_UNIT = "km";
        MIN_MINUTES_SPENT_IN_CITY = 60;
        PHOTON_API_HOST = "photon.komoot.io";
        PHOTON_API_USE_HTTPS = true;
        RAILS_ENV = "production";
        REDIS_URL = "redis://dawarich_redis:6379/0";
        TIME_ZONE = "Europe/Brussels";
      };
      image = "freikin/dawarich:latest";
      ports = [ "127.0.0.1:29121:3000" ];
      volumes = [
        "${path}/gem_cache:/usr/local/bundle/gems_app"
        "${path}/public:/var/app/public"
        "${path}/watched:/var/app/tmp/imports/watched"
      ];
    };
    dawarich_db = {
      container_name = "dawarich_db";
      environment = {
        POSTGRES_PASSWORD = "password";
        POSTGRES_USER = "postgres";
      };
      image = "postgres:14.2-alpine";
      volumes = [
        "${path}/db_data:/var/lib/postgresql/data"
        "${path}/shared_data:/var/shared"
      ];
    };
    dawarich_redis = {
      command = "redis-server";
      container_name = "dawarich_redis";
      image = "redis:7.0-alpine";
      volumes = [ "${path}/shared_data:/var/shared/redis" ];
    };
    dawarich_sidekiq = {
      command = [ "sidekiq" ];
      container_name = "dawarich_sidekiq";
      depends_on = [
        "dawarich_app"
        "dawarich_db"
        "dawarich_redis"
      ];
      entrypoint = "dev-entrypoint.sh";
      environment = {
        APPLICATION_HOST = "track.feline.works";
        APPLICATION_HOSTS = "track.feline.works,localhost";
        APPLICATION_PROTOCOL = "http";
        BACKGROUND_PROCESSING_CONCURRENCY = 10;
        DATABASE_HOST = "dawarich_db";
        DATABASE_NAME = "dawarich_production";
        DATABASE_PASSWORD = "password";
        DATABASE_USERNAME = "postgres";
        DISTANCE_UNIT = "km";
        PHOTON_API_HOST = "photon.komoot.io";
        PHOTON_API_USE_HTTPS = true;
        RAILS_ENV = "production";
        REDIS_URL = "redis://dawarich_redis:6379/0";
      };
      image = "freikin/dawarich:latest";
      volumes = [
        "${path}/gem_cache:/usr/local/bundle/gems_sidekiq"
        "${path}/public:/var/app/public"
        "${path}/watched:/var/app/tmp/imports/watched"
      ];
    };
  };

  feline.caddy.routes."track.feline.works" = {
    port = 29121;
    mode = "sso";
  };
}
