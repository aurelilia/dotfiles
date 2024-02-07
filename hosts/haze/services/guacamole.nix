# https://github.com/NixOS/nixpkgs/issues/278067
# Thank you!
{ config, pkgs, ... }:
let
  app = "guacamole";
  guacVer = config.services.guacamole-client.package.version;
  pgsqlVer = "42.7.1"; # https://jdbc.postgresql.org/download/#latest-versions

  pgsqlDriverSrc = pkgs.fetchurl {
    url = "https://jdbc.postgresql.org/download/postgresql-${pgsqlVer}.jar";
    sha256 = "sha256-SbupwyANT2Suc5A9Vs4b0Jx0UX3+May0R0VQa0/O3lM=";
  };

  pgsqlExtension = pkgs.stdenv.mkDerivation {
    name = "guacamole-auth-jdbc-postgresql-${guacVer}";
    src = pkgs.fetchurl {
      url = "https://dlcdn.apache.org/guacamole/${guacVer}/binary/guacamole-auth-jdbc-${guacVer}.tar.gz";
      sha256 = "sha256-7Tuncc5Io4oOVvApkTuAUSSdvr/dMv/tvOLfDbEyJH8=";
    };
    phases = "unpackPhase installPhase";
    unpackPhase = ''
      tar -xzf $src
    '';
    installPhase = ''
      mkdir -p $out
      cp -r guacamole-auth-jdbc-${guacVer}/postgresql/* $out
    '';
  };

  oidcExtension = pkgs.stdenv.mkDerivation {
    name = "guacamole-auth-sso-openid-${guacVer}";
    src = pkgs.fetchurl {
      url = "https://dlcdn.apache.org/guacamole/${guacVer}/binary/guacamole-auth-sso-${guacVer}.tar.gz";
      sha256 = "sha256-pEVl8vvkQQ2D0UHsgSZ9YH+FsZgEY570wxn/KKBL0pQ=";
    };
    phases = "unpackPhase installPhase";
    unpackPhase = ''
      tar -xzf $src
    '';
    installPhase = ''
      mkdir -p $out
      cp guacamole-auth-sso-${guacVer}/openid/guacamole-auth-sso-openid-${guacVer}.jar $out
    '';
  };

  psql = "${pkgs.postgresql}/bin/psql";
  cat = "${pkgs.coreutils-full}/bin/cat";
in
{
  services.guacamole-server = {
    enable = true;
    host = "0.0.0.0";
    extraEnvironment.ENVIRONMENT = "production";
  };

  services.guacamole-client = {
    enable = true;
    enableWebserver = true;
    package = pkgs.guacamole-client;
    settings = {
      guacd-hostname = "127.0.0.1";
      guacd-port = 4822;
      domain = "elia.garden";
      extension-priority = "*, openid";
      postgresql-hostname = "localhost";
      postgresql-database = app;
      postgresql-username = app;
      postgresql-password = "";
      postgresql-auto-create-accounts = true;
      openid-authorization-endpoint = "https://sso.elia.garden/application/o/authorize/";
      openid-client-id = "guacamole";
      openid-issuer = "https://sso.elia.garden/application/o/guacamole/";
      openid-jwks-endpoint = "https://sso.elia.garden/application/o/guacamole/jwks/";
      openid-redirect-uri = "https://guacamole.elia.garden/guacamole/";
    };
  };

  environment.etc."guacamole/extensions/guacamole-auth-sso-openid-${guacVer}.jar".source = "${oidcExtension}/guacamole-auth-sso-openid-${guacVer}.jar";
  environment.etc."guacamole/lib/postgresql-${pgsqlVer}.jar".source = pgsqlDriverSrc;
  environment.etc."guacamole/extensions/guacamole-auth-jdbc-postgresql-${guacVer}.jar".source = "${pgsqlExtension}/guacamole-auth-jdbc-postgresql-${guacVer}.jar";

  systemd.services."guacamole-pgsql-schema-import" = {
    enable = true;
    requires = [ "postgresql.service" ];
    after = [ "postgresql.service" ];
    wantedBy = [
      "tomcat.service"
      "multi-user.target"
    ];
    script = ''
      echo "[guacamole-bootstrapper] Info: checking if database '${app}' exists but is empty..."
      output=$(${psql} -U ${app} -c "\dt" 2>&1)
      if [[ $output == "Did not find any relations." ]]; then
        echo "[guacamole-bootstrapper] Info: installing guacamole postgres database schema..."
        ${cat} ${pgsqlExtension}/schema/*.sql | ${psql} -U ${app} -d ${app} -f -
      fi
    '';
  };

  elia.persist.postgres.path = "/var/lib/postgresql";
  services.postgresql = {
    enable = true;
    enableTCPIP = true;
    port = 5432;
    authentication = pkgs.lib.mkOverride 10 ''
      #type database  DBuser  auth-method
      local all       all     trust
      #type database DBuser origin-address auth-method
      host  all      all    127.0.0.1/32   trust
    '';
    ensureDatabases = [ app ];
    ensureUsers = [
      {
        name = app;
        ensureDBOwnership = true; # same name db
      }
    ];
  };

  systemd.services."tomcat" = {
    requires = [ "postgresql.service" ];
    after = [ "postgresql.service" ];
  };
}
