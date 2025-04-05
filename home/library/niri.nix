{ pkgs, ... }: {
  xdg.configFile."niri".source = ../files/niri;
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
    xwayland-satellite
  ];
}
