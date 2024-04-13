{ pkgs, ... }:
{
  # Haze is behind NAT. We therefore proxy to it where relevant
  elia.caddy.routes = {
    "media.elia.garden".host = "haze:8096";
    "photos.elia.garden".host = "haze:2283";
    "vikunja.elia.garden".host = "haze:3456";
  };
}
