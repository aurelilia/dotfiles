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
    config = null;

    # https://github.com/NixOS/nixpkgs/blob/master/pkgs/servers/home-assistant/component-packages.nix
    extraComponents = [
      "default_config"
      "esphome"
      "met"
      "zha"
      "jellyfin"
      "mqtt"
      "local_todo"
      "ping"
      "caldav"
      "mealie"
      "wyoming"
      "ollama"
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

  services.ollama = {
    enable = true;
    host = "0.0.0.0";
  };
  services.wyoming = {
    faster-whisper.servers.small = {
      enable = true;
      uri = "tcp://0.0.0.0:27001";
      model = "small-int8";
      language = "en";
    };
    piper.servers.en = {
      enable = true;
      uri = "tcp://0.0.0.0:27101";
      voice = "en_GB-jenny_dioco-medium";
    };
    openwakeword = {
      enable = true;
      uri = "tcp://0.0.0.0:27201";
    };
  };

  feline.caddy.routes."${url}" = {
    mode = "sso";
    inherit port;
  };
  feline.caddy.routes."valetudo.catin.eu" = {
    mode = "sso";
    host = "10.1.0.147:80";
  };
}
