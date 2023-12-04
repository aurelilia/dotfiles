{ config, pkgs, ... }:
{
  home.username = "leela";
  home.homeDirectory = "/home/leela";
  home.stateVersion = "23.11";

  home.file.".local/bin".source = files/bin;
  home.sessionVariables = {
    PATH = "$HOME/.local/bin:$HOME/.cargo/bin:$PATH";
  };

  programs.home-manager.enable = true;
  targets.genericLinux.enable = true;

  imports = [
    ./modules/bat.nix
    ./modules/git.nix
    ./modules/lsd.nix
    ./modules/micro.nix
    ./modules/ssh.nix
    ./modules/starship.nix
    ./modules/zsh.nix

    ./modules/alacritty.nix
    ./modules/eww.nix
    ./modules/gtk.nix
    ./modules/sway.nix
    ./modules/xdg.nix
  ];
}
