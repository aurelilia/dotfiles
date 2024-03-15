{ pkgs, ... }:
{
  elia.containers.jellyfin = {
    mounts."/media" = {
      hostPath = "/media/media";
      isReadOnly = false;
    };
    mounts."/var/lib/jellyfin" = {
      hostPath = "/persist/data/jellyfin";
      isReadOnly = false;
    };
    mounts."/var/lib/radarr" = {
      hostPath = "/persist/data/radarr";
      isReadOnly = false;
    };
    mounts."/var/lib/private/jellyseerr" = {
      hostPath = "/persist/data/jellyseerr";
      isReadOnly = false;
    };

    ports = [
      # Web UIs
      { hostPort = 8096; }
      { hostPort = 5055; }
      { hostPort = 7878; }
      # Jellyfin discovery
      {
        hostPort = 1900;
        protocol = "udp";
      }
      {
        hostPort = 7359;
        protocol = "udp";
      }
    ];

    config =
      { config, ... }:
      {
        #services.mullvad-vpn.enable = true;
        #age.secrets.mullvad.file = ../../../secrets/haze/mullvad.age;
        #systemd.services."mullvad-daemon".postStart =
        #  let
        #    mullvad = pkgs.mullvad-vpn;
        #  in
        #  ''
        #    while ! ${mullvad}/bin/mullvad status >/dev/null; do sleep 1; done
        #    ${mullvad}/bin/mullvad auto-connect set on
        #    ${mullvad}/bin/mullvad tunnel ipv6 set on
        #    ${mullvad}/bin/mullvad set default \
        #        --block-ads --block-trackers --block-malware
        #    ${mullvad}/bin/mullvad relay set location se
        #    ${mullvad}/bin/mullvad account login $(cat ${config.age.secrets.mullvad.path})
        #  '';

        services.jellyfin = {
          enable = true;
          openFirewall = true;
        };

        services.jellyseerr = {
          enable = true;
          openFirewall = true;
        };

        #services.radarr = {
        #  enable = true;
        #  openFirewall = true;
        #};
      };
  };
}
