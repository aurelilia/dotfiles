{
  lib,
  config,
  pkgs,
  ...
}:
let
  root-mnt = config.fileSystems."/";
  root = root-mnt.device;
  cfg = config.feline.zfs;
in
{
  config = lib.mkMerge [
    (lib.mkIf (root-mnt.fsType == "zfs") {
      # General config
      boot.loader.grub.zfsSupport = true;
      networking.hostId = lib.mkDefault "00000000";
      virtualisation.docker.storageDriver = lib.mkDefault "zfs";
      virtualisation.docker.extraPackages = [ pkgs.zfs ];

      services.zfs.autoScrub.enable = true;
      services.zfs.trim.enable = true;
      systemd.services.zfs-mount.enable = true;

      # Make sure a proper kernel is available. I want newest stable, not LTS
      boot.kernelPackages = config.boot.zfs.package.latestCompatibleLinuxPackages;
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
        openssh.authorizedKeys.keys = (import ../../../secrets/keys.nix).zfs-sender;
      };
      users.groups.zend = { };

      system.activationScripts."Allow ZFS send to datasets".text = lib.concatStringsSep "\n" (
        map (dataset: ''
          ${pkgs.zfs}/bin/zfs create -o canmount=off ${dataset} || true
          ${pkgs.zfs}/bin/zfs allow zend mount,create,receive,destroy ${dataset}
        '') cfg.receive-datasets
      );
    })
  ];

  options.feline.zfs = {
    lustrate = lib.mkEnableOption "ZFS lustration";

    receive-datasets = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      description = "Datasets to allow other systems to send snapshots to.";
      default = [ ];
    };
  };
}
