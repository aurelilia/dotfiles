{ config, ... }: {
  elia.containers.vaultwarden = {
    mounts."/var/lib/bitwarden_rs" = {
      hostPath = "/containers/vaultwarden/data";
      isReadOnly = false;
    };

    config = { ... }: {
      networking.firewall.allowedTCPPorts = [ 8222 ];
      services.vaultwarden = {
        enable = true;
        config = {
          DOMAIN = "https://vaultwarden.elia.garden";
          SIGNUPS_ALLOWED = false;
          ROCKET_PORT = 8222;
        };
      };
    };
  };

  elia.caddy.routes."vaultwarden.elia.garden".extraConfig = ''
    ${config.lib.caddy.snippets.local-net}
    reverse_proxy vaultwarden:8222
  '';
}
