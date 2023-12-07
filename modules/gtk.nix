{ config, pkgs, ... }:
{
  gtk = {
    enable = true;
    gtk2.configLocation = "${config.xdg.configHome}/gtk-2.0/gtkrc";
        
    theme = {
      name = "Catppuccin-Mocha-Standard-Maroon-Dark";
      package = pkgs.catppuccin-gtk.override {
        accents = [ "maroon" ];
        tweaks = [ "rimless" ];
        variant = "mocha";
      };
    };
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.catppuccin-papirus-folders.override {
          accent = "maroon";
          flavor = "mocha";
      };
    };
    cursorTheme = {
      package = pkgs.catppuccin-cursors.mochaMaroon;
      name = "Catppuccin-Mocha-Maroon-Cursors";
    };

    font = {
      package = pkgs.noto-fonts;
      name = "Noto Sans Regular";
      size = 10;
    };

    gtk3 = {
      bookmarks = [
        "file:///home/leela/personal/images/screenshots"
        "file:///home/leela/personal"
        "file:///home/leela/misc"
        "file:///ethereal"
        "file:///mnt"
      ];

      extraConfig."gtk-application-prefer-dark-theme" = true;
      extraCss = ''
        .horizontal>separator {
          border: 1px solid #1a1823;
        }

        .thunar .standard-view.frame {
            border-style: none;
        }

        .thunar .sidebar {
            background-color: #1a1823;
        }

        .thunar .sidebar .view {
            color: #F9F9F9;
            background: transparent;
        }

        .thunar .sidebar .view:not(:selected) {
            background-color: transparent;
        }

        .thunar statusbar {
            margin: 0 -10px;
            padding: 0 4px;
            border-top: 1px solid rgba(0, 0, 0, 0);
        }
      '';
    };
  };

  systemd.user.sessionVariables = {
    GTK_THEME = "Catppuccin-Mocha-Standard-Maroon-Dark";
    QT_QPA_PLATFORMTHEME = "gtk2";
  };
  home.packages = [ pkgs.libsForQt5.qtstyleplugins ];
}
