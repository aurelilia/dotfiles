{ ... }:
let
  url = "music.elia.garden";
in
{
  services.navidrome = {
    enable = true;
    openFirewall = true;
    settings = {
      ScanSchedule = "@every 2h";
      MusicFolder = "/music";
      LastFM = {
        # TODO lol, secrets in public git repo
        ApiKey = "7215047f29bbb24662ef06f59c3c9fae";
        Secret = "0945b41f371b9f5acf3d3ceb0107b157";
      };
    };
  };
  
  fileSystems."/music" = {
    device = "/media/personal/music";
    options = [ "bind" "ro" ];
  };

  elia.persist.navidrome.path = "/var/lib/private/navidrome";
  elia.caddy.routes."${url}".port = 4533;
}
