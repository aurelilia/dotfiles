{
  config,
  pkgs,
  pkgs-unstable,
  lib,
  ...
}:
{
  config = lib.mkIf (config.feline.gui.enable) {
    environment.systemPackages = with pkgs; [
      tuigreet
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
        pkgs.xdg-desktop-portal-gtk
      ];
      config.common.default = "gnome";
    };
    services.gnome.gnome-keyring.enable = true;

    # Audio
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      pulse.enable = true;
      wireplumber = {
        enable = true;
        extraConfig = {
          # I want always HQ LDAC
          "ldac-hq"."monitor.bluez.rules" = [
            {
              matches = [ { "device.name" = "~bluez_card.*"; } ];
              actions.update-props."bluez5.a2dp.ldac.quality" = "hq";
            }
          ];
          "alsa-headroom"."monitor.alsa.rules" = [
            {
              matches = [ { "node.name" = "alsa_output.*"; } ];
              actions.update-props."api.alsa.headroom" = 1024;
            }
          ];
        };
      };
      extraConfig = {
        pipewire."99-quantum.conf" = {
          "context.properties" = {
            "default.clock.rate" = 48000;
            "default.clock.quantum" = 1024;
            "default.clock.min-quantum" = 128;
            "default.clock.max-quantum" = 2048;
          };
        };
        pipewire."99-rt.conf" = {
          "context.modules" = [
            {
              name = "libpipewire-module-rt";
              args = {
                "nice.level" = -11;
                "rt.prio" = 19;
              };
            }
          ];
        };
      };
    };
    # https://cmm.github.io/soapbox/the-year-of-linux-on-the-desktop.html
    users.users.leela.extraGroups = [
      "audio"
      "rtkit"
    ];
    security.pam.loginLimits = [
      {
        domain = "@audio";
        type = "-";
        item = "rtprio";
        value = "90";
      }
    ];
    services.udev.extraRules = ''
      DEVPATH=="/devices/virtual/misc/cpu_dma_latency", OWNER="root", GROUP="audio", MODE="0660"
      DEVPATH=="/devices/virtual/misc/hpet", OWNER="root", GROUP="audio", MODE="0660"
    '';
    security.rtkit.enable = true;

    # Plymouth + threadirqs
    boot = {
      kernelParams = [
        "threadirqs"
        "quiet"
      ];
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
