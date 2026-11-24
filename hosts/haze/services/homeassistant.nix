{
  config,
  lib,
  pkgs-unstable,
  ...
}:
let
  url = "home.catin.eu";
  port = 51321;
in
{
  catppuccin.home-assistant.enable = false; # ???
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
      "wyoming"
      "matter"
      "otbr"
      "thread"
      "wled"
      "luci"
      "music_assistant"
    ];

    extraPackages =
      python3Packages: with python3Packages; [
        aiogithubapi # HACS
      ];
  };

  services.openthread-border-router = {
    enable = true;
    backboneInterfaces = [ "lan" ];
    openFirewall = true;

    radio = {
      device = "/dev/serial/by-id/usb-SMLIGHT_SMLIGHT_SLZB-07_f40b527b9373ed1181c968eefdf7b791-if00-port0";
      baudRate = 921600;
      flowControl = true;
    };

    rest.listenAddress = "::";
    web = {
      enable = true;
      listenAddress = "::";
      listenPort = 58082;
    };
  };
  systemd.services.matterjs-server = {
    description = "Matter Controller WebSocket server based on Matter.js";
    documentation = [ "https://github.com/matter-js/matterjs-server" ];

    wantedBy = [ "multi-user.target" ];
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];

    path = [ pkgs-unstable.iputils ];

    serviceConfig = {
      ExecStart = lib.escapeShellArgs ([
        (lib.getExe pkgs-unstable.matterjs-server)
        "--storage-path=%S/matterjs-server"
        "--listen-address=0.0.0.0"
        "--port=51322"
        "--production-mode"
        "--ble-proxy"
      ]);

      StateDirectory = "matterjs-server";
      StateDirectoryMode = "0700";

      DynamicUser = true;

      # Required for interaction with hci devices and bluetooth sockets
      LockPersonality = true;
      NoNewPrivileges = true;
      PrivateTmp = true;
      PrivateUsers = true; # Prevents gaining capabilities in the host namespace
      ProcSubset = "pid";
      ProtectClock = true;
      ProtectControlGroups = true;
      ProtectHome = true;
      ProtectHostname = true;
      ProtectKernelLogs = true;
      ProtectKernelModules = true;
      ProtectKernelTunables = true;
      ProtectProc = "invisible";
      ProtectSystem = "strict";
      RestrictAddressFamilies = [
        "AF_INET"
        "AF_INET6"
        "AF_NETLINK"
        "AF_UNIX"
      ];
      RestrictNamespaces = true;
      RestrictRealtime = true;
      RestrictSUIDSGID = true;
      SystemCallArchitectures = "native";
      SystemCallFilter = [
        "@system-service"
        "~@privileged"

        # ping from iputils (used for pinging nodes) needs this to drop privileges
        "capset"
        "setuid"
      ];
      UMask = "0077";
    };
  };

  services.music-assistant = {
    enable = true;
    package = pkgs-unstable.music-assistant;
    openFirewall = true;
    providers = [
      "hass"
      "snapcast"
      "opensubsonic"
      "subsonic_scrobble"
      "ytmusic"
      "genius_lyrics"
      "lrclib"
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
  networking.firewall.allowedTCPPorts = [ 1883 8095 ];

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

  # Do this weirdly and separately like this since STP requires passing a secret
  # in its cmdline, so we just have a script that contains a docker run command.
  systemd.services.docker-speech-to-phrase = {
    description = "Docker container for Speech-to-Phrase";

    serviceConfig.Restart = "always";
    path = [ config.virtualisation.docker.package ];
    script = "/persist/data/hassio/stp.sh";

    after = [
      "docker.service"
      "docker.socket"
    ];
    wants = [ "network-online.target" ];
  };

  feline.caddy.routes."${url}" = {
    local-only = true;
    inherit port;
    monitoringEnable = false;
  };
  feline.caddy.routes."thread.catin.eu" = {
    local-only = true;
    port = 8081;
    monitoringEnable = false;
  };
  feline.caddy.routes."home-music.catin.eu" = {
    local-only = true;
    port = 8095;
    monitoringEnable = false;
  };
}
