{ config, lib, pkgs, ... }:
{
  imports = [
    ./modules/alacritty.nix
    ./modules/eww.nix
    ./modules/gtk.nix
    ./modules/sway.nix
    ./modules/vscode.nix
    ./modules/xdg.nix
  ];
}