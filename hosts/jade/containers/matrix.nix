{ config, ... }:
let
  path = "/containers/matrix";
  url = "matrix.elia.garden";
  port = "51003";
in {
  # TODO
  elia.compose.matrix = {
    env = "${path}/env";
    compose = ''
      services:
        synapse:
          image: matrixdotorg/synapse:latest
          container_name: synapse
          volumes:
            - ${path}/data:/data
            - ${path}/media:/media
          ports:
            - "${port}:8008"
          restart: unless-stopped

        postgresql:
          image: postgres:14-alpine
          restart: always
          container_name: synapse-postgres
          environment:
            POSTGRES_PASSWORD: ''${PG_PASS:?database password required}
            POSTGRES_USER: synapse
            POSTGRES_DB: synapse
          volumes:
              - "${path}/postgres:/var/lib/postgresql/data"

        mautrix-discord:
          image: dock.mau.dev/mautrix/discord
          container_name: mautrix-discord
          volumes:
            - ${path}/discord_data:/data
          restart: unless-stopped

        mautrix-whatsapp:
          image: dock.mau.dev/mautrix/whatsapp:latest
          container_name: mautrix-whatsapp
          volumes:
            - ${path}/whatsapp_data:/data
          restart: unless-stopped

        mautrix-signal:
          image: dock.mau.dev/mautrix/signal:latest
          container_name: mautrix-signal
          volumes:
            - ${path}/signal/data:/data
            - ${path}/signal/signald:/signald
          restart: unless-stopped
    '';
  };

  elia.caddy.routes."${url}".host = "localhost:${port}";
}
