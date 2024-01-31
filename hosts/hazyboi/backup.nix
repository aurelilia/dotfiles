{ config, lib, pkgs, ... }:
let borg = config.lib.borg;
in {
  # Borg
  programs.ssh.knownHosts = borg.hosts;
  services.borgbackup.jobs.systemBorgbase = borg.systemBorgbase;
  services.borgbackup.jobs.mediaBorgbase = borg.mediaWorkstationBorgbase;

  # ZnapZend
  elia.zfs.znap.remotes = [ "jade" ];
}
