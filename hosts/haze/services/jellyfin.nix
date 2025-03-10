{
  pkgs,
  ...
}:
{
  services.jellyfin = {
    enable = true;
    openFirewall = true;
  };

  feline.persist."jellyfin".path = "/var/lib/jellyfin";
  feline.caddy.routes."media.catin.eu".port = 8096;
}
