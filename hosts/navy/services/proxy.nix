{ pkgs, ... }:
{
  # Haze is behind NAT. We therefore proxy to it where relevant
  elia.caddy.routes = {
    "media.elia.garden" = {
      no-robots = true;
      host = "haze:8096";
    };
    "photos.elia.garden" = {
      no-robots = true;
      host = "haze:2283";
    };
    "vikunja.elia.garden" = {
      no-robots = true;
      host = "haze:3456";
    };
  };
}
