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
  services.syncthing.enable = true;

  home.sessionVariables = {
    MOZ_ENABLE_WAYLAND = 1;
    _JAVA_AWT_WM_NONREPARENTING = 1;
  };

  home.packages = with pkgs; [
    autotiling-rs
    grim
    jq
    inetutils
    slurp
    sway-audio-idle-inhibit
    swaylock-effects
    wl-clipboard
    xdg-desktop-portal-wlr
    ydotool
    ripgrep
  ];
}
