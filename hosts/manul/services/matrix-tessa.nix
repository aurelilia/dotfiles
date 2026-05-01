{ pkgs-unstable, ... }:
let
  url = "matrix.tessa.dog";
  port = 51047;
in
{
  services.matrix-continuwuity = {
    enable = true;
    package = pkgs-unstable.matrix-continuwuity;
    settings.global = {
      server_name = "tessa.dog";
      port = [ port ];
      allow_registration = false;
    };
  };

  feline.persist."matrix/tessa".path = "/var/lib/private/continuwuity";
  feline.caddy.routes."${url}".port = port;
}
