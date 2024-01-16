{ config, pkgs, ... }: {
  programs.lsd = {
    enable = true;
    settings = {
      color.when = "always";
      icons.when = "always";
      date = "relative";
      sorting.dir-grouping = "first";
    };
  };

  programs.nushell.shellAliases = {
    lsd = "lsd -lFh";
    lad = "lsd -lFha";
  };
}
