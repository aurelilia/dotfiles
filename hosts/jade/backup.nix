{
  config,
  lib,
  pkgs,
  ...
}:
let
  borg = config.lib.borg;
  mediaDirs = [
    "/containers"
    "/media"
    "/srv/nextcloud"
  ];
in
{
  programs.ssh.knownHosts = borg.hosts;

  services.borgbackup.jobs = {
    borgbaseSystem = borg.systemBorgbase;
    borgbaseMedia = borg.defaultJob // {
      paths = mediaDirs;
      repo = borg.borgbaseMediaUrl;

      prune.keep = {
        within = "1d";
        daily = 10;
        weekly = 2;
      };
    };
  };

  elia.zfs = {
    receive-datasets = [ "zbackup/zend" ];
    znap.pools = [
      "zroot"
      "zdata"
    ];
    znap.destinations.jade = {
      dataset = "zbackup/zend/jade";
    };
  };
}
