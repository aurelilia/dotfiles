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
  ];
in
{
  # Borg
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

  # ZnapZend
  elia.zfs.znap = {
    remotes = [ "jade" ];
    paths = {
      local = "data/local";
      keep = "data/keep";
    };
  };
}
