{ config, pkgs, ... }:
{
  gtk = {
    enable = true;
    theme.name = "Catppuccin-Mocha-Standard-Red-Dark";
    cursorTheme.name = "Catppuccin-Mocha-Mauve-Cursors";

    iconTheme = {
      package = pkgs.papirus-icon-theme;
      name = "Papirus-dark";
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

  dconf.settings = {
    "org/gnome/desktop/interface" = {
      gtk-theme = "Catppuccin-Mocha-Standard-Red-Dark";
      icon-theme = "Papirus-dark";
      cursor-theme = "Catppuccin-Mocha-Mauve-Cursors";
    };
  };
}
