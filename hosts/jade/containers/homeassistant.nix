{ ... }:
let
  path = "/containers/homeassistant";
  port = 50045;
in
{
  elia.compose.homeassistant.services.homeassistant = {
    image = "ghcr.io/home-assistant/home-assistant:stable";
    devices = [ "/dev/ttyACM0:/dev/ttyACM0" ];
    environment = [ "TZ=Europe/Brussels" ];
    ports = [ "${toString port}:8123" ];
    volumes = [ "${path}/config:/config" ];
  };

  elia.caddy.routes."homeassistant.elia.garden" = {
    mode = "sso";
    inherit port;
  };
}
