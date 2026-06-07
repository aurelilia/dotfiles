{ ... }:
{
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    settings = {
      "*" = {
        Compression = true;
        ForwardAgent = false;
        AddKeysToAgent = "no";
        ServerAliveInterval = 0;
        ServerAliveCountMax = 3;
        HashKnownHosts = false;
        UserKnownHostsFile = "~/.ssh/known_hosts";
        ControlMaster = "no";
        ControlPath = "~/.ssh/master-%r@%n:%p";
        ControlPersist = "no";
      };
      "Host haze".User = "root";
      "Host manul" = {
        User = "root";
        Port = "9022";
      };
    };
  };

  feline.shellAliases.ssh-unlock = "ssh -p 2222";
}
