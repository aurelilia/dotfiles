{ ... }:
{
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
}