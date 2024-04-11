{ ... }:
let
  path = "/persist/data/vikunja";
in
{
  services.vikunja = {
    enable = true;
    frontendScheme = "https";
    frontendHostname = "vikunja.elia.garden";
    database.path = "${path}/vikunja.db";
    environmentFiles = [ "/persist/secrets/vikunja.env" ];

    settings.auth = {
      local.enabled = false;
      openid = {
        enabled = true;
        redirecturl = "https://vikunja.elia.garden/auth/openid/";
        providers = [
          {
            name = "authentik";
            authurl = "https://sso.elia.garden/application/o/vikunja/";
            logouturl = "https://sso.elia.garden/application/o/vikunja/end-session";
            clientid = "fngbfnhgeftbnegtfht";
            clientsecret = ''''${SSO_SECRET}'';
          }
        ];
      };
    };
  };

  # This is a bit terrible but we can't set OIDC secrets otherwise
  systemd.services.vikunja.serviceConfig.ReadWriteDirectories = [ path ];
  environment.etc."vikunja/config.yaml".enable = false;
  systemd.tmpfiles.rules = [ "L /etc/vikunja/config.yaml - - - - /persist/secrets/vikunja.yaml" ];

  elia.caddy.routes."vikunja.elia.garden" = {
    no-robots = true;
    port = 3456;
  };
}
