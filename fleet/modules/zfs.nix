{ lib, config, pkgs, ... }:
let root = config.fileSystems."/".device;
in {
  # General config
  networking.hostId = lib.mkDefault "00000000";
  virtualisation.docker.storageDriver = lib.mkDefault "zfs";
  virtualisation.docker.extraPackages = [ pkgs.zfs ];

  services.zfs.autoScrub.enable = true;
  services.zfs.trim.enable = true;
  systemd.services.zfs-mount.enable = true;

  services.sanoid = {
    enable = true;

    templates.hasBackup = {
      autoprune = true;
      autosnap = true;
      hourly = 48;
    };
    templates.tempDir = {
      autoprune = true;
      autosnap = true;
      hourly = 24;
      daily = 10;
    };
  };

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
      zfs destroy ${root}-minus-3 || true
      zfs rename ${root}-minus-2 ${root}-minus-3 || true
      zfs rename ${root}-minus-1 ${root}-minus-2 || true
      zfs rename ${root} ${root}-minus-1 || true
      zfs create -o mountpoint=legacy ${root}
    '';
  };
}
