{
  lib,
  config,
  pkgs,
  ...
}:
let
  ty = config.feline.archetype;
in
{
  config = lib.mkMerge [
    (lib.mkIf (ty != "generic") {
      feline = {
        autodeploy.local = true;
        borg.persist.enable = true;
        tailscale.enable = true;

        borg.media.enable = lib.mkDefault true;
        smartd.enable = lib.mkDefault true;
      };
    })

    (lib.mkIf (ty == "server") {
      feline = {
        docker.enable = true;
        dns.enable = true;
        dotfiles.user = "root";
      };
    })

    (lib.mkIf (ty == "desktop" || ty == "mobile") {
      # I want Mullvad on GUI systems
      services.mullvad-vpn.enable = true;

      # I want a basic docker host on GUI systems
      virtualisation.docker.enable = true;

      # I want my NAS NFS share available on GUI systems when needed
      fileSystems."/haze" = {
        device = "haze:/media";
        fsType = "nfs4";
        options = [
          "noauto"
          "x-systemd.idle-timeout=600"
        ];
      };

      feline = {
        zfs = {
          lustrate = true;
          znap.enable = true;
        };
        gui.enable = true;

        dotfiles = {
          user = "leela";
          full = true;
          create-user = true;
        };

        syncthing = {
          enable = true;
          user = "leela";
          dataDir = "/home/leela";
        };
      };
    })

    (lib.mkIf (ty == "mobile") {
      environment.systemPackages = [ pkgs.brightnessctl ];

      feline = {
        power-management.enable = true;
        wireless.enable = true;

        gui.extraSway = {
          input."*" = {
            middle_emulation = "enabled";
            tap = "enabled";
          };
        };
      };
    })
  ];

  options = {
    feline.archetype = lib.mkOption {
      type = lib.types.enum [
        "server"
        "desktop"
        "mobile"
        "generic"
      ];
      default = "generic";
      description = "What archetype to use for base configuration.";
    };
  };
}
