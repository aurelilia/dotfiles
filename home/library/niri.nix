{
  pkgs,
  lib,
  config,
  nixosConfig,
  ...
}:
{
  xdg.configFile."niri/config.kdl".text =
    (lib.readFile ../files/niri-config.kdl) + nixosConfig.feline.gui.extraNiri;
  xdg.configFile."niri/scripts".source = ../files/niri-scripts;

  # Swayidle
  services.swayidle =
    let
      lock = "'${config.programs.swaylock.package}/bin/swaylock'";
    in
    {
      enable = true;
      events = [
        {
          event = "before-sleep";
          command = lock;
        }
        {
          event = "lock";
          command = lock;
        }
      ];
      timeouts =
        [
          {
            timeout = 300;
            command = lock;
          }
          {
            timeout = 360;
            command = "'${pkgs.niri}/bin/niri msg action power-off-monitors";
          }
        ]
        ++ lib.optional (nixosConfig.feline.gui.autoSuspend) {
          timeout = 600;
          command = "'${pkgs.systemd}/bin/systemctl suspend-then-hibernate'";
        };
    };
  systemd.user.services.swayidle.Service.Environment = [ "WAYLAND_DISPLAY=wayland-1" ];

  # Swaylock
  programs.swaylock = {
    enable = true;
    package = pkgs.swaylock-effects;
    settings = {
      screenshots = true;
      clock = true;
      indicator = true;
      indicator-radius = "200";
      indicator-thickness = "20";
      effect-blur = "8x5";
      effect-vignette = "0.5:0.5";
      effect-greyscale = true;
      grace = "0";
      fade-in = "0.2";
    };
  };

  # Polkit
  systemd.user.services.polkit-gnome-authentication-agent-1 = {
    Unit = {
      Description = "polkit-gnome-authentication-agent-1";
      Wants = [ "graphical-session.target" ];
      After = [ "graphical-session.target" ];
    };
    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
    Service = {
      Type = "simple";
      ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
      Restart = "on-failure";
      RestartSec = 1;
      TimeoutStopSec = 10;
    };
  };

  home.packages = with pkgs; [
    grim
    jq
    inetutils
    slurp
    wl-clipboard
    ydotool
    ripgrep
    libnotify
    swww
    alsa-utils
    catppuccin-cursors.mochaRed
    nixosConfig.lib.pkgs-unstable.xwayland-satellite
  ];
}
