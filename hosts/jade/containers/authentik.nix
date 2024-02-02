{ ... }:
let
  path = "/containers/authentik";
  image = "ghcr.io/goauthentik/server";
  version = "2023.10.6";
  port = "50042";
in
{
  elia.compose.authentik = {
    env = "/containers/authentik/.env";
    compose = ''
      version: "3.4"

      services:
        postgresql:
          image: docker.io/library/postgres:12-alpine
          restart: unless-stopped
          volumes:
            - ${path}/database:/var/lib/postgresql/data
          environment:
            POSTGRES_PASSWORD: ''${PG_PASS:?database password required}
            POSTGRES_USER: authentik
            POSTGRES_DB: authentik
          container_name: authentik-postgres

        redis:
          image: docker.io/library/redis:alpine
          command: --save 60 1 --loglevel warning
          restart: unless-stopped
          container_name: authentik-redis
          volumes:
            - ${path}/redis:/data

        server:
          image: ${image}:${version}
          restart: unless-stopped
          command: server
          environment:
            AUTHENTIK_REDIS__HOST: redis
            AUTHENTIK_POSTGRESQL__HOST: postgresql
            AUTHENTIK_POSTGRESQL__USER: authentik
            AUTHENTIK_POSTGRESQL__NAME: authentik
            AUTHENTIK_POSTGRESQL__PASSWORD: ''${PG_PASS}
            AUTHENTIK_SECRET_KEY: ''${AUTHENTIK_SECRET_KEY}
          volumes:
            - ${path}/media:/media
            - ${path}/custom-templates:/templates
          depends_on:
            - postgresql
            - redis
          ports:
            - "${port}:9000"
          container_name: authentik-server

        worker:
          image: ${image}:${version}
          restart: unless-stopped
          command: worker
          environment:
            AUTHENTIK_REDIS__HOST: redis
            AUTHENTIK_POSTGRESQL__HOST: postgresql
            AUTHENTIK_POSTGRESQL__USER: authentik
            AUTHENTIK_POSTGRESQL__NAME: authentik
            AUTHENTIK_POSTGRESQL__PASSWORD: ''${PG_PASS}
            AUTHENTIK_SECRET_KEY: ''${AUTHENTIK_SECRET_KEY}
          # `user: root` and the docker socket volume are optional.
          # See more for the docker socket integration here:
          # https://goauthentik.io/docs/outposts/integrations/docker
          # Removing `user: root` also prevents the worker from fixing the permissions
          # on the mounted folders, so when removing this make sure the folders have the correct UID/GID
          # (1000:1000 by default)
          user: root
          volumes:
            - /var/run/docker.sock:/var/run/docker.sock
            - ${path}/media:/media
            - ${path}/certs:/certs
            - ${path}/custom-templates:/templates
          depends_on:
            - postgresql
            - redis
          container_name: authentik-worker
    '';
  };

  elia.caddy = {
    sso = "http://localhost:${port}";
    routes."sso.elia.garden".host = "localhost:${port}";
  };
}
