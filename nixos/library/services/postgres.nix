{ config, lib, pkgs, ... }:
let
  cfg = config.feline.postgres;
in
{
  config.services.postgresql = lib.mkIf (cfg.users != [ ]) {
    enable = true;
    package = pkgs.postgresql_16;
    dataDir = "/persist/data/postgres/16";

    ensureDatabases = cfg.users;
    ensureUsers = map (name: {
      inherit name;
      ensureClauses.login = true;
      ensureDBOwnership = true;
    }) cfg.users;
  };

  options.feline.postgres = {
    users = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      description = "Users to create, together with databases.";
      default = [ ];
    };
  };
}
