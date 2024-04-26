{ pkgs, ... }:
{
  services.jellyfin = {
    enable = true;
    openFirewall = true;
  };
  users.users.jellyfin.extraGroups = [ "render" ];

  feline.persist."jellyfin".path = "/var/lib/jellyfin";
  feline.caddy.routes."media.kitten.works".port = 8096;

  boot.kernelParams = [ "i915.enable_guc=2" ];

  hardware.opengl = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver
      intel-compute-runtime
    ];
  };

  feline.containers.jellyseerr = {
    mounts."/media" = {
      hostPath = "/media/media";
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
      { hostPort = 5055; }
      { hostPort = 7878; }
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
