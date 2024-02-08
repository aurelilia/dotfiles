{ ... }:
let
  url = "vaultwarden.elia.garden";
  port = 8222;
in
{
  services.vaultwarden = {
    enable = true;
    config = {
      DOMAIN = "https://${url}";
      SIGNUPS_ALLOWED = false;
      ROCKET_ADDRESS = "0.0.0.0";
      ROCKET_PORT = port;
    };
  };

  elia.persist.vaultwarden.path = "/var/lib/bitwarden_rs";
  elia.caddy.routes."${url}" = {
    mode = "sso";
    inherit port;
  };
}
