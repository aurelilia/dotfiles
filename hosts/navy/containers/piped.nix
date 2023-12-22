{...}:
let
  caddySnippets = import ../../../fleet/mixins/caddy.nix;
  path = "/containers/piped";
  port = "15216";
  defaults = {
    autoStart = true;
    extraOptions = [ "--network=piped" ];
  };
in {
  virtualisation.oci-containers.containers = {
    # These configs were translated from:
    # https://piped-docs.kavin.rocks/docs/self-hosting/#docker-compose-nginx-aio-script
    caddy.dependsOn = [ "piped-nginx" ];

    piped-frontend = defaults // {
      image = "1337kavin/piped-frontend:latest";
      entrypoint = "ash -c 'sed -i s/pipedapi.kavin.rocks/api.piped.elia.garden/g /usr/share/nginx/html/assets/* && /docker-entrypoint.sh && nginx -g \"daemon off;\"'";
    };
    piped-proxy = defaults // {
      image = "1337kavin/piped-proxy:latest";
      environment.UDS = "1";
      volumes = [ "piped-proxy:/app/socket" ];
    };
    piped-backend = defaults // {
      image = "1337kavin/piped:latest";
      dependsOn = [ "piped-postgres" ];
      volumes = [ "${path}/config/config.properties:/app/config.properties:ro" ];
    };
    piped-nginx = defaults // {
      image = "nginx:mainline-alpine";
      dependsOn = [
        "piped-backend"
        "piped-proxy"
        "piped-frontend"
      ];
      ports = [ "${port}:80" ];
      volumes = [ 
        "${path}/config/nginx.conf:/etc/nginx/nginx.conf:ro"
        "${path}/config/pipedapi.conf:/etc/nginx/conf.d/pipedapi.conf:ro"
        "${path}/config/pipedproxy.conf:/etc/nginx/conf.d/pipedproxy.conf:ro"
        "${path}/config/pipedfrontend.conf:/etc/nginx/conf.d/pipedfrontend.conf:ro"
        "${path}/config/ytproxy.conf:/etc/nginx/snippets/ytproxy.conf:ro"
        "piped-proxy:/var/run/ytproxy"
      ];
    };
    piped-postgres = defaults // {
      image = "postgres:15";
      volumes = [ 
        "${path}/data/db:/var/lib/postgresql/data"
      ];
      environment = {
        POSTGRES_DB = "piped";
        POSTGRES_USER = "piped";
        # Not actually used for prod.
        POSTGRES_PASSWORD = "changeme";
      };
    };
  };

  system.activationScripts.dockernet.text = ''
    docker network create -d bridge piped || true
  '';

  environment.etc."caddy/Caddyfile".text = ''
    piped.elia.garden, api.piped.elia.garden, proxy.piped.elia.garden {
        reverse_proxy http://navy:${port}
    }
  '';
}

