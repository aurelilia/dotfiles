{ config, pkgs, ... }:
{
  # TODO switch to a systemd distro lol
  home.file.".config/sway".source = ../files/sway;
  home.file.".config/swayidle".source = ../files/swayidle;

  services.swayidle = {
    enable = true;
    timeouts = [
      { timeout = 300; command = "~/.config/sway/scripts/lock.sh"; }
      { timeout = 360; command = "swaymsg 'output * dpms off'"; resumeCommand = "swaymsg 'output * dpms on' && ~/.config/eww/init.sh"; }
    ];
  };

  services.dunst = {
    enable = true;
    configFile = "$XDG_CONFIG_HOME/dunstrc";
  };
  home.file.".config/dunstrc".source = ../files/dunstrc;

  home.sessionVariables = {
    QT_QPA_PLATFORMTHEME = "gtk2";
    MOZ_ENABLE_WAYLAND = 1;
    _JAVA_AWT_WM_NONREPARENTING = 1;

    XCURSOR_THEME = "Catppuchin-Mocha-Mauve";
    XCURSOR_SIZE = 24;
    XDG_CURRENT_DESKTOP = "sway";
  };
}
