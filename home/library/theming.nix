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

  catppuccin.gtk.icon.enable = true;
  gtk = {
    enable = true;
    gtk2.configLocation = "${config.xdg.configHome}/gtk-2.0/gtkrc";

    font = {
      package = pkgs.noto-fonts;
      name = "Noto Sans Regular";
      size = 10;
    };

    theme = {
      #name = "catppuccin-${theme.flavor}-${theme.accent}-standard";
      name = "Catppuccin-GTK-Red-Dark";
      package = (
        pkgs.magnetic-catppuccin-gtk.override {
          shade = "dark";
          accent = [ theme.accent ];
        }
      );
    };

    cursorTheme = {
      package = cursor-package;
      name = cursor-theme;
      size = config.home.pointerCursor.size;
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
