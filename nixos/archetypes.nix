{
  lib,
  pkgs,
  name,
  ...
}:
let
  tags = (import ../meta.nix).nodes.${name}.tags;
  conf = {
    defaults = {
      feline = {
        autodeploy.local = true;
        borg.persist.enable = true;
        tailscale.enable = true;
        dotfiles.enable = true;
        theme.enable = true;

        borg.media.enable = lib.mkDefault true;
        smartd.enable = lib.mkDefault true;
      };
    };

    server = {
      feline = {
        dns.enable = true;
        initrd-ssh.enable = true;
        dotfiles.user = "root";
      };
    };
    docker.feline.docker.enable = true;

    workstation = {
      # I want Mullvad on GUI systems
      services.mullvad-vpn.enable = true;
      feline.persist."mullvad" = {
        path = "/etc/mullvad-vpn";
        kind = "config";
      };

      # I want a basic docker host on GUI systems
      virtualisation.docker.enable = true;

      # I want my NAS NFS shares available on GUI systems when needed
      fileSystems."/haze" = {
        device = "haze:/media";
        fsType = "nfs4";
        options = [
          "noauto"
          "x-systemd.idle-timeout=600"
        ];
      };
      fileSystems."/wolf" = {
        device = "haze:/wolf";
        fsType = "nfs4";
        options = [
          "noauto"
          "x-systemd.idle-timeout=600"
        ];
      };
      fileSystems."/ziggurat" = {
        device = "haze:/ziggurat";
        fsType = "nfs4";
        options = [
          "noauto"
          "x-systemd.idle-timeout=600"
        ];
      };
      systemd.services.create-dirs = {
        description = "Create directories";
        wantedBy = [ "multi-user.target" ];
        serviceConfig.Type = "oneshot";
        script = ''
          mkdir -p /haze /wolf /mnt /ziggurat /media
        '';
      };

      feline = {
        zfs = {
          lustrate = true;
          znap.enable = true;
        };
        gui.enable = true;
        autodeploy = {
          # Persistent timers get wiped on reboot, so update
          # during the day instead of at night
          time = "18:00";
          # Config switches while trying to actually use a system are annoying
          noSwitch = true;
        };

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
        tang.enable = true;
      };
    };

    mobile = {
      environment.systemPackages = [ pkgs.brightnessctl ];
      feline = {
        power-management.enable = true;
        wireless.enable = true;
      };
    };

    virtual = {
      feline = {
        smartd.enable = false;
        grub.enableEfi = false;
      };
    };
  };
in
lib.mkMerge (builtins.map (tag: conf.${tag}) tags)
