{ ... }:
let
  base-dir = "/containers/piped";
  url = "piped.elia.garden";
  port = 13415;
in
{
  # https://piped-docs.kavin.rocks/docs/self-hosting/#docker-compose-nginx-aio-script
  # Yes, the postgres password is bad. This runs in it's own network and is not
  # something I consider sensitive data whatsoever, so eh.
  elia.compose.piped.compose = {
    services = {
      piped-nginx = {
        image = "nginx:mainline-alpine";
        depends_on = [
          "piped"
          "piped-proxy"
          "piped-frontend"
        ];
        ports = [ "${toString port}:80" ];
        volumes = [
          "${base-dir}/config/nginx.conf:/etc/nginx/nginx.conf:ro"
          "${base-dir}/config/pipedapi.conf:/etc/nginx/conf.d/pipedapi.conf:ro"
          "${base-dir}/config/pipedproxy.conf:/etc/nginx/conf.d/pipedproxy.conf:ro"
          "${base-dir}/config/pipedfrontend.conf:/etc/nginx/conf.d/pipedfrontend.conf:ro"
          "${base-dir}/config/ytproxy.conf:/etc/nginx/snippets/ytproxy.conf:ro"
          "piped-proxy:/var/run/ytproxy"
        ];
      };
      piped = {
        image = "1337kavin/piped:latest";
        depends_on = [ "piped-postgres" ];
        volumes = [ "${base-dir}/config/config.properties:/app/config.properties:ro" ];
      };
      piped-proxy = {
        image = "1337kavin/piped-proxy:latest";
        environment = [ "UDS=1" ];
        volumes = [ "piped-proxy:/app/socket" ];
      };
      piped-frontend = {
        image = "1337kavin/piped-frontend:latest";
        depends_on = [ "piped" ];
        entrypoint = "ash -c 'sed -i s/pipedapi.kavin.rocks/api.piped.elia.garden/g /usr/share/nginx/html/assets/* && /docker-entrypoint.sh && nginx -g \"daemon off;\"'";
      };
      piped-postgres = {
        image = "postgres:15-alpine";
        environment = [
          "POSTGRES_DB=piped"
          "POSTGRES_USER=piped"
          "POSTGRES_PASSWORD=changeme"
        ];
        volumes = [ "${base-dir}/data/db:/var/lib/postgresql/data" ];
      };
    };
    volumes.piped-proxy = null;
  };

  elia.caddy.routes."${url}" = {
    aliases = [
      "api.${url}"
      "proxy.${url}"
    ];
    inherit port;
  };
}
