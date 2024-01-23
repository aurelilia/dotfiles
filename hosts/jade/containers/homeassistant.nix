{ config, ... }:
let
  path = "/containers/homeassistant";
  port = "50045";
  port-esp = "50046";
in {
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
    "homeassistant.elia.garden".extraConfig = ''
      ${config.lib.caddy.snippets.sso-proxy}
      reverse_proxy host:${port}
    '';
    "ha-esphome.elia.garden".extraConfig = ''
      ${config.lib.caddy.snippets.local-net}
      reverse_proxy host:${port-esp}
    '';
  };
}
