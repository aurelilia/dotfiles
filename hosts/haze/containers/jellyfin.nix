{
  pkgs,
  ...
}:
{
  services.jellyfin = {
    enable = true;
    openFirewall = true;
  };
  users.users.jellyfin.extraGroups = [ "render" ];

  feline.persist."jellyfin".path = "/var/lib/jellyfin";
  feline.caddy.routes = {
    "media.catin.eu".port = 8096;
    "s.media.catin.eu" = {
      host = "jellyseerr.container:8989";
      mode = "tailnet";
    };
    "r.media.catin.eu" = {
      host = "jellyseerr.container:7878";
      mode = "tailnet";
    };
  };

  boot.kernelParams = [ "i915.enable_guc=2" ];

  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver
      intel-compute-runtime
    ];
  };

  nixpkgs.config.permittedInsecurePackages = [
    "aspnetcore-runtime-6.0.36"
    "aspnetcore-runtime-wrapped-6.0.36"
    "dotnet-sdk-6.0.428"
    "dotnet-sdk-wrapped-6.0.428"
  ];

  feline.containers.jellyseerr = {
    mounts."/media" = {
      hostPath = "/wolf/media";
      isReadOnly = false;
    };
    mounts."/var/lib/radarr" = {
      hostPath = "/persist/data/radarr";
      isReadOnly = false;
    };
    mounts."/var/lib/sonarr" = {
      hostPath = "/persist/data/sonarr";
      isReadOnly = false;
    };

    ports = [
      # Web UIs
      { hostPort = 7878; }
      { hostPort = 9696; }
    ];

    config =
      { config, ... }:
      {
        services.radarr = {
          enable = true;
          openFirewall = true;
        };
        services.sonarr = {
          enable = true;
          openFirewall = true;
        };
      };
  };
}
