{ ... }:
let
  path = "/persist/data/joplin";
  port = 50143;
  url = "notes.feline.works";
in
{
  elia.compose.joplin.services = {
    joplin = {
      image = "joplin/server:latest";
      depends_on = [ "db" ];
      environment = [
        "APP_PORT=22300"
        "APP_BASE_URL=https://${url}"
        "DB_CLIENT=pg"
        "POSTGRES_PASSWORD=postgres"
        "POSTGRES_DATABASE=joplin"
        "POSTGRES_USER=postgres"
        "POSTGRES_PORT=5432"
        "POSTGRES_HOST=db"
        "MAILER_ENABLED=0"
      ];
      ports = [ "${toString port}:22300" ];
    };
    db = {
      image = "postgres:15";
      container_name = "joplin-postgres";
      environment = [
        "POSTGRES_PASSWORD=postgres"
        "POSTGRES_USER=postgres"
        "POSTGRES_DB=joplin"
      ];
      volumes = [ "${path}/db:/var/lib/postgresql/data" ];
    };
  };

  elia.caddy.routes."${url}".port = port;
}
