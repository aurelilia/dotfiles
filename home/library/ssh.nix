{ ... }:
{
  programs.ssh = {
    enable = true;
    compression = true;
    matchBlocks = {
      haze.user = "root";
      manul = {
        user = "root";
        port = 9022;
      };
    };
  };

  feline.shellAliases.ssh-unlock = "ssh -p 2222";
}
