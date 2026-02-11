{ ... }:
let
  url = "mollysocket.catin.eu";
  port = 23439;
in
{
  services.mollysocket = {
    enable = true;
    environmentFile = "/persist/data/mollysocket/env";
    settings.port = 23439;
  };

  feline.caddy.routes.${url}.port = port;
}
