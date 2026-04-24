{ ... }:
let
  port = 50143;
  url = "notes.catin.eu";
in
{
  feline.containers.joplin = {
    image = "joplin/server:latest";
    environmentFiles = [ "/persist/secrets/joplin.env" ];
    environment = {
      APP_PORT = "22300";
      APP_BASE_URL = "https://${url}";
      DB_CLIENT = "pg";
      POSTGRES_DATABASE = "joplin";
      POSTGRES_USER = "joplin";
      POSTGRES_PORT = "5432";
      POSTGRES_HOST = "host.runc.internal";
      MAILER_ENABLED = "0";
    };
    ports = [ "${toString port}:22300" ];
  };

  feline.caddy.routes."${url}".port = port;
  feline.postgres.databases = [ "joplin" ];
}
