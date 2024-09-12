{ ... }:
let
  data = "/persist/data/darkflame";
  client = "/media/media/DLU";
  port = 8704;
in
{
  feline.compose.darkflame.services = {
    db = {
      container_name = "darkflame-mariadb";
      environment = [
        "MARIADB_RANDOM_ROOT_PASSWORD=1"
        "MARIADB_USER=darkflame"
        "MARIADB_DATABASE=darkflame"
      ];
      image = "mariadb:latest";
      volumes = [ "${data}/db:/var/lib/mysql" ];
      env_file = [ "${data}/.env" ];
    };
    server = {
      depends_on = [ "db" ];
      environment = [
        "CLIENT_LOCATION=/app/luclient"
        "DLU_CONFIG_DIR=/app/configs"
        "DUMP_FOLDER=/app/dump"
        "MYSQL_HOST=db"
        "MYSQL_DATABASE=darkflame"
        "MYSQL_USERNAME=darkflame"
        "EXTERNAL_IP=haze"
        "CLIENT_NET_VERSION=171022"
      ];
      env_file = [ "${data}/.env" ];
      image = "ghcr.io/darkflameuniverse/darkflameserver:latest";
      ports = [
        "1001:1001/udp"
        "2005:2005/udp"
        "3000-3300:3000-3300/udp"
      ];
      volumes = [
        "${data}/config:/app/configs/"
        "${client}:/app/luclient:ro"
        "${data}/res:/app/resServer/"
        "${data}/dump:/app/dump/"
        "${data}/logs:/app/logs/"
      ];
    };
    web = {
      depends_on = [
        "db"
        "server"
      ];
      environment = [
        "CLIENT_LOCATION=/app/luclient/"
        "CACHE_LOCATION=/app/cache/"
        "CD_SQLITE_LOCATION=/app/cdclient/"
        "USER_ENABLE_REGISTER=1"
      ];
      env_file = [ "${data}/.env" ];
      image = "ghcr.io/darkflameuniverse/nexusdashboard:latest";
      ports = [ "${toString port}:8000" ];
      volumes = [
        "${client}:/app/luclient:ro"
        "${data}/web/cache:/app/cache"
        "${data}/res:/app/cdclient:ro"
        "${data}/web/logs:/logs"
      ];
    };
  };

  feline.caddy.routes."darkflame.feline.works" = {
    mode = "sso";
    inherit port;
  };
}
