{ pkgs, nixosConfig, ... }:
{
  xdg.configFile."noctalia/colors.json".source = ../files/noctalia/colors.json;
  xdg.configFile."noctalia/plugins.json".source = ../files/noctalia/plugins.json;
  xdg.configFile."noctalia/settings.json".source = ../files/noctalia/settings.json;

  home.packages = with pkgs; [
    nixosConfig.lib.pkgs-unstable.noctalia-shell
    nixosConfig.lib.pkgs-unstable.quickshell
    gpu-screen-recorder
    wlsunset
    pywalfox-native
  ];
}
