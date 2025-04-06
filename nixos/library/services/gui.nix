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
        default_session.command = "tuigreet --cmd 'niri-session' -t -r --asterisks -g 'welcome to the garden'";
        initial_session = {
          user = "leela";
          command = "niri-session";
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

    # Niri
    programs.niri.enable = true;

    # Portal
    xdg.portal = {
      enable = false;
      wlr.enable = lib.mkForce false;
      extraPortals = [ pkgs.xdg-desktop-portal-gnome ];
      configPackages = [ pkgs.niri ];
    };
    services.gnome.gnome-keyring.enable = true;

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
    lib.pkgs-unstable = pkgs-unstable;
    lib.nixgl = nixgl;
  };

  options.feline.gui = {
    enable = lib.mkEnableOption "GUI";
    autoSuspend = lib.mkEnableOption "automatic suspend on idle";

    extraSway = lib.mkOption {
      type = lib.types.attrs;
      description = "Configuration to add to Sway.";
      default = { };
    };
    extraNiri = lib.mkOption {
      type = lib.types.str;
      description = "Configuration to add to Niri.";
      default = { };
    };
  };
}
