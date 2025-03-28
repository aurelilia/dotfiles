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
    mautrix-signal = {
      image = "dock.mau.dev/mautrix/signal:latest";
      volumes = [ "${path}/signal/data:/data" ];
    };
    mautrix-whatsapp = {
      image = "dock.mau.dev/mautrix/whatsapp:latest";
      volumes = [ "${path}/whatsapp_data:/data" ];
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

  feline.caddy.routes."${url}".port = port;
  feline.postgres.databases = [ "synapse" ];
}
