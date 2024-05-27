{ ... }:
{
  programs.bat.enable = true;
  feline.shellAliases = {
    ca = "bat -pp";
    va = "bat";
  };
}
