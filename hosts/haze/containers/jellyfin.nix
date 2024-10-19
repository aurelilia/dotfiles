# In part based on:
# https://headless-render-api.com/blog/2024/04/08/mullvad-vpn-containerized-nixos
# https://github.com/pceiley/nix-config/blob/3854c687d951ee3fe48be46ff15e8e094dd8e89f/hosts/common/modules/qbittorrent.nix
{ lib, pkgs, pkgs-unstable, ... }:
{
  services.jellyfin = {
    enable = true;
    openFirewall = true;
  };
  users.users.jellyfin.extraGroups = [ "render" ];

  feline.persist."jellyfin".path = "/var/lib/jellyfin";
  feline.caddy.routes = {
    "media.kitten.works".port = 8096;
    "request.kitten.works" = {
      port = 5055;
      mode = "sso";
    };
  };

  boot.kernelParams = [ "i915.enable_guc=2" ];

  hardware.opengl = {
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

  age.secrets.mullvad = {
    file = ../../../secrets/haze/mullvad.age;
    path = "/persist/data/qbittorrent/mullvad";
    symlink = false;
  };

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
    mounts."/var/lib/private/prowlarr" = {
      hostPath = "/persist/data/prowlarr";
      isReadOnly = false;
    };
    mounts."/var/lib/private/jellyseerr" = {
      hostPath = "/persist/data/jellyseerr";
      isReadOnly = false;
    };
    mounts."/qbit" = {
      hostPath = "/persist/data/qbittorrent";
      isReadOnly = false;
    };

    mounts."/etc/mullvad-vpn" = {
      hostPath = "/persist/data/mullvad/etc";
      isReadOnly = false;
    };
    mounts."/var/cache/mullvad-vpn" = {
      hostPath = "/persist/data/mullvad/cache";
      isReadOnly = false;
    };

    ports = [
      # Web UIs
      { hostPort = 5055; }
      { hostPort = 7878; }
      { hostPort = 8989; }
      { hostPort = 7979; }
      { hostPort = 9696; }
    ];

    config =
      { config, ... }:
      {
        services.mullvad-vpn.enable = true;
        systemd.services."mullvad-daemon".postStart =
          let
            mullvad = pkgs.mullvad-vpn;
          in
          ''
            while ! ${mullvad}/bin/mullvad status >/dev/null; do sleep 1; done
            account="$(cat /qbit/mullvad)"

            # only login if we're not already logged in otherwise we'll get a new device
            current_account="$(${mullvad}/bin/mullvad account get | grep "account:" | sed 's/.* //')"
            if [[ "$current_account" != "$account" ]]; then
              ${mullvad}/bin/mullvad account login "$account"
            fi

            ${mullvad}/bin/mullvad relay set location se
            ${mullvad}/bin/mullvad auto-connect set on
            ${mullvad}/bin/mullvad lan set allow
            ${mullvad}/bin/mullvad lockdown-mode set on
            ${mullvad}/bin/mullvad dns set custom 9.9.9.9
            ${mullvad}/bin/mullvad connect
          '';

        services.jellyseerr = {
          enable = true;
          openFirewall = true;
        };

        services.radarr = {
          enable = true;
          openFirewall = true;
        };
        services.sonarr = {
          enable = true;
          openFirewall = true;
        };
        services.prowlarr = {
          enable = true;
          openFirewall = true;
        };

        systemd.services.qbittorrent = {
          description = "qBittorrent-nox service";
          documentation = [ "man:qbittorrent-nox(1)" ];
          after = [
            "network.target"
            "mullvad-daemon.service"
          ];
          wantedBy = [ "multi-user.target" ];
          bindsTo = [ "mullvad-daemon.service" ];

          serviceConfig = {
            Type = "simple";
            User = "qbittorrent";
            Group = "qbittorrent";

            ExecStartPre =
              let
                preStartScript = pkgs.writeScript "qbittorrent-run-prestart" ''
                  #!${pkgs.bash}/bin/bash

                  # Create data directory if it doesn't exist
                  if ! test -d "$QBT_PROFILE"; then
                    echo "Creating initial qBittorrent data directory in: $QBT_PROFILE"
                    install -d -m 0755 -o "qbittorrent" -g "qbittorrent" "$QBT_PROFILE"
                  fi
                '';
              in
              "!${preStartScript}";
            ExecStart = "${pkgs.qbittorrent-nox}/bin/qbittorrent-nox";
          };

          environment = {
            QBT_PROFILE = "/qbit/data";
            QBT_WEBUI_PORT = "7979";
          };
        };

        users.users.qbittorrent = {
          group = "qbittorrent";
          uid = 888;
        };
        users.groups.qbittorrent.gid = 888;

        # https://github.com/NixOS/nixpkgs/blob/nixos-unstable/nixos/modules/services/misc/flaresolverr.nix
        systemd.services.flaresolverr = {
          description = "FlareSolverr";
          after = [ "network.target" ];
          wantedBy = [ "multi-user.target" ];

          environment = {
            HOME = "/run/flaresolverr";
            PORT = "8191";
          };

          serviceConfig = {
            SyslogIdentifier = "flaresolverr";
            Restart = "always";
            RestartSec = 5;
            Type = "simple";
            DynamicUser = true;
            RuntimeDirectory = "flaresolverr";
            WorkingDirectory = "/run/flaresolverr";
            ExecStart = lib.getExe pkgs-unstable.flaresolverr;
            TimeoutStopSec = 30;
          };
        };
      };
  };
}
