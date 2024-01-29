{ config, ... }:
let url = "vaultwarden.elia.garden";
in {
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
          DOMAIN = "https://${url}";
          SIGNUPS_ALLOWED = false;
          ROCKET_ADDRESS = "0.0.0.0";
          ROCKET_PORT = 8222;
        };
      };
    };
  };

  elia.caddy.routes."${url}".extraConfig = ''
    ${config.lib.caddy.snippets.local-net}
    reverse_proxy vaultwarden:8222
  '';
}
