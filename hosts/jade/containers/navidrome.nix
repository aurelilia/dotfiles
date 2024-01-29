{ config, ... }:
let url = "music.elia.garden";
in {
  elia.containers.navidrome = {
    mounts."/music" = {
      hostPath = "/media/personal/music";
      isReadOnly = true;
    };
    mounts."/var/lib/navidrome/data" = {
      hostPath = "/containers/navidrome/data";
      isReadOnly = false;
    };

    config = { ... }: {
      services.navidrome = {
        enable = true;
        openFirewall = true;
        settings = {
          Address = "0.0.0.0";
          ScanSchedule = "@every 2h";
          MusicFolder = "/music";
          DataFolder = "/var/lib/navidrome/data";
        };
      };
    };
  };

  elia.caddy.routes."${url}".extraConfig = ''
    reverse_proxy navidrome:4533
  '';
}
