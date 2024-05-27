{ ... }:
{
  programs.micro = {
    enable = true;
    settings = {
      autosu = false;
      clipboard = "terminal";
    };
  };

  xdg.enable = true;
  home.sessionVariables.EDITOR = "micro";
}
