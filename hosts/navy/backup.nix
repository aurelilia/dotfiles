{
  config,
  lib,
  pkgs,
  ...
}:
{
  programs.ssh.knownHosts = config.lib.borg.hosts;
  services.borgbackup.jobs.borgbase = config.lib.borg.systemBorgbase // {
    paths = [ "/containers" ];
  };
}
