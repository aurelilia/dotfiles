{ pkgs-unstable, ... }:
let
  url = "docs.catin.eu";
in
{
  services.paperless = {
    enable = true;
    # package = pkgs-unstable.paperless-ngx;
    dataDir = "/persist/data/paperless";
    settings = {
      PAPERLESS_OCR_LANGUAGE = "deu+eng";
      PAPERLESS_URL = "https://${url}";
    };
  };

  feline.caddy.routes.${url} = {
    mode = "local";
    port = 28981;
  };
}
