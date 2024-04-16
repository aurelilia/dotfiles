# https://github.com/NixOS/nixpkgs/blob/nixos-unstable/nixos/modules/services/web-apps/vikunja.nix
{
  pkgs-unstable,
  lib,
  config,
  ...
}:

with lib;

let
  pkgs = pkgs-unstable;
  cfg = config.backports.vikunja;
  format = pkgs.formats.yaml { };
  configFile = format.generate "config.yaml" cfg.settings;
  useMysql = cfg.database.type == "mysql";
  usePostgresql = cfg.database.type == "postgres";
in
{
  options.backports.vikunja = with lib; {
    enable = mkEnableOption (lib.mdDoc "vikunja service");
    package = mkPackageOption pkgs "vikunja" { };
    environmentFiles = mkOption {
      type = types.listOf types.path;
      default = [ ];
      description = lib.mdDoc ''
        List of environment files set in the vikunja systemd service.
        For example passwords should be set in one of these files.
      '';
    };
    frontendScheme = mkOption {
      type = types.enum [
        "http"
        "https"
      ];
      description = lib.mdDoc ''
        Whether the site is available via http or https.
      '';
    };
    frontendHostname = mkOption {
      type = types.str;
      description = lib.mdDoc "The Hostname under which the frontend is running.";
    };
    port = mkOption {
      type = types.port;
      default = 3456;
      description = lib.mdDoc "The TCP port exposed by the API.";
    };

    settings = mkOption {
      type = format.type;
      default = { };
      description = lib.mdDoc ''
        Vikunja configuration. Refer to
        <https://vikunja.io/docs/config-options/>
        for details on supported values.
      '';
    };
    database = {
      type = mkOption {
        type = types.enum [
          "sqlite"
          "mysql"
          "postgres"
        ];
        example = "postgres";
        default = "sqlite";
        description = lib.mdDoc "Database engine to use.";
      };
      host = mkOption {
        type = types.str;
        default = "localhost";
        description = lib.mdDoc "Database host address. Can also be a socket.";
      };
      user = mkOption {
        type = types.str;
        default = "vikunja";
        description = lib.mdDoc "Database user.";
      };
      database = mkOption {
        type = types.str;
        default = "vikunja";
        description = lib.mdDoc "Database name.";
      };
      path = mkOption {
        type = types.str;
        default = "/var/lib/vikunja/vikunja.db";
        description = lib.mdDoc "Path to the sqlite3 database file.";
      };
    };
  };
  config = lib.mkIf cfg.enable {
    backports.vikunja.settings = {
      database = {
        inherit (cfg.database)
          type
          host
          user
          database
          path
          ;
      };
      service = {
        interface = ":${toString cfg.port}";
        frontendurl = "${cfg.frontendScheme}://${cfg.frontendHostname}/";
      };
      files = {
        basepath = "/var/lib/vikunja/files";
      };
    };

    systemd.services.vikunja = {
      description = "vikunja";
      after = [
        "network.target"
      ] ++ lib.optional usePostgresql "postgresql.service" ++ lib.optional useMysql "mysql.service";
      wantedBy = [ "multi-user.target" ];
      path = [ cfg.package ];
      restartTriggers = [ configFile ];

      serviceConfig = {
        Type = "simple";
        DynamicUser = true;
        StateDirectory = "vikunja";
        ExecStart = "${cfg.package}/bin/vikunja";
        Restart = "always";
        EnvironmentFile = cfg.environmentFiles;
      };
    };

    environment.etc."vikunja/config.yaml".source = configFile;

    environment.systemPackages = [
      cfg.package # for admin `vikunja` CLI
    ];
  };
}
