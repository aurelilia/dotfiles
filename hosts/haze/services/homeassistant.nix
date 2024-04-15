{ pkgs, ... }:
let
  url = "home.feline.works";
  port = 51321;
in
{
  services.home-assistant = {
    enable = true;
    configDir = "/persist/data/hassio";

    config = {
      default_config = { };
      homeassistant.time_zone = "Europe/Brussels";
      http = {
        server_host = "127.0.0.1";
        server_port = port;
        use_x_forwarded_for = true;
        trusted_proxies = [
          "127.0.0.1"
          "::1"
        ];
      };

      lovelace = {
        mode = "storage";
        resources = [ ];
      };

      sensor = "!include sensor.yaml";
      "automation ui" = "!include automations.yaml";
      "scene ui" = "!include scenes.yaml";
    };

    package = (
      pkgs.home-assistant.override {
        # https://github.com/NixOS/nixpkgs/blob/master/pkgs/servers/home-assistant/component-packages.nix
        extraComponents = [
          "default_config"
          "esphome"
          "met"
          "zha"
          "speedtestdotnet"
          "adguard"
          "jellyfin"
          "rmvtransport"
        ];
      }
    );
  };

  elia.caddy.routes."${url}" = {
    mode = "sso";
    inherit port;
  };
}
