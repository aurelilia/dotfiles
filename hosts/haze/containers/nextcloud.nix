{ ... }:
let
  url = "cloud.catin.eu";
  path = "/persist/data/nextcloud";
  port = 40013;
in
{
  feline.containers.nextcloud = {
    image = "nextcloud:stable";
    environment.NEXTCLOUD_DATA_DIR = "/data";
    ports = [ "127.0.0.1:${toString port}:80" ];
    volumes = [
      "${path}/www:/var/www/html"
      "${path}/srv:/data"
    ];
  };

  feline.caddy.routes."${url}" = {
    extra = ''
      redir /.well-known/carddav /remote.php/dav 301
      redir /.well-known/caldav /remote.php/dav 301
    '';
    inherit port;
  };
  feline.postgres.databases = [ "nextcloud" ];
}
