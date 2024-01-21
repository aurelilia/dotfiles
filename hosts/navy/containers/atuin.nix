{ config, ... }: {
  elia.containers.atuin = {
    mounts."/var/lib/postgresql" = {
      hostPath = "/containers/atuin/db";
      isReadOnly = false;
    };

    config = { ... }: {
      services.atuin = {
        enable = true;
        host = "0.0.0.0";
        openFirewall = true;
        openRegistration = false;
      };

      services.postgresql.enable = true;
    };
  };

  elia.caddy.routes."atuin.elia.garden".extraConfig = ''
    ${config.lib.caddy.snippets.no-robots}
    reverse_proxy atuin:8888
  '';
}
