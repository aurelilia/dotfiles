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
      wineWowPackages.waylandFull
    ];

    # Greeter 
    services.greetd = {
      enable = true;
      restart = false;
      settings = {
        default_session.command = "tuigreet --cmd 'dbus-run-session sway' -t -r --asterisks -g 'welcome to the garden'";
        initial_session = {
          user = "leela";
          command = "dbus-run-session sway";
        };
      };
    };

    # SwayFX
    programs.sway = {
      enable = true;
      package = pkgs.swayfx.overrideAttrs (old: {
        passthru.providedSessions = [ "sway" ];
      });
      wrapperFeatures.gtk = true;
    };
    programs.xwayland.enable = true;
    services.dbus.enable = true;
    xdg.portal = {
      enable = true;
      wlr.enable = true;
      xdgOpenUsePortal = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-gtk
        xdg-desktop-portal-wlr
      ];
      config.common.default = [
        "gtk"
        "wlr"
      ];
    };

    # Audio
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      pulse.enable = true;
      wireplumber.enable = true;
    };

    # Plymouth
    boot = {
      kernelParams = [ "quiet" ];
      initrd.systemd.enable = true;
      plymouth = {
        enable = true;
        theme = "breeze";
      };
    };

    # Misc.
    services.gvfs.enable = true;
    lib.pkgs-unstable = pkgs-unstable;
    lib.nixgl = nixgl;
  };

  options.feline.gui.enable = lib.mkEnableOption "GUI";
}
