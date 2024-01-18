{ config, lib, pkgs, ... }: {
  environment.systemPackages = with pkgs; [ alsa-utils greetd.tuigreet ];

  # Greeter 
  services.greetd = {
    enable = true;
    restart = false;
    settings = {
      default_session = {
        command =
          "tuigreet --cmd 'dbus-run-session sway' -t -r --asterisks -g 'welcome to the garden'";
      };
    };
  };

  # SwayFX
  programs.sway = {
    enable = true;
    package = (pkgs.swayfx.overrideAttrs
      (old: { passthru.providedSessions = [ "sway" ]; }));
    wrapperFeatures.gtk = true;
  };
  programs.xwayland.enable = true;
  services.dbus.enable = true;
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    xdgOpenUsePortal = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk pkgs.xdg-desktop-portal-wlr ];
    config = { common.default = [ "gtk" "wlr" ]; };
  };

  # Audio
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
    wireplumber.enable = true;
  };
}
