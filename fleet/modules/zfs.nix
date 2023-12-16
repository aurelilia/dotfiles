{ ... }:
{
  services.zfs.autoScrub.enable = true;
  services.zfs.trim.enable = true;
  systemd.services.zfs-mount.enable = true;
}