{ nixosConfig, ... }:
{
  programs.eww = {
    enable = true;
    package = nixosConfig.lib.pkgs-unstable.eww;
    configDir = ../files/eww;
  };

  xdg.dataFile."fonts/material_design_iconic_font.ttf".source = ../files/material_design_iconic_font.ttf;
}
