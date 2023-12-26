{ config, lib, pkgs, ... }:
let
  borg = import ../../fleet/mixins/borg.nix;
  mediaDirs = [ "/containers" "/media" ];
  mediaPre = "find /media/media | cut -b 14- > /media/.media-list";
  mediaPost = "rm /media/.media-list";
in {
  programs.ssh.knownHosts = borg.hosts;

  services.borgbackup.jobs = {
    borgbaseSystem = borg.systemBorgbase;

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
  };
}
