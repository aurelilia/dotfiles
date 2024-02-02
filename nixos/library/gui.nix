{
  config,
  pkgs,
  pkgs-unstable,
  lib,
  ...
}:
let
  # Thank you, piegames!
  # https://git.darmstadt.ccc.de/piegames/home-config/-/blob/master/main.nix?ref_type=heads 
  wrapWithNixGL =
    package:
    let
      binFiles = lib.pipe "${lib.getBin package}/bin" [
        builtins.readDir
        builtins.attrNames
        (builtins.filter (n: builtins.match "^\\..*" n == null))
      ];
      wrapBin =
        name:
        pkgs-unstable.writeShellScriptBin name ''
          exec ${pkgs-unstable.nixgl.nixGLIntel}/bin/nixGLIntel ${package}/bin/${name} "$@"
        '';
    in
    pkgs-unstable.symlinkJoin {
      name = "${package.name}-nixgl";
      paths = (map wrapBin binFiles) ++ [ package ];
    };
in
{
  config = lib.mkIf (config.elia.graphical) {
    environment.systemPackages = with pkgs; [
      alsa-utils
      greetd.tuigreet
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
      package = pkgs.swayfx.overrideAttrs (old: { passthru.providedSessions = [ "sway" ]; });
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
    virtualisation.docker.enable = true;

    # (Graphical) packages I want from unstable, whose version in stable is too outdated
    lib.pkgs-unstable = pkgs-unstable;
    users.users.leela.packages = with pkgs-unstable; [ (wrapWithNixGL logseq) ];
  };

  options = {
    elia.graphical = lib.mkOption {
      type = lib.types.bool;
      description = "If a graphical shell is to be installed.";
      default = config.elia.systemType == "workstation";
    };
  };
}
