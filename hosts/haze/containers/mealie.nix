{ ... }:
let
  port = 60032;
in
{
  feline.containers.mealie = {
    image = "ghcr.io/mealie-recipes/mealie:v3.1.2";
    ports = [ "127.0.0.1:${toString port}:${toString port}" ];
    volumes = [ "/persist/data/mealie:/app/data/" ];
    environmentFiles = [ "/persist/secrets/mealie.env" ];
  };

  feline.caddy.routes."recipe.catin.eu".port = port;
}
