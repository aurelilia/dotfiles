{ config, lib, pkgs, ... }:
let
  borg = import ../../fleet/mixins/borg.nix;
  mediaDirs = [
    "/containers"
    "/media"
    "/srv/nextcloud"
  ];
  mediaPre = "find /media/media | cut -b 14- > /media/.media-list";
  mediaPost = "rm /media/.media-list";
in {
  programs.ssh.knownHosts = borg.hosts;

  services.borgbackup.jobs = {
    borgbaseSystem = borg.systemBorgbase;
    localSystem = borg.systemJob // {
      repo = "/backup/system";
    };

    borgbaseMedia = borg.defaultJob // {
      paths = mediaDirs;
      repo = borg.borgbaseMediaUrl;
      preHook = mediaPre;
      postCreate = mediaPost;

      prune.keep = {
        within = "1d";
        daily = 10;
        weekly = 2;
      };
    };
    localMedia = borg.defaultJob // {
      paths = mediaDirs;
      repo = "/backup/media";
      preHook = mediaPre;
      postCreate = mediaPost;

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