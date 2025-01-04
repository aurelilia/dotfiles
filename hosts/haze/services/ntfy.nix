{ ... }:
let
  url = "ntfy.feline.works";
  port = 23438;
in
{
  services.ntfy-sh = {
    enable = true;
    settings = {
      base-url = "https://${url}";
      listen-http = "127.0.0.1:${toString port}";
      behind-proxy = true;
    };
  };

  feline.caddy.routes.${url}.port = port;
}
