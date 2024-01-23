{ config, ... }:
let
  path = "/containers/mastodon";
  url = "social.elia.garden";
in {
  elia.containers.mastodon = {
    mounts."/var/lib/postgres/data" = {
      hostPath = "${path}/postgres";
      isReadOnly = false;
    };
    mounts."/var/lib/redis" = {
      hostPath = "${path}/redis";
      isReadOnly = false;
    };
    mounts."/run/env" = {
      hostPath = "${path}/env";
      isReadOnly = true;
    };

    config = { ... }: {
      networking.firewall.allowedTCPPorts = [ 55001 ];
      services.mastodon = {
        enable = true;
        localDomain = "elia.garden";
        streamingProcesses = 3;
        smtp.fromAddress = "none@example.com";

        extraEnvFiles = [ "/run/env" ];
        extraConfig = {
          WEB_DOMAIN = url;
          SINGLE_USER_MODE = "false";

          OIDC_ENABLED = "true";
          OIDC_DISPLAY_NAME = "Authentik";
          OIDC_DISCOVERY = "true";
          OIDC_ISSUER = "https://sso.elia.garden/application/o/mastodon/";
          OIDC_AUTH_ENDPOINT =
            "https://sso.elia.garden/application/o/authorize/";
          OIDC_SCOPE = "openid,profile,email";
          OIDC_UID_FIELD = "preferred_username";
          OIDC_REDIRECT_URI =
            "https://social.elia.garden/auth/auth/openid_connect/callback";
          OIDC_SECURITY_ASSUME_EMAIL_IS_VERIFIED = "true";
        };
      };
    };
  };

  elia.caddy.routes."${url}".extraConfig = ''
    reverse_proxy mastodon:55001
  '';
}
