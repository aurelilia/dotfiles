{
  config,
  pkgs,
  pkgs-unstable,
  nixgl,
  lib,
  ...
}:
{
  config = lib.mkIf (config.feline.gui.enable) {
    environment.systemPackages = with pkgs; [
      greetd.tuigreet
      lutris-free
    ];

    # Greeter
    services.greetd = {
      enable = true;
      restart = false;
      settings = {
        default_session.command = "tuigreet --cmd 'niri-session' -t -r --asterisks -g 'welcome to the cat nest'";
        initial_session = {
          user = "leela";
          command = "niri-session";
        };
      };
    };

    # Niri
    programs.niri.enable = true;
    services.dbus.enable = true;

    # Keyboard permissions
    security.sudo.extraConfig = ''
      %leela ALL= NOPASSWD: /run/current-system/sw/bin/systemctl start keyd
      %leela ALL= NOPASSWD: /run/current-system/sw/bin/systemctl stop keyd
    '';

    # Portal
    xdg.portal = {
      enable = true;
      extraPortals = [
        pkgs.xdg-desktop-portal-gnome
        pkgs.xdg-desktop-portal-gtk
      ];
      configPackages = [ pkgs.niri ];
      config.common = {
        "org.freedesktop.impl.portal.FileChooser" = "gtk";
      };
    };
    services.gnome.gnome-keyring.enable = true;

    # Audio
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      pulse.enable = true;
      wireplumber = {
        enable = true;
        # I want always HQ LDAC
        extraConfig."ldac-hq" = {
          "monitor.bluez.rules" = [
            {
              matches = [
                {
                  "device.name" = "~bluez_card.*";
                }
              ];
              actions = {
                update-props = {
                  "bluez5.a2dp.ldac.quality" = "hq";
                };
              };
            }
          ];
        };
      };
    };

    # Plymouth
    boot = {
      kernelParams = [ "quiet" ];
      initrd.systemd.enable = true;
      plymouth.enable = true;
    };

    # Auth
    security.pam.services = {
      login.u2fAuth = true;
      sudo.u2fAuth = true;
    };
    services.pcscd.enable = true;

    # Misc.
    services.gvfs.enable = true;
    programs.nix-ld.enable = true;
    lib.pkgs-unstable = pkgs-unstable;
    lib.nixgl = nixgl;
  };

  options.feline.gui = {
    enable = lib.mkEnableOption "GUI";
    autoSuspend = lib.mkEnableOption "automatic suspend on idle";

    extraNiri = lib.mkOption {
      type = lib.types.str;
      description = "Configuration to add to Niri.";
      default = "";
    };
  };
}
