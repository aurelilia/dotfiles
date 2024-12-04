{ config, pkgs, ... }:
let
  theme = config.catppuccin;
  cursor-theme = "catppuccin-${theme.flavor}-${theme.accent}-cursors";
  cursor-package = pkgs.catppuccin-cursors.mochaRed;
in
{
  home.pointerCursor = {
    name = cursor-theme;
    package = cursor-package;
    size = 24;
    gtk.enable = true;
    x11.enable = true;
  };

  gtk = {
    enable = true;
    catppuccin.enable = true; # TODO find a replacement.
    gtk2.configLocation = "${config.xdg.configHome}/gtk-2.0/gtkrc";

    font = {
      package = pkgs.noto-fonts;
      name = "Noto Sans Regular";
      size = 10;
    };

    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.catppuccin-papirus-folders.override { inherit (theme) accent flavor; };
    };

    cursorTheme = {
      package = cursor-package;
      name = cursor-theme;
    };

    gtk3 = {
      bookmarks = [
        "file:///home/leela/personal/images/screenshots"
        "file:///home/leela/personal"
        "file:///home/leela/git/public"
        "file:///home/leela/misc"
        "file:///ethereal"
        "file:///mnt"
      ];

      extraConfig."gtk-application-prefer-dark-theme" = true;
    };
  };

  systemd.user.sessionVariables = {
    GTK_THEME = config.gtk.theme.name;
    QT_QPA_PLATFORMTHEME = "gtk2";
  };
  home.packages = [ pkgs.libsForQt5.qtstyleplugins ];
}
