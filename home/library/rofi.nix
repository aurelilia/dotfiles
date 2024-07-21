{
  pkgs,
  lib,
  config,
  ...
}:
{
  home.packages = with pkgs; [
    rofi-screenshot
    gawk
    rofimoji
  ];

  programs.rofi = {
    enable = true;
    package = pkgs.rofi-wayland;

    theme =
      let
        inherit (config.lib.formats.rasi) mkLiteral;
      in
      {
        "window" = {
          width = lib.mkForce "50";
          height = lib.mkForce "50%";
          border = lib.mkForce 2;
          border-color = mkLiteral "#f5c2e7";
          border-radius = 15;
        };
        "prompt" = {
          border-radius = 15;
          background-color = mkLiteral "#f5c2e7";
          margin = 10;
          vertical-align = mkLiteral "0.5";
          horizontal-align = mkLiteral "0.5";
        };
        "entry" = {
          border = lib.mkForce 2;
          border-color = mkLiteral "#f5c2e7";
          border-radius = 15;
          text-color = mkLiteral "#f5c2e7";
          margin = 10;
        };
        "textbox" = {
          text-color = mkLiteral "#f5c2e7";
        };
        "element selected" = {
          text-color = mkLiteral "#f5c2e7";
          border = lib.mkForce 2;
          border-color = mkLiteral "#f5c2e7";
          border-radius = 15;
        };
        "listview" = {
          margin = 10;
        };
      };
  };
}
