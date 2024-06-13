{ pkgs, conduwuit, ... }:
let
  url = "matrix.ehir.art";
  port = 51147;

  cfg.settings = {
    global = {
      server_name = "ehir.art";
      inherit port;
      database_path = "/var/lib/matrix-conduit-ehira";
      database_backend = "rocksdb";
      max_request_size = 20000000;
      trusted_servers = [ "matrix.org" ];
      ip_range_denylist = [ ];
      allow_registration = false;
    };
  };

  format = pkgs.formats.toml { };
  configFile = format.generate "conduit.toml" cfg.settings;
in
{
  systemd.services.conduit-ehira = {
    description = "Conduit Matrix Server - ehir.art";
    documentation = [ "https://gitlab.com/famedly/conduit/" ];
    wantedBy = [ "multi-user.target" ];
    environment.CONDUIT_CONFIG = configFile;
    serviceConfig = {
      DynamicUser = true;
      User = "conduit-ehira";
      LockPersonality = true;
      MemoryDenyWriteExecute = true;
      ProtectClock = true;
      ProtectControlGroups = true;
      ProtectHostname = true;
      ProtectKernelLogs = true;
      ProtectKernelModules = true;
      ProtectKernelTunables = true;
      PrivateDevices = true;
      PrivateMounts = true;
      PrivateUsers = true;
      RestrictAddressFamilies = [
        "AF_INET"
        "AF_INET6"
      ];
      RestrictNamespaces = true;
      RestrictRealtime = true;
      SystemCallArchitectures = "native";
      SystemCallFilter = [
        "@system-service"
        "~@privileged"
      ];
      StateDirectory = "matrix-conduit-ehira";
      StateDirectoryMode = "0700";
      ExecStart = "${conduwuit.default}/bin/conduit";
      Restart = "on-failure";
      RestartSec = 10;
      StartLimitBurst = 5;
      UMask = "077";
    };
  };

  feline.persist."matrix/ehira".path = "/var/lib/private/matrix-conduit-ehira";
  feline.caddy.routes."${url}".port = port;
}
