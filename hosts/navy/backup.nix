{ config, lib, pkgs, ... }:
let borg = import ../../fleet/mixins/borg.nix;
in {
  programs.ssh.knownHosts = borg.hosts;
  services.borgbackup.jobs.borgbase = borg.systemBorgbase // {
    paths = [ "/containers" ];
  };
}
