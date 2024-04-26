{ ... }:
{
  programs.bat = {
    enable = true;
    catppuccin.enable = true;
  };

  feline.shellAliases = {
    ca = "bat -pp";
    va = "bat";
  };
}
