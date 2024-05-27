{ lib, config, ... }:
{
  config.catppuccin = lib.mkIf config.feline.theme.enable {
    enable = true;
    flavor = "mocha";
    accent = "red";
  };

  options.feline.theme.enable = lib.mkEnableOption "Catppuccin theme";
}
