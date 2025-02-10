{ ... }:
let
  path = "/persist/data/authentik";
  image = "ghcr.io/goauthentik/server";
  version = "2024.12.3";
  port = 50042;
in
{
  feline.compose.authentik.services = {
    postgresql = {
      image = "docker.io/library/postgres:15-alpine";
      container_name = "authentik-postgres";
      env_file = [ "${path}/.env" ];
      environment = {
        POSTGRES_DB = "authentik";
        POSTGRES_USER = "authentik";
      };
      volumes = [ "${path}/database:/var/lib/postgresql/data" ];
    };
    redis = {
      image = "docker.io/library/redis:alpine";
      container_name = "authentik-redis";
      command = "--save 60 1 --loglevel warning";
      volumes = [ "${path}/redis:/data" ];
    };
    authentik-server = {
      image = "${image}:${version}";
      command = "server";
      depends_on = [
        "postgresql"
        "redis"
      ];
      env_file = [ "${path}/.env" ];
      environment = {
        AUTHENTIK_POSTGRESQL__HOST = "postgresql";
        AUTHENTIK_POSTGRESQL__NAME = "authentik";
        AUTHENTIK_POSTGRESQL__USER = "authentik";
        AUTHENTIK_REDIS__HOST = "redis";
      };
      ports = [ "127.0.0.1:${toString port}:9000" ];
      volumes = [
        "${path}/media:/media"
        "${path}/custom-templates:/templates"
      ];
    };
    authentik-worker = {
      image = "${image}:${version}";
      command = "worker";
      depends_on = [
        "postgresql"
        "redis"
      ];
      env_file = [ "${path}/.env" ];

      environment = {
        AUTHENTIK_POSTGRESQL__HOST = "postgresql";
        AUTHENTIK_POSTGRESQL__NAME = "authentik";
        AUTHENTIK_POSTGRESQL__USER = "authentik";
        AUTHENTIK_REDIS__HOST = "redis";
      };
      user = "root";
      volumes = [
        "/var/run/docker.sock:/var/run/docker.sock"
        "${path}/media:/media"
        "${path}/certs:/certs"
        "${path}/custom-templates:/templates"
      ];
    };
  };

  feline.caddy = {
    sso = "http://localhost:${toString port}";
    routes."sso.elia.garden" = {
      aliases = [ "auth.feline.works" "auth.kitten.works" ];
      redir = "auth.catin.eu";
    };
    routes."auth.catin.eu" = {
      inherit port;
      extra = ''
        	header /static/dist/custom.css Content-Type text/css
          respond /static/dist/custom.css `${builtins.readFile ../../../branding/auth.css}`
          redir /static/dist/assets/images/flow_background.jpg https://branding.catin.eu/background.jpg
      '';
    };
  };
}
