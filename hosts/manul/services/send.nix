{ ... }:
let
  url = "send.catin.eu";
in
{
  services.send = {
    enable = true;
    baseUrl = url;
    environment = {
      DEFAULT_DOWNLOADS = 1;
      EXPIRE_TIMES_SECONDS = "300,3600,86400";
    };
  };
  feline.caddy.routes.${url}.port = 1443;
}
