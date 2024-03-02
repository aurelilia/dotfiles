{ ... }:
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
    mounts."/var/lib/private/jellyseerr" = {
      hostPath = "/persist/data/jellyseerr";
      isReadOnly = false;
    };

    ports = [
      # Web UIs
      { hostPort = 8096; }
      { hostPort = 5055; }
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
      { ... }:
      {
        services.jellyfin = {
          enable = true;
          openFirewall = true;
        };

        services.jellyseerr.enable = true;
      };
  };
}
