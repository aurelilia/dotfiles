{ ... }:
let
  url = "docs.theria.nl";
in
{
  services.paperless = {
    enable = true;
    dataDir = "/persist/data/paperless";
    extraConfig = {
      PAPERLESS_OCR_LANGUAGE = "deu+eng";
      PAPERLESS_URL = "https://${url}";
    };
  };

  elia.caddy.routes.${url} = {
    mode = "sso";
    port = 28981;
  };
}
