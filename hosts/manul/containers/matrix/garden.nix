{ ... }:
let
  path = "/persist/data/matrix/garden";
  url = "matrix.elia.garden";
  port = 51003;
in
{
  feline.compose.matrix.services = {
    mautrix-discord = {
      image = "dock.mau.dev/mautrix/discord";
      volumes = [ "${path}/discord_data:/data" ];
    };
    mautrix-whatsapp = {
      image = "dock.mau.dev/mautrix/whatsapp:latest";
      volumes = [ "${path}/whatsapp_data:/data" ];
    };
    mas = {
      image = "ghcr.io/element-hq/matrix-authentication-service:latest";
      volumes = [
        "${path}/mas:/data"
      ];
      ports = [ "127.0.0.1:${toString (port + 1)}:8080" ];
      environment."MAS_CONFIG" = "/data/config.yml";
    };
    synapse = {
      image = "matrixdotorg/synapse:latest";
      ports = [ "127.0.0.1:${toString port}:8008" ];
      volumes = [
        "${path}/data:/data"
        "${path}/media:/media"
      ];
    };
  };

  feline.caddy.routes."${url}" = {
    port = port;
    extra = ''
      @mas path_regexp ^/_matrix/client/(.*)/(login|logout|refresh)
      reverse_proxy @mas localhost:${toString (port + 1)}
    '';
  };
  feline.caddy.routes."mas.${url}".port = (port + 1);
  feline.postgres.databases = [ "synapse" ];
}
