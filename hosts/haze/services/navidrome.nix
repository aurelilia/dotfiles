{ pkgs-unstable, ... }:
let
  url = "music.catin.eu";
in
{
  services.navidrome = {
    enable = true;
    openFirewall = true;
    settings = {
      ScanSchedule = "@every 2h";
      MusicFolder = "/media/personal/music";
      LastFM = {
        ApiKey = "7215047f29bbb24662ef06f59c3c9fae";
        Secret = "0945b41f371b9f5acf3d3ceb0107b157";
      };
    };
  };

  feline.persist.navidrome.path = "/var/lib/private/navidrome";
  feline.caddy.routes."${url}".port = 4533;

  # I want streamrip
  age.secrets.streamrip = {
    file = ../../../secrets/haze/streamrip.age;
    path = "/root/.config/streamrip/config.toml";
  };
  environment.systemPackages = [ pkgs-unstable.streamrip ];
}
