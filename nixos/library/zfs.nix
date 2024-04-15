{
  lib,
  config,
  pkgs,
  name,
  ...
}:
let
  root-mnt = config.fileSystems."/";
  root = root-mnt.device;
  cfg = config.elia.zfs;
in
{
  config = lib.mkMerge [
    (lib.mkIf (root-mnt.fsType == "zfs") {
      # General config
      networking.hostId = lib.mkDefault "00000000";
      virtualisation.docker.storageDriver = lib.mkDefault "zfs";
      virtualisation.docker.extraPackages = [ pkgs.zfs ];

      services.zfs.autoScrub.enable = true;
      services.zfs.trim.enable = true;
      systemd.services.zfs-mount.enable = true;
    })

    (lib.mkIf cfg.lustrate {
      # NixOS 'lustration'
      # Heavily inspired by https://grahamc.com/blog/erase-your-darlings/,
      # as well as examples in the ZFS manual pages
      # as well as https://discourse.nixos.org/t/zfs-rollback-not-working-using-boot-initrd-systemd/37195/2
      boot.initrd.systemd.services.rollback = {
        description = "Lustrate root filesystem";
        wantedBy = [ "initrd.target" ];
        after = [ "zfs-import-zroot.service" ];
        before = [ "sysroot.mount" ];
        path = with pkgs; [ zfs ];
        unitConfig.DefaultDependencies = "no";
        serviceConfig.Type = "oneshot";
        script = ''
          # We keep root from the last 3 boots
          # Any command except the create can fail in case the system has not
          # booted that often yet
          zfs destroy -r ${root}-minus-3 || true
          zfs rename ${root}-minus-2 ${root}-minus-3 || true
          zfs rename ${root}-minus-1 ${root}-minus-2 || true
          zfs rename ${root} ${root}-minus-1 || true
          zfs create -o mountpoint=legacy ${root}
        '';
      };
    })

    (lib.mkIf (cfg.receive-datasets != [ ]) {
      users.users.zend = {
        isSystemUser = true;
        group = "zend";
        shell = pkgs.bash;
        packages = [ pkgs.mbuffer ];
        openssh.authorizedKeys.keys = (import ../../secrets/keys.nix).zfs-sender;
      };
      users.groups.zend = { };

      system.activationScripts."Allow ZFS send to datasets".text = lib.concatStringsSep "\n" (
        map (dataset: ''
          ${pkgs.zfs}/bin/zfs create -o canmount=off ${dataset} || true
          ${pkgs.zfs}/bin/zfs allow zend mount,create,receive,destroy ${dataset}
        '') cfg.receive-datasets
      );
    })

    (lib.mkIf cfg.znap.enable {
      programs.ssh.knownHosts = (import ../../secrets/keys.nix).zfs-receiver;
      services.znapzend = {
        enable = true;
        autoCreation = true;
        pure = true;

        features = {
          compressed = true;
          recvu = true;
          sendRaw = true;
          zfsGetType = true;
        };

        zetup = (
          lib.concatMapAttrs
            (pool: value: {
              "${pool}-keep" = value // {
                dataset = "${pool}/${cfg.znap.paths.keep}";
                plan = "1h=>5min,1d=>1h,2w=>1d,2m=>1w,1y=>1m";
                destinations =
                  cfg.znap.destinations
                  // (lib.genAttrs cfg.znap.remotes (remote: {
                    host = "zend@${remote}";
                    dataset = "zbackup/zend/${name}";
                    plan = "1d=>1h,2w=>1d,2m=>1w,1y=>1m";
                  }));
              };
              "${pool}-local" = value // {
                dataset = "${pool}/${cfg.znap.paths.local}";
                plan = "1h=>5min,1d=>1h,1w=>1d";
              };
            })
            (
              lib.genAttrs cfg.znap.pools (pool: {
                recursive = true;
                mbuffer.enable = true;
              })
            )
        );
      };

      systemd.services.znapzend.after = [ "tailscaled.service" ];
      elia.notify = [ "znapzend" ];
    })
  ];

  options.elia.zfs = {
    lustrate = lib.mkOption {
      type = lib.types.bool;
      description = "Lustrate the root filesystem on boot.";
      default = true;
    };

    receive-datasets = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      description = "Datasets to allow other systems to send snapshots to.";
      default = [ ];
    };

    znap = {
      enable = lib.mkOption {
        type = lib.types.bool;
        description = "Enable backup of datasets with ZnapZend.";
        default = true;
      };

      pools = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        description = "Pools to back up.";
        default = [ "zroot" ];
      };

      paths = {
        keep = lib.mkOption {
          type = lib.types.str;
          description = "Path of the 'keep' dataset in the pools.";
          default = "keep";
        };
        local = lib.mkOption {
          type = lib.types.str;
          description = "Path of the 'local' dataset in the pools.";
          default = "local";
        };
      };

      remotes = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        description = "Known remotes to back up to.";
        default = [ ];
      };

      destinations = lib.mkOption {
        type = lib.types.attrs;
        description = "Additional destinations to back up to.";
        default = { };
      };
    };
  };
}
