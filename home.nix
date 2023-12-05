let
  guiImports = [
    ./modules/alacritty.nix
    ./modules/eww.nix
    ./modules/gtk.nix
    ./modules/sway.nix
    ./modules/vscode.nix
    ./modules/xdg.nix
  ];
in
{
  "hazyboi" = { config, lib, pkgs, ... }: {
    dots.kind = "desktop";
    dots.base = "arch";

    nixpkgs.config.allowUnfreePredicate = _: true;
    home.packages = with pkgs; [
      # Scanner tomfoolery
      gnome.simple-scan
      epkowa
    ];

    imports = [ ./main.nix ] ++ guiImports;
  };
}