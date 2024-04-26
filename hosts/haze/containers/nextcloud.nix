{ ... }:
let
  url = "cloud.feline.works";
  path = "/persist/data/nextcloud";
  port = 40013;
in
{
  feline.compose.nextcloud.services = {
    nextcloud = {
      image = "nextcloud:stable";
      environment.NEXTCLOUD_DATA_DIR = "/data";
      ports = [ "${toString port}:80" ];
      volumes = [
        "${path}/www:/var/www/html"
        "${path}/srv:/data"
      ];
    };
    postgres = {
      image = "postgres:14-alpine";
      container_name = "nextcloud-sql";
      environment = {
        POSTGRES_DB = "nextcloud";
        POSTGRES_PASSWORD = "WbU6!m4B$Z^&bZfS5eGa";
        POSTGRES_USER = "nextcloud";
      };
      volumes = [ "${path}/postgres:/var/lib/postgresql/data" ];
    };
  };

  feline.caddy.routes."${url}" = {
    extra = ''
      redir /.well-known/carddav /remote.php/dav 301
      redir /.well-known/caldav /remote.php/dav 301
    '';
    inherit port;
  };
}
