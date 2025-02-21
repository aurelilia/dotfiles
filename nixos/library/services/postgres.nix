{ config, lib, pkgs, ... }:
let
  cfg = config.feline.postgres;
in
{
  config = lib.mkIf ((cfg.users ++ cfg.databases) != [ ]) {
    services.postgresql = {
      enable = true;
      package = pkgs.postgresql_16;
      dataDir = "/persist/data/postgres/16";

      enableTCPIP = true;
      authentication = pkgs.lib.mkOverride 10 ''
        #...
        #type database DBuser origin-address auth-method
        local all       all                    trust
        host  all       all     all            scram-sha-256
        host  all       all     all            scram-sha-256
      '';
      settings = {
        password_encryption = "scram-sha-256";
      };

      ensureDatabases = cfg.users ++ cfg.databases;
      ensureUsers = map (name: {
        inherit name;
        ensureClauses.login = true;
        ensureDBOwnership = true;
      }) cfg.users;
    };

    networking.firewall.allowedTCPPorts = [ config.services.postgresql.settings.port ];
  };

  options.feline.postgres = {
    users = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      description = "Users to create, together with databases.";
      default = [ ];
    };
    databases = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      description = "Databases to create.";
      default = [ ];
    };
  };
}
