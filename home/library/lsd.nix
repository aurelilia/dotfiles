{ ... }:
{
  programs.lsd = {
    enable = true;
    settings = {
      color.when = "always";
      icons.when = "always";
      date = "relative";
      sorting.dir-grouping = "first";
    };
  };

  feline.shellAliases = {
    lsd = "lsd -lFh";
    lad = "lsd -lFha";
  };
  programs.zsh.shellAliases = {
    ls = "lsd -lFh";
    la = "lsd -lFha";
  };
  programs.fish.shellAliases = {
    ls = "lsd -lFh";
    la = "lsd -lFha";
  };
}
