{
  lib,
  config,
  catppuccin,
  pkgs,
  ...
}:
{
  config.catppuccin = lib.mkIf config.feline.theme.enable {
    enable = true;
    flavor = "mocha";
    accent = "red";

    sources = catppuccin.packages.${pkgs.stdenv.hostPlatform.system}.overrideScope (
      final: prev: {
        whiskers = pkgs.catppuccin-whiskers;
      }
    );
  };

  options.feline.theme.enable = lib.mkEnableOption "Catppuccin theme";
}
