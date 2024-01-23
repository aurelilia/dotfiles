{ config, ... }:
let
  url = "cloud.elia.garden";
  path = "/containers/nextcloud";
in {
  elia.containers.nextcloud = {
    mounts."/var/lib/nextcloud" = {
      hostPath = "${path}/www";
      isReadOnly = false;
    };
    mounts."/run/secrets" = {
      hostPath = "/persist/secrets/nextcloud";
      isReadOnly = true;
    };
    mounts."/data" = {
      hostPath = "/srv/nextcloud";
      isReadOnly = false;
    };
    mounts."/var/lib/postgres/data" = {
      hostPath = "${path}/postgres";
      isReadOnly = false;
    };

    config = { ... }: {
      networking.firewall.allowedTCPPorts = [ 80 ];
      services.nextcloud = {
        enable = true;
        appstoreEnable = true;
        autoUpdateApps.enable = true;

        hostName = url;
        datadir = "/data";
        https = true;
        secretFile = "/run/secrets/secrets.json";

        config = {
          adminpassFile = "/run/secrets/adminpass";
          trustedProxies = [ "10.0.0.0/8" ];
          defaultPhoneRegion = "DE";

          dbtype = "pgsql";
          dbuser = "nextcloud";
          dbname = "nextcloud";
          dbtableprefix = "oc_";
          dbpassFile = "/run/secrets/dbpass";
        };
      };
    };
  };

  elia.caddy.routes."${url}".extraConfig = ''
        redir /.well-known/carddav /remote.php/dav 301
        redir /.well-known/caldav /remote.php/dav 301
    	  reverse_proxy nextcloud:80
  '';
}
