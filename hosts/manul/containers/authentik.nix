{ ... }:
let
  path = "/persist/data/authentik";
  image = "ghcr.io/goauthentik/server";
  version = "2025.10";
  port = 50042;
in
{
  feline.compose.authentik.services = {
    authentik-server = {
      image = "${image}:${version}";
      command = "server";
      env_file = [ "${path}/.env" ];
      environment = {
        AUTHENTIK_POSTGRESQL__HOST = "host.runc.internal";
        AUTHENTIK_POSTGRESQL__NAME = "authentik";
        AUTHENTIK_POSTGRESQL__USER = "authentik";
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
      env_file = [ "${path}/.env" ];

      environment = {
        AUTHENTIK_POSTGRESQL__HOST = "host.runc.internal";
        AUTHENTIK_POSTGRESQL__NAME = "authentik";
        AUTHENTIK_POSTGRESQL__USER = "authentik";
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
    routes."sso.elia.garden".redir = "auth.catin.eu";
    routes."auth.catin.eu" = {
      inherit port;
      extra = ''
        	header /static/dist/custom.css Content-Type text/css
          respond /static/dist/custom.css `${builtins.readFile ../../../branding/auth.css}`
          redir /static/dist/assets/images/flow_background.jpg https://branding.catin.eu/background.jpg
      '';
      monitoringStatusCode = "302";
    };
  };
  feline.postgres.databases = [ "authentik" ];
}
