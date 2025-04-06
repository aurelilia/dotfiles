{ ... }:
let
  path = "/persist/data/ffsync";
  port = 50075;
  url = "firefox.catin.eu";
in
{
  # I would use services.firefox-syncserver here, but it sadly forces
  # MySQL and is therefore incompatible with historical data I still have.
  feline.containers.ffsync = {
    image = "mozilla/syncserver";
    environment = {
      SYNCSERVER_BATCH_UPLOAD_ENABLED = "true";
      SYNCSERVER_FORCE_WSGI_ENVIRON = "true";
      SYNCSERVER_PUBLIC_URL = "https://${url}";
      SYNCSERVER_SQLURI = "sqlite:////data/syncserver.db";
      TZ = "Europe/Berlin";
    };
    environmentFiles = [ "${path}/env" ];
    ports = [ "127.0.0.1:${toString port}:5000" ];
    volumes = [ "${path}/data:/data" ];
  };

  feline.caddy.routes."${url}".port = port;
  feline.caddy.routes."firefox.feline.works".redir = url;
}
