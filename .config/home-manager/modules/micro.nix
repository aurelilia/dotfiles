{ config, pkgs, ... }:
{
  programs.micro = {
    enable = true;
    settings = {
      autosu = false;
      clipboard = "terminal";
      colorscheme = "catppuccin-mocha";
    };
  };
}
