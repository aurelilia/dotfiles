{ config, pkgs, ... }:
{
  gtk = {
    enable = true;
    gtk2.configLocation = "${config.xdg.configHome}/gtk-2.0/gtkrc";
        
    theme = {
      name = "Catppuccin-Mocha-Compact-Maroon-Dark";
      package = pkgs.catppuccin-gtk.override {
        accents = [ "maroon" ];
        size = "compact";
        tweaks = [ "rimless" "black" ];
        variant = "mocha";
      };
    };
    iconTheme = {
      package = pkgs.papirus-icon-theme;
      name = "Papirus-dark";
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
}
