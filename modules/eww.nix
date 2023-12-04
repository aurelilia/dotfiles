{ config, pkgs, ... }:
{
  programs.eww = {
    enable = true;
    configDir = ../files/eww;
  };

  home.file.".local/share/fonts/material_design_iconic_font.ttf".source = ../files/material_design_iconic_font.ttf;
}