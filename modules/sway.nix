{ config, pkgs, ... }:
{
  wayland.windowManager.sway = {
    enable = true;
    package = (pkgs.wrapWithNixGL pkgs.swayfx);
  };
  # TODO port config
  home.file.".config/sway".source = ../files/sway;

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

  # Misc services
  # Syncthing
  services.syncthing.enable = true;

  home.sessionVariables = {
    QT_QPA_PLATFORMTHEME = "gtk2";
    MOZ_ENABLE_WAYLAND = 1;
    _JAVA_AWT_WM_NONREPARENTING = 1;

    XCURSOR_THEME = "Catppuchin-Mocha-Mauve";
    XCURSOR_SIZE = 24;
  };

  home.packages = with pkgs; [
    sway-audio-idle-inhibit
    autotiling-rs
    ydotool
  ];
}
