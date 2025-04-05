{ pkgs-unstable, ... }:
let
  port = 60032;
in
{
  services.mealie = {
    inherit port;
    enable = true;
    package = pkgs-unstable.mealie;
    listenAddress = "127.0.0.1";
    credentialsFile = "/persist/secrets/mealie.env";

    settings = {
      OIDC_AUTH_ENABLED = "True";
      OIDC_PROVIDER_NAME = "feline systems";
      OIDC_REMEMBER_ME = "True";
      OIDC_ADMIN_GROUP = "admins";
    };
  };

  feline.persist."mealie".path = "/var/lib/private/mealie";
  feline.postgres.users = [ "mealie" ];
  feline.caddy.routes."recipe.catin.eu".port = port;
}
