{ lib, ... }:
let
  url = "vault.feline.works";
  port = 8222;
  dir = "/persist/data/vaultwarden";
in
{
  services.vaultwarden = {
    enable = true;
    config = {
      DOMAIN = "https://${url}";
      SIGNUPS_ALLOWED = false;
      ROCKET_PORT = port;
      DATA_FOLDER = dir;
    };
  };

  elia.caddy.routes."${url}" = {
    mode = "sso";
    inherit port;
  };
}
