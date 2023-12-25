{ pkgs, ... }: {
  imports = [ ./workstation.nix ];

  home.packages = with pkgs; [
    firefox
    thunderbird
    obs-studio
    alacritty
    dejavu_fonts
  ];
}
