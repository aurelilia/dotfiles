{ lib, ... }:
let
  url = "forge.catin.eu";
in
{
  services.forgejo = {
    enable = true;
    database.path = "/var/lib/forgejo/gitea.db";
    settings = {
      DEFAULT = {
        APP_NAME = "feline forge";
        RUN_MODE = "prod";
      };
      server = {
        DOMAIN = url;
        DISABLE_SSH = true;
        ROOT_URL = "https://${url}/";
      };

      avatar.PATH = "/var/lib/forgejo/avatars";
      session.PROVIDER = "file";
      security.PASSWORD_HASH_ALGO = "pbkdf2";
      service.ALLOW_ONLY_EXTERNAL_REGISTRATION = true;
      mailer.ENABLED = false;
    };
  };

  feline.persist.forgejo.path = "/var/lib/forgejo";
  feline.caddy.routes.${url}.port = 3000;
}
