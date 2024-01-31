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
          LastFM = {
            # TODO lol, secrets in public git repo
            ApiKey = "7215047f29bbb24662ef06f59c3c9fae";
            Secret = "0945b41f371b9f5acf3d3ceb0107b157";
          };
        };
      };

      # https://github.com/NixOS/nixpkgs/issues/151550
      systemd.services.navidrome.serviceConfig.BindReadOnlyPaths = ["/run/systemd/resolve/stub-resolv.conf"];
    };
  };

  elia.caddy.routes."${url}".extraConfig = ''
    reverse_proxy navidrome:4533
  '';
}
