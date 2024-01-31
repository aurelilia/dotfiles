{ config, ... }:
{
  elia.containers.atuin = {
    mounts."/var/lib/postgresql" = {
      hostPath = "/containers/atuin/postgres";
      isReadOnly = false;
    };

    config =
      { ... }:
      {
        services.atuin = {
          enable = true;
          host = "0.0.0.0";
          openFirewall = true;
          openRegistration = false;
        };

        services.postgresql.enable = true;
      };
  };

  elia.caddy.routes."atuin.elia.garden" = {
    no-robots = true;
    host = "atuin:8888";
  };
}
