{ ... }:
let
  path = "/containers/ffsync";
  port = "50075";
  url = "sync.elia.garden";
in
{
  # I would use services.firefox-syncserver here, but it sadly forces
  # MySQL and is therefore incompatible with historical data I still have.
  elia.compose.ffsync.compose = ''
    services:
      ffsync:
        image: mozilla/syncserver
        container_name: ffsync
        environment:
          TZ: Europe/Berlin
          SYNCSERVER_PUBLIC_URL: https://${url}
          SYNCSERVER_FORCE_WSGI_ENVIRON: "true"
          SYNCSERVER_SQLURI: 'sqlite:////data/syncserver.db'
          SYNCSERVER_BATCH_UPLOAD_ENABLED: 'true'
        env_file:
          - "${path}/env"
        volumes:
          - "${path}/data:/data"
        ports:
          - "${port}:5000"
        restart: unless-stopped
  '';

  elia.caddy.routes."${url}".host = "localhost:${port}";
}
