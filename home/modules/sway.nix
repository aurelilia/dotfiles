let
  mkScript = content: {
    text = ''
      #!/bin/sh
      ${content}'';
    executable = true;
  };
in { config, pkgs, lib, ... }: {
  # Sway itself. Package is managed either by Arch or NixOS
  wayland.windowManager.sway = {
    enable = true;
    package = null;
  };

  xdg.configFile."sway/config".source = lib.mkForce ../files/sway/config;
  xdg.configFile."sway/autostart.sh".source = ../files/sway/autostart.sh;
  xdg.configFile."sway/scripts".source = ../files/sway/scripts;

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
      grace = "5";
      fade-in = "0.2";
      color = "00000000";
      inside-color = "1e1e2e";
      inside-clear-color = "1e1e2e";
      inside-ver-color = "1e1e2e";
      inside-wrong-color = "1e1e2e";
      line-color = "11111b";
      line-ver-color = "11111b";
      line-clear-color = "11111b";
      line-wrong-color = "11111b";
      ring-color = "cba6f7";
      ring-clear-color = "cba6f7";
      ring-ver-color = "cba6f7";
      ring-wrong-color = "f38ba8";
      separator-color = "00000000";
      text-color = "cdd6f4";
      text-clear-color = "cdd6f4";
      text-ver-color = "cdd6f4";
      text-wrong-color = "f38ba8";
    };
  };

  # Swayidle
  services.swayidle = {
    enable = true;
    timeouts = [
      {
        timeout = 300;
        command = "${pkgs.swaylock-effects}/bin/swaylock";
      }
      {
        timeout = 360;
        command = "${pkgs.swayfx}/bin/swaymsg output '*' dpms off";
        resumeCommand =
          "${pkgs.swayfx}/bin/swaymsg output '*' dpms on && ~/.config/eww/init.sh";
      }
    ];
  };

  # Dunst
  services.dunst = {
    enable = true;
    configFile = "$XDG_CONFIG_HOME/dunstrc";
  };
  xdg.configFile."dunstrc".source = ../files/dunstrc;

  # Misc services
  # Ulauncher tries to open themes RW (?!?!) which obviously does not work
  # with the store, so we link it's files directly out of this repo.
  # https://github.com/nix-community/home-manager/issues/257
  home.activation.linkUlauncher = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    ln -sf $HOME/git/public/dotfiles/home/files/ulauncher $HOME/.config/ulauncher
  '';

  # Session variables
  systemd.user.sessionVariables = {
    MOZ_ENABLE_WAYLAND = 1;
    _JAVA_AWT_WM_NONREPARENTING = 1;

    XCURSOR_THEME = "Catppuchin-Mocha-Maroon";
    XCURSOR_SIZE = 24;
    WAYLAND_DISPLAY = "wayland-1"; # swayidle fails to connect without this
    XDG_CURRENT_DESKTOP = "sway";
  };

  # Packages
  home.packages = with pkgs; [
    autotiling-rs
    grim
    jq
    inetutils
    slurp
    sway-audio-idle-inhibit
    wl-clipboard
    ydotool
    ripgrep
    libnotify
    playerctl
    swww
    ulauncher
    (python3.withPackages
      (ps: with ps; [ requests pint simpleeval parsedatetime pytz ]))
  ];
}
