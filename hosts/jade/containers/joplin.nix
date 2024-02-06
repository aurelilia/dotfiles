{ ... }:
let
  path = "/containers/joplin";
  port = "50143";
  url = "joplin.elia.garden";
in
{
  elia.compose.joplin.compose = ''
    version: '3'

    services:
        db:
            image: postgres:15
            volumes:
                - ${path}/db:/var/lib/postgresql/data
            ports:
                - "5432:5432"
            restart: unless-stopped
            environment:
                - POSTGRES_PASSWORD=postgres
                - POSTGRES_USER=postgres
                - POSTGRES_DB=joplin
        app:
            image: joplin/server:latest
            depends_on:
                - db
            ports:
                - "${port}:22300"
            restart: unless-stopped
            environment:
                - APP_PORT=22300
                - APP_BASE_URL=https://${url}
                - DB_CLIENT=pg
                - POSTGRES_PASSWORD=postgres
                - POSTGRES_DATABASE=joplin
                - POSTGRES_USER=postgres
                - POSTGRES_PORT=5432
                - POSTGRES_HOST=db
                - MAILER_ENABLED=0
  '';

  elia.caddy.routes."${url}".host = "localhost:${port}";
}
