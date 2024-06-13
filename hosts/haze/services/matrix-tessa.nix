{ ... }:
let
  url = "matrix.tessa.dog";
  port = 51047;
in
{
  services.matrix-conduit = {
    enable = true;
    settings.global = {
      server_name = "tessa.dog";
      inherit port;
      enable_lightning_bolt = false;
      allow_registration = false;
    };
  };

  feline.persist."matrix/tessa".path = "/var/lib/private/matrix-conduit";
  feline.caddy.routes."${url}".port = port;
}
