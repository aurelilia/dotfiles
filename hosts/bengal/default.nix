{ ... }:
{
  imports = [
    ./backup.nix
    ./disko.nix
    ./hardware.nix
  ];

  # Separate Swap partition
  boot.zfs = {
    allowHibernation = true;
    forceImportRoot = false;
  };

  # Sway config
  feline.gui = {
    autoSuspend = true;
    extraSway = {
      output = {
        "eDP-1" = {
          resolution = "2560x1440";
          scale = "1.25";
          position = "3840 0";
        };
        DP-5 = {
          resolution = "2560x1440";
          transform = "90";
        };
        DP-1 = {
          resolution = "3840x2160";
          position = "0 0";
          scale = "1.5";
        };
        DP-6 = {
          resolution = "3840x2160";
          position = "0 0";
          scale = "1.5";
        };
      };

      workspaceOutputAssign = [
        {
          output = "DP-1";
          workspace = "1";
        }
        {
          output = "DP-1";
          workspace = "3";
        }
        {
          output = "eDP-1";
          workspace = "10";
        }
      ];

    };
  };
}
