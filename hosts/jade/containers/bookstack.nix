{ config, pkgs, ... }: {
  age.secrets.bookstack-db.file = ../../../secrets/jade/bookstack-key.age;
  age.secrets.bookstack-key.file = ../../../secrets/jade/bookstack-db.age;

  elia.containers.bookstack = {
    mounts."/var/lib/bookstack" = {
      hostPath = "/containers/bookstack/data";
      isReadOnly = false;
    };
    mounts."/var/lib/mysql" = {
      hostPath = "/containers/bookstack/sql";
      isReadOnly = false;
    };
    mounts."/run/db".hostPath = config.age.secrets.bookstack-db.path;
    mounts."/run/key".hostPath = config.age.secrets.bookstack-key.path;

    config = { ... }: {
      networking.firewall.allowedTCPPorts = [ 80 ];

      services.mysql = {
        enable = true;
        package = pkgs.mariadb;
      };

      services.bookstack = {
        enable = true;
        hostname = "books.elia.garden";
        appURL = "https://books.elia.garden";
        appKeyFile = "/run/key";

        database = {
          user = "bookstack";
          passwordFile = "/run/db";
          name = "bookstackapp";
        };

        config = {
          AUTH_METHOD = "saml2";
          AUTH_AUTO_INITIATE = true;
          SAML2_NAME = "authentik";
          SAML2_EMAIL_ATTRIBUTE = "email";
          SAML2_EXTERNAL_ID_ATTRIBUTE = "uid";
          SAML2_USER_TO_GROUPS = true;
          SAML2_GROUP_ATTRIBUTE = "http://schemas.xmlsoap.org/claims/Group";
          SAML2_DISPLAY_NAME_ATTRIBUTES =
            "http://schemas.microsoft.com/ws/2008/06/identity/claims/windowsaccountname";
          SAML2_IDP_ENTITYID =
            "https://sso.elia.garden/api/v3/providers/saml/2/metadata/?download";
          SAML2_AUTOLOAD_METADATA = true;
        };
      };
    };
  };

  elia.caddy.routes."books.elia.garden".extraConfig = ''
    reverse_proxy bookstack:80
  '';
}
