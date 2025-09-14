{ pkgs-unstable, ... }:
let
  url = "docs.catin.eu";
in
{
  feline.paperless = {
    enable = true;
    package = pkgs-unstable.paperless-ngx;
    dataDir = "/persist/data/paperless";
    configureNginx = false;
    domain = url;
    settings.PAPERLESS_OCR_LANGUAGE = "deu+eng";
  };

  feline.caddy.routes.${url} = {
    mode = "local";
    port = 28981;
  };
}
