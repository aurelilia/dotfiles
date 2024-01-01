{ config, lib, pkgs, ... }:
let
  borg = import ../../fleet/mixins/borg.nix;
  mediaDirs = [ "/containers" "/media" ];
in {
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

  # Sanoid
  services.sanoid.datasets = {
    "zroot/system/nixos".useTemplate = [ "tempDir" ];
    "zroot/data/vms".useTemplate = [ "tempDir" ];
    "zroot/data/personal".useTemplate = [ "hasBackup" ];
  };
}
