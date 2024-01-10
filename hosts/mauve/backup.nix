{ config, lib, pkgs, ... }:
let borg = import ../../fleet/mixins/borg.nix;
in {
  # Borg
  programs.ssh.knownHosts = borg.hosts;
  services.borgbackup.jobs.systemBorgbase = borg.systemBorgbase;
  services.borgbackup.jobs.mediaBorgbase = borg.mediaWorkstationBorgbase;

  # Sanoid
  services.sanoid.datasets = {
    "zroot/data/persist".useTemplate = [ "tempDir" ];
    "zroot/data/ethereal".useTemplate = [ "tempDir" ];
    "zroot/data/home".useTemplate = [ "hasBackup" ];
  };
}
