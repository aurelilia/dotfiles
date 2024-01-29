{ config, lib, pkgs, ... }:
let borg = config.lib.borg;
in {
  # Borg
  programs.ssh.knownHosts = borg.hosts;
  services.borgbackup.jobs.systemBorgbase = borg.systemBorgbase;
  services.borgbackup.jobs.mediaBorgbase = borg.mediaWorkstationBorgbase;

  # Sanoid
  services.sanoid.datasets = {
    "zroot/keep/persist".useTemplate = [ "tempDir" ];
    "zroot/local/ethereal".useTemplate = [ "tempDir" ];
    "zroot/keep/home".useTemplate = [ "hasBackup" ];
  };
}
