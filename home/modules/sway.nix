{ config, pkgs, lib, ... }: {
  # Sway itself. Package is managed either by Arch or NixOS
  wayland.windowManager.sway = {
    enable = true;
    package = null;
  };
  xdg.configFile."sway".source = ../files/sway;

  # Swayidle
  services.swayidle = {
    enable = true;
    timeouts = [
      {
        timeout = 300;
        command = "~/.config/sway/scripts/lock.sh";
      }
      {
        timeout = 360;
        command = "swaymsg output '*' dpms off";
        resumeCommand = "swaymsg output '*' dpms on && ~/.config/eww/init.sh";
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
  services.syncthing.enable = true;
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
    swaylock-effects
    wl-clipboard
    ydotool
    ripgrep
    libnotify
    playerctl
    ulauncher
    (python3.withPackages
      (ps: with ps; [ requests pint simpleeval parsedatetime pytz ]))
  ];
}
