{ config, pkgs, ... }:
{
  programs.eww = {
    enable = true;
    package = pkgs.eww-wayland;
    configDir = ../files/eww;
  };

  xdg.dataFile."fonts/material_design_iconic_font.ttf".source
    = ../files/material_design_iconic_font.ttf;
}
