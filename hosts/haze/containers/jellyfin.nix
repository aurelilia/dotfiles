# In part based on:
# https://headless-render-api.com/blog/2024/04/08/mullvad-vpn-containerized-nixos
# https://github.com/pceiley/nix-config/blob/3854c687d951ee3fe48be46ff15e8e094dd8e89f/hosts/common/modules/qbittorrent.nix
{
  lib,
  pkgs,
  pkgs-unstable,
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
    "media.kitten.works".port = 8096;
    "s.request.kitten.works" = {
      host = "jellyseerr.container:8989";
      mode = "tailnet";
    };
    "r.request.kitten.works" = {
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

  # critical fix for mullvad-daemon to run in container, otherwise errors with: "EPERM: Operation not permitted"
  # It seems net_cls API filesystem is deprecated as it's part of cgroup v1. So it's not available by default on hosts using cgroup v2.
  # https://github.com/mullvad/mullvadvpn-app/issues/5408#issuecomment-1805189128
  fileSystems."/tmp/net_cls" = {
    device = "net_cls";
    fsType = "cgroup";
    options = [ "net_cls" ];
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
