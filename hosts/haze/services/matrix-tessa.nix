{ pkgs-unstable, config, ... }:
let
  url = "matrix.tessa.dog";
  port = 51047;
in
{
  services.matrix-continuwuity = {
    enable = true;
    package = config.lib.pkgs.continuwuity;
    settings.global = {
      server_name = "tessa.dog";
      port = [ port ];
      enable_lightning_bolt = false;
      allow_registration = false;
    };
  };

  feline.persist."matrix/tessa".path = "/var/lib/private/continuwuity";
  feline.caddy.routes."${url}".port = port;
}
