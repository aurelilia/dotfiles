{ ... }:
let
  path = "/persist/data/ffsync";
  port = 50075;
  url = "firefox.feline.works";
in
{
  # I would use services.firefox-syncserver here, but it sadly forces
  # MySQL and is therefore incompatible with historical data I still have.
  feline.compose.ffsync.services.ffsync = {
    image = "mozilla/syncserver";
    env_file = [ "${path}/env" ];
    environment = {
      SYNCSERVER_BATCH_UPLOAD_ENABLED = "true";
      SYNCSERVER_FORCE_WSGI_ENVIRON = "true";
      SYNCSERVER_PUBLIC_URL = "https://${url}";
      SYNCSERVER_SQLURI = "sqlite:////data/syncserver.db";
      TZ = "Europe/Berlin";
    };
    ports = [ "${toString port}:5000" ];
    volumes = [ "${path}/data:/data" ];
  };

  feline.caddy.routes."${url}".port = port;
}
