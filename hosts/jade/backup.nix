{ config, lib, pkgs, ... }:
let
  borg = config.lib.borg;
  mediaDirs = [ "/containers" "/media" "/srv/nextcloud" ];
in {
  programs.ssh.knownHosts = borg.hosts;

  services.borgbackup.jobs = {
    borgbaseSystem = borg.systemBorgbase;
    localSystem = borg.systemJob // { repo = "/backup/system"; };

    borgbaseMedia = borg.defaultJob // {
      paths = mediaDirs;
      repo = borg.borgbaseMediaUrl;

      prune.keep = {
        within = "1d";
        daily = 10;
        weekly = 2;
      };
    };
    localMedia = borg.defaultJob // {
      paths = mediaDirs;
      repo = "/backup/media";

      prune.keep = {
        within = "1d";
        daily = 30;
        weekly = 12;
        monthly = 12;
        yearly = 10;
      };
    };
  };
}
