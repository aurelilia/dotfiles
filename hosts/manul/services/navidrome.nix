{
  ...
}:
let
  url = "music.catin.eu";
in
{
  services.navidrome = {
    enable = true;
    openFirewall = true;
    environmentFile = "/persist/secrets/navidrome.env";
    settings = {
      ScanSchedule = "@every 2h";
      MusicFolder = "/media/personal/music";
      CacheFolder = "/cache/navidrome";
      EnableSharing = true;
    };
  };

  feline.persist.navidrome.path = "/var/lib/navidrome";
  feline.caddy.routes."${url}" = {
    port = 4533;
    monitoringPath = "app";
  };
}
