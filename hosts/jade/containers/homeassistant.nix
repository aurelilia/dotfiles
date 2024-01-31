{ config, ... }:
let
  path = "/containers/homeassistant";
  port = "50045";
  port-esp = "50046";
in
{
  elia.compose.homeassistant.compose = ''
    services:
      homeassistant:
        image: ghcr.io/home-assistant/home-assistant:stable
        container_name: homeassistant
        volumes:
          - ${path}/config:/config
        devices:
          - /dev/ttyACM0:/dev/ttyACM0
        ports:
          - "${port}:8123"
        environment:
          - TZ=Europe/Brussels
        restart: unless-stopped

      esphome:
        image: esphome/esphome
        container_name: homeassistant-esphome
        volumes:
          - ${path}/esphome:/config
          - /etc/localtime:/etc/localtime:ro
        ports:
          - "${port-esp}:6052"
        environment:
          - ESPHOME_DASHBOARD_USE_PING=true
        restart: unless-stopped
  '';

  elia.caddy.routes = {
    "homeassistant.elia.garden" = {
      mode = "sso";
      host = "localhost:${port}";
    };
    "ha-esphome.elia.garden" = {
      mode = "local";
      host = "localhost:${port-esp}";
    };
  };
}
