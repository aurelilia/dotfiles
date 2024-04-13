{ ... }:
{
  programs.bat = {
    enable = true;
    catppuccin.enable = true;
  };

  elia.shellAliases = {
    ca = "bat -pp";
    va = "bat";
  };
}
