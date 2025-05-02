{ pkgs-unstable, ... }:
let
  url = "home.catin.eu";
  port = 51321;
in
{
  services.home-assistant = {
    enable = true;
    configDir = "/persist/data/hassio";
    package = pkgs-unstable.home-assistant;

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
        resources = [
          {
            type = "module";
            url = "/local/check-button-card.js";
          }
        ];
      };

      sensor = "!include sensor.yaml";
      "automation ui" = "!include automations.yaml";
      "scene ui" = "!include scenes.yaml";
    };

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
      "mqtt"
      "local_todo"
      "ping"
    ];

    extraPackages =
      python3Packages: with python3Packages; [
        aiogithubapi # HACS
        beautifulsoup4 # ha-bambulab
      ];
  };

  services.mosquitto = {
    enable = true;
    listeners = [
      {
        port = 1883;
        users = {
          "home-assistant" = {
            acl = [ "readwrite #" ];
            hashedPassword = "$7$101$pINRYODd4Oj1e2S3$X7eVtC1TG4aXcN4QKE+Bl+bUdHzWZu37Oxs/yML8kaNcuXn4kPrEZC8nity0K8RjvSG6OPuYPLSrGaf8UX6n5w==";
          };
        };
      }
    ];
  };
  networking.firewall.allowedTCPPorts = [ 1883 ];

  feline.caddy.routes."${url}" = {
    mode = "sso";
    inherit port;
  };
  feline.caddy.routes."valetudo.catin.eu" = {
    mode = "sso";
    host = "10.1.0.147:80";
  };
}
