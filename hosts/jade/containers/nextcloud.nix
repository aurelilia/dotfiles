{ config, pkgs, ... }:
let
  url = "cloud.elia.garden";
  path = "/containers/nextcloud";
in {
  # TODO
  /* elia.containers.nextcloud = {
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
       mounts."/var/lib/postgres" = {
         hostPath = "${path}/postgres";
         isReadOnly = false;
       };

       config = { ... }: {
         networking.firewall.allowedTCPPorts = [ 80 ];
         services.nextcloud = {
           enable = true;
           appstoreEnable = true;
           autoUpdateApps.enable = true;
           database.createLocally = true;

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
           };
         };

         services.postgresql.package = pkgs.postgresql_14;
       };
     };
  */

  elia.compose.nextcloud.compose = ''
    services:
      nextcloud:
        image: nextcloud:stable
        container_name: nextcloud
        volumes:
          - ${path}/www:/var/www/html
          - /srv/nextcloud:/data
        environment:
          NEXTCLOUD_DATA_DIR: /data
        ports:
          - "40013:80"
        restart: unless-stopped

      postgres:
        image: postgres:14-alpine
        restart: always
        container_name: nextcloud-sql
        environment:
          POSTGRES_PASSWORD: "WbU6!m4B$Z^&bZfS5eGa"
          POSTGRES_USER: nextcloud
          POSTGRES_DB: nextcloud
        volumes:
          - "${path}/postgres:/var/lib/postgresql/data"
  '';

  elia.caddy.routes."${url}" = {
    extra = ''
        redir /.well-known/carddav /remote.php/dav 301
        redir /.well-known/caldav /remote.php/dav 301
    '';
    host = "localhost:40013";
  };
}
