{ ... }:
let
  path = "/containers/mastodon";
  url = "social.elia.garden";
in
{
  # TODO
  /* elia.containers.mastodon = {
       mounts."/var/lib/postgres" = {
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
         networking.firewall.allowedTCPPorts = [ 80 ];

         services.mastodon = {
           enable = true;
           #package = pkgs.mastodon.overrideDerivation (oldAttrs: {
           #  name = "mastodon-glitch-soc-git";
           #  src = pkgs.fetchgit {
           #    url = "https://github.com/glitch-soc/mastodon.git";
           #    rev = "main";
           #    hash = "sha256-80308d384a9f914c6500961f3e0fa5b4444fd30d";
           #  };
           #});

           localDomain = "mastodon";
           streamingProcesses = 3;
           smtp.fromAddress = "none@example.com";
           configureNginx = true;

           extraEnvFiles = [ "/run/env" ];
           extraConfig = {
             WEB_DOMAIN = url;
             SINGLE_USER_MODE = "false";
             LOCAL_DOMAIN = "social.elia.garden";

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

         services.nginx.virtualHosts."mastodon" = {
           forceSSL = false;
           enableACME = false;
         };
       };
     };
  */

  elia.compose.mastodon.services = {
    db = {
      image = "postgres:14-alpine";
      container_name = "mastodon-postgres";
      environment = [ "POSTGRES_HOST_AUTH_METHOD=trust" ];
      shm_size = "256mb";
      volumes = [ "${path}/postgres:/var/lib/postgresql/data" ];
    };
    redis = {
      image = "redis:7-alpine";
      container_name = "mastodon-redis";
      volumes = [ "${path}/redis:/data" ];
    };
    sidekiq = {
      image = "ghcr.io/mastodon/mastodon:latest";
      container_name = "mastodon-sidekiq";
      command = "bundle exec sidekiq";
      depends_on = [
        "db"
        "redis"
      ];
      env_file = "${path}/.env.production";
      volumes = [ "${path}/public/system:/mastodon/public/system" ];
    };
    mastodon-stream = {
      image = "ghcr.io/mastodon/mastodon:latest";
      command = "node ${path}/streaming";
      depends_on = [
        "db"
        "redis"
      ];
      env_file = "${path}/.env.production";
      ports = [ "40001:4000" ];
    };
    mastodon-web = {
      image = "ghcr.io/mastodon/mastodon:latest";
      command = "bundle exec puma -C config/puma.rb";
      depends_on = [
        "db"
        "redis"
      ];
      env_file = "${path}/.env.production";
      ports = [ "30001:3000" ];
      volumes = [ "${path}/public/system:/mastodon/public/system" ];
    };
  };

  elia.caddy.routes."${url}" = {
    extra = "reverse_proxy /api/v1/streaming* host:40001";
    port = 30001;
  };
}
