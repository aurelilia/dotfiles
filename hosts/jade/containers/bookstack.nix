{ ... }:
let
  url = "books.elia.garden";
in
{
  # TODO
  /* age.secrets.bookstack-key = {
       file = ../../../secrets/jade/bookstack-key.age;
       owner = "999";
     };

     elia.containers.bookstack = {
       mounts."/var/lib/bookstack" = {
         hostPath = "/containers/bookstack/data";
         isReadOnly = false;
       };
       mounts."/var/lib/mysql" = {
         hostPath = "/containers/bookstack/sql";
         isReadOnly = false;
       };
       mounts."/run/key".hostPath = config.age.secrets.bookstack-key.path;

       config = { ... }: {
         networking.firewall.allowedTCPPorts = [ 80 ];

         services.bookstack = {
           enable = true;
           hostname = "bookstack";
           appURL = "https://${url}";
           appKeyFile = "/run/key";

           database = {
             user = "bookstack";
             name = "bookstackapp";
             createLocally = true;
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
  */

  elia.compose.bookstack.services = {
    bookstack = {
      image = "lscr.io/linuxserver/bookstack";
      depends_on = [ "bookstack_db" ];
      environment = [
        "PUID=1000"
        "PGID=1000"
        "APP_URL=https://${url}"
        "DB_HOST=bookstack_db"
        "DB_PORT=3306"
        "DB_USER=bookstack"
        "DB_PASS=somerandompasswordidfk"
        "DB_DATABASE=bookstackapp"
      ];
      ports = [ "50100:80" ];
      volumes = [ "/containers/bookstack/data:/config" ];
    };
    bookstack_db = {
      image = "lscr.io/linuxserver/mariadb";
      environment = [
        "PUID=1000"
        "PGID=1000"
        "MYSQL_ROOT_PASSWORD=somerandompasswordidfk"
        "TZ=Europe/Brussels"
        "MYSQL_DATABASE=bookstackapp"
        "MYSQL_USER=bookstack"
        "MYSQL_PASSWORD=somerandompasswordidfk"
      ];
      volumes = [ "/containers/bookstack/sql:/config" ];
    };
  }

  ;
  elia.caddy.routes."${url}".port = 50100;
}
