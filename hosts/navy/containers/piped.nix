{ ... }:
let
  base-dir = "/containers/piped";
  web-port = "13415";
in {
  # https://piped-docs.kavin.rocks/docs/self-hosting/#docker-compose-nginx-aio-script
  # Yes, the postgres password is bad. This runs in it's own network and is not
  # something I consider sensitive data whatsoever, so eh.
  elia.compose.piped = ''
    version: "3"

    services:
        pipedfrontend:
            image: 1337kavin/piped-frontend:latest
            restart: unless-stopped
            depends_on:
                - piped
            container_name: piped-frontend
            entrypoint: ash -c 'sed -i s/pipedapi.kavin.rocks/api.piped.elia.garden/g /usr/share/nginx/html/assets/* && /docker-entrypoint.sh && nginx -g "daemon off;"'
        piped-proxy:
            image: 1337kavin/piped-proxy:latest
            restart: unless-stopped
            environment:
                - UDS=1
            volumes:
                - piped-proxy:/app/socket
            container_name: piped-proxy
        piped:
            image: 1337kavin/piped:latest
            restart: unless-stopped
            volumes:
                - ${base-dir}/config/config.properties:/app/config.properties:ro
            depends_on:
                - postgres
            container_name: piped-backend
        nginx:
            image: nginx:mainline-alpine
            restart: unless-stopped
            volumes:
                - ${base-dir}/config/nginx.conf:/etc/nginx/nginx.conf:ro
                - ${base-dir}/config/pipedapi.conf:/etc/nginx/conf.d/pipedapi.conf:ro
                - ${base-dir}/config/pipedproxy.conf:/etc/nginx/conf.d/pipedproxy.conf:ro
                - ${base-dir}/config/pipedfrontend.conf:/etc/nginx/conf.d/pipedfrontend.conf:ro
                - ${base-dir}/config/ytproxy.conf:/etc/nginx/snippets/ytproxy.conf:ro
                - piped-proxy:/var/run/ytproxy
            container_name: piped-nginx
            depends_on:
                - piped
                - piped-proxy
                - pipedfrontend
            ports:
                - "${web-port}:80"
        postgres:
            image: postgres:15
            restart: unless-stopped
            volumes:
                - ${base-dir}/data/db:/var/lib/postgresql/data
            environment:
                - POSTGRES_DB=piped
                - POSTGRES_USER=piped
                - POSTGRES_PASSWORD=changeme
            container_name: piped-postgres
    volumes:
        piped-proxy: null
  '';

  elia.caddy.extra = ''
    piped.elia.garden, api.piped.elia.garden, proxy.piped.elia.garden {
        reverse_proxy http://navy:${web-port}
    }
  '';
}
