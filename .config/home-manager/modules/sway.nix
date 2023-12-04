{ config, pkgs, ... }:
{
  wayland.windowManager.sway = {
    enable = false; # todo: sway itself
  };

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
}
