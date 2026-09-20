{ ... }:
let
  port = 50149;
  url = "fiesta.catin.eu";
in
{
  feline.containers.octo-fiesta = {
    image = "ghcr.io/v1ck3s/octo-fiesta";
    environment = {
      ASPNETCORE_ENVIRONMENT = "Production";
      ASPNETCORE_URLS = "http://+:8080";
      
      Library__DownloadPath = "/app/downloads";
      Subsonic__Url = "https://music.catin.eu";
      Subsonic__StorageMode = "Permanent";
      Subsonic__EnableExternalPlaylists = "true";
      Subsonic__DownloadMode = "Album";

      Subsonic__MusicService = "Tidal";
      Tidal__TokenStore = "/config/tidal-tokens.json";
      Tidal__Quality = "LOSSLESS";
    };
    ports = [ "${toString port}:8080" ];
    volumes = [
      "/persist/secrets/octo-fiesta:/config"
      "/media/personal/music/octo-fiesta:/app/downloads"
    ];
  };

  feline.caddy.routes."${url}".port = port;
}
