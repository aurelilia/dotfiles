{ lib, ... }:
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

  programs.zsh.shellAliases = {
    ls = lib.mkForce "lsd -l";
    la = lib.mkForce "lsd -la";
  };
  programs.fish.shellAliases = {
    ls = lib.mkForce "lsd -l";
    la = lib.mkForce "lsd -la";
  };
}
